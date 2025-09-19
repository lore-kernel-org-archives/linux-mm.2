Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D6BACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A248E000C; Fri, 19 Sep 2025 08:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AA48E0001; Fri, 19 Sep 2025 08:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2778E000C; Fri, 19 Sep 2025 08:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 886BA8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:56:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E3BA140351
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:56:58 +0000 (UTC)
X-FDA: 83905999716.16.458426C
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 793E7A0007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:56:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=roNl18MR;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758286615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sXkyLG6zSpE8Zg8MgpvfJixz+QjhL4EEfTfyfr5+OM=;
	b=YO8J4p8MoT/YOLKwSdMHfO4qwmP+PTN86bUJdkXJSaaPGeVhEKkI/D7Tu0VUtrAfpeI6sI
	npFdty5yvSD2sMXbs8aZh+mKM3zA4KyJuWsfBcnRnCAxe7eoyy3HT9xA+WzCRuOnFpY84B
	hIBuXgGQrk9E4wDl1sGZcglx/VJHezg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=roNl18MR;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758286615; a=rsa-sha256;
	cv=pass;
	b=J/xcVbYlxPtA1/C3uHGXhCBU3jn7NhxDJ1KC+3obQnpu5C11sIsrhK8KvMQCumvScmJwxP
	AzIUFaFgIXy2t+njeL4wWDMg8Nj/P8a88Qj8LfZ4kNcybLNfn0IT2iM66pWpmCcVJbSn/P
	sWRUoFxB5EZQqkWy9kMGQTwQPd4Um6s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXTenyWVrQQVc2A6aXV02weYMXRVAWjeb0eB2+jbGTzBc7ocFy5mLBUeHa/dXKxqaQsbgzgUJ7AaD+IW4Wp7kgPo+DKghvR+KrOTJuaF6aAGqShkyyDORD/BM457EQxoD4nMJuQSU18DefOvOC9vSQ5K3ABmon7FX4obTRjWcxf7mU00NpKiTwtAiGd+i/lUhcieeEjGJOE8atAh+y2Xhdieb4glB9SNuJkg7O0clQqFTfdlKco4IUATbPFZsSn6ARtYfFV/dXwDAt9s9xAbAwEjd3BWy8HNideB4F9sSqU+qA5LYP/N2VD5mBSa652hv5MbiFtjvVnKNyMzskW5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sXkyLG6zSpE8Zg8MgpvfJixz+QjhL4EEfTfyfr5+OM=;
 b=IcPc6oEJaZKIfSaYxwZUgjDGpU6ZRZMmGNoDIbzasdLo9RM0WGupIBB/tlBN38Fc4RZMMsah3IbcfUWN8DpatDLkscvomyLmF7ocwhTmS0xNs99id58q+R/E02s48DBcl6gkn60R45SrFeKCASDQ4FSdEapYcFFNVSzPTQeIAatnD7ijjYfVdk520APBS7VipUthSWFLhrlxILNHRNKZrhb08qthaFYwKTr2syOVtz2yniio5WA9/Ytw1uhyrq/Z6J8E28xgNBBfBgvp/5guSL0l2nl6rCt+Q5HiWCrXhICweuqAdLJ4Z7rEWKSUSWK4zgOuGZs7Q5HNV40MCDpKIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sXkyLG6zSpE8Zg8MgpvfJixz+QjhL4EEfTfyfr5+OM=;
 b=roNl18MRbeyyjjyXYAS+iN+qs6LgxsBLB3CYONnJJqYkzw06LynGhfsp+6vSw2PCE5/eqxPympNHJMdj7EPvGziyc9t8gUvPtVxXLOeZu9LhZ6/vvbcvidYO9iVz9+BetNM2m/kCG9qLZgpKrVDnSU2KlRef4muzVIDTSDcvEW6HHc6/oJyZcokUj22M3EhmXi2ahSXiPkRDZPKx5YhUu0hIYkaFayt/Pj05zx36DOknj85yZn47TnzumZdc0o/3EwjnA6N6+LsKpRA642bHPMDUe7Nny94b9XkE2q1k6SUaTFwCzxYLPnKdCYE5Mzfz+dIvctZpF6+m9oBZPQs+sQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by IA1PR12MB7662.namprd12.prod.outlook.com (2603:10b6:208:425::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Fri, 19 Sep
 2025 12:56:50 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 12:56:50 +0000
Date: Fri, 19 Sep 2025 09:56:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jason Miu <jasonmiu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 1/4] kho: Introduce KHO page table data structures
Message-ID: <20250919125648.GS1391379@nvidia.com>
References: <20250917025019.1585041-1-jasonmiu@google.com>
 <20250917025019.1585041-2-jasonmiu@google.com>
 <20250917122158.GC1086830@nvidia.com>
 <CA+CK2bBbSSyCDAAgThDSSwH0WdOeHz-eVgB-1bdiwsDtTSE5pg@mail.gmail.com>
 <20250917163200.GC1391379@nvidia.com>
 <CAHN2nPK+Z5cvQ_waTWyPZiEoeSc9o7e3YnQLLjRzNzrb7VhAqQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHN2nPK+Z5cvQ_waTWyPZiEoeSc9o7e3YnQLLjRzNzrb7VhAqQ@mail.gmail.com>
X-ClientProxiedBy: BN0PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:408:ee::11) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|IA1PR12MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a716519-2ae3-4775-68f1-08ddf77bffc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qaIJtcENLcfThMaMroqcCIaMUUV3D3bYhUK3k6DODtXRnQuqi575g/CpTnsl?=
 =?us-ascii?Q?mHJUWXJKw8e/BStdFZiB8oIex9wpBN5j5lz6cQ6gnIY5WkBLRpR8Z4v1jZ9U?=
 =?us-ascii?Q?bcpuQmg3kurrSy4wV2ArOL9RdPYvyOzs7lZe2OHBoVz1FjrjM6WA7zhDe3ty?=
 =?us-ascii?Q?KeHGZbrT/4/rvafsq2i6DzzrIwEP2SiZubsIyiqXiFPbIQruF+ecak67NBGp?=
 =?us-ascii?Q?Uki67JpDR42kv740IMTcFXjpq7KTXR219tGTj6F+oZlRR0CYIfdRzP7iTkXP?=
 =?us-ascii?Q?Vlq+WnkAfwOlKSMrzyNFNpYcpfMTRqMJBZML9r9XMTJubPOm+2oQRGGf5nGS?=
 =?us-ascii?Q?R8SVPAmN++XpuzPzOJ10EQAed+PT6wRSa9CJf8dxwUOxOyUzZV++bHJl5iFw?=
 =?us-ascii?Q?kKbzIkuEF2SZCwn7gIaeoPq7Fd7Up8yCVZbagqhousCkJIXLo4iby2lBQZWE?=
 =?us-ascii?Q?u28mum4DmyoWFO6OqthF7jbFo5IABmG38Us+ExBuh2dse/Suf2OncE36v/23?=
 =?us-ascii?Q?9rSMrPFxwNeTUPrsAFUVZsyJiuCCH5Q+g7qMmHE8vRotFpbb7BKWHaGLDkiN?=
 =?us-ascii?Q?0hJHxBFVcyQtr5aWLcQlMdvyaxI/+plLFShJsfXjKCc4hDVuuaUrk6YwhijU?=
 =?us-ascii?Q?a3LnLaICsFrHq9tgmUcKBcnA8uDloUqnu2DNlyQxUBQWnOpl8Lchds401waL?=
 =?us-ascii?Q?2fd77KVrKHR+6GM52L/G9VertQObHAgBybLv6d0ttSKNYS9e4aw5ikkS0PQq?=
 =?us-ascii?Q?4yQ/dGyUiSAz9bDStEp9GU/Q8Eu5cpYSK9pp8qhMV8hb94O+JQMp4FHtF8s9?=
 =?us-ascii?Q?hFsCQVayKgi01Gi2xGLApeaTlffD3tbKy8UMnlnQ1G01LH1uX8xfEMWfm+KB?=
 =?us-ascii?Q?C79GkcEKbnN+n/RL6ah8QrEiFFOqsZd70wHVuzCfJIARHBfLVR3qYTkVmQ2s?=
 =?us-ascii?Q?PARYsFXucjJp7Nyw1IJSxqaiUpvyTTXSskYXbRjdc+Pn54bLXnSJyxV3ykA9?=
 =?us-ascii?Q?qqf0oNWtxfyBCGMCoGXOwke6JTS52hFMs+tyLa/g+AluRmk3OYYRFu0IJf5W?=
 =?us-ascii?Q?/10YcuhTszgBkfCkZnyB5olaVjkP0VBYyf0aaUTpzHvWlKR4xZvvOE8u5svz?=
 =?us-ascii?Q?T8wxEGknfO268050bL4MEeKI9Q46dnu6MzTDJuPGJFxFaOh+m+hIlo9Arcac?=
 =?us-ascii?Q?qus3DyLeU+6qXL7X29kem/mHPssX3Fh4naSd7f7iOB0LKjTHgqhMZ1eIkNhj?=
 =?us-ascii?Q?E2j22Ic7U/kyvs4gp5ovd9DNWf1HG9OnoaoS9ahfoLTbzPJ4FY1a01e/gnHV?=
 =?us-ascii?Q?uGWrysLdqYVbUCBwRW9422pdqdL+CrxCvDfLvfanbX/Ux7LhH67u0TxwXEs7?=
 =?us-ascii?Q?JRSlv54H/2QG9CAPJlkA8PT1RclAcxnvf8YUEwvQ12z4VMcHyzb6Wta1FjQF?=
 =?us-ascii?Q?FqlHXt1HQe4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KoOwwgxlryghWI+9M+Ca3/wpHYiU4RaDBoAHJjmgnt0sbcWFaKQsu8VfVfQG?=
 =?us-ascii?Q?ZgOpSpDa4XbXpWYQhbHv7b/7LVzqWnjllOtmkoREOsH7DPsFj6ZX2Ey5RlQr?=
 =?us-ascii?Q?PkRqbQFQcEhHSawo5HkKF4w0qxAPI3DmT2Pbnh0Bh8fbipH5Dt8bLSu4RPMu?=
 =?us-ascii?Q?/Tce3l2b1hBoAPl9Pw5TGOM7ZZNbFfPwZgvVuX1YXUU2rTKR888dxsNMeNZr?=
 =?us-ascii?Q?0UFj+C/rord8yvga7Uu7jlhOxUgEjJ5GQuoe9AdRroKu0+gyPsmX+Fe+BhPO?=
 =?us-ascii?Q?KtdMhTA9NQwkjOLjJb+d7dJtPzSfmfYjAS2aKFhdn3Kdx2W1rRFOKxe9150+?=
 =?us-ascii?Q?YVl+NXN/eNEpA5TKFqLtoNGao1QqnYu41Fs1XScB6h8RjJu3jhXpktliloo2?=
 =?us-ascii?Q?aNcAc2jTcISEtRMSeJqCyrb+4DnUCplW348jM/dEpO8/G2wSP3aAOrTU1S+I?=
 =?us-ascii?Q?4RSg2fUtuV5PXw2SImMFQXTzLEgXgQxGYpGyDeNseIpZVG+b+k32ywutK8kP?=
 =?us-ascii?Q?L3vmPauvQfUh63BG3f829EZROK4gnvFApD/DekXpt+HGS4KR8zeoCodsd9Zu?=
 =?us-ascii?Q?3UxgsBUzsA1TWDH63vx1oql43xqoz/m09BSoZiAwuCm4e3YobtC7zWbDO0A4?=
 =?us-ascii?Q?vNjX4AtjZgxNrrwiz3rk5JTTRRZY0c2Xn0X3a6xSmi1i24QLYGEtKgZGMLaf?=
 =?us-ascii?Q?c8s0gMZ3OqmURfv8tJE+dnkS3eEtFg47XxycokKvpE4iCTyjtqIPs6PqMV/6?=
 =?us-ascii?Q?dS+QfsIcCdiF8oMnRgipZCl/LB29BaQSuQOa0U8a8v8+3ZJObLGeaqZZ8pro?=
 =?us-ascii?Q?xSwj7bVf3CUyw4z26+mpVoLvsotI9I636i6IDEjH/uSD8TzV/OITTEAj2IXI?=
 =?us-ascii?Q?kO71gqzUnTtxfPxZ8QxaWMnfqUzdhKiCDCKxn3liBV3V7Pvkl/rjAzFdMClY?=
 =?us-ascii?Q?kiGnsTosrhwF7ffGggoNZpqK6ccPAPF/LaR2WMnZBR2MJcO82WziX2NBKDUU?=
 =?us-ascii?Q?sWveDDgUG3v3pEe5hOFoqFh4VAvATf1DNY7JA9bmt+dcIpiDuFKo4R1XrUIJ?=
 =?us-ascii?Q?SiW2Vgd0gB26f4Gf62k/jEkQVYdpPmfKBpVoaZjzNO2U1BmtEbYhfC4VqFRz?=
 =?us-ascii?Q?d4cH9C0VhAyw0z+bmzWsh9XV8Mkt2bHu0B8o/WrDpng0ROqLTYflEAqUBtt/?=
 =?us-ascii?Q?FBLosGQe3iFtf0sRkGznafeIktmrOTAtuCCegjzdssVHjVdUQOD5s4twdzLd?=
 =?us-ascii?Q?6VBorPJ7WZ2RWeRwP0kcXMs081QUjOflwuQm/lauzy0RP3tadB6Z8bxnY3U0?=
 =?us-ascii?Q?P5nOWbGKzzmKInG0nytfhN5t+/oUjHDEJ1wLE9j3F38fC+BNs0TNXtNHweoA?=
 =?us-ascii?Q?uEfVWw3gCXI6wFrGATjy3v/487GxUTscmeaUtcMB2TDZndTf/rsZl1e2CuY9?=
 =?us-ascii?Q?Rzjv1gyNqQS8aMylP9JkOHodhmpER2irj3ezg9EqZAg7rTMgjkJVUPgpK6Yl?=
 =?us-ascii?Q?Y3ng28kn1FtYoI7U5cxMW0gN24WPbo61/RcpLuHlwMwzLsY//ouJTemIW09e?=
 =?us-ascii?Q?e45gTlXvtyx0WWq6nMYSCpzgZenr0b/SESkzVCNN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a716519-2ae3-4775-68f1-08ddf77bffc0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:56:50.2191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5FV3mbMYndknWHVLlL3yIXRhxk2bumqw4wrZuljx48M6JZ0iP8Mtd/qYtao5pwF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7662
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 793E7A0007
X-Stat-Signature: e4xw51wuk1h9f47cj1u5oqsh6nm1rkic
X-HE-Tag: 1758286615-241187
X-HE-Meta: U2FsdGVkX19HRpjnSUA0k/2sZS0bxy7nBCoXEy02GCq0xB+1UueB+hE1G2TX7bFJgFPrD4f1vRHCCHDQsY76I6AkEw9FnIOzr9zXTUNnnBU+MINai44MZRBdI4MKUA65Vyx+NEpIFpLpOcSemwoBl4KFCRgD3D0i+giqMlwl6PWZC7QMGFm8ZszgVZIewZMxy1n4HZuZ1V8VtKW4v9d7e1nV/VUPIS9VgcfXdz7bto/CyZaQoq2/c/L3MjxidIS5Mt5G09g9H38HqNpqgMWDBMJaqqmdJU3u3rKm6OMUaYLRyAXi8UDBW/zegFijT4Inp1+Moj2+uTr/GyUlCo7VhknhIewC6h9c8bDerK4StO6/e6tlSidj0ygCNK9ppnOaPQBXY/d1CYhR1VphQKbZtcZjc/rwKzXX7t9kr4oK3WR6svjAPlbHSQnRZg3FvG/C3Ck0K125HIkxrfW73vJZyNpMNeIlfr8Xzk/Mimxx6Z1PAJrY4rBMHS0KL7ZvP21ipgZMSVwRNaGSSWVUd3EQTt7hQ0cgC6sON3H9PN/b3A96nb4YTQqGj8ktWxz/KYL74pIqpxs55o6KZoaRMWXL6IVCvT/60h0pRzw99qLLkqsmm3BSGCe4kOREuRRzmvFdYuQu+ivTYFk0zAGDOOSmUndMygATJwCxN5Z4VkTZq+QQ6WBRIF3doSkmJYYec0VFQadUVl+S02dpWd4dX4S325/xrPOm9oB/CEmcbUVtOPhuFPsY2YTNIQuE7yY/wMgLS1FWl8eOHB/220zGZnBlutxRwFeupW93T/3XCHSFZSBXYvMraMFZ9rI8CxDf2eAnj+5vad5HC/df/dB/6uFzm8NVzBifTVukAtMJ8ZuNF+1/3KFV5twsN6xSy3eYTAPnV+Kej4e4kV/2JwO9/HCTfEd/hWsdSf+lqXkntyCjh0Ig7/YtcxH8m3J4h6YCy9kBxrr4eapbQA0H9Qzlf1A
 gTQcWz03
 6N0KJxxUqv0qC4RqSrKSdxhfmd9qaqtAqfkuAvoQCnGhnBO7gcwq27Pq61xOTB02rquwh+w4cUPEx8ig+IjU+CchvQIf97sUJRpowKYd+NxNn3U2Ci3wcC2ImenoENcJHnCGRhxczxSOFPTP9cEBW17k0SR7VpOsZd2+Zhw5FnuTWN9/lizzvQf3L1KzSetiZzcxp/ldb0Ppqd7hNwa1AetcObpx6pcy5ZlZ7iLNQRJ3/4XGEdRjgAG+ELz7p1+p+R1TdNPvaWtaT93VCdF30H+NiiOy9OMdSPtUjQgRDzKFNSiBLm89sSWCKkAFR4KKG98zBH+zzPY5gJp8SOgW8fBvwcTId/RjI+42TZvVOBR5AoGPRpKCHbA0wIhp1JZc5bp/VeA/lT18j+2mz6fOn7yXuWTllZAb3o0niynffjvgdTJljuHPWFwYnZ7vfabedFpvcCe6dZCdoZyEb85gMJTMY85z9sCJQ96kuAgqfCYjlPhYNnjiTdxejyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   1. Find the `start_level` from the `target_order`. (for example,
> target_order = 10, start_level = 4)
>   2. The path from the root down to the level above `start_level` is
> fixed (index 0 at each of these levels).
>   3. At `start_level`, the index is also fixed, by (1 << (63 -
> PAGE_SHIFT - order)) in a 9 bit slice.
>   4. Then, for all levels *below* `order_level`, the walker iterates
> through all 512 table entries, until the bitmap level.

You don't need any special logic like that, that is my point, the
whole thing is very simple:

static int get_index(unsigned int level, u64 pos)
{
	return (pos / (level * ITEMS_PER_TABLE * ITEMS_PER_BITMAP)) %
	       ITEMS_PER_TABLE;
}

walk_table(u64 *table, unsigned int level, u64 start, u64 last)
{
	unsigned int index = get_index(level, start);
	unsigned int last_index = get_index(level, last);

	do {
		if (table[index]) {
			u64 *next_table = phys_to_virt(table[index]);

			if (level == 1)
				walk_bitmap(next_table);
			else
				walk_table(next_table, level - 1, start, last);
		}
		index++;
	} while (index <= last_index);
}

insert_table(u64 *table, unsigned int level, u64 pos)
{
	unsigned int index = get_index(level, start);
	u64 *next_table;

	if (!table[index]) {
		// allocate table[index]
	}
	else
		next_table = phys_to_virt(table[index]);
	if (level == 1)
		insert_bitmap(next_table, pos);
	else
		insert_table(next_table, level - 1, pos);
}

That's it.. No special cases requried.

The above is very limited, it only works with certain formulations
of start/last:
   start has only one bit set
   start & last == true,
   last ^ start has bits 0 -> N set N > log2(ITEMS_PER_BITMAP)

Which align to my suggestion for encoding.

Jason


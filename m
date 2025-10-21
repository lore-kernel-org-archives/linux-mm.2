Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99602CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBDD8E0003; Tue, 21 Oct 2025 13:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CB28E0002; Tue, 21 Oct 2025 13:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CBC8E0003; Tue, 21 Oct 2025 13:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC04C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:11:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5763513B6E2
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:11:15 +0000 (UTC)
X-FDA: 84022762110.15.2559414
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 754202000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:11:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jN1yTmFO;
	spf=pass (imf13.hostedemail.com: domain of ira.weiny@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761066671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hM8c7GvWydfBUBCRMQsusjf6EZhc6yHKRSd2RWaiEGQ=;
	b=OmkcQI0LpGmRvh93qKMPYfnhsGl1BipvEMstEupoyiGhPt6aqwNiODX77a95zk7UMyCDm9
	RDyiyqeM7jZ62fiWWX9ARJyVhqWe0mOF+3DipclJvg47KfYbZuJAH+uFRkMV3nB/ZBKhSW
	MZs+/HtwPhT8zgGkliGK/KSimnLXk4E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jN1yTmFO;
	spf=pass (imf13.hostedemail.com: domain of ira.weiny@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761066671; a=rsa-sha256;
	cv=fail;
	b=gC+xtirdSTCyTp1lTyG15bvwT9A+O6+tHTs6HUVwgJRxyQOQBoUTRmEE0No18BVw8qTEyS
	Rm8TV/2rb6bZ0hA2pg837+STtEGxbUSkMZ4R9o/H81yqnQeMyi4qRUmDqgAUQnd/i4v2iu
	skrZu9kC+l3U09WKxKX4d5Ep3Aka0WU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761066672; x=1792602672;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3NkFn1RlEEpF+8IAOp4EMxb7JC1QKl15922XQ8MdKqI=;
  b=jN1yTmFO2znvf6JiFp/1pvSKJU9a4M9bcg1WVmeuqSUVe6+Q1tGWBkz/
   YL8AL+fs3Iec5N5koSYMKjeulVwc3/9ypwZkKczVeLtaNpNQHke7i+MzV
   88f8PmaygY+9uuEnKn7bp8JcuAH4KUD995AQRSpiUIxTcONTY0qvanhAM
   TQgxduxbOny8FY0ModS9tno4CUMPs0XWkl0a5VzN4/M+XGg9yfi+hnyWK
   78L4yZv0PQW4y24U0tNnSEpsKrg8fsmSMFBGM6oIWongn2hPAdMEPYgLk
   Is+sQHZ1LJ5LLrJWrUdC54LBnFqUIIYUhuycUGpBDMWKkfvRu4AlmGuV9
   A==;
X-CSE-ConnectionGUID: kuFTdIaCRkmj6NTjS6WUPA==
X-CSE-MsgGUID: Nb1YC7h2SEmDM+pyrWubVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73807245"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="73807245"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:11:10 -0700
X-CSE-ConnectionGUID: dvrXJOj5SbGLuDUi7Njrjw==
X-CSE-MsgGUID: PERtVwRxRSudh91p9ntHYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="183346787"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:11:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:11:08 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 10:11:08 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:11:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4z4GLPqUStkaMhqVcokrQ0M2A9h1mg2dZhN6kn80zu/rW03dtsVzB0rrpP0KzkJB9IhdmdFiiXu9TmgdE5jG+C1s1MmWUIZr2CibeFW/dxM5Pd7x9rqi1N+ancem7V5FFX8X/+NP66uSuShPTcxngQFKWNIzsx5SFFKCftYFmXaU0SfvA4Xjw4O7kv9ELO6HAfb246krjfz6oOGzp2jPded9zPfmEOvsR6Sbuh6q5aPxomhn5Zeam1sX52nfTJqR2dZpzAuCO0G45gpSJ4ScPei7bRElp6MaLmbaVnNDpoN3GyFErGAhBvpfDiv39P9auNnztyuEXGfPiK0q1rZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hM8c7GvWydfBUBCRMQsusjf6EZhc6yHKRSd2RWaiEGQ=;
 b=mGLVX/esOw0pfsVmHE2aRN2qOd5NMJhoiv+KHUNOuowRQa5wrD73kJSNZSBpEYHST1KQWYpB8TVOUwH95pgNOVgeMbciyoLrCiT+AInYtXS/qKdN0ZSB4ahr40QjQOG0AC5p7VfajUWUCb4HUBHBSpcX8+fFdLDJWkkxovekEDXT6cnky7j2ncQFJNOEgusac9NG1enbjtxlcN42SIQ4CbGAFpsiMIpbYaiyr34+HRvo5cRRR26e1daWSyCrkeXvWAfhSY+XYXFtDkCSLzqL/fhQ8NFtujOh6+qJgEkmoD4HXH1i4iC3FRzPKGeVLaqEOyVlnOKhedVztk89KOlf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH8PR11MB9457.namprd11.prod.outlook.com
 (2603:10b6:610:2c3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 17:11:06 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 17:11:06 +0000
Date: Tue, 21 Oct 2025 12:13:17 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Message-ID: <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251021102327.199099-3-ankita@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH8PR11MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: 1926bcfd-dc79-4bec-0036-08de10c4d22d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iJANH6ASxftG0IXMs/cy0rJ9wtnrCt9112VQjPJs6oRdkUb5wVqOqS+lwRf5?=
 =?us-ascii?Q?gsWAANjmrxilvRyzCa6D0ERFhP1qFSyX6BjYVMPmIZCw5GD+spDkCPFe24O1?=
 =?us-ascii?Q?0BABnoL0GbPBRXOuxkRACyIeLHHBsOz6ra9OGX8poFKlNsa86nya4R5oP6kJ?=
 =?us-ascii?Q?YeYOMj9ccDVtP4rcLFYHOzUJBQ/GwPzMrU6YybqcZrdpMsju0UVMWm5uqPiW?=
 =?us-ascii?Q?pM4xMwOvZa8n6Gwuf5d9atQgRMZb1ot722wiaSeicHO/C5LiRNWbwy9SkLrC?=
 =?us-ascii?Q?KV6lt57RQ52XzZ3kdiovb9ibPz82Fy09NbmOp8Re86NBebmt67LQEftPliWG?=
 =?us-ascii?Q?qCsvonDLA+OKt0PF+D9PYVLRso6LE0fl00VeDwpIoYTzO/buhZw6a1xNC/N8?=
 =?us-ascii?Q?AqajKNqOaDL+IUSZDqTUOPPwPJQBjGD1sk3TXMUdRiylu8kmQK41huYkLFJV?=
 =?us-ascii?Q?SRP4QL8gmPgTSO0MnuLMu1s8w8c24aT/BaHVuqR5ioottKqMnl90CEF8mu6U?=
 =?us-ascii?Q?YW+qHEihHzd0d5sw6G/uC3qrANqKt2u/XPZ9jYrTHgzoAhaV8Q9DGhd/cf8h?=
 =?us-ascii?Q?gXH128m4RPoJh0bzYCtdO1rjAfhZkVqpKWq+Ah6cIUh9qX5nckzCQf7CYUKp?=
 =?us-ascii?Q?5Eooz8OCgpPmLhr7NRmtWqi6+LHeqaEuIVl/JiuJoJjjPHmjkIm3gUYmMGEq?=
 =?us-ascii?Q?Up+jSYrh0Y9BQhDyDotdX7Kg4eRh8wISZyPA0PjqRw464wpdskXsxNKx6v8r?=
 =?us-ascii?Q?oVJ1RQZcqm70fNfjz7G+PJrscUm8YLNIM8wDqcK2tvSGAF3u7Se7k+dqeotg?=
 =?us-ascii?Q?+bVY57i3stQWyXL2+MZvYxvrXVi2LdLZJ+l+9ytwldHLc5eWgIeBZppbpDT7?=
 =?us-ascii?Q?OChO/Py6DF+bYU6GvC62ZzmTBF7lpXGWqQNQ/zeFAaDvdisXzGgf3xUUZh85?=
 =?us-ascii?Q?ejSS2ppJNthG6XTsOIZY4uqTmtOhCJ9mh9JEAEYpxv3tgHJMML/cT/eiCcfL?=
 =?us-ascii?Q?MZJ4UWR3IbCFkKDssZ6nFqqfmlsdIFbrt1cbkRIl01i8DzeT/8u4igVH/oDF?=
 =?us-ascii?Q?bbNaRIQUWR9CjBp7b4Bb1DI3BH739oGqQPs8Cl88IAABCd+++uh5ZEN0SAst?=
 =?us-ascii?Q?NEX6sjtC+WFAE4VasSUucHw3sojav4MXf5i25k/2sCZekPUiQLiUJJa7MsOo?=
 =?us-ascii?Q?5WTc3ifR4u3nxMD7wewr8s6pNhZ6rYJN1plbItiTvKLXKl38nGkppqZIZ4LK?=
 =?us-ascii?Q?WCrJv08YujSUrtjt8l/NYa9aC3Nf9ub/UOgINq6nUvqPZqiG92tYAsDkhdox?=
 =?us-ascii?Q?vox4+gv7pr1R9HqyAUnHHLGhFnocQGUanTpF9K1MkfJ9/LnIqYIEXh+cm5c0?=
 =?us-ascii?Q?Emr125q9SkfEeb4aKJG91nX5i14VRYJDVWJQ18ZCw0ZXIheTXv2dXfLqwBN6?=
 =?us-ascii?Q?fFg3lTdYH0njEn1Jrb9v15QB78jzh9onWGCnK7kKx0KGbMkhuasZTeGHCina?=
 =?us-ascii?Q?TxHbf376QLXcY3M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F9XnTluY1GvUlvAjnwosucwE0GZe6FOoxjnxBkbx4exn2L9DzmPlpEXAzKyX?=
 =?us-ascii?Q?SGlt5QSYJDUT7TdFKjIsdISt4dhxkmBFP8ojidX8fkLRAMUPqBe1gyY/TvYe?=
 =?us-ascii?Q?MF48lBhfp6MC3Nf0qrwOPjBqd6PPs2zgENDaQ9CjgPoNL5xH9BD+HDE77mYB?=
 =?us-ascii?Q?Cvn3Mt320im7XMzFiMeAhOPxF7gBYFM3efLQh0Nuotjvki0AVUIehU+Z+uOq?=
 =?us-ascii?Q?9IX2Cg+VfdFRhKfBdPkEzD7Dz4sZpujG7t2GiRdFj8uPHveb9FQbqs1aX3fo?=
 =?us-ascii?Q?S4F13VRNbvZyWj7C25UesnkFaNn00q7p9DSY8N8rwn3t16bA6d2fir29AfYz?=
 =?us-ascii?Q?gJh6hRCyVY51MXvnkEDY2IJXJaY8LYViceQgaC42drrqXebY09aQtLBjwop1?=
 =?us-ascii?Q?HJzVnCT8QPR6CiJHqomLEgaZIpmbWVZ6kFh2sNoKxaRWWxD21RmBVjVtpEt9?=
 =?us-ascii?Q?RMQROdslBfQtpxacSfu2l+tSMwW+AOlJ+C4rxXMCekwiXYbe6/HtV9HngXAP?=
 =?us-ascii?Q?8XVl7yo9u0q0ge2Xx2kaqgPv6YYteNMwapYJ0e9lGFcV92MX2O26PHQ9Gzi/?=
 =?us-ascii?Q?F5WAQGKdVbuZ20wCqDOShLZlEjIUuGqliA6Y22l+W1Rm1ZxtUIMI7yfr97AO?=
 =?us-ascii?Q?eGIjJKf7zljbTva3pEztP8feI6OEQvmKFM0bOfpuNWAOT7MF1zY0f12XDZjj?=
 =?us-ascii?Q?NgU0wMvjK2T35MmfMtzWGVgheO+2z3HmiIYBi9DjC7uCPJ5pzc5hDJp3eu85?=
 =?us-ascii?Q?oUqpjHZqRQ/mIIBa4ogAmRmb4W18hxO2Ms7HwHdJUi/mAnyafAsS6pzPtbvI?=
 =?us-ascii?Q?zpnOMvDtjNCHLKYBjzLYx8tvmQ1De/BK+g0nUNtsEXFu9+3a3NeUAq1K7cGl?=
 =?us-ascii?Q?n9qIe6Hda5vOL4JgPEQq/In/GWeKAyaeh4hB+rIgOiXv7hyXTnp6cM2M9l+V?=
 =?us-ascii?Q?wizfjRoVtdOlX2GyFHNUz0R21DDbx6D7jU9s9PoFRs9VM7VYfRk8txYzhwWR?=
 =?us-ascii?Q?hS2inMGKq9x97vCO7fx3kt70QuXnyvO2ihLMY/PazyR/mJ6hRgR3ePKF7cQb?=
 =?us-ascii?Q?TTs70exwct0wJmY6KOWU0EobSxVi4kdzVIwPBsWQm6p7t6iNud8QEWOGR3qG?=
 =?us-ascii?Q?ARKybo2s1dXpyLaoX7+45cbHG9EcQHrwNm/co20pez89cJwbgQZSvxQB75qX?=
 =?us-ascii?Q?ebtnE8XpXLl1hBE9un4ZJQqzpb7VRrfqVNDqPL+D8au2yNj9scKX0cV7ac8a?=
 =?us-ascii?Q?h3XF6qjS8A1mbUuGkb3G+fv2CB/SAJl94j/ncnRB5fZEwysw/m+aR3Dg7z13?=
 =?us-ascii?Q?SgJcvMdNQAMCcs1RZQ8Ok/XlZC9ybXP9qbCdMEeRLJDBXCYY0HiBEswzM7H+?=
 =?us-ascii?Q?LPiNch26XOT5poDgSvZtlOsXlohR0xCRHbIKQrFarPymiwirme6z8/K/U1kf?=
 =?us-ascii?Q?89ZBtPOuE52NzOVncSsbVEg4S/KcxiiihWsxNkR/DUl6UCBr8DzUVzrzwKJx?=
 =?us-ascii?Q?AeFEUdplDSdgq4oEI5KN8r/DCEmDv8Ce2A6FlLUznNFtWYd2H+kO446sx5fO?=
 =?us-ascii?Q?y65KszXo4si/lK6vrhSLN37fbsUVk7f50YwkArJg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1926bcfd-dc79-4bec-0036-08de10c4d22d
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 17:11:06.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwiOvIa3lb/LFkwJ1OYZnnMKcVreFcJ13Y+oCqHjr33Q0jfEXp3472+RkywsSy2+QkvbKdjVEkioGFhoNw56iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9457
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 754202000B
X-Stat-Signature: w919q84a4o1ho98ghpx8tmxtqnouao6n
X-Rspam-User: 
X-HE-Tag: 1761066671-756648
X-HE-Meta: U2FsdGVkX18dlWaMsCcCBkhvEyvE2YDUQ6tZEiGiUp5RpAzkIeeitoWdf3ItRw6dWeBMx2GQeJSAS7l1QkLTUfDOqL7ebOHvOd/QLHAPyJWMQ1QHELXG4AMyurvk2OJjjlG4j/Q1OYOe14IAfd1b+hrG6kE7+2mejV4g30OyJGalhNd72kochaxqF7RqLJHI7GpTdy5DzCYVIx8EMg1YdpvxusYQYRP1wnibpjZQQ7eK54YmwPY/EfwyXPvCHRmEfcn/URsdKz8cTcVazRzC0kwOw24sbl2UgHYUmD9kGSWBra6zLluEU2Ku6CLCYo7m5MzoBqwSqCKYqOWMJ/YVZO6//YsVG6Xbii6lZeNubzGzCfcTaa43RTxGdo/qI2TbsQvgbclYN57rVtbi2ma3Nsgw7Qq8nDZYS5JUUlPjkp2sI3RXf870WuL0yc2LhkFzcwTswopT7vsHY7IjtJNYDLXSiCo7WZnGRhH0vQ/8ftMtMYiwq9BFq3d4X2tFxFt/ZvNa07MQtn35onZwEk9xArkHFDZGwde2NDpi+5VW3mlvhkl6VmHhdQdi3CVDOREaL8/uvRY4eEBM1uYziv7GzVnnhO+Bitk3tMnGMBHSCpgZuzvdeik2OcHs2KGIcoioynjemwfZ+yvqRrSlcxv7K37LwFNA2umTDkLKnxEOf//sTm9Wyq0oEX/ie15/ujSBCywbICRtcWC0X/Px6RK54uaKZJPPNuuvLzkqe4BLu5C5vKGuKQIh7Mwun+uFdRxB0O65sj2/BWOTohYgupWYcaIlbF8ryOaDNCn5/wQr+PXP5B7lZSNd1YuyZIqU9Jb3zRCOzw8AqPkuLWmXjyow/bIha90Rkc32tQAHVuyk/+MJZULxAAbcQrFK/tmWNe8osWvCagPKwB6ujtyfSetNN9psK3RAkOP0GXtDrv+vhQx+NpVVO+H/LF2Cze3qP+w0sHq0ETvK4/IiploDlhr
 8u7nNIAJ
 PJ5bxN3LoArD/oIeogDNZZ1IekfGwzLn8wjMd9tcv95mm2BAODdHdxW9u9vACNDFI9wrX1UrW1/ki1VfP9GEmlBJMdq8MasNiACGKx+7b1MtMZ3EMopB8PKrGmHFcfSh2HimaRZ6jDkeVb4vSbnwok7dxZ31Z4oyNlFi9JRSAoJq0szrexdMVPsBdoxDGGZAi/zb8ACJfQ1qyDFWQnD6mglK1O60M23R4hUMbvUCvII3YlesUKmyTXD0TinKfcMgJDChqEx1BGgExfMAQ98xpWj6ftEGsamYu8y+beXZe2VpuBGTS7TVrXAyDVd7FL1n/FN6f9M1iNIbM96bOPAdLH8oyHh6atZrmBr5T7bw/ad+fDPf7BSH32zaeNi8lFT2O7ym4i6g8riiYAQ3qfFKbnl0M9w17GXU1KW7GuJOWJ0gpw8OEAT0toGR9JoCPhk9/ymbwQguO3LOdTBHCw4kKwRObXMdg2M3qohbjCnpgWUwdVMVoT8C/XRHkdO7JFREgI77dHNS8ywvfxbPcgFNXUwk+7D0oWV7CuxpPQmxG1cGZy8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ankita@ wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The GHES code allows calling of memory_failure() on the PFNs that pass the
> pfn_valid() check. This contract is broken for the remapped PFNs which
> fails the check and ghes_do_memory_failure() returns without triggering
> memory_failure().
> 
> Update code to allow memory_failure() call on PFNs failing pfn_valid().
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/acpi/apei/ghes.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index a0d54993edb3..bc4d0f2b3e9d 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
>  		return false;
>  
>  	pfn = PHYS_PFN(physical_addr);
> -	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {

Tony,

I'm not an SGX expert but does this break SGX by removing
arch_is_platform_page()?

See:

40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
Cc: Tony Luck <tony.luck@intel.com>

Ira


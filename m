Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9591BE6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062766B009B; Fri, 19 Dec 2025 15:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C436B009D; Fri, 19 Dec 2025 15:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A0C6B009E; Fri, 19 Dec 2025 15:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFC7E6B009B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53781C02CD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:47:35 +0000 (UTC)
X-FDA: 84237406470.16.4DFF726
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4215940006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:47:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OPzmF4jz;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of alison.schofield@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=alison.schofield@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766177251; a=rsa-sha256;
	cv=fail;
	b=RrqBpQcBhnQt/LDebIWubR73d20hUyS+Nv6VdWBTywtma9jb2WAI2oOpvSPO+BnHsEh4PM
	A39WIMtuugGocmmxtRzhqX+Sdb27aiaFv8wKkH6DfAAMOeSsGUUYVEGtWD5doa5NR0ccY8
	C35DB67kVHOMse6m1ryPDB7wBbjlDLU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OPzmF4jz;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of alison.schofield@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=alison.schofield@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXj9SDUHQcYIRQQyeVHZWvpEdLo7ojw4EvTpRKqhujQ=;
	b=LWzI9Wknp4rlD8HB+gucmnTdXIdSbbkeVBIC/1Cfmf+q5Yix6vQi+aZYEDYbt841+yR1W3
	2Mln4EVsD1h7H3t4XZSV0grnAWlw2FKcm1HdTraDiruIjbCEHw7jN8tVq+5rwG61xahh3n
	hf+U4eMZ9b0BJLZWgqFF7fb8rGBPjcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766177252; x=1797713252;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Gp7uY5r+lBZsputjdKjrBCGrn5EjO9CGBCLC0X4Frpc=;
  b=OPzmF4jzv1QbvqUs20sB1Iw9kX3Nn3gpuUV9EEXAqF+7b90ja+5/Wosr
   4Rq71A/friUK7cFfCKh0gRQ+l2vCqpCwxVPlXrCw0LqZq4MsCUU2Xpa0B
   MRiAFCG/8aAuzbCmRFrARK6YEoCuyLZ8LWgy5qGLF5hEddNBgWZWRyQPE
   QlGJPczSAVY4dABdpmv95fqw3liPkB2eWGnvwx532kdmpRsQKR+3ZJR6R
   0jvc/NCermMpZtDjBHoFhtMy19add7oqgfIm1nOK082nMl0SmrR6Eb0SN
   peehOTD3HFkd3MigkCjI++Iox0dB+6bJiMoYN0VXr92Gb4Slp+9kHUG9r
   g==;
X-CSE-ConnectionGUID: FzHM23aETp6uvyLkyLDh7w==
X-CSE-MsgGUID: po4y2C4UR5yWoxAb75YS8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68075837"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68075837"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:47:30 -0800
X-CSE-ConnectionGUID: Ji/VVx3XTDeb5LgoeexXBw==
X-CSE-MsgGUID: e5VdzkZcRwyJOI8HBzfZXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="236381485"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:47:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 12:47:29 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 12:47:29 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 12:47:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZPGlWw4R/pGPdnbt/iX7lZS1K5VAbeTlvDVyz+N41eka7sesh8lz0BaZYX3qDMOUlHin6EAbuMcf8aa3ghkMskpUfuwCdi2kpPjUobzpu6y+RYt7uuNwvH6eG/iktgSGbXIjT3Zppm2V/YiOOXwBw2Ast1v7jYYt9uaO/+XEI9dmMe+f7vGKj6rc++NGbJ3hmprSXkfem3WM9gDrldME7aIfUuD1fMG8HKhNVUuAGgv7k6i1Sn3zpsGXs4h3fsBfDy1PdbXl8Bf712r1lvqo80n4txDwdt5Q4RKynTmx+RSeUXyjZ2f0urVmmVAvfjVfjmydlpPnSa5530EK4vysGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXj9SDUHQcYIRQQyeVHZWvpEdLo7ojw4EvTpRKqhujQ=;
 b=VOKhjnOFESIOrntiV9b3izelQ4RHkVy8G1PA2oSlZ5LaUECfS/uU2B98Z+L0hR6ghqH/GvmgeupdS/i9b3011UESURF0FP4ZrSZGNISYFSqegI8Gal0Pjx8T9mQfS9RcXIgTzE3a3YkiH+/DzPXHcc6pF+u6Eav0uBY1WBhE/B8E6N7F5OsTXuNPchMjZX01ezjc7++/5/7SXhft7VSbYzY/C34jOyTFtv9VKNSmZMMH9JhPDL+fYu6U4pulQ6lHqAHt36oMHagYSNu3uzRmW68CH2cjI2GE/05ZgaUxhlVJ/Pc618P2rJUofgYmYoUELh5DqteLDEMqUDKLpPxQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA4PR11MB8942.namprd11.prod.outlook.com (2603:10b6:208:56b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 20:47:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 20:47:25 +0000
Date: Fri, 19 Dec 2025 12:47:21 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <John@groves.net>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, John Groves <jgroves@micron.com>,
	"Darrick J . Wong" <djwong@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Gregory Price <gourry@gourry.net>, Balbir Singh
	<bsingharora@gmail.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, Aravind Ramesh
	<arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [PATCH V2] mm/memremap: fix spurious large folio warning for
 FS-DAX
Message-ID: <aUW52Z8QJX1mko1q@aschofie-mobl2.lan>
References: <20251219123717.39330-1-john@groves.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251219123717.39330-1-john@groves.net>
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA4PR11MB8942:EE_
X-MS-Office365-Filtering-Correlation-Id: 229d206c-8a16-4cad-335f-08de3f3fd0f3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xJdUv4b940TkIvj7pzuRiSb7fYiygnmeT45M85Dvsysuk4M4LkVkCuVyLdN/?=
 =?us-ascii?Q?apJ0ywysUjEhTvxJbpw7uWo885HOQrGTge4dJG+uNpkKheLqcPKjZMOAeixZ?=
 =?us-ascii?Q?Bq88wDYsALQuVKGM3rQlvihkFSIhxz3dB0NThfV4nMWAnINLQr0O1h0MrkAt?=
 =?us-ascii?Q?Ku1QGRO54EyeYtaqgeAz83lVjP79N09J7ajtNO1Q7C7OP48LKenjMOxUox9e?=
 =?us-ascii?Q?OX0zgmt5pfmoYcPceB6/Ih7NoqA5sX+ODORJaumi65lh53utMGbApvlAcvwR?=
 =?us-ascii?Q?72E587Ak98UODgzn9K4dcLWSaJdQW9S3Gxpxshr66KwbHFbMs8ITjZgQcV+g?=
 =?us-ascii?Q?2DIZLanIkKpQCceE/qdaEpJuB/+hvAdB6UYr+BqNrSkZv+ejZDN27u8NM+Re?=
 =?us-ascii?Q?g52M668cYB3FnwsMxAuXJ7iuMIC5LQxGNaLVK+1lLaWePSkOO8a1g/GezS7v?=
 =?us-ascii?Q?pZsX/qLQTIWRQq5znlZU/OePBSs5ZyTXj7e9GwZnIC7GApByZiI26jzmgBiE?=
 =?us-ascii?Q?rsDFXtINp9s6QI8i+4uDoYQInQjqBJuUrUl58JqE9F/sG5Y/ZpafLvGnx/pL?=
 =?us-ascii?Q?vmZCRRUXxmN66MtPiyUqgzViD3Ye0SvalSmE+21GTOWM7lVFJzdowpRN8elG?=
 =?us-ascii?Q?nfdXxB+xH1dOEoqT96CCX+lElZfH+bB0ULw7PY8TuLI+w4JE80IEMqI1OIpy?=
 =?us-ascii?Q?YrsikSIwApKaDF1+PUpjWxGkl++8u7tza/vh9/GBUBEtQ6Go9wf7DkDxfw8p?=
 =?us-ascii?Q?JQyqwuPnX5CElBQ8GT0980c2R4fN9U2HNZWlG/D5d565NqWtJduWG7ZXtNRd?=
 =?us-ascii?Q?JZ2MmA8LGlfJgCIKjiNakTmB+r2qXo9J5y/R1c8IcmYgksqp3UfYhqY4f2cz?=
 =?us-ascii?Q?NwYota8N6L1mzxo+ntg4DF/hQS0WI/k1qY+JednoveZB2qYp3xZXT9b8Qtog?=
 =?us-ascii?Q?1jCa3x0kFfX/BvEPePfuYFw2WL7lN38LgD97cqDrIyF88mQLN3bFES2wr9fg?=
 =?us-ascii?Q?TxIwnYtWoPKMgfyUR/um8W5Q+nz+oFGyH0Nn34E4u+sm/iB5963vSrK2VqJ8?=
 =?us-ascii?Q?bHxygdduaB7LXNKgI4ZSocTZTJdjhpWdaum2ufnoJStTd+kP5yY2wtARnK7s?=
 =?us-ascii?Q?yfBUewgsSKDXLVrXFeAqzL/1veh4VXNyPjjXqQ9+1z4oJ6OrDFJqUtA78phi?=
 =?us-ascii?Q?Afcxvq0dwpr0cPbgDRczVxZaAp4CQjNb72ZsD5pO1tn3yXwqKOvOPH5PNs6X?=
 =?us-ascii?Q?e01GsvXC3dggrATIMcMD1GbzWf3PUTOCN8GMX0q4pZnrmv8WpKYCO8c8yxkm?=
 =?us-ascii?Q?KTGK6HNCmrt6ewfi4KU0SBkOJ07rWYSGRvNkpO1LWk7bVUjPRMEtm4H36liy?=
 =?us-ascii?Q?wQumNzw3FFVgG3bFv/mMNZtGZBQOKbpnzA5raIJvxyGRDdO0Rk74xoTS2IQi?=
 =?us-ascii?Q?A/dtS/gICq9pZxPvy1RTlZGeDVVAhReL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AvjcE2a/3arcN7FAT1G1itsY9AgwZ8oTL9Op2dDS3Qtu4XnwImZFEJwRfNJj?=
 =?us-ascii?Q?vIgqNb66V/xazA7BzNT0+uaWeLjQb9Y13ARCQAtaRgdqtpUuJdTp4jNup+UL?=
 =?us-ascii?Q?c0lwbWP7BBIKPzgjdqQUbeb+MeLZYSLlZoG/9p1Q+ugAsVhLGUEwuwLiOev5?=
 =?us-ascii?Q?bLXMvQ1zBWA4yY3m68fmMlaozDWRdKfKpv3I9/yuo41HYx2tTbvC8ii5RW1k?=
 =?us-ascii?Q?MFi5PQjmDSzOARyVS4Cuc5bZjR+BxyLENbwYUQpXbLHuBz4gDL/SuUxvnGtb?=
 =?us-ascii?Q?9XUP8bacbb4jFwKTCR5LwjbaxboiRmBXZRu5JUlmx2ESf4kFn8HLwvzVRPod?=
 =?us-ascii?Q?pYhDGXLPcK3I0bYq+KEBvlBThgND/MmPzr56Z0xGN+fSM9XU02WPUGNArMH0?=
 =?us-ascii?Q?OlpAOPcO5TnoyF1/Kv4BvRVbXVvs1p06MLAtNHYQn0UABNYrxNL3zi0k6O4t?=
 =?us-ascii?Q?t6Fnl9lLLmfu87QcM4BCp+k42fmKJ/ENkOBWFWIMQL5gqQnV1NyBYiiCbrbC?=
 =?us-ascii?Q?2eDisp40ttDj/1+P0azN5bTL9CYEiPppZ3N/1HKiM6YdcOe1t1TcvGtLkpSp?=
 =?us-ascii?Q?YU4ilwZNPgmJ3JqxxorDd8G9+G/y7iVvN68cHJMxrywvkjuItCalrCX3k2qe?=
 =?us-ascii?Q?/YNUbZRBqoFe7SsPLEMV3jU8Jqn4x9Bxm8v+0jha+YaNe7WnarEAerkX3TRO?=
 =?us-ascii?Q?ylH+OK5P+lZ19eg3N7eZrntbYm0CHLjWOlP8ClF1FLTvpeWVh/fbIipc28K2?=
 =?us-ascii?Q?fVh45JAyluaBXkFujCYY9ZC5uRK/jI6rqfFkQ9E/KMvMwehQ2kA07OKH9n1Z?=
 =?us-ascii?Q?E7n5Yfuk/LZgCIVWTQpI8tE4m9Uhz4D3kCT3SIJq/mX1xr/ZKMv7pNT/5S1p?=
 =?us-ascii?Q?8UZqzKnmRvheO+u6g4AW+oj9qg3VpdWAFX+NJmTx3B7TAgJyajRtC63Jck7r?=
 =?us-ascii?Q?mf2quXOutdDMWIBFGlknGz9EvaGmnWdPDXRseidQC4NwTAj1y+O4Rvb1AvjT?=
 =?us-ascii?Q?ssUEos3CVJzAA5Wo3DWCUQnkDPoMRlhHkV80ILLlrfYbFrypP9IySKdRSmr9?=
 =?us-ascii?Q?k0HJyn5eHgycqy7OCArCrMW3I2rBo3CHQi+asZgj+5uV/Xu8OQ6G542xTqQ4?=
 =?us-ascii?Q?UeP05udNTMoNr6xWOoATckFs5nGZigUXmMTwY2mnc5vOAw3h1wCQ+eKz5sOO?=
 =?us-ascii?Q?mKGcL38PiczGLPPTKJjC7YH50rzfQs54JXpp0Ch6J2T6ztoiR5TfHGTOmek4?=
 =?us-ascii?Q?jLU+O9/bTSUSVp3eIZGT4Y4xXwZFqV8WpbbuR1vqoNHfM/BiClldHXQlIHGk?=
 =?us-ascii?Q?xc24MTQC6Cyg7nEFlMBWiDF7iSLuvJHkUup1YSYRdT/Km0nD5NWOLhtoC/qs?=
 =?us-ascii?Q?r/3aMYhDKHCripWObY5AptV7cgLBXhXuC20Rp4pW/vwTR0JeQnVbCL14VufK?=
 =?us-ascii?Q?qiZvRt9EjuadK7Dy9BITj+ccWc6JH266XeguT5/iOnIjG1BdIiYr2VQtEJ0i?=
 =?us-ascii?Q?2Ye6iJubYdhL1phvMGe/ahs4xfY0bcxD0jx6X5ZeF91/tI75A2tGa8CnD2wG?=
 =?us-ascii?Q?ZwqB62//H6c8i0Tn0iGnigTzVyDwhuT0mlclw14mIpzuW6AM+hKP0AJQXrxt?=
 =?us-ascii?Q?AiQvbPoCwrbf53yix0NzVEp089CkSDgUyxCKWcNBoKTRLYTb+h+SDiPeBKAe?=
 =?us-ascii?Q?qrr/reGawh2aguAWSbpA/aG6EkhKqELZjUvMvAwEEW15kLCRiSxTU9sE7d5x?=
 =?us-ascii?Q?BYEbzPNfiHbQW3kI7L2Ze004/LieeRE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 229d206c-8a16-4cad-335f-08de3f3fd0f3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 20:47:25.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmKUtHo/a8CAJRaGTnSSdVorDh2BQTqYTgvUhiFVyZ38qeYJy3NHQp0AxzW5kQs7dQ3BjyeKYcW5tm4RDvbeJSHmUDeO1qBLc6x1HDUxFAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8942
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4215940006
X-Stat-Signature: 4duqgcdpbz7ydk9n7jm7izcm5p76w6kr
X-HE-Tag: 1766177251-92424
X-HE-Meta: U2FsdGVkX1/gvCJMs6qyZNkD+Msk5SHMuHE/BJhjqTYMWL/uNC+6x3LCpN3KMM5O5xJn+z47iihnkTrjUd+m2zeH4qSSuBGpRQgksZsl+ArgvO7iEp8wInwGcwrTBJfF+S5xY+qWAupitd7tRJp/8Ojth2R6/i72CunTDDHXJKEhcD0e27cYfDJAVbVTkGq3wA/fT+t2wY6jy1dP0OJqN6F+yBEwPe7IriZDQuJn1qPBMdkM0fTJNz7yXROml8wCBnTJMgr+1iepgX5P2pDO4J21GSmKvbYjyYnbTwpuuMp7sBDgRITaNIEstepgnl2Ulk1rnDfPE7PieN8j0PSo3mX9K+Ja8uWCqBwjbdc+EeqxKKApkZRpZz52r8IaHmA9iL6n7hk3XyL8OdWjBU5+bIg02JjOsaOpg6KCLIS9sKy8fvn4WxuFCURZDlDPQAsf5v51ysA1PJV6wUNG6NhvvX86icbLlLiTXs4y5P6I22qeLbb5qyzHKrKYx+7UzFCZt55/0TbwUTWfUljXc4yowTmgaoBETWMA+3vOQxM6qKMolZkPEKgQZkyu2pIyjI79XgJbBAhB5BYeevOLXcwMN/9jGCQ1pJzkn1a4a/8V+bnhWA4M+4Mh0oijIvfsAy0RElYJ0pmtfs6Kck0Wi+RWAQDGYpsrezWvoA44tfOTAG+SybiVFdFOMma8L5sP0Woxv73/FPyhZ+WBn/w/LOo/i5w183RlWUlvnaOkY3lAKMILfDJAX6Hba5++/cjSFb/X4TJpwoeaCX1C59wQ4qbXXQHc1U+zIF57Gzbf4fOXqkANcgsXWpLQ1FKYe9gpu1NsFqWU07OwTNJgDlzT/by8Quv8foWkts2kJxt5UVY9uaUrK3vhOM0h/sgfa4T+ZNhkfQKBa8dRytHbpN0X1CQYRxVQKdk0HNjG6xTBkBANrxptbUxOjFGsb4PlxmTNZy2fZPGo+kBabVADr0opgtA
 n203YWAq
 iY5EtJ5qV+thwjJdHDMlZRNYe37qqOTcL63dD8zMgdWVhp0zhLJPTMxCsJJt3Y3OtRtijPuGVFCs2fZSUclpZfdlPkQI/GTFuN/iIIwfDjdY9UvIcx6aFPKvJMtH9iObPZYg1r6wua5ymqd+JcotBXZ/o1Xr+G6bmKjBArFmyD1OEmYS7Ht1y4DZBpYFDqCjLGHLiYQ/vk6fls2IvYmmr1FqJ2JAtDaW9bESj8ag6upEtM8rLq276vFiLRL4xL8lnULN/FBy1od6NfDOVI2RoKF13GFN0vPRy42M7OyUpputMOSHPhkA8MvIprFlEnDVwalrEZlEj8A63WyfdCmWOAl5WHDRFnmcGaVpP/vdvShUjZ842PTcb0gfSiSHkkTT9Kusi1xhkZQgU0F2YAq6qUHYGeGtPY1gGvx7+QuAb2wKxPiLHls6XEKETGGUfffHCT1YuKcsnZzoAvOdi9nNRCCjBkIgU9fuBHlHNCu7tdkuYhenoNgOkq3hcgbUFmWPtb5MnJZMMOK23x7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 06:37:17AM -0600, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This patch addresses a warning that I discovered while working on famfs,
> which is an fs-dax file system that virtually always does PMD faults
> (next famfs patch series coming after the holidays).
> 
> However, XFS also does PMD faults in fs-dax mode, and it also triggers
> the warning. It takes some effort to get XFS to do a PMD fault, but
> instructions to reproduce it are below.
> 
> The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> when PMD (2MB) mappings are used.
> 
> FS-DAX legitimately creates large file-backed folios when handling PMD
> faults. This is a core feature of FS-DAX that provides significant
> performance benefits by mapping 2MB regions directly to persistent
> memory. When these mappings are unmapped, the large folios are freed
> through free_zone_device_folio(), which triggers the spurious warning.
> 
> The warning was introduced by commit that added support for large zone
> device private folios. However, that commit did not account for FS-DAX
> file-backed folios, which have always supported large (PMD-sized)
> mappings.
> 
> The check distinguishes between anonymous folios (which clear
> AnonExclusive flags for each sub-page) and file-backed folios. For
> file-backed folios, it assumes large folios are unexpected - but this
> assumption is incorrect for FS-DAX.
> 
> The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
> allowing FS-DAX to continue using PMD mappings without triggering false
> warnings.
> 
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: John Groves <john@groves.net>
> ---

Tested-by: Alison Schofield <alison.schofield@intel.com>



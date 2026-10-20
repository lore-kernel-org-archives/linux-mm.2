Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980ED606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YAnsYHfy
Received: by kanga.kvack.org (Postfix)
	id A5D006B0110; Mon, 19 Oct 2026 21:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34A66B0111; Mon, 19 Oct 2026 21:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923D16B0112; Mon, 19 Oct 2026 21:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69A256B0110
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:11:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1E5C1C4257
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:11:16 +0000 (UTC)
X-FDA: 85341226152.28.5D4409E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id A74F114000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:11:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YAnsYHfy;
	spf=pass (imf26.hostedemail.com: domain of alison.schofield@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=alison.schofield@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxVJGyZVD4TOspb23UE+zCyCTGO29XhAyetbWeKszVk=;
	b=e3BUDol6n6AqhDXRhxz0Ds997+LtW7bxURqLe/hDLdzPmL1pAYLTFDOvhyrdICqXYNeNKV
	1n4HmAuk4PFu8cn+jEb5NOzzlTktSuw3SEzYJIpao1riaoi/Q53YXEmJ2lMqQ3j8Oi98ze
	49ywfDre7l7vhs+b6E1pfWET0Rmdr60=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1792458673;
	b=X7GSHrZ8UAkBEKAnHC1oyK+4KoCY3uiBbe9n25VbxC0V3A9qBCyb4p+Idj5CNz6Uf90+ru
	VVi9q2FQ1vNxzEBTM+EvPtLgwfsEPN63XN8Pkc2JzPpoF+on6bsyGkupY5tToO6A9NAmyq
	rPLHet7AxNvC73f3GY1Gs4GbadPvQ9M=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YAnsYHfy;
	spf=pass (imf26.hostedemail.com: domain of alison.schofield@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=alison.schofield@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792458673; x=1823994673;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=egGm3BiBFelzVfRJOhA60kEcRa2S9uvUM5V4+B9Sc2A=;
  b=YAnsYHfyNFSRd8Ch2QTv86l3m40YkhbtysxtMU4iW7hiTxceNkLg9z7/
   S/Ib4NaNeBejegSjKMtq/a16kbQY63QS4We7rxlqXXwhSXoXXlNDLEN77
   tgKXDGsjw98BjEtTKQqQcWatuVmKJ3pbka1Vg/6/TO9wPRygORCdW1U+1
   2wCoWu77HUwnSVmy04oVZw421faL9bkC9RMlJ9r+H2S7AiGSebjIlvfnn
   XV3R6Y+gQXSK5dCYsnOxyVxUd0A5PqqbG0BzPwTNuLariSK5et16mUKZ9
   WiohlzzjFmxEN09jG2NhFbjdQyWEyKxkyaMOnfcqZ0ojf+YdTrNm0QxJ4
   g==;
X-CSE-ConnectionGUID: NE3h+K+pQ4qusFASh7xHdA==
X-CSE-MsgGUID: KRE8EL/uS4WJsl/wtPPCQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1138841"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1138841"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 18:11:12 -0700
X-CSE-ConnectionGUID: NudScc1yTfSSL/oMQobKOg==
X-CSE-MsgGUID: RVMFA7JJQ4eH5CIGFwtMMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2671654"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 18:11:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 18:11:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 18:11:10 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 18:11:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zInT9SkRg4z8nh3PmS22W9bkHDibgax74AKYvTdeYu2mX21s+/YblIIKcyRp+JXdgnAD5YP4Fiv25U8kGy2yZ3kUSeUxIf4kadDxcJyEeHBx584X2TfEgLvE/LTePB3RjeysMWkPYNFInzX48fRT2Q/O7Whf0VsgzkRGkNxGNaxNM2sU0WLy64Xnb4s+Sbs+ZBh+ruPt2IrNiYvgKFISxFp77VUyxkW6EJGA5ItBT2qDJKJb0/d5QV1nUqtgCctxny+R5vThPj4MtEyAMf+zkxCFqJNsvrCHoo+coVMBkY1KHPrfnpKBsfZfKwcqxxHtTQxlbmaNgiJbdPe787GXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxVJGyZVD4TOspb23UE+zCyCTGO29XhAyetbWeKszVk=;
 b=HrdUKMT/IFxBhWPXmfYM4wOQOPEUQJlbvTYB02bedmtKXo3XNeDQUfYebSF16qwtTDG2TpPzRmKj/V8+V7dgOMUijVNJLopNjRpzsqUPgYRB4nc2qJKaHJ7b59Yg/BdfsDUVf0ffNHkdyIS0+bPkyJEi2G0ftEZcyEbQ/nr8O3RxmfZmxISgze8fHOlmcO6ZjtDa42OTD7G4uaM2FKEpCuQoBWOjEaXJcVU1Eicmf3XrDImRVW0ac77eVdwzu+v5pGs7NJ5M+BKQuSATGEYwDcuv0JqmBKhLafE6MgWb1bRfP7+gdNmtVyvTxcU6LZNvaBnu6PXlbzoatCYwkpzXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB6398.namprd11.prod.outlook.com (2603:10b6:8:c9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.14; Tue, 20 Oct 2026 01:11:07 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 01:11:07 +0000
Date: Mon, 19 Oct 2026 18:11:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Richard Cheng <icheng@nvidia.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Kiryl Shutsemau <kas@kernel.org>, Harry Yoo
	<harry@kernel.org>
Subject: Re: [RFC PATCH 0/5] cxl, mm: Keep device-reported poison out of the
 page allocator
Message-ID: <ata_pfACXdlQuM_e@aschofie-mobl2.lan>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d9f524-2080-46d6-986e-08df2e4704e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|22082099003|18002099003|260925021911599003|261009223027099003|11063799006|260925022911599003|56012099006|260925021311599003;
X-Microsoft-Antispam-Message-Info: m2nQRa0HXo6gUu57Q2WZ828yi1r4p9P0yNGSlQTZ0LONum4OhJ7IGTHvHeujtPiav0LdWpyCZnbBIaim/5lHPu7i3/giTR7bj/fjTKCRDOMfRZ1xAtZYO/hd0T0w4dKvY88Tg6F3qlF6sGB1Jqnhk12eNEDtsCbLcieGs5qLbbFnj9WJqjW0Xz1Ft34PVjc/j/oUSjwuBKzaeNEudQWvOkNTjUtBd2C61u+iNSk4IRcqYSBOLdqzMwVbTzcIvBRMMSLz004N6lgEiQc5STSwy1wSREDLQdKNsJYmnI+CBlIzpF7FUxJfm13BAhhf9jlPX7mT+ChMkJqAtUz12H3jQ8BHvojYA+6m7Sa0b95TOKwX5aQumB+8sYKPvyti3PE4T9j1OX+GNUnoZN526n+bI4AOLQK1BO5fMu1kHXXtoI0PdNHjW9ocgRGYNeJ5o9S16v2Fj6yWajFykV1Nu1IAf3q7UfB8pwlM+owaBIsxy9dHPXUp4B0z7aVGY8z6LU25FZLTuCWj9kQPY6db94Q/2PJblFz7sKTjc3oqdO/CdKMZed0cn8GjTQ6PTt+H12rKcdRG+n4MgiuEBXnO81d2iQZXvmta26P1G4tBQfoqd0nGZF835j78VJamo8R9EZbZuBcjeyquP4d4R3v/CUL6LZ6ZtP1wdNO6ab2TQxXHyCs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(22082099003)(18002099003)(260925021911599003)(261009223027099003)(11063799006)(260925022911599003)(56012099006)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m77FtsD5niDtZxzY9zjsEgKnCuMfsDxHWncukPOCU1Yt6w3naHXp+jSfevWj?=
 =?us-ascii?Q?pOnLEI7iXCjXuWp4H+ym4LJSUpmeuWl8gCiXDqHvCPkAbHCvr69aWaWmWs3W?=
 =?us-ascii?Q?A3i5gL0/w9EiIutWcesahEfCkRymTUxFiY8XDVD8uyg/IAu6S9mB0zOtzjT8?=
 =?us-ascii?Q?r1kHm/OS3b3E7Xt3mztbHntyQnRKgZfFi05Fg98Daq3yIpzWPKoG3NzEGNbt?=
 =?us-ascii?Q?gQUbpNVPJcY0+tqWLEHs30IQ+DJBn8ieq/UYkVgzYyKS6i8Wsc/BHenZbXz7?=
 =?us-ascii?Q?xZROvnR8n0Iy3zgmIWaes7Sf2voIbC2O9dxpvFuteRa6xW5AU7kw0H/Gw/qx?=
 =?us-ascii?Q?pkNlk0P+45njeRWidnplZNwst3gcjgAfqAeXOJU+cx8CVskBffRSyej90Aro?=
 =?us-ascii?Q?4N5R9KBOr9u/sT7+7w9BLaIB3BI9BkBl8xgnZDUYOObQBtATUPsT84tUDGFe?=
 =?us-ascii?Q?m3F9n8TCJQjb5G+miPP75sMaOTe9aemtNU8mcUVgAy4Ki1MRZiY3dDthrGBy?=
 =?us-ascii?Q?fcniGsUaG+7uLmhngBRT0+DfctzOiS5uQqCWCk7eTYTwq5JcvpWQyqeigv2+?=
 =?us-ascii?Q?jeXOs5bva+LxbW9eKVxQ7clr4pxnzXJcWz1BFM/4mzalQUSVPgeBnmLd9oHb?=
 =?us-ascii?Q?L5LpmD6q2VY8pO2vKI/yYS1v61Xytx31NS0T9GPXTYylIbC+VZAwKkLaBwnp?=
 =?us-ascii?Q?cRV+RK5KzrwqBVzUw6K0m5+L/+WPHbmgvtpPmlRTeC28uPdsx097zJwGo8gD?=
 =?us-ascii?Q?Uin7BTZi/DFVU0kirHPu6VigJWfYPC7fQOG5VCDxHXm0eEZhRfuZ8saJEzs9?=
 =?us-ascii?Q?sb3+4wZ6sZaW6Gy9jFZIu6ukNBCHc6OiU2oybGNw3EJ5LPfutfUef6bhVTnE?=
 =?us-ascii?Q?ucfkocTBXiX2+g1NjNFYXMbTBxfr6birUFcx1keI+5Ga9ZwEEmz+zIK68ChD?=
 =?us-ascii?Q?H+dvO2ju8HgL8pHE5kMX8N9mJxWMvNGO/cr87z/l9AH+ccFtNx5DCvNyluqb?=
 =?us-ascii?Q?dna9814beDf/4sprZOL+42vAX6xDe8cEUH3181MCxY2aFCAuYbyikwEZNAzY?=
 =?us-ascii?Q?eacyyB0oqU3Q1b5U2ovSORf2HHH9a4iz13hel80P0nBh2ACNhtlI+azIjQk8?=
 =?us-ascii?Q?smGRu6H7nGh0mwe50d14c0xpKscj4Csk3vZN7sUFnjdaVBumA4Uw0ZhC6G6Y?=
 =?us-ascii?Q?XXzHdb5JwEETP20du4CJPfnjNNu+aoPUP+bY7dYwO4ZfKo42V7bYUzRJv6fk?=
 =?us-ascii?Q?MYZwNUy45n+Goo9Q3oaGcyvaTsDNNoUL6ZkrrY/FnRU2IKpeqH//PM1pyncK?=
 =?us-ascii?Q?s3VE/fZmCWPIoDk2Lh46qyu4e858zU0Fm9YHwL3gN0KvUYh4p+KpK/Fw3Txs?=
 =?us-ascii?Q?ViEFqTGNcEGGhksyjLzYXjUYjozUD6IVqBuRFfg/KjAkxOehyotNZwcyGhoh?=
 =?us-ascii?Q?2ESBjEv2jjyHDRdpLnzguf3X8XI/bBXDYZu0CklH6RLo/y2pQzILFA0jlAwf?=
 =?us-ascii?Q?GXaAX+RsNvvWNTcJ8ynRchStk9GXDaK//4+0agS0g9EW/vKZi9nqMDzf7KgL?=
 =?us-ascii?Q?dwQwqZERdQykgU0PG+uXabHgCNLPW9zE6E3Py2EIZtZMQiGJVEzKnqnV4yLT?=
 =?us-ascii?Q?01LPyAuv6yi+4Rh4v0lsmjzPKAyLjKZkNZWn89RVwiM9vQ9pSHgER5B9uRnq?=
 =?us-ascii?Q?RPL2JON1Bj6HK9rVfGJL99oRpxAbPzaFaKTY2sSwlj6DRZOWPN11dL6iOya8?=
 =?us-ascii?Q?Rh7wAGvyHCTHDqhflNYgoy+tawsGDws=3D?=
X-Exchange-RoutingPolicyChecked: COmATCrjpbGDT8tQ2sCGN9nFb7cnb8DQyNYyMRdycO3irFHTGykYs3rghfUkgqfI7v5OeEXI4LuWOVnOoqEs0bvRoqbIsYzoQCptkglOjG99fky6u96lnuBQQW1buoYrzT+BycyrhNwmcJE9BXGVx0Uyw8x3eik/1ka3nl3RNqk4cnBEweBQTCbVCs46EgAJ62IuGYoZso6/mPveEPPY29yDx9ML9Qg0o4tATup9AHDBEmx13kUZRNCYcGO0jYiA7VyiPM9nUQEtMkIyP9kBcRE+jMaodqYZq+sg7OVDaEYeC4qI0qfFZ8diRFYtrz8L9DJjUL+nmoQMsS/KL/3aig==
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d9f524-2080-46d6-986e-08df2e4704e6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 01:11:07.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8JXWUfic9N+YgJofivgkS4eCR2My0abuRSiThPNj+Usmf3ScrW6mSlvc4eMjvkqiCFyDToOI9iIb9XzJpdALuSCcsoYNjjr1UxROxpriOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6398
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A74F114000B
X-Stat-Signature: jp1sruybe5cszwqdm5h6j5uxoufhyem3
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792458672-805102
X-HE-Meta: U2FsdGVkX1/D7jwem4LVBxPvxSCkndk8yfgb2HlmfoKfiEY9uji7D2KCBfm4vovXlVmvjLBr/ONTlst0rgIVQkyCbXfegBKUf5E2rAN8XKNgLApEZWyGvSubR9KVLfqSfW5h1dJnEW2/AGuhoRvbkaKdyUdaVnVdWAyNWw3UdjSJAtaMMeTC4IoUX7j3zNbicCeUOlZ+F44TViV7bQ/kTBKNmSdEDoTfD6e2OyknjuR0z8vp+P5niytPxDnxOYCpoG5MZrcaoonUQTcD43kd/x44a1IplzSJEYZdMhJnlL85mUaTP0ZeXajFmPA3YphfwNNGrcE8rw935+fygGh9PQlAeLPs0lPV8YA1tvwU5aD6qNo1TRdfTg5jEPp6nP8uhL6QXuXmmNIdsdsHT9ltAFlMBZf1TKi4nrVQ0nk6yjEGdJamo/OKf0Se4u53RT7KHMPtaKCTt/UvjYoXqP4udaJ74stLWF+LBABVY9mbz/e8fRqT80XUibXn27nQxMS3+mJq73IrWHrHUQDSlLF4OwrOBPjJWDKBFS4iC9A4ljdVBZ7OBC1QbOFctWI62oEdyPaQb0+uiZXiSQwe1uexzbwN+YXJqzKMwv8sKYYIbbNlYKeGMb7QWKVroBXzOAIgOTFadwpE6d3p5g23wXamgloX1+FVwrWnHMFrbl1ii4cPnUhUFpbKidPerY3v6gdPyZdW4/oX+8/mTkYKPXamDCFUxNpbV7yK6BU8SqSMTSyKHyRXQ5AuYoNpOQOIGJymnSokadpYDaf38R3/C0bANjQzK1/EQegh+Iws0F+cbPCNub0L8MvSqcc+u+rcytofzpmzwITGlc4b8nWQgL0TBWZgqO18Ip9GIIpTLuxayak/zLHsUQjCropm1l0S4cHW0v0z4IdUrHK7WsTNkKsomXZapOdVRFFiwf3j8UAY3r3Z8DCq5xtB7PmyOBBIUld43S0pKWGcB/k4h9I6whE
 AASDRqT8
 MNN7EuC5frlIxT4Hqqbqo7gTdcBjLMqEr5/2QJQFy2E2PohJ10uH1ndPzvd7nGs9BzWlUJ6D06QDfjrdaeSfFoNnvI1SV1lWsdRcSmetQT40B1W9n+H8Hq6PBQLPDbVwRtjzdKRgVEV2XZao5rXeeMnRbzWsXnzLQ+NzZcjRZHa8DPDRz1OPwmjvoCOMeh6lWWFDdc1vhfb9P7KR3hHL+b0gBAWqIIGlWSyuXRZXzAYGPIubojMdNWht6Tcngnov+lSM8Wir6Kz11CCjMzdgjE7k8E3rV+oZzd46VUSnHcge0cMXUs492OSI4wz8aGfANBTnNyxYAklRYI2totaDRkXDOxo8ijDIfkN5j/nFcQLRPUaGqz0+F6KDjchIvWTMF6E3f/KDkibu+b7kVMouQ4P632eagBI/KycNI+IJfw4mt6vvOAFznqognjMY1WDf63USRCJe9UISUj8GbIyezDKZ4QoAFzGVWeXJTQqRJlLbppftI22e8bXIUAP/8Sj7pAw66ydNDFlmluvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 10, 2026 at 09:50:08PM +0530, Shaikh Kamaluddin wrote:

snip

> 
> Applies on next-20260908 plus [1] v5. The num_poisoned_pages_inc()
> change agreed for v6 [2] does not touch these patches. Patches 1, 2 and
> 5 touch only drivers/cxl; patches 3 and 4 touch mm.

Hi Shaikh,

Can you share a public branch with all this code in one place?

-- Alison

snip
> 
> 
> base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
> prerequisite-patch-id: fe9d44deb8ccc48c0311bc4131bdf733eb353b34
> prerequisite-patch-id: 4cabe6adb37cd8c218bd43c97970bc65f313b671
> prerequisite-patch-id: 52ad24bceedb9c03df167f10573166a1d97ba97d
> prerequisite-patch-id: 44bfbc8aa3c4b19593f7b0d466fbc0cb99b99f76
> prerequisite-patch-id: 2d344a5322ff07c7895a59d2425540a30e4e0630
> prerequisite-patch-id: e776f306dcbdda3f6972187ad1e43a62c2754890
> prerequisite-patch-id: 3ef887599e31ef973d6d9ca15d0462d55f5f0409
> prerequisite-patch-id: a23fe88ab4529b6a6669a991e15cf1631311391c
> prerequisite-patch-id: 111c69880ed0e148cdda285896c006e8d1fc98a8
> -- 
> 2.43.0
> 


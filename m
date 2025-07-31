Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BE1C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8118E0002; Thu, 31 Jul 2025 19:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3887F8E0001; Thu, 31 Jul 2025 19:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202898E0002; Thu, 31 Jul 2025 19:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 059E08E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:45:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77665810B4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:45:27 +0000 (UTC)
X-FDA: 83726193894.19.B08741D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14BAD4000F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:45:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nXr+uK1N;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754005524; a=rsa-sha256;
	cv=fail;
	b=MxHPtpvNFPfXgWnrOBxEnoJ13pQN0HAh8fIuYkeQmT8c+WSmpDBRCTHYZIFdEvqJ7lZBMg
	iIVeojKXzVUFQ+qsxeDbmu0SbUN5xLzarMm5tum66fLQft39yMeBXuRKr26ufRZvjruErX
	4/bwHxDrbuLoEpyosWD78AYXcykUOxU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nXr+uK1N;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754005524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmIGVEayR2fUH9l3KIpv3IE7Ik4ugOM8SrO22J/WmcI=;
	b=a9XbPUMonEZ41k/ZKAin1/DjdREjGf7H8I4vlSAwB5p800yKG2MRAPUlMzyRw8n4DDPWLS
	tF6H5y+Txh7vXRXQCFC6wK5QGp4Uwhc+09nzayG0Q/yOj0hZo15XIaCy21KNzulMXrfJv5
	u1xNGopStxooSU6gJdOgwU4eCCkcflc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754005524; x=1785541524;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eYWGnZmvATUBz90oGZfSzf+FaWVy8oUlG3MBs1RbuW4=;
  b=nXr+uK1Nh3aaNJ6FjoOL2wLWQDgJnnE5BUAYddcmKjL+q346pSTUFs9n
   OeIvv+MXkMvhVAVqfZxt6TNWsTDOZOsL9b3NKqw4psNevnbeaYOXoicGd
   z1HYcON9FScJbuPjWgbhgpcoHnAAqkLfjHPm8ESof4NfzsWWyw1H2fRYl
   AFwhZzG3+in6VluwQfyXfL140ei4J35UrlQx7XKa631iA/QELxN6Y5SJh
   4fd1WTlJV32gmxx145535DHJe4dUWiWk4lLagpDb34utPwf7pQeUlVQk4
   tO2RqVAEGhhd0kDQeDrE2hj8kyRq65htcVuT6ybacNymdISWdGwBsF6P7
   A==;
X-CSE-ConnectionGUID: d7zXi3cDTj2FqpdDCdabLQ==
X-CSE-MsgGUID: GMA/jFQfTSqQKt9zZgjgtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="60174344"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="60174344"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 16:45:22 -0700
X-CSE-ConnectionGUID: jaREoA4nTrKi2W7cHVR9zQ==
X-CSE-MsgGUID: t8tqJ3r8SLul09Z/vXJL2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167572837"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 16:45:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 16:45:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 16:45:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 31 Jul 2025 16:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYbPxX7+qsW5m4G8zB2gBtOerKQ3cIRTdBrJlWIy5YIsDrje4PdWpaYjpKqdyVhFQ7jBBsgnCdr00S3iNO5/s3ROuEFwafTQfYlKsIYJvalYNiiTDJllyqzcNr1f0P8aI5k8RN6Eg3QU0Sud1KQqcv2D+wwIRvZPo0Mc/hL64civbMPZLMx21Az00jP3uEfN4+7bW9e9qR5zvq2QjBjfnsH/dcvfoU4uBV4R78R3Mqa0TH4BC8eofcFH6/Z8zRVGltrHN03ratwkdRKno9rMcC7AiWviGmK7MzFopz7edzDdZgHjK/1xwCjaMHLPNuysdKilMCqvaWlRfAlu49lo5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmIGVEayR2fUH9l3KIpv3IE7Ik4ugOM8SrO22J/WmcI=;
 b=r+kboEls3B+o0faEEbaClXu24c3LGRJ1o37ad+GOxLQGALQbyylYcPsmPfbi7WA7LFG4a/TnakTjwD+zPECo3yGbVGMaV3pr9kRpYXmYwJTL7dSWzx+S/YPnbhw15GShDuSE9aDY0s8jBElWpoA4NahkB9JFFiObTJLf7Q+i99ZziZW+l63ZEVpJK8kkyDYKm45l8IgiQkx54C5ron8zQjBNSXwqUjdhlj7IRoTSVH/tlCjdvUERpWcSRBhmmIEbcnt6MIhRz0PhFFB7KrhYZSRu8QgRkRVeYV5JvprdgUH8Tja8onxqpzOFsAByO849mNBz30TjIl9oYaEnTD/Ssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by PH7PR11MB6425.namprd11.prod.outlook.com (2603:10b6:510:1f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Thu, 31 Jul
 2025 23:45:18 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8964.026; Thu, 31 Jul 2025
 23:45:18 +0000
Message-ID: <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com>
Date: Thu, 31 Jul 2025 16:45:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 04/16] x86/cpu: Defer CR pinning setup until core
 initcall
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, Kees Cook <kees@kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "Pawan
 Gupta" <pawan.kumar.gupta@linux.intel.com>, Daniel Sneddon
	<daniel.sneddon@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, Breno Leitao <leitao@debian.org>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Alexei Starovoitov <ast@kernel.org>, Hou Tao
	<houtao1@huawei.com>, Juergen Gross <jgross@suse.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Eric Biggers <ebiggers@google.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain
	<mcgrof@kernel.org>, Yuntao Wang <ytcoode@gmail.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Christophe Leroy <christophe.leroy@csgroup.eu>,
	Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>, Huang Shijie
	<shijie@os.amperecomputing.com>, Geert Uytterhoeven
	<geert+renesas@glider.be>, Namhyung Kim <namhyung@kernel.org>, "Arnaldo
 Carvalho de Melo" <acme@redhat.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<linux-mm@kvack.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski
	<luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra
	<peterz@infradead.org>, Ard Biesheuvel <ardb@kernel.org>, "Paul E. McKenney"
	<paulmck@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Xiongwei Song
	<xiongwei.song@windriver.com>, Xin Li <xin3.li@intel.com>, "Mike Rapoport
 (IBM)" <rppt@kernel.org>, Brijesh Singh <brijesh.singh@amd.com>, Michael Roth
	<michael.roth@amd.com>, Tony Luck <tony.luck@intel.com>, Alexey Kardashevskiy
	<aik@amd.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	X86-kernel <x86@kernel.org>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
 <20250707080317.3791624-5-kirill.shutemov@linux.intel.com>
 <6075af69-299f-43d2-a3c8-353a2a3b7ee7@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <6075af69-299f-43d2-a3c8-353a2a3b7ee7@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|PH7PR11MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 176965c7-a3e6-41c7-0c39-08ddd08c4dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NlJEaXBzTk1JSHpTSnVDU01kc2t2dHdzMjlhNXpFY2hIVThSZFhRT0cwd2VX?=
 =?utf-8?B?czlzem8ybSt0cmFST3pxM2hWK09RK1hqSnlzUk4rcHhSYmJoWmNFYVdnekI3?=
 =?utf-8?B?cGczZkdlSTdnZjRaTkg0SVlZdnhncnBibExjZkF2SnQwT2lJK0tBRERpUkdN?=
 =?utf-8?B?L2ZSTVU1U2pGRWU2MkhoTEJCSStTZzhUb0JwY3RuT0wrekFVWVNuRVhrRHpy?=
 =?utf-8?B?Vm93QzErb0I0bVpWM0xiZHo4cE53dlg1dzRUS1dpNDA0eTVPWWNXNDFJWlJw?=
 =?utf-8?B?U1RyNERpZkFHWDVncmMxQkZ3MDcybEpweDdKT1ZHNng1bnpzVzBYNkpPYmpx?=
 =?utf-8?B?SnBLTXlFTkFETkpzdWZXOCtMblZqbXo1aWxhZEJZekZwS2FCczlHbDByUGkw?=
 =?utf-8?B?NGhxR1lLeXBJaU9VYVNRYUtpNDczdytTODdlOFY0VkNNb2xuaG1sd2tRQVFv?=
 =?utf-8?B?MTc0UnJEOEpLNjdCbGU5dFp5aExzMzhZT294Q0o4RVorVzFIZkdRako0N0Fp?=
 =?utf-8?B?ZVQwelFkakEraGk5N3JyeTkzeGVJZWZzdmZlVW9tN3JPcEtTRWVjSHJieUVo?=
 =?utf-8?B?Wi9IaitmTVVSSjZFZ000WVB4YXZiSVd0QnlGYVlZdC9VQ2x6TXR0eVREUjdh?=
 =?utf-8?B?NmNTdU1nMUJyZlZsK3krMHJZVy9Qc0hndjV0eFM0VWhTY2oyZzhIUjZhMVRj?=
 =?utf-8?B?RTZ4cmpoa2txdUdPaHEzK1RPQURWWUJPRmNoNDY2SW41Y0VOejRtQmxtaTNP?=
 =?utf-8?B?cjNneVhJNGhDOHg5clZmbjFwdnM4b1JIK2JmWjNEZkdiZVBmM0JPWGNIcE5S?=
 =?utf-8?B?SFJFQ3grbUNNRzRldTA5TXlVNVpmYzYwTGNGeERURkE5RmtLQ1ZCSXVyYXE3?=
 =?utf-8?B?SFVaSnhrTHhlZVlEWEZaTHJzZHNqMnNWam1LK2tWYUtMTEIxSmlkelRaMWts?=
 =?utf-8?B?M3h4Yjk0YXZWU1hiRWhmZHh5ZnNjWERsTnRVU3N4amRGUW51TmtmTlE2elhL?=
 =?utf-8?B?bktkWTRBekZnSDkwY3JmQW5hSVJmT3VHeDI3WitLbXBhMWNlelhnZTZNTndm?=
 =?utf-8?B?S0FPOTRkYzZCc3EvWU9odjVSTUVUY0lHOTBKL3lDSGYwa1hJa2VCekUweXpr?=
 =?utf-8?B?clR2emN3VDk4bjlBcmZMTVlFdTBjREtXdndHNmhqWDdSbDNGaHNNMXMzS1ZH?=
 =?utf-8?B?Y3pSK1FVdlNGSVI2NXJtbVNjRzZBcUpkT0x5RFZ2N21qd2d3NjJQOW1OeTRR?=
 =?utf-8?B?YmhsRk9yK0Rab0E5dXlGOWIvTkNGdDRQd1kzNEZYRXg0dk8wWk9heDFOQWNi?=
 =?utf-8?B?cGZkNGFSNUhlMXdRcmVPcFNnbXhvd0hoSFVReng2OXFJUEhRZEhFQjNISURt?=
 =?utf-8?B?RzhkVS9WQUV4RFBOQXhwWm82anlvOE9obXB3Tkp1MERPL2ZLRUU3Tk9RSmQz?=
 =?utf-8?B?Zys3R2l1a1NDOVRQTTBNZjBUOXRmbFB2akgxdHA3S3k2M3JRcy9LNXdvVUNh?=
 =?utf-8?B?bnRkL2VpVjRNSWdrd0dmN0NiU3NEMXV2WStoN2lZT3dBbHloRWNWY2VHZ3lL?=
 =?utf-8?B?OWtTQTNPQ1dXc1RXZ0pzenNDNUV3YndVUHZQQzlXbTRjWWtWMS9uQTF2eUFZ?=
 =?utf-8?B?MEhMalNuanJpVlFSNW0zQzZ5MjJnRmQ4RjBhN2lVeGtZeWM4Q3hqN0JCQVdu?=
 =?utf-8?B?M0JtTGtSNFpMcVRxekMxSEVkQ2tZVHJpcTdXS05MSFlRL2FPdEhxQWJscU1p?=
 =?utf-8?B?MEc3RCt4aGFuR2I1OTkzQUxVd2t4cWw5SEhMYzA3azZ0ZkptU3hhZWFhblE1?=
 =?utf-8?B?eGxCOE94aUhIN0FhcnNkK1ZQZFVYdjcyekVTc0U3UWVNS1pDRjE1MzNPc2hF?=
 =?utf-8?B?RTdrR0p0WU9mVjQ2MjVMbUVNRVV5VTZZa2REVHN1SEttTWJ4SE1PeTZBOHdL?=
 =?utf-8?Q?YTVI0bwLw4U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlhJcXJBYTFSbG1VQnNXbmRXWENuNjdnbmR0Y21zdFNhODkxWFMvd2ZHNjVK?=
 =?utf-8?B?SWcvNnVKSlhKYlFYYUZuUDJ5SzVQdVhYTy9EZmQrMVNWTXU3RzN2U2JEOGZv?=
 =?utf-8?B?a1FGZUxIRVFrRTNpSFdzN0NldS9reVlFR3BNUWdsMm03Wk16Szg1aUhzcHJt?=
 =?utf-8?B?b2pSNng0b1c0VlJsWk05Si9VQnN5VE5JSkFJNWltUDBVRXByOTNOeTdXWDgv?=
 =?utf-8?B?ZFZvaDdpdm9RWjhvQ2JsazZzcjJNb1NSVlM2S3ZodVNKcGt1WGZ1WmxCUlVE?=
 =?utf-8?B?Ulg0VVJ2TXNIY1JabGZBcHdzSDJqOGZlUEwzRW95MVE4V242Z0dSdGd2bHJ0?=
 =?utf-8?B?YUN1TFlBZG9QdDJ4WWtuYTYwbkt6Rk9WUlFNSjVRTytLOFg1eEx5enRreVFJ?=
 =?utf-8?B?SHl3NjM5UERhenVZdkxkWXlTU0dWM3JnZXBHUUdVZ0tPSk5vMmpDSGp6cHBW?=
 =?utf-8?B?cjkvUFdldGhPNlR1bDBLMUtoN0NxLzNpdU40ZDNNd01zTTFDSWxtcTYydFJz?=
 =?utf-8?B?Y0M3ZFR3MWpLcDMxNmI0R0pHK1NNV1ZadCt2bk5lOHBtcmFHZHFLNHBZeUht?=
 =?utf-8?B?QlVWSGpKREs4L2UvTWRwRnJRTk9hOHBIWHBkc1F0Vmdocy9CNWR1UEdFZlo4?=
 =?utf-8?B?cFg3UFAwNWw1NFFNeWhiejZlNEQzMDNrNzA3dVhWQUxXUGZVMXhNMysyT1FT?=
 =?utf-8?B?d29YZ0RmNFlkWHNVMlJBUm5HUDVobE9pL2Vxc2xYVDYwVGRFVWdpN3NJTEpz?=
 =?utf-8?B?Zk5XSzlZU1FHdGVsL1h5NUdmNTZxTHJRUytJdzJqcUdvMVlhUkFmZUo5c3Bq?=
 =?utf-8?B?ZW1VTHR5WHppVEo3SjFvajhYK1hSaktyM3duNEVnb1F0VWZVT013TkMrclVa?=
 =?utf-8?B?RTVpc2RtdUJ0N2VzVDBPUGhJQzEwRFhVcU9reUxWVjhnYkMxRVRjYnNZaGpH?=
 =?utf-8?B?YmtMeFgycGtoS09kcXZwTnFMeHdHWndacm9aOVFwaHBjMW5QVEFuaFVObkFY?=
 =?utf-8?B?MVd6WEVyV2xhMjBNRHRIV3IyN0JVaTNjQXA5Umx3WTkwV1VxNFE5NUUyQ3Ns?=
 =?utf-8?B?dHRKUnRzYjUxTHlRNTRIQ2tadm1iLzVKY0tLUm5iN3A5TjVXZ0hqVWlDdXMr?=
 =?utf-8?B?aVQ5cUxuQUlOS2tCTUR4dU5tbTgvYnF2b0ZDRlFseVl4YkwwWjZCem94c3VO?=
 =?utf-8?B?QUtQbmkzWk04R1pYMVdpSitQY2FyRndFL0pLTEgzWWhySmZBaFhvV2JEbWUx?=
 =?utf-8?B?ZngwdkEzYStMaVNtV0JmdFE5V3ovNUZsZTlJdjdITk1XblJUazF3VHY5bFhM?=
 =?utf-8?B?T0pnODhlbXJhYlFHa2hvcytCUUx6WFlMVXl3MXpWcmF0REk3SWlMRFgvU0Zt?=
 =?utf-8?B?VWhjaHh5VVd3Nk9yVitKWWtGcjdXWkpoTzB5a3RTQkxKUDI0RjVGTXNVRlZJ?=
 =?utf-8?B?WFdnQUkwbitkd0JVR0hwVG1FOWtqblNDbktWL1plR3NXK3lzSUUwZWNEa3M0?=
 =?utf-8?B?SkJCckk2YzVId2ltZWt4ekNoY3ljSm5oTitIS3kxVUtJS3ZIRDdXZ2pOcjNh?=
 =?utf-8?B?VUNtd3dOSkVzb053ZmNCcmZZeGw1ZXlsMWN6UkNkOWVIWVRqOGZkclluNnFR?=
 =?utf-8?B?ZlFKTmZtUDFzRTIvOFcxZmYxczNSWWxjZUJvRjFBV1pHcFpTWktKSUlUMkM3?=
 =?utf-8?B?TUxDUFpyeGRQMHJmTWhuVnNrZ3BnS0VRQkVPUUFaVVVqZXRYdmpWZUpWMUtH?=
 =?utf-8?B?UWpldldpZXVJbWxFSlArcmpJSGxmNk9QVzN3OUs2SExtSk4rYUsvMEVNOU44?=
 =?utf-8?B?dURtYW1UQ0dUSGxGWURrdktETnBVK2NwU2JmUmo0RTJtU0tnUGEyVHhrcEZq?=
 =?utf-8?B?WVJNSFBkQ2lxOUZhTmVRU0pjNTl3WHdycCtlMnk0NENrQlFVSkFLNFNwbWxW?=
 =?utf-8?B?MXdkcTV2YWhCMW41dnlUVzdKNnU3Z21kRUVyWlAzeXVmZ3BZVmxHdldVZXFU?=
 =?utf-8?B?M2lzZHkxMUlHV21XOW9VUGxjTnRpSlNEVTZNN0hrZzgvOWlVS3hkQjAzS2E1?=
 =?utf-8?B?N0FKaFJBUmJXbGdxWTdGVjZrNzhKbVhxMDUzM28xRHhlSzFDTExTcnZBMjhC?=
 =?utf-8?Q?xDtZdtU4R85W7IK/Dzfu+VjFb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 176965c7-a3e6-41c7-0c39-08ddd08c4dff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 23:45:18.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QHXuaDq+zO9koqR19kbPGDfgkCNCXNB56iJz61JJfjB3H1ZwU5AnQPUlJW/fHnutuu1cG+O3lW7+VeJXV72LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6425
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14BAD4000F
X-Stat-Signature: 887cphao3p6iuzix9hi77gaoyyahsmyq
X-HE-Tag: 1754005523-304091
X-HE-Meta: U2FsdGVkX1+HDYVuQ0cfMCP1hdR65cXRgipz/iNjgIoRUHI+NeGg69KaTEnvrNqymZ6XIntPuc42q6QhmRYlN1IR540kerFJoMLpTIug22NByCTagm5cSLVxTGBdrryrb9tIzLs63z6mFvCumNAj/EMSNxofDK5xycUDeA6Pqcr7l74K9L/eJW6hRvR+D7JVOGJWQHnRynBZ7vDcMA4vRQR6OpLRTu4WA8WZMPPKYE0Jx6tq3mqEA0Ir8L5gAbXtSnoEBEUnTnNFCL1Djjfhc3J/DRsrlJwdWvm6NfEOuP7dd2OxirqZEOjlzEsK70FyOCv3WO5R5R5lSwW4P9lxoc+K68N6rvprpSP/gpfvBSqlApdM8fex2bqwlAO+3KF1rpqr35p5de4Uk+fkUT7u/840SVkLqIZehMDq8b1cOS5Sv1ZEw6oHN/9LoDiRgWcBfy75zOCP546U0zTmtiq2LilPgLP/KPGzXmJqd7nH1xmrRK1ahk1ISbTdoHnSP180WIEzYJp9smtlO4sBUUV9Ohh8Dh5/qQ/EKYr4V6PtmYTPHrbI0twNwTccN/duyXGNHKVx9twYlEbaAqXMpaXOyYU1KAP5pDaE4vVHrArUHQYIPJ4acHkuv91O76VmB29eibthvivCo1YfTWgdDFh/Yb3zyiNsoA4mUNLnETDsPsbMDzG2foFsjGqZcJ2s2x0Y6+ZFlBjH8w13xgWN796nHQYuq0LWhJZlVH3XqwgxOLT5IPjfQAAezEUh7GiF5MxLuBYyGEN9XlFWLd2aLJZLm2kYsKzlOETszpyL3ckYmmZq+aUHqtFrCl9O5P3IpT+o5A+mDSZb2DaoRVLfLT9BwTKBadZIJZ/TaYLoqBR3pMl8N0J3xBOosPoSXwDU0I+paqSc941GQaUSDNImey3eNaf6yJHAPd72RBNZZszqp2kHcCZEGbmMR5CvnZT3t5mqkZlcVCNYl9NpQzI8Mo+
 6P+nhsCP
 jl+SKNfbEOzSGs6UuTOY3D7hmZkjuRVoJbbBa1pYF4TVsOXaUVlCPfnXlC3z3RKUEPPzl4kVZTfTHiyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/2025 10:00 AM, Dave Hansen wrote:
> On 7/7/25 01:03, Kirill A. Shutemov wrote:
>> Instead of moving setup_cr_pinning() below efi_enter_virtual_mode() in
>> arch_cpu_finalize_init(), defer it until core initcall.
> 
> What are the side effects of this move? Are there other benefits? What
> are the risks?
> 

Picking this up from Kirill.. Reevaluating this, core_initcall() seems
too late for setup_cr_pinning().

We need to have CR pinning completed, and the associated static key
enabled before AP bring up. start_secondary()->cr4_init() depends on the
cr_pinning static key to initialize CR4 for APs.

To find the optimal location for CR pinning, here are the constraints:

1) The initialization of all the CPU-specific security features such as
SMAP, SMEP, UMIP and LASS must be done.

2) Since EFI needs to toggle CR4.LASS, EFI initialization must be completed.

3) Since APs depend on the BSP for CR initialization, CR pinning should
happen before AP bringup.

4) CR pinning should happen before userspace comes up, since that's what
we are protecting against.

I shortlisted two locations, arch_cpu_finalize_init() and early_initcall().

a) start_kernel()
     arch_cpu_finalize_init()

arch_cpu_finalize_init() seems like the logical fit, since CR pinning
can be considered as the "finalizing" the security sensitive control
registers. Doing it at the conclusion of CPU initialization makes sense.


b) start_kernel()
     rest_init()
       kernel_init()
         kernel_init_freeable()
           do_pre_smp_initcalls()
             early_initcall()

We could push the pinning until early_initcall() since that happens just
before SMP bringup as well the init process being executed. But, I don't
see any benefit to doing that.

Most of the stuff between arch_cpu_finalize_init() and rest_init() seems
to be arch agnostic (except maybe ACPI). Though the likelihood of
anything touching the pinned bits is low, it would be better to have the
bits pinned and complain if someone modifies them.

I am inclined towards arch_cpu_finalize_init() but I don't have a strong
preference. Dave, is there any other aspect I should consider?


> BTW, ideally, you'd get an ack from one of the folks who put the CR
> pinning in the kernel in the first place to make sure this isn't
> breaking the mechanism in any important ways.

Kees, do you have any preference or suggestions?




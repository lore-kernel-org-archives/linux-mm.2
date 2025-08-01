Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978BEC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E578E0002; Thu, 31 Jul 2025 20:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246208E0001; Thu, 31 Jul 2025 20:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110EC8E0002; Thu, 31 Jul 2025 20:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F12038E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:15:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95E2F160CB4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:15:54 +0000 (UTC)
X-FDA: 83726270628.26.80F0137
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5CF2140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:15:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IjXO+9wT;
	spf=pass (imf23.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754007351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQRKYX3t8O3d+9syrjEnB3cbE8GnhqMjzpPxKE5a/Hw=;
	b=icB34KQS3/fRZge0Us5YvBFcjdFrUZZp5hWHh7igzT2VT1s1gZXZ+CXTC9zNtAeyBBI9zD
	tEehd9A1REEnz2acRJ53g+5U5vLVXvlb3UBETd4g/VSo6FKfxa7J4sGXhpKrtRkKGqo/nl
	GhwnS2ipBCGHJCdWRYja+X+PV/VaeGk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754007351; a=rsa-sha256;
	cv=fail;
	b=yBI8+gW66iHeykm/0qHBOgOyZwGBwrCPKT39nlxpzlfDw/Ry+VZs5nU0IQhvtdCwN5XyTV
	cVQjYdltOngjb7UIcjAknYe28mE8bKqwb4oqRY0Nsd9ylVeJRiD6cuyqxPq8VyRB4upoHP
	HL0yFvxg2QRyFovM6nf7H84Pes6xZro=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IjXO+9wT;
	spf=pass (imf23.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754007351; x=1785543351;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qhPX9e3kYoHINzIuHeQu3Bq3aVOESYMnnLdiHyMTu8k=;
  b=IjXO+9wTr+xJWELeMBN7ss5WElfrgcJ60N1bqMECwjCq80WjDb1fPRr7
   O1C0vmLZMHN5OtR3yFWpgAwoHORCkdyKUux+p/Tu4DBFQohS/TCloKiRj
   JqVaaJZLetlhSKhpG4sZGvT2jdYoKLnmmdgdcr6GSilYJ96Qal4cDcasM
   smMc9vGbQMxYxnwwHCsV2AgVfNg7/kydYXdjSz9HmnntB9pFrtwLXCkRz
   IVQjxgxpP+y/+w04clEesQTU0M2l/7KyJhD9nyQS1V7OPsvQwnJOcn9gS
   Hm+uCGZelLIe4bPceaFLbnvIxRnqGg4mhFpXqEIVDiNvRUMSLH8cCm27m
   w==;
X-CSE-ConnectionGUID: eNwdYo5JROyGlbF0nJy0gA==
X-CSE-MsgGUID: M2k7d6mYTOWksTjFhPfnxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56045301"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56045301"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 17:15:49 -0700
X-CSE-ConnectionGUID: qfOcjLreR1SPud1gFsVvaw==
X-CSE-MsgGUID: 18orQi7AT/OK5iY6GR//LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167627593"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 17:15:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 17:15:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 17:15:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 17:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w0+ELVvF3/TbkOrvGMnjD9DdXLDD/otSqz5xr2fr0ov9Z8fXNCwCwmYbN7uN+y1dATjCgFliFhL/6SG7gvS3cLgPK3CSo44LUfEr5KI837SvuyD7Px9wpqApiwPA375yHGD7/ZWcsGhzr4Y76eXFkJC5X5NDbBt4PELUWX25yWRFqEUrdZVrWe1+OvQCwqVkRQe50CP+B+WbBawjAm5m3P69FvpiZ8FVSgakm8WXm/licvwFVLEy/op83SUPCsNdEkc4sNcxKtBQTZDqTaWiSj9WVGyAr+FBZck/ynReZchzSMgIZh5wYccKc9TfYYcHyjqFjMgMQyMvRSCia5TcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQRKYX3t8O3d+9syrjEnB3cbE8GnhqMjzpPxKE5a/Hw=;
 b=S650dR+5oRHtpSjEe3FwODJy4sxVj+DsghggVvwd5aWCtF6/J2fuWTeSOQL0wNxULW3IXQBRDVSjFymzx7rAteAoARQROExq5W04yDjPIf9bv8tgkCikzzXaCq4Thp/nc7dx9Tn6gRFGbwKuXFifP60NjvZV6WtDgq6xRm24r3JIUXnq0SNf2d8N3NSQrnpA81cHYwLzGxItNfJyDkJOT741FlN6cdFs+p09qXItfKrvb4SXpb0vEpqL/OJf4r3U95LC6Ygz/FCBfXxzdJ5fwUfki4pvtwRBkrupc5ql50Axl1yVGVkMjpXI48ebSCVJnJ0VGGS2WD7jYkZtsakhkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SJ5PPF0FD67B0BC.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 1 Aug
 2025 00:15:16 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8964.026; Fri, 1 Aug 2025
 00:15:16 +0000
Message-ID: <96a36e37-5558-4c91-9591-8e5a77dce850@intel.com>
Date: Thu, 31 Jul 2025 17:15:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 02/16] x86/alternatives: Disable LASS when patching
 kernel alternatives
Content-Language: en-US
To: David Laight <david.laight.linux@gmail.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Dave Hansen <dave.hansen@linux.intel.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Ard Biesheuvel <ardb@kernel.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Xiongwei Song <xiongwei.song@windriver.com>, Xin Li <xin3.li@intel.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Brijesh Singh
	<brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, Tony Luck
	<tony.luck@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, "Ingo
 Molnar" <mingo@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>, Kai Huang
	<kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>, Breno Leitao
	<leitao@debian.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Hou Tao <houtao1@huawei.com>, Juergen Gross
	<jgross@suse.com>, Vegard Nossum <vegard.nossum@oracle.com>, Kees Cook
	<kees@kernel.org>, Eric Biggers <ebiggers@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>,
	Yuntao Wang <ytcoode@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Christophe Leroy <christophe.leroy@csgroup.eu>, Tejun Heo <tj@kernel.org>,
	Changbin Du <changbin.du@huawei.com>, Huang Shijie
	<shijie@os.amperecomputing.com>, Geert Uytterhoeven
	<geert+renesas@glider.be>, Namhyung Kim <namhyung@kernel.org>, "Arnaldo
 Carvalho de Melo" <acme@redhat.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
 <20250707080317.3791624-3-kirill.shutemov@linux.intel.com>
 <20250728201137.113d0f45@pumpkin>
 <98BE7799-DA6C-4267-9E03-E6F68263D250@zytor.com>
 <20250728203809.7bebf01c@pumpkin>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250728203809.7bebf01c@pumpkin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::29) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SJ5PPF0FD67B0BC:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dba244c-e98d-45dd-50f6-08ddd0907dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RjU0NFQvUkMxMG1FWXBDcTVnOWlMMjl2Y2JNTGkzRndrc1NuWENqZ3ZncFgz?=
 =?utf-8?B?bnBxeE41d2ZLYTZ2aTRlQi85UUlsc25CZHQ4bis2VXZ2ck43eGlOVTVSVVFI?=
 =?utf-8?B?ZG9vd0xvMC92US9sMDllWFV6MStBMlNPWlEyMWUyNDNTWElkM2tiakNMbFpr?=
 =?utf-8?B?eUg4d3VVUVlobTF5ODFlaFdVQXFveDVqcFVDYVZSWjNnMEVxU2dRNW5rY3V0?=
 =?utf-8?B?bTRXVDBrQlpHVHQzeUIvcFlzWFRIVDhHTnl6UDhQOUh0WVBBZ3NydmVnVjRi?=
 =?utf-8?B?aWhYdXhuK2E1KzNGMERXNC9OOVJOcVpWYkxybENTZERTc1ZhV29Ld2h0TU9p?=
 =?utf-8?B?eWR1eERkc3pVRWVPaERwR1lnTURqUk16NjNmTjAyUjFSaU1EeitmWndXNkFt?=
 =?utf-8?B?MXAraGdoVE9sNG9keG5RRFZPaVh0UG1iNmRDekI1M093d0lHSjRtSlg3b0cr?=
 =?utf-8?B?T1BPYzczeU9tOUdvM2VkN21RYWtDZTNTM0ZoWDYrQVg3L0VnYVhpMmJWYTJq?=
 =?utf-8?B?MHpPaDMwT1ZGUkVhVkRxWjh2bXFneUpnMjNSNDRsWVA4YjRQWG80b1M4K1Bk?=
 =?utf-8?B?NFIwWmhMZEtRVVptZXJwakZ1MHRHRTVGYktxaEI1bUZiM0ROVlNSNlZ2R3JG?=
 =?utf-8?B?aUdZVXhQbis3NHNpMU41VnA2alBJQnpNaXJEZWZGeVNBdXdlYUJGWnFGWVFB?=
 =?utf-8?B?eTdaaVNxSldoMFFIcVgrTGkrdWhLVk5jUkJmTS9ab1FqMjJPem9KMEx5dWJk?=
 =?utf-8?B?VWM2VktWRzRwdDFEbExiUWV2b3lhNEVRV2tLT2k0cnNDaENOUEViV0hxTEVV?=
 =?utf-8?B?SUxzNDJqOWg4c1FlWExwTW9BQjJwVmM2UDErMHUxY2owRzdERWl1WVljdHY2?=
 =?utf-8?B?bUJjVllmUzF2WHZ3V1pWd2RCSHZPcUNHY2VtWFV3NlVRU09CdEVhZWNWU1lu?=
 =?utf-8?B?M0NTTjk4SDZEZEVScTJCbTFoaURRb1JyUGNVNC9vZkRiM3FhVkZZWHZLbDhU?=
 =?utf-8?B?cjc0aG9JY253K1d1RUNyNG1oTlBUbW9hQTNJWEc1VEhYaDBJQlBVVGgrNjl2?=
 =?utf-8?B?OUFCUCtwdWN4WHJqRERVQUwwcExVVitpWk5uT3Z3VkFVcWUzRlNyVDk0VVRX?=
 =?utf-8?B?MEpSWU5WWHdmRnFHUVJKV0g0cVhWVm5RYlF3YnB3U3AySEdmaXlST3lrMEc5?=
 =?utf-8?B?MjYvaDdxVFYvRGNXamRKelJtMEphbUxTdlV4aHYvbnRqR252dS80eXhLZG10?=
 =?utf-8?B?OW4vemxMYWVxWUpvNjRpWUFtajd0bzlicFRpWkxibXZoTktHSXZBZWRUUWty?=
 =?utf-8?B?c2R3SWE3R1lwUjQ0K2d1Qkxwam01QkZrc1E3Mkd6R25FMGV3VHZyVFg0V1Ba?=
 =?utf-8?B?dTZST09sK0tiMmZhQjhvRzV2Wk5lLzZjN2M4ekpZU0hWNllMUWFEUzl6UmhL?=
 =?utf-8?B?Ni9WUTVUajA0cWpWSDh6Z3RjSFQ1cUROeXROT3JjY3VGUlZrLyttY1IxVXNQ?=
 =?utf-8?B?V3BUalMrWHluZXRkSm5jRm9DUXlYUW82VHBNUVZZRUxTN3pjZ3gyQkN3WkVz?=
 =?utf-8?B?VlZsVTh5OHFrb1dobzc5Z2pYcWJZRGo2aHUzMzBucHJVZXFDTHN1QmtPTXJX?=
 =?utf-8?B?MzVPaVprNW9XQXE0TXcrUFBhQnRKN1EyVkxweGozazBqdm44RWJZNkx2cTRp?=
 =?utf-8?B?YTJNNHI5R01pUkV2bXZVaTVYN0lDSUNoNVFoL3piL2lHVGlZaDRLMXRXWmlL?=
 =?utf-8?B?dTI1TUUzKzMxalhOb3hWVm93amFzbmFPNnQ0OUd6dFdLbDI4L05yVXJxcFZD?=
 =?utf-8?B?MG9sQm4xci9tS0JiUGhKd3ZaNzIyUDc5bnEzUGlZbG94Nk1RWTVMdUJsa3Qz?=
 =?utf-8?B?VllpNWgzQld2ajVvVVYrSXVoa1gwTVBHVGEya2kwaGZCNFZrK05KUVlXNUxF?=
 =?utf-8?Q?/R16BJkyifE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTgwRllicUNydFk4Nk5IcExheFcvTm1jSDdXd2lXMTB4aFJybzhlVXNmbHkw?=
 =?utf-8?B?Zi9FZEt5bFNxUk5wTDlWeURwNEZQUTVhVnhGcVpiTVV1SmxORDlLRFN3Q01J?=
 =?utf-8?B?UVFHS09rMDFnejRzSWNlVEltRkZUeTk3R0VsajlRSTJlZkpFeCtLc2cxbVFx?=
 =?utf-8?B?bXVrTklNa2RUcThWSHJOS3k4bGx0Qm0xQVlvd09uTjB1NElwU3NaeHJFb3pX?=
 =?utf-8?B?OG8wbTM0TTA1Uys4QW9jV0tnK0pCeVVkMlBLMTFhektKcTNMb2VaS2xOKzJS?=
 =?utf-8?B?a2N3bmRQN0xxVml1WUdOZURubUMrdms4Q2NmWVIvSVp1djU2Q0dISFRydHhK?=
 =?utf-8?B?cENQankzUTZZaGJIbWxUMjYyREhBZHRKOG9FM3NLTkZXOWRhUlRyMlZJTDlG?=
 =?utf-8?B?R3E4bis4Z0p3TU9DZkU3MmRzN3E3aDBDcDUrL1E5NnhwVm9PNzZWMGd2dzhP?=
 =?utf-8?B?b2k5UEVIcEx5WHRoTjlTTWhoTG5iTXAzS2JTNThudGFPYjJJSDlHR2xjQk5t?=
 =?utf-8?B?bWlVcWRKbkRGR0pTY2tKRDdSZzBjM05TczdpR0JINlhWVkVlckxGMVFwTHdn?=
 =?utf-8?B?VlM5N3JSL2g5WWM3ZUZRYlRtVDhkZUtIYlFpRytwcnNVdU1mck9LMWpBbjUy?=
 =?utf-8?B?UWRxaFJndHZjU2szQzFrenFETzJ3MXgvb3J4VWRsNkI3SjAyV1g4Z2tmc2xK?=
 =?utf-8?B?YndwdmxkV3c3UHMxMGZaYkllRGFYUUFSSEROTytrcUhzYWVvbU03L0tnWms1?=
 =?utf-8?B?Q0xjTmpvMXV6bDZEbjlUaUxwd0gzQTRucTdXRzNlTHQ0M3FzVTI1ck1WMmZa?=
 =?utf-8?B?cmxkTUt3QjRKM21jeVhLQlROeVQ1QWFLZVkwM2N2ZXczcjdtMFR1NS9GQ2JP?=
 =?utf-8?B?M2krdjdJelZjUW9vd0J1TUhETEdmditvR2R0UkFaNkJFNDM4UVhSaXI3TGsr?=
 =?utf-8?B?aUpaTmo3ZXM3VElob3VBUzg0dzh6TlNZa1hBdUJuU3IrTnZaajdzL3NobTFQ?=
 =?utf-8?B?SlovN1E3OXQ5OVhESUZvajRVd2xwZXZsNCsyMCtyMFJtWXVSZGZlazBjd0hh?=
 =?utf-8?B?c1RGSFg3NldDL2lleW9PTWZmZXdNd2dtaVRHMzd1SEZnRUxBRnlnVmluK2hG?=
 =?utf-8?B?bVVhMmtyKytIVzVoTmw2bjlab3crdXJiK3A1V3ozVmJGbkpOTjNZNzcvRUgv?=
 =?utf-8?B?bHdpR2tZWUN0OHlKNHAwOW9DYzU2MlhsYUlzRWk1blE0NWxNSFQ1RjhVUk1t?=
 =?utf-8?B?WnlBYWZJUTRoRDZsc2Q5T2ZCMUVaSC9FeE1OMk5TbWJaUVhtNXZ6WkxMaUlZ?=
 =?utf-8?B?UHdka09qRU9tT3FlODlIZEpnTE5hS1phSGU4QjgwaEVzMTlHZnVrRzZTbC9a?=
 =?utf-8?B?ZnpNdngzWGdaUG9DSEhpOWJ5SUttLy8rMWxFM2IvK3BJYVVBKzJWQWVZUUpm?=
 =?utf-8?B?SU15ZlllUHVKQ3luSGJ4RlQ2ZTdham5xSGtSZHBYTzVaNWdCTnVmWjJuajNU?=
 =?utf-8?B?bmZOdFJZd1VDN1JnOC90U0tjTWVWSGpUWmRoaDFpVWdsSlUxczRlMEtUejJF?=
 =?utf-8?B?bkJxY0p2NnlxRTU0T2dPcmhJalQzeW1xQlh2RFp4QjZnd05jTW5nMVVjL1JK?=
 =?utf-8?B?NEczUXFDWmJEbU5zSmRGcVFITTNZYVh6cC81MHRDZlpQYnpkRi95Kzd4aFpE?=
 =?utf-8?B?cDJuVzZoRXVJNWdxdGJ5NGREVjIzQmN4R1N5elVWb2NQWC9oQTFSaGhxaTBn?=
 =?utf-8?B?K2t5Z0VNOXdFNzYySFVKbmFOWlJQL1poY1E1S0tCcHFhNkZReWNrbG5IRnQ5?=
 =?utf-8?B?cHRtbW9aNFFwMEtrcmVPQlZ4alY4M1E0WkpyYkhrRFZhTWZtWHJzNm81aU82?=
 =?utf-8?B?ZjRpdU5jZ0xPUXgxeTNEUHNMalZydnRzYkZoS3NxbzFpMFVlN1BiODZlZ3Ja?=
 =?utf-8?B?dnllZncwOXp6cmxYc2svL0FQQWpDd3lPNWkrV1hhNUFrdlgwMGJuZmpBaS81?=
 =?utf-8?B?MXp1aDBUTng3a1MwUmE1cUUvQ3lPd3RDdUp3Q1B0NVl2ZUVHNkR3Y2tGMjdl?=
 =?utf-8?B?Uml5REpMZDJsdjExZ3pPb2R1bmdUb3F2Z3ViaEVMbUtuM1VvazV1RUZ2dktR?=
 =?utf-8?Q?juINQ/JtQRO7KjbyylmBsnNOm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dba244c-e98d-45dd-50f6-08ddd0907dee
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 00:15:16.6369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPVlMjmmz/qrOsJduV0ehDit8pkd6fio1sKN/QWD2h0AhBcWc/KM9eoJIpolut77zgDQmvrU5Z+DKRw8sReFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0FD67B0BC
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5CF2140002
X-Stat-Signature: axihxh5e9dz43butafui97c6se3b19yi
X-Rspam-User: 
X-HE-Tag: 1754007350-652935
X-HE-Meta: U2FsdGVkX1+4D/EGP/XT/5BnQt8QR5bLJ1UCtg0FHvZNtxivI7Fdpc4UUk50pdgeLmEt8+CIp82ijx7rTKL5qLCMNtSjn0nPvOv0dOkwcAHnyCLRACROG1zyHEt2N2XOlZ0Imqk0Wd048rp986U+9pPVITyOoiOqK9ooOD3xUr6fM7rBvUHOMyYk4qNG0gxL0CECj+Twl0bpKcamPAJVsxHdOqgRaNbImd8wSR4hgw7e9Xj6t5ax7OGMgD27k1RPcsGOGGpBK0/JDKOh6lUci6fY3XR2SMBCDjjFt5icUSXjrswM4iLkNeq8w+lgjU0xWjQUpHkbnu/uoxXt3wu13Tw9eFn13XzMVZl1FlvdpC4kEGh6ZavtEr7CsFwbDV5nJOKGyqOtV75IsE1yfAWTk6Xj5Mk+nJSnkBoYtrN3cNe5zyEmb5OXIa5T87LuNlBACRUDEgpVUcOlAHWlYB3RABuy1ei2E5HZ/39bSu9sfMAQsbZiisSo6elPKUcR+KotSlAlYl4jSYjmHXzNF30g4UQxZwIxyWi9pllntrz9PZygbkNgjcWwX12v//pe8I0FdwSAqCvTu9fKzw+zgmlq9vQ2K984KZeaAwdLJxK8/KOWDww87zOe+w2X7NAJkGLhda0x68+GO1UUcCNVa6sCV8AnZ2FA627HWbFadVt5WPVi4eadLEhIfGvQWuBcBjcc/oRI7tVdlGoy2syglzoR/8+i0JVgeDsN3F9t+dJTNgOMcUZ9TcAH5N+frV6NC8KdV5H5qBG1BwkV3srVY9A0kkaEke/hsq1VH531O9r+K7aIY2/nRdPPZdPexFIm2PpBFJ4HY8sCQBfCZOz0fW3hGjys3VODhAjXlq1hLrtbH3EFKxunIqXcZfiClPcECJx3BUrQ/7X4fFQx37yEN9mQvltdC8QmSJPV1oTyhxmdqo+Hb0gdce1/RVJlM88bBUxPsM2E7Z9VMl9WhNn9ltT
 LALhqbTM
 4GPSGG2T2btn5VcnsPCMHKxjgx8TLzxqCU8cARXcDkuYRZ0vUFKAXVdT3tsoAXUrmrD1xx8BLRpmlWLvzgx8v0YONedXnBS+gKr2HhXIBAnG27mwM+9d0q82DuzRKksSxQ+qOKpxseQnf40SNGLd2iHZf1tdyG+Bsf1nVpSTu6mFDHh81zp0rbQvcxyn12es43HGT0k+iH7Mq0zTz38q1P5Rt0j8XZANHTgqOhPoP6grYS53an6L8KE4q+YZ52recXLhz8icpN/4GUfX9X/m5dKgyi0zoEzMnzbpHf/pjscRP2N/oMSe+VpRQXJAVgryyagbQbXG/ESO3tNSaEEDDh6r8exgYnUPUp2y98Qu2ueW5nF6j5CvzAstILFRZsgocIRsgQDeD7JyGs+JpG7oIyVFbLnJAFp4F1KBe2QXSSuVhfRBqLGRwRr0rafcb4L9C4fhludkwA/bNbWKL1ndRc6uJC7c7o98PGUENCnvTQMW4lVB3kteT5NIeitSOr4AzzfC/0BhCeB4ssGDOJhCG/8L87hq+SlFgk5BUH0S4TGFdu1saiVsgVTSIDPEJUGLtWsA28tkY/iLuU5jm9uDJjUQsZ+Fm94Rr/wYLp1gU+gOwfjBSoB23o6+FaMG7tHq6w9H+DhQ0k1HmOu43LyGxSQkdwfihOlGlw6eaQgo/IAFRnnczVTbgf2tjz9o/BNTjRf4KQyDXEtkw7I2kgbUyuyT2rBtlv2jfjNoho6ELIPkSYWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/2025 12:38 PM, David Laight wrote:
>>> ...
>>>
>>> Or just write a byte copy loop in C with (eg) barrier() inside it
>>> to stop gcc converting it to memcpy().
>>>
>>> 	David  
>>
>> Great. It's rep movsb without any of the performance.
> 
> And without the massive setup overhead that dominates short copies.
> Given the rest of the code I'm sure a byte copy loop won't make
> any difference to the overall performance.
>

Wouldn't it be better to introduce a generic mechanism than something
customized for this scenario?

PeterZ had suggested that inline memcpy could have more usages:
https://lore.kernel.org/lkml/20241029113611.GS14555@noisy.programming.kicks-ass.net/

Is there a concern that the inline versions might get optimized into
standard memcpy/memset calls by GCC? Wouldn't the volatile keyword
prevent that?

static __always_inline void *__inline_memcpy(void *to, const void *from,
size_t len)
{
	void *ret = to;

	asm volatile("rep movsb"
		     : "+D" (to), "+S" (from), "+c" (len)
		     : : "memory");
	return ret;
}

static __always_inline void *__inline_memset(void *s, int v, size_t n)
{
	void *ret = s;

	asm volatile("rep stosb"
		     : "+D" (s), "+c" (n)
		     : "a" ((uint8_t)v)
		     : "memory");
	return ret;
}



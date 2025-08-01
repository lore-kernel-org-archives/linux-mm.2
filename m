Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEA8C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717B58E0002; Fri,  1 Aug 2025 00:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0028E0001; Fri,  1 Aug 2025 00:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3AA8E0002; Fri,  1 Aug 2025 00:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 329FB8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:43:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5DFC5E37B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:43:53 +0000 (UTC)
X-FDA: 83726945946.24.EA82296
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id 238041C000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:43:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FRe3pL8r;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of sohil.mehta@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754023430; a=rsa-sha256;
	cv=fail;
	b=JHWgzY3k0IWlrzXJMW3ftEorBuF2RRceFCAY1wyNIStURx2OzMrxAdj9Cs+GtbKS3rZ79R
	AyondqOz50NL/3rrmHIVHoIm3NbiSJkphKYUndIdIlXe1Mk7evaw0RfBUdhG+Q+EcO7JFx
	m/wNw2aWh++mnSZ50oAnwV0SjwcnBKU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FRe3pL8r;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of sohil.mehta@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19YNpEghXdQb/1VA//ZJ+kT9yFrIWTCVdYnEaVmZ2CU=;
	b=TrhBpVJQ8qrdh64AUPXxhTaM+u2u+2i7nxukHiHvVt8A2VWDrBTCM71S+v6eRUr3jCllxe
	K8JvCG6eo6U+Gtx/3XcnVV7MNcnJaoBx3izKdPZQy2c/eHmuPoPfdV1LzX55q+J2GswnMm
	gVc0CSp+9LCdd61mOadtJ1LY2xeV1CQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023430; x=1785559430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xiiOJsSd3alnjgnBDPTKh0YDwwJcaaDDIvBS9dEhUiY=;
  b=FRe3pL8rt0/PczK2dRhrVGB1dKWOzp0GZYLvHEvvhN5fXa81OFd7HBRl
   DoDqmfIwNMQiP6xzwORYrtanaHpYK03Qa5R/xdhRLP1QRdPMlAX8uXAPP
   m+Sze+6l6Tn5Co9z/LIm1j2eXBOJOKABg6HLt0xQ9dJ+zx77yQL7/k7aA
   qeMMRlksd/SBCzGq6Mk7i+4lr9rS5JusUQNfwxYPdQTHKvPBDAHgtseYQ
   0N/dC+yRol/NomXNu7w7UUEXk5WUArx04vzE2QE7RbEkLKTmwtiFSai70
   6aVVtv87kMjQqNp2rVAGmytsJghY/HT4Un7WafmQDBF2nbi7i27iovK5w
   g==;
X-CSE-ConnectionGUID: 9eObbI9PQvyrBWnjrj81sw==
X-CSE-MsgGUID: //G9hbMsRuqefXqF5UC4Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="55423925"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="55423925"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:43:48 -0700
X-CSE-ConnectionGUID: w8IpBgGjROmT7weD5p3+dA==
X-CSE-MsgGUID: oGdbMAC4RaKwuAMdYGL2Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="168846073"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:43:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 21:43:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 21:43:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.86) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 21:43:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J43TQikQOjm1iNy2FCvctLiuOg2dwpcMBvOyg/1gpWjVO7+hMQa4N09ISlr8u76M01P/fiWL/WN0AQsBSYHuutrM+zg/aWu0DW/aV5FJD4KqMCC8j39+1qb76LXnqHejMBAHyfg/+Se7cBl5iNoJm5zCNl7BoYCBm903dyJ5j3TKVoKNtVlAl9WpaSR8NpDToONfrOebqPw1PPlkTCW1vRCjgeQXeKqDyM2QgA6kGHDwVfUStvsMnJa2oF1nU/dsDn2VfasSUlmJcTkBbutDVfmh6Iu2lW+HwVv0OLAVBqjeK0u/gGGmQoTOFrrDdeGAek6A8hl8oTeAoGPqPZf+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19YNpEghXdQb/1VA//ZJ+kT9yFrIWTCVdYnEaVmZ2CU=;
 b=M4Tn092q1mP+K2X+Fvckf7Hawr8qehSb8qsDbYPcMoe/k5QoRA5UUF+fmZ0Z84z3OmyNpcrufbheIDVLHVtcXOlPCXAXlQYj/RWkovJ5o/PtN0yxyN47IEEw0Oj62XqdNSQBiQ7LcQueS1ac/ffUMGNbOIYZ7QH0DTI8P4mIU7LwgvhN8jm9ntSTKPDGcEPQV6PE4qfbmP3Gv0RaBH0LjrnlvqwdxT3byUrPCQbVUZSBNCCs36kHJfzNsBK9oDDtmjK5TQi4mzSkcRv5jsUolhxyMnzQCa9hSSWCnuYHsifupNhgETcSIGdpL/EBua+3lQ3ztbeu0TG/D/3eOyFPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CH2PR11MB8868.namprd11.prod.outlook.com (2603:10b6:610:284::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 04:43:13 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8964.026; Fri, 1 Aug 2025
 04:43:12 +0000
Message-ID: <1c42680f-c962-4a75-998f-031008dd8343@intel.com>
Date: Thu, 31 Jul 2025 21:43:10 -0700
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
 <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com>
 <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CH2PR11MB8868:EE_
X-MS-Office365-Filtering-Correlation-Id: 761ae324-91b8-451b-b667-08ddd0b5ec2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SUlFSWhlYXhqanJBK2d2L3BnR0d4SmRWSkhsRzdpajN1aWpkK3NyS3ZweVl2?=
 =?utf-8?B?b2xoZmNILzhjdGV4cDJvUUhCbkVwYjQxSWYwaUpqck9DS3ZOeGlOaUdTbHNC?=
 =?utf-8?B?Mmt6NEV2VXA5QVVvMWRPaERzQmh2RHNXTGpFTTJzY3F5VkVmem5XL3JDRHdv?=
 =?utf-8?B?RXl3S0JHMG5Cbml1U3A0b2tqZjBXV3pqLzlrbUxnN0pRaGhmU0xTQTkyUlN6?=
 =?utf-8?B?RGVJSDVIWU0rQTNJR3R0cXpvUUpOVUtzOXBBbE9XaFVVRkx0YTBPTXhROGtK?=
 =?utf-8?B?QzNhV1BWdWNvZ3doU0ZmN2xDRVBDWVpPMHlOejZwQ1pLUDJxSk1lVDd0VndR?=
 =?utf-8?B?SUw1WUllOEwyWXo4VXQ3N1dmN0MreVVWYjRVcFBjM2pHcWZucytHLzJ3Umwy?=
 =?utf-8?B?RzFCN3JBMXBTcmlCaXlzdWYxdEFxMkRVUUZRb2tHVEtrTXlyVzhRellaU1Z6?=
 =?utf-8?B?RklPVHdKdTBvSlNvQWQvZnJrUnRaN0daVFJ1MDhxVlAxeVQ1MzQ1aW51NjFi?=
 =?utf-8?B?NEJUVWk1MzU2dENRS2djank5QVVUUE5oOVdJTlYwZ3ZLZlNlTjZJOEJ3S3h1?=
 =?utf-8?B?dE0zN3dQa1JvVHlqbzJLQjNncnVuSTUva3dsYTI0cG83Y2RYOSszZWl1Qm9p?=
 =?utf-8?B?MzI1QzdsczZldGxnaEVvQVJWMXlZZWZIc1BiTUZiRVFST0xDd2JlREltZ3JC?=
 =?utf-8?B?T2h4RkhpQXhERFNoOTdUdXpKRnVDcjh5STVJc3E5NWJlZDJMUmszTUxpL0p3?=
 =?utf-8?B?WFJnaUxRTFZaVHdObFdOdWxaRGNISVRXNFFuRVY3bnQ3d1lzbWRKNUF3cXdR?=
 =?utf-8?B?a1hjdHhEcTU4WXJJQzF4NjYvcUI2QURoWWIwVkc4L0JFeC9neHBDSDBuSytS?=
 =?utf-8?B?QkcrUmlyZ0NNVk5ieWJLUjIrU0czRldEbUsxN21pRDBwaXJTQXQweHF0aEZp?=
 =?utf-8?B?OHFNVUZDbmdjMElCR20zMG94VEUvWnQvK2V2bWxzd2dUYWdvaHR6cEkyTDBk?=
 =?utf-8?B?S1JFL0lkWGVyb2dCak1PU1hOVEVaOFZocEp2L2c2bnhrUkx4Z29HK1VqdENZ?=
 =?utf-8?B?N0FRZGl0ZWNCd1YySDhkSURZQVZXckI5TWhNK3hTQ2NRYVBkRXBBYWdscWts?=
 =?utf-8?B?VHA3NldlWDgyVzVmQ2pubVMrRHJLRjJCMXFXNzUvSG9QUFBpYVNzY1hjc3pw?=
 =?utf-8?B?dWxMMWE5TVdOTmhvTVZjQnhkdS96UnRlZGt2TGZiUEVJb21HdzJoZGx4d2lE?=
 =?utf-8?B?OWFvUFVkemkrT2FraWlnUDNPa1I5UDFRcXNXOVE3Rmp2eU1jenMyUU5pLzFi?=
 =?utf-8?B?bFRBdGFEN0ZPSldueEM4RERuRU83QjAramRPRjc5eVZPYkJlNzBGQTRxWHkr?=
 =?utf-8?B?N3F3OGdvb0Zwc3hTTU0vV2dkRkliT3pjemJrek5XeE55U1FFVUc3Zzg5a0lG?=
 =?utf-8?B?VUFmWkZNdENJOHE2bHExZGVEUll2bTRNaGc4UWZEZ1NUZlN6UWk3TlZMNktp?=
 =?utf-8?B?MUNXKzdpVS9YSzBraWxpczlHNTkxTzdOVElUS1V2blR4NWNjNDZlZXhKMVJI?=
 =?utf-8?B?ZjlPdmw0N2QyMHFEenRFdHU1UVBOcVN4M1JKT0tWay85KzFmNERKTnFNZHlN?=
 =?utf-8?B?SWVpSmxIV2NUeXpxMHBubGI4NTFSektJSUpVQ1Y5U0RxQ2tqajAxZTljMmli?=
 =?utf-8?B?a00wUDNzTEMycHp4RGZJaXY5UFBlT3doN2lOZUlpRmZWeDJURmVyTE9jbG0r?=
 =?utf-8?B?QjJqV1h3M2ZGVHovcG1hdEk2OWJSSEp3QzJISytTMWs1dEszOHRoYUxlNHZV?=
 =?utf-8?B?VXRNWit1R0haQjlPRnFTeEpTUG9HZ1JhWWpkWWd5U3RhMXU5bmpDT1Y4KzFy?=
 =?utf-8?B?U2M5Y1FPWnFjOGV5Q3dkRkMrTFhVWU5nSEwrc1dKL1NSeXNjaFZlUjZRN1dR?=
 =?utf-8?Q?bEODAwwY9ls=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnJkVGJEOHZ4aHQ3TFdXSHpHZUJMbDArR09TTXBqckRaR3VhU0NoTnAwSHE0?=
 =?utf-8?B?MTNnSWpWZEpISHo2ejRvVG1zRzVPS1ZmQnNMb1JSZEx2SlZsaVJGZlllUEtY?=
 =?utf-8?B?aUF1eWZhZ1FNTDVYZ1BsR21pYW1hU0YycmRZTnQ4anNFQlpKMmFGN1ZacC9D?=
 =?utf-8?B?VHE3L1pieVJMM1FIQXRXYXNCS1R2alUxR1BhWnNQZ2pLdjJFcTA0blU0UGNh?=
 =?utf-8?B?ZnErcTJzenBJRTZydlJGcllxOTRLWmhUM0F1OVdGdzlGTlNBaG9NVnBFUGM2?=
 =?utf-8?B?L09oOTdLeFhHUHFLRStEYlVXU2hqOThEaXA2ZVJyVVo5SHNJdzU1YWtkN3VV?=
 =?utf-8?B?TnJxRU5QRUtheFVPbDJ2UGExazdkY1pBU01IVllKZmtvdVNOajYzeWxVT1hr?=
 =?utf-8?B?WVBGN3JhVjh4RFZOSmlkZEFXbXhEejFYUjM4clVzWWIzNXZBVnlEQjFwbmJ6?=
 =?utf-8?B?ekZ5SUovS3Z0dXFNWjd6OEdYMnRLdVNZWHlDSFc4eEp2d0JEMWZzTmlQa2E5?=
 =?utf-8?B?L0hVeXhPWGwyR09SNHJ5VCtGQjZ1Vkh5cmdnMHNxcHVzc3NlbVFRZDQxajFi?=
 =?utf-8?B?cVYwdU9PTUxHZXlibS9vdFpjTitLdjEyQ1hLM2Z1YTRwbEZFckJ1aitUZEZI?=
 =?utf-8?B?U3lCNHJ3ZTVuejlkZVlhYjdROXBPbzJnd1M5MlpRd0R0SnozNTB5R3FrTWpx?=
 =?utf-8?B?bmNWR2h6aldNaTlGekdmbnJOVkR5UzR5MTVWNThEVGdoOWVLVHdKTnY2SklF?=
 =?utf-8?B?OWJSNlptWGRoVzh1ZlFpOVVmbTIwQmgyRjZlR1hsS2lGcGZncDdFVWkrWDRQ?=
 =?utf-8?B?b1BldjQ1UWc3RGVWOHdHMkhlWWc2dEYxaWJzMGlmd1NIWWp6SDJqNm9UNm1q?=
 =?utf-8?B?Tk1Ed2VhVHBHUnY5NFRtU0xOT3lXaWowbzFDa1h1OTMzQlg5clJDTFFMN0dN?=
 =?utf-8?B?cXUycUJnMVp3dFNTajJCb2EwOFlPT0FrSWNjYS9vTDlOb2VhZ0RabmJzL05k?=
 =?utf-8?B?alJpbEFrdmUwVXFFMHNFVkMrUVA5ZkpSS0d6N2c3a0hWS0lBTkIvY1hMWGoy?=
 =?utf-8?B?U2JtOFBPSkZjU0RRZHRNSGp4TDBiSVlpZGt3aHNoS3h5ekZsQTB3ZU1mczBJ?=
 =?utf-8?B?TGl1dnJ5cG44TWdNalpUeEhZRmFSdzg3OWlNYU1QRWNuZitNYXlXTHdvd0pj?=
 =?utf-8?B?Z3RNbDVFejd1OXBFL1pzTy81VTdnQWpkUUhWL2s5U09jcmcwVXdJOENYamVX?=
 =?utf-8?B?VmlMOEd4YzV1SXIvVGtXUDVLY2ZmQVNCUlZCSC9XenhwbisvajJtRWRSS3VL?=
 =?utf-8?B?STRNZE9EazZoZFZTL3dBTGVwMFdVakpCS1hJR1dmZVRsL1BCWFdOWk1ZUUl3?=
 =?utf-8?B?dGcwR1ExU0hGVTZDUlpMNFpEUHk0eks4eFBKcllMOXBKM3oxMEFEdTRJRkxU?=
 =?utf-8?B?S2orTGdqZ0dQT3RhaWVJU3Q0N2o3b2thaEpvOEpQYlk2L1dJZGdmcE5rMkJD?=
 =?utf-8?B?K0xXTVZhMThEZGljL3lVaE5uSDJJV2tLcTkyeG9DUVpndDE3a25KQ0VpdWhl?=
 =?utf-8?B?T1UzbGVqbkFLMDFsM05EWDNTWEo2WGMyNHVKdXU3WVhxeFNMOUJUWCsyUWsr?=
 =?utf-8?B?SHFwWEl6bmlHQmpqN1JwSFY0SUkyL21RYXBkNzN2WXd6RXNwREI4SVdGUkJN?=
 =?utf-8?B?US9qd21Dck12ZkN5bWtJK2loTVBMTXZudlN2OHdzZ0FSVjNWMFovN3hXUkRW?=
 =?utf-8?B?TWFiNE5RaVlPcW5Fck02KzRIU0tqQUM5cVFUcy9UK0t4UExaVS9BVVA2SjNY?=
 =?utf-8?B?L2xveUNzZDRrNEVMOGJLazF6R3oyWmxoUXBoYjJSRmNWQnBUeC8reENzVEdV?=
 =?utf-8?B?Y0drQ1pPOWFWSTRnLzhSaFBGWGRUY3FNTFpMVFg5WkI1N3d3QVJrSk5NcjRV?=
 =?utf-8?B?OUZDY0dIdzl5Z2hQY29MYTBzZXJ2c3d5TDluSWFFMlVEVTJUQjRHa01GL0VT?=
 =?utf-8?B?aXRUejdmcXFCaEtUY2FvL1ByRzBCM3VheExQUFFHcitILzRaRjI1UmNHdk9W?=
 =?utf-8?B?T1E4RlFMZFdoNW5ycTFLaFh2bHpiU05kSFUxMXphTjAyRllVc2d0ZFprRFVu?=
 =?utf-8?Q?d/ry3TdkUu0YVQe6nmWyI43R1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 761ae324-91b8-451b-b667-08ddd0b5ec2e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 04:43:12.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojDtIZA/fVUl9dSkKB1QUucGDb/aYRAmL7gcz39xI3EoUxvoHUTKgJq/BAkgqY3FSx3cW7C+mwc4XxyK6TDUhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8868
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 238041C000B
X-Stat-Signature: gs775wo7ixhhqhetsfp1nagd3axw5wcz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023429-923526
X-HE-Meta: U2FsdGVkX18gaR27Q9YkznZECKU7JI6LiKAR9dmUpnTV80Yp/9wLEupETZrhhmOcA3GYLW6qreQXWNb6CwBZ48O4HsjOqkwQS9ImUpYQZU8dqFViSR89gK2V1ADZoa1i468I1/4jTola3fgBNu1K22IywSaXnTQM8y8OMIRP2Wpy+IFGyKCLDuOvQqRFck/eS3e2I9eJisznkq/3Mxqx0/JtWAblhB+Roi0YMFA04tQ0skRxEox6kuqKkpkUhFpVsA9IW/gnuKxyL8YJnogbIb/GkXm/BgnTTh+mT9SGnk/dvncs2eONtBftoGunP0wOBHBuPCNwf6ArtDAEKdBcLATMg8whP2cHqhTsCKEoyScGhumD1aUTqTSrRmQZahFpOmux1YEqKQPfpXpUFIQYKMZdZYRTNOsvk62GF719jkL/c45B2kdvyyNmymZL5DzBxpDILEp+99w7IRt4BNXfRsSZw9nrJc7S/h4GDzQ8RnPJCOq4PrpKTFZMyUqrTHSg2x9D4CQhisOLZx7w4WV55b9NR2fsAIBX2p2I0g652gQojMjkQIs8/MeCSmU0fPe9kXf9sSpGh/0L9MYWcEbuGxGM6kjz8FNKAG/X2CUT+Il2bwkwiC2pkGaVL1Vk256ZGB/SuIXia1BPrxw20b7KVvk8AioEDKXWsmPyLIcj12804wSgMXN9AcUY2opIA+2Kwb8OoN2jo/z4i5Z2LI5rpe3tQB9EcOvx/MBktVE/OeeaHhaOMi6OcKM29TVFlyBH28jwUOhvdL+H9tLRxR2HKv89TLOZoTUog+gzXEXq8a0kBdOrEupuq33cevu+kaurwqk1OD3zo3UMwGxD2uvETLV+T68pNa74Vo5Y7wM/fwBUtxJO644pQVlAPo9GB4oJhpcWN6ZvbTWX3Fj1v4h9HA/0toFYia/dh7LlM0lxSs70OCG2r7Urbn9Z8zjGUJHFJp/d++rjaWFJ4eae1Vc
 LswUcmmo
 5t1FmzId5emgXrLfjZTaUdDCM16MYLCMRAGZc7YS4aZg4ihH/yx5bqL/61DtyGz0RRlSGrCyOYtcAoB03xQ6iQe1ZQlDbSPJhVDOHUSYxKwA5q3jWf6PaUAGfiFj/+r4Y70Qx2mTdP80JZFLiWuMh7EI89C2588L2uCGnW47qpIEGYwn6bOY3VAmPpL5zw/lboh9KE/3Ilx+EXkh9pbrxMLMKfBiK+tBrqZUb3JQ646RB//2KHzHkqpl0kL+axX4Url5MoAV9bBCZFyGYRvJR6kLMw+zpDA1QJZjZNUVAzcZ9QX++oH5q4X/SBShGrzxEtjHs38bOwYkUdxhbK6sloQc+MWvuTCkVkSS/Gm5A9elPhE9WR+mdA/0vbpRtZ7m91ysVOIgPL8oo5BIMEY/JiDKHKsG1O4DcLBNsHcM2ZlTe+/naBqt7piNwhLLPIYER7TQ2UvEauDPyDSqxRwVTO/a04iW0sBkT5xTSB53KkpmIpz9CquslCmxkTzTDzk1qddQzQa7nHab4iK8rV3lLfyRB3PszI2+u8lqvDXs1zmRKcq1olzrS1MZHEYxaRi/kwSnFoE5CtCpfEVNQTHJS+vOIDJ0Io56Dlt7lJuMX+oXKcAwR/CkVk79A2WS8W/Oya2+kEpxTeJ+iOpYSZ3uuZWxvleI1f6fFrnufpF6cJfWqF/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/2025 5:01 PM, Dave Hansen wrote:
> 
> 'cr4_pinned_bits' should be set by the boot CPU. Secondary CPUs should
> also read 'cr4_pinned_bits' when setting up their own cr4's,
> unconditionally, independent of 'cr_pinning'.
> 
> The thing I think we should change is the pinning _enforcement_. The
> easiest way to do that is to remove the static_branch_likely() in
> cr4_init() and then delay flipping the static branch until just before
> userspace starts.
> 

Based on the current implementation and some git history [1], it seems
that cr_pinning is expected to catch 2 types of issues.

One is a malicious user trying to change the CR registers from
userspace. But, another scenario is a regular caller to
native_write_cr4() *mistakenly* clearing a pinned bit.

[1]:
https://lore.kernel.org/all/alpine.DEB.2.21.1906141646320.1722@nanos.tec.linutronix.de/

Could deferring enforcement lead to a scenario where we end up with
different CR4 values on different CPUs? Maybe I am misinterpreting this
and protecting against in-kernel errors is not a goal.

In general, you want to delay the CR pinning enforcement until
absolutely needed. I am curious about the motivation. I understand we
should avoid doing it at arbitrary points in the boot. But,
arch_cpu_finalize_init() and early_initcall() seem to be decent
mileposts to me.

Are you anticipating that we would need to move setup_cr_pinning() again
when another user similar to EFI shows up?
> Basically, split up the:
> 
> static void __init setup_cr_pinning(void)
> {
>     cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
>     static_key_enable(&cr_pinning.key);
> }
> 
> code into its two logical pieces:
> 
>  1. Populate 'cr4_pinned_bits' from the boot CPU so the secondaries can
>     use it
>  2. Enable the static key so pinning enforcement is enabled




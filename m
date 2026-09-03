Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8711C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5016B0088; Thu,  3 Sep 2026 14:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395496B008A; Thu,  3 Sep 2026 14:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236A66B00A1; Thu,  3 Sep 2026 14:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E34686B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:33:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DC2D140601
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:33:55 +0000 (UTC)
X-FDA: 85173300030.25.FE79776
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id D3EBF1C000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:33:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JRZs0Yla;
	spf=pass (imf20.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788460431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVTHG/ft+QQRMc/4yJEx9oY6dTaBHLAKzXLC6ICV71Y=;
	b=PM3qNWeuiMulCjKgJMOwS9nWryRW659wQRfD4bD95cd8c0yn+HaqG6nXcYc7ca/gDZm1iz
	kbZdukMGgepCXo+eXFvvZup8LSbGPM3WNES1s6TqxsWWaH0LfKYiBFV6rnMVXATWQSzCKb
	r4uPbsh7RbUTqfvpR6SjlNVaDTos/ug=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788460431;
	b=UondnIayT+bCw/IVguYeAbMqFplrPcB/w/byNs1ncUvbRYb3/QFihSLyBI6OcXFQI3FLNJ
	VWdj8/piVJ2NKDB3RzJdZSU5VgJNgnL/K7NiHRDQxIpN3G2ArsJlS7UnbMCrjghEQnPgX+
	KL4Qn1jdW609WmoxUofrC72/DI2wpPM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JRZs0Yla;
	spf=pass (imf20.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788460431; x=1819996431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eVTHG/ft+QQRMc/4yJEx9oY6dTaBHLAKzXLC6ICV71Y=;
  b=JRZs0YlazRdQuuXccJ/2Q9PXVfUdNH/WzAEM/8ud594mpUWcVDUTT1zX
   44RpY7L6GipNWF6cEIvgltItbMmzUn/mRhbKQgVXogCPXPHRW9UaCm1VA
   082iCAoC8UBqLbCpkqwYnxkacW4T9nafcmOl9I7445EfIwkDUXPyA7eiw
   TcghhMXNqNAMpx50o7RIdpFYIhP5C5pLmPdJn8thUX6P1lfRBH8xtZ/Ke
   ghzmec9QCajNAwwTvtYskCDNTykzcyhSQ/gRNK57J/DSDZtBSooW8s8pN
   7DNoHbv/skpKtWHz3iLneaR2jXA9QtnC+3s+4rIPxXkZBCBBgBQ3lD5/y
   w==;
X-CSE-ConnectionGUID: ao7whG9tTY6IgD4UeglRpA==
X-CSE-MsgGUID: DSXCHV9wQlaX3LsZmCjQtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88987424"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88987424"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 11:33:49 -0700
X-CSE-ConnectionGUID: 7vJEA8neR22P2LStQDou1Q==
X-CSE-MsgGUID: lJcDUZzmQXWMqz+X7up/uw==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 11:33:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 11:33:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 11:33:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 11:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGaUXtOObLZn7t5mFI/7yEtC5Kbl8n1Kj7RWkRfKEm18U2iCR7Z49bYrCKeA9h4zLCAPiReUb1b0Vbx+Ql5isb72joAlonQC3E+3FGl0Jp48012anh0csMyWG6aDsrAr+5ed+rlSKtGfftyikVF8pHZZFuCeF+5ldZRik/svh+A/V732ukwZa8c1dtDI5jPEf8o5zn1EG1ktellcGzQbjmGslUGlypuSMS0cPjN8898L0nsWkMVLSSuBdNsoiXPPsXZpBRfoRU7ADP3m56hdGb53jFLjIbh3yGRYim0n4HtlWRF8ZisGSPRr8ofJ5Sm6RGsypzhrCW1UrbUe73dTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVTHG/ft+QQRMc/4yJEx9oY6dTaBHLAKzXLC6ICV71Y=;
 b=oNzc/SQhkI6D6klJTliPFfMtXTAbIwnwPhhrp4W3sSw+DhpzDi7oV14Jjac0nhxdI4ciXJ3zpnX8Po0O0hWSTDOv08tk46IX2xhCy4ERTTrad7PzjsYEPxQZ2xFzBVMQGNX+e9D5cbIzACYQccRfBoBdWEkJG1LUcg/knNl182TyrLSDf4SbNpCqIvV6e46gUeww8aRmqk4gMiy0yHVS6PHbIiEB5pvS4ULKGV335WeD69N4D39mO0zVLTPK4/AVH6xs9PZD/lAeaXRYDojiQEBabT7EBYAnbuAjKRQqbtwlWOmkvoKHW/EYKofSXZv90otVloW9NP6ukqv0G09tlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by IA3PR11MB452602.namprd11.prod.outlook.com (2603:10b6:208:54a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 18:33:41 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 18:33:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "vernon2gm@gmail.com" <vernon2gm@gmail.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "kas@kernel.org" <kas@kernel.org>
CC: "andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>,
	"rppt@kernel.org" <rppt@kernel.org>, "pasha.tatashin@soleen.com"
	<pasha.tatashin@soleen.com>, "yanglincheng@kylinos.cn"
	<yanglincheng@kylinos.cn>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "david@kernel.org" <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"tj@kernel.org" <tj@kernel.org>, "orsonpeters@gmail.com"
	<orsonpeters@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "rmclure@linux.ibm.com" <rmclure@linux.ibm.com>,
	"bp@alien8.de" <bp@alien8.de>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Thread-Topic: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Thread-Index: AQHdO1K4MHbba6oaQ0Cd7mC7VbQSrba8v1SAgAAoUwCAAD1wAIAAAKSAgAAJGgA=
Date: Thu, 3 Sep 2026 18:33:41 +0000
Message-ID: <e9c76dab579fbadb156410265d463828d54acfed.camel@intel.com>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
	 <aplfcTfjeQUgnrvH@thinkstation>
	 <314f11c1-ce5e-4b36-b296-0ab742550851@intel.com>
	 <c15c2b17e110782d966751dbf3c487a6db837a87.camel@intel.com>
	 <0b084321-0898-44fe-8c69-7aeb171eb8af@intel.com>
In-Reply-To: <0b084321-0898-44fe-8c69-7aeb171eb8af@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|IA3PR11MB452602:EE_
x-ms-office365-filtering-correlation-id: cadd87a2-a3c7-42ef-0c2d-08df09e9e0d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: Lk6UctQ1OpSYY/CB9CmIH8S6VEuBQFGMurqnzWFXhPNo58YakGX9KdYFhb2U4P0T/0ZApbJwxP0Q9hTkHa+1/6dDvUx6mlGX0OPNHF1tLKkE8y76CSdP8T0fq9tf0sWz2BsDcxILxj1of+jBVkwfEY712RcNcZdWPMUEo0YRDWCbV3Gog10cXIKy7jblbsUTB0dTgSJv2ICulhghvPfbw9hRwxDNiFwmPb8aEC1WJeewidnGVoMUx/GIPyUJO8irpRhqRXQFxKuYbVp+F1Gln4S1UvSxyYVlOh5Yy29eMusKJyPnKN+EaaIfsJeJt/y4L63xX1s/knuvsMqorCDMYQB72Nrs091FLklBhasldkOiSqy9KGSuChCB07wmbDD5Hx7OpIbjy0iYvmO3AAVZVwBEm3M6CDycfV3bUKCKZ+DyI85dkntv3cEuFOz6Tcfno0QXoGQgSWO2Jxjonu/bjkiqJoCdyYIs51zjK8rb8l//jfKXma+YiCYtzuz94zLa7nQRrWavU6Y0PzcoBPAydtWV8HpQu4F2SzbBdU24XKGuMw7s4vvI991SWCJXKiMrkC5W9dMvrq5JDPxnSJ1mABv0K7XUKhVtlaz1uzD6pX5gsShpanPXXf7eF/4XEYTmnJTP/0WA2lpNpylIjw2+z4moemeFwA3+vpwX6JP5A9fy/buwhxG5kSOJoBcNNpFfTADNPtfcqElsYNoyV0h1aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXRmR2VtOFZvQVZqTmpHV25QRlBETlZZcnliK2lOZzBWbjlDcVVGYzkxNU51?=
 =?utf-8?B?WUtJSjBJTVU4SDA3QXM5MEZZT1JkQUdHeTk1QVdXdld4TlNVV1FRYVRrQ0RZ?=
 =?utf-8?B?TnV4eWdxYStvOVVxT0oxaUFjTzIxNzVKblMzcHdQT2tNaGM1Zk1LbkR1cFd3?=
 =?utf-8?B?SWhpWUh2ZlBJOVgyN1pxOU5nWXNUeUlFME1Kdm5vTUhqTGNOYnB2aUlsV2k2?=
 =?utf-8?B?S1N2NnFBNGRuYmNqcDM4aVFpZGVzMVZzdHhRdFpCREFyR1hYcHRNdEZaMy9L?=
 =?utf-8?B?RlAyOCs0Y0I1MldQUUMwcU1QV2xaTTV0S2hMalRpbmwwQ1EzaVpZNHVYeVZT?=
 =?utf-8?B?UkVlaHpTamJOQ0dWUUVZVEhPbk9QU3NiNi9mczBOVDV1dnZYa3MxRGVCLy8w?=
 =?utf-8?B?U0o5WDFPR1BvZi9pSlFkdmEvdVlPRWdRU2cyVUhJKzh0MkYyTXV1OVJDMVVw?=
 =?utf-8?B?bUxLeVFPalVqcjRCYVF3aTRsN2lIZ0x0OC9VUmcySHlhR2hiUmFDOTZlNlZu?=
 =?utf-8?B?WS9LcHd5TTRzVkcyb3gybEFiUHZpVS9CMWFOaDA3aEZ3YThsS1lTL1QvQ3ho?=
 =?utf-8?B?dlVKWWFPS3FaQVl0REVZR0dCNkRuOFlpNldSSitHZENrRmhXdXJwS2t6MUw2?=
 =?utf-8?B?NDdmMTBxVmtNM2U5QmJ1T29nTldzMXhKcndua3dlcE5QL2lMVG8rZEo1dGhV?=
 =?utf-8?B?SHZjV1MxMExLNTQ4R0c0anRjdzNhVnViNDVzelNDTVlUTXpDd0dRUzdIa3d2?=
 =?utf-8?B?YjlXTHp4dVhYbW9LRmR5SFIvZTZFMGp0cit0NUFFT042TjVnSWpLR3IyRDRE?=
 =?utf-8?B?cXgxd0p2TVNWRkVIaTFTL2h0bnZLNVlqa0FvMDl4ZVlxbDN4NlZsMmZnZlI5?=
 =?utf-8?B?SWwyd3dVSU5RenNBUnh5OVIyWXlXbmhmZElkaTBqZXAvVjBJTkM1cjkxUm1X?=
 =?utf-8?B?ZGs0Z2FReEZhNE1VRDRtamJXWW4xNG1SSEJSSFRmNVUxNWM1Z1I0V2ZUMFRL?=
 =?utf-8?B?cEtmZk1maEdMNXRKbnFNaFkxaVkrL1Qwc0gzSTd0eFNBUENZZzNiN0ttanJH?=
 =?utf-8?B?Q0xIZ2NhT2R4bDc1Qys5bEpudnlCaGZzWEV5TUZDUE5zc1Frc294bGlOMVha?=
 =?utf-8?B?MlBnRjV2MUtoWkpNODFyYkNIVlNTM2lYc0tubTM0VXRESXhtUDdxdll4aG9Y?=
 =?utf-8?B?enAvUzZUdmJvZi9EekhVSnNWT2VmNk5DMmZXNkVEdjVnTEszWVB6Y0VGZW1D?=
 =?utf-8?B?WEhuY1hRZmlSN3A4YldRTFprU1pqcUdsOGxuUkg1KzFjY0JMalpyekRON0pW?=
 =?utf-8?B?UzVRbTZXYnZNbHhOQk1zS3FINndUQWhVOUdWU2wwa2JiZCthZmt4RDBmcVpP?=
 =?utf-8?B?dnFzSlo2bm80bGxoTGtEYzV5UTZneWpGRWhHUjNFQjk4eXUrOVFvU3NKSGZz?=
 =?utf-8?B?Ti9uSVdlLzZjeGJTanpYaVgzU21qYXJRQ1RxT0J5enVHZ2VGSGpwRldSSUd2?=
 =?utf-8?B?KzhFREswcE94clZJL250TEFySVhtbHNUZmxXRjhzclI1R1Y1dU9Xc1FPT2FJ?=
 =?utf-8?B?N1V5bkdxWnZNT2FmZTVRak1CeXZ1UnMwYU5EbUtHWVlTWFpYRWlWd1N4eGt0?=
 =?utf-8?B?dUM0eXp5QWs1UUdydUpVVGxZVHBpMVptaUFSYXpZZkxjLzRXdEJKYWJrSjNi?=
 =?utf-8?B?ZkxHWU5ET0x4Zm1WckJnWXJnRXczOFVZZ01KeTNEc3JLaFgzKzlQMlZlSmU2?=
 =?utf-8?B?K0cwUkttZVNVV3J5Nk8wZkNFd0FBU0hUVncwWVFSZFVIczdMQ0wrZGFoWWRt?=
 =?utf-8?B?RzBIb1ZWY1ZzNFdYRDFrT3pnekZKdk42WDlPNUQxYzdFNnVIYityK3g1Y0ww?=
 =?utf-8?B?Z21QQUNFTHA0S0VLS2VsTU5XMXU4WCswbVBJMWhSSXZsZlBZaWJ5R3lxeFht?=
 =?utf-8?B?UGZ1ZGZpWlFNeUNDY3E0ellSWUdLQS91aDBiRmRzaUZOSEFYc1g2bnJpc3la?=
 =?utf-8?B?OUM0T2VRcFpvMzJyd2dLaEFqZHpYZWZidVI5b1ZEQnI1VWMvS2xKVVhVMldn?=
 =?utf-8?B?cnYwUXJodE10LzJvdEVXVVIrRlNhbm9xRVUwYndvb1hUdENack1MMDJYd2pz?=
 =?utf-8?B?b20wL0FNbks1a05YaXExSG01Y0JOZHNaU2gvVE9WR0t6cXpnTlFXVjF1U1k0?=
 =?utf-8?B?TmdvZFFPQURpUVhrV0lHaEExZS9KWXVMeWdtL0l3d0hVOXF4NUM2UWNpb2s1?=
 =?utf-8?B?T3VVSFAvRW1JVy9YVXkrbmFvRVI1dkI2cCtRdWxKSmxaS3VhTFB2dUZmMDlY?=
 =?utf-8?B?VVZRbXVoUFF0V0t3T0h0RGJFNFB1Q2FybFpzOFo1ZC9yc0luVkxOQmxubDNP?=
 =?utf-8?Q?g6ctP4vHseHqYqAY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3452C6F7D37EA439A9AFBD66BE4D89A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: LBmbctGuA3q48ejcaUyCVYVQgrJn4HXUARdgNtYPk+SOfpw2TXb04Fu0g8uaDEx90eFkIWuruUGynb6zEwEgWL0ILE/dN9td60KqeHvi6OEwUoV8LU/J2EkAlTZYUb9UEdUDoZ7fyokLkdOo0bhHZnslBvz5Dq3eOk27Vwm8WWxBgMH3uMo+tSnahVTHWPxyqBEC666A9Gm5bTPbo/KbVp1LFxY3v0xvYjBWvA8FH9NL+KuyymhVTGKqTDBSjZ/+P5oO7bFhR1sHKzcZxQ6o3QojKADVwdPhnLOjpXwigh6zN/YBuaYOgaWbccBK9x1fBNzmkAZx55S+QHrL7LCPQQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cadd87a2-a3c7-42ef-0c2d-08df09e9e0d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2026 18:33:41.3454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: voeHo1CxEKKHG59V5lqJm0vQfIphMLNrOJCM/3FYVFwsf4Nd6cWwMyBykd6sZm3MVO+1wT7d58NCQq1utggGd8wcXo6ugoCRSbc+GD7BuV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB452602
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3EBF1C000B
X-Stat-Signature: 4xx31pu67bxs35nouenxrbstya5168eh
X-HE-Tag: 1788460430-661625
X-HE-Meta: U2FsdGVkX1/GHPAQnaK3x5/wqD1GalCg5VtCo/n6yude8KufLLTR5YJmqokAUoG92uWxysQaDbG1OFIz4X2L+T/6W3wvAkKvgMkLrGNJKcRO9fJHs1t+eBsJ5x9KeaGPF80liyfdEBk8dyupHd5cScyp/RhFq8kmJhH/LxOfchUoNPzKS2Bvl1VlO0hd/87dcEyAscLJhCxeN3n50RTMA2JLnByg1zpQVQvWx8HMm2BWgEbfc2B1VNUEMBL0+pibiwzopglvwlyttAiRJRpV7vFBDeSggHJ3oIcUB8YqvOzLkfppIhKMaYWtUKRyVysgqxRsVMor3RIaqdSWu5PXCpXaAmCM+1ItjNXm/WySHhPJ5yOI+A9VN7AGig3rWPbvZvl+xmFH7U0G82xvEj7jOuE3PRt2EEIJ01hDB3EnOkpjejXuEiIJo0y0l99VjlPjpnMfhYkxHePIuzUC7kkkCNHwiUqcTAv7+YfoSWx9Txe1FGhnrYo+RVlGOfMO22fUKEBWEp39HOXbckqNp3FmarPVe3CEMRqfjn3xeAOBE7M+076upt4ZYZP01k4HiqG+o7TEENmVite7ycdkajKK0PU+wE5Is4J6FFM7oUxB5ODRD7Bahl7r0p5vwWla4ov5DKhwUwWxOjGNmUxJb6vk/KKSnzd54arMafVHOS9ozZMid4VrU221FUaDRma6ut9sfYAFZ9jw3TN6w0WtiVi9TCL8lp9OKY/AggZpsAH0LEMtHQh7k7LG3nutXUJBCY5XeZgiwGymxCnHjinqv2vYwUGzDtu5f6hz9wL7c5HBtZH2jYeINbtcmO5FvVfRE1VSg3RLBQkAysqiuEO94fR3rwqYs0mwh11zcNdwy0V3sa1v/58HQgf0FJ3P3GTx6ESIH2SK+oMaKPf9dw+eA3nCiwWfHmHVAPZoIcvggd8O4j2D4Yz6a5ybUPOH0KxhOVEopBoNEVtTUDbJ2m5xblC
 4xb7ictd
 5f/hS45b7kdD6hXtKxier9nna78Gr7kjgbqixtg1LjVAhMObmrPzL2BCuKauZvi++DMdDnCtI0DWH8OePzr4zr/60XS2OKt7BEUu3YUh6GhPn7gzk/lWDFboua8KUaVXPOW7+01TNevspamqHt4FVRgyweZhN7bmlPaIxs34BKddb7lF4v14GORYGP7loG9WT+iHTpA4SUUb0Z3o9uYqamFGaZyly6IkHp746idBnfytIcWscqAajPsIpC+LMWuXFEQuqSZ5vi+rLL7bK1Osv9KPyFx8Cetm4ASnz+cLakQR9lCAcuuGBboddVz57hGVb6Ok4d4rp2XoukogWxdWFYkED1sFqqhdRfhy6hgoid9zv94UfyFV5Zmx/PtqAEioV7zj2YdNDfniymK0Oo2V8JqjL+v64uPtWOZn2R/Rc3mpz8XajPgnNVAojN0JS0tJs2wdQ+nEmJk24+w3axOeMTfMKS7RIrDC4vzNj/9V8M6tonFpAByd0bGuKZpALt8cCHI6hrX1m54EbgUnxrGZuFdmblFMd8wj1RZsAlb+YsaV4yElYpr6OnDgmr05DpYYJD6tmn4jnMD47kE9nXZVWiyyrDRsF3qT6HcVa3sfm9ZWKb4oG+zkEMkFD9i2iKzbgj2JqfizPDUWMPfu856S0d/V6IMZzUS4iW6YDfhzpRy0tXIvoiHWzJk0fAPw5OaAUmxN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA5LTAzIGF0IDExOjAxIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8zLzI2IDEwOjU4LCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBJIGNhbid0IGZp
bmQgYW55dGhpbmcgYmFjayB0aGVuIHRoYXQgd291bGQgaGF2ZSBwcmV2ZW50ZWQgaXQuIFRoZSBi
dWcgY2F1c2UgYW5kDQo+ID4gZml4IGxvb2tzIGNvcnJlY3QgdG8gbWUuDQo+IA0KPiBJcyB0aGF0
IGEgUmV2aWV3ZWQtYnk/IDspDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5w
LmVkZ2Vjb21iZUBpbnRlbC5jb20+DQoNCg0K


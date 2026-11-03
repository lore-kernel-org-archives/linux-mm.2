Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162C0606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lWTMs9IG
Received: by kanga.kvack.org (Postfix)
	id 211BA6B00EF; Tue,  3 Nov 2026 10:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19BD66B05B1; Tue,  3 Nov 2026 10:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BDB6B05B3; Tue,  3 Nov 2026 10:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C687F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:50:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55961140482
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:50:13 +0000 (UTC)
X-FDA: 85394244306.23.1F6C53C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 081AAC0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:50:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lWTMs9IG;
	spf=pass (imf10.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793721009;
	b=I/p/IQ3vnPnI1E65FgDqIwi5uMPn+XC7sdLAWuxe9sit8EkeRA+CWD7YAGVKqM4bbnYach
	jIYWds4ou+lGbbXMk/ywZxqOuQY7SJDrCSK+egOye1VBZ/MBb95h4NOty5UNzjnWCaSEBC
	aIcRaS7EBR+09FetUHCtKnmb5yIzyIc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lWTMs9IG;
	spf=pass (imf10.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AQtpdmbC/5712jQGLkTIYzOxhRwpEl7qjbwqBOqUoY=;
	b=KyW4ocwFREr/SgFvEhwv6nujWxWA4KW11RGHUFD7T8rAyXVV63Aa1/41KnbYgi4Oci7qIe
	O8qzoXC6NwXfKQTgcxfG+3SYSfcow+G33dLrQFjXuTe/Y6q29a/+oz8iZffmsLkJSElcN2
	llzLthx9bNCHzOpDhPxn1PcI5V6QU5w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793721009; x=1825257009;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8AQtpdmbC/5712jQGLkTIYzOxhRwpEl7qjbwqBOqUoY=;
  b=lWTMs9IG7RopNz9qly3lOPU9LEeIBAZmIS3qFL3eJAaOqSYdeGTAPYaP
   SR+S20sODZ8YhtQelHs1ArTBUnRF/7/NDJG9xKPtMJ/9scQp5/0xtKwsj
   F8M47TlpKIZx+Ov1gX+HUsWxoSYcSsPBULzlaaZtUhNtd/52Pgu6ZwOMY
   F767kvmTml9SKdrRCp0B6AGbdKycxmCRPyIUGq/SWc57x1CUT2/1EMJrL
   jdIo6cq6GDM+9A0UVWQPkD2gPvcEuiQyta9Oi+t+1/lUaidYsOOVmSlAs
   bZ/0t+NwmUi/yBPX5v1YwJF37yZJ5vMKE69gyQ6qZ+rcAJ23/gTq14SXT
   g==;
X-CSE-ConnectionGUID: DWy6Zn8BSWiFfQkQa5hWeg==
X-CSE-MsgGUID: UwfPRdfqSBmEabGHpYcYhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2330386"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2330386"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 07:50:08 -0800
X-CSE-ConnectionGUID: PX0/GnnPQpePNN4LEUmiNA==
X-CSE-MsgGUID: ULMyKlVcS7K782cRXJrY4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6540527"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 07:50:07 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 07:50:06 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 07:50:06 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.67) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 07:50:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJ7spnxfbBS1eRYxzOOXJtLkNyL2Sz3Oj4bt5AmNf9+xXXA2vF2mlr6S8Q4Z6G+A0sbHXPz21IkCtAN1laCFgOGT3lTzXEm7qMIAsiTXA3HqOz1vM0/KG2RtMOdCoyjxETtwj8QUQ6UBcMMtLeLWAT+8KGNIRbWA4JeTrow2tRi62Pjg3WxbfUOo/TJnwimZi62GIjDd0O3brvyw5pZ7l3CSICw7HpH2/SOnCxByF4GPrW/48o/XJzIcdCeMpy7RDyi7hzKgLboV4kcBWRhGOJQyc9Ogdzr/7D6Lz11TowU6II/4QEFppj/3i09q8fFDYilf+5p4Z9iwinqt8CVZ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AQtpdmbC/5712jQGLkTIYzOxhRwpEl7qjbwqBOqUoY=;
 b=m/+A7xkGkk+j/jPx5msy31OypO7Wx5mpyxkHwEs8mPj51NwIoKZq/VtKnFrrvoJUQbnUjfKuL6JQM+vAhtco5QvY2WxNeLPCuTbJuGumiKodXghqTemu5eS3bVGtjvSH1ZOBPcjWuN42lXs5h/Ax3KFRA45UQ+trxPiZ5LF/rdEk1SC4G/ZHNn42Vl/4UNyvBopsLXGgHzJLC5pL5QeiNKr7lRKOWA5B6Fd7z6cgs4xtAVBu+CwPOTSH8GeP4YkOJhf5u55K0yxupsW2IduYKdaDAd89WLKKgBHTiERtr15xmJgg20K2gdRgAqad7m6LUkkC2Qo+Xli8m797LL/uOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by LV0PR11MB242363.namprd11.prod.outlook.com
 (2603:10b6:408:602::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 15:50:04 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:50:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>,
	"luto@kernel.org" <luto@kernel.org>, "pasha.tatashin@soleen.com"
	<pasha.tatashin@soleen.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kernel-team@meta.com" <kernel-team@meta.com>, "david@kernel.org"
	<david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peterx@redhat.com" <peterx@redhat.com>,
	"tj@kernel.org" <tj@kernel.org>, "azpijr@gmail.com" <azpijr@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "rmclure@linux.ibm.com" <rmclure@linux.ibm.com>,
	"bp@alien8.de" <bp@alien8.de>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Thread-Topic: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Thread-Index: AQHdatgdOWG1gcUTjkG6z8ShoYs60bcbSCGAgADaLICAAF39gA==
Date: Tue, 3 Nov 2026 15:50:04 +0000
Message-ID: <b45fe4c2a730a23845a36b5beba4f434c7be7477.camel@intel.com>
References: <20261102144001.342837-1-kas@kernel.org>
	 <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
	 <aumzjHyJsshPJBUI@thinkstation>
In-Reply-To: <aumzjHyJsshPJBUI@thinkstation>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|LV0PR11MB242363:EE_
x-ms-office365-filtering-correlation-id: e50cca75-7938-45c1-cd8d-08df39c220a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|261026121527099003|261102123227099003|261021121427099003|56012099006|11063799006|4143699003|6133799003|10067099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: Ssz6TOudzHql+HGFMj2K2n8+Uiws756e3AZ2eE25ARFF9e8Gyan4rWx5RyFu2h7xU03CgKP9BCH8JW6NOP46CFtIE+1TxGf7Z1QYOt26xmoqNI/9Wr+u7WWv38uLkyXxa40Z0WeeHBXkBA550oCYAqfK6AnrjuP0JGuf9Dn35PbH/R6k0t5+Y7x8CzUuMXvXeYGq/HPZnwkq+shSnk4ltu00iwZqmpk8OjZKQBqFCGNYlgPceyoebeKNGkEKur7WOaapu64OcO/CJIqcYzQt0r68/gWDtWMJAgh61UgkFA6RLVovEdABcc+QBd+H0jJw32MLb1gcwiUhuLeuGrMiyiVSbxQJKWbBeZTshMBctQG7V2b3M1f4w8U1WGx9DrchVNOaBefnZnbmwlGgrABlDM4Lx2pRwRE5W92TDW4oWUGwA80BgLI4ME/nmkLARGEdP93+O8s6JaBq5RkOnOHvxPNir22VhvoEPbRxDe+ZBFhM6G2Lm5yo6SZ0rk1kF2UmcUTLcgaw01CrZDgDPxxav73+fvGDHDf3q+mR20WBYLA6aIYanpU5sjxpQ858COtaOTh2QinFMpvF3bGeb5cEMKZC4yyOvmLmdQWgD/HeZZYmce4RYoSDdpXz/ZU7rVavBAG6piwb2jHdt+sJAsL9nMEhHYFm+VrV4M0HFgIS7oGOYeOUOFa2eqSA7N8aC8vmP4Z4Z/42l3/70NikQzTKSALU9Zd/NONFq77rBAKIhuQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(261026121527099003)(261102123227099003)(261021121427099003)(56012099006)(11063799006)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEtyelgwc09hN3RIWG1tdGdJZEdTQUtSUVVHQlR2TStHTzNLUEpCdmx2elN2?=
 =?utf-8?B?R0Z1cEpwRGg0U05Wd0JVUGN2dllMNGZjUkVhTU9zRWVqOVlEbHZyVCtNZUFk?=
 =?utf-8?B?RThxdDZQSkswZ3RZL0hyNklJNFJCODZmeGMzdGp1WnpteFlhaTVZMXAvRHBx?=
 =?utf-8?B?cXBDWFNQWXhoM1M1bGRYTjdYMkRkMW5Cdm0yckk2Q1hncTFNV1Z3b1VNZmRa?=
 =?utf-8?B?TFluTGJRT1JnK3dEYTlwd3k0Z08wZTlCTTBiY0UvQitrcjYzalFjMEVaR3po?=
 =?utf-8?B?dzNKcGJuM3JORUIyVGxnUXcvalJqWjJEY3U1Njc3ZTNzNFlKcnltTXF4eVJT?=
 =?utf-8?B?d2RjZkVNQ0xUZVlaNTlLaW93YmoxenNBZi9KWUtVWklGQStQbkNKU3ozRDVr?=
 =?utf-8?B?VzFEVm1LKzJXQUhVSEVvQUF3QkRQUWZOVHhycXFjL1M5NG9pTGVudnhqTFZj?=
 =?utf-8?B?TmFNaER1OEt4MHRRS256N2ZlOWFBcUdZVlIzakxYYS9pUndnMlYwUlJDa0Rt?=
 =?utf-8?B?QjdoaEt1OGZpSWI4RnJ0ZmFMdlZZc21pRkh6MmRyaXBINVdEaVVtYTZpeEVn?=
 =?utf-8?B?cW9sYUE5U0lzQXBjak1URFhYNkFhcWxkS2xUVktOSGhRTnluSEtScy8rcmRv?=
 =?utf-8?B?aEluckc1cE9TVDJZdXRpekxVMDRQem9IcVpsUzF6R2ErOW43ZnFlclBGdzda?=
 =?utf-8?B?bGk3N29vc29RcUVOSzNYaUNQa2E5VmJ2cUJTcG9YTnZoa0Jlb3FCYWFtYUlm?=
 =?utf-8?B?TDJhZjFTNnZXMGFZM01OcExqUkVxWmNFK1pIWmQzRy80ZzlUMmJHalJ5Z003?=
 =?utf-8?B?RG81a3dUZ1dDbHEycHF4am5VMkRjSE95UlBLN2pZMjlyeEZkemZob2dGOTJU?=
 =?utf-8?B?V2wxR3owQVpFY1ZlcUZtd2tyYTJ5UEttc3pFNmpDeFlTangxS21zTjFrL3I4?=
 =?utf-8?B?VmFCdnFKQy9JaVFobDVNRkkzYzdjQkcyOHJsc0wyQzl2c0t6NVpyaXVMNTJ2?=
 =?utf-8?B?U0VVODl3bFc0WllyY3hTSGx0am5FNER1bHRtWldWQXdSZ2xBeWRVNVE0eFF5?=
 =?utf-8?B?R25iMmJ0SUdyN05PNFJWRlZnRVFvMVJUaTJyM0ZRQ3dsRmI4ek5ZUXltbWxm?=
 =?utf-8?B?QzMzQ2FqY3h2bXpLMkxDeDR0NGJ6dEhpbjhhT3plQTh4OHRrRWkrSzFwbndR?=
 =?utf-8?B?YjU4ZnhFYzlLVTFLV1F3WklaK09QbmNCc013Wlo3d2pkdWlLeWRFWGR0YjM5?=
 =?utf-8?B?dElucnZNRFlWaVdiaDU1VkpwVmdVQ0FMekY0NTB1bjhhTXE1bEVKbG9LU3hM?=
 =?utf-8?B?aEJBdUVvdEZsZDh3Tkx6WkRhMzFFYjAwMzBLeC9iZkEzdGRhNkI5cDNiSXpk?=
 =?utf-8?B?WlZ1VEtPVURwd1ZvRXlvUU5vZVhHV1cybTM2U2llWTJpeFhYU1RFVjM3cDNk?=
 =?utf-8?B?N0RUT2pWVmtMTjVKcnZ6MzZpazJhYWZJMXF0Uk9ySlIvazgraU0xU3UzTzNM?=
 =?utf-8?B?Vjg4b2VTU3h0bndoUUwyaHRtKzI0S0hJQVlKMjN0eVRoQm0rZ0dpK3hqeVRD?=
 =?utf-8?B?WUw4Z3FKMXRya1NlVEEzQXNjeVFQSUZQSFFJRURsQTMwSXM4a2kxNy9zbnla?=
 =?utf-8?B?VHFWdzZjUlpqSGV3MEh6QnlLQ01VTWtkVlpwODdtc1pXM2hrVUFOUXhYNTFk?=
 =?utf-8?B?QU1KMzhxUUp1eVBQd1FBZHlwbWN5Z2dpUk5CcG52eTZmL0xtN2ZGVGwrdktm?=
 =?utf-8?B?TUR5UGQyY3c2TXBuSTIrcXBydEJRRmthd0lxNVN2NDc3SUg4VGlDLzFReC9m?=
 =?utf-8?B?WWhPMWFpdFlWUjRWUms4ek1UTld2QlNqbytxNVRlcnZkWVFWODgxdXdTdUl1?=
 =?utf-8?B?TWZZaDBjdytKMnRvbXNFZWJ2QXRTcEkydzFxd1A3WEp0endtaFNvanJWRHRj?=
 =?utf-8?B?aFZCZFkxdk5GNy9sZ2YxaHlSNWV6R3lIQnNqR2oxUytpdnNTMjhtOFpkcEx0?=
 =?utf-8?B?QVNWV2J6NUd6WlZhODd2dU5ZRzQ0ek1hMXBGd1RjeWQvY1p1SXVSdldocGc0?=
 =?utf-8?B?QmZyVTRQa2JMZUNpYnFoejh1UzR1aGtxdFNCUDRPYVpZelhyNENYY2VvaGE0?=
 =?utf-8?B?SnZ2aXhZT3pIenE3aCs1ZCs1cDFsblcyeVhFS3JHa0FpaXBRdEI2R1lndHVH?=
 =?utf-8?B?Q1BEWi9maGRWdzZkOEZMU25LRElmU2xWTC9mNHk2MUxLR1hReWwzaStyS09p?=
 =?utf-8?B?ZDFUSGhxbDlMQnlzYjUvSzRuc3JOM2VWamlQTVdQUUExU2JpM2kyMVRtdzNh?=
 =?utf-8?B?TVNyblFyNC9RdXgzWUlwZjlkTjVXUVZaWDRCYWVNbHhHNm1vUW15UjVNZXMw?=
 =?utf-8?Q?HsCR9jPK7woH1QIA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5BF12A55932124D8C511F5915F5A1A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: oVN33P6XlYuURcHme4QESLaIFvNchNvfK/pix78JL/H32rfNQdK1OnZcahqYBYLsM6KJZmi0PMPJZamtWfwk8XgR9sJIB1ICLOHWcMJtnbrS2AJV+Zh0Ie2pfhjgQYexWvC5ggHkphOMpmBC3YvXiHDAKZdCo/8/B9Rbj8tW+ERjithinWpXWIIycWtWC5m8px+89QZ7JoBqnA9BK9CamGUwqfmhQ0lxSyGzmCXCjGLm7/GDCjJy5qxgE2KaSQWvm1kKvKFoPEZXLXWK0OwZTNiWhEXlRHxLg1IpO6jz5WcJePf9QAZhoDEePpYm9Q/l8fPil7jAiKp4V/r9x30kEg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50cca75-7938-45c1-cd8d-08df39c220a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2026 15:50:04.3867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NwdEREj1f6bCA+xaDHmPNzT27dWi68jYeXtVHhBmZSDTT9WQhB0IPM0SEoySS/7CY5bAIqOYanR8S6/RCo9ocXQ//nXq+wUkzJdskUXTWrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB242363
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 081AAC0007
X-Stat-Signature: uyi555pwsuso5pemr3ew6tkim1opo9hf
X-Rspam-User: 
X-HE-Tag: 1793721008-964730
X-HE-Meta: U2FsdGVkX1+AHRTJTb5wYvRgziIIhvDEuhB4qKkI+Z3X8aoQBL9JnKHef/2XLy4A1pbCmcUlDjQPux507qGqhbLN/qjPq6rOzbsv/suJI/UlY4P9M3hnNXmYzxF6JsBR7UG7NaVNJLP1XROtaSK0fbleE4iuXBK8jE0hDjo8qGtTExv9ryfpe61m2IW6U7yz/t2nVAxITGCtjQT0EwyWNiXNQuR5k1CJUPm/BSUvPUdQ1iEC5S6bI19ccIxeQjQieYcu2rWbfTRK8Tw+wUv3EC+pz8Xq3uKQWJqYT53U2Y0s1EhLF3WpVedpB2+e64kauiZmx9e/pWfZZBAT+zc+2iBMZgk4oYUbyxY93jw/nXWvIzNhXLySRiuBiSwQIYQ3Y/NBCS9Qw7hUmYYMDH4w/NwnKrytFJDBJtT9uKw6sR4NXmTYljSVLCJOl73AWyJoR2bFhkg0HdJfw0DxS8TAHgy7VPd9WA8sJ/SlHBgcUcvkY6sbyyc0NjK8zFzMWu4rqho81jkZZL6pQws5CSCWDsF9KcpZo+TLvqdQuojW1Wy38OeV//5bdSEHRQAWPenLWe4VkD+OJ03msFVP8FW/CqgFZe8ZWno494SPkO06laO6UqGyNHmgPBdRx4qBgNAI/HYVBCTlT7KCwVV13Jbs3lb1ICQG0aDip7junkL+eiD7WcxjnzMRQa4CdT6QJvcD5kxiFwZ2JELl5w1uAQAOgxjmHZM1ZZJFfoLrQOs6IGRF1otmITnqSqCaWMGxyg5/+XqfAEx0XTY9b+2VuQ+kvHWmJAENj9ZvJ1ZbHWHUBFeZuOASccN/KYfSZULifhTLeuqej7pQ+N2f8QBSGlEGqldjEsh0347O+xe9/a0dKuZ//VERSC6ZsmBS27ZFEC9RkvNrUKP3HIyeO7o18/cMsyn4tDM/uB8NWH/OhxojCOuoTJL1W5H3Nyo2/6UckXg1PzCKQNg0L7kQv36l7Jm
 mMVuedRV
 ICJha/suIkww1oPM4nJhhrD26aMgTGgmLhMHU3+UaggSXsBF1gVkoDeg//QYIDCD8eAP5wiXdZlrcQu+ESWbSg352vUHAZVDF0ubPFQffCZXmG62QahcFgsVLUB5SBeKbG+u7ssX7pJ4MjM2KAjz0sHe44wNticZqG8jPIze5Lz2v0KDyIyIX279llB2M1Nl2R5n7YLJpkXclFkAaO/Pt+3Uct70AxYNFbgb1GkiRG6F1rBDrr86KvbPgJi15BCk5lWLXkXr3bbvls3SFoO8xLgfkshJRclTTllmMPGiKDuwdPskv2EhmAYQo/7CSzPPh0iJirxR1/h5pqca3vfQ0bN9mJOktBqlNS0WgYrEkXQBUdJAH6L/BL0asKudap1DbUlPmu4+DjHNeS3oFhSWsQm3sfV9jk7Sl+/UHFdXkowPYZJFBIQgzexe3DASP/OYehUYy0o2FjgT7wDe5ke9IgYo0UhST9mF7aA4mESxpvXOwvEVSQaV5FtYsl0mMMYZuy4cQTKstVX6F6DL+1mPyW/aaZ2A/1YU1c9TxNoF3XwKjJgyon7M4Bh4pAN9g0ElAWGtYRHZXl1rOL8XvZU2mQBjXp7KGHxDCYRpTX+FnAjswD4YuM5fk+fJ2uNUK7/I9+tXidPmqfnLxI6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gVHVlLCAyMDI2LTExLTAzIGF0IDEwOjEzICswMDAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+IE9uIE1vbiwgTm92IDAyLCAyMDI2IGF0IDAxOjEyOjQ3UE0gLTA4MDAsIERhdmUgSGFuc2Vu
IHdyb3RlOg0KPiA+IE9yLCBoZWNrLCBJJ20gbm90IHRoYXQgYXR0YWNoZWQgdG8gdGhlc2UgY2hl
Y2tzLiBMZXQncyBqdXN0IGtpbGwgdGhlbS4NCj4gDQo+IFdvcmtzIGZvciBtZS4geDg2IGlzIHRo
ZSBvbmx5IGFyY2hpdGVjdHVyZSB3aXRoIHRoZW0sIGFsdGhvdWdoIGFybTY0IGFuZA0KPiByaXNj
diBoYXZlIHNoYWRvdyBzdGFja3MgdG9vLCBhbmQgdGhlIHg4NiBoZWxwZXJzIGFscmVhZHkga2Vl
cA0KPiBXcml0ZT0wLERpcnR5PTEgb3V0IG9mIG90aGVyIFZNQXMuIFBhdGNoIGJlbG93LCB3aXRo
b3V0IHRoZSBGaXhlczogdGFnLg0KPiANCj4gUmljaywgYW55IG9iamVjdGlvbj8NCg0KRWgsIEkg
Z3Vlc3MgSSdtIGx1a2V3YXJtIG9uIGl0LiBUaGVzZSBjaGVja3Mgb25seSBjYXRjaCB0aGUgY2Fz
ZSBhdCB6YXAgdGltZSwgc28NCml0J3Mgbm90IGEgaHVnZSBwcm90ZWN0aW9uIHRoYXQgaXMgYmVp
bmcgcHVsbGVkIG91dC4gSSB0aG91Z2h0IHRoZXkgd2VyZSB1c2VmdWwuDQpBdCB0aGUgc2FtZSB0
aW1lLCB0aGV5IGhhdmUgbmV2ZXIgdHJpZ2dlcmVkLg0K


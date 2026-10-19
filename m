Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12805606A326
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TPLB/Tom
Received: by kanga.kvack.org (Postfix)
	id 0F5BD6B0338; Mon, 19 Oct 2026 14:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CCEC6B033A; Mon, 19 Oct 2026 14:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF836B033B; Mon, 19 Oct 2026 14:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BADEF6B0338
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:22:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 381DCA0785
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:22:17 +0000 (UTC)
X-FDA: 85340195514.14.EC6F175
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFBCC180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:22:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TPLB/Tom";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tony.luck@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792434133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
	b=Z55tw+oH2yjfY5QTpW2hTd9hDXqkydNlUoOOBhUfQX697gnIpCnRHWlS/XLzJ3Ch8Film3
	uj6DoFhLS0wIkS2Yn3om9VglpceAehad13n8lCmaIxJpB36MAhcvJnSKP1GM7RuwaSr3eV
	Jd/CR2TOqIAWNZFkoObUuLTs0Z3H6Yg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TPLB/Tom";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tony.luck@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792434133;
	b=gNAG39Z/ezCb7r6dpa7GlUZy2MgmeldEsjR/wKyfRfGbEYCiiSlx5TSLCpvtio6A4gD0hy
	R3lChVahwFdhAS4lSoy6NnjGjcA4oidvPaHzwTPa61GapS+U4wXhvWbzzgnuHa6rXC5NHD
	TlyYfU+d9DLOFng0Fgzg6A43bxhQvnk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792434133; x=1823970133;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
  b=TPLB/TomLxgGu+HSRK8DXHpSbzWBY7xzuiULnGVFRsp6LzpaNnkXDMdD
   itO39Q4Fxgvp3zi8XM/XXzbjzfY6B/isyk9Tnotv2E/2W5CMWLc8j2kj6
   6EPPVVNpRt0HdiWqU46DZiVRnqMJ/uZvFuL6E2nLImN1/GkUOh+QhbcDD
   VlqhaPFdhiR7mjPVxOuaR/6BLLc1c6459E4sNN/Wc8Q/gqkK7Pmc5czjh
   WtV16Zk23HyRhJ7r7B3stsMliJTWwpSDd7LOQPbAD4JnZBNOVSKCGpFjz
   wUMFcwDFmJQOZHolLAfI25E/9iJoF2UY65BxPnPZUo/9qNok3jZ70a8ke
   A==;
X-CSE-ConnectionGUID: S1O0gPGGRY2OsfPGaZ1b8g==
X-CSE-MsgGUID: /07DtUf6SgaQhoXXn5u7SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1026618"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1026618"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:22:11 -0700
X-CSE-ConnectionGUID: /IjvaEKbQvOutOsFQILInw==
X-CSE-MsgGUID: BxG9IwJnTHuQdZzpHOd+jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2585713"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:22:10 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:22:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 11:22:09 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.67) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZWPgOmevmox9EWvbCnrBdsLWp0FpeAeMZInPTu7lucexVbPSaIv8s5xvfHQ+neZoB9pCQrwt5jfJjQj/ET7+OCdGlfLPKEz1OkWu0dmhi215dzrCno60E/k1cdJGd2OdT0S/Dw1Jw10rmcQmwXdkIz0aAwWMM6cEX8xylnWidmpoh2/Ww1EA/4wkvLZHJAlChjSGqGcvCwXEldutngWOTBAWkEYXXUM2zTmW9abQzdFwZLOgzmfqRA7dxj6wnZbXimrOYymG8WElGdTyGETE+G4OlOsila5rnNqMDtR/EcT131kX1XUhKBU77K+HS7tsIMAjaoWs1FizPoMmY4RpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
 b=vBnQib6yVcCkuCbkbYXJBEUZzcYFtb/RA2s7ssDb7f3N7D+Ez/xLDqEzy3MoPpnE/l0TCbHBXgaoF4WCCML4nr4tOXh0LPk/sPeD6ZIqxyu1oYicOxImm3coGIFthwutB/BTzs3mh4wWvBTCuwDikfObpR7GUlAgWppEPvttZ+Eft47T+SwBIr6Qt0GHdNLXI2xe+TAJ0yoO9XFd9csPo71acDKHBj0Fhk3C88C2HAdKFchizgn9fSc8lbROpttlvUNH3QCfUXUExLUKtQCmpYYBtYb+KipAIs/fbbgAlzdr6PeOh3LEPh7PZDz29fVnx++4efymRK8cgEEFuugvOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7115.namprd11.prod.outlook.com (2603:10b6:806:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 18:22:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:22:07 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, "kees@kernel.org"
	<kees@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"vschneid@redhat.com" <vschneid@redhat.com>, "kprateek.nayak@amd.com"
	<kprateek.nayak@amd.com>, "vincent.guittot@linaro.org"
	<vincent.guittot@linaro.org>, "bp@alien8.de" <bp@alien8.de>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "david@kernel.org" <david@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"seanjc@google.com" <seanjc@google.com>, "ljs@kernel.org" <ljs@kernel.org>,
	"zhangguopeng@kylinos.cn" <zhangguopeng@kylinos.cn>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "surenb@google.com" <surenb@google.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "tim.c.chen@linux.intel.com"
	<tim.c.chen@linux.intel.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "pratyush@kernel.org" <pratyush@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "gmonaco@redhat.com"
	<gmonaco@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "mgorman@suse.de"
	<mgorman@suse.de>, "Graf, Alexander" <graf@amazon.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"liam@infradead.org" <liam@infradead.org>, "ridong.chen@linux.dev"
	<ridong.chen@linux.dev>, "blum@kernel.org" <blum@kernel.org>,
	"longman@redhat.com" <longman@redhat.com>, "bsegall@google.com"
	<bsegall@google.com>
Subject: RE: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Thread-Topic: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Thread-Index: AQHdX2dIvJ5EZSvEr0+jfa7rd1zKWLcFLFbQ
Date: Mon, 19 Oct 2026 18:22:07 +0000
Message-ID: <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7115:EE_
x-ms-office365-filtering-correlation-id: 10c429b9-fd4d-4372-afd4-08df2e0de204
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|38070700021|921020|11063799006|56012099006|261009223027099003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: lzLbd4unzW+qIHYeufMybapC63MDt2uLH9mqS7BpTtPg8mVCRd7qJ3n80zBXUFixjZ1YvQNO6SMVJ22Sbhw91xQWTpPe5kyZkk8phFWOjtnQ/mgegUglaGmrbeCJc4qLXDLhX5UpKxegWWZQr691ASxMkSnSoolNRKu7FN4IMx5h2HzX6Zi/N4Zw1eRb1HXglPsflnOWvTSO1JsoTaVKNZs+sNWuBfMWW51Ja58NxH8lEM7VK4WzNRuO9u/fxSEp2okwln/rlnMgP+HB9y6O66tm6o1B9R80Y/cOw+FSMT3zlIBK+aNZCmIkQj1ytlwhFpgnbxfvQlHXzpQUn8diHvYnogWQuilN2VTtFci1J6Niym2SLBGDUXVhulNUwIfslL2MOwVnQOdlCFl543ra8e/CrO2igdYAMXUV4eVmbYuJLRC0u564i4w0S7zD1iqI50Ey2BCiA4wAEnUWhITt8PUUdMBozXDUWQA5JZUvH8LcrMJNnpSSZ/bBWlgLqCa37ZryEnzOPWwniVqyIwoKkw1+DLUY93tszCeWL1tx7DSucUB1fuJxPKnCAwda/wXMtcknmuiZP8gNwm2LARlxWFCNvRxGZxYDA7Nkob/3vgilvYH22J5I4cKLq14+CIv4iPLnyTYfKTCBuBGj7FATAiqCOdMox1N5mCOhQur0K9T+ZzfjESglOeIlcy3Ddmy5iKfL4GtueaVJGfdqMZ4kLyrZHqGBWHsXt8MU0ofySw/8x7zxib0eifhUCKAjHd/d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(38070700021)(921020)(11063799006)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUdETmxjRmhGWmRrTEI1U2pvY1ROcy9LMkNiZDFJYlIrM2s2MmR0WXhvcnU2?=
 =?utf-8?B?TDdzeXRZbnBmdzc3aExJSUNLU2xKUTdOOE9Hbm1RYmViVmZUYU1wVnZBQXlv?=
 =?utf-8?B?bERYOTZxSmJhVjdzNDRaVFRxUXBOUW5QVUswSFhleTNrblc0RkFiWWxUMGl0?=
 =?utf-8?B?NUVta0ljcEE3d1dpcGE3ZFlRWVJXMEtOeEVySEtzRmUra0h5VnhVcmR6NlFk?=
 =?utf-8?B?eE16L0hBQmc2RlRKZHI5TjR4d0ZYYkFTdFpNa2k2NURlYXpYandNZU1LQTBi?=
 =?utf-8?B?YXgzVDlIRk84aC9RU0ptYThXRi9KSEZvMWI2ZzUrQTh6QUFyanJoc2NVOGJC?=
 =?utf-8?B?MFcxOWtIUTgxZ1BDNkNCaVhFQ3lrcmRBYncvTlZFV1htKytvTXlvaTdPSWZo?=
 =?utf-8?B?Vmh0OE5OUmlnWEZacnV4OXdVRUJlZFN4ajNGcU9MbVdycWNXRzNrUnltVXdi?=
 =?utf-8?B?enNGeDFuUWl2SkNPdFpuVVpaUStBeFIrSHFnY0lyNVpKQjlvNkJDZDlEQXlU?=
 =?utf-8?B?Tlo4Rko3eFBtckZjajk5UHE2bHEvRUNPY2Faa29WWG5qSm5VTWYwOXRJcUVQ?=
 =?utf-8?B?ZjBnWGpwaFNYb0VYL3ZzeENDWmVxSTRvUjNlUVBpK0JYQ08yNW9LYm4vM01P?=
 =?utf-8?B?eVJDRVdQa0JmT1ZXNnVsRHphbWlPVmV2V01mNjZRbk1ITFFGWiszYmNNU01o?=
 =?utf-8?B?VTFKOHNJaWZIWUZNRkZ0YkFCR2hRcG1QNStjb1NXbEVLM0ticE5sck9sQldq?=
 =?utf-8?B?TkJQRy9iM0NYOC9sbU5ybktpTjduZ1RiZGwyVG1WeFBUdFg3Qy92NVVyVWpu?=
 =?utf-8?B?L2t5TlBBTXh5NFlxcUpmdGkrdlJGcStMR243VnBCU2JISzFzbkkxKzd5ek1L?=
 =?utf-8?B?WXNSbmFmVnUva0YvY0NLNE9yRWt3bTJDL3g2aVFrUU9pRlRCMUZTdEVqZlZS?=
 =?utf-8?B?NjNDbnYzRHBzMUFWVWxmWlpJbDlnanZTQUNQY1l4UFRDQWRPdlJ4SUtRaXNx?=
 =?utf-8?B?TWF1MmxGZ0x4U0pVdVJSTlliNFY0OHRYVnJvcW9NU3Z5cnlDNW5oMms0SnR1?=
 =?utf-8?B?ZUtaa1QrZXZpN0F1cmFFb0ZsbXFCOTh3Q0pPbTRtUVJFeWhzczVxTmxKTVUx?=
 =?utf-8?B?alcyd1BPMko5QkpFZXVVWGRiR2lpZzRUMWhZZC93QXFBdmcwYTFnbVpRckho?=
 =?utf-8?B?MjFDMk5DTUN3bUgzYWVkQUdoWGNwUWU1SG1qUUNTUW5vRU1OQnBKTmxrSS9l?=
 =?utf-8?B?SEFYdVlYa2IrUG9YRmFPalowK2IrZzJjbXdWNGRveVE1R3R1STczYXhPbW82?=
 =?utf-8?B?V3NDeUtQdGIvcXpZbkJNcjlrSllOY255V1M3YThsREgray8rVHJpVW51WHp5?=
 =?utf-8?B?MUxuaHJodmxZSkF6Q0xTc3V5L2EvR09UTk85UVU2SDVoU3Z6bkJDZ0hsQUEw?=
 =?utf-8?B?blM1MURoTUtJRWhJOGhQajFOTnFSZkhMM2NBY0wwaUp2Rk9aTlc3N0lXMUsv?=
 =?utf-8?B?cE53cWRMVE9Td1JFM1draVVld3JRWTQvWXhDQWtmc0VHdFBsd05ZemxyV3kr?=
 =?utf-8?B?bVNrTTVaUUJHelFhK2loTzZlVCtmckVOU3I3bHUrUTJwZHJXd0hSNHVlemcz?=
 =?utf-8?B?aXFVQWZEUy8rVzFYVmVOcXBGbTR2RE41NXBMaGNRaXEvOGIvU0MxcHloY1dD?=
 =?utf-8?B?d0JtaWlWMDhGTlJwWVd2M0p0UStjQm5GQkZPVGlhYVFWVXVuMXFlc29LWEo1?=
 =?utf-8?B?Tk5FK2huMkJSTEV2dGVxM0dkYjhFbWljK3hOUlJ2bE1abWg0MDJXQ0lOZ0lt?=
 =?utf-8?B?STFGdHRkaE9odHBUMTZQbUZpandSNjNHVFlxWCsxWDVRcGl6dCtYZUd6NElq?=
 =?utf-8?B?RDAwSmRpUFdhRXd5SzBscUl5dTVvcEJKT3JRSTZmcitVZXJtMWRpNFNndWFq?=
 =?utf-8?B?ZGRLTjkxajZib01hd3lVSW1BdVJERlpuMjlpY3A4bDhvd3F5YWdqWEpGaGtN?=
 =?utf-8?B?bnAxNWlmYTdQbGZ2Ui9BaDg4QlN5OUpreld2WWtsRXo3SnZIZnR6Y0Q2Qkhy?=
 =?utf-8?B?UGdzdzhHbG1UMGI4akNuL3hHeGpONlZPUkQ1WHU3QnI4akcvOC9iWVBmQkVn?=
 =?utf-8?B?WUpFR2lvVnRhZ1JaSmRLSWx1VFVOVGZoUEZOQ0w4WDFRL0xlb1FneUczNGw0?=
 =?utf-8?B?cmVBWXZNWjVGV3B4U1lPN01oY1NIeFBvREFxb0Nzb3AraG4rYnBhb0xFSjZ1?=
 =?utf-8?B?QUlweHdjZnhWUWF4bDR1Y0dqcmpGc2Q4dnBIblM2TlBRektSSUZtTld1R3JB?=
 =?utf-8?Q?T3oXlKvXIaKmhVatdj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: eI2THX9Ae1FEODJdc+BvfuRR1TiZvAdHSv4U4IXmw7LsoCRPVTj6m+xjb7JfsLUqVrJ+UFZ2IqPtT0kkO9s7a8dYSNIHIiB4i1IhBqQf8XUF6VuxZrpFV7uhHBJ2jlLNuhc5ZruQCyvw/52GsfEuZ9ctpUHmV/3urZSn9Nw3FpHG0KQHbEcqPEIDFzIuwId19msQT4MTk6w9ahJrfvVyouZztLLsySj8Ze4kMX/wMpUBHGZVhaFUR5Vlx9JV6Ag3cz+CTQiB2EQ9dcraTlNY9l8PKDI4KZ6qX8JmewKjgpt6ffEPQgtIdOB76Bbd47JzcAZDjougeP2UnuYHjIEgIA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c429b9-fd4d-4372-afd4-08df2e0de204
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 18:22:07.0869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GbbATxYLx+ykgN49sGENngF0knOEB+uHCCSBVO4iftDyNj20Uhq0qx6snoj8sSz6JT1X8bIbboKJgb+R79ffg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7115
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: EFBCC180005
X-Rspam-User: 
X-Stat-Signature: kobg6k1qcsrnxp5t96ziurk58fca8go1
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792434132-666208
X-HE-Meta: U2FsdGVkX18jXM6aXEE5S3EkLiXlLi4FtkM57DB7bNmwNL+5j3nXkH39jtchkeyzU7iCIpcre8D4dAglG38IcYJ9SMPQjH6vU/1HS0A3SWdos9TRlphYZtI83Cfp572JMkkE4fV4tzV9p4VwjOwVt0Y+uscNFurnihYEKJxZAQRMIGLP4y8SDshhzBkQHC5axIdd0MV+NtmG2K3Y54ylJu1dnowwCpiQHrs/r9iUNe7OUlDG7q7kkrdTic8drhmIFvAWKWnukMqETJrdomwGJyC7pBflM4hZ+3a5M6kb4UiH18to9KYon1wPCc2nXHH/iK0mJhuSyx4tQKFj0tWsh0xX2h6lF2hzL6A0P6cYUZyHIRcSQoaLbH7BY36pIXEeq6hbaq72yHOovT6QsWcZCkqTyQ1R3zZ/4/n8X+wRWIH179w1QnzLx2xBm9H1GfKgII990Q4U55Offz8yG//lVLXFvOoyN1/9VeyOYnC02//nMMSbWWN0Wsel9q8lftZ0Rr+E1poOA6jbDdb0M64TJF5SFlhLhE1OMxAFEIUxqAig386702VZyBSHRBWvG9TIOsH/YzW6I4VDtvLfR/hvNJvjRbu4UuM6LzzxlBzwZbRDlFsGCE52IeZZezphiO2Y6/BLinrNsTJT6yBD4mLWW8bt6GjL/k1jr6HL1J20B65/beujrgC5y4Xh4uaQeV45mkFUWSwTR4s0SnVG0N6YiPQX5O0Ei64kew2JOwBCaU9X2Yuz2c/MRDWB0YQPiCiscpTVJ2MPD5rep9hi9JnGqja5hDVfnMRo27QYMJkvbiLmL9eAw+Ev+puIbP7Std0+Boxix/DJLlmRlVKC0kOGrZ590OvXei9AaTlE89cWxC5T5fmp2V1LH13DiQuPRAlWvpFxcOSLFy3hta/YYc1PIYZhD1NaOev8t89e0xkDCpC6ntxWVj6RzrQV5BMNYZ+VXh9b+Hb3jwaSO9up80T
 PpmrI3Um
 QnY+NrVtpzLUfA8bVP/9F7XKiOQPRDtTXVcp71wBqljK+l+tfxca9pVbmQvYJvwal1cJlY7JCzMDvQQdqQLI8Aq3KMB0AunFcVWN7sfjw6Pi3k3YUouyWfneQXM+Kx1UZ5Q4VVI5lmTARswE8GkiMxQGQCXJrt3HPEDBGycQzb/ZDT6Ll6MClaqt+YJeUM8ZM9BaWehoWP6eK1RpyMHUyfA9wfDuotQ52F1c6YGQ30+xCgHaqW0iHTQZnrV9TXkqUXa0Lr7Rx6SacY9wJxyiity3cjLXJ26Y5WLqcmJVvMgQsOg1pbilJ5vi38GEwpaPtNxIz9hyi/unMzcQFBBCWhHf+5RjH39K6KrRkEFjPBFzofr2z8nBWd7rnYkh+oYwqZsMfq+i2Z8f6LEleiE63AkVyP2ta+C47vsZrn7v6GFtrk8H6yE7y3jgxfcRN8Bd7lI370CE3VWj/XPdefAvvJFCVTfmDTnQ7IfnlJizIzDeX2CQdtU4gwyNEoN9d2rQZAGAED9WtTf1l9cP63OFjSg3Y6zDuM7deKSCrHXO2IDodjVlX5iopEzozuoe+95YUhcLx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PiBCZW5jaG1hcmsgd29ya2xvYWQgKG1lYW4gb2YgMTAgcnVucyBwZXIgc3RlcCk6DQo+DQo+ICAj
IGVjaG8gMSA+IC9zeXMva2VybmVsL3JjdV9leHBlZGl0ZWQNCj4gICMgZm9yIGkgaW4gezEuLk59
OyBkbyBlY2hvIDAgPiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHUkaS9vbmxpbmU7IGRvbmUN
Cg0KU2lkZSBxdWVzdGlvbi4gSGF2ZSB5b3UgaGFkIGlzc3VlcyB3aXRoIHRoaXMgc3RlcCBmYWls
aW5nIG9uIGxhcmdlIHN5c3RlbXMgd2l0aCAic21hcnQiIEkvTw0KZGV2aWNlcyB0aGF0IHN1cHBv
cnQgbWFueSBpbnRlcnJ1cHQgdmVjdG9ycz8NCg0KU29tZSB2YWxpZGF0aW9uIGZvbGtzIGluc2lk
ZSBJbnRlbCBoYWQgc29tZSB0ZXN0cyB0aGF0IGxvb3BlZCB0YWtpbmcgYWxsIENQVXMgb2ZmbGlu
ZSBhbmQNCmJyaW5naW5nIHRoZW0gYmFjay4gVGhleSBjb21wbGFpbmVkIHN0YXJ0aW5nIGFyb3Vu
ZCBTYXBwaGlyZSBSYXBpZHMgdGhpcyB0aGVpciB0ZXN0DQp3b3VsZCBnZXQgZG93biB0byBqdXN0
IENQVSAwIGFuZCBDUFUgMSBhbmQgZmFpbCB0byB0YWtlIENQVSAxIG9mZmxpbmUgYmVjYXVzZSB0
aGVyZQ0Kd2VyZSB0b28gbWFueSBpbnRlcnJ1cHRzIHRvIGZpdCBpbnRvIGp1c3QgYSBzaW5nbGUg
Q1BVcyBhdmFpbGFibGUgdmVjdG9ycy4NCg0KSXQgd2FzIGEgd2hpbGUgYWdvLCBzbyBtYXliZSBz
b21ldGhpbmcgY2hhbmdlZCBpbiBpbnRlcnJ1cHQgY29kZSB0byBoYW5kbGUgdGhpcy4NCg0KLVRv
bnkNCiAgDQoNCg0K


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284F9FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C97E6B0088; Mon,  4 May 2026 19:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A9B6B008A; Mon,  4 May 2026 19:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041FC6B008C; Mon,  4 May 2026 19:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E588E6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:15:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AAF0A02E5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:15:37 +0000 (UTC)
X-FDA: 84731296314.03.6F91FD0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7DF184000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:15:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZMEIsyWl;
	spf=pass (imf11.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777936533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dBvVKIDfNgaVSCWlpB50dQu7stWB1ePjnsVAYV8bdo=;
	b=wzfmWjFHwJQoJspZzRZrMPBFx0PbF1wairWXzKl6YnN2FNitjW8fgGhDvKeOmmRkT7M3+H
	XzAEkydup0evY8SIwLJxm3gAzyuROY/i+qUJHde4OUGW54q2Rm2zMppo1NqBHVjomodPs3
	Kw5pOf2x11WxEKpkKdk3F5k7QsAsW6s=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZMEIsyWl;
	spf=pass (imf11.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777936533; a=rsa-sha256;
	cv=fail;
	b=6Hu2cuTs3PdKo8dJfX/Mf8FTUXQOTlJyIXDElGgkQ8wK7A+jLCykdgOgzdMIBjkpgx0nIB
	gYBkMwrQ2OAwe3jwp6CWqwuqpkP2wGMgq1ytniih3uu24rWYyIaTmpw43TvarCb4aSv4BZ
	zPR6p5UM9LD89UOq+I/GRjASKwwmTr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777936534; x=1809472534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/dBvVKIDfNgaVSCWlpB50dQu7stWB1ePjnsVAYV8bdo=;
  b=ZMEIsyWlupkD533tID2a7DzE8k2M87qsiZZ/TS89T+uHatPs1+2PBF8d
   lwCPmZiRC3eHbp34A+o/OrkyiF3ZZI6Dy8MqtPqqTSnZ8sjL8Oiu1/9FA
   4Ay7nAfu/iwJ54Zsrjaxu/B1d2WfYcjk55iC/3s+v6jTW8pHNOqhvL5Dw
   mY75wlZ2/iFLpOjRtYr0by10P3AVitoUezvOHKWQhXJMvlkzpUcImKAj4
   92oRBt1ueb7S3kgQBVNFXEAXjlStYfg3DSXxMT9d6Os/mV7fbSucx0yyj
   p7KUbGPXdkFZyBj+1MPytwvfOHnW2gXc198nVPk6MzjmX1JZwnBu1OSsL
   A==;
X-CSE-ConnectionGUID: 1Jsowz0aRaO5/Sdma/+Viw==
X-CSE-MsgGUID: 476YvJ+YS3+chzn5XYGOJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78735820"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="78735820"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 16:15:32 -0700
X-CSE-ConnectionGUID: XALDrTCMTAmC9unAwjqu2Q==
X-CSE-MsgGUID: OvTqDScSTlWb4Q/bJNdrGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="259006780"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 16:15:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 16:15:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 16:15:31 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 16:15:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZRFkYf2wqVHpEjvwX0Pd2eJ8rn2OPgMqjpGoMYj9taU0X0fK/tmaCShTweiMa0WJ5AzAn+mNS7fUYUzYdTRTqMxz4J57b05F0TpB3/nwf9EOmh5E3T00FEnmysypxfx6XkixKa5BzZdFcBRuvveEiY8Ic2RF+Jwx+epaBdm3Di96nvLkjBRnDlY17nGrHYdqk8m9csQHlJuPyQUizywyioQNJYfifXQLNnpbp5+nCUqak+h7St5J8hY8TxcBVcBn4E5F9K0/vM4RQJH0N1sek3PkSXJpd076+wFx92VJGnw2GhmHuzy5kanZLsevdbiCLqyWcwoJCERSevTMEg6LUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dBvVKIDfNgaVSCWlpB50dQu7stWB1ePjnsVAYV8bdo=;
 b=nHc5uXWAg0DxwEvp4HApkENc/qUYgvyQmDIhAay1TzgzCJ0VvdMFs0OGE8JlyXF3DrA1oCo3iZZ7cXuj5o8XFWWWMMZQpvmFfl5UtQiM2lyx5hK9Z099o+DON3dzUU1ChT58NINmfk3OB3mRI9dMJKXp3eJvC0mH7phR9G/jbgmLFQH1ovvYWv/aKIQoDJLLHs6YM/Z1ErsPGOzLGrqHZfTRaSI2zIFek7NMRX4XKa3DK0ysS+9etwKTbLKlycnABY+QQ5xDfCCkN5LzQFrxMX8NVC/Cpn8L5cPvDhZ9pRs4kauckqJ1E8FaRZMoimICvBSmyOZcR0EEvszCozoVSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3018.namprd11.prod.outlook.com (2603:10b6:5:68::11) by
 DSVPR11MB9578.namprd11.prod.outlook.com (2603:10b6:8:38a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.25; Mon, 4 May 2026 23:15:28 +0000
Received: from DM6PR11MB3018.namprd11.prod.outlook.com
 ([fe80::d5a2:c5ee:1227:9d1f]) by DM6PR11MB3018.namprd11.prod.outlook.com
 ([fe80::d5a2:c5ee:1227:9d1f%6]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 23:15:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "ljs@kernel.org" <ljs@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast
 path
Thread-Topic: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast
 path
Thread-Index: AQHc3BRiIB0C+SH+DUyVH+K3pghit7X+f6CA
Date: Mon, 4 May 2026 23:15:28 +0000
Message-ID: <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
	 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429182005.00BF70D8@davehans-spike.ostc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3018:EE_|DSVPR11MB9578:EE_
x-ms-office365-filtering-correlation-id: 6e235331-1c0d-49b4-6123-08deaa3307f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info: 2FE12RgJlyHRqPf5zt8iQxXr0ss5JAZarN1B8KHuBxSyqWVRcabKAa7UsJPhIVZFGyQMoSG1qIDTMz7HO2SnHNw6OCyXVHzHssq+0ywpELYQiF937Y7J7MAcFApjaU/s79wqC1oB+9UNdLm5rVkWEQ8Ur1nXndaeDmlosuZg79WC0ui/yPafuAKBngUe9WkPFB1lavKcqd/sbxdn05FCIRwMmMRbRwbMg9HCvKQhqV7Wo2b4g58piAv01a1TU5APIFxM3jHcrFH8liaeaIQx5lygt+aAEaXsrB1zAOppiCQKNfA+BuV+PAxxqdGS+HNvAWS0Ebh5pWYYJ+NzO3kn0fPFhIIgM17LJeJ5bV35PdqEFjgpmsjqRLW8uXDO603pAjM20xR2wciC7pLBkW/f+nVB2EOOZN/VKmLmMCM/P5bhyDIo+kZgrvrkq+W61+/JQJRzcN05Re0NvMqfKm41vg012vgKvxliK9c/pS9O4+1pvOblWDmb5Mjb17FA6QrpRoukYtKvtNTL/j4WYkVONSj4ttehKS0plz4RvR+wmn9cDouhbY+SpARZffsaSbieFtDW/0zEkTs4slv2KcWuw0OfLb71+PEUeG9LSCUxJG0FZ7RIqUErbBHlBB8dHDeu11VeCWhL6XdqWya3HQkdtcU9gJiHN0d0uWojn9/MMgSPsDqikduzd1ClBYCBxcE2dv+6sG8VAAFzoBtUTJwzzwr5FMYe6USMnum8UDW45FX0SiCwbOvY9WY0eU/4Shhf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3018.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cThkYjdTUkdSV2FaeTNaUndqWTJYeDNzM1g2WG8vM1g3dmxObU5qdVZMYlNH?=
 =?utf-8?B?RlpVVlpSTEIyMzdwM1luZUsxMUZQMlZYSmwvQ29BMHVrclltTGZ2QWFObjNx?=
 =?utf-8?B?RHRqNEM4VTByZzBCTm0xdXN1N3pZVUZUb1dpVFV1b0VPU05RRTBIU0llMGo3?=
 =?utf-8?B?cnFhMUJBSDFHZnI0SGdqWkprMTFyYlA5RzF1cVBFcWpTWmhZR2JHNUdmQlJD?=
 =?utf-8?B?UTFNZzRtZ211NkptVXNGeEpmV2NvZnhTengreDNZTXhOZGwrTU9kaGdGK0d1?=
 =?utf-8?B?Qnk1STlKZVdCWlVjZ3d4UVJ5aTBSa1FtMS9iN0xOL0R5Q1M1Q29zVlBoRWxK?=
 =?utf-8?B?NnRRZmFMeUVjcTJVSXE4STQxLzVPeW9HenlFVW8rU1BmL25Yc2hRSGYxVWJ3?=
 =?utf-8?B?SnYzN05WaXMwZ1pIem4wL3VFT2xoWmtLK3A5SUpLWU5qaVRWUFpBa0NHOXlT?=
 =?utf-8?B?bThyR2c0L2lBWDNXQkpLeXFjQ2xtWWpsVk15eFBOVHlmZWJCbTdoUjZSNWZz?=
 =?utf-8?B?MFdheStOMTBhM2FwUlpvdlhQN3cwcnpiZjJsK0RwWU1idzBkRnAzTDExdnUw?=
 =?utf-8?B?ZVJXb2h3UEEyUDdTbFFkMndhV1dmLytoWW5GL0tzN1hBNFhoZkIyZWFBT0kr?=
 =?utf-8?B?ZHBraWxnNm5xKytSbWo1TkFqZm5peEtGMDVzdVVYMUZyOUhmSDFvYU1DZGlp?=
 =?utf-8?B?N2FNNXZrS2FrbVNuWGFwOTUyS1VlV1lEL3dGSHZBalg0cmVoUk9jY0E1Tmhs?=
 =?utf-8?B?bzcraHBqcnQ1Y1VGMk94RnhBTXBNNnpVK0lQVm15MjZBRElGaFVpUzNNanVK?=
 =?utf-8?B?KzJBRE83MU9tZzNhV0Q3THpUZHFQOFN1WGsreDI2Nk5ERnQ3ZVJvY1FTSkNo?=
 =?utf-8?B?WTlDY1B6cVViLzlyU3QvMUhGVjJFaUV4enFXb21HYUxyREM1NklRNjBTYWRF?=
 =?utf-8?B?MG5JUTI2OTlMSXc1U1dmSC9XTnRHRTREOUVjZHVJK0NSSGxBWlZRUXJnV0dF?=
 =?utf-8?B?aGVWUy9iSTd3WWoxcXhEYTZIY2tYUGVvNktzU3IrcFZTNmpDejl4TzFNR0tJ?=
 =?utf-8?B?Nk5tYk5NejdHNkJXcWZ3NlpTUS9SU2VwMEorbE8wVVRuOUtCTEowbU9ZNU5q?=
 =?utf-8?B?L2NMUGR4Lzl4WWh3WHpYM1VaVC9VMWhpN2hLU0tVSGhld3pPMGNCdzFPcERp?=
 =?utf-8?B?ZDJoa2NTUHVKeGhKcEZ4clBBZmVJaFhKSlgyTGwxblpSZjljYXdvYktUbmtY?=
 =?utf-8?B?QnF5aEozNmFJQ2IwOU9iamFtQUVrckUvTnBLMHJ0bzF5N2cvYkxCUTFGbjdi?=
 =?utf-8?B?YUx1S1ovUHRBK0tEampUWHhiREdMemRLUzkvSkZqWFFQTVFvVklrMnk0YVFm?=
 =?utf-8?B?V05wbUlhTDhCREE1aGVRNUZtQ1ZQUXlqOEpLNFIvUk1PNDAxOEpNWDdYdG5j?=
 =?utf-8?B?RkcyUGJHeHFEMjllZWRvVmRac0MyVWhyQkxXSGMwZmcvUnVPVjM5QnZTRjhs?=
 =?utf-8?B?clk2cnhTRzNadHBlZXB5T3plVTJCZVp2V1duZ04rTEpHcmZ4U3dnSUFQZ3B3?=
 =?utf-8?B?SU0rWGxUeTM3bXQzTXhmNmx6UFJ6RUV1cU5zUGlIMzE0YUt4ajZ0aU5PVGkr?=
 =?utf-8?B?UTlOOUtSNUdETjVCU0hvaXhFVkVuSWdVNDRGMTZhd3BobGQ1eE9qdUdSSVZk?=
 =?utf-8?B?bDdxWXZQeUpJZE9Kc2ZVUUxqQmNON0d2MmVzVkpta2Z2bDhjS2ptR0ZaYUtt?=
 =?utf-8?B?cTNNVHFOcFREYysyU2xpcEVnSEZIQ3dCUHJ1Q1JmcHJWdk5XT2pjbC92ZWxq?=
 =?utf-8?B?MjhmcHltblQvR3E3a0JlaVc2djF0VWkzQlBtWEdtM0lzMjY4L0JZTndhZXg5?=
 =?utf-8?B?Z250SndYSlFyOWhkbDgzUWIvNHlkZk5ibDJDaVRQZlpKQVNhckFFcW85M0sz?=
 =?utf-8?B?TjdtUkFieUxqSUwwNjIxcjM2N2ZyTVFuNlpGQmNwc2IyQW1nWTNhYU90UWhm?=
 =?utf-8?B?L1N1NTFFOVE1a0EwWlE0VlJhSXZiK0VXK01HUnZvUkxNR215Ris2bjR5UFdm?=
 =?utf-8?B?T0EvbmMxWUpoNHdBYTY5eUtBY1RaSTlZMmFRVktXZ052NkRyWkx1dXB0akk4?=
 =?utf-8?B?RE41azZ3Tm9INUhGSXRoR2Z5Q0hmRDRlT0VjL1B6NHRxbUhuUFdDeFJMTURr?=
 =?utf-8?B?bXZzcFV4NTJlOThPUFVMTmZiUEtyeXZiUEtFTFg2eTlscTRZNDl6VTJsdkRV?=
 =?utf-8?B?ZEtYUmtacVY5N0Q3cWh0aUdkaEJ3YUIxbGgvdURaNWF2OTNuMVBxRXZqckJF?=
 =?utf-8?B?MXc3K2hqMEE1Yk1CVnlnVlhWazc4OENBSnlPMC96eHNsQ3FiK1g4UkppZkpQ?=
 =?utf-8?Q?aiQgg+cCJKIgyG0Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF4AFFC2BCD9994ABB94CAF8122311FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: OQURrv28C2N/speJafN0AOfJkF0+7SlvP5Yo+w33P6bIKnIrIPE4qlCydCntC9c1nLe9mG4YJDxT+8JNgGpoDvnSxJRZJscTQUCwVr9eMc74WU98T8b0aYOzD/2vRATncMuXijC1uTrls12Py+XdY+EKzU91M+e1mX2XbSlcA8DNMCmToZ7O8H4tSBwf+RTANPjo9rvY+3sLv0nWDHCw4GwB2Ah74B6S6ZkCmovu9iYfw3L5jHecTQb2qAb3X2iexPSfQZi4x0HHFmu5Mzk/rOP8iPBtf3KZAeHGNkAMJjg8wcCsXscEI7ui+jxAJOLdyJXXanyJO9M5226q98pLew==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3018.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e235331-1c0d-49b4-6123-08deaa3307f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2026 23:15:28.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxoBVuNRVyxdg8rRvm9JspDIglZw+oRFsFuwoh3OTDQpbuDKyPfdIb/FKqptqtj7DxGgiRoFQjoXhtxPh7KV7yjt8JfYUGzqb/QAFyZbVtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9578
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DF184000D
X-Stat-Signature: bbq4sanxr6bbu1rdbpeipqmqn8inxr5t
X-HE-Tag: 1777936533-43771
X-HE-Meta: U2FsdGVkX1+Mkpd42ZPWzOwVhAmFDQKpu3FIgzPSINOqh0N5haoPgRYmyEk7nJdZ4NqxZz4JX2Ly3SoyXG7coh6vmGn7auS+DA+87BW+ebOAuU9tF3H1A+kldTD9ShNWf6cvanwuZ7C+5A5wz7uJXuZWyIj/ZNYY8Z54hM94lfr7qxdSbv/Xw6sx36nKdpe1pOuEt/QtQBg7sZYC2XigNKhCGVhxpguF4+gIj4LNzRfopmJBZ37q8/L7TzMQA97CdI1x7OJfiPVPxohe+qlF/9C2dF009hatwtlzmgvhmFt6MjT20ro5DwrIQhB7qkJQNIN9I4m4y828rOv/KJuP6B5XM7RTAYzHB3xELgk1l1zvQdzBJVrb0XyQt+ucUVBtawpcZwxg5oTAkLlVQPufemo2BdnU3Xy/a9BmZJPLLYO+yL7FIgP7uHbG8Zk1LB8UslUGq0EIM32YtnQzHV9vTk5jnTHMASpdVbuGUwzTHpsST5Zt5J/8HUdMV0R9ltajZCB52Rpg9ZhHVHT7Mh1OGyrGRICf8oxLk/+kn9kAj+u3oswfxg9Kj1oMJf+DmH7e1wwePgVN0bMYwkra4BISo2vnEc2Z4K9++lo7ulM89E+6Gonn0m2FLaIO+pWhY42fUI5142c39FxihLYkpGDAJpj/YiAsuLenw28boN5rKFZRj3P9atfBqxme/0u+dGUAhWALUxqiy/yyDTzns5WhzQ/pTCT7PpD8WkJUxfzrrmofiy1ZPVKAFep1/0aMTtUfZn2i6r0/wc69F0YpE9Lersx3WmJElHGtzGMuNqokRWJjAYUhQW7HaFMMBM8ljQtBHL0e5ADlQVf6Uw4eh4nbLdaKaYB9zEFNnqG3QWSlIIYsGK0l8tO3FdP9C62cIgNd0gsxbaGoFGsyomnHGwQBGViBYfT5qWE0iOemT38rrk/4lDh7hK5/fkvy9nIavhOEZc7QQJviTTVJa/Q4LN1
 OprAOWte
 H5hmNPdleA5EY30QQ9lTzaVW1hSGfquCMxOU80cbUunoX8QUfA3t788+O02r9WQ3LbtuKdNaD22/Y1v5JwbBDVxBS5OB/WB9qcJdFsE9exNidRUH7tjYu1Lh6uBPSxjkBBc1VhtpNTeJWSNLUrG8LABRmNRkeTN2GJ9lSERgxsUvp2212H5Tg4zNMM8lFpQ4uiSwjjdueXfAKONao4oHT+LW+SNQPDvMvK8xuoIc36lMJnATWtdRpI0nFC6P3li8fuHdZI50nocK1fKW5dkX6tt71XKnTKHk3NGIlsa4d6cJ+tz8XHpU2P93DpMPG00+HwJLfW08uNmYbVhynHdpHfkn1/jWoIFoSJxLRDi+mj59OE33Nc5mtbqL19RTHY0BRohxCwIP9+oogigcaeBWWM9SY0G5anfUKTxb7UbxqphH2Oet4hLLZyCPfjijJzQ5gFQjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTA0LTI5IGF0IDExOjIwIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
Kwl2bWEgPSBsb2NrX3ZtYV91bmRlcl9yY3Vfd2FpdChjdXJyZW50LT5tbSwgKnNzcCk7DQo+ICsJ
aWYgKCF2bWEpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJaWYgKCEodm1hLT52bV9m
bGFncyAmIFZNX1NIQURPV19TVEFDSykpIHsNCj4gKwkJdm1hX2VuZF9yZWFkKHZtYSk7DQo+ICsJ
CXJldHVybiAtRUlOVkFMOw0KPiArCX0NCj4gKw0KPiArCWVyciA9IGdldF9zaHN0a19kYXRhKCZ0
b2tlbl9hZGRyLCAodW5zaWduZWQgbG9uZyBfX3VzZXIgKikqc3NwKTsNCg0KVW5mb3J0dW5hdGVs
eSwgSSB0aGluayBpdCB3b24ndCB3b3JrIGZvciB0aGUgc2hhZG93IHN0YWNrIGNhc2Ugd2l0aCB0
aGUgdXNlcg0KYWNjZXNzLiBJIGdldCB0aGlzIHNwbGF0IGZyb20gdGhlIHNoYWRvdyBzdGFjayBz
ZWxmdGVzdHM6DQoNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQ0KIFdBUk5JTkc6IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVwZW5kZW5j
eSBkZXRlY3RlZA0KIDcuMS4wLXJjMSsgIzI5MzYgTm90IHRhaW50ZWQNCiAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiB0ZXN0X3NoYWRvd19z
dGEvOTMwIGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6DQogZmYzMmEwNWZiYzZhMTAwOCAoJm1t
LT5tbWFwX2xvY2speysrKyt9LXs0OjR9LCBhdDogX19taWdodF9mYXVsdCsweDNjLzB4ODANCiAN
CiAgICAgICAgICAgICAgIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOg0KIGZmMzJh
MDVmNGNhZjNjNDggKHZtX2xvY2speysrKyt9LXswOjB9LCBhdDogbG9ja192bWFfdW5kZXJfcmN1
KzB4YWYvMHgyZTANCiANCiAgICAgICAgICAgICAgIHdoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRz
IG9uIHRoZSBuZXcgbG9jay4NCg0KIA0KICAgICAgICAgICAgICAgdGhlIGV4aXN0aW5nIGRlcGVu
ZGVuY3kgY2hhaW4gKGluIHJldmVyc2Ugb3JkZXIpIGlzOg0KIA0KICAgICAgICAgICAgICAgLT4g
IzEgKHZtX2xvY2speysrKyt9LXswOjB9Og0KICAgICAgICBsb2NrX2FjcXVpcmUrMHhiZC8weDJm
MA0KICAgICAgICBfX3ZtYV9zdGFydF9leGNsdWRlX3JlYWRlcnMrMHg4ZC8weDFlMA0KICAgICAg
ICBfX3ZtYV9zdGFydF93cml0ZSsweDU2LzB4ZTANCiAgICAgICAgdm1hX2V4cGFuZCsweDdlLzB4
MzkwDQogICAgICAgIHJlbG9jYXRlX3ZtYV9kb3duKzB4MTI2LzB4MjIwDQogICAgICAgIHNldHVw
X2FyZ19wYWdlcysweDI2OS8weDQzMA0KICAgICAgICBsb2FkX2VsZl9iaW5hcnkrMHgzZDEvMHgx
ODQwDQogICAgICAgIGJwcm1fZXhlY3ZlKzB4MmNmLzB4NzMwDQogICAgICAgIGtlcm5lbF9leGVj
dmUrMHhmNi8weDE2MA0KICAgICAgICBrZXJuZWxfaW5pdCsweGI5LzB4MWMwDQogICAgICAgIHJl
dF9mcm9tX2ZvcmsrMHgyZWIvMHgzNDANCiAgICAgICAgcmV0X2Zyb21fZm9ya19hc20rMHgxYS8w
eDMwDQogDQogICAgICAgICAgICAgICAtPiAjMCAoJm1tLT5tbWFwX2xvY2speysrKyt9LXs0OjR9
Og0KICAgICAgICBjaGVja19wcmV2X2FkZCsweGYxLzB4ZDAwDQogICAgICAgIF9fbG9ja19hY3F1
aXJlKzB4MTRhOC8weDFhYzANCiAgICAgICAgbG9ja19hY3F1aXJlKzB4YmQvMHgyZjANCiAgICAg
ICAgX19taWdodF9mYXVsdCsweDViLzB4ODANCiAgICAgICAgcmVzdG9yZV9zaWduYWxfc2hhZG93
X3N0YWNrKzB4ZDYvMHgyNzANCiAgICAgICAgX19kb19zeXNfcnRfc2lncmV0dXJuKzB4ZGYvMHhm
MA0KICAgICAgICBkb19zeXNjYWxsXzY0KzB4MTFjLzB4ZjgwDQogICAgICAgIGVudHJ5X1NZU0NB
TExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc3LzB4N2YNCiANCiAgICAgICAgICAgICAgIG90aGVyIGlu
Zm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6DQoNCiAgUG9zc2libGUgdW5zYWZlIGxv
Y2tpbmcgc2NlbmFyaW86DQoNCiAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgQ1BVMQ0K
ICAgICAgICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tDQogICBybG9jayh2bV9sb2NrKTsN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jaygmbW0tPm1tYXBfbG9jayk7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2sodm1fbG9jayk7DQogICBybG9jaygm
bW0tPm1tYXBfbG9jayk7DQogDQogICAgICAgICAgICAgICAgKioqIERFQURMT0NLICoqKg0KDQog
MSBsb2NrIGhlbGQgYnkgdGVzdF9zaGFkb3dfc3RhLzkzMDoNCiAgIzA6IGZmMzJhMDVmNGNhZjNj
NDggKHZtX2xvY2speysrKyt9LXswOjB9LCBhdDogbG9ja192bWFfdW5kZXJfcmN1KzB4YWYvMHgy
ZTANCiANCiAgICAgICAgICAgICAgIHN0YWNrIGJhY2t0cmFjZToNCiBDUFU6IDE4IFVJRDogMCBQ
SUQ6IDkzMCBDb21tOiB0ZXN0X3NoYWRvd19zdGEgTm90IHRhaW50ZWQgNy4xLjAtcmMxKyAjMjkz
Ng0KUFJFRU1QVChmdWxsKSANCiBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExDQogQ2FsbCBUcmFjZToNCiAgPFRBU0s+DQogIGR1bXBfc3RhY2tfbHZsKzB4
NjgvMHhhMA0KICBwcmludF9jaXJjdWxhcl9idWcrMHgyY2EvMHg0MDANCiAgY2hlY2tfbm9uY2ly
Y3VsYXIrMHgxMmYvMHgxNTANCiAgPyBfX2xvY2tfYWNxdWlyZSsweDQ5Yy8weDFhYzANCiAgY2hl
Y2tfcHJldl9hZGQrMHhmMS8weGQwMA0KICA/IHJlYWNxdWlyZV9oZWxkX2xvY2tzKzB4ZTQvMHgy
MDANCiAgX19sb2NrX2FjcXVpcmUrMHgxNGE4LzB4MWFjMA0KICBsb2NrX2FjcXVpcmUrMHhiZC8w
eDJmMA0KICA/IF9fbWlnaHRfZmF1bHQrMHgzYy8weDgwDQogID8gbG9ja19pc19oZWxkX3R5cGUr
MHhhMC8weDEyMA0KICA/IF9fbWlnaHRfZmF1bHQrMHgzYy8weDgwDQogIF9fbWlnaHRfZmF1bHQr
MHg1Yi8weDgwDQogID8gX19taWdodF9mYXVsdCsweDNjLzB4ODANCiAgcmVzdG9yZV9zaWduYWxf
c2hhZG93X3N0YWNrKzB4ZDYvMHgyNzANCiAgX19kb19zeXNfcnRfc2lncmV0dXJuKzB4ZGYvMHhm
MA0KICBkb19zeXNjYWxsXzY0KzB4MTFjLzB4ZjgwDQogIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJf
aHdmcmFtZSsweDc3LzB4N2YNCiBSSVA6IDAwMzM6MHg0MDIxMmYNCiBDb2RlOiA2MSAwMCAwMCBl
OCA3MyBmMSBmZiBmZiA0OCA4YiAwNSA0YyA2MSAwMCAwMCAzMSBkMiA0OCAwZiAzOCBmNiAxMCA0
OCA4Yg0KNDQgMjQgMDggNjQgNDggMmIgMDgNCiBSU1A6IDAwMmI6MDAwMDdmZmMyODZmYjIwOCBF
RkxBR1M6IDAwMDEwMjAyDQogUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAw
MDAwMCBSQ1g6IDAwMDA3ZmY2MjhiMTg3YjANCiBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAw
MDAwMDAwMDA2NjQ5MmEwIFJESTogMDAwMDAwMDAwMDAwMDAwMA0KIFJCUDogMDAwMDdmZmMyODZm
YjM2MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQogUjEwOiAw
MDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDIwMiBSMTI6IDAwMDAwMDAwMDAwMDAw
MDANCiBSMTM6IDAwMDAwMDAwMDAwMDAwMDEgUjE0OiAwMDAwN2ZmNjI4YjZjMDAwIFIxNTogMDAw
MDAwMDAwMDQwNmUxOA0KDQoNCkkgZ3Vlc3MgdGhlIHByb2JsZW0gaXMgdGhlIGxvY2sgb3JkZXJp
bmcuIE5vdCBzdXJlIGlmIHRoZXJlIGlzIGFueSBzbG93IHBhdGgNCmF2b2lkYW5jZSBkZXRhaWxz
IHRoYXQgY291bGQgbWFrZSB0aGlzIHNwbGF0IGEgZmFsc2UgcG9zaXRpdmUuIEJ1dCBob3cgYWJv
dXQNCnRoaXMgc2ltcGxlciBtdW5tYXAoKSBjYXNlOg0KDQpTaGFkb3cgc3RhY2sgc2lnbmFsICAg
ICAgICAgICAgICAgICAgICAgICAgICBtdW5tYXAoKQ0KLS0tLS0tLS0tLS0tLS0tLS0tLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgLS0tLS0tLS0NCnZtYV9zdGFydF9yZWFkKCkgKFZNX1NIQURP
V19TVEFDSyBjaGVjaykNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIG1tYXBfd3JpdGVfbG9jaygpDQptbWFwX3JlYWRfbG9jaygpICh1c2VyIGZhdWx0KSA8LSBk
ZWFkbG9jaw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm1h
X3N0YXJ0X3dyaXRlKCkgPC1kZWFkbG9jaw0KDQoNCg0KPiArDQo+ICsJdm1hX2VuZF9yZWFkKHZt
YSk7DQo+ICsNCj4gKwlpZiAoZXJyKQ0KPiArCQlyZXR1cm4gZXJyOw0KPiDCoA0KPiDCoAkvKiBS
ZXN0b3JlIFNTUCBhbGlnbmVkPyAqLw0KPiDCoAlpZiAodW5saWtlbHkoIUlTX0FMSUdORUQodG9r
ZW5fYWRkciwgOCkpKQ0KDQo=


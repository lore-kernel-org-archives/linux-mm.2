Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44718CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507726B0088; Fri,  5 Jun 2026 09:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B89A6B008A; Fri,  5 Jun 2026 09:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380596B008C; Fri,  5 Jun 2026 09:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274DF6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:09:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A444162235
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:09:11 +0000 (UTC)
X-FDA: 84845889702.26.5140BB0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 441271C000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:09:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K2t86NEt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780664948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLP9DQXAsm5SZ8Dg87/aXjUknXcfZDU3zo+c6kV54Pk=;
	b=fIikvnPhktA8kNQsH/vllQ4kM1VcdC+cvCREJ1+2aqtCOwxP8xR//7RGwmUhGFqGYRFLtJ
	XuRA+2V2NKymY6EGCltef+q9qhbRgtCM6XW9PH6wUdIvqJRl3s46jIQhK1mgNG3Jqs/Fr7
	xChRkjhELSsDPqDu9ftDVsQvwSbjqHI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K2t86NEt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780664948;
	b=HhYwZD4BswAgbYVRRHFealZNKEnk8l5HDsddNqSnYFRDaBR/u4sF2NDwGis5PNyPLlyuWz
	apPDy7ReNfZC93SbIW7Nf7FrPzNaarV+9Qkc0Y0IM/0m9PLmtx8F5h7pyTpnjA8Ptk6FBI
	m2x1Z7CFLcXzV6TdlHXCFa3wqwXGCYM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780664948; x=1812200948;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WLAmhmbyNTHXj0SlY0wgaiI7BzKLtKQyqKCBLeiBnHk=;
  b=K2t86NEtRT6nTJ/ImxzU/0gnzVes7F5lWPvtsqq0965z24OBn80zgb7E
   7krhQtEdEL3ZoXhf05R9iXlMON5KGQ7Kq9Gv/ZhaUnkYc8P17pw7WKCKK
   hMq/uu7Yk4vlqgJV8Nvm9oi7Hw3/IAAhAzAvP7UY1EXMOjbdQIrNWOWiK
   n7jBM/GeQ0JDQPEyJ5E1/3xLwBf2cKciAR5LOGvs5yYEHMZm9ZBqLvgRM
   pObkXVA/9Ghqk97JkyEbf+Njq82Js766LzikEfILQX0nmB+HZtbPCH5At
   45iFogBtLZfuplcgZLUzKBLTBKJhqzceX2dTH21wRNwdCQLs3IGCIk+/d
   w==;
X-CSE-ConnectionGUID: cahA7GAzREmr4xNpOEQxjA==
X-CSE-MsgGUID: z+BBifgUSoiOW0NSVyxsrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="85117318"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="85117318"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 06:09:06 -0700
X-CSE-ConnectionGUID: 05+0zTAfTeKeE5PYflYPbA==
X-CSE-MsgGUID: FYlw5SqETfSdnchnl1Xnhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="249180482"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 06:09:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 5 Jun 2026 06:09:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 5 Jun 2026 06:09:05 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 5 Jun 2026 06:09:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWpj//xMY+cn2PZjZsFDQRycmXVQKOmsNovcNwpP0m4doUeB0saZXvAws1XrN99kBCY+Vp7AaqXkYzlzRxHG9u0DEJ2EHegSdY/Dmsgcf7FETrzaxKhFOozvQiGKc5XmAF2RTuIWPMr/4Xm/sYX4QJkbUVZzGtnGBRiR6vRSCu2Frn4f6pg08U+XHSuSV190d0DU8K2fKgnPeIlKHi/UETwbvYB8fVqL+elBu35CuCLjAUtZ6a1ZjEpddUSoQjfBD2ChOD/Rg+msLLD+FceyH2MVHeeKvatKUo6kOHVxNBaqkO1vdoKIy6lvjHe6ywfmKXwtA6HWSBP40ZFl7sAFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLP9DQXAsm5SZ8Dg87/aXjUknXcfZDU3zo+c6kV54Pk=;
 b=DUuwLDwSCwvwi16OCv7MM/2TN85g2Yf5t49c3gZHS0sKmUhIHrf9qhyG7EAFAnuQ0DDPzVm3+Pz78ZHt/UzQ95O0TeRcducWZQMfsjQc/XC6GOQt8chf9gfVs2/BCxT1Fk+7n/Cgy1T2ixSlXPsEarZSvsg6v4+OBr/QWf9RMGdxhiGHMB8TyfIlTeuYhe0rMaZ7nxJwOd5P/b66j3k/UwxveOj3sq/qaqXoD7qTWV0CXyUdnMv5ONTogzfgc1xxEQVjuIVVDK0UUMwN7MYiTI2aRbu+nJVgm6GfvO7dylg2H4u93IRqhl3EJEbPxMwKrmNVXRcVb7ZvFugy3h4MQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by MN7PR11MB628000.namprd11.prod.outlook.com (2603:10b6:208:5f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 13:09:02 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf%5]) with mapi id 15.21.0092.006; Fri, 5 Jun 2026
 13:09:02 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: Xie Yuanbin <xieyuanbin1@huawei.com>, "david@kernel.org"
	<david@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "mchehab+huawei@kernel.org"
	<mchehab+huawei@kernel.org>, "Luck, Tony" <tony.luck@intel.com>, "Lai, Yi1"
	<yi1.lai@intel.com>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"lilinjie8@huawei.com" <lilinjie8@huawei.com>, "liaohua4@huawei.com"
	<liaohua4@huawei.com>
Subject: RE: [PATCH] mm/memory-failure: trace: change memory_failure_event to
 ras subsystem
Thread-Topic: [PATCH] mm/memory-failure: trace: change memory_failure_event to
 ras subsystem
Thread-Index: AQHc9MMbuFRq4DBri0iidGLQ1Pc5G7Yv7Z1g
Date: Fri, 5 Jun 2026 13:09:02 +0000
Message-ID: <CY8PR11MB7134514CBDC8434CD1E2BF8F89112@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20260605081213.154660-1-xieyuanbin1@huawei.com>
In-Reply-To: <20260605081213.154660-1-xieyuanbin1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|MN7PR11MB628000:EE_
x-ms-office365-filtering-correlation-id: 3450eea5-6f85-4d6b-86f1-08dec3039d78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|38070700021|921020|56012099006|11063799006;
x-microsoft-antispam-message-info: YKbKxlef0kv22IULLgcwkb/+qfsMSplYKMWroyMnpc6CQ5ERNaYOg8cvPfkUJ7C1rRnPG8Wsk2JDL1vFIrKKEQIf4ZEamjFFN63L0ojV7QdnyIGE5bfqFMjsvZJhljoe8zIw1CpM0UShhUPak9YQE4670mfojFo/gWnB2/th6eRQ61KPBnPHeYI3aMKPNWvGRR/4+TPJ538TJ1ABd7c9K7I7C858tOfvVDfy3pcWCI9AqIbEO8LyYTZhDrvd2iLKMQ/FootFksMJU0uIFzhOCuFzQvceduuJZsMSqCXX6IbajpTQGZW4GRziCKERPuVsvkKecubfiy4ZGnhUQRwWl20xtNhF/TJKPsGgnXSNBmA3gb9uLQi2zrU8KwZSlTQNsdI8/Jywl7P4RCJ18l7yhjxyGGC+dqCNiAjSDE90lgPLraYXQRqb0YlWSZ85coD5vfrmWhjxnmc5sGS1qAppulTOTT7h0O53ptROYDJbiZWXadpTuNpzUoLq2I2PmtyksTmDUvaSAylmHaIF/M8RFsv4sloSij719eRq+Azq1w7MOPHUfm0R6wk4YI/Y2xVnUQkVelCcUZ8U+MZlGRnfbOf5uNxa4wFYCjOY3x0o6ksaMhs7dYFwPbE+aINpzQ2T7vZHv43Zg8Gwe9DM9De447njgcoW8TYT7PAnh9VJsjKD5Y4PQ2Eah768Vo+2DkjF2AMM91ISSe0GfJ46UR+P7oa/ppqNT3gx19UPQJEJIaJNhQh7Di/uOnOihkYM2s3x8uu9lja3+5kOKUhytXIf4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(38070700021)(921020)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OU7VnrCyghSFyhtK7E63TMTB3oNqh1DznjhIe6KHGSREsh/UbaGNl/mvmRW4?=
 =?us-ascii?Q?GrDnk49wy2XnTjoJiA1JLegbdLnPKevcCJ8h/IoaxzeGOahW6Ql1tiaAfVhx?=
 =?us-ascii?Q?AZn/u1ZICh6i8yIRJ+MVoWBk8UCVOgOiCZ0sDEDEAEe+mu+OfRMDphT1ZnlC?=
 =?us-ascii?Q?k3VDCtWoGc3nRra61oKvQQ8VjndoFYi4WOkA4IP+ifO/XcaClVEt8i9eOTgA?=
 =?us-ascii?Q?x135TZ6ZAUu4ypWbyHq5EY2qCquqpkleavmHZViNqxHul+i6+mJLkJ21VBFu?=
 =?us-ascii?Q?/31qJ/CPB0AiqSUVbvuKBBhddCJmNUxNdBs0yTQtqh/S4P+bvliqMRNi/dhc?=
 =?us-ascii?Q?D8jrnvRBDnwTDzvSsYSkQkBERyRP/81cDC09j/w9ln7gwMh+U1lptI2RX6T5?=
 =?us-ascii?Q?JAlHoDQal/ltxaWnxxWzT9yeKrJ57vnzOUBe/pqDMeJylkJcpWHS8VoTOYOH?=
 =?us-ascii?Q?tg8E12csRIX4yiabYh4o1UZHAhN6XK4u7t/W5PCfLDEw4/QlrMlGJ9I0yUXZ?=
 =?us-ascii?Q?n0cMnLVw/AQGr6jpOcNr5Cc8wSjURmc69LH+4Z8/mNLB/3KM7T576jgzClCU?=
 =?us-ascii?Q?yuX3Z8QCTP1uCkyfI9ClB8x5M8xMr2S3Zs/gHgJUtKlFM0uJwwRAvzksf+GO?=
 =?us-ascii?Q?2lGwQhZ35t5PnR00cU/ZQym50HCmy1nTU6ZQQppgPnemC+wqznIJuku7RUTJ?=
 =?us-ascii?Q?kAXv29jiU+XIdwBpE53iTQYVIDMfxRPTCN52/k/9N7KDLBgWgYFKnYY9UQx9?=
 =?us-ascii?Q?ffh5w0wZ1JrLbvUDe0YGb323TASEBtGGS7h5E1BxISG1E2hMObYSIQbQ9NdQ?=
 =?us-ascii?Q?JZ7TeobOmzyeNYO1J0lOOLWzTwGpvb+ZOSe7nKx/rd2kp/A+JkL4PKtT5zHW?=
 =?us-ascii?Q?a5dkTfGntIOf8cZ/2rnI0ujB7vI1Qux6kv2hUWLRNwD+AJNaFiX7DeDo+NPF?=
 =?us-ascii?Q?OVTuGzF37h3CPosoZBSTs/Uc8kRnlI5xppt4ssZCaOy5PmXjePYqldW4+4FX?=
 =?us-ascii?Q?VMVNn6OtzsbnEIT5qh+to5DXcE4fwBl1oHdpDZkQ2BwmoGfKYADbgqbG5pWW?=
 =?us-ascii?Q?owBNOXotW+KY6X6MP54pDoxs3IWWtdR9NyEg4U+44gBlK+NIUZcE6jt9Kpi2?=
 =?us-ascii?Q?J2Jc0XsUBTozP8/MEI1KEgxPnW+o3G+GWYMeHr0C+16FQmaN0pAwVcs3sEqE?=
 =?us-ascii?Q?KWY+UWLwV6MM2gsqG3WroNpGNmQgQZbW4q5fsH20d4wzkolRQRehsC4jwogI?=
 =?us-ascii?Q?xbQGlcNRvXeHSbGob39PSUn0Ip4qLyaxgB5u0GccELjiYNMeyyffztp7RTX7?=
 =?us-ascii?Q?MaFVxrCyrPFsUj+rVo2TN7+QrSg/Pv17NX2tANDAvslCKsIz0dT4W3ZFONJq?=
 =?us-ascii?Q?BlZUySpeAPnn0ux/uv2L6IIRWEWVnygOv4TnTwySfry83kdTZFuD7W8JKpHn?=
 =?us-ascii?Q?G/2lv9oxERMlHJMPIghI9ajo+ZyGYoGjU1aLtJIab2fvqSeBd8cT0ixlnO1a?=
 =?us-ascii?Q?t0hRiSmLZHWcyLBcuNvB5nk6SJOai7h7KmDXemhBaq+oBFlvR8oQie/FE+IN?=
 =?us-ascii?Q?ATFVrvSAeCjmwNxNPGKBGHGZb+MYBat37tnL1tHmWWHpeLe55jLnC38k0HRj?=
 =?us-ascii?Q?/+W3np86xxoJUr6dA3tJSW3aHJFo0Z2RpO/GZBst89UdAlpU6qo+SDrH9vt7?=
 =?us-ascii?Q?S2th/AqO3cuy9IYOnNaEMB7F5BqUluyE4jsOpXwFCcC/Fwpn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: S7Ail+6dVg992NdUrIgpB4HAKmZdsCBBO0WHNewsF5Er4FGRIJyWlD7mqj3wdYev7l9b8ctGv1fxe6vxSoPN/6lkFedVfULdW2xh2jSCi3Sp4eVNqDKLSszJ6Hx3QyxVSrRpRqPphADRor5R4CvcRwhuyS6557U9jTQdZWYReRSsUruzEjRaNpCw9K9JgOEGaw77+T1pIX7XkfxW1NdG10pItQuyeYHU4Z3H27atpwt7kbo6awSLPPSLFfyJ+MB7mQywuD4GwCZ7Co3bVAHNT+c3X0Fr8nh8hfV828WQlaloSlNTi521KN2ciAh42dUJ+CTjF7fvowyw+I9XMOexuQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3450eea5-6f85-4d6b-86f1-08dec3039d78
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2026 13:09:02.7349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdccPW/69DFcCMne9GivQZfzpuGwsuO6cHC936SW58y/Xi5HQW2UM2z6Na/5on5M6vju/hQfs7YLmZ1fZFJHlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB628000
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: npwj64zs3453hi78nytroedjru1ysn4j
X-Rspamd-Queue-Id: 441271C000A
X-HE-Tag: 1780664947-780524
X-HE-Meta: U2FsdGVkX18uPlXy4Ki+owy7SAs6O91h7Pt0syri5DkcsdsuNen6gZ1yKpMVILXNZuQ+HYNLUkek8GR7nZY9/h50wh0Iw6GSVzhu/1dCLXPPMVI1fDY6LlXjl67f1rfdmCywntRaD6BoPe12EjOFT6ipf0uTHZ7faudmb/UVTpVLqSm4wmFajSydQmtpoqN6cGriXQu+qVyepLMLSNRmbJ+ze7DtR3+lUNR6llVxJLluyh5Rd8LzaelB3dK7h69Xzk+UDA0S/asJLZ0sfWeMft2Q3unQSVLF/wqD5fICqZzVSyAvur71+hLHCDUzRtp2Wn3/OIKDALFZSgPVb6NJRjvBO+G1fxKDnJ7YITN1bqfm4E0l6gjVcH0MQnXoqPJ65AXtCgM3tWwYTCG7Mf6INJdrEwzUj7fpXGCAV/7DzCbLgKErr48ZBy8AcQr9KgQ/TUFbi/Ad7808J6MmebHfEFd+oSRs2lChSEziIFnehwm1MjTFNuL1Lfjpo40sgjGjcLyLa0W71PK2+/iNUnZjazXq69JAtQulZ9ZoF6h5lt3awtmIj1HGKAB7Ni59JpWj/Gv7T+yui3kx7glZVeUs1ZK2Ez/Wve8RG8Zle3LzmoEjQmnPcMaEukLwTu7oE823UWH8Gpx8EyZo9c7+5N8d7Vglp32lsl4z1OETjQ6whezGGYzdkAtHPFHXV73oKQLnTBD4W1pnQHKMvUB+vXXO3/+vD1K2/L57PLwsegWjyk4H10qGny1FIRlQHEw0Ymcj0mRj58H76nGZ8lJhINX5chJB2VCupWWYMple786IM82P3aeJ8xPkfwJe8ZHid+qqjp3qn0XcCvmINuVOn/dWFgFCZHk1YhB60WvMMBUXHLnDM7AblSVSiNVpprznjHHlOM3aalTdod//0V75mV06cXxQNDbN0cQRQMP9ENjacmhBDbabigLgi0lwPbrDR729ksYEs2rl3kqMEAGPHvs
 Z89dN9Pn
 OwPln8D9qUZ7gs+FzJo3G+DCy5YXE9gdmdPHU8lLA1h07US8X0BFJ561rFmpD9eIC4uDv0r2Li27D7hzZ/3oVdpOLfAKNMlkNTw2wPQ4qnbyNWv5bXKJi2dRlFNzo8kdNZlEnrjlaY7ARuIiLOa5gmdUlnQsItVR5Zq1NoR78y0G+1sCYQYytZmJEvFD2xRxDfVJJ3vUt2gjwKADGaqwXEN4cn21jUonSQRPDhq9+bAVb/r27BGLbciYnpN6zHuihZGLbZ0JQtQVgNmT2pZJ+z3uxlR0P6TEPi9gDuf9wguA14zrIamMYDEGIKNzyfZFT0QdJM+MBBdG0F6de3BxtRW5c/ICVfkStwDsgTLzeTe5fqe/PBxS+SBDIFqjt8/aQEyPIpW5fS1IBuqtV6MiYqsRNUQBCaJm0cL9Z80fCj2svf0JaNVMFhfxs77DZw1ZyB7qKKZFK9lMGNVy0ywul1IYxUS1MPX1J4lXIZC0W+7Bqle6Y2SQQI/nl3CRM7/NJKE3TagahFQx9n8wv5nljoPAoECb9BwZahb2pCra3r7HhJ8ehvxR8i+4Cm6Wac1+MJHT2H9Qp9/JTD4SFEFfnCjil0kMNFzi7Kmln15eUM3+X4K9Difn8UfIXV1bJwqRTFnT8G6dh+pU3ONVQSY5ikhKjpar0vYGh0QkEXY/s86bCK4+0SvwP56sdTLPL4asGYFuH8b7beFOskE0lYtcuVAp6IlEuUJ8r2Gv9HBE26VtOznWPO8Ow/E2hqE+oDInDlndB/mStk4niwYBwirz+tAPqf0ALD/Wjm+NQ+kqlvn9MHt89GIe6SqLURqRQYEBMMOwacw+DLyRgyzHjA0tb4/vJamQoqcTcD0yf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Xie Yuanbin <xieyuanbin1@huawei.com>
> [...]
> Subject: [PATCH] mm/memory-failure: trace: change memory_failure_event to
> ras subsystem
>=20
> For historical version, commit 97f0b1345219 ("tracing: add trace event fo=
r
> memory-failure") introduced memory_failure_event in ras subsystem.
> commit 31807483d395 ("mm/memory-failure: remove the selection of RAS")
> changed memory_failure_event to memory_failure subsystem. This breaks
> the backward compatibility, some user programs rely on it.
>=20
> Change memory_failure_event to ras subsystem to keep backward
> compatibility.
>=20
> Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")
>=20
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Closes: https://lore.kernel.org/linux-
> mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.nam
> prd11.prod.outlook.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

LGTM.

  Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Verified that rasdaemon can enable and receive memory_failure_event on
v7.1-rc3.

  Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Thanks
-Qiuxu


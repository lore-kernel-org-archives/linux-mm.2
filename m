Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8BAC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31826B03FF; Tue,  2 Jun 2026 03:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2D26B0401; Tue,  2 Jun 2026 03:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A830F6B0402; Tue,  2 Jun 2026 03:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 912286B03FF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:55:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 367A3A07AF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:55:39 +0000 (UTC)
X-FDA: 84834213198.23.1023370
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97D97180006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:55:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gwiXjyTI;
	spf=pass (imf16.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780386935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnTZ4X3otd71DbLTqeJ+j7Jky4BITP7k5EetcFHCOsQ=;
	b=RrRQw6zkMzNA5J0srL9ALpsgAsuJY3sFrjyBaAoBswE1LvGYlM+c7jl2IhRu0hb/Habpqt
	LYB3p9PK4pHXaP2Ja4Evt+4VscQ0XVRrJvSviLy3pUEREQk/o+6Aqsopj9Cg/9bStLbIsA
	WK9et/aicbl2tvVoXnjUkClaxnc2bKE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780386935;
	b=N5OS5AuiJP6loiEEKDdsd7UCdeYVHq2uLNl+si3dKWX+XJJ4HS1iaFsyXPw7QTr7mg5h89
	sSlXyIt5EdleM6w/zlr6ebFX5JfpJxEwS+ghgf+2Ire5Vduhiknk803642fi52uWfq784A
	U7t6Q1M9s0SvOS/CFOzTY58R+pabbAw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gwiXjyTI;
	spf=pass (imf16.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780386935; x=1811922935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zn+v8GYydyhEdWr8kL3E5DJGAkZ9Qv/dmMgOAFNhcUo=;
  b=gwiXjyTIORrEQwoBePkLitXCo45RTLZjDVMLgX69r/KUEvM6Dalluylk
   xVMmW0f2kmKKya3qDTFWp7EjnC9wwrbdKziuzrXMLaIT7wvUcSwTCRCp/
   CmY+z+28R25+s+RNaMG9A3MMJBafzvXC1+4PpZbb6cVGC7OvABbZ7qSDk
   5NkTCC6C0BTBdY8AreHdC+I7Ydeq9hzcHKNe+hbnDow4fRLDwrhgTAvrU
   YFYqRMyr8JHW3s7MQqCQQfGLR0+hIax8zH7NTk21ebTHB6zYAa4IY5xH9
   P5R0CKp50wpHEiWZCvaCk6rK77R2KdPdcDDMrKAJQkYllegMDkHEW6sEd
   w==;
X-CSE-ConnectionGUID: 8NN9IZfJRLejp0G7I24wLQ==
X-CSE-MsgGUID: bxYSUkhiSk6wLAeLhSj8Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="80195679"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="80195679"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 00:55:15 -0700
X-CSE-ConnectionGUID: sNXFHW8BTXaFNWiOha1BLA==
X-CSE-MsgGUID: AHf+Tm3JR7+CrQmX8BwjMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248111980"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 00:55:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 00:55:14 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 00:55:14 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.14)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 00:55:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kV1rZefsXPdlk8jS6ounpQZ4aJla5yi+fdnxuvHAj0tSLJRr5bpQWzfpC/dbspX4CD+SvEj8RJlPfVRp4GE7nyuC6iBpHACMp04r6m4jewBVWQDksg+y3SBn8sgTQfSd8nkoX1KkQpKQ9Nwn9B5SEjkKMimMMuclTewDfRW3HwbHGXAABaMl/Bc5TUkiH1Ver1/6ZyIMQcHsoZ12sLyXI1D/HbidFt2mrbk34IZuv2Pi/BTUoyNZ218vO4RnupTKbjlTyIIY91AEJr0R2+y+Tq0IU16iWEvl7Cz/XClmbE/jFN0erOmaSpTVLpoNJNOLHz6JKiJdgsURqsKPftgMXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnTZ4X3otd71DbLTqeJ+j7Jky4BITP7k5EetcFHCOsQ=;
 b=BJ6jmZNOjbQ/E2JWEP8EGUUvhVhAEhKE7mtTPYzJDH850VBCA4wrrx1cX0jMyrpDLo4kPShw6npXLhUmAIb3bOjQ61I72dN1/3Cdnp3B1NmrNNY4o3pJSTvX8O+moFoqqU+h/SlKGBAwqEZYtN+JjyycB63V1uvAhvNJcENi4wDqED5pXF3eNNA4U7A2cpUoOhaTAqWNK2V1iNVRBKeOyx8XDKBZioGj4oC5SB01s4v0TotU1SESi8fb3/B5kl3p0O3scjpWsS4UvdisnA3/vyxvNnjJx++/3RdDsBSuRw7O/D+OKz+nr5SpV7ui5A6dGCYQOHJ8PSUwykQMEvQhOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.18; Tue, 2 Jun 2026
 07:55:11 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 07:55:11 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng,
 Jason" <jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Topic: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Index: AQHc6DwJDfX3zlWKz0C/zOkb6gw/RLYX1JeAgAHOQPCABM+wAIAMhKJQ
Date: Tue, 2 Jun 2026 07:55:11 +0000
Message-ID: <MW4PR11MB69363A902465ABC015CE5E2BA3122@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <20260521033303.7jg66h4sxwi4l3cm@master>
 <MW4PR11MB6936A4383B3EC638A4B24ED1A30F2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <20260525083554.6x6l5y46icekegzg@master>
In-Reply-To: <20260525083554.6x6l5y46icekegzg@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DM4PR11MB6311:EE_
x-ms-office365-filtering-correlation-id: 375ab1e3-82b3-4542-db74-08dec07c45da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|38070700021|4143699003|11063799006|3023799007|6133799003|56012099006|22082099003;
x-microsoft-antispam-message-info: ZSi4wcag29u7Hxisk072uOcozUqWDjeDP9km7jCrd2VFVqJP/tO/z1sFSpG9Z28C2iu3YsSieFO8x4y6jicwfz6EFzxeqRdIy7WU9u029Cl36So4fxIMSLcSayKrGqzexImCBNxfTXL5o6Zh8Ie90LPA2Ljc/MCin3AqeuHFQQSQwi8fqicEcMEd1mRrc1Ne1J2YcdGBECWKTL9x5Po/Nm/w00FOF27hX+SBR8Rv40zzGDbqoqKdkLGlZYe0qF1vjCbokYNsKJRO1tc2xgN5Z/NrADlhsNJ0Eg/w5AjJGzz6HX486XYKf/htMf7TRixCIBWoPamINEF4PGAPxPaoDaus6Xq5Hewtau4OZalUmBg3Xuy6VPJtlCzHHkGEqGxQ/AMIozkhNyXAptgKmmaWNsrJFxCUC7JEZ1DzIKcyqBF/u/5LcgfQjK6nIKO5A6GvLbbos7CCn/n71xkpG4FOHM1HIoNz8G3GCJ6lEx/5iCgou0F/hiJ5nZUf0igCJzn5zI64NFJZfAVEvHyfVM+l87pTSnao6yHigHnArQbLhsGbETs4g3uxiRTbszW9I5cRV/JGC+9X7SE8SjkpSgLGHQq9jo6KGD0YEFOwfgkbDpxYMS7v2a0Uc48bnn/H4TCOmDxHm0cqsB9eHIgOEJ/5HCLyq4PEKoxqymUdBxEqttw52kBNkBB8ubgiOuIQok+7k+hVHK0JvSfkU7yxVImCRUS+uChmoYXE/YuLifZwTMht/0UKYtnaF1nlrdglJtcz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(38070700021)(4143699003)(11063799006)(3023799007)(6133799003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fMVPJRO8U2BbDHDFx+c2+MX671dv7d3nBv6Qiq9oqjpnTIuVO3oRXR/7TmmD?=
 =?us-ascii?Q?zFxTMk+cuktA9HG8jRT6RwI1mDzfx9jFHlPgzeEaV7nPOLQP1bFEI6lZJ+Mp?=
 =?us-ascii?Q?4ZWTSVhKLZ31gTcjALNAG/PFG1B0YhRLzngJvN01iW5+JDfRAqjlvKMR6XKT?=
 =?us-ascii?Q?jyjIdtL5nrmyrQQkx6ZaezE9rerCbqsRu2tHM+d9pno/5/rrBwNstpuOGsIt?=
 =?us-ascii?Q?Tzv2Gr5aTB5xABbZnSy/yDnp9LUe1Hwlv2FCO9AmtWbUWRhY53Lnx9z86LBf?=
 =?us-ascii?Q?gVz34KL4vmlhc2nIoAwadQPGL8hGVAOK0BMcvUpvBQHLRLwUTaI+oKrM4xmO?=
 =?us-ascii?Q?kAGNJTGWXZGa3Lvv+Xws+QAtHxEhrWrTceDZsozvDe5DW+pepLsyBEzaNP0c?=
 =?us-ascii?Q?I/4fzp8QZon2d31YpuvHb1if4nlRDALrdliI09qjpEYw7qrydAToPh/Jcbgc?=
 =?us-ascii?Q?GMbOuw5X5DMuOmTmr5i9YOfU7gzn4fVtnMsXAIvvyYLA39w42jgOvlnTby8y?=
 =?us-ascii?Q?gjst2yncUQ6P5zcBG/s78LdLi8HVk8n2jflCY0D1LYQSosYDP6/RXbS41icV?=
 =?us-ascii?Q?rjUOJ7++d7Xp7vdOvZlm5cee5eMP/r32o3B+7Hx41A98RQfX5vtuBlWa28Po?=
 =?us-ascii?Q?54X1ugvb5GFP0MA1I8Ik6UsFfnQVHSEwrTqZ6nKPpThBl4HOCSu0yt9q0Q2H?=
 =?us-ascii?Q?3DOhN8qHfF4hN7t/ZSblMURxsIqK9z6M86AzS+galgZK988QgwXRh3NZXFB0?=
 =?us-ascii?Q?SrMibs/DNoGCGU9A9Rn+EPVY/humwRi0+aPsAKSzBy6A9+lRqU+r/LP8fDaB?=
 =?us-ascii?Q?H9gErFCEEVPMy+/RCk1xDm5tedKs8blEoW3TXFE4nnlv7s6OCiVWnV79Z/UX?=
 =?us-ascii?Q?PTROFfO7FLW33Ud0uK6R4TtIa46epFxRqu09dv4X7Y8vw5IhK5Sp89XStPKS?=
 =?us-ascii?Q?xh/o3ynzZJXpvXMe2WXR8K9zAL8D5LerrsgdBwebLP/LU1UoZ4y3s8GJJInc?=
 =?us-ascii?Q?aZ3EVIRdSxTXzs2h2PAdazTphah4OJpPxDmPOzPvQD0h+gH7b+4ZiC76fLCE?=
 =?us-ascii?Q?f0GbH/hW4NAxaNUoKfJ/w+XM9JzHeFpwDGrq95pe7M5yZUnbkT16ZCT+fzPX?=
 =?us-ascii?Q?9zstncEBpDnhwZEtHZz21uPph1genj1wdrbqCJDgvKFd0f9mYSGZ1C4+9tHy?=
 =?us-ascii?Q?iHjEwo43xDC+IZd2Mwr3iRv1r3LmA9wWn68V/Lfzygs1Mf+mFAste0XfA9av?=
 =?us-ascii?Q?zEAlq+u1rNgMYk3T9Omf3cAIbG7NJIHafy77gU4a/qNBbuSPcpYsUm6bNUWb?=
 =?us-ascii?Q?pY8LL8l3/eGnQiC/2euNKztvvZKz4DJ4sid86NTQCcjZOL9hUtX57ebB/U+E?=
 =?us-ascii?Q?lKlFvSYvKntx6hi4veunsWELBJW9jm3TiJSgCaY9bkBgaIo/8h/0DfaSHdcH?=
 =?us-ascii?Q?xsOmW8ARNx4l6qYd1biZj/fh4Jja1yjZTW9whU608VKSA5dFqbJdgKTI7Vtt?=
 =?us-ascii?Q?41SvN2dVu31XTijOcXkxgPA7dG/M5rqw+B7iULRFs9GhdZW2v7qdziX7iTRT?=
 =?us-ascii?Q?PnWFvht1lak4Er0oBo8Z/vl7fSv5v02ljfVcCoS75dOwnoE+niC5WnCFeqLJ?=
 =?us-ascii?Q?IDhHGFjC9c9n+WwOYg7heygPTqN6jp0Xtxv+Qja7BCIuTqUv1yWt4GwgR7FN?=
 =?us-ascii?Q?UEO2GqUaiOI9P3Ny60mvFfJymn7njaMFvIgHUI5V7jZyXOWj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: p50cieO6obsii/OcT88gvMUJi7J4L+2KtNuNpwoz61qm+sL89RhkrivhiKTpZYg6+6yrmB+CjPgokc8/wJ0riRBmCmpmWHtdrPPa2M0Q9nf1jt2EUUNqnZ9EaoNJ2XgRp5Zfx1hkSBiHa6IyAlpP6g8bXTT1D5n2udVPo/ETI1yE/2Vblah0b0+OVDWzVPX7VAHN3FR+BjWWySf2UBNY/gezpIA+0A4lZ6pa4oydrKymiFQgu3StRTcLc5QIbjtyzrpkaqT78Sl+BVEmYVuaOskKkX0SmmRpwIwA2QWk5/4L4RdsrZSrJh4Ppu9iAAhhbH4s4kraupKMcajqN6DaCg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ab1e3-82b3-4542-db74-08dec07c45da
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2026 07:55:11.3080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: igrzvj54bhxRoMx3lLnsSRIwfexTC65ATPsBg5977XMDTv+b3NRCJNvpULm1+qoLpi2Tef1jzB57FGr35/2I4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6311
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97D97180006
X-Stat-Signature: fy9fzzci551zonfk3fegdbbdid4eziem
X-HE-Tag: 1780386934-377179
X-HE-Meta: U2FsdGVkX19Gr2izNpqNbSHQWGjgTS/eW8t4IF+7rZsJMKsqHZbqKUl+ppfnTkgGFIGTGhHJ7qusUG9ffXOKbCQbky2MNICw6wcxJVvND49C/R53v+qPOt3HfiRhQZLxLknGNBav1yZUdCd7KjUH1tiyTLREWI+bY9zegOtN5mOXBXNr3kUU3z+QzJ7SvXYYmO9EM1kNcZ5xt+XVDQHr3fKJ3sQqQqBz8weWdhGJ0KSCgs6ihERiRzhe5VGZeMpmp4G499wl8I14XuFfuJ64/Gjk4zQd/4/bL4PXKBEhq0s4saeeR9zin2ga+ki616LprVEiIyHUYmm/woXijyYHcY1GMbeMFVAm9LSI3BH1Ksg1aXJdXup1DyuD72Zfm3dwurou2F81h+4OjggwE/qB3sYRheza9YSj9veevQhXcVsrJbDIhF5wcRRT0hUCrkGSjEmdOlirRkYxHszAn9Nnma8Onou7J9KgdBA4SeUYqT3ZhzX62RLoIKTSgMfIAPshuULmXk8dJHXg4JIIl9CqZXDocZcs1MWppPRY3JBVxiQMazO9hV3lskkBpPfLcbauTwS5uV/lWwExfZ6gVKV2PrWwy1iaVLP0IwepzhzJ66/5lwj+nelc08BSJkx9NADfAqt2NesuTEMX+Tk6HZ/ulnKSjAU+TVX0sIh+NpXYna+funepT13qcGgy4AKao5tgTrgl85ImCt5KLzxSpSan8ShnkOT9D9v9WnqvddLSO70KAOasC8yh3EiZFnM1WKSyAdg/Y9dl2tEoA5GYWi+7kTZygn0w2b+YKEUeI0AGdckV1x/UegFrNVP2UEKnDDrw5Yx9No3Cck8DnOLNl1hZOnoS840DMcikxZ0Nb6WbOTpC6AkHIPkDCuCwsy85gATLsDSTIkyIAo64jDY1FC/lMoO/ZoNmF6P4lfgCpLPnAijcGxZatx+QxIusLeBNvwYup3IhT/wWVPCfTkyataE
 WwAn9BUY
 GDR3gNc8mLATfAYgKKBExokcnmxsYH38ypIQGwoi+VjfUwb0YdSxOIaR4Q/UQ09fFFAH4p3XUoBB90X4QEs2VDPRXOxRo9OmeGQ0nKPo6pmrFW/lKaWek80+UHHAQjJ75xndFqzC5sVYxVo1ZN7cbgwAU7+fdJj3SCU+bDE+hYnclxHo0zNEUf3TGDEdwrOg7VQlxUn+aPSsNs4uPLUtvYu8aLMSxNGpyJLy5CkRoXVwEqayHWqhZdMjO+Sua5fYTMFCCcyGL8bQaa6UXHMN0LivCp6dxj36aJmkMfQXOaJ0JM+bjEfXTjj5ESOlffGwD7Z/z+TO4WxZO/MHbdtllZFsXefIuW97XlyJwZXz3SqDeXysPQoLhsqkJrjU4rEJ+FPokLzZ8qG6GAPBh1ir2gCO+Jha9nG3wLuxfVTqeBgTaaDlqtttJJnWJyqQLpHewE4N8Tf29NN0oHfNJICOSRVL527MykWrpsQf2qsAoNdC+j/C6K6phkRF4GsrkD33DTtJjsUwcp45wxL1bJ/No38opdrFAUnhmJujJlm09rYVDEf6GG3bNXhPOgEm2jFeGfu/+EzqOGZS+5HKgcwd3SRD5YSnxs6ris3Ovl8q3T+OUV3h48M45/m8RMFSM86StH1QFYgPRP9++1QRqIo0/EjoeJvfXEcmnXM9XRDAXr19QMGc45qUdIEwJ2uaMAjSJ7IY4NahZMLvRestcJHm5NlYkjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Monday, May 25, 2026 4:36 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>; David Hildenbrand
> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
> <rppt@kernel.org>; linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou,
> Nanhai <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>;
> Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>;
> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
> Zhang <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to
> the outer loop
>=20
> On Fri, May 22, 2026 at 07:43:38AM +0000, Liu, Yuan1 wrote:
> >> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking
> to
> >> the outer loop
> >>
> >> On Wed, May 20, 2026 at 05:34:53AM -0400, Yuan Liu wrote:
> >> >Move the overlap memmap initialization check from memmap_init_range()
> >> >to memmap_init(), and replace the per-PFN check with a memblock-based
> >> >check.
> >>
> >> The description is a little simple.
> >>
> >> Even I know the purpose, I feel confused at the first glance.
> >
> >Thanks for the review.
> >I will try to rephrase it and provide a clearer description in the next
> version.
> >
> >> >
> >> >Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> >> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> >> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >> >---
> >> > mm/mm_init.c | 29 +++++------------------------
> >> > 1 file changed, 5 insertions(+), 24 deletions(-)
> >> >
> >> >diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> >index f9f8e1af921c..24e103a402b0 100644
> >> >--- a/mm/mm_init.c
> >> >+++ b/mm/mm_init.c
> >> >@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long
> pfn,
> >> int nid)
> >> > 	__init_deferred_page(pfn, nid);
> >> > }
> >> >
> >> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an
> overlapped
> >> init */
> >> >-static bool __meminit
> >> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >> >-{
> >> >-	static struct memblock_region *r __meminitdata;
> >> >-
> >> >-	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> >> >-		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> >> >-			for_each_mem_region(r) {
> >> >-				if (*pfn < memblock_region_memory_end_pfn(r))
> >> >-					break;
> >> >-			}
> >> >-		}
> >> >-		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> >> >-		    memblock_is_mirror(r)) {
> >> >-			*pfn =3D memblock_region_memory_end_pfn(r);
> >> >-			return true;
> >> >-		}
> >> >-	}
> >> >-	return false;
> >> >-}
> >> >-
> >> > /*
> >> >  * Only struct pages that correspond to ranges defined by
> >> memblock.memory
> >> >  * are zeroed and initialized by going through __init_single_page()
> >> during
> >> >@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long
> size,
> >> int nid, unsigned long zone
> >> > 		 * function.  They do not exist on hotplugged memory.
> >> > 		 */
> >> > 		if (context =3D=3D MEMINIT_EARLY) {
> >> >-			if (overlap_memmap_init(zone, &pfn))
> >> >-				continue;
> >> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
> >> > 				deferred_struct_pages =3D true;
> >> > 				break;
> >> >@@ -956,6 +932,7 @@ static void __init memmap_init(void)
> >> > 	int i, j, zone_id =3D 0, nid;
> >> >
> >> > 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
> >> {
> >> >+		struct memblock_region *r =3D &memblock.memory.regions[i];
> >> > 		struct pglist_data *node =3D NODE_DATA(nid);
> >> >
> >> > 		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >> >@@ -964,6 +941,10 @@ static void __init memmap_init(void)
> >> > 			if (!populated_zone(zone))
> >> > 				continue;
> >> >
> >> >+			if (mirrored_kernelcore && j =3D=3D ZONE_MOVABLE &&
> >> >+			    memblock_is_mirror(r))
> >> >+				continue;
> >> >+
> >>
> >> So you have figured out the memory layout of mirror memory?
> >>
> >> Would you mind elaborate?
> >
> >I have a Xeon server, collected mirror memory layout information as belo=
w
> by using follow changes:
> >
> >int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t
> size)
> > {
> >-       if (!mirrored_kernelcore)
> >+       int ret;
> >+       phys_addr_t end =3D base + size - 1;
> >+
> >+       pr_info("memblock_mark_mirror: base=3D%pa, size=3D%pa,
> mirrored_kernelcore=3D%d\n",
> >+               &base, &size, mirrored_kernelcore);
> >+
> >+       if (!mirrored_kernelcore) {
> >+               pr_info("memblock_mark_mirror: mirrored_kernelcore not
> enabled, skipping\n");
> >                return 0;
> >+       }
> >
> >        system_has_some_mirror =3D true;
> >
> >-       return memblock_setclr_flag(&memblock.memory, base, size, 1,
> MEMBLOCK_MIRROR);
> >+       ret =3D memblock_setclr_flag(&memblock.memory, base, size, 1,
> MEMBLOCK_MIRROR);
> >+       pr_info("memblock_mark_mirror: marked [%pa-%pa] as MIRROR,
> ret=3D%d\n",
> >+               &base, &end, ret);
> >+       return ret;
> > }
> >
> >Here is the detailed layout information:
> >
>=20
> Thanks for the detailed output.
>=20
> After some investigation, I got two things to discuss here:
>=20
>   * current mirror memory would disable memmap defer init
>   * confirm the mirror memory layout and may simplify handling
>=20
> Before discussion, let me mark the key point in the output below.
>=20
> >Case 1: efibootmgr -m t -M 0
> >Enable mirror memory below 4GB, and no mirror memory above 4G
> >
> >=3D=3D=3D zoneinfo summary =3D=3D=3D
> >node   zone       start_pfn    end_pfn      start_addr         end_addr
> >------ ---------- ------------ ------------ ------------------ ---------=
-
> ---
> >0      DMA        0x1          0xfff        0x1000             0xffffff
> >0      DMA32      0x1000       0xfffff      0x1000000          0xfffffff=
f
> >0      Normal     0x100000     0x7fbffff    0x100000000
> 0x7fbfffffff
> >0      Movable    0x140000     0x7fbffff    0x140000000
> 0x7fbfffffff
>=20
> (1) Normal and Movable zone end with the same address, so overlapped.
>=20
> >1      Normal     0x7fc0000    0xff7ffff    0x7fc0000000
> 0xff7fffffff
> >1      Movable    0x8000000    0xff7ffff    0x8000000000
> 0xff7fffffff
>=20
> The same as (1).
>=20
> >
> >node  start                end                  size              flags
> mirror   pfn_range
> >----  -------------------- -------------------- ------------ -----------=
-
> --- -------- ------------------
> >0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2
> yes      0x1-0x9e
> >0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2
> yes      0x9f-0xa0
> >0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2
> yes      0x100-0x66417
> >0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2
> yes      0x777ff-0x77800
> >0     0x0000000100000000   0x000000013fffffff   0x0000000040000000 0x2
> yes      0x100000-0x140000
>=20
> (2) You mentioned no mirror memory above 4G. If my understanding is
> correct, 4G's
> address is 0x100000000. So why this range is marked mirror? Is there some
> limitation for this?

Hi Wei

efibootmgr enables mirror memory below 4 GB through the -m (--mirror-below-=
4G)
option, and configures the percentage of memory to be mirrored above 4 GB t=
hrough
the -M (--mirror-above-4G) option.

My understanding is that the layout of mirrored memory is determined by the=
 BIOS.


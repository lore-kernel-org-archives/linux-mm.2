Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88327C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF3E6B008A; Tue,  8 Sep 2026 04:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496DE6B0093; Tue,  8 Sep 2026 04:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F276B0099; Tue,  8 Sep 2026 04:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3196B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:03:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96F2216044F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:03:15 +0000 (UTC)
X-FDA: 85189854750.26.C203EFF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E01D40005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:03:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JbA8AxFZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788854592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9qYs3sqsDf5944lLqhPqUMD+ehgIbSzWz8zGLra27Y=;
	b=OteRzfu5LMG8NjT7IM0Dm1izJgWS6LQquDzI2B4fHaPEi3V5s6mx551qfFQ63d91uAzV6Y
	8nvlmBXr3UgSTyzPpALh4gVG00JEYzVAGPT+Fxq2Cm66n5bJVrqo9+iLKwlrnSgFACiJU4
	+c0xnIg+r+l4toHGklCLAgSV5ESyiYU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JbA8AxFZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788854592;
	b=HH9v6DyGrfp++Ga7pzTRwGv2T/X2M4jtUMBUPOiNteGnc3rbsMMK1r3pIpboWrW0DbH2N9
	pQh6jfraSGZfc7YJfu7xzHGKp6zUeqBNU1jufE6bWAS7xSU3t97Uk2CsLxozxh6FEC7v5b
	2PZO61PPrsVUkuSSuw387H7UbXN+82s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788854592; x=1820390592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XCzf+YTtAk5WJZ2LL5Uzsku0YdDkSHKEvm3rDZ9X1Jc=;
  b=JbA8AxFZew6ZiVtsQjYE77r+bVvom9PcFkIZcV2kRRG/3VkWNsVi13pW
   QQG9O04oRsrCDTU9qhrVVWTzsZUEMznfFw08iTOZFt/z6t7pDa4UX3/83
   TGFKdDg9vFJ5pUUA1eHYQRAXSKXjxCluVA2uuAKkhA8EfIpKKk7lkCLlV
   EOGKeKDw5ktXPs0/2JhehwU5I/MjU1+vXr1EYe7yxfWpM+DsTdAPj8YDx
   cqSiqmbnxq87wTReooWR5e3fs1fJUfKP6gDa9r8UtX0WKZ3NblTduO/3A
   a1k4SlbzLked7mHU0ekT1+/E24lHjnEbwykN3HMrxukr3f+XDHAjFam1g
   A==;
X-CSE-ConnectionGUID: sm65SMwxTROwoV/m+0sJOw==
X-CSE-MsgGUID: mpbJlxG1TRyKhOjob88UMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="92949708"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="92949708"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 01:03:11 -0700
X-CSE-ConnectionGUID: +yY5S5jHTOOeKxaPWGtdvQ==
X-CSE-MsgGUID: TzWk2DfiS/i3VUee1AGzQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="300806227"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 01:03:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 01:03:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 8 Sep 2026 01:03:09 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 01:03:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fmIGKDC8OgojyFjuFtPkfUiBfXk2hIDpU3ulY4t3F0AJO4VCzzBnMW4XaWGhlFmBMZPhERvAmmuKkHblJ4JU+2lHDBzdzKhfRmKz4JJRu+rTCSAnlqxH1X7P7kTdiMnmMR8VjsQnmYqqkP3JHocYiBi0gQ1D/4XMYoKy/1KwGacFQ1f+Ln95rwONyKC5gh2kZOg8iD5TutThhVPF+8RNJzuowlzSbttvZl8bH6TmBVnSG+G3sIgre6nbd4CuvuwNK4wJe0Lmok00EJeHDUE1vj4anJdCvr0Tp03mhkqcxLucu7g1OV8rlojLK2L4I+NlBsHWUmLJj5fkVQrwOzbMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9qYs3sqsDf5944lLqhPqUMD+ehgIbSzWz8zGLra27Y=;
 b=vLU2uwb3/BnkpNXtx60K+mMP9rm8Akt5QhKW51AC+zEAuxoD8xG2n/3zjoDZgQagYcqNq29HFIeMDweW7oPAM6ltBS4orsA//QUX37FXS3wsjYOPcORQ+49udJ3AGeC62TfwuRSIZhfKbQfIiRB1o0ukkBkozABxpzA3HvI2gDl0q/eEQZ90rzAXs+bMPapNwVj6rwr+998FMUTa5mI/HW9Jd+w3Mu7nRxZifBuIvfstRuUBszVd+e5HthmS0CuaEGB3pfURf6u8sS5vNAU3voWLAicx7oDM5aCZtbWXW6SDG6FvjriD8s4FuS7dgN4gRgDzef3Qka5VcvF71qt+oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by IA4PR11MB9393.namprd11.prod.outlook.com (2603:10b6:208:569::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 08:03:04 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 08:03:03 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdOdJ3NlBSXbnrNkuQIAyQkKw68ra+DTwAgAZNcKA=
Date: Tue, 8 Sep 2026 08:03:02 +0000
Message-ID: <MW4PR11MB693634C6F602E234E7C81D8DA3B12@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
 <20260901052950.3284540-3-yuan1.liu@intel.com>
 <20260904073856.5r56imgrwtpe56wl@master>
In-Reply-To: <20260904073856.5r56imgrwtpe56wl@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|IA4PR11MB9393:EE_
x-ms-office365-filtering-correlation-id: 67484fd2-b5b1-4cf1-37b7-08df0d7f9b89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: GhBqmwE5ozEpi3gA5idM4dMZ70/yJLL95DOAy0EroTBfGuqar4WMbApTCGEBhF1amH7FMyoL4WeRcHixfAZVcgnyurYg3gjDKj41320gRWqoekZozRNivTSew8bvcOmgUGznkX5RYMGCakR1db2jluvBu/Ismb3rGGWTwWrMWgrnZkrZOoHl7/j1NaWfnKmtirbk/miRXPuYJZx48axJ6ZLJujKqmo7TpFEp5sKltQQylYOLZkKN1PoXZ8guBi8S5d3NQJdAxyUtOSV+elQ+i71mf3m6sp/3kxs3r/tTV0ezqXzS7tfpIwQD2EpmvTBWJZWVkgbkSHVQRoYqQ9747J0AViHN2ZZFZiQYT99eb+G1oo8X1vZKAAtjMbU375y7RSRxr8zm2Qjxpp5RCCh/g30wQ6ZIAXosTOmgootOxCfEvmEr+SnYYeDaysHGfTB8RhdqLvrxUPzhwbgvoZf/pWydYSmtX2nnl7nLrN66r+d9soty5Hi6ncS809+v34QB7rjMEcEqaCJVdVKJmC2T9dS4RBF5An5V88LjHZUGAhGvmMAC/DXct5Rz9AN+1lZ+ogQerGjxEoEa5u6vY7bQ3r1EpQuHeLYLClfD0oMt/ESxNBG7s+4nSJDK+BAsHd5HNPZwmSM8Wgo8lLTKZQZoyD6eekRUND5CNLGS27hFVKtrh1d7dksWucY4FbS8fAbTksQbSsaH/hxPMcQkdzcflg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IPa4Z52TM44q/CiWuA0rwYKcFtbzdXakimYvVk20gkPHXsv1t26C5Crktv5R?=
 =?us-ascii?Q?zA4/6vswv7KNH8gUJ6WdPRLX7sj0KUv1aJzaoURfMja8ZJh0MYjXWMG03M+C?=
 =?us-ascii?Q?Jw8ehvH0ka9YMYEIN8HAp8cd+nvmuGYHhcrsu2fL4tpyUbph8RRNlw1loyD2?=
 =?us-ascii?Q?dSvtG9TObENvdPiom5WTe7wcUy1MPy/rMB8yapNgkS4M7ZQpHcB0iPh0D4wt?=
 =?us-ascii?Q?IMJzV+jpNEF/jc4hTOIdgYlSad503DgGlTBz8XJkuhIAhcWSNN6ZYeLv2AR4?=
 =?us-ascii?Q?q9f9IGm9c/cdbtBXR9Q9stnowM5/wPjC4BKoZAwZgDZUwfP8qSRNcwkltIgk?=
 =?us-ascii?Q?QkDwy+KqsJd4SB/dNKGQyTZ+CtzoyvR7++L7D5WduGVFQ1MuBFopCI3qkYpi?=
 =?us-ascii?Q?V1Sm9hcAsVh7Zb/r+YndERflSmVDtAn1/ZX6nX0bIa9lzscwvBTXo48xBKTV?=
 =?us-ascii?Q?AkD3jDpOqCS3y4wiKZqZm25NmmUV4VWzvgWSpyBWKDxKFCpADDJOphlyc6DR?=
 =?us-ascii?Q?84qsNJr/eTSVG7JdMO53tYmhy/brWn/1as9eMAxaWq9662s8tZ90bifz3MxG?=
 =?us-ascii?Q?Meg8YHjdl8CGFexWKiw+HDdG0ZcfR1ExVOJWVySNHBibnEonZ3xAeOTdq+OG?=
 =?us-ascii?Q?0Fd3AzstC++RcNo9MHxdMp8eHLOKwHAgP4Vm5DZ/ydddI94LHFkId93X6m45?=
 =?us-ascii?Q?+HSzD20ehmCCt2f21nd7zFvSYN4lwNgX8N/8Ait3Hx7liw9oSr+8PY+7frZY?=
 =?us-ascii?Q?14iAXwVeLtjZUeoMcxI5zvcU2UyzUDbEg1dG6ZfBdZM+DR0CH9T26Zf81yW4?=
 =?us-ascii?Q?RFCL+uZ8DBDWpElKfkvUbvOQ8Cz3Z7UbP34S7j53RcoOO4Bq1m+BM8Qb+Quw?=
 =?us-ascii?Q?7g0RHPmZfu9z9ds1f0U4rtMnuSR3Yx18XPz955/1Rek8JPaHyopZOJ2s6Z2/?=
 =?us-ascii?Q?crUAESr7mxRf83yjXQR1ewGTq8RV1Yb1XScthJDhMMKsyOVmbhdYQ4CnbQFq?=
 =?us-ascii?Q?ac9ZbRMrvd4YKg9a6RhaRUeG8Rjibt8Io+GMBJVRTsG3pRC8EIf4IoxgbYUN?=
 =?us-ascii?Q?V3zQsvrhPjaTK1p2Ydn+9rt7xtIL17izo08/kxroP1+FBFA6Q2OmZH5pL8k5?=
 =?us-ascii?Q?ylxMDd6cj/O5ySySyBx3LGqvBpNZh/hcKvw2AuUEorWJ0dxiFaaWw8AVtzat?=
 =?us-ascii?Q?EeoChrUktdKQ7ckbUa9CIXvt2fZqF7WqxaS+QJaOd5t00ZVwM0rpgkW1kLto?=
 =?us-ascii?Q?GovNnyrrYogNQlyL9+u4MeCqamQ3XxIpjczSkhMYuTQxkbl8xb4aL2lbSNVQ?=
 =?us-ascii?Q?zQiJbPZ9mOPYobP5xP9wUtaVKkJ3o3wZrdNLHzyVc9s75S4Qy20uh8GMreEW?=
 =?us-ascii?Q?XQ8jClNDRbCgZKggShIKS3YeaNdygA2v4yqTyPYjzC9GrLg4prB2LqxdOXni?=
 =?us-ascii?Q?9yPV/uRb95qhxGPP6A0mMuYfBT0jWGUTr6JXB+O1CVU1nYr9Zwb3owHNdmp5?=
 =?us-ascii?Q?WFMSEwKCDyk4eqsix3BpksP/1tgjS+0qeqs8ZjkHP9AfcqY01virNHG85Cg+?=
 =?us-ascii?Q?iqeQ1WZkSglDFRJsZ27sBSZbVPjLfB7fxiIunmoOlatD2Fh08s5Kg4IEpZYr?=
 =?us-ascii?Q?1H+1QfcYDO4eZ7cp6DOiqYZvJ+qQu0WRnv0/nZbxeKHW1qV3wtyeoqlW/LpB?=
 =?us-ascii?Q?ebSmW9uNfCEsao9xxSB3YOs+A5JAfzsyiqGp2aiBTEx/qIOz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: cjjqsCRFmD1tvu6B7BGnCSXf7bRkSBcObCbil8BRLly750cIDJQ/emtXm9INlTjHJBiQQg6quPO5ks837CBP3M+z4mNf2xarxxWjaZG1PaloDf1WsdBEXJVR0ZKdUg0VmZxMulGmcBKBjLyjC7psv1cD6A1NarGJlxIqeM6u8k9o1lakcBRn/Y8svORt8GHJ7a+gOcIkOjU0G6MyTLLViyQ/oHfZqsgMwUYQiMQz6fwCxgsuzbSuvqMLJWWkqq1m4+J+wGCucR3ePtY0wZoqvbd5Wh/iFSGGUxoGwXlqlgbjBsf2dfMbqAtNzpmSFMa8de3q4L9/aOKc5yWaw4HFug==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67484fd2-b5b1-4cf1-37b7-08df0d7f9b89
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2026 08:03:03.0217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0RC6Wj5WF5HpeXV2bVESCl4XUNzNjsToG/GlRdwza/E0/B/XRoOaBAcFHTGZIPLWIh686zXHTw6cQQHkrBofyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9393
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qyptxo5th1a4ngk7bqzyb9tjbya3dnht
X-Rspamd-Queue-Id: 6E01D40005
X-HE-Tag: 1788854591-592304
X-HE-Meta: U2FsdGVkX19a/iKbQi7qjFqAtwRiqmKmFwbgPBxRrOAZdkYiD/nNuADHRyedxBQon9CxXyivF3JE4s+gEqpjd0gDrletOjRH55nbZiTwGtuKuNMKj7NdPugPzESbZYzRHvTA/ThDb8EGq2ZE74GvzWLV5k4/1bXWp9+lnIVFezczyQRYQuU3Ezk+HBHjkMqw8S923wRI/p/+zYt0rjlugDKU2GoXFJW8XMHVOUkvpYKgwemvbRVHnIlQBxw0sQLaRnANMJn0iShZ5l0+7E7A8Iqm7K+7mTUflqeKIPsKugr9RI9jYeOtiv30YukjQjawcRImLpH9rJEqm2uwfOyujMi6I+i6yw+RzA+w+bGBePgp5KKaPmfonBYWZu2sGyk8rSYEQqGFK7dSFe6A8L8OaS876fM1WUKEwozIXCpiSX89q2SmVPwLMVg2vFhJOQ+qtv4nQKGCN9GVCzIha0wMCBiZsuPPse9GwqBkBi4SeKyDXHUy9xncREaRtsP+lP8pfi8+6SeN5dl9YTQhLpox6qDqxtXlMsGjzrll1h9pq8NDDnYgEPSqAFHkVXh9P4Tl51ZMjMU7GbeZuo5K2wDJdL+bZCHdhMIScr/d/PmQT7pSR5ej1p/AbUkPkIBF3Xs87PHD1i0f75IKWjCNfHir1YQrj/raCRLpsGBPP9Ot21uQki7pqCiHbxGKlPnZD0Jy1ro9qSHksXF0VI8BFEtRyv29xLNOt5HE3Lw4Bh21Gqb+ruj/V+NuEU1LSc3nUteNzVhUv5b1ZfK7cFucUxssYdFnxbtP1Zt/m8ciulroixNwbmENKA7QmalSNIuuaYvhSxIAolRYPBWhLvhbosrQlpZOrcschgPqNtGbZdWKv+bUTvXEXZ+l4mJMkHIeHouIf2Hn+yOsgRgHY99WDh8DkXZhpGOlyDRqnlDR2ui6P3tngGajiMAWEVhbvDXr7opaSEifUU5pssV3ZBenVj/
 qjiCUDC9
 OHtD6JdpI/XlEOowizPbAWqMcp56ODyOu4n7v0VZZ1cAVdfB3SjsuLKl/OZXthn5jIhHSCrvB/eMB76gRfBqfodNY5N7fQyrr4AgYGKLbt2xrZnmDIR55MFTTYZ2Hp4r96oPAJv+IxbVaMaYukovbnTi8hKUSbq5TyOEd5rrRCrfYDDCWXGi5NszHPkDBepJVXUgNFAvA1YzV3aMP8DJq08jK4ZbIqkMyUXXpVpO5Z+5VaJ4vBzgSjVuml/mZDsfpbaYLlGCGuJt7WdOAXs/7AxDbueUT749gM/WxqT8Gta1ZDluMPce8/LarM5zPtPnLhzzpS3NiBW4SsbTaUFOWgqfLKNCO21TcNSHnnui0mtxWvc6G6lXM27ftGK39ezK0X8s7o+TR6dD8eTaLpR1CJx1Hqab3cxTh91QBiCzFBK4HuVCTw4vuKa2U8YoNjudgaR9jzTsvxXPOMpKkWvy5l7F+DfQgLF5XaINAFXs0C3ce7Nzf3rgZRbYeQMAtVeTrLddxlQ4XzAssrtuzycYi3PkC/TpzyJ+VisROkiDT+TD28T9Uk18XPqTzgh5iKdVGNjODJaE3WA7ZFNpUlUPQAL9fTVwuZCwUrQHwc6JRHIvLkYVTY9GJGFK36ll2GBePAV4TZPyaXoy1UXxQwELlpHk4R0Nyu984QCaWVegJ1lM+OzgASmbC+LkqXp6aHNi7o3rjM4Cdp4QpKeczTdwLZB8WtFiwj4EeigxiZBetyPwH/vhcS2Pt5VpP0nFgX8Q3uHQK5ROyB3d8W/zRbyxY1/x5TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Friday, September 4, 2026 3:39 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
> <nanhai.zou@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
> <jason.zeng@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous
> check when changing pfn range
>=20
> On Tue, Sep 01, 2026 at 01:29:50AM -0400, Yuan Liu wrote:
> >When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> >zone, set_zone_contiguous() rescans the entire zone pageblock-by-
> pageblock
> >to rebuild zone->contiguous. For large zones this is a significant cost
> >during memory hotplug and hot-unplug.
> >
> >Add a new zone member, pages_with_online_memmap, that tracks the
> >number of pages within the zone span that have an online memory map,
> >including present pages and memory holes whose memory map has been
> >initialized and for which pfn_to_online_page() succeeds.
> >
> >For early boot memory, pages_with_online_memmap is calculated in
> >memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
> >included in pages_with_online_memmap, and hole PFNs for which
> >pfn_to_online_page() succeeds are also counted in
> >init_unavailable_range(). For hotplugged memory,
> >pages_with_online_memmap is updated through adjust_present_page_count(),
> >which is called during memory online and offline operations. When
> >spanned_pages =3D=3D pages_with_online_memmap, every PFN in the zone spa=
n
> >has a valid memmap entry, so pfn_to_page() can be called for any PFN
> >within the zone span without an additional pfn_valid() check.
> >
> >The counter may temporarily undercount when pages with an online
> >memory map exist outside the current zone span. This can only happen
> >during boot, when initializing the memory map of pages that do not
> >fall into any zone span. Growing the zone to cover such pages and
> >later shrinking it back may result in a value that is too small.
> >This is safe, as it merely prevents detecting a contiguous zone.
> >
> >The contiguity check using pages_with_online_memmap is stricter than
> >the old pageblock-by-pageblock scan. The old set_zone_contiguous()
> >iterated at pageblock granularity via pageblock_pfn_to_page(), so a
> >zone could be marked contiguous even if a subsection-sized hole
> >existed within a pageblock. The new check requires
> >spanned_pages =3D=3D pages_with_online_memmap, meaning every PFN in the
> >zone span must satisfy pfn_to_online_page().
[...]

> >+/**
> >+ * zone_is_contiguous - test whether a zone is contiguous
> >+ * @zone: the zone to test.
> >+ *
> >+ * In a contiguous zone, it is valid to call pfn_to_page() on any PFN i=
n
> the
> >+ * spanned zone without requiring pfn_valid() or pfn_to_online_page()
> checks.
> >+ *
> >+ * Note that missing synchronization with memory offlining makes any PF=
N
> >+ * traversal prone to races.
> >+ *
> >+ * ZONE_DEVICE zones are always marked non-contiguous.
> >+ *
> >+ * Return: true if contiguous, otherwise false.
> >+ */
> >+static inline bool zone_is_contiguous(const struct zone *zone)
> >+{
> >+	return READ_ONCE(zone->contiguous);
> >+}
> >+
> >+static inline void set_zone_contiguous(struct zone *zone)
> >+{
> >+	if (zone_is_zone_device(zone))
> >+		return;
>=20
> After this patch, set_zone_contiguous() is only used in two cases:
>=20
>   * memory_block_online()
>   * page_alloc_init_late()
>=20
> If I understand correctly:
>=20
>   * zone_for_pfn_range() won't return ZONE_DEVICE
>   * there is no ZONE_DEVICE memory populated at this point, device memory
> is
>     populated during do_initcalls()
>=20
> So we don't expect ZONE_DEVICE here?

The code does indeed work as you described.=20
However, I would prefer to keep this check. The zone_is_contiguous comments
explicitly states that "ZONE_DEVICE zones are always marked as non-contiguo=
us",
so I think making this explicit here is clearer

> >+	if (zone->spanned_pages =3D=3D zone->pages_with_online_memmap)
> >+		WRITE_ONCE(zone->contiguous, true);
> >+}
> >+
> >+static inline void clear_zone_contiguous(struct zone *zone)
> >+{
> >+	WRITE_ONCE(zone->contiguous, false);
> >+}
> >+
> > /*
> >  * Returns true if a zone has pages managed by the buddy allocator.
> >  * All the reclaim decisions have to use this function rather than
> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >index 9f19876ec3ec..100941d1b828 100644
> >--- a/mm/memory_hotplug.c
> >+++ b/mm/memory_hotplug.c
> >@@ -549,18 +549,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
> >
> > 	/*
> > 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
> >-	 * we will not try to shrink the zones - which is okay as
> >-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
> >+	 * we will not try to shrink it.
> > 	 */
> > 	if (zone_is_zone_device(zone))
> > 		return;
>=20
> One question not closely related to this patch.
>=20
> This check is introduced in commit 7ce700bf11b5 ("mm/memory_hotplug: don'=
t
> access uninitialized memmaps in shrink_zone_span()"), at that time
> pfn_to_online_page() couldn't handle ZONE_DEVICE pfn correctly.
>=20
> Then commit 1f90a3477df3 ("mm: teach pfn_to_online_page() about
> ZONE_DEVICE
> section collisions") enables it.

That's a good question. However, I don't think it is directly related to
this patch, so I'd prefer to leave this discussion for a separate patch.

> So could we remove the restriction now?
>=20
> >
> >-	clear_zone_contiguous(zone);
> >-
> > 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
> > 	update_pgdat_span(pgdat);
> >-
> >-	set_zone_contiguous(zone);
> > }
> >
[...]

> >diff --git a/mm/mm_init.c b/mm/mm_init.c
> >index 1533aebafb68..d40a8ff23370 100644
> >--- a/mm/mm_init.c
> >+++ b/mm/mm_init.c
> >@@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long
> pfn, int nid)
> >  *   zone/node above the hole except for the trailing pages in the last
> >  *   section that will be appended to the zone/node below.
> >  */
> >-static void __init init_unavailable_range(unsigned long spfn,
> >-					  unsigned long epfn,
> >-					  int zone, int node)
> >+static unsigned long __init init_unavailable_range(unsigned long spfn,
> >+						   unsigned long epfn,
> >+						   int zone, int node)
> > {
> >+	unsigned long next_chunk_pfn __maybe_unused =3D spfn;
> > 	unsigned long pfn;
> >-	u64 pgcnt =3D 0;
> >+	u64 online_pgcnt =3D 0, pgcnt =3D 0;
> >+	bool is_online =3D true;
> >
> > 	for_each_valid_pfn(pfn, spfn, epfn) {
> > 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> > 		__SetPageReserved(pfn_to_page(pfn));
> > 		pgcnt++;
> >+
> >+		/*
> >+		 * With vmemmap, at this stage all pages in an early section
> >+		 * have a valid memmap and are marked as online. However, only
> >+		 * subsections in the subsection map are actually online.
> >+		 */
> >+#ifdef CONFIG_SPARSEMEM_VMEMMAP
> >+		if (pfn >=3D next_chunk_pfn) {
> >+			is_online =3D pfn_section_valid(__pfn_to_section(pfn),
> pfn);
> >+			next_chunk_pfn =3D min(SUBSECTION_ALIGN_UP(pfn + 1),
> epfn);
>=20
> The range iterates by for_each_valid_pfn() is [spfn, epfn - 1], so we
> don't
> expect pfn exceed epfn?
>=20
> 			next_chunk_pfn =3D SUBSECTION_ALIGN_UP(pfn + 1);
>=20
> Could be enough?

Yes, that's correct. Given the range [spfn, epfn), pfn should not exceed ep=
fn.

I'd still prefer to keep min(..., epfn), as it keeps next_chunk_pfn within =
the
scanned window[spfn, epfn)  and makes the intended range explicit.

Best Regards,
Liu, Yuan

> >--
> >2.47.3
>=20
> --
> Wei Yang
> Help you, Help me


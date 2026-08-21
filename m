Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930E8C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A25A6B009B; Thu, 20 Aug 2026 23:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778E06B009D; Thu, 20 Aug 2026 23:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667D26B00AB; Thu, 20 Aug 2026 23:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC5D6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:17:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD0808019C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:17:47 +0000 (UTC)
X-FDA: 85123816974.03.4053E6B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C09440003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:17:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fjGx5GWh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787282264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubh43q0UFT7kHT2AIqdckzyjRyOu4ybweFKIOHGUOT8=;
	b=6bpNOL2vMSD/i2jz9BSdH6vUrBpuFJ4olWtLqU61jDqRgq2v9AmQVGvgdspoR+yJ5BJVPG
	GsCiAl7DqFyWU29JA2n5Xacg9jRJ/faelxIO4V81SJ6iuaAYiyCTqxRBeGr8hpG+J50NiB
	qzmwzekZmxG4L0etbxtGjm/UBmXZy88=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fjGx5GWh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787282264;
	b=omLszPKhI+obtgQq4ur0XGrWxszq1oJHInLzfE6sdD4n+opLEPKaI8oDIdHeYVeEZLkA/y
	F803R0dtVxU2mKJ9rBlMEgYxmMCHdKKG4jNOLqRUIJNzppfOCacZHpom9NpnxZKJ1pijxo
	fshNPIkf8mIrhdgImeKktMiNx07suEM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787282263; x=1818818263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3c16f4nMEB+YHerlFpL19nSjTHwcqGGanfnur6odXrg=;
  b=fjGx5GWhAX0e+Jid5f1w9YSwkH8uZk5qZjFqyKhtzPzBcS/wSaRclRSP
   QzV+BAH+GqS4yO6WT9ui0Dco5XLes0TrAvEuBBLodUSegJTH8x/fhvk24
   3Lw645iYHIIZyXtdDDX++2ZjXIAlunPqxoGRZLcqs2z8cyyq2sRnuIy2K
   IvOSAxh7CnBtoTfLUqJE77MgF2bYCKm5/JgwK+Y4EHs7KAAoCHvgsCN5N
   gnxG9skyqmAQi6vdlJPC70NObSeByYva9QIIIRnwvbYC5iz5PbqqgrkQB
   VaecHD7GzZI0DgOWt7AP4ceJWDAAABY1UfIsFa5Ash2m/zlcQ2CtV1cDL
   A==;
X-CSE-ConnectionGUID: v1XUwV+BRvCAtxLS5U2TzA==
X-CSE-MsgGUID: uyv+AjDFTeCsq1pZK6FILg==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="98421471"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="98421471"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:17:42 -0700
X-CSE-ConnectionGUID: lhCoPxNpRBGt/YW/ukHhAg==
X-CSE-MsgGUID: nBuhUerQTxek/KMoXeBHeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="296127558"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:17:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 20:17:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 20:17:41 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.36)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 20:17:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxE5rAwkBKdtp23Yq+H6oGLONt1QdwxpFlk7XzvlI+Lnxvi+zXIPpBfq5BrX+ppa21c2BWGq9KaU4vpSuA0K4mURL+oCySMLNwVd+KpbFbtH7Uge/0k/P/yDXFyvKKmmr0bk8Xc5CpR86/mxCz7n5j1cTJPGmg0Dt3Yy5yqKX+SnymRb1qySvq8B3P9Iemb+C8Pcu5zR7qCoytcMtDE6NQTOzqL9xYgkJwUGy9V+ynE11OQYtdb39PSKMuphcOPStwerUOJNZF19yKtwe1AzquMPnxxBNwXAkxhzKYARxwwBu5asJFWM2CbH5rwpIpzlhCCl0gw8cflwkCDfHGJKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubh43q0UFT7kHT2AIqdckzyjRyOu4ybweFKIOHGUOT8=;
 b=b6sbGasXBMRe2mp+R2gO6joPrmtVapSGMeJnlivnVvwK+Oi+FJXZfEoaFYusSHllpmD+EbCZDN/9tWwTwJ/demsW1kp1Hnjm/Z2U9HxjLRfq2inXvc41yzyMzFIhttwyN1my74t+3DvvQqAt8okKheJNdT3OlAQJ6yR8Xl4AoE31bJiRGt5mI1+kzqe9qUUt7eV0LsmaXE8OH650Doc1N/ZCiPixGeW9z0zj6fRIvyAjC/JEC7oKFftorHy/ITrRpMtcLyaDXHp7bbKyUcqoasKTFaBa74TouFWg/iq/RT+cSofPXMLVyYfjT81A4E2xl/9aGnjgWsXJEpSpjbArnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 03:17:36 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 03:17:36 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdLu8R8F489m5sRUGA8lOjA7/dwralh/aAgAFm0GCAAEr2gIAAnm0g
Date: Fri, 21 Aug 2026 03:17:36 +0000
Message-ID: <MW4PR11MB6936054EC741918CCFC6FDD6A3A32@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
 <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
 <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
 <bf298ebe-55bd-4f42-9339-9567eadaa514@kernel.org>
In-Reply-To: <bf298ebe-55bd-4f42-9339-9567eadaa514@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DS0PR11MB6375:EE_
x-ms-office365-filtering-correlation-id: 313ce792-ca8b-475c-d0d9-08deff32bfc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: ni94TKjwzESZ6ZaOtE3TaQblLan6VhnzdiJaan0JnV83Vjg5CqwGKQ34l1Gomuc6juwxhsqKQzRrQRSS8Hj/FCrLOFVlEikk8Wz7ggvZKhNfXji/HVlZAHoyQUXObpLS87NCNOHnzmQHw7gT9cqwvyjNKqQudZDSoOp2qFy/ulZ2WXo4MmG1zFb7gJS5BHiRaDSEbenHdcjW1NE/ryxYmWP2ocK7OtZ8h4pP3m+FLMJM/5fNDqdS88+niPhuxBeWwtRcwe0cqhgI7Iig2e7wB8yCAajXo9L5hQGld2kbvNUlEliEfjT/35fJ4AS8AhHxojxGCDAS0vbXogG5GTUfIweBsgeRLYcXyD7MS+mWKPqUDjHm4KxYDrJOLJBQsQH7YkVzfheVsndBfOWlrfa5HooNcUQx5G8/IvInRmRmXQSm89nDHK8ERdYZ5eg8/fhOOdgTWtIof1icXiWUxGhqdsjI905etvABrx7xvV1a5deaQQYB2P0pyipr/e/PZ3qzc0TrGhBe/oQWAYkwpRMaLrfNfpEN2yPtWJdFZL0WDffDs+Q7rP8+ju+/9gXzmmFEJVtGWEXyuqRp1SsPbXGMPzAyMeUPro3UOV9pdqwGjYHU6xqXT8jyPCd2WKUBS6/007UPkneisW2ofaB2IxMHAaCsAOFZgR4Z8UW+np17sISLTJJSaZqY+Ed0YnWfrlL/Ingher61jHQLfP5FfZhmw5VYgbuCRiC+5box2PChcXs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s//48VAYNsAKrfdV0KqZ4Qp5inZjRmBGog9qynxB0c5ebuR2geFjbpqJQ5xW?=
 =?us-ascii?Q?rCJEfKxl3SbcI5rtql5dk9FvYESQYIebVZWJM+I8C5KG34Xltsc2MQckGb68?=
 =?us-ascii?Q?H378biZeKqxgxVeCFyxaK20uSuB59juq+IxYTbVVR0Ub/y6vI/5+W2DKBbOT?=
 =?us-ascii?Q?5T1oLqNWB1WBU/HYwhyuSSx6RDbXRqDsml/Ubg3lIGmazIgZIUMTakHVaucw?=
 =?us-ascii?Q?CH8Ztz02Jo4TKfwetK4H0Nz6bm6Xkdaw51fNZl+A+gbelPSJT/mcR/S8SIsZ?=
 =?us-ascii?Q?Gx8poZSflpTuCFtdYTVSKKrE/AeAJPCwrH4m/SIOTjlV8pnVzsX609guXiNb?=
 =?us-ascii?Q?mhLJDcLi6uyetFw/XfAgT8o+ZFG6ayAHXBkTJEiLPOnnlOi5ysxvPcfpWF6C?=
 =?us-ascii?Q?yebBfirYP4/FsdEoqpnoIOwKFDoefiduEOyWELbYEDPl7i7kMIMrh77ECuWl?=
 =?us-ascii?Q?N1NnubaL/aFNQBt4VJW/p+IxGRMmnjTeeYVwVdO+4BxJB/6co/c72Fpwc9Ln?=
 =?us-ascii?Q?EN3/fhS/8XwAVp9D61zfqdtuq8/kq2QxWUXDtXWuJHom1plBxHGDj98p06Br?=
 =?us-ascii?Q?aiBLH5GXpdwXXF3tNRdiojGk2U6wZi0rmi8qNDiE5nH2RV9TbuzDwmY96v7A?=
 =?us-ascii?Q?pfAuGpyCkh02QgeX+H5fzOJdE40FpRlmCj82LnBkfxnjoxIDuZF5w+e/HbvZ?=
 =?us-ascii?Q?2aXZZXhidpUpph2k5LgXkhBXHODkhuQDOC7kMaYgxMg50CyxFAVcciw9Ge0U?=
 =?us-ascii?Q?lzPZuLvKwD/bjJLMhosmpKVMFn3dcaUFyrblyPbQE1jgyxJEEbJfHeu7o6rK?=
 =?us-ascii?Q?5VxN2I0F5wUKpxPxyU6kJxNQGDEMNHSMOcqXrS3uE+QXxntBwQDn4usyW+BO?=
 =?us-ascii?Q?FLnUQTB/joT882nAbgsy1vfHV8NCl8z7XkXOYDRYPxE37BaGOawqbYmp92Ic?=
 =?us-ascii?Q?+wJr1YEH0tCCwtSMbIn0vnbDe0UMTU1g9Ue6EypfHk5SQ3QHdDIigf05LJyb?=
 =?us-ascii?Q?clnC/V0wEchy4eRt86jkqGNR1U5cPzU26QyeNkKBJup0U0WC6I2xI7OPFJ+H?=
 =?us-ascii?Q?Q/8AQmgP8pbCRgqLshRyrB3w1nUX7scoidL6qeWdchgGdjhR153Ypi3fVxzL?=
 =?us-ascii?Q?kjGnZl9imGlf0oU9AFLHBxQmxY1Bo/s0cLHP2znvTbWvZZDszQQIyMGeIoPC?=
 =?us-ascii?Q?XM+CM7uq3yiJh3qCTrh4OMMqclHBsR4BmaR7DrqH+fiACCM6HFr0sLgdVhrH?=
 =?us-ascii?Q?djDizUw/mKLR9RTb+ZXYTBxfOLakfS6HTUav1kSOY16Btw4TkJOtG87hL2Om?=
 =?us-ascii?Q?+B2hTwLqYqaKGfiQbjvXmurtLVnOjdfCr384GNMrJLvgltq+Sm8uKzLR5fAf?=
 =?us-ascii?Q?cvsRB8YH4iDX6J3lWzce+IkltSBquRITWb5NQ7gT7PkvMorwhttUNczOIZWq?=
 =?us-ascii?Q?IX/DbLXFfYp1adGM2CaFyYW9LVX7m04qTceawVM+83s9pA/LaE2Bu298jj6r?=
 =?us-ascii?Q?rxfFT5ra7SRymsGxx6PoxFoSTWaz5wcMicV80NRPjlQHaC6BFFhEiaSPkaiW?=
 =?us-ascii?Q?sVOE0vrynylPt38CbSESLpNo4rBM93fB8o/CHCRn/361AdY0xIwkRQy+nyBW?=
 =?us-ascii?Q?dnoEE5yVyot6b0y4MyHtTI1uIvJFqp7K5625i4QLOkWnY/CYX/W72telU0rL?=
 =?us-ascii?Q?YwMYMyOdd+cfAgoRAampfeBe2+w8fzcUGg29EVSY/U6QdKE7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: YgnYCZer3dCiOT62MfP+gFCLT6rdvVDQwQfB2/1tsZRnlHl+pBr/wm7eny6aXhNOnnsXTO1fjB4jWiD8v9ZW/LXAQGbXfYyURbXAwXX2E9bOLW58a9jEX2TrjW619FtyOwqmbj5yiaIwRIdKcGFd8S9d6r3TYSJWo6jMWLjhTuUGfeE5ZuXdclf7qBtTDVEFyYfCVX/VCVM4J3b9Hs43OaYH6TROtXzU93Pxj7dglp3U+gGT6+kCeEFMtGEpSobCj9ZUkKTrQfnNxxEMfO71bGWnmuebyFNmrUSQQOGAaxmYXOHJZzWkqxbai51CjF7Wedj5g8W37zruyC8IdEgZ9Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313ce792-ca8b-475c-d0d9-08deff32bfc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2026 03:17:36.3531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /OPHLMCauSIGEl+ng0ZPdvujxKk7Um9+B8+8CYx0dy5Y+6N7Yjw6rQ77+QyU2VSsNaP7JKtyEate8WMccFNk2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6375
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 475y3b6zw81ah7immf6rn1iyf8h7z3a6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C09440003
X-HE-Tag: 1787282263-511615
X-HE-Meta: U2FsdGVkX1+Fb9Wd4X1lKbxVV0Nhgu1CP0KwRCjFoedJpNrpaL+BuHhv3UlniPPclO6C1WJ69Q8NWRZRXxlKVtrVpEpb5bqGlNzsoc2OvaeGeMlqXsj79wwUnKzbJf1cGsqruxYTGeKCxM1xvLIrVm1vzeVSf09mbeqOdhMW/CxyPr09GJrr88mAv+5osc3ObNBlL4Dl4hk4YiF3jpUVgePCMi3CNXeFG9FXBR0fGnUMm+MKVR4fVvwihb6qO+Aqh5jcbT+la7DYAz6BCLytGSnXq6bhchRTfxhugcsAih++hEkahWsUpZ7f3ydjt1Xb2hGAdZPL8jUohK+fpUDW9U16whozc5QQrvWIeYJQYe9+SiZBKNdsHCHCBasEDA7GMiSupVJlR9o9V3ekhqOD+PqSfggwRZdKF6jzVOQfLpkt6Q02LJLM+IsMID0aEzGjVj8alXzkzSEiiU/Qlz+4Gq6Dwu4WDXcVLtK1Sr2KewzKz/LjxWZflcnGQI7cvIdn6Ae7gaRxbpfU/zQwdRQ+CvfPjsS2iKj7ujCKwk5lCFZDOgEdJsIvphqzdI0SfBXa2jKGl4FqEYYQE4f6knE4hgUN8B0giZj2Cb2c3xGr8/QD3rkeDH62j0mZaoIAnJIzmHrwwUj4d7Swyxk9fq31AcBVdzOH7xlJg/qbtHYvh3B5QZLhmOUFhiof3GzeeFXchyvarSW3Bc/x68E0Nh0caEXUV30VOxGbO7q+ymAJMwqh8iZGrI+cJ3o502l7fpdebz7cvpSruAfooo0ovkbHmMBCCJF7XYW4fF4zXU8rvNoom718kNJEvAcP37ar/dDfitp+kJSDCWZIaMJFVpilDam2pxlfs86jLm4/pMj9UPpwNFiR5QMUpZtMRZdgWm+BpJLraeTysbxW3BOyEwKZZzqz9QgxgstrnC9WXfwsfCo1NW/UaK6oB7XYdCb/m/mt7lCjkEBoinJvz4a+B4Q
 cPAJ3+fq
 zRq7r4xVDqiu2iilhNS8e0Eo7DRJsr51+FfZa30WFKnuAQ9GcOgl9EXrjSLDcGQEVsxlYPO06Q511FKF1dCGeM9jLZm1347CI2leBhZOAAlT7hJ71ZNNtCc/5H6S8WD4Sx4Vj1ott9buBt9n6MB6GzrLEKgJKxRaNqg7RdYi3b+iNXSoBGuQmt58VUy+pvCMTdeYFShkuckJfDCV0R5goNyBZRWsi3T787vkQKKwAmUcyxUcmgJ9lh4/REtuA07WnlIOAhKP8nVaq2i2Pxa7qGpMs7hnyGFbM/s92GUsVNXy9fZEzDYVu/XWtS4JpdO8XeJIFnQp9suW8+NfTZgkHbvf+zu6IVYPJ0ijzs8q80nkAsHU82Zy8efXHNMjSHuZPZyCeR2LxXib/2VAFXlKy9YiDzrNE3MgXwIbLDi+X6zKKTAwkvTGaJHs2K/+FlXccvwiRlO5R3TxZLaP0DzssebEdcqDjRQ5+PTZWFXMGQzSY6dyEPlDma4UR4OoxKFcMmVpWR462BMXaXnrmGJi7xRhFuWk95A+8AgXejiP4//QM3NXfjUOO/In+cdetcU/AqeyuM08t6Jr4qodoj1RsVHC3htxHtSURsdjYo0lJyzbqCKhQ1kXm2O+EFNG8gTVw9miX2pat8gjFU3qviZJafCHkmvQUb0ux33iCBjDIRWyxBr3JP6kQ71yNHcNVHRsmPqr1rZ+lw12TmbAaWpvq9aZOpA5iocDBckjh+/b7+VjKXnFW4iE7jjO+0XWKxexqd5sJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: David Hildenbrand (Arm) <david@kernel.org>
> Sent: Friday, August 21, 2026 1:46 AM
> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; Chen, Yu C
> <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous
> check when changing pfn range
>=20
> >>> +			online_pgcnt++;
> >>
> >> Can we avoid these helpers?
> >>
> >> 		const unsigned long subsection =3D pfn & PAGE_SUBSECTION_MASK;
> >>
> >> 		/* We can have section-sized online holes with VMEMMAP. */
> >> 		if (IS_ENMABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
> >> 		    subsection !=3D last_subsection) {
> >> 			is_online =3D pfn_to_online_page(pfn);
> >> 			last_subsection =3D subsection;
> >> 		}
> >> 		if (is_online)
> >> 			online_pgcnt++;
> >
> > I think there may be an issue here: PAGE_SUBSECTION_MASK is not
> > defined when CONFIG_FLATMEM is enabled, which would result in a
> > build failure.
>=20
> Ah, yeah.
>=20
> >
> >> An alternative is an inner loop that just walks in SUBSECTION chunks
> until
> >> epfn.
> >> That would probably be even cleaner and faster.
> >>
> >> I remember !vmemmap always only has early sections when they are
> actually
> >> online. We could extent the comment to clarify that.
> >
> > Hi David
> >
> > What about the following approach? It removes the helper and changes
> > the per-PFN online check to a per-chunk check.
> >
> > +       u64 pgcnt =3D 0, online_pgcnt =3D 0;
> > +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> > +       const unsigned long chunk =3D PAGES_PER_SUBSECTION;
> > +#else
> > +       const unsigned long chunk =3D epfn - spfn;
> > +#endif
> >
> > -       for_each_valid_pfn(pfn, spfn, epfn) {
> > -               __init_single_page(pfn_to_page(pfn), pfn, zone, node);
> > -               __SetPageReserved(pfn_to_page(pfn));
> > -               pgcnt++;
> > +       /*
> > +        * With VMEMMAP, subsection-sized holes can exist, and PFNs
> within
> > +        * these holes can fail pfn_to_online_page(). Without VMEMMAP,
> we
> > +        * always only have early sections when they are actually
> online.
> > +        */
> > +       for (pfn =3D spfn; pfn < epfn; pfn +=3D chunk) {
> > +               const unsigned long chunk_epfn =3D min(pfn + chunk, epf=
n);
> > +               const bool is_online
> =3D !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ||
> > +                                      pfn_to_online_page(pfn);
> > +               unsigned long p;
> > +
> > +               for_each_valid_pfn(p, pfn, chunk_epfn) {
> > +                       __init_single_page(pfn_to_page(p), p, zone,
> node);
> > +                       __SetPageReserved(pfn_to_page(p));
> > +                       if (is_online)
> > +                               online_pgcnt++;
> > +                       pgcnt++;
> > +               }
>=20
> I'd keep the for_each_valid_pfn() the outer loop.

Hi David

Do you mean the following approach? We use for_each_valid_pfn as=20
the outer loop and, with VMEMMAP,check online PFNs=20
in PAGES_PER_SUBSECTION chunks

+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+       const unsigned long chunk =3D PAGES_PER_SUBSECTION;
+#else
+       const unsigned long chunk =3D epfn - spfn;
+#endif
+       unsigned long pfn, next_chunk_pfn =3D spfn;
+       u64 pgcnt =3D 0, online_pgcnt =3D 0;
+       bool is_online =3D true;

        for_each_valid_pfn(pfn, spfn, epfn) {
                __init_single_page(pfn_to_page(pfn), pfn, zone, node);
                __SetPageReserved(pfn_to_page(pfn));
+
+               /*
+                * With VMEMMAP, subsection-sized holes can exist, and PFNs
+                * within these holes can fail pfn_to_online_page(). Withou=
t
+                * VMEMMAP, early sections only exist when actually online.
+                */
+               if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
+                   pfn >=3D next_chunk_pfn) {
+                       is_online =3D !!pfn_to_online_page(pfn);
+                       next_chunk_pfn =3D min(pfn + chunk, epfn);
+               }
+               if (is_online)
+                       online_pgcnt++;
+

Best Regards,
Liu, Yuan

> Cheers,
>=20
> David


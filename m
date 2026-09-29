Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC58CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0664A6B008A; Tue, 29 Sep 2026 09:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C506B008C; Tue, 29 Sep 2026 09:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BC46B0092; Tue, 29 Sep 2026 09:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942516B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:46:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23271A68DF
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:46:42 +0000 (UTC)
X-FDA: 85266925044.21.E3F4B0F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 687FF80004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:46:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rla5bRjP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of pan.deng@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790689598;
	b=nK5xFyK3ZLzbSyrqaHl0pVlnzIBFXyd/q+XMuRHluhR1lBeu2HV2lbGCEc12NZAh1iuXso
	aGuQPpXvibVZsE9BeUQuHnqYRFldfJWfeb1qZsqTbCBK+qyhcx+sLqyO23AUFIiTUCvb5C
	XhdCapNclbSp5/9uTFqGaaV9ezuqb9E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rla5bRjP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of pan.deng@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790689598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8lWqqBRTmdH5UFLh/nHd5Won2ex4wnbUCjLopuJgKA=;
	b=rZ39PT10RrnmmnChg8UkmBKbGaVR0HOtl/N7Z+n8milvrA4Q/463AcK7b41hrBMl0vSexq
	fp1pGQ2cYK0FaLmut2hVGjof/RiJxktwFQUfHi3UoRUIqmTUjsKy3FWVsG6eqyEpTgg4SB
	KkhkJViYVI91zZfcvyoGMrX4wndgzMg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790689597; x=1822225597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KDNNFDS1UlWMV2xeaX65V+72ALGiHOSt1Toq5y7XJo8=;
  b=Rla5bRjPenxlOObsaNjNB1NezqcF7ubn0ZHvBAYZHii8FNoEiZXME1HS
   fZ6JB8lGYRyVVEbd0gsyyMU5hDgW/3QGhurwyxfc5fD5OD9vt0yP5nwpj
   DLNNW/96xYlLaui49F39nAY8MC06xszY0GE+XUNrEMgk8XcSIA58yt6nY
   BlJYibt5VqA/f0uT+M2wV/JQnpkyKrkROWZ7+mDKlVeM8LNSHoXc3MRuS
   a/VilJ0jeKEN6y8XaCa/dhcST5In0rucKwhWG7D2J3k6s/MgaZj8uDUws
   U3ExpDHQ+l31GTsQ8jlu/tU3J4jT/HGAX+ofIA38uNoaFgC5pHauaFaZB
   A==;
X-CSE-ConnectionGUID: VCAj2MISS/mWntIX+iadkQ==
X-CSE-MsgGUID: dZXt2RiZS3G0fUHAeDV3pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100739677"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="100739677"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 06:46:36 -0700
X-CSE-ConnectionGUID: bq3pou3qQhmvhKe/HFuoQQ==
X-CSE-MsgGUID: u3Z48GBWQcqAF88VpHS4tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="278724409"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 06:46:36 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 06:46:35 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 29 Sep 2026 06:46:35 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 06:46:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQSEY5AQIqf/zmlQrBmAJdupvBvw9/DVj/2/trG5kMXGFGfYp7ikhOCAzQwwKnm7nu5OQ6qrO1kb+IeLoNu9bLi1FL5g75MJrANCRcQn36rOQGAzmPw0xvaPAdNi4n/Ebp3zSP5XcxNh0cXvpXWHsVbrrHZt6kRvaNO0xHudgpUW9eJX7DR8bsyoKYJKFRBRIsb6vMxEZn7NO8clJaCPVRKoiIYVHT0RGpg9POFaxdXnHIebu+lK7HoA7rOsBOIBiYwXe8HbFc1HZS82kLdmkhRMiAKSonee0w4Hs0i/joRi7zXtJI9rYuQD/sQAHqvooprS3HKgIFKXSgGsWIvWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8lWqqBRTmdH5UFLh/nHd5Won2ex4wnbUCjLopuJgKA=;
 b=KWpLF4sWBuQ30iEpbeA/eLiN+KioaLPc9AVf2X5RkLtgU6FBy3PBHMCNZDzWyF4EuggNho52RRSxNXDIqaAGTZIoHhPa61AYnGgn99TDDUSKH0nDWIruhNta0+G6tGjmyLrLrVGGNpVZ4l1I8WaqyjwF5d1jx6gDhzl1DC32gnXUItVwFPidxWKQG5k26jmItzBAPUgfVTtVZJf5hZ1GrcPvN0zTV2eLDbObyxSq5k2k9kW1Tx69ao+19HvODOAU1lBRF6NThcvj1YLbReBbV3C5he2dhPOu2YTAB2NE2hPsMx1mGo3w3B/0f6BvjK8tDnzKAgGVvg6nbL/TAFcQzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6824.namprd11.prod.outlook.com (2603:10b6:806:29e::8)
 by SA3PR11MB192006.namprd11.prod.outlook.com (2603:10b6:806:52d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 13:45:49 +0000
Received: from SA1PR11MB6824.namprd11.prod.outlook.com
 ([fe80::e9b0:be93:d665:7096]) by SA1PR11MB6824.namprd11.prod.outlook.com
 ([fe80::e9b0:be93:d665:7096%5]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 13:45:49 +0000
From: "Deng, Pan" <pan.deng@intel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel
	<riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
Thread-Topic: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
Thread-Index: AQHdTRxC1TcWAn4fdEmGY5QsyWT8e7bkJG0AgAAXR4CAAVpaUA==
Date: Tue, 29 Sep 2026 13:45:48 +0000
Message-ID: <SA1PR11MB6824A3768F22AA274860809A968C2@SA1PR11MB6824.namprd11.prod.outlook.com>
References: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
 <arqI5QB5tUr8dd_r@pedro-suse.tail5790ac.ts.net> <arqczL8K39qBoqgV@gremlin>
In-Reply-To: <arqczL8K39qBoqgV@gremlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6824:EE_|SA3PR11MB192006:EE_
x-ms-office365-filtering-correlation-id: 47597110-2fc8-48eb-3558-08df1e2ff874
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|11063799006|56012099006|6133799003|4143699003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: 2Qttxf42h/lLRVbrMUvCFsvojrOV2QalJabBOe6P993+S3/R5UPdfJmdEBx5KkWUvL5oUzt0TLHdw0qk4aJ2/VWjBGMTRFIDljEuIoYa5GivhoaV+oeHBMHu+Qy9xK2S0t2Obt4WzsTtR2b807DEtwLjSbIuvS44MSpjF2iBTRovRSJYFXnvPT/f4Kl7YJemDN8D+CHDBt3Dvby1hLAsD3lwQ2tTn7lso4RAcbX6uoPV2U4yVHu094fnafGle4fv/feTbfi5FqUwPkIIo5FEDEz5jzwiJj6xIVIgYIbWYcKrn+ZEOSYbAL6kIFyuD6OuvpFgeTjPx2i5boTIFOcqffYXXvfmrqLWP5S+AsMrhde+af7LyhGr+CNTElxV/95TRGHD60/He8bojUcCQfNdoVjb9SApRPVe2coJx79X2tXDZza3LSUwFgWB3nvSu4HIrCMA9n1fm3GkQgBFRXaCt74Fixsbn8Hk1V4C71AZLlVrNNvyPjdezYFzco5J3djtQcXRC9s9l/udF33UCK14reLwTKvONjTsz1a20duArt+8Yzm9szyuzjKr87dbUIkt4Q/J1nkS2zgJPqNXcUYolCQmyuKixXeAy44lgbwwcArRXfJvLdv4TM7b/g5rDvWFpPuV1X9EMnrTXwAgGU1lDak1RLYcqVEuw+4D7UjUhGekOkOHkbczsFuYJjQP9d1hFoU9lxiJZvRAqNcX7xDnmHI0FCEQcxAd3pe3IieVU6I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(6133799003)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4rwTObSW7RtVMpdLKUEZVxfrjpjmszu5IXh/sYvQVMzXu9BwUr1HppP5KZzG?=
 =?us-ascii?Q?ABEydKXDP6bUPhqPcYIuIXcUEHPuHHjIGfju1u4V1292+Mx306TRye6gPJtC?=
 =?us-ascii?Q?MYkDYC+A65ZP9tqBOaJlh99/cRXkrhVAdYcMI1Ohi+Y5/ZzPr6RV3k7V8MV1?=
 =?us-ascii?Q?gfw1LCH92aOkwAqLDKmNcr66Y0xD6w6JusihImeSEwec/ZjiJzixLV0pGXxv?=
 =?us-ascii?Q?HJ1V8yvddKIQsLWpAXUwhO9HfjR0fzGW0HIwfkKsiJfwdzcucUPV8zB/L8DL?=
 =?us-ascii?Q?egmsbf1lPZG6RuVwbAXlm1ONLBAT9lhmHHKPVWehICz4L0ONUJOYS8lMKRsD?=
 =?us-ascii?Q?zXvameIE0Tt/4Li7xwaN8dH0y3/Kaf2p+V+B2Ud0Zpfx38mBel/AXFZCxFjL?=
 =?us-ascii?Q?OeVxXp0V+lES86Ru1n9LifMKb43h3Ja8t9Ds/6Bs8Jq/gfTyTrTnVtp01sji?=
 =?us-ascii?Q?gexpkew7mWBRPoEE27JWwfNm/tYVD+iwQlSIk8xYgnJYhRN/AvzwJWN2KfWJ?=
 =?us-ascii?Q?j2/ZrMWstTXBrWQ0tuPkBGbi8mDa/mQkm3h+NH6qYuMki3COceFm8PSrUpMJ?=
 =?us-ascii?Q?gNLGgDzT7WF/4OMrgJvyvk7C84TCDg+2/pqrpkSO61c4791na9PPuWkQLGG7?=
 =?us-ascii?Q?4nVqZlHfoyrKk5dLFBImorHN8hEDjuLoDGIrcCafrC2x2ZDoxO0DuPE7zdCR?=
 =?us-ascii?Q?fw8I7WPdMf4VTarNtHO2WHR6nisHFW8tdM5Ij+DfYDdcn+kJX992koHOwiQD?=
 =?us-ascii?Q?XhvDYPhlO6k4kktnayEbzOyu/Ddfsz1IIrBUljqYYj/lh0awA/1NJXsF/RtM?=
 =?us-ascii?Q?f8a4UpIN8w9P/xcd/1PS3xqqnU/MpylZ0edzzEmq4Rw0gWGG+Wfz9hZqPZNp?=
 =?us-ascii?Q?YsqqC8aXurQHSlFWOhJOggLPrnAnvqyzhLF+ni2m3mUnqUlrrmrCseyxb/NZ?=
 =?us-ascii?Q?/Yeg3rYnYbBu2pFoYYTMrDH0ohKj/3uEVv9C1YPPQolwb5aXoTKvFdXFtQ7X?=
 =?us-ascii?Q?Ac4Qfz0Twjb+UeAHrW8xJs1vXmYms5NeNukbnET/6aiBf6gml6aJdztDM2PJ?=
 =?us-ascii?Q?c3I1HHZ3yl9W+zEleoq+NfmeRhXbMr5HMqnRyHqUa1NfagAT1JT7zsSAdU5R?=
 =?us-ascii?Q?kHoUT1U5+FEMNEnAfmWaMUt8Gyu/9o66aPqu112a1b3E9akAMWOjwiwY3Oot?=
 =?us-ascii?Q?k8J7NgXCaLO3y7Jd56fdZmg+6tDh1R+MZ/uYhmEd9re9xVw1HW7eP8yrHvAN?=
 =?us-ascii?Q?Fffz6NiC5qvSQG/0V/6aZUzJGEASl5xkfXf0Fcushhze6SKUUGHVlz9CKybI?=
 =?us-ascii?Q?HsXh5C3y3ELHsokZjtUNhe0V+qBgokdn6QU8YunVKGIBGEyJW6RmZatp+tUJ?=
 =?us-ascii?Q?JAJEviWe9ya2qJFhags/hLWxWHEu4TJll7+kORGvcCDEFIeTp8+Mbg1BllQe?=
 =?us-ascii?Q?NQ70QIDNGppraUBSGaro6ZQu7OQ6iPpQtQe5vXOr4YdlQoSSFypjXBF1nDtW?=
 =?us-ascii?Q?hwaR2oLIHuQzvfDbfU3kJw3ufqvbDVhaQ7LO368WAc/47bfJe7EC1oU1axdy?=
 =?us-ascii?Q?kiJwOFV3b4l4BfewCM0Xx0bhEtMZ3xwXGKpamsL1hn43ZJCKUYkTbmKiTqyD?=
 =?us-ascii?Q?JMQJjF3HXRLfhCu7QUtDbeprAkpWIb5IbvMfUmNZWZa/IELsFd0FjpiEI1bB?=
 =?us-ascii?Q?7fpqk9dhz3KPiLdNfV7Jhvuye0xRMts8grV/HQV2eiaoxeik?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZPwQwra9Ltk4AsGaG4zfsNdAFIo1v0NguZjxQNjdYxOH3kccHrpHYjP+rxYpqR2dN+IGgH5oogbCrbp5pIW9FjGc8VtOcWw6mIXNxuNZ7Im3TpwW6CuvPx1xGD9pspTQvq436E+97cXHensISf7iNKkN34JtA/nJMZOT7Ki5/KXWbx5pZuNnYeAPVDc7sHOEWnnJT5pRwfoBEyI+WZWUFGlFLHSzuRRh1Vj+QnAdC6CTKjo0HZWlaOs8WAihCSZCiSfN7AQ+Mm3BBDzjjbfx3QR6eJPi21P/PjjvxnmVBr+bOvj2A21Jf4RoD4uCJbu7wZhTwzDeKbKknSOMvUBo+w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47597110-2fc8-48eb-3558-08df1e2ff874
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 13:45:49.0520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2nnlMos2LPgUC5l6mGl3wA15Umr1aEEPdQqW8zggvfsAIIZfwbY2h/aHtwHG43CTwQg+bv9KXUNXfRcgnh9ASA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB192006
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Stat-Signature: abr6mqxbcepug9ronske63jpwkop4sfw
X-Rspam-User: 
X-Rspamd-Queue-Id: 687FF80004
X-HE-Tag: 1790689597-429807
X-HE-Meta: U2FsdGVkX1+5FlemJZIoGUMFiKwZZaGWGdVEJlDJiLL8GLgwgHRJGiFAN83yiS7wOOWLxuZKet1nGLwiMPh+sy7w6SOiEn95hGh0h6HgVPjJUC9gk4UDGaec7Gaulud7siqAgqhcWck7f2dywxHGi0kvzgiShzimZDh5d23VDBrea+eVi15hzE+Q2QT4x+vXf42Qwv8Xbq6Cj7kYrnmrMlvMuIuz+/N23ZTY2H0qqs770Mr2jq+7w1in4PGs4qTnuKHpTrIl0qzLSoLpr4QYyXqVZ5Iu7Uj+V0f4N0DyegqOKsdsOME+z19lQLUF5FPjQUgvUtkFBcTGmtSw5DQ3Iv+OJZQWI00LF/PxiaepiRRObW4PBSRU55b8s5YASRYOp+Lh/bvMaUTQ86ts/UaijJJ2fSk3884J96rWNVd5xdkQ2cs1hej2nktjUHe+cuW+fVd44K9VMHAnU5EqIyQx04YRXcIIrzne8hLP9fjg/LMmtSOXS3GWRP6Fb5HJBCOD3qFvMpbOn2f5KM361ZvV14zKQR3WcFwleAGsgLr0VcjojBEBBmqxYB+GDgQOK27YwAoVluzgwbNme9AujjOfh0ct8ChkkromWghxTx8gggHtG1Y/Mh0qcGax7A4AolFCXqHkL2m28LQ32Qupf3hIFKsGVSixr56W2XPU2sIbe3G3AzictoXB6MwgIHIphgkY7EkELRUzCqd2nnoa71WghmYuYOXTsnFD0q/2jITgY5aypIcoKlLUDaEYGmfCZmiL5C27qLUDnki51keLwolxPUQJ2I3XKtPHSYLAREK5giGb1Oi6qixW3EyvM8zG/eetWqK7OAXTfgpK3p2/Sxk3PeS06GkHiDKXYTwgJkloC9vXAaP6Kf79gmwPsyAKAfrs7zsPHG1frkD+eqJHi3OV8+M2QLW440lL1of8fynTovm1jMVAIVONtZHIBzrmC+OrisvrUUMJlwumuRNkQ06
 byTDHTwW
 qvkytkyonTovvs0UviaxuVoCis44h2rHDHqrWCwAC+uOlltvTluz6+qAtsaPQw+LpsyH99Yq2GF/Bs4i884rpCAOaYCodRvCQnZQ1kEwdm3Dk9jfX1b6tZQO9MPIWi8icF3lje1cZ8uCUcnIpg+YjNnam96h6PohGkwHF0eI6xpb7lxRL44SB4ek6jpgUowMqSbg+LOr4fWsOiGPcty/NDFSFK8v3ERdiDuYhRXNHacH+tKq9xW+jSMtFRGHS0g/H+GPJqnbZhXST6RLceawXalDH0Db/N3t5JSd1f4r5M0WT+kFp3QODLmWImI26zlWmFI6cbrxHoUZF0oyVpcv65QUfO8YZRbk1xQ2rBKR8hYvxooqM25JKwfrtwRvehD2r+QaItJQL5wyU9d8ghF5nXUmj3HZDQvPGfKMQHq0wI8lQecLg6Pn7KZ7p1Y2IUDJdhgQuQo8dH1jy7gAfjckRBL/cqXxRCfBRP7hETavSCOea/X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > The anonymous rmap is keyed on anon_vma_chains not VMAs, so in those
> > > instances anon_rmap_tree_update_vma_inplace() iterates over
> > > vma->anon_vma_chain, invoking anon_rmap_tree_update_inplace() on
> each one.
> > >
> > > For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc-
> >cached_vma_last
> > > is also updated in anon_rmap_tree_update_inplace().
> > >
> > > When performing a VMA shrink or a split where the VMA is the lower on=
e,
> the
> > > page offset cannot change, so set the flags unconditionally in these =
cases.
> > >
> > > When merging VMAs the page offset is unchanged only in some cases, so
> > > update init_multi_vma_prep() to set the flags only if the page offset=
s
> > > remain the same.
> > >
> > > These changes ultimately result in less rmap lock contention.
> >
> > I think this asks for numbers?
>=20
> Well I don't have any :)
>=20
> It logically reduces the contention, and that can only be a good thing.
>=20
> Pan had some numbers, I've asked him to re-run against this one.
>=20

Yes, UnixBench/execl case, measured on my 2-socket, 192 core / 384
Thread x86-64 system, on v7.3-rc4 with and without this patch, built
from an identical kernel .config.

Configuration, re-applied after each boot:
  - cpufreq governor "performance"
  - uncore frequency pinned to max

Run rule: 10 runs per kernel, 30s cool-down in between, cmd:
  $ ./Run execl -c 384

Result: Execl Throughput, index score:

                              avg    %stdev         min        max
  v7.3-rc4        3511.5     0.44%    3494.5    3543.4
  + patch         4069.0     0.48%    4047.4    4109.5

The speedup is +15.9%.

In addition, I also profiled lock contention data ~10s in the
middle of one iteration, cmd:
  $ sudo perf lock contention -ab -l -S vma_prepare -E 8

The dominant lock is i_mmap_rwsem

Result: avg wait on that lock in ms, 5 runs per kernel:

                        avg    %stdev        min       max
  v7.3-rc4    9.470     2.91%     9.070     9.820
  + patch     8.420     3.34%     8.100     8.770

avg wait is ~11.1% reduction.

Note: under the i_mmap_rwsem write lock, this case only exercises the
split path, for both the file and the anon rmap, while  merge and shrink
are not reached when the lock is held.

Best Regards
Pan



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FBCC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640E86B00A3; Tue, 21 Jul 2026 12:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB5C6B00A6; Tue, 21 Jul 2026 12:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B746B00AB; Tue, 21 Jul 2026 12:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6C16B00A3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:55:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FD5DC0233
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:55:55 +0000 (UTC)
X-FDA: 85013385870.23.1019A9F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5213E18000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:55:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TXAPa/kZ";
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784652952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mrQ/MICeZnpZ7A5pgB4oaFRP/282t/NBSgkNHCC9eU=;
	b=W8t/P8pPitLPv+VQ8S82SMtWyAxUhsGReXvQ3nrwseda8fWSJmF76OZYRdyfFlxmQZaGFf
	Gjhx7dlf+JvkJ4ncY9ut24efbG/YQC8IS0ogg/4VbCV2w2rPXIq2So78QC5EArjas459Ec
	yrYOF1HKyrIdOipI+dybv1BvsJdUtU4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784652952;
	b=R3YpFX8HkXYO2i+wcjHirTbtmO4fFiZXA/qtLqCj4HvHJt8TYdMy36UE4lE+EVB83pUx4h
	tj0NuyAi8TLn20kt43uPzITwRxNQpLsyaXn0CDYTjdgsj0KOOCxPo6780fySmPuk2ZF/U6
	e6xc8s57gNQm5nuq76ERtx1SD13oYvU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TXAPa/kZ";
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784652952; x=1816188952;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+rvC2naf5M79oDxaHvy7VB0+U2f7vgQRHR2dQJJgg2I=;
  b=TXAPa/kZNe1iEF07tChqe2X/rlSN/V4ZvozUbzMUNGFHTXFxDTCqg1x7
   Y1TqEsgh+N7u4Npvrx8mCi/In0V8+mQRiTBvSlaff4uO3SEvDgUwODzSn
   4IUpEBAFWOj9Ea2kfrNh4oHP4QM4KWnCHQdQ84YXVVJ4brTQDzzGkc/BR
   cvDRtveTE7Jayjzc9LOuHVT73TaRD/P6Dbeksf92Ikl6oZfKLkY7RO8x6
   qRkr/69PDdvheybvrTadEvdkj6MT4gzEKFLIs658B2WXA//VsJHECikEt
   a+fmFuNg5bQvC+nl1sxxcTa02Fxvk/KZhqzCEfD3Gohl2FQMUMH7b+VNM
   A==;
X-CSE-ConnectionGUID: L5XxI2exQniM/x4L5dbbvA==
X-CSE-MsgGUID: oGpl1NzaSMGD+FfePNxnaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="88940608"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="88940608"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 09:55:50 -0700
X-CSE-ConnectionGUID: oWO4B3kNTTK/inrKqVLDhQ==
X-CSE-MsgGUID: 4EPphMXJRmmwdqYpKYxMKA==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 09:55:50 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 09:55:49 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 09:55:49 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 09:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3uZQenkfsYUweEzN3ubPYaWdyNitS5maIjDIVyJ70Oq4Ibv4G7FbiJOEw3jUqmTai676QNtLctZnYesk4lVJCWln8mOpcW8xv8ET3SMDih3trlYWdp4lX1OXS/+qTNMHJ9JjkspxO+uB00+WHpHvooDdfHlRomXTBLs3DIkvYaXrtz47ZIqH+f7Tk+ALShJkzW/CXIlft5kugfgjI0DJVrxHHWkyU6dB+qKrK9kbpW8Izq3LE8VN3gMtwqoYBUvMqOGt/g+WkLIKI/uS9th27QvYE5CSHyI3B+mpWZFmVPJbotcJ+ucgXZoC8q7kIf+Xbu+7BLZBiCrtvxkA+I3jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mrQ/MICeZnpZ7A5pgB4oaFRP/282t/NBSgkNHCC9eU=;
 b=NmRhfvFCfPRyDC/pRyQISpsFdTl9XfZf5zHoU3etu3+gggrBuIBrcp95zNzl3BIcbKACR3iq/s58DWmPfrVXBM+HMxro+0avcqEEnwgs2sLxr0wz3DOnzupyjk1SYlz9Aq0W+1EqR++F/8E6C8AQlLXJFPyJGedWTvjY9icW/D9aT/bk0xOW3OhNcBRCojJYez4+I3LwvAGbDh5y3028RYTfTd6Qy1g6lt74M7Oa+1ismCL1uRCbI11Np5f01Js/c0LIpyCZGQP5anb6GOgeIEEt/ugnzWDL/1VlCc+Typ31Liz7kgH9Kdgpecs0Z71SAioD9N+iL9/Bjrd+oOvi8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CY8PR11MB7797.namprd11.prod.outlook.com (2603:10b6:930:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 16:55:44 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 16:55:42 +0000
Date: Tue, 21 Jul 2026 09:55:39 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Christoph Hellwig <hch@lst.de>, Mark Brown <broonie@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>, Christian Koenig
	<christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
	<dri-devel@lists.freedesktop.org>
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <al+kiyFVgrulSneA@gsse-cloud1.jf.intel.com>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
 <al40qCMTxhEP3Kx8@casper.infradead.org>
 <al6cVnNv2TuhuiV3@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <al6cVnNv2TuhuiV3@gsse-cloud1.jf.intel.com>
X-ClientProxiedBy: MW4PR04CA0326.namprd04.prod.outlook.com
 (2603:10b6:303:82::31) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CY8PR11MB7797:EE_
X-MS-Office365-Filtering-Correlation-Id: a735d633-65ff-4105-3558-08dee748e680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: m2SvUCk+/qEYsstHHpmUg5arsHwFT3pl7pW4d8JBOtBRf/e/rm8e/r/R7GPFdI5YWpdU2lMKSV/z81CcNYlInbnxX0ObAnNWbJaiEr11Lg7Uzu+dNr7lKdFpg64nLfXeu9xJJGs0Ad+48bM1UJkRTfEkaKYWAkweGU4PA7mOvVbq8AK+HceTM9J40EK5p5xoZvFV6KMAv8+XyOqbBT2hFWxZ+pJboLK8935kTt9B+LdH4XExCA2cd5QwBLhC5gZDbtMe3HyyqfbrQSATI85taqiLmcZpmQ67Lllv5+yNTJcKdXGQO3+v9IT4TkSNh1eQBgvhrzCloPCpd/xwRLsaYG3jgwyR9PSkksyJ88evWaOeI9aozdelPJi89fy+rq6oQAHN/SxmkokxD/jDBhSge2/BVvmtCC7pfxMFpCKt+ymjcpSC5OvIBbKtFAKqcIVAWByVWFPGDT7WKx0df9Kk9IxNwJVJvDZAVul0IzQJqbHlX7J5fHKTkvnbLIlh94ZLDqNzUKyFr/05zFImA6z7KZCbZftuKF8kMbteGvWIkkp0hXXKgYsnQeqS1HuPfMMbu4bHlBC1c8RvvYHtEe2Q0je1LpKZW75oTUPRls8ofOJur3dNSOOXShRFscaXlgXqFauOReqiYjIYrhEMKdCLvWxVjIy1zBD53vhoIm8mjuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kxWsYiXTj7xo4tp2fuyO1VEmCUFsan8rUeBDHt2K/5AgEwfcgvZYu/Dha5qI?=
 =?us-ascii?Q?OqEmFQVjfLMDXK0ZeBrtqHyEWwS/kN2VOY5GqgyPX0EmUX1JhPbLCfhX06Yu?=
 =?us-ascii?Q?PXROggQ88LiIOIwCvbnJFjUFqhxXJShtPL1CH/AyJYSQufRD+bBCTnkXKDps?=
 =?us-ascii?Q?IdZLBecnFlvscq94ZZ82NdXIP2OR+ZwxVpMrdlqHHLKzeIGPCmwrdUCgslfJ?=
 =?us-ascii?Q?9aaHS4ZzDKkXLWw5f2/7eFVYmDxpChbRzsemnU/ciFEKNyrKpCjgc/kBlKPF?=
 =?us-ascii?Q?pVKFu/aRuO4xMtpA453Xsa4ywY7KDJgZa98Cu18Jk8Po4W65t/aFhlpLUv/e?=
 =?us-ascii?Q?z66ikBiOIvwFEzM/3iBrqwVnR2BzjZTYIge2YYz9GsAZdcyExW+YHEdAg0VE?=
 =?us-ascii?Q?kaVEBJp2oYuJfZ0RE2lAvDVV+uE9h6YAvgX25t2lC/MvZ5PH4DjkDhxufH2q?=
 =?us-ascii?Q?mvVeZEu3UWItvW2cvg1wI7X+WzlWRc3EN5D98L+daIuUz5++MyhAuX079ENO?=
 =?us-ascii?Q?ISjgKq8cS6oac+FLHKIB7vEtxOxS9MUFNyvPRy+u18cJOfRIt6SyPnhYQOsY?=
 =?us-ascii?Q?04mHCnhCi43Vx/OeuJaqo/JXDqIgN3jqrgJrypQOARIXcNOHw2iRzDlUa5LW?=
 =?us-ascii?Q?+ySZcgtLHxAfAgw5QAQB9i0dbBOMVldRgZP/2TlOw7fHrePUHVmsJXdxC65Q?=
 =?us-ascii?Q?NqgBzoLxzZOzu+Am4HiZS5978CKORSEPHNkySv9VQMZMebYQwWBrJgqQ3NOA?=
 =?us-ascii?Q?zVCZ0iXj/SRDWAsGFhM44kxuSBfv0RzAYFjZzvECumnE9O0hoWXh9SyX63Bg?=
 =?us-ascii?Q?PCZg+Xj3qfyl11gKnOdZT2EpeM44xTN4HJGBlFZ4h+rPjtK7DcMCklOBEQlX?=
 =?us-ascii?Q?RQfzoU3v0ldibK7ceRSYjTLas1Z71/v9a/6jShfz8+Y4WP9tXjNDVlGS4M7h?=
 =?us-ascii?Q?D+HwcecZZ2LYYZ9BUmyycgeE/9YJuWOLku4zv3L3IAGcfFwwxF8Fai+7XFoG?=
 =?us-ascii?Q?z+JEFRti5WXsA72SVdPgJhzMFL69P18cqr0HUN3/MODZSzZA/AkYWSxwyocu?=
 =?us-ascii?Q?/3ktLShYCM1fiGpwTaVV6mzZrwDTzHPi5D+UNWuulFkv5c1eL3fhZeTNocil?=
 =?us-ascii?Q?px8jbgE/Rj5Tcgk3Ot9PrTOBiSP8BOm2tW6FFijd+hnnEz4pOj2UW7azPcva?=
 =?us-ascii?Q?kE008VooE3w5s63+TobyBmnr5vHB52WHq/PjyNvX7eG0b/hwZ3Qy9lH2LCij?=
 =?us-ascii?Q?YjhFmpWQMA0r/Wjqy8xnMMQ6hTRsyjGrBoGd5Qd5/cUMOZx+o1oGpWX1EGFd?=
 =?us-ascii?Q?5Q6GiqkzAwexO5HkLoRm0dvdipWLMmQjUJPbBEjJd23aEmWzrwykLNaT2TAh?=
 =?us-ascii?Q?t8q6WOvC5lt62Lo+xI2tZjtFrRZl1kp5f8dn0vfGK8xR/Z1R2nsWFiYfYf6P?=
 =?us-ascii?Q?CflQFUbxgEtA6jAo9mvNciaeUdcQZ7Zo/exP7U4hYbRhRHMv7d2N7eG4apLg?=
 =?us-ascii?Q?XllVXZIndHvTVLVObeFk8bD9SOFMuQSLd3eYLi9w6XbuTOqrs27OMYkDuoJQ?=
 =?us-ascii?Q?X/FSQ0+0blb/0VzFt7lurPqSsSKHfCdOY11LHxmsWZyMgHLa5HdxvqcHGXFc?=
 =?us-ascii?Q?987Eus5xLjT1xGZ7Hig05hp6JA6a/3xOmL4SPdrz7nkbKOPepPbFmiGwgmr5?=
 =?us-ascii?Q?uZF5Q3fcm6z4m3IAaxFheJcL58P5XIMVRQ8FWfUDnNhe34CMHcjE+RGzRUpf?=
 =?us-ascii?Q?yNpzxjX/VgnTxt0NjidMASg3C6TJPzE=3D?=
X-Exchange-RoutingPolicyChecked: Imrq3jreoSNfswwPEAgNgHtrHBCuukrrx05qbfe1OPsamA1+VETRI7a39T43mvL4ARGvvkQD4WFRaUVrMMx7QnSWIcBOJgdtfNwqQfx9ZxZfHkUeVy9mcmSTEJxoP6zQ2Qs+aSzIAP2vZKQqkBWCl6c1KoSaRNG0GBWi8Y1D49b2dus5U3Oa3IAkGFSL6XhWU7P9mhxRDOhfGH+q5oHs+8kmwjSVYNQRSEKDajp4ILZgau+PfXQctvCULWzjnhlftsyYqjUMyKA9kCpCWuoM7OD/NjOS1N1KdYlK1HX2nTsxw5JPrp4wKjSO6tTFFLBUnOFLQ6fCCHy6tp3j7OMzlQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a735d633-65ff-4105-3558-08dee748e680
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 16:55:42.7114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd3scA089vB3rWKQLwseKVqrvfZ9zgLBie/IPIDMJDj1ud/SztIxlR2zhM85T674kWCDsGCNghwGwbeSTvH8NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7797
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 5213E18000D
X-Stat-Signature: q3q34n77ch1t1dojd6hp3hwgjcr4b4ch
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784652951-13048
X-HE-Meta: U2FsdGVkX1+d0C8OmPklICs62pV1543tbENq7+nGOGaH1GfLtHrvg/cHWksixAqeVVOrHTsTBb61pjSUr4X7RGDCXSWKjw48KJPp/8ElfXwETAhjSJuIMGRxFyA0j2QdksmZ14VSLYUMohoo+iEK4EIFxa35ny4lAoCjjBm7jfuofJdT0Jk+C4V3HhcdyRn8Pk8UDvoStne16SJCy/odu0yZbsJGO2tuW68LI9wroyKVTEJ98KC1k2wZ5ifR7ek6KVB3nNkptDk/NFz5PUSbbRq7b8IayQl5hjFDbIJ860nZXujMlEi3NYLwAgIHY0XMPSMuYMFODWhmLhCvnMoPqxtfp+jhyg6aAPkjUQJ+TZHi0kaLD2mwI7dL6EOyuD7aqyW4dBwLqZwB4qL2nfHdiOM5N+Ylk5qVin2leJhWwRtueyKGcHohyr+YhJaACT9dsJfEMBD1iq8ck4UL9PSSpj4NNG7m5Unx0tkko+BGgHY4S62aW+rhdfsaSBrfdk98HFajJKFUZnzOfNTtExxw2VmMZswk70MwdFB762uA+DiQs1viFRfZpdlST0Aaj7mZB36hS9P1N3ZwGeP2JUdmkgbyKJjOlZjOwWsUW5EmF2njqUAm9xIOhQkzNgL4R7SeARLUZ7r1n2P+l71E362XBHtv64vtbrFfoTSnkxwmzBBIZADBMJFwP9xA5vJrMMdQBVZmuIKCNQCzvSRQImzBR2NPpTbWzx7Cps91O2l003GkwypltDGAvUsFS9ENLIuLSoK9jNmlwz8jw9UhoXI1Wjm3EqHlQb9cQvu7NtdKeT1m0eCfsCFoN773C3T8wzUmBfMS7Gh8Lq/JCmdFggD9gsFfA0swUxdBGVPdqg7p2bpN2ane20xRr5Zy681GcdcpNG5xaMVZ4GRpZV6W9io2YMA/q0fuxPA03+4iW9grbJHLdIGByAEXRIR8lGrN4z7An/bdhNMSicFQ6+0b0E6
 XKmO12E4
 XbYvs9pMkpZ6lcP/uF6Ez10q7wdaoNFquYnN2M5HNk837aU2DuL66m22zCJieCLL0b4LIn1v9AzNKLZWA11H79Xkjr+Hjg1zajQ/lKwZrJT1xsCjYK59SN5Pvbq6Q0qfJpfr83GKno+cgLyxb80FA73Gsxh+aq1YZgrIb1AFJpodtXTY+jq0c0SZV45R/YoGNXqqF8vA9NmyHOuRMvDBhvACiiNgrFf73spC6QNg2ZDdt1LP9oDqtyGfUmYqIrKGRWEXWV4DqGrsoEAfaCQ5CcWVFG6sdBTfmOMfhA0W8X552UGCaotBpysmJvtEOPDbvHKVOEMdyRHp4rpGwz6hoJ81yBgMAg5WEX0yckWZ9DX/ox3uxfvXwrp7ncKTnrU0l2fYoU+RKeJSi15yF1ZJrC1/s1/CZRfLxTIpzbuspnvFepnXcqds3YyDUicG4ojTPW5cRrimrxo0yAMi5BtPG+/V3CG4c3mtrpLYqtz3TkvLz88Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:08:22PM -0700, Matthew Brost wrote:
> On Mon, Jul 20, 2026 at 03:46:00PM +0100, Matthew Wilcox wrote:
> > On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
> > > >   /**
> > > >  - * ttm_backup_backup_page() - Backup a page
> > > >  + * ttm_backup_backup_folio() - Backup a folio
> > > >    * @backup: The struct backup pointer to use.
> > > >  - * @page: The page to back up.
> > > >  - * @writeback: Whether to perform immediate writeback of the page.
> > > >  + * @folio: The folio to back up.
> > > >  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
> > > >  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> > > >  + *         return 1; the caller must pass the true order explicitly.
> > 
> > Wait, what?  This is just broken.  TTM should change to allocate using
> > GFP_COMP.  Why can't graphics people ask questions before writing stupid
> > patches?
> > 
> 
> To be honest, I have no idea why TTM doesn't set GFP_COMP. This
> predates my work in graphics by nearly a decade.
> 
> I found the following comment in TTM, which was added in this patch:
> `git format-patch -1 bf9eee249ac20`
> 
> As far as I can tell, setting GFP_COMP would make things a lot easier in
> a number of places.
> 
> Christian, who maintains TTM, is out for a couple of weeks, but this is
> something we should probably take a closer look at.
> 

I have looked into this a bit, changing TTM over to allocations with
GFP_COMP seems pretty straight forward. I have local patches that are
working with my driver (Xe), will post something shortly.

Matt

> Sorry for sending a stupid patch.
> 
> Matt


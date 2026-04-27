Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16BEFFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AD56B0005; Mon, 27 Apr 2026 04:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C146B0088; Mon, 27 Apr 2026 04:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303426B008A; Mon, 27 Apr 2026 04:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B93E6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:36:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C93861A0802
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:36:01 +0000 (UTC)
X-FDA: 84703678122.16.2627C64
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id A235A40008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JfHdTPSB;
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777278958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NFxm9c9wLIVpiw/QRiQWn3s9AEVJ/k1LkcJlRfzgYgs=;
	b=GSkQ9OyDdVTYTKrErk3bCtchvc4SN2xbS40rQ2URCUaAOSbG9eHXce4SEauEy2uRdT4A3t
	NFdqCt3Nas169BS+NjyfQaICdVESnlPcvS0bLzBGfd8cCWtRSK08eIFWtMp1m4Mb/2EI6l
	g3IJ62uEEfJ+JdjgN6oAn1OFjFjfyU4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JfHdTPSB;
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777278958; a=rsa-sha256;
	cv=fail;
	b=clns5llsE4RJhtGmOOzKQ8pYg6AScInQUs0UO8GFn9MaV28qhEyXng0GhbNkXJss5pQIRc
	6Ymk9XMPlpHtwetiQQ7IuSvswEo0ByMHF4Vzm6H7SG3PTGekZ2rNt9V0uWGoTOq5hhkHr3
	w1M/2zvH/9DEB8gGT29FhqAzhsbrUr4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777278958; x=1808814958;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=xSf4gM2tYyM+PkVbcKazJLUEuPxP58GcMTKHJdjhWdw=;
  b=JfHdTPSBy0Hd5w1CYldAH6t5hbzPhM+Nnd4Hj276PAsxqu64BB/uEWfz
   lVvsfZWmb3pJKRbvoVs3DG1BHN4SHMC9URkd7c/NdCta9AXRYsmh8CGeY
   OmGoZeImkJbUoDZ+Lh680jNX6VzC74DSzooOrh+MtlVZO4drEO/7NY5Db
   VJKNBPW8YmRxqL0lHUMqPe3ogxP4d22isBJ7N8Rz2Kp+h1iAYNfR2gX/n
   Y+PFLA/RNH66fSr1vxK5YdfBI6Bj7eeT4v5Z4gJzUoJp5AnPoad0cBj0O
   3eJX4rO/vX396D/07siVaQzbKm9exA9ZRKwdV3cEEc8AMNHpR6sq1MQc7
   w==;
X-CSE-ConnectionGUID: jUbZ7RFLS/GzGsxIbA5+7A==
X-CSE-MsgGUID: PToCmRsOSUiq7sG9LF6eYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="82024487"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="82024487"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:35:56 -0700
X-CSE-ConnectionGUID: 4PwePjNfTguN4TvnWSzMkQ==
X-CSE-MsgGUID: ooRyr78lRSSefa/Jr1/BaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="227049879"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 01:35:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 01:35:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 01:35:55 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 01:35:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZ0DgfnAyZR8Nj9/LXRcUnS63iIJzUazsY6iBjcBFtOc77srsFrAU6lvXvYkcL0XDyOmZW8YooHIsvN1xlKBrzrBHsLaVvFFm4hYaXEGlTgumUyLQaMceLwVUbrqbUwYkwDngr3ldXP2gljNrE4tm3tfSlS4vLJD01GHD/H14LnJwzYa2CaU8Tvbmi7yAhFeZ5c4L/J0vCQlovP58HkOufn7K2lrRFE7QeSZG7dXF3TtJzp5wd3/U1JOQpJYb1XJ5IzDXsVAL2r0XiFVWFWTAWBz1fkgo8GgS2RtcSVfhQ1Z2v6Fd1h3GjZG/43qq10kOhoy5tvA9Cu3BZEXok9viw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0r0/R/Q4QQ5SjzbTb2XMtLhjOFZ5ekKFkL8s9eARPB4=;
 b=L/ANqefSrhpHZ+a2BfD/LfKhTf1K9Y+17BRxTqYuUJM5YiaKFQMFtNtYgpWhK23/navBGRlzWn4D9+gxbopVeGQXyNBntXIe1CNzlFpZoEDOxMVUfdQ1UOQMx028Fht4how/O9zC5L6oajiHjeKVo+/S+SAG8zI/It/qXrU/j6qXH/7Bek8eguaJzmQIfbW497ysBBPDkr9lZkBrFGnTLsMF21JQzFolwFJ2LipS5gPmTKVZ+4c41Kn8BqOFGFWeh4VpvNRDKqVE1b362rFWHg2zVjARJPizApmohyVGEuGI4iy1WTdFcaZfaH/3/fDlznloDhnkBbuzLdjiKw1GHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
 by DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 08:35:52 +0000
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7]) by SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 08:35:52 +0000
Date: Mon, 27 Apr 2026 16:35:45 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [slab]  5ba6bc27b1: stress-ng.session.ops_per_sec
 3.4% regression
Message-ID: <202604271639.21c44b96-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To SJ0PR11MB5815.namprd11.prod.outlook.com
 (2603:10b6:a03:426::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5815:EE_|DM4PR11MB5325:EE_
X-MS-Office365-Filtering-Correlation-Id: 58235d54-a26c-48ce-9fc1-08dea437fdbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: jUt79To2XCydp+1kIEbWwq9jlHgQB5XD19dBSrC9uNLmunyh1jdP2uSQqpe9j1GqBl3YkDDCxoEb37s4Z+BiCGzRe0zZHiXyJl/KgYb4Iv6BLWqW49qwWzLPkOhtkKd/Ypma10+25+XG2NCspYuyA6FWaPbGP/WCGmLeRsbEVfPLh3JwGfpEFp1a3hWGQl8ziQVyU4Lk0TJzgsJA9eOaBiWjR06VYYPHhLx5wiyI0qIEvJZ+L+QZn5a+QU4SVvUECOrG1tl1aCI7B6CqB2ehbHlulhY2hjpTKi3VEYVMLb2gGiPo7Ooz0xtzrHd02LjgfW80zhaOl5RpvfOoxAa65FYKtARYttDlXnpdhD4SbbbQbwKtVlAi5moT60OVROdGmeg4BSl5McAX+MQDLKfDOlBofQKgyjYb0dRrteD+5durUUH2clY4EAulYN1yUeUi/FsoSzrUI4Re4luAqP4/g438zqsN+Rs/JxBohsvBdfja8A7RCQPlZmyf0HwvBXBthgjJ5F8DtigTTd0uI5P3cFRaRvo7XBfDunkM8BVo/fTNGp5np21qWG3+myoQyAiOfhGqVOwDKfMbES+iv39xkG56iHItbNHLw5vU4I1aEM9qJQeLNvwUTZ6g9zCxRVEFeF2D12AGuuoGOyJtH5liu8F+pudJRiP32ve+R87n+wDKeU2ycuwekrWECq+HVVrDHNBIaxQu5Bqg4HbtAkk62w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5815.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?m3pFexYs9UoPtiOwYksCbImGKLp+jdW1WR7aS4w9YVxAOkqB+37g1Ktkwg?=
 =?iso-8859-1?Q?sak/ffygwCscXkb9sX3PM4JEqYkDqyl1bSBbdnVHhu8x0ztbskOlnQRF49?=
 =?iso-8859-1?Q?VEKsKhbPjdxagbpW/DLdBWZ002mk1AqMu8l955NXVZL4GzZoC9mGuBmtQQ?=
 =?iso-8859-1?Q?L/1b2xRXfPaAcJqqFvvb3Er9IWmEDPBgUGUXv6RyBD2QVDuzS3vJvCAVm7?=
 =?iso-8859-1?Q?Adh0gzqvoch9TCBmvOPLGXkLBqJdTTa5SNlheiQS7ljNzfifwETqR/DOVc?=
 =?iso-8859-1?Q?BSFk8qJBFxr/qtum1xwXp/ZRtXvE3/j4zZHuDZD9t5KHUm/7hmdMzN/+EA?=
 =?iso-8859-1?Q?iLIyEc8TAPmb7o5XHnKVb+mwe1e+Rqm/NWLL7pUZ5ucU/f4kAd6aGdYjGR?=
 =?iso-8859-1?Q?c5ekoy7mdIDfh69hUbcXprR6Zy52OGF/7ziuu3lZ3bU+TDXnGFp7Ipntw1?=
 =?iso-8859-1?Q?goSesfH/HAFuu1kfmYs5oE/5rKIPccs2Q6S0a0NXBplMnHuK5foipwzO1U?=
 =?iso-8859-1?Q?eP/eYA25KZmsVCMk2f84NnHpcd5OdynZv76HaQng3P1/R2L1FNDB7elM4s?=
 =?iso-8859-1?Q?LRDfosZxGoGsYahPi5XauM7GahMuP8uH/kyOkPNntXDeDqLJdHlf22i1kH?=
 =?iso-8859-1?Q?vb2fhf8+ae8PyistpSCSytqHobMcDTEBIu7RQ8DYMBVRO+SrskFhlcjjzE?=
 =?iso-8859-1?Q?T8BmqCe09HudAooXw68OR40eu93SLdHSS+V3dh5Mys+DewY13Vp5d7R5Zs?=
 =?iso-8859-1?Q?FaOXj5UKZ9i+Kpr2QcCSV54VfJ3DYmVqLWqWx3/eKugB26DYO4XYvzHXG2?=
 =?iso-8859-1?Q?klnaJIBlS4wo3CLkTqdSWF49yeARYPz0t6zXjyUx+C4yuV0FuJUbskqEBj?=
 =?iso-8859-1?Q?m5HVohk2FZmioIPksSfHn+bQWjwrp0zYl+gKoY3CQIvcpZyNVNVz5w2TcD?=
 =?iso-8859-1?Q?EG5ITt1nZVAWFLzVnahegXTA6dhrCPN8kSB13yx7juQX90GzmJ5w6dR5tV?=
 =?iso-8859-1?Q?hbMyyAE11Z0tEKlnegGUtKMGK0MJOWy9eD34Zr5/XTN0XtMWqbTC+cHfwW?=
 =?iso-8859-1?Q?Iu27nPlEuoB3VEQgQ6pwfPvbXMbYPBZj12kaeu0vYzo0t0lRLK2HBoZ6K4?=
 =?iso-8859-1?Q?TrKXTSJMWu5bS+d0yYOtLKPKNJnrVd9RtN8q7OIr7QIvBQDD4B+uPkdVYD?=
 =?iso-8859-1?Q?HbMlipvJdP18S57Bhr+QzriaAPB3h/HpkIZcj6gxK3gnHBM7BsxeTyLZns?=
 =?iso-8859-1?Q?urPdJfrVUHeT/dt1uGGfjghw7jpyKXv2k0WGgI0xIIe9VwApk5IM8KA2Iy?=
 =?iso-8859-1?Q?CPVSqW6tK5qadIThs3LK6Ck0B5i4A/CR3mLPRN9qAb7TChQHMvLsThn3Yc?=
 =?iso-8859-1?Q?+RdRsXPqWAZxFeRM2yOKjXqLPDcoeDB0r3LesmtZW3cE4BH40A3tlyIuNx?=
 =?iso-8859-1?Q?DopWqMRKfIAShv18yBLrY94wED+6enVNI1runqsEEBqkW/hCPXn1HdQ6uw?=
 =?iso-8859-1?Q?NZCTbpnZ7/vB3mfdEg286XX+64sf8FLJP4jDACc3dd1kEfRwr+wOpSkcuH?=
 =?iso-8859-1?Q?SCKJgThssoWT0CnGmvSApKL5JtyqXmlZj6xw6XKsdg+SB9R8HQww8dIC0B?=
 =?iso-8859-1?Q?85C4fjKNC0jkpCDlPyjKQOcQAJy6lKHxTArCVMbcg7gWigPSt0kHJNGSn7?=
 =?iso-8859-1?Q?vZEQJ+DMj9rCTKOoUWttFQnOKKbRLzyfBOdJx8EbNUh+cijNs+qCOSgzlV?=
 =?iso-8859-1?Q?Ws3Ud9/vSXFE0s1iHkdtFv8pGGfrwIMKIxScso+XtRvSFQmwjSzjyGCRQP?=
 =?iso-8859-1?Q?FVHE1fXN0A=3D=3D?=
X-Exchange-RoutingPolicyChecked: mx82U9OJkGyEC4G4gl7EAg6CUxzF5W+7eE+sZreO4dmNqHzncgQyIn+wqikk87WPQaJ/ar609lPWZl9GrjcOQfNrJ+Cs9zgGDN0yJkbh+RM+QL6i8UjznNkVtCVpMwqxwYb9D1HsTWGyfOTc6QbLXQs71+aC/o1XtnSDhAKv0fw1vVejZ8ypkEdUKGK5SOrjCSSuVFfCWEDLrySi9U79SOYE1Y654I/hcB5DfClrjB7oUtrbyj8yq/w99TLXf4xoqjo2xhB3D3lGc/fyV2lOmLBuGRayZxUFzNunMIlpYJcTRB+/+FPWaTQU+u67gopIV/yO/LZ1fY/p9HpV8wGTSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 58235d54-a26c-48ce-9fc1-08dea437fdbb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 08:35:52.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEiE9cW6GyOafKZitbn6fYLGKTLI1G/vD5i0S+60DZDbk8pnjm7hNrbrFh9X7XobmlmnZ1cCOo0BtNl6kev5Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A235A40008
X-Stat-Signature: un91ih1w1hn7ytzxcktt6q15nbikfxaf
X-HE-Tag: 1777278957-471412
X-HE-Meta: U2FsdGVkX18EMY5bGWQ+2hJWK/d+6TNo0vVTKtGhk62HzfqSDPtKi1pJFcJUenFbhe/79xHJkJWzRVGGlGBvqsB+sSuqg7aaTAs9/p2Ydg9juwTLz0D+eM2Uf7vQl1pl1SbkDBjEzDAswGG6HCZKgIIbr9FY8gvp3KA0pTRkUy2bkhfUY+z6UsMYpORR13uxNRePEDv+7RTbuQ79f0VNMyhhIR/EXI9BjRAp+AzJHbfYYQQRJ42BLutbGz3gA6CKFN86B/WCfe5/vaXtOcDRbJCHFymv4jaTz/s+aTwIYCPhM4AzbKgu2vP6DXMHzoFp7i5Udf2EruRfkPv7i86rMTRETijAWV5Rd6Pd/BDFFT5IEQjG0vUxp+0y7sWUd6LwTC9db6kTe8rxAJYP1yKHedwr21RAhgRQCYRRom+Luv8S5FWLuNekRrXN6ykNrP67IHoREU7+pgQBDjx+mHoI25ji36vRNpULRA5N5p2f00TuHB5NhPJtXj0V8LTb0+uY+R9Y+cKXKx2FhKzJZUaG2Ac8Sxc8R0yG0vKOx7P1DqadV8wzRWceFN6+iu2mBVRsKENoP9eXC2jP2jOfn7JUHjZ36N7Dfpumr2cBeQfEUr6/e9YUtfrxD4viNOQ6+Wt01vLfCAt4eaeNopKarhO3JR8FIUKvm9ma31DUF0iemgVZegGVeo8OhRAlCeF6+jEboCmcMyp+KMRqNlpNPt7pbKMhD4JNK3qaV/8qBFamdxRy1ywDiq9G2ljDvmKPaNXeGWtmLeZEoymQrT4PLQjUKgrQOpJTGl/l8/e0uReeooC0ZKOdqg/RaUZbVKm1foqcZ4V8pgkSzwsUuEKz635xdH+zu3O0z/TzH4Wu+JN5CEiZbyg9MtRvird9nV3equEPF0NxrJ5Axbay7P3Yw9R80nhSvoRkkGSC1+Ov5y7zmfTiDJaUUy5vOPUJbVavMyGM6b8T0mkGV2jJkRXL98P
 Pv0nyUNc
 esnfoGSR05HCpDjXeY+Bu1kUDaGD3nZ+09sdGmfGptSNDoa3mQ3rzKBp5OoG6kS29/RemzkKuTvoGKRrqSP7tapKoUKK/dm+ctYIDcn4Te0vR8PDf94ND8DO9vILeIvE21QoUdpN93E3b0y1pzm7leIQLKKQ15zPE5g2NPUN++oPTLNDt37HHBlE+AjN89SxTAHlONFsHKSFjT83AFYbEplfEza3AAk2ptGokI3UFeH7hImU90H/PwrlpjBu0iwEMNe80IiWzPxN5uxSdhDzAZYKWQ/8o8gUbCHIQLNUXcSoCTH29vUOPBcUaL6kg9PXUW2OpoNhAPYUMAJnXn16Sqq8aJPLSntGuvQxgR05c56eKdmuvgAzk2LhcJBkq2IMJfmNfveeXp8f/vgPlWsi3x0K/SNsvj/7UOazUd1q53WtW5YtgYfoSal/8WTxIS5XqPgYlesmutwSj69Zq/quSY5JcFcnZb7FSsIYCzeFYJ8mSt8YBjup/h9YB0a9Yi8oS2E0MRrpNH6xrMX63/cNdTTm5zv0tyni3/gK+VuLoXfRIllVOdydSHK0pptGu7UkjLQFcvgieERPvi/ouPv0GE1oP9u9iWiK1Hf8f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 3.4% regression of stress-ng.session.ops_per_sec on:


commit: 5ba6bc27b1f99b35aa528409a8e223136c59e0af ("slab: decouple pointer to barn from kmem_cache_node")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2]
[still regression on linux-next/master 936c21068d7ade00325e40d82bfd2f3f29d9f659]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: session
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202604271639.21c44b96-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260427/202604271639.21c44b96-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/session/stress-ng/60s

commit: 
  69d73421b7 ("slab: remove alloc_full_sheaf()")
  5ba6bc27b1 ("slab: decouple pointer to barn from kmem_cache_node")

69d73421b76e3d95 5ba6bc27b1f99b35aa528409a8e 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    721150            -3.4%     696311        stress-ng.session.ops
     12027            -3.4%      11614        stress-ng.session.ops_per_sec
   2757163            -3.6%    2658513        stress-ng.time.voluntary_context_switches
     37.76            -1.4%      37.23        turbostat.RAMWatt
    116476            -3.5%     112365        vmstat.system.cs
      6.33            -1.7%       6.22        perf-stat.i.MPKI
      0.52            -0.0        0.50        perf-stat.i.branch-miss-rate%
  96378014            -4.2%   92350977        perf-stat.i.branch-misses
 5.781e+08            -3.1%  5.603e+08        perf-stat.i.cache-misses
 1.298e+09            -3.1%  1.257e+09        perf-stat.i.cache-references
    121290            -3.5%     117042        perf-stat.i.context-switches
      6.34            +2.3%       6.49        perf-stat.i.cpi
      1002            +4.1%       1043        perf-stat.i.cycles-between-cache-misses
 9.116e+10            -1.4%  8.985e+10        perf-stat.i.instructions
      0.16            -2.3%       0.16        perf-stat.i.ipc
      6.38            -1.7%       6.27        perf-stat.overall.MPKI
      0.50            -0.0        0.48        perf-stat.overall.branch-miss-rate%
      6.39            +2.3%       6.53        perf-stat.overall.cpi
      1000            +4.1%       1041        perf-stat.overall.cycles-between-cache-misses
      0.16            -2.2%       0.15        perf-stat.overall.ipc
  91907282            -3.8%   88452571        perf-stat.ps.branch-misses
 5.614e+08            -2.7%  5.462e+08        perf-stat.ps.cache-misses
 1.258e+09            -2.8%  1.223e+09        perf-stat.ps.cache-references
    117705            -3.2%     113987        perf-stat.ps.context-switches
      9.20            -0.3        8.85        perf-profile.calltrace.cycles-pp._Fork
      8.95            -0.3        8.62        perf-profile.calltrace.cycles-pp.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
      8.95            -0.3        8.62        perf-profile.calltrace.cycles-pp.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
      8.95            -0.3        8.63        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
      8.95            -0.3        8.63        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe._Fork
      7.83            -0.3        7.51        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.83            -0.3        7.51        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      8.66            -0.3        8.36 ±  2%  perf-profile.calltrace.cycles-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.48            -0.3        7.18        perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64
      8.45            -0.3        8.15 ±  2%  perf-profile.calltrace.cycles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
      7.48            -0.3        7.18        perf-profile.calltrace.cycles-pp.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.48            -0.3        7.18        perf-profile.calltrace.cycles-pp.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.48            -0.3        7.18        perf-profile.calltrace.cycles-pp.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.28            -0.3        6.99        perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      7.28            -0.3        6.99        perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group
      7.27            -0.3        6.98        perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
      8.08            -0.3        7.80 ±  2%  perf-profile.calltrace.cycles-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
      1.66 ±  2%      -0.1        1.55        perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
      1.54 ±  2%      -0.1        1.43        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.exit_mmap.__mmput.exit_mm
      1.50 ±  2%      -0.1        1.40        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap.__mmput
      1.48 ±  3%      -0.1        1.37        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap
      1.10 ±  3%      -0.1        1.01        perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
      1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.online_fair_sched_group.sched_autogroup_create_attach.ksys_setsid.__x64_sys_setsid.do_syscall_64
      1.04            -0.0        1.00        perf-profile.calltrace.cycles-pp.anon_vma_interval_tree_insert.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
      0.95            +0.1        1.01        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
      0.97            +0.1        1.03        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
      0.97            +0.1        1.03 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.__kmalloc_cache_node_noprof
      0.97            +0.1        1.03        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      3.46            +0.1        3.60        perf-profile.calltrace.cycles-pp.__slab_free.kfree.free_fair_sched_group.sched_free_group_rcu.rcu_do_batch
      2.98            +0.1        3.12        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      3.00            +0.1        3.15        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      3.04            +0.2        3.19        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.__kmalloc_cache_node_noprof
      5.20            +0.2        5.36        perf-profile.calltrace.cycles-pp.free_fair_sched_group.sched_free_group_rcu.rcu_do_batch.rcu_core.handle_softirqs
      5.20            +0.2        5.37        perf-profile.calltrace.cycles-pp.sched_free_group_rcu.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      5.18            +0.2        5.36        perf-profile.calltrace.cycles-pp.kfree.free_fair_sched_group.sched_free_group_rcu.rcu_do_batch.rcu_core
      4.78            +0.2        4.96        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.__kmalloc_cache_node_noprof
      4.76            +0.2        4.94        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      9.20            +0.4        9.59        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.__kmalloc_cache_node_noprof.alloc_fair_sched_group.sched_create_group.sched_autogroup_create_attach
      9.13            +0.4        9.52        perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.__kmalloc_cache_node_noprof.alloc_fair_sched_group
      9.15            +0.4        9.55        perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.__kmalloc_cache_node_noprof.alloc_fair_sched_group.sched_create_group
     60.96            +0.4       61.41        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_from_partial_node.___slab_alloc.__kmalloc_cache_node_noprof.alloc_fair_sched_group
     67.38            +0.5       67.85        perf-profile.calltrace.cycles-pp.get_from_partial_node.___slab_alloc.__kmalloc_cache_node_noprof.alloc_fair_sched_group.sched_create_group
     60.37            +0.5       60.85        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_from_partial_node.___slab_alloc.__kmalloc_cache_node_noprof
     67.95            +0.5       68.46        perf-profile.calltrace.cycles-pp.___slab_alloc.__kmalloc_cache_node_noprof.alloc_fair_sched_group.sched_create_group.sched_autogroup_create_attach
      2.67 ±  7%      +0.6        3.24        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kfree.free_fair_sched_group.sched_free_group_rcu
      2.65 ±  7%      +0.6        3.22        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kfree.free_fair_sched_group
     79.70            +0.8       80.48        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsid
     79.70            +0.8       80.48        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.setsid
     79.71            +0.8       80.48        perf-profile.calltrace.cycles-pp.setsid
     79.70            +0.8       80.47        perf-profile.calltrace.cycles-pp.__x64_sys_setsid.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsid
     79.70            +0.8       80.47        perf-profile.calltrace.cycles-pp.ksys_setsid.__x64_sys_setsid.do_syscall_64.entry_SYSCALL_64_after_hwframe.setsid
     79.68            +0.8       80.45        perf-profile.calltrace.cycles-pp.sched_autogroup_create_attach.ksys_setsid.__x64_sys_setsid.do_syscall_64.entry_SYSCALL_64_after_hwframe
     78.25            +0.9       79.10        perf-profile.calltrace.cycles-pp.sched_create_group.sched_autogroup_create_attach.ksys_setsid.__x64_sys_setsid.do_syscall_64
     78.21            +0.9       79.06        perf-profile.calltrace.cycles-pp.alloc_fair_sched_group.sched_create_group.sched_autogroup_create_attach.ksys_setsid.__x64_sys_setsid
     77.68            +0.9       78.56        perf-profile.calltrace.cycles-pp.__kmalloc_cache_node_noprof.alloc_fair_sched_group.sched_create_group.sched_autogroup_create_attach.ksys_setsid
      9.21            -0.3        8.87        perf-profile.children.cycles-pp._Fork
      8.95            -0.3        8.62        perf-profile.children.cycles-pp.__do_sys_clone
      8.95            -0.3        8.62        perf-profile.children.cycles-pp.kernel_clone
      8.66            -0.3        8.36 ±  2%  perf-profile.children.cycles-pp.copy_process
      7.61            -0.3        7.30        perf-profile.children.cycles-pp.do_exit
      7.61            -0.3        7.30        perf-profile.children.cycles-pp.x64_sys_call
      7.61            -0.3        7.30        perf-profile.children.cycles-pp.__x64_sys_exit_group
      7.61            -0.3        7.30        perf-profile.children.cycles-pp.do_group_exit
      8.45            -0.3        8.15 ±  2%  perf-profile.children.cycles-pp.dup_mm
      7.29            -0.3        7.00        perf-profile.children.cycles-pp.exit_mm
      7.28            -0.3        6.99        perf-profile.children.cycles-pp.__mmput
      7.27            -0.3        6.98        perf-profile.children.cycles-pp.exit_mmap
      8.12            -0.3        7.83 ±  2%  perf-profile.children.cycles-pp.dup_mmap
      1.67 ±  2%      -0.1        1.55        perf-profile.children.cycles-pp.unmap_vmas
      1.51 ±  2%      -0.1        1.40        perf-profile.children.cycles-pp.zap_pmd_range
      1.54 ±  2%      -0.1        1.43        perf-profile.children.cycles-pp.unmap_page_range
      1.49 ±  3%      -0.1        1.38        perf-profile.children.cycles-pp.zap_pte_range
      1.52 ±  3%      -0.1        1.42 ±  3%  perf-profile.children.cycles-pp.exc_page_fault
      1.13 ±  3%      -0.1        1.04        perf-profile.children.cycles-pp.zap_present_ptes
      1.38            -0.1        1.31        perf-profile.children.cycles-pp.online_fair_sched_group
      0.77            -0.1        0.72 ±  2%  perf-profile.children.cycles-pp.rwsem_spin_on_owner
      0.76            -0.0        0.71        perf-profile.children.cycles-pp.__vma_start_write
      1.05            -0.0        1.00        perf-profile.children.cycles-pp.anon_vma_interval_tree_insert
      0.80            -0.0        0.76        perf-profile.children.cycles-pp.sched_unregister_group_rcu
      0.80            -0.0        0.76        perf-profile.children.cycles-pp.unregister_fair_sched_group
      0.66            -0.0        0.62        perf-profile.children.cycles-pp._raw_spin_lock
      0.64            -0.0        0.61        perf-profile.children.cycles-pp.remove_entity_load_avg
      0.80            -0.0        0.77        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      0.44            -0.0        0.41 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.64            -0.0        0.61        perf-profile.children.cycles-pp.kmem_cache_free
      0.50            -0.0        0.47        perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.40            -0.0        0.37        perf-profile.children.cycles-pp.attach_entity_cfs_rq
      0.39            -0.0        0.37        perf-profile.children.cycles-pp.__pi_memset
      0.37            -0.0        0.35        perf-profile.children.cycles-pp.tear_down_vmas
      0.40            -0.0        0.38        perf-profile.children.cycles-pp.up_write
      0.38            -0.0        0.36        perf-profile.children.cycles-pp.__anon_vma_interval_tree_remove
      0.27            -0.0        0.25        perf-profile.children.cycles-pp.wake_up_new_task
      0.21            -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.sched_balance_find_dst_group
      0.38            -0.0        0.37        perf-profile.children.cycles-pp.update_rq_clock_task
      0.17 ±  2%      -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.wp_page_copy
      0.30            -0.0        0.29        perf-profile.children.cycles-pp.init_tg_cfs_entry
      0.24            -0.0        0.23        perf-profile.children.cycles-pp.select_task_rq_fair
      0.32            -0.0        0.31        perf-profile.children.cycles-pp.__schedule
      0.17            -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.__rb_erase_color
      0.20            -0.0        0.19        perf-profile.children.cycles-pp.__ordered_events__flush
      0.09            -0.0        0.08        perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.20            -0.0        0.19        perf-profile.children.cycles-pp.perf_session__process_user_event
      0.14            -0.0        0.13        perf-profile.children.cycles-pp.schedule_tail
      0.20            -0.0        0.19        perf-profile.children.cycles-pp.update_sg_wakeup_stats
      0.24            +0.0        0.25        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      0.24            +0.0        0.25        perf-profile.children.cycles-pp.smp_call_function_many_cond
      6.34            +0.1        6.46        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      6.53            +0.2        6.71        perf-profile.children.cycles-pp.free_fair_sched_group
      6.53            +0.2        6.71        perf-profile.children.cycles-pp.sched_free_group_rcu
      6.53            +0.2        6.71        perf-profile.children.cycles-pp.kfree
      9.37            +0.3        9.71        perf-profile.children.cycles-pp.__slab_free
      9.61            +0.4        9.98        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      9.54            +0.4        9.92        perf-profile.children.cycles-pp.__refill_objects_node
      9.56            +0.4        9.94        perf-profile.children.cycles-pp.refill_objects
     67.38            +0.5       67.85        perf-profile.children.cycles-pp.get_from_partial_node
     67.96            +0.5       68.46        perf-profile.children.cycles-pp.___slab_alloc
     79.71            +0.8       80.48        perf-profile.children.cycles-pp.setsid
     79.70            +0.8       80.47        perf-profile.children.cycles-pp.__x64_sys_setsid
     79.70            +0.8       80.47        perf-profile.children.cycles-pp.ksys_setsid
     79.68            +0.8       80.45        perf-profile.children.cycles-pp.sched_autogroup_create_attach
     78.25            +0.9       79.10        perf-profile.children.cycles-pp.alloc_fair_sched_group
     78.25            +0.9       79.10        perf-profile.children.cycles-pp.sched_create_group
     77.80            +0.9       78.67        perf-profile.children.cycles-pp.__kmalloc_cache_node_noprof
     75.00            +1.0       76.04        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     74.09            +1.1       75.15        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.62 ±  3%      -0.1        0.56 ±  3%  perf-profile.self.cycles-pp.zap_present_ptes
      0.73            -0.0        0.68 ±  3%  perf-profile.self.cycles-pp.rwsem_spin_on_owner
      1.14            -0.0        1.09        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.99            -0.0        0.95        perf-profile.self.cycles-pp.anon_vma_interval_tree_insert
      1.14            -0.0        1.09        perf-profile.self.cycles-pp.get_from_partial_node
      0.78            -0.0        0.75        perf-profile.self.cycles-pp.__slab_free
      0.41            -0.0        0.38 ±  2%  perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.51            -0.0        0.48        perf-profile.self.cycles-pp._raw_spin_lock
      0.37            -0.0        0.35        perf-profile.self.cycles-pp.__pi_memset
      0.32            -0.0        0.30        perf-profile.self.cycles-pp.kfree
      0.33            -0.0        0.32        perf-profile.self.cycles-pp.dup_mmap
      0.37            -0.0        0.35        perf-profile.self.cycles-pp.up_write
      0.35            -0.0        0.33        perf-profile.self.cycles-pp.update_rq_clock_task
      0.44            -0.0        0.43        perf-profile.self.cycles-pp.__kmalloc_cache_node_noprof
      0.29            -0.0        0.27        perf-profile.self.cycles-pp.init_tg_cfs_entry
      0.36            -0.0        0.34        perf-profile.self.cycles-pp.___slab_alloc
      0.25            -0.0        0.23 ±  2%  perf-profile.self.cycles-pp.anon_vma_clone
      0.35            -0.0        0.34        perf-profile.self.cycles-pp.__anon_vma_interval_tree_remove
      0.17            -0.0        0.16        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.17            -0.0        0.16        perf-profile.self.cycles-pp.update_sg_wakeup_stats
      0.06            -0.0        0.05        perf-profile.self.cycles-pp._find_next_bit
      0.21            +0.0        0.22        perf-profile.self.cycles-pp.queue_event
      0.21 ±  2%      +0.0        0.23        perf-profile.self.cycles-pp.smp_call_function_many_cond
     74.08            +1.1       75.14        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8031BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2B36B008C; Tue, 15 Sep 2026 06:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874886B0092; Tue, 15 Sep 2026 06:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768CF6B0093; Tue, 15 Sep 2026 06:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46BDD6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:40:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D80D2A5397
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:40:14 +0000 (UTC)
X-FDA: 85215651948.30.E524278
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81C4F100007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:40:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=auPOt29D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.4 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789468811;
	b=TVC5LyJG7W5P41Y+9TSYyyl2fxXLne6FwOpnNmzZTmfzxa72QRMFALOPFOtNShGIsFpVUT
	MOj/hT1EtIsjT3gwLizwKdJwmVlOnpReOxlT1CPWCGRsOIxrIJ8OvISF8op1AUFU0fR4sr
	x1O0dePRYk0v+RMmNv9AdUW42KtlO9A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=auPOt29D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.4 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789468811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/p/lUkHzhWXjSuFTc0G/pzEC0RV2k54CVIJzMfYHpg=;
	b=RZ0NH/mxkNOk8r2uvyVNlYiQJZHXYvUSQ5mEmXxu3RZL/A/Eg4KU/FF3hEU81nWZ0CzfN9
	nPiULsPqEmkmF1v+X6cJIAHeMwcsucei/es2+9bcLMeqJi8Js8pZSs3SZahLrkcXceiBw+
	PCy5DP6Hp/bMnHLBKITyUwJ9mKUowvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789468811; x=1821004811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BK2KlqWfgs3vhThqBgccvxES69sBDk4J0IzceeSGKfU=;
  b=auPOt29DUtkrE6y+UQBryFMFm7XAYrFqQdDY+GzORZ1cyCAmkI9XIs4T
   jrZ6mSSAc/bhmqqn2XCHMF0dUqFWEyl2dgwky5Y16GUFS0bWb2wifWjmM
   EBbGHo98nx4swzPMhMek7Ic2ytpXjeiT8LeA4fIFKnFcsBrkxrtnwpnhs
   K4RELApYTLkAYbYOzvbwVqKBdE00Tp+mjl9KhT+hC/k5Jb6M784qoZc9b
   rxuVieUlBtgvWfoz6wg6vX86JDlW+gmkQrNBavi0OreaUTfWDA0aMj2NH
   NKBIcm8uOJzVR9fDvstfXXjrJO2Zie5RtWRES/QPUZaNPCYMmWe5O1KMV
   Q==;
X-CSE-ConnectionGUID: 9g9uN5V/RG665r+TPk8fbw==
X-CSE-MsgGUID: CCkJPtp9R7acVoFVn/O+BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="338514"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="338514"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 03:40:09 -0700
X-CSE-ConnectionGUID: IzeAZ4gkRXGa10Hy+m3Mlw==
X-CSE-MsgGUID: Sv1QvZizT5y0WfoiEDZ+2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="266757385"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 03:40:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 03:40:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 15 Sep 2026 03:40:08 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.56) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 03:40:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eh4UUTlGCHpFb+NJse9L7DUG3QXlMOA3AfxTCKdoRjrxSN4cv5FPshpsVPemdL675u5gjRJokQ0QS8s494QbregtoLxoVnAoGPgOQWmth4do0IBfqp+Uj67/GQezkKVwUHhQH1pW7rERiBgdcFpXjc2ilc8zy9n9aZIzoz2jY2s7kIAHuvLBU1BQ2JGr0feO4JKj5nCIYPXmqFHWAx4s6lK2sFw8CBdC/QQ0EjaLkf3mX+ZUdxDhOn5mLsP/Ojj9CB1ndlntXCXZ6W4mPo3J2O36Q17M9s1LVjaCMZvAc9exPakBeHR6T5wnfdZbTfdInaXzqY5lxxrW3M4yFr7p1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/p/lUkHzhWXjSuFTc0G/pzEC0RV2k54CVIJzMfYHpg=;
 b=oS6NbyQe23gsBUsDV+URkFgEoDoJDefSce6YAOJyA0BiMr9VxhD8BixjzskI3Oc5rOTOj0h8HX7UA9a3remzztRVallaZCroEVyiu9vRaDDslKzW15GGe5nDo2c05OE2acyrvVffbch9Lh9WEb73hQBvPkyJfbp+nJGPpYFXSkLbyqD8UKKePV6Quktn/EfgcYTArVMK7akQfisamvtB02KJxFtZx8LlGaCcNCsvl2So3XCLrCU9wVPb2aO6xKSzbWKNfQazyY2TfBZVuPhnTL7fTk0qWtGFAn0XUFPcvaVJdz/YO2BHhNOoGZmpdB0z0UsE/bDa/KSqPVRhgnQE4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5)
 by DM4PR11MB6238.namprd11.prod.outlook.com (2603:10b6:8:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Tue, 15 Sep
 2026 10:40:03 +0000
Received: from PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e]) by PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e%4]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 10:40:01 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Zou, Nanhai" <nanhai.zou@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, "Zeng, Jason" <jason.zeng@intel.com>, "Chen, Yu C"
	<yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou"
	<tianyou.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdRBpeQYFQ9mVeMEqHN/qStzhaGbbPJ8IAgABMWpA=
Date: Tue, 15 Sep 2026 10:40:01 +0000
Message-ID: <PH7PR11MB69325D48C3419508FFD8B8BEA3BA2@PH7PR11MB6932.namprd11.prod.outlook.com>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com> <aqjfyGeQaL4g2EcA@kernel.org>
In-Reply-To: <aqjfyGeQaL4g2EcA@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6932:EE_|DM4PR11MB6238:EE_
x-ms-office365-filtering-correlation-id: 191adab4-cb85-414c-1d52-08df1315b249
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: G4ujBGfL8EPzZm7AVgq5X62ENanXM1NcL1LFibIEr/1wvpSHwJfJ0Q991DuUNVJ0Ia4Wb6QrEZFzgz2qzfgYKBv/uT4xHfDHxeQcE8O0dEWX4dm0z1OctX4vmgqZzJt5TRPIbTJgk02gGNelRrsUzqgip0KKv+dFkW0ycIOJ8mzWwoLWk0dO2YBZsneyvBdcla7GNXhMOvvzmR/L35hJEGzp33RAmTDHDsgZnqq5l2iRLQ4FMVJF9Jz/kH272PfGHC6jZBtDl72e3YjxFUgXUMmHWMsbKftwK8IFOaJLEG52+QP2I/jfUQL6IvORNTkzSYvgTbdQs2cKbhBpYUMURV+HfKSHJu9Kqk6n2OahoGJ7PxhnIfq/lWyheGY2sJfjPh+bi1/2m+j7oFuDi9Dx0oNZK1ZyFtuJIiyPujXhaA2FkLSqmzeBwpi1nF14ZdETdKuKltksnkctzIRLy8ZjOK+bkEdbO8aQjYz29B55Pj8ynJCT15TsA8FdRLHve6Ypkeezts0pf7w2JP8wBx3CuKGnNbnnPc7rroENdoGMmpGzlwK/F7DG6mkFJWXamEXqGQjWMkAJXO1FF655KNAoiG6kW9tkruqcxg4iuVcHKxdteE/NodJExPcC1mkcJpDJl4HLXlK1G5iP5gZw8+xbd5GYsYET+TxF0GZOFtaE1XY2A8iuDWMgjL8dTB3hjiKVaFkDsHKn0vTKiICBG8wcuU8mzpr3xo0awblxGBfsqZo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6932.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nEvOuk7W9CcIvJ7yz6hkR7CuNKj4lEHJk9B/aaCWxqar/Bj7CBs8zVVcxDWd?=
 =?us-ascii?Q?C9oG/AmpIJhMLFlSmKvZw5dfkDNfundGBzN6ezr3kn8Va+GF2zo9vo26hiaL?=
 =?us-ascii?Q?jGFfkUxabLpVzfKsEo9mnfRVc8CY3dRt+yeRfZahH7omyLGFKaYnXaKtpz4J?=
 =?us-ascii?Q?ePmx9UEJB2GyiABgfWTOuxB0VApBaQtQ/je56WBhSA+kiUPlQRYGcBIdomUz?=
 =?us-ascii?Q?LMlwsmUb+ZErewAA+0T9w0XUvxe950r27giwUDGVd89FLvgvxap8WqpCy/VW?=
 =?us-ascii?Q?rQM/XCBzLrMRb/DCMzH6QjD4PB5BJZw1ZcCD334GMn/RxIlqObucUGCqnBik?=
 =?us-ascii?Q?GH2CNVV7O9rsK4tDlV4/LV+fvnquODzXXD3q0nVspZV6EYpm6QjW+J0oNFBY?=
 =?us-ascii?Q?7LOLOiggLIeL3REZgqAPfe/Rzm1KhW6MeSKhomKEeiAMRq8aQZK6DpyiJnxW?=
 =?us-ascii?Q?LKdXvfypHnM2g1m+pBZghVIAkm5ChV3iC7ckHSE6U12hwQDxr98c1au279Oa?=
 =?us-ascii?Q?ApF3j74ApAFMSkWY6z+K/MMJodF1gW/QSMzQhHvyvNLAeNoBaE6+Hu/EOHWE?=
 =?us-ascii?Q?Ok1/XqVFiTiMWa4zHINTx41S+J1KZj/5EJ7iHxv59fcR/c14cYizOGv+CK13?=
 =?us-ascii?Q?8zLx9cB6jwJXo9eS+1wUzNlhySAy/7+FiJ+Rf6Pu5Wyo8dN9AalptKWP0+ku?=
 =?us-ascii?Q?9XmOiYLQH7OHaG9BYQSCepTxIeoZZlN5rGri/scHfPcKR89UednKLkkgYSIt?=
 =?us-ascii?Q?D+ax7QX/VVg7dqF7JL0Ops27ufnvDMw7aXXalYCsR/zKFNKsofyufzLoxuhP?=
 =?us-ascii?Q?+jtmKqUmDdCdjErslpT8QNRbmadvvtvp2PHRXC+4ip00gt9c6edXetB1vyKy?=
 =?us-ascii?Q?pS3tA5SWDydRjO2TwrCJ0gaNha/UGAVwru1BlrA7LjdyMEP8DdN4OJ/zOFIq?=
 =?us-ascii?Q?2w+oPzQUF7PR+iQoXS/QqIzgiOban8bjvcVtHdv6BBi+OddYevnOveesKCbM?=
 =?us-ascii?Q?xkvfXfOkzbFXSlvL5uMVi0fzbxMXnmzXzRvkfY4QupWkDRGYZuO5SCSq9jvc?=
 =?us-ascii?Q?1LEFviunADW7H5Y+7Sd768PVG3oVSsHMemBBFhcB3mpn1TZogInbvjvcHUoY?=
 =?us-ascii?Q?FcmaL6q/EC5K/nyWWy74AO0pGiyDDdLRA+2fzZfsGeN3yPfgVO7nAqPjUSJF?=
 =?us-ascii?Q?d1Ej9uZAZbwKzlw6LLPVYgiR+RKUO+Gq4C1/+wFj+M6X0LjoZuiAPijvhpRr?=
 =?us-ascii?Q?RhmmN3ECAkQ1KgGYHQQ+THjcy7dKABIvxHi5wojjCObf6nFAqNQux4URlNza?=
 =?us-ascii?Q?yNpnboiWgB++T2Ab1BDjGb54lWmFK5V3Otfgnq8SYv/uwFIdjGuBe5mkd8jA?=
 =?us-ascii?Q?81m5RtX3/cOb7a2cW82dOP+BfqehjKxWVeAJ9wtN2esBwcB3QNStzl8GIDxR?=
 =?us-ascii?Q?4E3RzZbP0U/4WyXA6ayliQanzX13x7MI6+iygB+RFSKvzEh9dSDiFYd7A19z?=
 =?us-ascii?Q?09CYvmmmC816WTkv5oKfjCO2aLn2Q5qaBJUHx1+S+nKFwE0RRzd/Z9GA+Z+a?=
 =?us-ascii?Q?dlNIdos2eHoQ1cRk+J0qweWh5hNmn71h1sW3RbLEE+C7P7pCjLOX9FTMQJMN?=
 =?us-ascii?Q?IO1prLUVg+iW+pkBtWzJSZV1DKgTk+OY4bt7OIImQj12SYYYc0CH+nCMbR6J?=
 =?us-ascii?Q?2chO+xjGdTgLy9i/vBBZvUAjtouXps/hp2EoBhiX4K7bjFct?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: e8DyUu7ipD8a13VPELS/SanC/2itZFpelf+SQu02uq9gWrX+oADFxtZnnw26KBuNPSPaNNmMAA+ncvdjKpzh6rujbzk9Wj2/S+sTJ8vAuNc2iHdkaQOWkUEKDgx9rU4W1tTeadEt/vxre/JH0WKdUTk+Ydp45WwARc5Zu11OL2wsXBjlJP+U4sAOCZoTVXlWib58hv8YwsRFnokhXQ9G/bqav5m5LdAx8zMAOo/woHTtp5PGshPN2nl1BpedIVub8x0bRKBFNZJnL4O7knX8nU3lfkllWoLwJrIC91Hs0eJy6qV71EKRXgcceNtYbh3dEYBr9QrT3DwqD0aHj/cBQw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6932.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 191adab4-cb85-414c-1d52-08df1315b249
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2026 10:40:01.5732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PPIuyp9TTDfFi2SlMmNxRytIVGAVNkdn4KjvB0D5oW2Y3j8JPIi07uMdQHtlmprbZNn6KBrqYSPSnTgHDEYffQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6238
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81C4F100007
X-Stat-Signature: sjiuz483giw78cyazmcuc18ab7uak8kh
X-HE-Tag: 1789468810-723292
X-HE-Meta: U2FsdGVkX1/Gr/frZyKb6LDwAWa716Cw+MDbGNhlNalOj0u7EfFh7IMwKPJrpDxCm3TysInwRQ0NHz02gMKqkDINP4yk1USONXbtGjNc3gfxuwDL+zHM49B4JUmT20bWZDE9m++g+S97xaixyzzDmI1j59k3GNg3Kp1NtdyMAV3JJgB5RfuRHYS9YzF0f77YVHJj4LgR2pNsYRgHpTw71OokTVtQ/dvxVC4mL96Z6Zmrw0kU2VQ1C2T+W/np5139iUQhXZOQi/kKP4EqC87yRACadLGJ+lcibO58iY2YDFlOK7PHjogsDMTVmdguci9kjxKOhLkk/9ILdA+LcAiOFmijpG2czTGIH9vRhTfjIR96FTdsgTlUinUkDXMkKAsvm2Hq17aNuUOt57ftzS2w0OIKTS6fStXcwpf+Isj8K8+Y/DXENMOxm4//GPN5QpDO3CpQHzTxzMSKHOlwZK16PAZeK2buerVRvGj/fjNksbo8NasqbTV9zexJd+v2sQrgYWX2jQcbfCQ9uJQag2v+s0oADZtcpL94qKDKE7lyHuLQx7AWNeudgI+g5/bb16mz0q/FcR4OSom3t5fJBAkkeUtwpe/5zuRynw55k5GSY3zUHuIjYxPPuRKsdQFeFf9pZo1Dp19UuXbgudWMsXjKVox8C6pP+HhbxaBtJlDzr3HnPZR+zWBIbJBMJJKVVkIJ8pLq1cDFUUVT/s7nC6s2ldYpAlzqTAY2glFIY8QSughsJ0ts2NbVHH6kUJBSG+w+ibhopmmKIDU3+h3tFDGQCueh3e+o0CejXn3KuQH6Oh7fg2eprEosjFl9eM4YnAzxV47S/G8EG6wcFWkYz8P8tmB0kixCpfV6glug1W06dZKe5dYKptQJyj6YOYi+c7Z2aHi1LrLV0Ik+6nYuLEd1hldDXOpAoC9MHrX9W5hnCjrYQ/I0Bee9yeQjWejUxkf6el50b6N19k31dIj5ma0
 hasz4uYf
 yZ5SLy+6UKtxI/Tx44w7T3nfPiMFl6xal3S6YV/2/yt5AuV9sQbrmdA0+iklfh6iBTfrQ7Rb0jNaEEuyUcOFqAdeDnLZap3zuBA8B1Xx9P9ZZhpmY1nEAeWvPENU/nph4/bYOjBhL+bwQiw6xsAZphiztY9J1bcRP1mZjvizSfxW9UREDLWL1invaLfpxZWaV36Q2G9jhbU7LV8foKx74PejjIdsiy+IwXiV3S0YmgQPuCKJBctgp0hcS1xMZrfziLmRPKtpBwJhgOAA4KImlPH0OwiiJnHlOq5xPRpexw64FA5p7wpldhgGX+tugXq3KjIUV3BJbSYExo/LaTE9SzLLfWKM1lcQx82eFyMsvYgGl74aJy4ksLs/876EqmZpmvTSb0lppsqDtr8Ur+AemoppsAMcyIkshzPT4bfeefc3QujLCm8TFwW/+kAm+8dPd4V2o6UooboYd80fVKQIU8Jqzm8pI8FbpVjPlwOFm86fArW0EdPX/AMDmOaeMTAzS0KZRfR5OiTzTB0Itb3qmrXkRXA/ZXGpjRtmryfg2eaVXLODdZVm8jsbcA3xo8g5+P35WUn+5E17rx5BM8Ouu+zfL+7qQ47ns6roLpet4kG8ZqJHtOWYaLTzN9henRcH5e6aJp6vIznNH1K31QcmcsMCJz4q0wOp9IifisPysuZ+s8SVQrehRGgGJM/aDEoSZ8q+N9MIyrqM4supFiE90xZr8QGja++s248a4TE8xVvjmUooIpKM/azndrnr9CVWwH6cc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Mike Rapoport <rppt@kernel.org>
> Sent: Tuesday, September 15, 2026 2:04 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Wei Yang <richard.weiyang@gmail.com>; linux-
> mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; Chen, Yu C
> <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous
> check when changing pfn range
>=20
> Hi,
>=20
> On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
> > When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> > zone, set_zone_contiguous() rescans the entire zone pageblock-by-
> pageblock
> > to rebuild zone->contiguous. For large zones this is a significant cost
> > during memory hotplug and hot-unplug.
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 1533aebafb68..d40a8ff23370 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long
> pfn, int nid)
> >   *   zone/node above the hole except for the trailing pages in the las=
t
> >   *   section that will be appended to the zone/node below.
> >   */
> > -static void __init init_unavailable_range(unsigned long spfn,
> > -					  unsigned long epfn,
> > -					  int zone, int node)
> > +static unsigned long __init init_unavailable_range(unsigned long spfn,
> > +						   unsigned long epfn,
> > +						   int zone, int node)
> >  {
> > +	unsigned long next_chunk_pfn __maybe_unused =3D spfn;
> >  	unsigned long pfn;
> > -	u64 pgcnt =3D 0;
> > +	u64 online_pgcnt =3D 0, pgcnt =3D 0;
> > +	bool is_online =3D true;
> >
> >  	for_each_valid_pfn(pfn, spfn, epfn) {
> >  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> >  		__SetPageReserved(pfn_to_page(pfn));
> >  		pgcnt++;
> > +
> > +		/*
> > +		 * With vmemmap, at this stage all pages in an early section
> > +		 * have a valid memmap and are marked as online. However, only
> > +		 * subsections in the subsection map are actually online.
> > +		 */
>=20
> I'm having trouble parsing this comment. Shouldn't is say that some
> subsections in a section can be offline because of holes?
>=20
> Other than that
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Maybe we could add some more comments here
/*
 * With vmemmap, at this stage all pages in an early section
 * have a valid memmap and are marked as online. However,
 * subsection-sized holes within a section are offline, only
 * subsections in the subsection map are actually online.
 */

> > +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> > +		if (pfn >=3D next_chunk_pfn) {
> > +			is_online =3D pfn_section_valid(__pfn_to_section(pfn),
> pfn);
> > +			next_chunk_pfn =3D min(SUBSECTION_ALIGN_UP(pfn + 1),
> epfn);
> > +		}
> > +#endif
> > +		if (is_online)
> > +			online_pgcnt++;
> >  	}
> >
> >  	if (pgcnt)
> >  		pr_info("On node %d, zone %s: %lld pages in unavailable
> ranges\n",
> >  			node, zone_names[zone], pgcnt);
> > +	return online_pgcnt;
> >  }
> >
> >  /*
>=20
> --
> Sincerely yours,
> Mike.


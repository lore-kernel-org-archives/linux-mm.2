Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD591049514
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29A86B008A; Wed, 11 Mar 2026 05:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1A56B008C; Wed, 11 Mar 2026 05:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994E86B0092; Wed, 11 Mar 2026 05:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 690806B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:23:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58CFCC26ED
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:12 +0000 (UTC)
X-FDA: 84533243424.05.AB00E8F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41E85A0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fo19UhwX;
	spf=pass (imf15.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773220988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NB2nBRc43fDX8zlDL4NBYU+3M2DIhtkp5vKO6YL+b6M=;
	b=y53RdlaPSdd0LQW5ge3xwcsQCK/wd6U2JJJlAChHm04AUytwoKTgvdbizyu0uOdvWIgn+Y
	WkuHJEk+02bZyexkZsiow0j8MlN5BPBepHdBDfJVm6xAmB2Mw57T3q4kneZGOwfqAiT5At
	i9RDhX0DeZjNTSmmmJpNltQuZfjDFJM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fo19UhwX;
	spf=pass (imf15.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773220988; a=rsa-sha256;
	cv=pass;
	b=Sc+6dUE8DSX/jto0R+DQ6IziuzUinW9na0wrjUzhmLrp5qlTd7ymtTjNiQTHI8pwlHv4jL
	Ad0QEgc9O96Lrd9F4+U7FcYO2+P7L6SuxOYGgb5SeMy3Y5dHlGFd3DpjxRyeWHkSfs+yCM
	vFga+MmUhdc+gyr5aJ7MaX8QVMuD22c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773220988; x=1804756988;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NB2nBRc43fDX8zlDL4NBYU+3M2DIhtkp5vKO6YL+b6M=;
  b=Fo19UhwX6UW2qVtgWu3fPdiNxxW5LRTB127Jv8DJHSjfbcqw6AKLrKFz
   +IAXyvNyZV5u/IOjE1QmcTDNTqe3OLmLUBELg02kBazlnOD2mBKHuMINj
   htyFW/JtyJJIPEUgiHNXrZQ4cPZLkodZFd0s0S3sdwTmowoI38UByDV/c
   agROsTgRL2K/hWHESLJ9HYi35j/6+gL4NRZp4DsChZ0JS1469Ti6eADze
   7Q3ebWa+PTsd4UD5cZmhzG1s3ry86/6p4ZbmaNOkjckEDDnWvSvSCblC8
   imcam1AHNYa97gNooO+sb+R2Vga1NPm2kNmLbMgi2eYVZK0t2MwTeDYdA
   A==;
X-CSE-ConnectionGUID: hlpXFwmGRUiO3fp0Diuktw==
X-CSE-MsgGUID: Ga93wdB7QFa51t2vOylzfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="96899284"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="96899284"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:22:59 -0700
X-CSE-ConnectionGUID: JgNxlRfBS6KCtj1uc15vuA==
X-CSE-MsgGUID: 3z3bFIfTQuSWrDhKNAVhnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="220353827"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:22:57 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:22:55 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 02:22:55 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.10)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:22:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=baDKytEOSuGkPkikYD7+K5e3b064XaUagF8q4zWo7sRLP1x11vxxCZ0aqocLiEvcRwPWXe5NmAi4V60e5wQ242jK60Xlom2m7LiDRCfrqO/giF+QjAotDZJba+hbVhOJjkLM3VawTekdruOcV8QPGq6XLuXxzygetIn4lARS5+PjYAQODAQNeoeM9tLVHNNd6uXTVpCWgv5zZcXOY22kMhohQ2ORDtH8f+fftD3Dpra3gBjm1VffTHnMecQ1QbKmK+sf0qU/GweRNoPR4Jbchgp3J2xy/rYzrSRUxjOZTw3l+5/mVduPjfjn/wYXN93fxX24jg5tzIdZsbXPQfAT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NB2nBRc43fDX8zlDL4NBYU+3M2DIhtkp5vKO6YL+b6M=;
 b=w904wRkk3dEy+6955ivcfDdm519SZfBc5PoypOQOBqhPX/y2QEtd3JxFPwp8SAy+upM81Z/48KwY/MTVwpbA3zCHIBa7vma0VOm/BX43uRXEWRfAEOhvtJnBDOdk/TB+1u0BZpbJNiH2njmsAJayodsYG2VYrZfJ1rUVeDQGUeuxtVNd9MpyX0IIoD2QNvQc0iTzdLRSMQDVD8jB3kU3oj5xl0O9FRM2gFcxrnYX2dZqlT0eGyBrDds+cQ50dAc+23+4t1lVTW6X8IamG0cZpNgo2lHUCE0lzAHfbSP6GxPZKZyR1lqfgSUg/Lj2ItGwfGTAl/hAg9SsopqfrY2Yvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by CY8PR11MB7897.namprd11.prod.outlook.com (2603:10b6:930:7d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 09:22:47 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 09:22:46 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Philipp Hahn <phahn-oss@avm.de>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "apparmor@lists.ubuntu.com"
	<apparmor@lists.ubuntu.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "cocci@inria.fr"
	<cocci@inria.fr>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-bluetooth@vger.kernel.org"
	<linux-bluetooth@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-gpio@vger.kernel.org"
	<linux-gpio@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-input@vger.kernel.org"
	<linux-input@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-leds@vger.kernel.org"
	<linux-leds@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-rockchip@lists.infradead.org" <linux-rockchip@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-sh@vger.kernel.org"
	<linux-sh@vger.kernel.org>, "linux-sound@vger.kernel.org"
	<linux-sound@vger.kernel.org>, "linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "ntfs3@lists.linux.dev"
	<ntfs3@lists.linux.dev>, "samba-technical@lists.samba.org"
	<samba-technical@lists.samba.org>, "sched-ext@lists.linux.dev"
	<sched-ext@lists.linux.dev>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, "tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>, "v9fs@lists.linux.dev"
	<v9fs@lists.linux.dev>
CC: Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 30/61] net/sunrpc: Prefer IS_ERR_OR_NULL
 over manual NULL check
Thread-Topic: [Intel-wired-lan] [PATCH 30/61] net/sunrpc: Prefer
 IS_ERR_OR_NULL over manual NULL check
Thread-Index: AQHcsKJ0tObOnwx+9kO98VYqVZZsnrWpD+kw
Date: Wed, 11 Mar 2026 09:22:46 +0000
Message-ID: <IA3PR11MB8986B27E91681D79D9D8A387E547A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-30-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-30-bd63b656022d@avm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|CY8PR11MB7897:EE_
x-ms-office365-filtering-correlation-id: 7b7a6dfc-62d6-47f1-862d-08de7f4fc20e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: GxQQCd/c8eV6aNEekxf/kywrprbTaee5KerYvJkRN8yhsK9GmObVtty0cvZUqgruTDOnh9FYrnoryvIlYHlX1jPbTuRpZFBHu0FodbAGXBM+tQqVuKBZx5Rq5rtunOYZymKDvLdiGJJ+X2LSaEy6lyql4V32YdAsR9WvQ8LriGm0kT3J9sogaMlIk3w+RzQKv2V36PikgxJS0X03x1SKBIvYbugQ7+HXCFx+S54977zIJ0P0jRt4d3SI4R500xOle9LL9wl+NKUs+ZtXRPDTxXBRGMmhTxjrDke6HTfJlrlwNrD4bO3TlWEkE4iYRtPmH6ZzCA+S/yfwao3UbFe2MBKJPGG/WIGx8wWaqVG8suHB5h+oms3skixZcAmCnqUZfNhX7jCe114UW1puMdstFSN+lluiuvgbvmN1SFqRfkJOHBuCbAjmvGKIgPeUiVCJTUDUyRxcP3PVqW9bRFVu2O60LuQEA92OXdiCFtLBjr+mbnFBBlCUgnPczWphaTpOXMhAO/fyChiiDZF9qZNNPmIYPAtYNfW5A0zaj0sn5oIUzYxRvpEaS+vUowvXJ7WJPDoYhzDQl9DBoT7+PIYO895bhBXT1Zmo1y0gHPtb1RFJQqg+Fz4LGos7/ZrbG2fXN5CnlbS7KCCsk7050OVomSqrDeM2JP8EJnLoASHFjS9kg1Kq4S9smaAsEcfjgDGCX2082HK5ZN49fqlW/TzBrwoLWqJsfEGeIAfOm9NxClGzHYS4qqDJ40xLMc2sASYXhYaiH1O3kHtejDX8szCddM4ytwOhjczmM5QSQx06WvcYdwOZd6yMRpnXJn/nr1Cy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WU5GNWpPRWt2UXd3R05laHJacUZxQzlXN3RlNXh5YVJVUHFnbzh5OHB5TFY0?=
 =?utf-8?B?SkNhUXVpeHkrejlsNzA3YzYzdDlxTFVIRUptdzdiMU5ndFVpSCtvOXVhZDBl?=
 =?utf-8?B?K3l5dGFlWDRPVVVpaXRWRFJiTDYxbjJKOU5lRjR1bzFMbG5aU09obU5ya3Rj?=
 =?utf-8?B?L0JrWS9BRnVodFFZOXp4a01VYlA3WnBWMHd1TmRqWkliT2ZCNG13dTlPQ1RE?=
 =?utf-8?B?NWp6MXFFMEFMTU1STFh5bWdRSDdnMmI0RTh3Z2RhNlRDSDdZQWNoQ0VHM25m?=
 =?utf-8?B?cit3LzlUclZzUEtXQjRnVlEwQitxc2NoZTc2cXV0M2hUaSt6cHdQcVEyUHFN?=
 =?utf-8?B?Q0pFWjhETFI4NzI3Q0gvcjIvY1RrNDI1WDdMZjMvYlQxaThJcjZia0FuOTZ5?=
 =?utf-8?B?UEZwOUZSREhXSXk0MUdWUmR3OWhQT2trdlBTVUNFN1g5WitSeFVMMWdtSS8x?=
 =?utf-8?B?T0lLMyt6M29KbnV5VFNaejRiMWF3akhkQ0JzbVB2dmZIbjArOVM0MlltdktG?=
 =?utf-8?B?VVVKdTRHUjRlTnVpTVhLSE9saE44NnQzc2RQbVp6ckRQR2UxWENFR3NUc25R?=
 =?utf-8?B?aEQxaHc0U25FZWpQQjJ5Rzh1VmtUZW1McElvWTdTeEpvaS9GVG5lektXUVVn?=
 =?utf-8?B?RUxCbk40em5TQTR1dE0wV1p3T0RJVVJVQWc4dW1QeHkvcnZiYk1lSHBPUFdi?=
 =?utf-8?B?S1BGMGVhUGVyRDRjL3dFT1JFaGFuViswTk1SZXNiNXZJdEhqTnpqSXdWK1o5?=
 =?utf-8?B?ckJrd3kwT2lmNVljOGJvRWRRaW1PNUQwT0xUWkpXYUtNWWF3VUN5Q3VLRGh6?=
 =?utf-8?B?bVFqbm5QTlRCZll2SVhwaFVYSW5DMGhOWDRRbjU2bUxVVUtXNFg5UkN1eG0w?=
 =?utf-8?B?L3Rqa2F1SVUrazdqZ2doMHhBSjdML0s4Z21mRm5WdlJ5M1F2cDduYTRySDM0?=
 =?utf-8?B?N3k3THpiYlViTnZhV2VvQm0vOXVpRHBHUmZGaEpBcnBERkw3Qlc4RnEyWWpE?=
 =?utf-8?B?amU3RTRZUjVNYjZxR29VSXAyNVU4OFhsYVptTTQ2THVsOE85ZVYvTG9vSU05?=
 =?utf-8?B?SUpIbDFCOTJmZWU3ekpVL2oxNDRGWUFnZG1YUHJXRGVLaGFJczhVZFNjdW1B?=
 =?utf-8?B?cjhFbGJVT3NvWHlKV0pRMHZ3eDZxMzl4azVZRjY3S09vSFZ3RjRhSldHWUhV?=
 =?utf-8?B?c212T1JlSHZpSGVoQ29XR3NpRE9qa3VvWGRrODFyc3BkNXVHdStSZGszQzJw?=
 =?utf-8?B?UllibFlFRmVLRjlPcGFMM1VHT09ZdzZrRHQ3WDIvaGZRVkZOUHNJWUloU05r?=
 =?utf-8?B?NkJza1NvdFZuNUhBc2FiV08rbDlxSVhzd1RqencrdXZiVzFUa0RjTURnaXZ6?=
 =?utf-8?B?T0VTT0x4cEZVTi9uVDc3ZFVKSnNIb01FTnhCOHd1c3Vqck1OdnFQMnFHVzJx?=
 =?utf-8?B?SVFXcURtMnJ5MGF5VlRRdjVpNHVYMG45ektvaUVORzA0b21NV2FwZ0wyc3VC?=
 =?utf-8?B?L2xxbGg0VnpZcTRhMzdlNncxRzk5Q21iNnYrYnJMSmJMWWtPcU9BZUtMWWxG?=
 =?utf-8?B?bkFJVm5DaHZ5aFpCNjE1V1RMZ1JELzZOUk9QdGIvRythMjZib0d1eDNSVUZS?=
 =?utf-8?B?aXZlbExHUU1xZWtRc3dqRFl2QlJDc05hZzh2eEQ0U1FKdGlIa2NQMUhCRmdJ?=
 =?utf-8?B?L0N2VDNFcDNwRjRFUDR2RTZ2dG1iQVg5OVR6d1d6OTdWeTB5cnI0QVRHTWxI?=
 =?utf-8?B?ZkhLT201RHRkSUJ5VXc3a3JmUitEczJodEhqaEhzTHl0UmhkK2hCMEE1V1h1?=
 =?utf-8?B?RjNuczdmTmdsNVlDMDE1NXhPNHcwRklJQW1xL2MxdWNsRnIwZVF5bVdiNXJ4?=
 =?utf-8?B?WGw5OEM1V0pwS1BXSDVuYy9OQmJuVVdEUlA5amFYL2JCSllLaEhnSnZhR0Uz?=
 =?utf-8?B?SmRJZTlnWjRoU2Jwczc0bTQwdzdHNkhJamxGUXRsd3dDdjZpNVk1NE1QT0N4?=
 =?utf-8?B?bVNwZ1BqbllvZTNTVHdSN09MT1RGQWlpa3BzTkhxZU4xUjRxMjBPdm01RGZN?=
 =?utf-8?B?VXZJODBnd2dnZVU0ZkM4RVM1Q3A2MkIrd3ZLaCtSaXhnOTlEaUV0dHBRay9W?=
 =?utf-8?B?TURmTWI4V0RVQVJxUFlNS3lNcmVndGMxSk14WFlmdEsyQTNVemdiZGZIY2FO?=
 =?utf-8?B?UGk5NjBmaFFHVVZWVXB3VmxZb1lBT005blU5ODlsRjMyclVPRWRJZENGbFZi?=
 =?utf-8?B?dmxZeGNPSWs2Mnl5dENGTFIwaDJkdWtjSVI4Uyt5ajluS1dlTVIxNXBKem9j?=
 =?utf-8?B?aTk1UkhSUHBsWUM4WkhuYTNTdXAzU0ptSEZVU2tDcFJldkpnOGxacEVLc3hN?=
 =?utf-8?Q?d+ODkmbfj2d1XMOQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: uqN/PRuN+pHeGKAJeiVslQTfIoQDMSjXr/jPdOzJJ3OoQQSj1v7QxjBPGBW57eCn9dqtHV3Z3wcPezqhXwae0k4zhFu9vFi0et76GamFVnAkwI7j5nAUh51dQkzv7R11kKVmL7oPWLpUFr/Tp9x33d6niKWH7giuk1bdQtDsIPGTQEfzNY9PS91Tov41ZJ1s9KEOQUrVXkuWUAl3T655CAr6N9dkUsS6vrgGUjGgnP1oRdTpPPEHB0iXn1jkQGV/Q/vi9xP1yDKqBy6Bab/qdCXXkE2CQhJXlb9oyHY91l4tUFHb588Fyn/6VCgF8kU3Mh9lJHZ+WMoUvfnbvo5/bA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7a6dfc-62d6-47f1-862d-08de7f4fc20e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2026 09:22:46.7619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZLgNgL1yFcWDQiRaEtxZHr4XDLXtW42+n30PIQJxmEMOHU73e4kE3c/XFVsH5B8Pm+/0D1cNn3DD5Kane2r8K2fhocF3RSNuDUsNdiqZA+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7897
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 41E85A0005
X-Rspamd-Server: rspam08
X-Stat-Signature: ng9q76pj5g94fjpt8yrqqx614cuuxceu
X-HE-Tag: 1773220988-866710
X-HE-Meta: U2FsdGVkX19lbB/BedERyfCza6zTRzHkJzjRHzzriB+vHdswqQxvuvWdXNY5PgakrcREVhKVmAITUiwKzJwwoBY3LBFNaK8/0v0fsRWG+URhz6udtzNn0d2580XeKFi9THkhGtvzg9iDryLhKLbsQkRrQ6JiurHdE+moEgzFzlav5sxXNju1Pxq81zK9eQKdR2jP05WL5bpVv3UeTB9865cGbC3Uq9QKKVTpo1Ga9/LguJKuHlJGh0aFaHM+gd3dhqzJ7g04L9Rzv77jiKmNIUTkfUYvndUw7cOyF4VK+L2L6ewSaJQITNiLG12lJlbFkXaqM/gAH0gCWzZ0wZXxWz3Xhe6ZYOd8z4XbFmZZ/GmMClUoG0GbfeJ5DOOVJj/EacdQoqmoQ7TyvS6VOMWTNyplvJJOuomhHc/iTg1FBXrf1MXhzMpIgB7eFf4yQRllnAUrv5aG0OO5BXnmYwUTRRFYT7WStNyYKLdVlAOWisEH1kFKBD4eUR5WqewldnpHBr5UE7FI0ytUkvn+S2xnQsb7njR+1iEW7RsZ64Y5y9VoH+JkWczwrxzfeXgKGnCOhhXuQKPmW/3GiCEZonpUUPBDs4nnztPS2jgHHADE7EcYwEsfhMDAQC5HjR5GitxWDPvBP2uDN2Zy1AjmWWMmbaoY75tJtPfbWHIcTN4YA5MrQdi4u8Zw2uOwNDAoHC5+fQBsN7h7zhMgn1DeabEdrArEUmkxgOrh9SD/efWqPyks6JMl3S63/SgsPz4311GbQZe0Nf3a4yHIm1ihrgZD+wMpDlg3ZWs3KWr5n/lO9/+/PFyuI9EbUa0Kb27J+MVyW6AXdS4fS/6HlDAWdnw1FX23fkKrQI3inYGo04GLsyWiYilDNRD/PxJXJ5vfES/DZMHza2DoLUYpnOnFia4DZJt0/fWj11f2ct2QXejuS9B3nocPI8PvFHZLHglbD0/LvMF2yIwNVqlMiwtPmzV
 rz1vFLmS
 wqBmwxwJNQVWd7c1uWsMDtPex05fZ60AvQ+u7WxNjqiOKHM+kmRBpQOWh79jpBSdf8UNRg/ZBjxTsCLc9BOSIGJ3j6MR/wParj5FM3M2Bju/sth6C1k6OdNu3ZpVh9j+Jp+e8MW/6KqEJeJ5wU5it8Q8k7CZ+w9xjhS6d0VqvcfV9vu015mvfMR9nBuTwifr7ATPlgbFNFgkUAg8r4PWYNRTdanf3C1gobFtIO9fSHH/Nf+pEGmi83FBsRBa+FH3YZcy07ymNbc4Jl7p08sNPg0wN0SXrfUa+lOE5koiYiIUmsvs9flosTTrBhL9dd/+HnX/dcommaBT0snbU+7PGNK4+nwvh9ZjrSKhOy80n9eF/Ybw1YllHThMCNhQqgNcRftivbbSQzCGn+1Z+5e5dutjXS4Znsd9VBZ79wxXQigY7geDe0QkFbL24iLR6HPU+bbw1IOOYe3eSLp8KmdPFMRhCcR/rUKqR2Py6/X7Hjil5x/5OrKVWdRz8o/PLmBoDdXAjDdVuO0txJyBaDNLXLXoo0Zak2Z/YsBbBGrO3pSlKrUqD+30VFWL5HeeMB3/bEoVgpPEF2yilgjsh2G9IExYkJSodEa1myq9zgtmB/HnzU3DwNks5Q0fcw5RT4z1z3eJgQgop4HAg17+qQCAf/YzxQaYW/zohAvFydJz8mAzM4r5ZvM0Tnh0+Yy/L8lqVPznQ0wKp1O6T+cHkL0t9m3MBjUKbfS8Is/WSHqF1wX6J/DahUnJSg0OqGTjpA/yFfSrMIqhI6gqC3uwyBZ2A5ScsDiOdocHrejF6h/Rjxl5c1+O3nsL/DeKZDmWj9lObZxPTOvFjNfS98DQ7W7iYKtHS94/VHr9EBqFtBZjCMpoYb6dNCMWxufNmmP3IivxHW/nE/ATTbIQo6RUYBPCzkX8+GwMOOtNBuiOJ2t8gOZ6N6T9KMrxUdBGLzQQZfX07ehBzksJQBrjHbQSnP7jrXT5+FD6F
 uhktONmz
 qGHYI5gnuldgVt978znmN2DhXlbH7SRYLsgDsNaBhaqAw2nzvE8VPfWSrOtUcUTmWqW7J4yxlUOqUfnAwotaFW/ra0fqqQkplspi4xANgOSPaTYPKebyrtCkvqQKWSPAtlo93bXb+FclHpKjrP9SY339tndI0ZKuLvn2bgGz7rBwtSUT/P/UBnfdK8cs3A7v82WuMK5gYLBjsP0ldjIKrS1tr49Qwd5y6CF+mHTIPdhHOgsXuJrG3cNuAPI2myLCnhEnH+a4ncoO+rUFepRiX/pvusJh4Ujm9erRQfrIVgSuF6cWcze37sDXT+UQcHvGdiZegZSVBUig6J3kzkd7ix11jYHVijzx+FhSYekAwqXQL6LqxIDPOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtd2lyZWQtbGFu
IDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnPiBPbiBCZWhhbGYNCj4gT2YgUGhp
bGlwcCBIYWhuDQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDEwLCAyMDI2IDEyOjQ5IFBNDQo+IFRv
OiBhbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgYXBwYXJtb3JAbGlzdHMudWJ1bnR1LmNv
bTsNCj4gYnBmQHZnZXIua2VybmVsLm9yZzsgY2VwaC1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IGNv
Y2NpQGlucmlhLmZyOyBkbS0NCj4gZGV2ZWxAbGlzdHMubGludXguZGV2OyBkcmktZGV2ZWxAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnOw0KPiBnZnMyQGxpc3RzLmxpbnV4LmRldjsgaW50ZWwtZ2Z4QGxp
c3RzLmZyZWVkZXNrdG9wLm9yZzsgaW50ZWwtd2lyZWQtDQo+IGxhbkBsaXN0cy5vc3Vvc2wub3Jn
OyBpb21tdUBsaXN0cy5saW51eC5kZXY7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWFy
bS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtYmxvY2tAdmdlci5rZXJuZWwub3Jn
Ow0KPiBsaW51eC1ibHVldG9vdGhAdmdlci5rZXJuZWwub3JnOyBsaW51eC1idHJmc0B2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LQ0KPiBjaWZzQHZnZXIua2VybmVsLm9yZzsgbGludXgtY2xrQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtDQo+IGVyb2ZzQGxpc3RzLm96bGFicy5vcmc7IGxpbnV4LWV4dDRA
dmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWdwaW9Admdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsg
bGludXgtaW5wdXRAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtbGVkc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBtZWRpYUB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LW1pcHNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGxpbnV4LW1vZHVsZXNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tdGRAbGlzdHMuaW5mcmFk
ZWFkLm9yZzsgbGludXgtDQo+IG5mc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW9tYXBAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC0NCj4gcGh5QGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LXBtQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtDQo+IHJvY2tjaGlwQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxp
bnV4LXMzOTBAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LXNjdHBAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zZWN1cml0eS0NCj4gbW9kdWxlQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtc2hAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gc291bmRA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29t
Ow0KPiBsaW51eC10cmFjZS1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC11c2JAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC0NCj4gd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOw0KPiBudGZzM0BsaXN0cy5saW51eC5kZXY7IHNhbWJhLXRlY2huaWNhbEBs
aXN0cy5zYW1iYS5vcmc7IHNjaGVkLQ0KPiBleHRAbGlzdHMubGludXguZGV2OyB0YXJnZXQtZGV2
ZWxAdmdlci5rZXJuZWwub3JnOyB0aXBjLQ0KPiBkaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdl
Lm5ldDsgdjlmc0BsaXN0cy5saW51eC5kZXY7IFBoaWxpcHAgSGFobg0KPiA8cGhhaG4tb3NzQGF2
bS5kZT4NCj4gQ2M6IFRyb25kIE15a2xlYnVzdCA8dHJvbmRteUBrZXJuZWwub3JnPjsgQW5uYSBT
Y2h1bWFrZXINCj4gPGFubmFAa2VybmVsLm9yZz47IENodWNrIExldmVyIDxjaHVjay5sZXZlckBv
cmFjbGUuY29tPjsgSmVmZiBMYXl0b24NCj4gPGpsYXl0b25Aa2VybmVsLm9yZz47IE5laWxCcm93
biA8bmVpbEBicm93bi5uYW1lPjsgT2xnYSBLb3JuaWV2c2thaWENCj4gPG9rb3JuaWV2QHJlZGhh
dC5jb20+OyBEYWkgTmdvIDxEYWkuTmdvQG9yYWNsZS5jb20+OyBUb20gVGFscGV5DQo+IDx0b21A
dGFscGV5LmNvbT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMg
RHVtYXpldA0KPiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+OyBQYW9sbyBBYmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBTaW1vbiBIb3Jt
YW4gPGhvcm1zQGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRD
SCAzMC82MV0gbmV0L3N1bnJwYzogUHJlZmVyDQo+IElTX0VSUl9PUl9OVUxMIG92ZXIgbWFudWFs
IE5VTEwgY2hlY2sNCj4gDQo+IFByZWZlciB1c2luZyBJU19FUlJfT1JfTlVMTCgpIG92ZXIgdXNp
bmcgSVNfRVJSKCkgYW5kIGEgbWFudWFsIE5VTEwNCj4gY2hlY2suDQo+IA0KPiBDaGFuZ2UgZ2Vu
ZXJhdGVkIHdpdGggY29jY2luZWxsZS4NCj4gDQo+IFRvOiBUcm9uZCBNeWtsZWJ1c3QgPHRyb25k
bXlAa2VybmVsLm9yZz4NCj4gVG86IEFubmEgU2NodW1ha2VyIDxhbm5hQGtlcm5lbC5vcmc+DQo+
IFRvOiBDaHVjayBMZXZlciA8Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4NCj4gVG86IEplZmYgTGF5
dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+DQo+IFRvOiBOZWlsQnJvd24gPG5laWxAYnJvd24ubmFt
ZT4NCj4gVG86IE9sZ2EgS29ybmlldnNrYWlhIDxva29ybmlldkByZWRoYXQuY29tPg0KPiBUbzog
RGFpIE5nbyA8RGFpLk5nb0BvcmFjbGUuY29tPg0KPiBUbzogVG9tIFRhbHBleSA8dG9tQHRhbHBl
eS5jb20+DQo+IFRvOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4g
VG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gVG86IEpha3ViIEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IFRvOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5j
b20+DQo+IFRvOiBTaW1vbiBIb3JtYW4gPGhvcm1zQGtlcm5lbC5vcmc+DQo+IENjOiBsaW51eC1u
ZnNAdmdlci5rZXJuZWwub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHAgSGFo
biA8cGhhaG4tb3NzQGF2bS5kZT4NCj4gLS0tDQo+ICBuZXQvc3VucnBjL3hwcnRyZG1hL3N2Y19y
ZG1hX3RyYW5zcG9ydC5jIHwgMTIgKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9zdW5y
cGMveHBydHJkbWEvc3ZjX3JkbWFfdHJhbnNwb3J0LmMNCj4gYi9uZXQvc3VucnBjL3hwcnRyZG1h
L3N2Y19yZG1hX3RyYW5zcG9ydC5jDQo+IGluZGV4DQo+IDliNjIzODQ5NzIzZWQwZWI3NGI4Mjc4
ODFjNmYzMmQzNDM0Yzg5MWIuLmI0ZDAzZTU5YTgyMDJmMjAzNjBjZmYxZTJlNzkNCj4gYjFlMzI1
Mzk2NTE3IDEwMDY0NA0KPiAtLS0gYS9uZXQvc3VucnBjL3hwcnRyZG1hL3N2Y19yZG1hX3RyYW5z
cG9ydC5jDQo+ICsrKyBiL25ldC9zdW5ycGMveHBydHJkbWEvc3ZjX3JkbWFfdHJhbnNwb3J0LmMN
Cj4gQEAgLTU3OCw3ICs1NzgsNyBAQCBzdGF0aWMgc3RydWN0IHN2Y194cHJ0ICpzdmNfcmRtYV9h
Y2NlcHQoc3RydWN0DQo+IHN2Y194cHJ0ICp4cHJ0KQ0KPiAgIGVycm91dDoNCj4gIAkvKiBUYWtl
IGEgcmVmZXJlbmNlIGluIGNhc2UgdGhlIERUTyBoYW5kbGVyIHJ1bnMgKi8NCj4gIAlzdmNfeHBy
dF9nZXQoJm5ld3hwcnQtPnNjX3hwcnQpOw0KPiAtCWlmIChuZXd4cHJ0LT5zY19xcCAmJiAhSVNf
RVJSKG5ld3hwcnQtPnNjX3FwKSkNCj4gKwlpZiAoIUlTX0VSUl9PUl9OVUxMKG5ld3hwcnQtPnNj
X3FwKSkNCj4gIAkJaWJfZGVzdHJveV9xcChuZXd4cHJ0LT5zY19xcCk7DQo+ICAJcmRtYV9kZXN0
cm95X2lkKG5ld3hwcnQtPnNjX2NtX2lkKTsNCj4gIAlycGNyZG1hX3JuX3VucmVnaXN0ZXIoZGV2
LCAmbmV3eHBydC0+c2Nfcm4pOyBAQCAtNjA4LDcgKzYwOCw3DQo+IEBAIHN0YXRpYyB2b2lkIHN2
Y19yZG1hX2ZyZWUoc3RydWN0IHN2Y194cHJ0ICp4cHJ0KQ0KPiAgCW1pZ2h0X3NsZWVwKCk7DQo+
IA0KPiAgCS8qIFRoaXMgYmxvY2tzIHVudGlsIHRoZSBDb21wbGV0aW9uIFF1ZXVlcyBhcmUgZW1w
dHkgKi8NCj4gLQlpZiAocmRtYS0+c2NfcXAgJiYgIUlTX0VSUihyZG1hLT5zY19xcCkpDQo+ICsJ
aWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5zY19xcCkpDQo+ICAJCWliX2RyYWluX3FwKHJkbWEt
PnNjX3FwKTsNCj4gIAlmbHVzaF93b3JrcXVldWUoc3ZjcmRtYV93cSk7DQo+IA0KPiBAQCAtNjE5
LDE2ICs2MTksMTYgQEAgc3RhdGljIHZvaWQgc3ZjX3JkbWFfZnJlZShzdHJ1Y3Qgc3ZjX3hwcnQg
KnhwcnQpDQo+ICAJc3ZjX3JkbWFfcmVjdl9jdHh0c19kZXN0cm95KHJkbWEpOw0KPiANCj4gIAkv
KiBEZXN0cm95IHRoZSBRUCBpZiBwcmVzZW50IChub3QgYSBsaXN0ZW5lcikgKi8NCj4gLQlpZiAo
cmRtYS0+c2NfcXAgJiYgIUlTX0VSUihyZG1hLT5zY19xcCkpDQo+ICsJaWYgKCFJU19FUlJfT1Jf
TlVMTChyZG1hLT5zY19xcCkpDQo+ICAJCWliX2Rlc3Ryb3lfcXAocmRtYS0+c2NfcXApOw0KPiAN
Cj4gLQlpZiAocmRtYS0+c2Nfc3FfY3EgJiYgIUlTX0VSUihyZG1hLT5zY19zcV9jcSkpDQo+ICsJ
aWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5zY19zcV9jcSkpDQo+ICAJCWliX2ZyZWVfY3EocmRt
YS0+c2Nfc3FfY3EpOw0KPiANCj4gLQlpZiAocmRtYS0+c2NfcnFfY3EgJiYgIUlTX0VSUihyZG1h
LT5zY19ycV9jcSkpDQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5zY19ycV9jcSkpDQo+
ICAJCWliX2ZyZWVfY3EocmRtYS0+c2NfcnFfY3EpOw0KPiANCj4gLQlpZiAocmRtYS0+c2NfcGQg
JiYgIUlTX0VSUihyZG1hLT5zY19wZCkpDQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5z
Y19wZCkpDQo+ICAJCWliX2RlYWxsb2NfcGQocmRtYS0+c2NfcGQpOw0KPiANCj4gIAkvKiBEZXN0
cm95IHRoZSBDTSBJRCAqLw0KPiANCj4gLS0NCj4gMi40My4wDQoNClJldmlld2VkLWJ5OiBBbGVr
c2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT4NCg==


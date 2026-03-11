Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1294EFD0657
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493DA6B0089; Wed, 11 Mar 2026 04:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454AC6B008C; Wed, 11 Mar 2026 04:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316336B0092; Wed, 11 Mar 2026 04:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06CCD6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:19:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0A091C935
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:19:19 +0000 (UTC)
X-FDA: 84533082438.26.112DB7C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id D23DA1A0015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FROBtXBQ;
	spf=pass (imf19.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb8k9EUnk5kJj2LtvvAOaCQRgisPN85MlLKf/pO85gI=;
	b=3dbNEx/xgmQfPU6qBzNlXOSfoYNcnf5hrKg4PRfA0U4MtvB7sEQ/LEU2V2mz2HSO/ngduC
	QOfDYVOpcEF02G3lC19+5lpkswIFYtmHIp4462mzlpL9N3hnHJKF9ZcQa3ZXAVS657yd/K
	oN6MzafovlIpQ+45OmNx0K0Gv+IfbKs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773217156; a=rsa-sha256;
	cv=pass;
	b=Jo42syGazKlU5vWcY5OVSzdQIiMAvBmObUGT09+kbkrEp4mzOgz085xiTSvySSSX17KWv2
	+QoZvgmG4oNCg9YZC+A5dSyXImwqldEyLOFMqz/JQ1WO86FOzsShkJKLmrYNCCuTOQfB/C
	0peuLgVmkRG0qSA8aYbtEVUk/JsBQSI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FROBtXBQ;
	spf=pass (imf19.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773217156; x=1804753156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vb8k9EUnk5kJj2LtvvAOaCQRgisPN85MlLKf/pO85gI=;
  b=FROBtXBQv99BY5uXfgKVRno56KB3Q9tjLqArlM8VHSzx564PYS/vHQs8
   A7eEHomrR0gKDA67msIRbpw/QJa/3W5evZ/MdiP3komkxK2NfnXrH7LVf
   qABWpGNWotosCgDVfCDN6N86JtxTaG8J+GYrTreabgRCsf7lSdqLYZPCy
   23yvgEXWAJom3SSjBleEpfAQlodKu4o5TB4NfsqJqgFNZNTSxl2HANaJY
   dv2juTvsEpYHuTYsb8zWSlpDszqkjeCLA1ZyE2BJtYLTMLFjxRBnZUDRZ
   Mv3v5PwBLBYJ8RImoeZcQMb+QO2mfbfDWADbwQgOjiplMtuyqqoMWNgSH
   A==;
X-CSE-ConnectionGUID: YBMbGAVbSr2ZvFrobShLHg==
X-CSE-MsgGUID: zcX039giSxGpp9KoMjAEKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="78164843"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="78164843"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 01:19:13 -0700
X-CSE-ConnectionGUID: 0G/JU1hJQDO4CX97TaJrVA==
X-CSE-MsgGUID: 7FfCmmmvT/izw51Ty9X2lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="225346316"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 01:19:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 01:19:12 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 01:19:12 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.22) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 01:19:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4t3UpqGV4Iwt1Cg6SX9sEYFE2m/da3cKxX1afn4MUvi6yj9zT4pthCq9A004dIzW7bXS98TU+4axPGJTAwGmaY4N+rIysvulbxBCWvABnjSe2slga6kxxoUrNS2SrwEb3m72CFNJrcnea8IwcAnV2fNBnVp+qQiIqggtQxb12siFmvcMMNQiQ/amYzFg0jAmYSdgAJQ+skniHyl9D5Cqd5q3+NuM1nWRLNYV3+y5+VCCRYlUYIStZFepSpxeyPs41EHIwIt1vDy5IeBXEiCTNxJFvoavqlmZWmUEVv2c8mw1/Y/AK/xOfvnTAbGkRRK4mxSnbdM8rkcHEzBqL8uqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb8k9EUnk5kJj2LtvvAOaCQRgisPN85MlLKf/pO85gI=;
 b=EiUDl672fvZA+ijYyaPTCjPwCEpLVplqSI4cfOec7Ynh7DU2D4qpjt0i0z23WnYoDvTJQctct/WQka/5QESAAZNzsS6Xs7eWWanjQegd5OMJJHYOXP+7iSea7FgOCC5gb/aTcR1EKawbkJ4kSdCGsG2h9POGEZyqLyqzBCuM9FavPV0Dd9MeP2JP/jXaJ6uo+S9AQL/5zKzlmIL0Te6Kn8TcKQD52+fBTb9lcUvFHL43STQ0rxNQ/FMHlW+R8Z738/lbQsDmYnFJTo42pYkPGtx+qlkbTdQ8UoDbCsmeR8hKVcgCEALh1m6n7GH8z/HcjPI3HsUO1QXiriKSC/Cdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by LV8PR11MB8510.namprd11.prod.outlook.com (2603:10b6:408:1e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 08:19:03 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 08:19:03 +0000
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
CC: Jan Kara <jack@suse.com>
Subject: RE: [Intel-wired-lan] [PATCH 12/61] quota: Prefer IS_ERR_OR_NULL over
 manual NULL check
Thread-Topic: [Intel-wired-lan] [PATCH 12/61] quota: Prefer IS_ERR_OR_NULL
 over manual NULL check
Thread-Index: AQHcsKKaOR7G0NDKQEmlo1IiQUHj5rWo/h3w
Date: Wed, 11 Mar 2026 08:19:03 +0000
Message-ID: <IA3PR11MB8986DFF52256F69D2D8813AAE547A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|LV8PR11MB8510:EE_
x-ms-office365-filtering-correlation-id: 45170395-41f3-4f6e-eee8-08de7f46db56
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021|921020|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: uDlo72zsfG7E7OegXYkgviuwxoEgXaQcvEoAJg6j4/rltsamRh/Qn9VNeTSSeHInq0aq0fsq4v/Bdcg7Bu9fowjf7kVfGkmRO4sHgo6UoLAucxJE5mV1UPNNekdUC8c14BHka0ajN4E62VBuw8ezPo6Szn1KmPPoCHszFNbnFKt73DcPuLI1+5CzzWdpgYMbhYzughjIDAdGd5KaDrao2XCGz4Y7vlp4pPkxhGSgBcWd8od5s+H0FtaAvLLkNLcxHrrNOJw7W3cr4+lGQ4TYN+96OzlDiZ98/4xKM3zQxVUr2YXyQnyaw2/LKg6lIZBu/bWHL1GmeV0gkPoWjYtsvSf8c8B6B50GnO0Q/HxfYmkH42E+A5vQGURNRR0syUZ+5vE42aTiX2VQSvEJp2bX8V/VCBR492SZ/RQAB/B86gzbVjpJhp/UCY+d7MAlBeNz3Vhaz2DbUsQxbpdQJTlcjBFUadmDgWef08tW5Dn28lL+u3v9HxgXk6FrNIqU/uuxb2gNMow5kq/4A3yV841iZVQanjpdLzZE15xBEFpzoOnLaSUsbEc9vap5CVUMr3oJKfVh6txp+I/91pdubcTMhiM9H3SoxgEyDUY0a5gKuil0QqoD2+8xDTkcc0lhWGn8p2QfT7dFHBEqprQZJl5C3GACzzX2bzH68IsnSQ/ZwxfznEaGV+bglhaLusO13upuwd3VwYC311TO4BYUFl6nKdo/Xr579B2L/I6b8Oh+5SKiokkchULV9lvfi4xnS7hLMk97rjgDRIKbAYsYJjOEn/YP6hTF/tCJfk2+qJeQ21XLP4lDmom5BfybqRJ1Uelu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2xncWZUZTJZaUQ5SDZWeEtDZlMzcVc3SDZsSThjMUJSYjQrV3JWU0ZqS2Fx?=
 =?utf-8?B?czNKVzhscERCS2VEUzFhVW5BbEk4bjRZeUd1ekdmekFlTSs2bXNFSUh6T2FG?=
 =?utf-8?B?cXUwZlJGdTQyVUhPUmI0emsycHB1d3FuUTdRWC9GbGdNR1RpRVZIZXVUa1FR?=
 =?utf-8?B?YU8zRVcrUndtNG0zWEFCQTRNdldGQ1RSbjQ0d2txZHNuZDVmYVVhQko1dm92?=
 =?utf-8?B?OERFTmh5SkpLdWVIenNSV201YkRndWlWZ0FvMW5xWHI5eEFLNEdydkRlTTFT?=
 =?utf-8?B?R2VLR3FIV0xEOUhQUDZJeStlRmxSU3doZEV5NTZtbS9DWHhIQkt2ZzZsY2dn?=
 =?utf-8?B?M254RnZTbXZSV2piN04wRTF6L21oWmJya1l0d1hjUjlOdEtXcGdpZE9Zelhy?=
 =?utf-8?B?dVJxWmlvV1h0TVcwMDJwd3VkdGRKdWJSdXdFakQwZ2hGMUFuWEp2Y3ZLSG1m?=
 =?utf-8?B?Sk52TkRZKytpbm1VYTg3K2c0eUZ1ZXZUSXZJaFg0ZksrK0hYZm5TMVl4Zkd6?=
 =?utf-8?B?Yk9ta2ZqUVZkSUlFVFlCNDVtVDJwbmNIdVdkbXlRWGZ2eW1LQlBWMlNJdEdj?=
 =?utf-8?B?bU4yUjdIODFPNFZJVkZzYitwSkFPZVM5UDIvWmhHbk4wUmRNckE1TDJKeHZS?=
 =?utf-8?B?aGh1Y3cxUWF2S1phOFFPQXptTzlNblB5dytGMHpCdStmcDM4R2k0bVVISDY2?=
 =?utf-8?B?aTVJRlZYdDlBcXpSdm40NHZGUHFPMDZkYTU0dTRUcmNidzR5TjFxS0FOSDdF?=
 =?utf-8?B?dmVEcmRXQ21LSDd4STd6WVhLNC9UNzVVTG9PbTNONHFZVUlSWUFvRmsrcVcr?=
 =?utf-8?B?U0F2cXVsUFBWSUhSb2M3ZUtCU3lxZTFjekpEU2k3c1ZkdWV6WXBLU3plc2tH?=
 =?utf-8?B?U2hGa0VTanpGcDBNbDJBOFhOQlRCR05BRmJYMm9lZUdScXU4a3Rxa1kycVV1?=
 =?utf-8?B?YTlpN2QreHdNYjR0Q04xQ1d0ZEtIeHZKenBQazhvY1V3a1VJeElKSmhRR1V4?=
 =?utf-8?B?bjJBRkxXVDIzT3gwYVl3eVNiYTVwcFllTzN2WGRSaDlVdzAvdE91NUphUVRz?=
 =?utf-8?B?aVZaODlUcElwNzU2Rk5PZVEvbkhWbDhhK2pxd3dvMXNxeUNrM0tZUmxGaC9Y?=
 =?utf-8?B?WVBzWVg0VUlyTGEwVWZjYnhGYk1sZUoxZG1PWWh0ekw4dkJROE83Zzd3Q0FC?=
 =?utf-8?B?NHV2R0UvdS96a1R4Y1JadEFab0d4ZldRbnQzR2xqa08rQUc4UWZtVXlrRUxM?=
 =?utf-8?B?MXVyWFJOVG1Ha01mSXpiNG5NeG5weUpGVDRqV3ZuOVF1YlVWMUJycnhMbU5Y?=
 =?utf-8?B?TTZrVG5RZTZNT3QzZUkzYU1QK1F2VUE1ZUZVWWlwd085QWdQcFQ1cVA1WVFI?=
 =?utf-8?B?b1cyWk9QZzhWaHZkWDlnNUZ0cERKL2F4cFVyN2R0MVFjN25XMkdGVUFiTEd5?=
 =?utf-8?B?eGRwaDlGUWxZaHhtNVhGQUFOOXNRdTcyZ2NFTVdIM2JYYUhOTlZ0ajlsS1Jh?=
 =?utf-8?B?YjFEZERQNDAvWEpGZ1RxUmgvYjZFaHdLcGdZSTl3RCt1ZFpycWNjL2NyYUIv?=
 =?utf-8?B?Q3JxUGdrOFhGM0xpNkpGYXBOd2ZNWGdaYnpaRnpPMmhQYWZyZ2tOdTVYSk9l?=
 =?utf-8?B?ZTMzNCtQMFo4dmFTd3QwSXhqZzdiRjZGLzZOSFNmTGoxZkFpcXlFY1dBUDUw?=
 =?utf-8?B?V2JkaDBkV1FXZG1WNUJZcCtIWDYxTVpjcmFrMmtDR3RmT0t0QjkySDRzUUU0?=
 =?utf-8?B?d3BzSEZCOGNDY29RaVNrSWZ6cnpiV29Kamw3ZmQ1c0VhOFY3V0paWDRaelVv?=
 =?utf-8?B?d1E3RFJHbmNJdG1uNmptTC9kNmRpQloxaDNvd25DVC9mays2MDlMSEwxbG5z?=
 =?utf-8?B?UGZBQVoweFhSK3BVUzVVTmJQRnBIdFlEUEI1Rkl3S0ZDUUwvdzZlY2NRTTZG?=
 =?utf-8?B?anJTVEtZd3B1S29rU1dnRU1CRlhTaEtuUmhzeHM2alQ2NFo1cklTSU0yaDB3?=
 =?utf-8?B?Z1YwUlRnOU4zcnJEZkVQZmFKTzZWYkEwaFNsZGFhZXNHdFlsUHhHZ2xkOFAr?=
 =?utf-8?B?N2xVVjdNaGlwdDJ1ZG5YK0xjdGp4N0dERk5laVBKQndMSm91Snd3MSthVm9j?=
 =?utf-8?B?a1BlcTlYR2cyZ05zdWRtbGRteXl5T3JpSUQ2eHhub0JFeGd5dGNmeTB3bTIr?=
 =?utf-8?B?ZGJFTDh4SzV0NFVSSXhvdXVlKzBKc0haSXMwQnhFKzg1SWNYdGhtSXQvaVlL?=
 =?utf-8?B?N2t1bFNyYThOWWVySmZFRWVVdHRQT25KZWtMcHBOUHRvQ29kUjIwaHdjUWgv?=
 =?utf-8?B?ZjBlQ25mMVhRZG1CcGlrOWVQMU9uTThtTUhJNElGN1FXazRlUy9TbUVwMVRw?=
 =?utf-8?Q?7E/cpfHei4SBWdR4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Ch+ochnprmtl2q9ovwqRCZrVKKPwM03tyxbmujYFXAOT4AvuwA9ANdyDEY1HYq6IS0CBOXih0ogi6kACQR5W6FOpUALMb1OgLPFZSt7TP7Zhrw7oa9Enw/9mMlwsHJG+Pm3TxuDNvdJyQO8kQOVniBOcvmswGUA/ghhpct1Qc942Npgeam/uTxbvHzh0RlgJgnbg0BOQC/40OOrTRkwjrKD0Zx07MQljFPxynL49qHtwlJhex01xgxSeN3yRDQ93lb8sXyrrmWc84Hn2r6LcA0e8KmOYPSzhVMI7T+UZ3AilKzyF9I4T3COOKVRZjIH/UnbR9RG+DtSLbXhPRtKf5A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45170395-41f3-4f6e-eee8-08de7f46db56
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2026 08:19:03.7196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5RHPwGkuHaFJ/hqNzAtwi022X2mgyphxIgJ+1aWEloOatEVlDDLjsHcJbFCqfAMKzQX0FZ0cacMjTK6ge16Cprkp4plz4B+kggP05WubqN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8510
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D23DA1A0015
X-Stat-Signature: b34bg53qgkhdph4yk43k3sgup9zwrwn9
X-HE-Tag: 1773217155-359834
X-HE-Meta: U2FsdGVkX18nbb80xtlwFJaCTX9PhBuZVG48nEJRTCPQjALdZqoICoMCBtCE/qVCBMxUflfzBACMZYoBLoTqilOSdGchAq5Ag8hn7W0MuuJ702lPJ05S8H/q97lhGSVskghwly/CrFyrZPgWup8M0hE4WyoA2EunyEVFe06S4Sg/P0P6/ZUaemaehQtdc9LngdXiFqG3TDC2V/CMKjK22gnbbWEwEPqdLjlAUw7ZHb03gHPsQwq+2pnrrLuuwnT3kSDPe/1me4yhEqv2Q30Tgv44ZIrw9YLlKuDw79DFy0eHnFdTvTghH+ekDW8WtvqPGMKRg6Qsq/7GpJPdZf5s/u2tc8PKyc4A4ztls+GmoIx9JOE/MbYinQLUc7eba65/S3H8G2rtQCQvf3MpZeY0qMz+pS3zyu3zJqDw96Gx4REn9jM15KQDZMwX09+IVcF7aX49DnbsSrtssYQI6AWmtmetLp1h2KAaUYWZG56YofVwpYOKKClTrK8+rmE8x+q74RerVW4Sm3TDLqc4ePKgZXOJi3dqwb+a86njIN0duzwAkzS27BgwQqEIZMF6sDrvXTk3HLrfQ5QaO1ICwdboUiT4ceKtuwhOqU3UWx4+/acBWAA8CX0QXOP5EheM0tOQNv9RFQa/WeGRXsbvf5W72cJRIviJtaIbFro2YtLWPEZfQdYr6hzNyXiGKRfno9D9zKwdA00kF/WNGMRHxxjpelOSWVegqujS4/BVFt0Axa2qWnTM9Dw7BPYOTSg9qogT6HmKQ8fKOjnu5KK87o/1tdhJ74fISLLIdzCI+PviML0AX8bGhTFXcHmp+S5r8khGvnLzlHQwezY5T6lVBAvoiR6JIRkK9FgWRcS23UAegZmf55bY6DIvZJE8t9WXwrvOlu1dGcN55ifoK3ooBcWw5CYoE7YPmAhtNbIJCA13voGg+o0s1xAZ4n0OUsCS1KYRhBS/iNyEg9cKVqFcZGG
 ZWnaeyBg
 4Dcr1tBQ9k7Ch+Poyd7k6/cakJF4f/tOcljYlKMkd66rFNPE6+5W0V2wchU4zlnI5HaNFiYfIyrl6i/HQaBYAYL0sq1z+Hm+R6FiqNrkicwzs509Y0YB3y/R05Mobr6jsXQoBd2iFeCJVD5YZqGHXX7nPKf2SGp/fHKCwJbBaIohnsFUubjBmG+Lj+DupJq1i8aB6qdGSYUdfd5c/2CNlCytbEHUmVrpOfiifQnmz3KYe9mVtMQyOdht5qSRyl6oqxb4zESWVu1gLE5IOka0KCyn6hVbQexCrV/szmgqgc56J4KdFblcVgVqMXk8rxVJR8gpuurZT9Y1elnbPkz9DVJbMzFoA5ABvL3509HWLfpnlMM+h06PHzveKzDFCGHx0IB3dwWrwfsMViWI6TRkQfRIFwg2uf9mENHCLBr95/p1ANWZ+0cu5SSM8+pWSEJdTKZ6KGB27xxxhlvr6I8fUAaqMSkkk62ybfjc9bQa8FC7NpOgDHB4gIshd3dY4MWeUprhjMASAKaqOk/KyRj7D7CC4zwQIWJ/TNLXNb26afhABNccL2e6zQRZrm36fk0sNPqd4q3esdiON3743vhvtTPx9hxtXctMzLCSS82ljUbUCAtUYVTAcPRYmqGiLNF+d43+yCQHDIkqy/DM1UTlPGBc0Ay3ECivOMZr4xtUtD/wTF+8Hs1DGN4o67LwABgC2ipFZQ2FiaonPd1s+lKHlG0MsgHt8/R/rkFcWhivLabMNuKqR2udWb8Vttk5HuTn2vngrPGVEbzBdCUeBlbbBPgOgREYVWVeXhWHBv0bbwshRiT0ld8iBEqZRFxvro774SWZKbDGwIwn0qcI6xKkqurIV6vRTDeDpU1CKBj/11kXHbtofHkOg+/isaQ83IxR1C10pzVFwpzIFSuZSmewKuPWWNkIztNp3MLRVxmo342dWNVJWKbhzn7JJoleq9D7kCE4lTa5pmcR8lvjQ1eVa3pt/XyE/
 CTc4xKwd
 S6N0oGi0/ZJmymU4ySo77BBUGos08QLn2ZRSNibI1jowlan5nMavGIJF47Xw/sDWxhwAFiSFKpe9Wf3flxSjdMDVMnjIu8xYqcOv8huZiGFXEw2fXSNgwCjKFw7FRFFRwtOFOhSC9PdRXdFTrrirZgcLroZqj5dOf38SSAdys4tWkss0BRdGr5GAY7O71bhVveD5sYcH/sS9WJ4yaFdecd+mdf47eBpLlVumUw5S18Yf2YjJXDITCA==
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
bS5kZT4NCj4gQ2M6IEphbiBLYXJhIDxqYWNrQHN1c2UuY29tPg0KPiBTdWJqZWN0OiBbSW50ZWwt
d2lyZWQtbGFuXSBbUEFUQ0ggMTIvNjFdIHF1b3RhOiBQcmVmZXIgSVNfRVJSX09SX05VTEwNCj4g
b3ZlciBtYW51YWwgTlVMTCBjaGVjaw0KPiANCj4gUHJlZmVyIHVzaW5nIElTX0VSUl9PUl9OVUxM
KCkgb3ZlciB1c2luZyBJU19FUlIoKSBhbmQgYSBtYW51YWwgTlVMTA0KPiBjaGVjay4NCj4gDQo+
IENoYW5nZSBnZW5lcmF0ZWQgd2l0aCBjb2NjaW5lbGxlLg0KPiANCj4gVG86IEphbiBLYXJhIDxq
YWNrQHN1c2UuY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTaWdu
ZWQtb2ZmLWJ5OiBQaGlsaXBwIEhhaG4gPHBoYWhuLW9zc0Bhdm0uZGU+DQo+IC0tLQ0KPiAgZnMv
cXVvdGEvcXVvdGEuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3F1b3RhL3F1b3RhLmMgYi9mcy9x
dW90YS9xdW90YS5jIGluZGV4DQo+IDMzYmFjZDcwNzU4MDA3MTI5ZTAzNzViYWI0NGQ3NDMxMTk1
ZWM0NDEuLjJlMDlmYzI0N2QwY2Y0NWI5ZTgzYTRmOGEwYmUNCj4gN2VhNjk0YzhjMmExIDEwMDY0
NA0KPiAtLS0gYS9mcy9xdW90YS9xdW90YS5jDQo+ICsrKyBiL2ZzL3F1b3RhL3F1b3RhLmMNCj4g
QEAgLTk2NSw3ICs5NjUsNyBAQCBTWVNDQUxMX0RFRklORTQocXVvdGFjdGwsIHVuc2lnbmVkIGlu
dCwgY21kLCBjb25zdA0KPiBjaGFyIF9fdXNlciAqLCBzcGVjaWFsLA0KPiAgCWVsc2UNCj4gIAkJ
ZHJvcF9zdXBlcl9leGNsdXNpdmUoc2IpOw0KPiAgb3V0Og0KPiAtCWlmIChwYXRocCAmJiAhSVNf
RVJSKHBhdGhwKSkNCj4gKwlpZiAoIUlTX0VSUl9PUl9OVUxMKHBhdGhwKSkNCj4gIAkJcGF0aF9w
dXQocGF0aHApOw0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiAtLQ0KPiAyLjQzLjANCg0K
UmV2aWV3ZWQtYnk6IEFsZWtzYW5kciBMb2t0aW9ub3YgPGFsZWtzYW5kci5sb2t0aW9ub3ZAaW50
ZWwuY29tPg0K


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E843104950E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78C16B008C; Wed, 11 Mar 2026 05:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CA86B0095; Wed, 11 Mar 2026 05:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD196B0096; Wed, 11 Mar 2026 05:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F54F6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:26:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1159AB986A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:26:47 +0000 (UTC)
X-FDA: 84533252454.18.C3CB977
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42154140007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:26:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QcwRVuv9;
	spf=pass (imf26.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4nrxJrptq9qjGF+s6HBpmfa9vqvfEDymQUIf7o+O44=;
	b=eqgMkKOMyd0nhXftLiDB6eeQlK0YtUkbcxDAoxGtEx4fBMnEuZVUSIPQwT2XrradOgcM+e
	Y6olEyP7OyBKoxPkwyoDyIQ/U3Uu/UeVVTnO+J9M7+UDJe1kxRfg5tz7luai9IIoX/inUQ
	CTPDvf3LCGPJK2xvP/rnS6YhpBismLY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773221203; a=rsa-sha256;
	cv=fail;
	b=7fwR7D7068HdUk+5uoyT2GP22uiD73KrP9M7Y6mPaO0LwRZ3/HvY7UKhjXAym5G2xafVEe
	+ITa5hDbSHMDXl6Gjpm2Ixv0uvVQIlwTU2JHHJKH3euPNFr+ed/dnYbJ8cbbNW345H+HaT
	K0hGqkht3JKZ4h7W5Jr17/4QapmFiZI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QcwRVuv9;
	spf=pass (imf26.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773221204; x=1804757204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m4nrxJrptq9qjGF+s6HBpmfa9vqvfEDymQUIf7o+O44=;
  b=QcwRVuv9wkSCB0AdIVlGsH1iFHZ1beskAPcSI7t2kj44XJIvDlWDiPGX
   lUZhFO8rqFiFzMv3gfIj/f/XDLFQipZb+YMOdSh4HG6vETl21War9N0S0
   11KWs+5qX34NcH1ubZl1vyu54VNW2y5TFX8G4WcCJWoZCCOxyuz4q81DZ
   lhfQfKcoYUoAHkqD/7dcdjY4IkaqiLxDHWliMpIBBFeARB7Ld/1vS1A1p
   K+4/BkVgripyN3LpONLXKGTrSmcAKKc2ls+B+MQsUFgBIg8dNmLUoBu3W
   iPmwQeWVK93eH6eL40UrVIJiXTqgjKBCnTSH0OdhkEH+SfkGtvTR7sI6u
   g==;
X-CSE-ConnectionGUID: EJqi/FHGSNK0P7e5mQS+MA==
X-CSE-MsgGUID: V+jLBjgcQgqkdkCLMd3pcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85760877"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85760877"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:26:42 -0700
X-CSE-ConnectionGUID: 0Mvc00UjTyaR49tMurlA5w==
X-CSE-MsgGUID: 6g3dkHLDRdOJkiETBGMAMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="225103701"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:26:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:26:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 02:26:40 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.2) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIUmwbqBuCkYAHr/gwuMT/vbVyoJqHWc0S7qGkZSE95vriQ1cF1TkGN+a1PULfHbuDyi5DzAqAQ/PNHLIftR7JWBOHqHHT+jY93nxY5ZTaryKln3OoABQnwzl4ngeCG392k2OZCcRE+72NiuMFZgNGV9NuZjzzgtAKJSUl8jY6DJFEy1qNBSO6tQzZgbmelQ97j6UITzZy/WF4mr3LqAeRRhIoK91Gf/AWW++ljiOXiNYHRS0xvC/qW3hLE7seWkIxqqC0ez1Gs6saFyjGmdUV0qDNucOah0DJC0PY+O1yBivIsQu9Rd0Je4acivVundufd1+gxOD6g6HHhdSMq7zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4nrxJrptq9qjGF+s6HBpmfa9vqvfEDymQUIf7o+O44=;
 b=aBxZmB6sbegqcdGoKmtlZAOcsGRPJoNprfagE+h604gJAqAH4K6+KucWi6/tq0TarS5X5ug6WwI+Si+VnXJZGApS0Hp/He0BJm3O4i23WnRjIVWfT9fxBljBNaC9feFMVULojEpaixsil7zHJjzk/0Ei5rAY1WtxxlD9gS77inUNlktnOneLWplQNQV5pzR1G/7mz7TJdxJYLzt+Mj/x0RU8p5JaYh9hVbgYF9ieJV6cDINYiTVfqLAr/y19QYfhTWGVROS2hV99XVvqL7Clf7EilkoyJs2OW80ipPvFVFHkn71YZyTAVFDtCuAtCu+i3Ictw5nF52YGMajqU7oSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by PH7PR11MB6836.namprd11.prod.outlook.com (2603:10b6:510:1ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.3; Wed, 11 Mar
 2026 09:26:37 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 09:26:37 +0000
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
CC: Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>
Subject: RE: [Intel-wired-lan] [PATCH 54/61] aoe: Prefer IS_ERR_OR_NULL over
 manual NULL check
Thread-Topic: [Intel-wired-lan] [PATCH 54/61] aoe: Prefer IS_ERR_OR_NULL over
 manual NULL check
Thread-Index: AQHcsKKXHKPQgNOZaE+8HrFfa/02l7WpEP8g
Date: Wed, 11 Mar 2026 09:26:37 +0000
Message-ID: <IA3PR11MB898643D5101D44C2BF0A8D7AE547A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-54-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-54-bd63b656022d@avm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|PH7PR11MB6836:EE_
x-ms-office365-filtering-correlation-id: 3b137b1f-021b-47d3-320e-08de7f504b55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: o9Bm9SPj2ErETACCCJiV1KvRnwRIZWxKp+r2VpCYTLVSrVoOXKHBBMTgWhVUDs2sANIccdbYTu+T62K218GKzN/aip0x72lnux++4JYJqlvh/+DLcxp1aRL+nnl8drAmndk+uoEKXHbjsrmbxKSpxxtM0yAgWpm+ZH5fdEYrQDmjD+U4clF8ZOIY5tdrP8KIkZKPgKHDF2WIQQw3kM6Neq/s19XJeWxmLprxLY7WEQtHIOBisCCjbPmMtmC0XeWKtE2QvujQvu1eudnbidCG6Owrkwkt7IMubEScD7/tiO4a6J8CaXb0tAJspoNXvqrDgBUuAlK6Zij7190dQ21EDY6HvvYrMZdBFum7HkCJ9c9euTvZsC4ESkWBnQwF4/dMWbNVJfHpB8DflELVEpkeDQ3x8Owrq/PTdR3oVwE/JTiZsKFpMvcfjloKUoUgBGjl7cK2eIKjQt6wm7RK6bMDB/1ajwKu+THF+Tg7TIUaB4p7dgM/iryDIosZN5plS1kAqVRyOkEiLAsO6f8ZbiVin+ueU3v211dxC7q+ylCyK3oioWwnNTn0243NE68MUoYZWMHZ5epFt6wq4t7JkSduO6Do/5LSsY9ynWsZnf5QwMmxXVPHYAa35TzmlVv/VQNApQGohJL/bIxrZD1Yl5/NbczocEPnIKZvTZsiZ0x0q0VZUEhP0bHuYPfQD0hUytJsjfviNaEYaOdc2HXjOuGQN4ezE9KU9/LVQB7y+Fu6Rvw+ygYyNvS5uRaazOasfnSyLhp3xd9l9KeyWCukEDFSJ5ns4y3fpZSU1j74TOlT+U4sj+sWuJNFh3Tl8Qe+8c16
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmFhZFRwZVJNNEZKWmhMbFo0K2FpUGZKZjZBa0M1RUJDemJkaitZUUlsWVNG?=
 =?utf-8?B?S2Z2VC9yVHNXcHkxeTdpMGk5OHZLbU1FQys1M0FUOXhkaFVVbWFXZ1doMHlI?=
 =?utf-8?B?SHlqWktRTnBBdzJkZVQ2R21OZ29iNk9mN3pMVjRaZStuZWY0TE53VmZ4Y3A4?=
 =?utf-8?B?TEJ1N09FbFp2WllBZUcrOEVSSHdVN1FQZHQxVkREdnpxVEFMTTVMWmx6c2RC?=
 =?utf-8?B?dWlpNlZwRVRORlh6aGpUSUlnNGsvWGhmWGJDUzZLbUM4ZXpjQ2R4b1NTTlJj?=
 =?utf-8?B?VDNQdWt3THNiZFlYN1AwYS82S2dtRWFhb1BpZUZqZlhydDFab2VINm8rSTM2?=
 =?utf-8?B?djF0MlBqL0x6R0xJbEFoeWlIVG90WjV5VVBtU21oSnE5WjROQ2dyVlFvallu?=
 =?utf-8?B?YngxK09vMFdibjA3T00yaXJuOW5qMTBrRElDQmRJVWdWVytQOEh4a2dLVXZT?=
 =?utf-8?B?NzRISHd2bkZiQnp4N2pUVjRKS0tVSThxeEhPWU1keE5GQTJRZmlLcVl3Vm1x?=
 =?utf-8?B?aGo0R3dpeGo5Z29rNFhsZ1Y2OVdqWTNBYXFpcTh5K2lGZGtqM2pWclViUmEy?=
 =?utf-8?B?RlRZcXI1aFhlY2FIWCt5aFFGU0VQbXM4RmVvYkw5amp3VFlEdlI4WWRRTXdy?=
 =?utf-8?B?VlRrQ2ptWU9Ka2Nrd0xpUHlnR01VQ3cvQ2Q1ZjBhOS8xeENJaUw2R2ZTUzlu?=
 =?utf-8?B?cXlsRDVDL0tUZURUbDA1MnJsT0NYUUc0UUVpTTVSem9QSUpWeXJveHZNUG90?=
 =?utf-8?B?OWsxbEw3ZGJVbFYydUtDUGt4ZE5NZWpBbHFQNnF0RzNLSTdHYmNMQm1UUjJE?=
 =?utf-8?B?Zm14WFRlOVI2V0UyT2NLdnJURmdsNzJtTGt0T3pYOHdCVXo3VjRuTVJEOGpl?=
 =?utf-8?B?a3IwU1U2RXE0SG4vWG1RdmRwZnhFbzZUV0dLRXloQjUwSVJsZzNVam92T05L?=
 =?utf-8?B?ajE0amhwN2hnTzQ4MGRmVWxPcnN4b2ZKUjlTZSs5Y1RHdFovQm04V1ZiRkps?=
 =?utf-8?B?TmxDZXo1bmp0bjNsU25ZZjVwMWpSdS9lWjFtQ3dpQm1jcWJaVG1XV24yOUx5?=
 =?utf-8?B?V3ZxTmtDVVE4RVpyYjR0VngreGp3NUpmOWpFcHpmMnhkWGtCSnE2VUpYMmRp?=
 =?utf-8?B?Y3hGc0c1MkdhUXpIbzhQYTFjaEFNYy9MTzFqb00wbzlNN1JBZzNIMnVKZDZJ?=
 =?utf-8?B?WWhObjJtOU1hT2crV2dGU3U1UFl2K1dlTkpBZW15V1doSUU2bW9tK0NWV01C?=
 =?utf-8?B?N0pGTktIWWxuVjloQnRKdmFuekJxcGsyb3VrU1FINTduVC9IbllqSlNocVZN?=
 =?utf-8?B?eGZQWTdZNGdxelg0UFJSdi9LRjJ3ek9BVm1pem5VREtlMXB2QWQvQXJjRFYv?=
 =?utf-8?B?Y3VqR0VlR1JHeDNBY2NVSHJJUzVyOGZxU0VFbW9LMEF4UHJ3V2pnamRlblpv?=
 =?utf-8?B?VnBkcEdBcDRFeTBIc3hkaUg1ZFdORjdsTXh5SjFsckdibEF5eGtueXVHcW5r?=
 =?utf-8?B?NU5TT3BJL01rVTU3cXMwdmxRN3E2QU9KQjkwMHRFaURCRlR6cVV3N3puZ1o0?=
 =?utf-8?B?R1dKd0FmYjRHVitKMUMrNjY4N2RuTkRuamoxcGtCWUJCMmZkQkovODZZeWxk?=
 =?utf-8?B?WkZtRURoT3NYRDVFcEMzNEp1anIzcUdyWVV0UllXR2NYcXU2SWZvTkNKeVUw?=
 =?utf-8?B?Y2NuNkdhalN4eWEvVFFRS1RzUnIzTDdMM1BRMDZQdXNuRHFmd0I1YUF6OVd1?=
 =?utf-8?B?b0czL0hrMnRwNjg2K1cxL0RwZmozV1lCZUxxWnJJbjdzd2xiTDZiR3M4ZUk0?=
 =?utf-8?B?RkFFV25lZHN2S0JjVXpTbXBjeE0yeVZQN0o4RW5ncXhxcHR1blVWYjhQdTRo?=
 =?utf-8?B?aTgwWTE4aWI5MnRFUlJiYjZDU2U1YWpVdFR4ci9yOUJGMVB6MXMxSGp5dDkz?=
 =?utf-8?B?cERDamNzcS9adzh3WUJ2VGI5cmV4cW9Ma3kwZitISjhwRk93KzdBMWFWVEs1?=
 =?utf-8?B?MnBmdEpxUHNUaGRqVit4YVZvNFFVa20zNEJUVUFuT25IOUllWkhoREZOM1Ny?=
 =?utf-8?B?WEFEL0Q1c1lka0RFZmJVRFpJWjlENzM0N25Nek0xMVlmZ1Iza0Jua2JMWFVX?=
 =?utf-8?B?aXp6NC81UldQNHdLN0lZSXJXRHZob296U3JXb2RMc2grZmI3RmRGR2I0cUh4?=
 =?utf-8?B?MEE4TlpEK05FRzVodEs0bEtua0w5Z0k2ekFSV2ZndTc1YTRJcDUvY1lOSjVy?=
 =?utf-8?B?QVhZUTE0MXdPaXZKWVY1aHh0TEhmV2t2a3VUY3NsdVVkQ3RwazQrVlhRRGJn?=
 =?utf-8?B?enhjSkdsU01ZdHgxWmVQSTR2OGM2c2dQRHlhZkl4SElCZnptQXl6NHo3dCs0?=
 =?utf-8?Q?Yx2xsHvVHigxyfmA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CrOTZb1KRrluE8Hi1qKRD454X4/8qRXPxHi1cqFPQYNvr17f1fATBKuEHUjSG1O0/Hvh6RKs6WeVHUo5EpnlqFyKsFw7LDG/GIpH5YjjRev4xPkZtie/dfZhrv5YkbetTk+MjZ8Asj/daThWAC8Zllg6yxdewJSZ8D4dkiye9+vWa9ukZPFzKvY1+65tMcplIRZvV88n5ehhcwlbn4RZ96lty+38Kp5E+09w1hvWqFY/RAdQprsQK7Zd7WsIAk8a7rlWJL9k8IIDPNrS0kNlcvkQyr9F0pz+zR8rGkj80VM1Nm95YwTUKIV55FRluvP5VKCN51YLe7kXO0zjLjfgrA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b137b1f-021b-47d3-320e-08de7f504b55
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2026 09:26:37.1030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxdWCRDv24cjq1vJ384aXrRsVpA5dEn9LMt6b7ZY4xpRPyA7+lzpYDvdn+c/fLlu4FAozNXPYwAhO263RnUUNdrC+EOY+Cy5UgkT++EsOPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6836
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42154140007
X-Stat-Signature: y47kdzttzjrkbnhwbzmj4guawuxg3u7t
X-HE-Tag: 1773221203-312159
X-HE-Meta: U2FsdGVkX19lOlZjcBqx+Ye/SuCDZJluVhY8dPKIikc+kZWj9mKBtxkcS+xfl511ZwF3xlqJntd1l4eI64w49pWCWG+EyDml3uWImcHbLStdXvMHSLXFGQ9wcyTOVLzrr0m0r7eoHyY0bzB/kG5IqcEB3HvZl3tMMq6F0KN/4a1TmqPPwnEuX6H8jU0U8YNjro0arR51Z9kF9d4wh3VBZRSho+tiyeilDdF2Y9e9T2N8oBFcLuIxBFU3vSTIylHZc5xJrlIxOtMjoUPQzXSri4Gl8XIR9RiUc/4rivMQJyY6Y6+C75KjXsDajzNdgAp+8vzfAQ+pVFqVAR5hp4bUq+XWYjA3S3xJgV0uXt+rieX+k7e3ZNYCnSP+7ez6OSO6an52ecT6S73tRtNl/9prdITk6KP/Lnhsc9D8cvZ9TEURn170V3XG0dHtxbQZJB3uXsTseRaqx04m7gWunhl1E1u0zo3TfI4GTsOV8PX/gMKR2akC1/SXpiWrgWiGFODFl2cUfRy2nTVsOSIHEXLi1XHR06f/RKchlSn5kdShWUSa8k7K/obsgIApy/4ZczuEGZOj5oFBIZ2b1RAlclsu7wBjaC6CcFpa4jWkZTSYOacXSoocsADNCjfEeNW+SMQJVm8gmxEZvufbAICR+E7fSMKvTqORUu2QWOw3y98S0+zek8JJ/H69KZxcxdyM4BVaZMug/z+B+V2ShcXZUAxlRtz6KrObEWRz2YCHEzEXZ9P4Yeq7/jt+wrsUbQ/Yt1XLlZkKLVAMRkBfI0/ksxm/TqhzOeV5o8OmW4nXLdz7lo+gg8Mj2p1GMf7DWf/bozPqoxNxbtjIafGV1M8wEgjkEaePV/FVRwQv3EfBdjMetTNb0S5F8949vwCxG/AXjgKlx+XWvILb2UEWxizLsHP3DuPR4Qit2Ma9fZmymNl3nl83wHzrrqiEqGavExLIsf51vpoRlkPiP769+l6bOW7
 GNNmv6Ar
 6829n3B5yliCWfHkRfzhmR3QtyKA5KF7I+UNRhRMWR37uGZK/TDfGFHyiy1fFC+g/uRkQIkKqO2ophWtSR9XBTLYiux+WhkzU6PToQNdM0IrIXaNaf3+wMAHloO1M++CL0IEiOvk7XEIdn7tFpZ+6pS8z9PsAUEfi2Mi+1glwvUqFSfiFJYdkP8L/hKM5ZLiTVC+GLKweywjlIVzvbXTTj6zUOjRFKbyLnBVx3IrDTejM1URjoL6462RGVoQsGm192fSwZwDcigYB4Q0tVZmzMVW0b1Y1ShDoIIH3p+8v5YcILuIyZsgsPHAB84Pyq5X0IfqZ0qCEAOtAX1xdmAMNs+AhjK5O5itczI+K1tsfjtVlhQx+2z3QcIVCK9xjg1qpqWpSMtJZnAShmzAuXFYCkzACq93BK5yZuX3GBy9nQLASQHmC5sYO+0ARtuP1O0r5dgLKJQSVu+HqW+Pe+wAz9IPd6+uFDHjol7PJIjo/on277RQY7WKnH/ek9CA1upc56zeQX2m/plnWCJC0wz/5d+NirUrcxK0kR4Nm2qWbsx9X2+moDTr3o4+E4+Keph6lbBmV8l/RnkDl84Mmu74CNQsw7Lb/pl2eHcisgazOZBdXWvIoA1s4/Po5Ah72c6LR+AIfHUYqARXzwouYeCmZGAM6yR0fEpcujfUS1mNaMfSFYDDzekqvbT7dgAN8bjC+wT1SVkFuCmNJyxBXqNtNqN7QUqM3kA/phYUwMH+SgCg1oI7H8aTj1Ln45rGLseK7kyy+J9zNjZ+EUewonb24DnaLp0PKBvqY9T/rd3qVJpCI6KCrHpBzdjZC82QjBdnUl2r0W3H9W5OHi+wwQml3V281YNiy6VBnIVYQyq97WFDtV85dh7vvFBY/9XjQDhoGtWKzpHwZcKAE7Nzmhe76UZjTFcXCPA3o8NMfM7zLhVhCwPahYQ1Z1a+2t143pomqXQOzFG4SdSkA35BQTpVUaGMAZBAM
 bNR1BaQV
 ctJi67rlveUiM8CioxtnckIRtWloJtrwK7AXyechviYHA0hXJuk/HDvwKUCSi3HFouiSo9xOmSrLzQn8hzsV47Zo3p6sWUA7LECb0LxNx+0Q4Igt/ueibw3NiO1zCReFgFFQr52cKXyCNkbRvImvoUVuODg96sJKhp89VeFnyZRyhvbFRcnmhse9YhEnz8ba/3LP0+OUOAJTxrOGUdjbS6m74vgRCPExhjbo2o6PDBNlBLF/KCX4aAOBfBtkxrkcwRkv38XC83B3AqwirhFiDw==
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
bS5kZT4NCj4gQ2M6IEp1c3RpbiBTYW5kZXJzIDxqdXN0aW5AY29yYWlkLmNvbT47IEplbnMgQXhi
b2UgPGF4Ym9lQGtlcm5lbC5kaz4NCj4gU3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENI
IDU0LzYxXSBhb2U6IFByZWZlciBJU19FUlJfT1JfTlVMTA0KPiBvdmVyIG1hbnVhbCBOVUxMIGNo
ZWNrDQo+IA0KPiBQcmVmZXIgdXNpbmcgSVNfRVJSX09SX05VTEwoKSBvdmVyIHVzaW5nIElTX0VS
UigpIGFuZCBhIG1hbnVhbCBOVUxMDQo+IGNoZWNrLg0KPiANCj4gQ2hhbmdlIGdlbmVyYXRlZCB3
aXRoIGNvY2NpbmVsbGUuDQo+IA0KPiBUbzogSnVzdGluIFNhbmRlcnMgPGp1c3RpbkBjb3JhaWQu
Y29tPg0KPiBUbzogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPg0KPiBDYzogbGludXgtYmxv
Y2tAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHAgSGFobiA8cGhhaG4tb3NzQGF2bS5kZT4NCj4gLS0tDQo+
ICBkcml2ZXJzL2Jsb2NrL2FvZS9hb2VjbWQuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
YmxvY2svYW9lL2FvZWNtZC5jIGIvZHJpdmVycy9ibG9jay9hb2UvYW9lY21kLmMNCj4gaW5kZXgN
Cj4gYTQ3NDRhMzBhOGFmNGZmMDUxMTNmMzIzNDAyMWVlYzcyODI2NWI0Zi4uYjMxZTUzOWE2NjQz
M2EwYTVkNmU4MTExN2EzMg0KPiBkMTI3MzVmZmMxYmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
YmxvY2svYW9lL2FvZWNtZC5jDQo+ICsrKyBiL2RyaXZlcnMvYmxvY2svYW9lL2FvZWNtZC5jDQo+
IEBAIC0xMjY4LDcgKzEyNjgsNyBAQCBhb2Vfa3RzdGFydChzdHJ1Y3Qga3RzdGF0ZSAqaykNCj4g
DQo+ICAJaW5pdF9jb21wbGV0aW9uKCZrLT5yZW5kZXopOw0KPiAgCXRhc2sgPSBrdGhyZWFkX3J1
bihrdGhyZWFkLCBrLCAiJXMiLCBrLT5uYW1lKTsNCj4gLQlpZiAodGFzayA9PSBOVUxMIHx8IElT
X0VSUih0YXNrKSkNCj4gKwlpZiAoSVNfRVJSX09SX05VTEwodGFzaykpDQo+ICAJCXJldHVybiAt
RU5PTUVNOw0KPiAgCWstPnRhc2sgPSB0YXNrOw0KPiAgCXdhaXRfZm9yX2NvbXBsZXRpb24oJmst
PnJlbmRleik7IC8qIGFsbG93IGt0aHJlYWQgdG8gc3RhcnQgKi8NCj4gDQo+IC0tDQo+IDIuNDMu
MA0KDQpSZXZpZXdlZC1ieTogQWxla3NhbmRyIExva3Rpb25vdiA8YWxla3NhbmRyLmxva3Rpb25v
dkBpbnRlbC5jb20+DQo=


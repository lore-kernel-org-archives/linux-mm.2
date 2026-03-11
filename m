Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7431049518
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E8D6B008A; Wed, 11 Mar 2026 05:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338496B008C; Wed, 11 Mar 2026 05:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5B46B0092; Wed, 11 Mar 2026 05:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E367D6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:20:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C6C28C261
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:20:03 +0000 (UTC)
X-FDA: 84533235486.13.EA6A8CE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id C142840007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:19:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DYHs6I1V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773220800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VICTIF5oKMXxelvmMzEh0zJq1HLJVA1XI2LRgC7VCcU=;
	b=7TnDgjvF6QHgnnWM4WdbI/a8Pn0nQBgtIrTOR9f18l0CI/F1E77j2cZYUZP+xQ+v4lHjX5
	2Luyv85xolUWP1VZnmt79jaZFcp2Y8ZnIvn3K9JkDkTEUCk+nsvbjLCIUPMl5nTz8Dp0GT
	vxpiIDWoc+ItbzywF7epo5i+USlngZc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773220800; a=rsa-sha256;
	cv=pass;
	b=WMrM5p0YPYxQd2K2q8kTd0uZEWZDlVkuIPDLxigCLiuajEMSI0HX4GG7HtzDJWaHOjJyZs
	czg3TeKIc8qrqvQUg1dOH0+G7yzhIBRzazHMqp9qk7gpkEEDyPtnU+tVxeG7TZTXLxPWRi
	jOLPJxXnJMz5CMKs0jwZDqLOW2BnbOs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DYHs6I1V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773220800; x=1804756800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VICTIF5oKMXxelvmMzEh0zJq1HLJVA1XI2LRgC7VCcU=;
  b=DYHs6I1VLL6TUJITTi0f5Y2TEAjFKDV4rFs+VCPzC93raWSlLsolzMe2
   y4x1uhwjaXGFqyH/0tXKn7Q92SoHCS0/ubtwywEwHKlw6tMtMEZS8HLs1
   4CKimkdFtdmMQB5tD/2E8WDeNPOXsnnmC+goDl6s1Dp+k/XadS0JVex3e
   KWJS8AjKEao2GvAtgKZ+ENGYkDSrWKRa86fmEgeQDphjpXcAZN0E9SIBu
   L9zDpAUq5SD/L09vhYrhzaZcfqHhTYiPLRp4cVK1gZpm7QCrF6BY4piLi
   C/G5DLbU7HSqvRyvycRRGHjoBxbnd3+8yDK6GZfgrqZpRsvPh0X677XCf
   Q==;
X-CSE-ConnectionGUID: aBZt+5cVQbe2E+5+QsaPRw==
X-CSE-MsgGUID: mJWoL4aJR9ShCVAE/Bu63g==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85760417"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85760417"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:19:58 -0700
X-CSE-ConnectionGUID: rDRkcxt4S2OrIy4Cq2KTYQ==
X-CSE-MsgGUID: rJMf+9RKSX6kadZB4KURPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="246008222"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 02:19:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:19:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 02:19:56 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 02:19:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBGG4b7Mdcpvq8z9yjAjPaUvWfs0969wp35Z/SLhR6InEbJEFhaspgNYY88ae+ZdBOsep6jkskWKU85RsuBka9aNuS7ILrocSsI9607DCJrexM9Nzcemy7avRs9dkUQ3WfWXQsQNwAnzHSaUNsSafYBXS0W40gkMZONfhQhaTTTDqWzYitHdN/TEkLiCeNy+idNvXz61VqJaMl3G+NBxXWL8frlhzEYWrL6bgvEL++4KmrfGmcWkzAPM9v7t9PScMaV/jRMmKd49JNsyq6OBncJ1BBh3iiQhjw1tLvKTObiJXiy2p/DWvgtg0KFIKwkiHyD1HXK+2hptWijd0caB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VICTIF5oKMXxelvmMzEh0zJq1HLJVA1XI2LRgC7VCcU=;
 b=xfcbkXZEdYs5HLIJ2+RiuBCXGERHxwTQRaX8mksonk+QjitTrQrNfhKNs6k7ObcV+aQhOS7NWZe/wu6ZqZb6/GGM//v7K5wZC6l8reZEZf71p/KJnMEJOcIdNd8KeiZDUs7QhU04x3Me3t74jznDcB4OREvnvw51oAcPX5RZwMag4sIxX96PhH1W8/9nsYyKE2oPxh1MZZcM/fg8MBl4iVb81ZhXmhGlFZJAGP9qPSWYpRx2Sy0Smi8mWdn+9O0vKYZHVWiHGb5Sr161HNfzgG9TkIIlrE02eddq/HH65rKWWSwgXuLhvNmtj43akkr6ZfmnAgA3Y4Es5JhYrvIV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by CY8PR11MB7897.namprd11.prod.outlook.com (2603:10b6:930:7d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 09:19:53 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 09:19:53 +0000
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
CC: Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
	<lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, "Christian
 Schoenebeck" <linux_oss@crudebyte.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 24/61] net/9p: Prefer IS_ERR_OR_NULL
 over manual NULL check
Thread-Topic: [Intel-wired-lan] [PATCH 24/61] net/9p: Prefer IS_ERR_OR_NULL
 over manual NULL check
Thread-Index: AQHcsKKa+tfh5nrJRUSV5t+CFXfTkLWpDx2A
Date: Wed, 11 Mar 2026 09:19:52 +0000
Message-ID: <IA3PR11MB89860002CF9EED385181141EE547A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-24-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-24-bd63b656022d@avm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|CY8PR11MB7897:EE_
x-ms-office365-filtering-correlation-id: 146b6497-57df-4729-7c02-08de7f4f5a74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: xCzo8EzOlP1vZF7EM8SGVAPapKDtDSJ9Onrfr0iC1Ul3jbJp+H5/xvrVGhWVhOAUvpUksI5GqokHPwAgYbia+l8Phr4v5imaJqjPwPVuAYpvIWoxwk5Fa34TmO36HQOv/zGERAVWPri+oruLJPjkDNbAwHWgEV3mSphZJI1ow7fgT9V6yNsiMdhw4MalqOBAxsnT0Kuak5pL+mD59TLzZ1FAu6dKl9FO4PB4ti7p1IrOMTXVtjRJ2niY9+E+LrmUdugLbF8jcggmgtoTGWi96vqbqxnEjkOIHm4YD9GDNCmIBRgteJ83GtQU4CZGUvfUbRjfFoiMuyNptzIBMZXM7njG2eUqaAxVZBj5K4Hxw9vaaZlwyz6Ppg6ZZLPRZgfF95iCc0x0nZqQKNH4QtV8JRb0offlpviOvR1+nNLwCBy9YfKrzsSlTDBJbg5DzfBXZfza4KQRT13W0ebTCbB1x4RVTgP09IYLKbWE1xiwKPJ+3resnHDtWC3U4/2xVQ/YqUVAJZMa/fCHwmD5NXnqYtw5CFBOj7178Qp3z5LuLgv9B7EjHv0xOb4W8YvYrLzDwMCwlj7CxK1NUhr8cAzkzgXMQadCuYA0JvhBNDBYqtcIsXyFDXASt5+/+JtoXn+Jb94eJqJZ7YHeStDaPrD7NlIVscXhkUdAOqzUzzeCpyhzUe/oTbXLycKPHJqNXyz6CNIU2OObJQevWL2VTAJu1rPJBWL8wRjMMQoyfe55tTxJx9VJCKw9hyXE454gBcuDtLLc1udWV/FbB7c7cC4am2lXYPz1pb61er8qpsY1LImElxWAQ1kQRXK4XecHwbar
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXZJUTJ5cFJtN1k2d09ZM3h6TXNaaEVrMXNUc1NHbUVPMnJrb3liY0Zxek81?=
 =?utf-8?B?aW9MRXIwR1RTYmFFQ1Z1YlNQb25lVytGRWVzZlpkMTVGa25VeUF1UVhlTHph?=
 =?utf-8?B?b1FHNlZTc1FuTzNUZkxUWTl1Mm5xbGpFMW5SNC84VUI4MDdybkx4WHhOemRy?=
 =?utf-8?B?UmNkWUY0V3NPYjF6VEgvOVg0dDQwQ0JvUXVXQ2JCZDI2bFYxd0ZFaHNrT0do?=
 =?utf-8?B?K2hiejVjM1NYeHQ0Yjg1M09PeGg1ZkwyczVjTEJnUnZNa0lxNnN2cG1xYmZL?=
 =?utf-8?B?U1MzVzN4UTI3Ty9SMmtQT2dGMlNsVlZ1KzFGRzBxdDJEaGd0dzVmYlREYWt3?=
 =?utf-8?B?ejdTLzUvcUF0KzJ3U3YwVUpudVVENkk4L3JRZTVNNTFqd3lVZHprNTdpTlc1?=
 =?utf-8?B?K290VWNEdFhBemRDMFdZTzBkbkllS1FJc2c0V1I1cmdRdktBSXArTU1JNFUw?=
 =?utf-8?B?SDNTbDFBV1BKWFVEV1ZyMS9FYkxGdERvM2pCSy9Bb05WeTVmQUk3NDdIb0N0?=
 =?utf-8?B?V1E5MDZiS3o3dUZrZTg4SEdjKzlIank4WXRuUmYwTUdLOE1ma3Fvckl6SGlC?=
 =?utf-8?B?bUoxZldwYXZ1cUFyQXBSc0pRN2NESmFUZ2gwQVVhQXZ4M1hObkk2UnJ3YmNt?=
 =?utf-8?B?VklvY3ZsUU95REZEUUdma29sbnJjSWI2S3N0Tmw3SVNVMEwxU1J4SVYwZzJC?=
 =?utf-8?B?dWhGcGFzVEdJUXhFOEViN24zbnNGdkU5R0RaOTMxTnpUN3VuQ05jZ1l1cVg0?=
 =?utf-8?B?a2FrRXh5WG1xaXlGdUhLRjFlbmFyNWlkVFdyQVozbHFuNytQMURIaDR3V2NR?=
 =?utf-8?B?Um5hc3JvQjI0THZvQzk3NXo2WlY4UWtKd0ZjanU1Uy8rZ3I0SjhmMDBtZW5R?=
 =?utf-8?B?T25BY3NwV0VGRnIxYWJFTlBqZlBQNjFTUFRoTjF1KzIzQnQwVDBzbHdMbHNE?=
 =?utf-8?B?dDZQb0k4azljMlAzdVdhQXlSZ3NGRWgzZ3hqYkxqTmRDc1E3d1dpT1drN1JP?=
 =?utf-8?B?M0J5dkpqYlI2cVJaUzZWMHo4RmpKNXQrUW9IeTBPMWN5WkQ0T01UTjBRZWd0?=
 =?utf-8?B?azNVUkkxdGQ0QVdUN0JGMHI2TmhBRnQvK01URlI1OE1WK3dVbEhSUHRwTUlM?=
 =?utf-8?B?S0R5SUd4SlBkZGJwY3FJdDQ2TFlVaUZuRXorbEhpSDczS3VFUWtTaEhRSXE1?=
 =?utf-8?B?K0lNWDZSekZpbTJhazFCUEE0K085cmwwZ0FMZDhKbnAyQk9iandCYnpDUlJG?=
 =?utf-8?B?VlZNcjhxZThBVFdRalAvL01MeUQ4MW9uVWd0QU11Mlh0UkZWSDhDYjNLbjhy?=
 =?utf-8?B?RkU4LzJVOUJKVWhjdGlCVllROVdCdnEvam5QaGRQZUM5Zm4wVWJIckt5RWUy?=
 =?utf-8?B?U2I0cGd4T1UxRytiUDN5QW80TzdVVnU4MXB2NXdWaVJtbUcwSHZCdytUeWVv?=
 =?utf-8?B?bTl6ZTZjNEhOTnJIRHNSYVN1bWE3TjRtWXJGeEZuV3d5TUd0eG85OWxyTHh5?=
 =?utf-8?B?Z1FLa21RQTVzWkNuajBSZTU4aGIyUUU5R3p1R0NGSis1Z0E0ajRRM2x1bm1s?=
 =?utf-8?B?T3pUWDZWdVRwd1VkNWNTSlZpU1JhRTliUG5OdjAyUzU1azF6QkFxWkpvSVFn?=
 =?utf-8?B?UktjSmNFZVV2U3pFeDc2ZHlOOFYwM3U2cHJNdWk0L0pRc1BOaFYrSlEyb0Uv?=
 =?utf-8?B?Nldnd2drMWxQQWdENUVSVmo1UHp6am1xK245alhPNFhZcFVVaDU0clJqSlJE?=
 =?utf-8?B?VWlqMjBOUWRodTJPNk03R1Z2dGhiYmROVHZ4aXlPVERDQ1Z2UHdNbjJKR2Jy?=
 =?utf-8?B?VWxmWUlRWWJHYkNQd1lCQjZrdjJtcGZ2cXhrbCtEZjY2ZkpqVmpsYno3UUxQ?=
 =?utf-8?B?WVkwWC9PZkJUU3o4aFBnYmJBNlBHb0dETVdFL1Y0cXl2ejA5cVB2MWNjNTV0?=
 =?utf-8?B?V1R4ZE9IUUZDODd2aUI2V2FXYkZONDcxSTk0VkdleUFjTlF6YVVvWmVDRmxu?=
 =?utf-8?B?VHdxalk0RjFTR2tGMndWMkdwS0EraDQvOUpCZ1pDL0N3NE9WOE5iWTV5VjY5?=
 =?utf-8?B?SVNWYW0ySUhBSXU4RHVLUU9MbEh4Yi9tdHBBK3oxUXhiaUdGWW9nSC9LRXpy?=
 =?utf-8?B?KzMwMXl6S2JNOFdnd05nK3owNVNEbVc2bDVYTjhUd08yU0x2WXcwVXozT0Zh?=
 =?utf-8?B?TUVqS2RYNlNYdDJSSTgyNzR5alNyVWNLc3J3RHE4WFk3V1JySEZuR1pKSndP?=
 =?utf-8?B?MjNySHJ1RGx3TDBVbHFuVlMwNkwzb1FzVTZFR2JQQS95VkI3ZFBrVUpud0FU?=
 =?utf-8?B?bVZPaUFWNlc1ZHRtMVhGdnJYZmhKM0tnL3crLzQ3R3gzdEFJczhnSnVRc3Vq?=
 =?utf-8?Q?4trO51J1GdXfqpgE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: a69exJuCkYK9He6WhXS5mSdevm7QQYzMbKq84o6cab/5zxaKKIUsXxZYgqCNGumcBaFYj5zLT1NCQUL80c4a3isUjr381++Uszaxdb+w5gQ3ba2ICCPC4p4S98Tto+gtTS3inkmYhU6lWe4LdVhuTdSfcEEx5WYWHKzq9EoNXTXaza62zs2mCjoKYQ4FGd0s6imSNFVgZso0GnP1fA05JfZzBZXax8lUVJJD3NHpTVS7O+eMXVBl5SkwIt2o84IHBRoKTycswILn+dpCi1xdfZCcW0cVL5ytxukuqDkiRpzmx8Ifcw4FsWCPhc/WOC7/BSQT7ZFKDAzjTO/HqycriA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146b6497-57df-4729-7c02-08de7f4f5a74
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2026 09:19:52.9395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Ftkionec1AH2Drm+uzecDRYAiZuu9W4MK6U0DRbxspF/1CAxnRVLkh4XI4gsD2ggIGpaCVs0DgNhFcoz/9RHiBchDTTlsTKwloLswabMQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7897
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C142840007
X-Stat-Signature: eztjyw5ofk4fef5k14sxwfmgzkmb4e8h
X-Rspam-User: 
X-HE-Tag: 1773220799-845379
X-HE-Meta: U2FsdGVkX1/L5r7WhfWm8J7iNf2sNHjg30FRBD+3hgo70+OJxSPEn8vDq31vaxbj+cswCU1bgdECYKZPPyI5+jdzGsyJWUiohNau/ioWZX5vKtWz3ztjde3dGrC++qXaj5cZ3z8g3vKoLg0bynbC5Bv+kS/EevTcktFaT9VnWVFZUUNwAp9SLrxiFduDMMTHr+pKKp+VYVdgZ6bxsIsgZosn/vXJhfsF6wLY5Ml7hhxZHT6z7uEc0NW3HEH8zTcHlff7d1tXu3oymRTpFrm3qhfDRLZoQcPWnwfBJDhFP2KcYVY9JQWgANwy3WLeK5f/Du3MD+dLT5fUfTlOrCOfxJEwjRh+ggpa1dXIdepCczaQ+GLIFjSQ3DS+mja6/Lzq3RFrtrO9YgtliOuZrWR0FiuTzTL+dYxvV48mCkTaW8EyzsTKrucxtlB115cJh9wRkFVTYjrXwipJQFscwrIDzbiSC6tyDabySjm5d3I7q056Z0hu/KG0lgsXDQqKIC6+xp4RpDvGtKDbYAEaASpA7jScqAbD9FIoRp9/uM3yC1SWjuKDfBXFS6R+L0rUCLA7LNzoIyFuM5MLIyQ1VCOf5YeGHMCV+z3GisrFShDmtWcVlaY+N6q9b5+r2a+po72F+CK5Wc6CW4gi+5ZgTE/zUoiVRJBLCPhYwj7csCTz/cc8RRtt0gLq/oFj4DZkkNpo55r5YCp2fnNAxLQLHO8Bo2zzJi1rEkG8ogh8Y9uQcam82xmO9OM7MsDHEJFLMu/8ZmyIPenQBsFx9H6S2aCQc11obT1tkfokq8xMT+uQCee4S640p0YCdW0C2ZZoxn52pMEuqZNBZxfM8v2uaCpy6ydvpqeSKU3Eyhi4LIbfNcHmT5vhYLqaQuwKlDEjWf20pKjIDayYU6ieE5WRQzQ2FYr4V87EbJ3VlgASPwzL9eXXCYV7kbV/VPpwN1V3za7zDIU/vDkn0i5nwnck4xf
 +84KhDAm
 5naXdS3xEan0t+6Ln2fxUcC1MnxmDp6H2i3VaLiKCRN+MLFvDiO85lg9DgWMCjO9jhiSzR07mR6YvC2YVzKWCVw9VkbvYWvHfJspaTY2apQUtmzINU9K1xsb2zdOP2hEoJwjzvUWROBxDa450YkoNhQKOLNT1nFG1hmUXFmOmxN3yXkRJqYk8gMde1Uir1lpeRBWRbe4NJXm1yvWjQzM3FlJdsA4wh2bu4OpWO8apGtJ5ur4HSwmVshhqAK1WkxNj55D72WHjUHUs/vpo2ziqQ6dcZc4gCk3wZcPbs/1VHRXcam3n76Yd1sQkaTqSA4LC/rwr384TbtTeaiQXHcUVesrlJumn9cP6e7cpdSHZtP9fns1TLjw1r60WgJMR66zwRONyvEk8mHceOff/AdN2FJwivKxL0RhKjm6EhbbFbY6yWAIEVOJ0cNfJVyaNhDpZ7Z88YV+sgGrFqgmMDRZNESGDlgKr8zTMBLVz72hinhOwrAHZl7uz+dvIXKKQstegOkI3JxbvS3IWoHQb7P6osROv/UqE28XdIYtFBE2yA3QZ8VGu0D3xrfvwg2ADuf4hcOJNlOdooTVWC2u03hj1U2P/jJv1Su0J5xQmIaQXX7HpaN3Ou5AmgFcrPlRZvq2mNcAFHZCpqtgnmVhSwKrPta3o1J0ytqVsQTRYf4f0J9aMfXIpPiBIPDBSPyJoh8ziKctIIcXZhil6VhBPZe+80ERZajHjSEVEXTNzABdUGXUbTsHJi6pGpKkQuvBk7WMRiD655OLCqH0YPbrmlzB5o6RVjYRCeTZwaPxrEU3CxrjSH9ln/aLwH+XATYyhT1k8caT6ywnOoapy6Kdyu2+JCkFN7bo4AT5Tdn38cDxknEOBFdZ04FZPqcJYJQAKWQfKpQbfdY8hgTlSoWFpzUiS/XhSvXOnC0xUBNXlY5J82rA0QBPvRAdpwarULVDGdYCIm4G9c4uaB/FpOD2DyrBrkeeix1Vc
 kHS46zC+
 4Oh3AlKs46MJHJ29n5ngzyetx+dnqjDTxobaIlb7Ux7Lfps5egA8rl/iAcIgyxv2e2yQQPOQY/USZV3rAQtN9guzKr7r0AP++l5goKxhG05sjWO9XDLqciyc2C8BYZ8y4D5PVg2hyKN6gdWlyG4R6LSed0WCofq8APB3k6AoQ+1miOQwA0F9aPsXpu5BJO2vQn9uAtnxhba2Ja+nkMYf+/HUHmSSZIv0JUljUhRgJexDTOwGuTiNjI8xmr/Z2NcJvEYDEotrKKIyPwKzzSwAKg0fqzBPXqCL7EliOrbIHz0xKaJwWGfziIAlaFDcXoZu9EfPW60/H0lAIYxs11kArWEQAB1AgaKgw3a4kqW4MQhYrJJtTZV7lG/LnrLQftRzcY8OdXedXXHaHqRWGIHGx6Et98daE/RxKTEGddMFLdo9Pdtaq1YrKgUNzb1iRLY4OFtRQU9uIaQk1Yi0fAMsVg==
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
bS5kZT4NCj4gQ2M6IEVyaWMgVmFuIEhlbnNiZXJnZW4gPGVyaWN2aEBrZXJuZWwub3JnPjsgTGF0
Y2hlc2FyIElvbmtvdg0KPiA8bHVjaG9AaW9ua292Lm5ldD47IERvbWluaXF1ZSBNYXJ0aW5ldCA8
YXNtYWRldXNAY29kZXdyZWNrLm9yZz47DQo+IENocmlzdGlhbiBTY2hvZW5lYmVjayA8bGludXhf
b3NzQGNydWRlYnl0ZS5jb20+OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1Yg0KPiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgU2lt
b24NCj4gSG9ybWFuIDxob3Jtc0BrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBbSW50ZWwtd2lyZWQt
bGFuXSBbUEFUQ0ggMjQvNjFdIG5ldC85cDogUHJlZmVyIElTX0VSUl9PUl9OVUxMDQo+IG92ZXIg
bWFudWFsIE5VTEwgY2hlY2sNCj4gDQo+IFByZWZlciB1c2luZyBJU19FUlJfT1JfTlVMTCgpIG92
ZXIgdXNpbmcgSVNfRVJSKCkgYW5kIGEgbWFudWFsIE5VTEwNCj4gY2hlY2suDQo+IA0KPiBDaGFu
Z2UgZ2VuZXJhdGVkIHdpdGggY29jY2luZWxsZS4NCj4gDQo+IFRvOiBFcmljIFZhbiBIZW5zYmVy
Z2VuIDxlcmljdmhAa2VybmVsLm9yZz4NCj4gVG86IExhdGNoZXNhciBJb25rb3YgPGx1Y2hvQGlv
bmtvdi5uZXQ+DQo+IFRvOiBEb21pbmlxdWUgTWFydGluZXQgPGFzbWFkZXVzQGNvZGV3cmVjay5v
cmc+DQo+IFRvOiBDaHJpc3RpYW4gU2Nob2VuZWJlY2sgPGxpbnV4X29zc0BjcnVkZWJ5dGUuY29t
Pg0KPiBUbzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFRvOiBF
cmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPg0KPiBUbzogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0K
PiBUbzogU2ltb24gSG9ybWFuIDxob3Jtc0BrZXJuZWwub3JnPg0KPiBDYzogdjlmc0BsaXN0cy5s
aW51eC5kZXYNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogUGhpbGlwcCBIYWhuIDxwaGFobi1v
c3NAYXZtLmRlPg0KPiAtLS0NCj4gIGluY2x1ZGUvbmV0LzlwL2NsaWVudC5oIHwgMiArLQ0KPiAg
bmV0LzlwL3RyYW5zX3JkbWEuYyAgICAgfCA4ICsrKystLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL25ldC85cC9jbGllbnQuaCBiL2luY2x1ZGUvbmV0LzlwL2NsaWVudC5oIGluZGV4DQo+IDgz
OGE5NDIxOGI1OTNmM2ZiMTllNjgyN2M0NzI3NTMzODAxOTM0NjEuLjRiZGU2YmQ3MTZmMzIzYzgx
OTc0NWU2NGM3YWENCj4gYzBkZWE3YmViNzJmIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL25ldC85
cC9jbGllbnQuaA0KPiArKysgYi9pbmNsdWRlL25ldC85cC9jbGllbnQuaA0KPiBAQCAtMzY0LDcg
KzM2NCw3IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHA5X2ZpZCAqcDlfZmlkX2dldChzdHJ1Y3QN
Cj4gcDlfZmlkICpmaWQpDQo+IA0KPiAgc3RhdGljIGlubGluZSBpbnQgcDlfZmlkX3B1dChzdHJ1
Y3QgcDlfZmlkICpmaWQpICB7DQo+IC0JaWYgKCFmaWQgfHwgSVNfRVJSKGZpZCkpDQo+ICsJaWYg
KElTX0VSUl9PUl9OVUxMKGZpZCkpDQo+ICAJCXJldHVybiAwOw0KPiANCj4gIAlpZiAodHJhY2Vw
b2ludF9lbmFibGVkKDlwX2ZpZF9yZWYpKQ0KPiBkaWZmIC0tZ2l0IGEvbmV0LzlwL3RyYW5zX3Jk
bWEuYyBiL25ldC85cC90cmFuc19yZG1hLmMgaW5kZXgNCj4gYWE1YmQ3NGQzMzNmM2I1ZTZmZDFl
NDM0NGQyNmJjMDIwMWZmN2Y3Zi4uNjA0NjEzNDRiNTM2YmNiNmU5NDExMmFhY2U3NQ0KPiBhODhi
NmE5OWFkODYgMTAwNjQ0DQo+IC0tLSBhL25ldC85cC90cmFuc19yZG1hLmMNCj4gKysrIGIvbmV0
LzlwL3RyYW5zX3JkbWEuYw0KPiBAQCAtMjUyLDE2ICsyNTIsMTYgQEAgc3RhdGljIHZvaWQgcmRt
YV9kZXN0cm95X3RyYW5zKHN0cnVjdA0KPiBwOV90cmFuc19yZG1hICpyZG1hKQ0KPiAgCWlmICgh
cmRtYSkNCj4gIAkJcmV0dXJuOw0KPiANCj4gLQlpZiAocmRtYS0+cXAgJiYgIUlTX0VSUihyZG1h
LT5xcCkpDQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5xcCkpDQo+ICAJCWliX2Rlc3Ry
b3lfcXAocmRtYS0+cXApOw0KPiANCj4gLQlpZiAocmRtYS0+cGQgJiYgIUlTX0VSUihyZG1hLT5w
ZCkpDQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5wZCkpDQo+ICAJCWliX2RlYWxsb2Nf
cGQocmRtYS0+cGQpOw0KPiANCj4gLQlpZiAocmRtYS0+Y3EgJiYgIUlTX0VSUihyZG1hLT5jcSkp
DQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5jcSkpDQo+ICAJCWliX2ZyZWVfY3EocmRt
YS0+Y3EpOw0KPiANCj4gLQlpZiAocmRtYS0+Y21faWQgJiYgIUlTX0VSUihyZG1hLT5jbV9pZCkp
DQo+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChyZG1hLT5jbV9pZCkpDQo+ICAJCXJkbWFfZGVzdHJv
eV9pZChyZG1hLT5jbV9pZCk7DQo+IA0KPiAgCWtmcmVlKHJkbWEpOw0KPiANCj4gLS0NCj4gMi40
My4wDQoNClJldmlld2VkLWJ5OiBBbGVrc2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIubG9rdGlv
bm92QGludGVsLmNvbT4NCg==


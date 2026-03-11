Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F29FD0655
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BD06B0005; Wed, 11 Mar 2026 04:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D8A6B0089; Wed, 11 Mar 2026 04:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1536B008A; Wed, 11 Mar 2026 04:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4E7A6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:17:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7492B5A479
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:17:02 +0000 (UTC)
X-FDA: 84533076684.27.E80565C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91B3810000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:16:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DsILeU5r;
	spf=pass (imf14.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mh00NQrg2lIKNWkDXvNhPe2GMjEhYIMI8kQ4tCuMao4=;
	b=FlBkekhVdRR3XD46kSgt/EbLm0saL4ZoqIwqPqPsFD/AtGBVMcBCn6U5Av3D96Sb4XE4sg
	rULp83lzZmaYgxFxjj8HHX1xN2txrh6HKx0m5Q7iYGwW9syrMFzaAezFUF+ajXEYrNJgYI
	veaNtON3TjD7e63VEiOFU9fweibzDvQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DsILeU5r;
	spf=pass (imf14.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773217018; a=rsa-sha256;
	cv=fail;
	b=CY0Mgsawg3DzvqCu/iiRNc2nmJKSYUMDilqaeaky3FtTOxb1fiOWi6qdzEwI6Bt2xw1KTV
	zpyE5GuqlpJUBiJ20KCzhE8ut8q7nQtAG80C3Ire7Z6ZajZiZ7RiGjUAHm2MpBnS4FMqWC
	MuMPEOZDB0YOdYa4EX+MiglvXnBLypg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773217017; x=1804753017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mh00NQrg2lIKNWkDXvNhPe2GMjEhYIMI8kQ4tCuMao4=;
  b=DsILeU5rV0fPJi+km4xx5Ps63KhDRKsSsZOv9uaJFx/hrotbAgIMaQYr
   8EJ2sESMFdk6eLRDwLME1PQZg2v2BuMvZ2kChElVJTjXQJaY8Rt92R0yw
   4FL0jjdyct9zXzSe6yQSBCojhB9ClFK7tIJABDexaP9hVw2ZzC4TSqqcD
   YLsD8g0LWPJXclMl+vUxB10AyBFtAWSGom4RfakHdB7MQvI7n1GsjOyXM
   pZ9udvY7H1zjAnaQj4PLTc/BLSMUejVZKRaatBqIdGs9kxRjDG9/+cCQd
   vreAaCyyFuF+2GAOSwkIaxiew0NyofhB+QPPxPYfN+HkUG7MkqzGxhmJ9
   A==;
X-CSE-ConnectionGUID: tWo8e+YyS7aaGx5BqyfI8w==
X-CSE-MsgGUID: +SoE75JaQECyt5ybrsyzOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="74467607"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="74467607"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 01:16:55 -0700
X-CSE-ConnectionGUID: BMGoJHUZRWmghWNXe/Zk3Q==
X-CSE-MsgGUID: g5YTB1s2Sqi+a6FaJQciMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="217077384"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 01:16:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 01:16:51 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 11 Mar 2026 01:16:51 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.26)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 11 Mar 2026 01:16:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Opo9MpRJtwx0zLgDgZOZFJvPXyHqHHtJzkUiUwVJCsz4tKEKo07LreqxtnrsCjwVojH4U+UwLGvLUj6tWPkc6m4pF4S6tJD49D6pQ27s7xGcfs0lsvws5Mc4Crewz36bF2iEdApjb3wgDXOINHplZ8RrYmMyGB9KiYtvU5ZM7+8PPHQ4D+mLJZuIVu46F87G8kMLHuO5LzweNhPlt1T0hwPb8bjCxWtbmFufuecYQPnZ5Losrc+UeFJp5bjwsqeLk92kr09MQxsBmElWGC1C55jrobnIuiBTr7MkzzIlRr7ETHdfc04dd2ppiR3SK20FP0U+KXkotq1HmCcVeC5k6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mh00NQrg2lIKNWkDXvNhPe2GMjEhYIMI8kQ4tCuMao4=;
 b=PvZIA67maJcJZMl8ktUdh9e+oCmpUPO8uwMtDhImWg/7I0jtaQ97c2U03ZqEoY5MA8kxm/yaPjMOIZv/MRKJR5724vKgt3Zy0JtPGquxl+oby5wgXKR+gL5+Or5WdIAw4vi7PIP0s32fyfKM3StEJoqnrE68jqMTix3K03Ob2M8ClebhUzWxUWTTpgzEU+9ptB0YRzkwnLjf3Gbc5uI4fJXkLyhlVjPmb83qjchjgoQt/KAwPjnhtyjdlxnRgmuNmCsuQLP2UvSKZFbsiecOE8S+TAZM+vodeF7mGh4J2QrbQPRzL3dwaH393UaCBjVAY6A3gLotIzLPB/B5adEJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 08:16:43 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 08:16:43 +0000
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
CC: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: RE: [Intel-wired-lan] [PATCH 03/61] ceph: Prefer IS_ERR_OR_NULL over
 manual NULL check
Thread-Topic: [Intel-wired-lan] [PATCH 03/61] ceph: Prefer IS_ERR_OR_NULL over
 manual NULL check
Thread-Index: AQHcsKJtosLQvJfHUESbmHNNZ0gghLWo/XCg
Date: Wed, 11 Mar 2026 08:16:43 +0000
Message-ID: <IA3PR11MB89868EDCF9D093C501E01FA3E547A@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-3-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-3-bd63b656022d@avm.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|IA0PR11MB8379:EE_
x-ms-office365-filtering-correlation-id: e34e8a58-dab4-497e-6b65-08de7f4687c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: jQMLhYHNcc8rWLFFel/x2sMvHTNauRhuYBG4bf+v7DsJZFhupIQte49LtN3UoUBak4B1IEWtI5P1CmysS1a+awGpSJz1r40isgFFN6L4/mibvFUKClT/MHdIMjSE4HQukbYf0M2IxFRTmvLUaDZO/+OqT2RCKgtSBSNwPfxfWkRyzOeF2hz7VqpT/bP5wowbzNc66q4wL8xr7nzirI6YWKRsmxf1DWqNzDJq0ZDssnFrN3NJVD+DmQgHzvk6oU6znVEUc7rJrNuDvx5SfI22I0vk5YAHgZS3r3GWilsK/mH0/G6jWruqtyFazGqdS4YPo4VggHYRFgUF4hMOlNHdsU7DcnNMARrbZ0SGm+HoHpUKEXC4slgRMBk4pTRlS1bNRHmu7dctE53a4eld7MfvX4/VCisN7uIrH3H7wkgEnlsZFrITVWlYj6tCEICkv95CBNqOFL+vcNYaZDnlXRN4h4ieBBAs4bkxgJo51IR6odZkbLzjMXpzGcqsI/mt6RfxXqC8AL1RcxFJ07fcXv73zoGCVGHcwPZIItHDvtrPE46pL/lO0UByfnfuhJKRNACe4ge0dP0jWubYBPg4uKPCBIlEiu1E9lLwYWDODI+MxWMdCnw7Hi6ZWZe7Crnx98PGgc8WM8q+qFjTlWci6orACn3nPHmShktAHNmKZLfzUy4xRYweFBtNzgWrA73evyHgmwW3MabvCgHgm+V/f7BaRNGziMylCelvMtY5LRr3SVkxqtpuIWlU2tl6maVXxD/6Zma/pAGcxVD3vEAJpHEREdZUf+Id82qWyMcEFNe8aBamRKZIZReDd6IYnkL9aw8J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0JnUUFIYlQxQkxQM3YrYlVCSThmZkoyOGZMejBVUmpSTW1IdDhLdTdBRVBI?=
 =?utf-8?B?MjRuT09YQWdUSjNsclQ2Yi8wSDZBQjdiVzhCZmxXZkhQSTkxNjhXWExvNkZB?=
 =?utf-8?B?dGNLYlNJbi9SNlMwSG1HNTd0RmVRT2NJRmVYMklXdjdDNFI0Rnd4dWtKUFZk?=
 =?utf-8?B?YnZQVDBHelJaTmluU1FFQXZTelZZUlRNblJGMjVPT3Q5VkFpQXFLeW9UNmNJ?=
 =?utf-8?B?Vmc0bEkwVVBOSk5xcVJJMzh3b3NNWlI0MnVPVmE4SGxuUVJiaXF1NkNkUXBK?=
 =?utf-8?B?NmFLa2tEeWU4UEVPWERuTzVsVFZzREQyYnArUWdRVWRTRW5OK3FQcXZWRHpZ?=
 =?utf-8?B?MXdxUmtzUC9uS011RnlNZmYydWZHSVMrcDl6b3JnWEl1MnpIZk13eFZpVHda?=
 =?utf-8?B?UXJpT3RRRmtyOFdkUHVyKzZUN2s3NVMzNkZIU0ozUUgxNzRES3pjOHZaRTlw?=
 =?utf-8?B?YXBqeUMwaUg4WmNTWkdUWlpaV29vWVVVSWk4Rzhnb0dDeGlZWVVPbVZHN2lm?=
 =?utf-8?B?VUFobVB5cDM5K1ptdG5kcFFJUXd0aEJhNVFYanZKUkRIOFJKZUlweGZvWGxW?=
 =?utf-8?B?SVRwaEpvQk5nQmJTVCtPQ2RGZ0NnNWNiYWRaQzkyWmlpMzVzbThGZ3B6RFVX?=
 =?utf-8?B?UGxTOHJUSWFyeWZDSlZWSmtSM2Uwc3BEQ0dsM3hJS3J1S3FObTVvOW5sVzQz?=
 =?utf-8?B?YWRoekI0Wk40R1Z0Smh6VHpwZlRCRlBXc3BqQzgzZmZVYVd1ZXRtL3NHc0Jk?=
 =?utf-8?B?YWtqTEFtSHh2ODd6a29LYkpwSS9nUlQxU0xjdVA0c2JqUG9pT2VxMHloakNK?=
 =?utf-8?B?NnZmMTZXOGczQzBZLzhyWDNna1dmdWtXVUFaTlZnTHM5c3kvektGNEg5TG51?=
 =?utf-8?B?M2tieDF4dTBhUUJaRUJvQkNqcGkyMTJSYVl6eUpDNEZsbG42SCs0YWRNT3hp?=
 =?utf-8?B?UFQvVzJTTis5RnFEWE1WWjlSZVdFSFAwb0dLQkIvNlpUODdtdHFlT3JKeXhJ?=
 =?utf-8?B?cUN6em01SW5RQ0p2djM2NDR6UUxiQis2OGJGSHBzY3VURTZ2enhCT3Y0aDlC?=
 =?utf-8?B?aEZNeWdVTmlBK3hBUHBuWjRVSmRFZmJNWE40NVJ0RE9mc1IydUJmYlU5WitW?=
 =?utf-8?B?WVZKUXk4dUJGaE9tNUd1WmJ2ckN1V0VveVpqOGhXekxZeUxTcVRENWVFeVhr?=
 =?utf-8?B?V3dpSWZYajNPZWdZTkdpTWlta3RtK25uTTBpZENMUTU2NE9YeS80bE1uQi9D?=
 =?utf-8?B?SmFQdDQ3bUpRWmJwT3lKcVRFdEpHd1VwSHU3cXlBbnAraVBaR1NVQ2lSblVo?=
 =?utf-8?B?aVN4eXBTcmRHSHJNaFhITWpCeG81dFl0dE1VTUwraTc5SVBmTEFBMzR4eFJ1?=
 =?utf-8?B?bHZFYk1EZEYyaEVDTjlPUlBxN0ZhQmRRRms3YUdlZGpwTmVNMGp2UlJLS3h3?=
 =?utf-8?B?UVBhZzZJLy9XQ1FVVElVeHBVTzRBTHRPNXQwam92ZGFJaXlLQXp4TWxaMkxY?=
 =?utf-8?B?d1hGU1M1ck0yZkF4WVQxaXJaTlhjTGxXSTE1dUVwMVhzMmhmbC9JRk1yV0Yy?=
 =?utf-8?B?RDhWQThtL2xpT1E4aEt3OFBVcnU4bHJrVDBvVXpMM0RhSXNqSDdpcjVSVzFh?=
 =?utf-8?B?SWYyZDVLWUtBMExrcmQzdmJZYkhaN2c1VVR6SXUyWWVKNFE1Vit1dHdLcWF5?=
 =?utf-8?B?RTRaWUF2YkdtVGxHSVFTakRabXU4Y0lYOVMyMURmb3FrK1lPRVQvQ1NQZFpC?=
 =?utf-8?B?YWgzeEhPTjB0TjRNZ1NkVTZBeE1IMG9FelU3Qk8yYkRML3dwQ2RuTXJWdU43?=
 =?utf-8?B?ZFZPUS85bmw0dnc5cmFGWDlxbm5PbGlOdzJKTWhTSUk3clNXNTc4NW9NQWIy?=
 =?utf-8?B?MlJTR2JkQ0xiYkYrdE5LbXF2RkVERllYMzFZWCt2RFB3SlV3K0ZSeFJ1VTMz?=
 =?utf-8?B?ODA1bk45VERFZ2hiRXlWeFNJOUJLZ1AzTk9DSDJVMEZSYXNxWnlqalU4b0tP?=
 =?utf-8?B?K3RtZTFCb1VRK2l2K29abWdZZFpRWFl5d25GYmRURUlPbGxtTUJWWWpVem1a?=
 =?utf-8?B?bXcvR054UUd5WUVTNnlKUFAxdzdaa1NtN1BJSjJXWFFjY3h6eWp0TmdDS1A3?=
 =?utf-8?B?MWlybnExWTFMRytzeTVXNytOcFRNME42eU9wNk9xc3pQd05tNk42V0hhQm1L?=
 =?utf-8?B?dTl3YTBjbGxkYjUvMDdmV2NTNnlPdjl4Y09Ec2VrNXZZYW01amJOM3pZdWp6?=
 =?utf-8?B?YVAwSjFoV0FydDhMS0J0VWNWUmFDNVBtTXRnUEVKNnJ3R0N3RnJHNk42SEN0?=
 =?utf-8?B?eDA3ajdsQ0EzTkVhcXhBV0lsOU9vdk0rU0gwWmpnYzNnMHdBcjM0TXViZ2Yv?=
 =?utf-8?Q?pmu1iw0JdmpqlrD8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: lS2x9ZIERkqgSn6Qc2Rfme6olSfFFxn2kmThqyIUm9Tyig3CNDNpPt1RwVWn7smwbBGJOzGfzCUuSOp27IHdik5xKs6rWV3ymJopLnDQSlVKAM6dlmNiDO3CJSy8X/IwO/YZdVRbsCsLTnoDX/jQ7pe8NGHKIbWh/d/7lgxquo77YLgktOmX9UtHTSiUFZKVZNxDUkmF1ReoboNIUri7zvoUg3oS177Awk4d+KM4Mj0dBehbim9Vu9HmZcBLy7DO0/CV06JdE98SmKBKqBbfyaW51ogywi/q2lMNh4w0K3qwNL6po5vnFnNYH1EUfdnz2mU2G/+qIrH7ce+ltJ6kWg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34e8a58-dab4-497e-6b65-08de7f4687c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2026 08:16:43.5293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICks5v4abd3Mi47kJZ/Surb/+jNIrlILUiXV7SvcOuIRk0/oIphN5Js5Fof8QKa29fKfn+Kf31+5teG4Pxt9Lzf6o71UCRgFr4PD3RuzL9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8379
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 91B3810000E
X-Stat-Signature: tjij48jx77g85scjk63fye56zob3j8q8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773217016-545735
X-HE-Meta: U2FsdGVkX19NXVSGWE4NuMfpVOzqPA/vfaHkT5DJViiikO5Ymd0QICpNCvfBL/7G+HxgTuI/iK4682uX4tHU1S9SYYXLIX/1Dvl4UoA1kf4WLZsLjxhcnXpKJILw3I3gL274+/90SOTHj+JtRf/tx7QT9EfUj0ZS9xvFJPDCiBVCPNXSZ9IamCsSffWcWUAZJWwiIUHl/n9MKu7cGTpUKGbSu15PeOR97KGUsgxOFn9usnGJ3sHxQ2iS7eMMJiKsdsEFAUPDrmL51FJCAjSvK2csBCjuMJSpkZu0Ls+IM6AbGcCvAgApMB5OhSw9yRMPQ15EWecfeTmGCcg86ZdBOePtyr5MKyT8+fkIzEZLC6aLcsDokj8fl6RLZPtHO64t7QihUx5q1lrUDtZFFheR7dLg2VuE/WN/iugTiW5tbNZBbz1+5ZezTcLGytyhljEMvCphti6GnvjdXIQ7vWGWXyKpPOHgLXT+PE9++ZzqjK6RaF5HkSx07V6W8OFWKn6+dQsbmNfqKL1n++K1lC/yFiqZj0jiN3FQa581/OxRHZFH2vNq6BnK9QMzjGNMVjMbO5BkWMPtChsmhCDcFRzbiMpWf54WnfeNZBAUK1SYNfZ0PIAVmk3aDE2lZOzFocu3/GW7fS3YXtvmzhM3be3RbDFTv73sUjmEpoPOeeMq3Lys28jiAnortt1ns33e92HU4C4kFvvMA/A7tq126yqgJi0Olt5XNZGWqBtQDgqFqi+BJtlr164GmHgrfDk9oY6jCxbUAtNb8NvpuLu+IFKb8fkwJKuhbggB6eU5PTqfOZgeo/ExOF3/Wg8L1fsowe+yKY7zMWFNxbpuZgkCI6ZpLBiQRW91fTUxkPWfFSGtiYn+yF1BIbd329JFXCfHed8X1TFFwOIsUoEm2vZcGDqHQKZW3mYSz85mIEQTlqkkMkVBpIZcreMhBgRp6YFiGQbrNnBm/UkLqPIOwmozwty
 +opIEU8B
 b83+XVWYX+1GzCkGlYiKN+Rl6loL38ngCQRyKfNgKSN3Srue7v9LY2XBw7zPKNyOb8UE7u6OlUd3/IqjLEOVPen4p8q6PdkTwR+S7MmSL09g4cpAgSdJrJDiW4VSqjA9TyNiQAd5aBl6flaes+OgwfLyZ4qiIb1hunhjMYBWr6P5VsHOsoHwQ+RZWvNW5iXqnOGO8o/+1X1tEh3yzN0z2qbmDK97oMTDg3GOco0SJQlF3MhIkQKQA+qSlsUVsCBdkx7GHte69Hv9N4PFFx8eFLIjypc6II+8v9brcwCbePpCEisCwOnNxOtwu4/I8s6pf7NiPB6AwKxX0Sr/Snm4kHpWyLCpL2m24iOpnxItqSARnpBI3PgmBudB1sK5sT9SiFn/eE0RFxIkAXpIKAVckHNB19+aiMav2ULZJxZTyWSFwHUUI6v2w59PfnVcePiy44NInXxw9sUA/yzkr1M4q5eQMWoiRO+JNgNE5TuhzFX0QkajwKnOuFpsk6wePKx6sgFgbEri80V9+buFx2EzrOYJYNqui0zqhN8SoIJZWMbDmr4bZv1KCPbeavV+wfZPPCt3Hba/lQFLVTUMhr6Wm9oUf1P5qBFDgFBxFs+b7OEd0gorSAB2L56PLjM87rmOwjfFSfhR1cIwl2l9BFhjqM2UAq6m0zdHdbGo4LULb4DyB4ddJudjqONjYRmdqRCXNy+uOKjcl9eMKaVf26vTXPCKcqvF1M/SOLY/PiGwVPiL1x3L0bgp+LizG2g+ARWUVCe4LeNbFO8lgRW9N8sf5E3KnPaX81LeQ4Hz/Klu7+FBaOBTb/sp259uVfvSXyNaMoaMB2cX0QzVbJo4NpqVZdj18Rs6Qj5qmko3/kJcedkLs8qc4hUjK7sA2wIufqCjkomMFU9rkWqOnlCJjzri9AgE5ezEj6oqLDcGXEKDterNgoIVftmZEptswOHD8KJbzlX8AK6XZXXTDT0u4A4M3sqouLSU+
 EzlKSE1B
 TtECFSyDUK1FpkOIKwWbJSsBMBX6ZJ7PH7cRAabRfpGGdRASGtpvooyCrEOIMrwDIpoPSpIvBbYUD+j4T8GX7NdUjKWScJiUtZh6/S2SdLVJlsdMHAKBrTCuxqgcPJwftBctsWSO6DCuvxlPNFH4HFmCilW7ix0ql3RmShopcLieQetbvG202y88E0ubvORKS+GaZpptG3qS2UmUCGUWtTzX/AawDe+H63f8GTJutlCIs88vKN1xG4xpdXnvugQwxPOuF0ehEi53hlXCa9PAWrbwC8zc5gfMzazZsNZ1RxFXz3A6ufgwZoTBJWEi7zrq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtd2lyZWQtbGFu
IDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnPiBPbiBCZWhhbGYNCj4gT2YgUGhp
bGlwcCBIYWhuDQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDEwLCAyMDI2IDEyOjQ4IFBNDQo+IFRv
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
bS5kZT4NCj4gQ2M6IElseWEgRHJ5b21vdiA8aWRyeW9tb3ZAZ21haWwuY29tPjsgQWxleCBNYXJr
dXplDQo+IDxhbWFya3V6ZUByZWRoYXQuY29tPjsgVmlhY2hlc2xhdiBEdWJleWtvIDxzbGF2YUBk
dWJleWtvLmNvbT4NCj4gU3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIDAzLzYxXSBj
ZXBoOiBQcmVmZXIgSVNfRVJSX09SX05VTEwNCj4gb3ZlciBtYW51YWwgTlVMTCBjaGVjaw0KPiAN
Cj4gUHJlZmVyIHVzaW5nIElTX0VSUl9PUl9OVUxMKCkgb3ZlciB1c2luZyBJU19FUlIoKSBhbmQg
YSBtYW51YWwgTlVMTA0KPiBjaGVjay4NCj4gDQo+IENoYW5nZSBnZW5lcmF0ZWQgd2l0aCBjb2Nj
aW5lbGxlLg0KPiANCj4gVG86IElseWEgRHJ5b21vdiA8aWRyeW9tb3ZAZ21haWwuY29tPg0KPiBU
bzogQWxleCBNYXJrdXplIDxhbWFya3V6ZUByZWRoYXQuY29tPg0KPiBUbzogVmlhY2hlc2xhdiBE
dWJleWtvIDxzbGF2YUBkdWJleWtvLmNvbT4NCj4gQ2M6IGNlcGgtZGV2ZWxAdmdlci5rZXJuZWwu
b3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6
IFBoaWxpcHAgSGFobiA8cGhhaG4tb3NzQGF2bS5kZT4NCj4gLS0tDQo+ICBmcy9jZXBoL2Rpci5j
ICB8IDIgKy0NCj4gIGZzL2NlcGgvc25hcC5jIHwgMiArLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2Vw
aC9kaXIuYyBiL2ZzL2NlcGgvZGlyLmMgaW5kZXgNCj4gODZkN2FhNTk0ZWE5OTMzNWFmM2U5MWE5
NWMwYTQxOGZkYzFiOGE4YS4uOTM0MjUwNzQ4YWU0ZmQ0YzE0OGZkMjdiZGY5MQ0KPiAxNzUwNDdj
Mjg3N2QgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvZGlyLmMNCj4gKysrIGIvZnMvY2VwaC9kaXIu
Yw0KPiBAQCAtODg5LDcgKzg4OSw3IEBAIGludCBjZXBoX2hhbmRsZV9ub3RyYWNlX2NyZWF0ZShz
dHJ1Y3QgaW5vZGUgKmRpciwNCj4gc3RydWN0IGRlbnRyeSAqZGVudHJ5KSAgew0KPiAgCXN0cnVj
dCBkZW50cnkgKnJlc3VsdCA9IGNlcGhfbG9va3VwKGRpciwgZGVudHJ5LCAwKTsNCj4gDQo+IC0J
aWYgKHJlc3VsdCAmJiAhSVNfRVJSKHJlc3VsdCkpIHsNCj4gKwlpZiAoIUlTX0VSUl9PUl9OVUxM
KHJlc3VsdCkpIHsNCj4gIAkJLyoNCj4gIAkJICogV2UgY3JlYXRlZCB0aGUgaXRlbSwgdGhlbiBk
aWQgYSBsb29rdXAsIGFuZCBmb3VuZA0KPiAgCQkgKiBpdCB3YXMgYWxyZWFkeSBsaW5rZWQgdG8g
YW5vdGhlciBpbm9kZSB3ZSBhbHJlYWR5DQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL3NuYXAuYyBi
L2ZzL2NlcGgvc25hcC5jIGluZGV4DQo+IDUyYjRjMjY4NGY5MjJiZmVkMzk1NTAzMTFlNzkzYmZl
MzYyMmNkMjYuLjUyOGFkNTgxYmUxNjA3MTNmOTE0MTYxMTU2NTkNCj4gZTJkYzZmMjU5NTc2IDEw
MDY0NA0KPiAtLS0gYS9mcy9jZXBoL3NuYXAuYw0KPiArKysgYi9mcy9jZXBoL3NuYXAuYw0KPiBA
QCAtOTAyLDcgKzkwMiw3IEBAIGludCBjZXBoX3VwZGF0ZV9zbmFwX3RyYWNlKHN0cnVjdCBjZXBo
X21kc19jbGllbnQNCj4gKm1kc2MsDQo+ICBiYWQ6DQo+ICAJZXJyID0gLUVJTzsNCj4gIGZhaWw6
DQo+IC0JaWYgKHJlYWxtICYmICFJU19FUlIocmVhbG0pKQ0KPiArCWlmICghSVNfRVJSX09SX05V
TEwocmVhbG0pKQ0KPiAgCQljZXBoX3B1dF9zbmFwX3JlYWxtKG1kc2MsIHJlYWxtKTsNCj4gIAlp
ZiAoZmlyc3RfcmVhbG0pDQo+ICAJCWNlcGhfcHV0X3NuYXBfcmVhbG0obWRzYywgZmlyc3RfcmVh
bG0pOw0KPiANCj4gLS0NCj4gMi40My4wDQoNClJldmlld2VkLWJ5OiBBbGVrc2FuZHIgTG9rdGlv
bm92IDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT4NCg==


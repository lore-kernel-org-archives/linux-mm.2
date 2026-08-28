Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D40AC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B0E6B008A; Fri, 28 Aug 2026 00:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC356B008C; Fri, 28 Aug 2026 00:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D2A6B009B; Fri, 28 Aug 2026 00:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5C496B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:18:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3740CA0380
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:18:52 +0000 (UTC)
X-FDA: 85149372504.08.A471039
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 545D620002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:18:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CVM2ga/Y";
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twnD7z2efGavywFEnQp6NqJcchyCbA0XLbh1RVf0axQ=;
	b=7epNnIAbhbh8W/lEPxj6WpT8v+YcymJ8zesCF/HA/YvVePHVDR7butRU96KzlNUZa9KelN
	b4gi/AsAFtr/L1cTHRcRfN7NH1E3+5IKsRL+zFmf0cx72xwQEBCwp3ZnJvg8EmYNsh0Sr8
	qvNoeMNUh361kNlYTFsHw5Be8MyULsA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787890728;
	b=ahCfC4Hvj/EM6gBpk+0DzXZ/vAyfG+/Foj7xa67AvTkBn1uhtqyvKcAZ29CQPztd0i1+9X
	QYWhqjnIXlvlJ4ZxW/DpRCBrqugm+wj9/wgCqFQpSCcaDhBNdRQUsueOlT5cCWeZgLAoh/
	k90PZm8ngw3+NNcJsyuuzso8wH0uzsk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CVM2ga/Y";
	spf=pass (imf03.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787890728; x=1819426728;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Qk0Pi4eIHu1ZNAuf0bzI0ycwWUKoPHAvkM7mBtkYjcQ=;
  b=CVM2ga/YjIIexeG4va/XbNUvpbTWcvQ71lVzWPtDggy+Le3iL4SC5yFU
   LbfvgsgIymmtmWcIr52Lv9rrTlTDcu0R9oPcv6o173RpxvJmIa2aOzEaP
   9hp+Ju5BwNUFUGZ0maXI5p+9AD6lBddZQg2Ek2/PQwYjH7EttRyAbHmD0
   fHgKm7uv9osNTCYjlGhcwAEPOQBTZMduSRHPbx1osKoUSl551R6OtbiHd
   7jM4C/N79gJeGoMl4fbsvEavOdMHWxqJDLORNlEUfqHrZH+N6FKxSBQzX
   NFsNB/YDbKN01JuVtSzAsMHOyxjZn0t0kf2uQdITspyaB7IwmGLkkubjr
   g==;
X-CSE-ConnectionGUID: vrAZZtOWRYShc8BmAmtCvg==
X-CSE-MsgGUID: 8D6jJgyKT3WsHQwWT1CoaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99747746"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="99747746"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 21:18:47 -0700
X-CSE-ConnectionGUID: 1U2KDw+ZTVWpJy+dQahZkg==
X-CSE-MsgGUID: Hp+DVQaISze6auu3pTzJKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="267460495"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 21:18:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 21:18:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 21:18:46 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 21:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmkRIJqdIdbw7mDhEblhKDvDL0NyKrrIcI6dVw1FuDoKSAeUoWOQoNOTIYC0C5xRXcYQkLKtWpU/Lx+1Pdrh3CZ7+FCw7ojlVFDPNxPp5pTPzuxpM2UloOqBdpuqaD+OYg1pyzOTcL7oCLVtjj/bjuF2Si3dsnx9hJ7CA6AFdHjtPbCJvNdQdG1R5Fkow5Pcb1mkzzrBjph/w1GqyoXCLsRZcpTEON+ECfP9JbYXBMX+76eA03L3zfcGTl7KWKLALNauV7CFiZzzaPqV6OqmZb6nnncPJ0s3etn5W9SEZCPgyR3jc6I8jNdUBzABSR5B6lKQ7ZvAgPN9o5cPATD8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ob2tGK8UfYbjr841u0559or5imoa4GQcI+O/LsAdC0=;
 b=gOVjXFjz918ZpGpcXQym08XNjdsmp5CmP1MT9SwSGykpHHZMdIHuNKzMBIWay+ljs9oy3ZnRIG8AxON7WzlNaU4QWBPcdCYS0uhYjAeDnmfQ0B7bhAf73Eypt02LAnuhUtOsbipco0h1uoVHZXSX+tIQbUAsT0cJn6n52tNh88YDY8kwoBlXS7rnIJUlKu5i+jwDRBkSgvim/5QeiNYzX+8zIQk7SjqPZioiYLh7MAo8L+NcFKXLOZlTuQlx80fmeJzURju6IxNzu8nNelksc3mFhoadf7e4q13aryWu7fj6ka1hukqPTVeIQBoeJ0pjEdhtQY7NAFclPVOeEuKxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS7PR11MB8781.namprd11.prod.outlook.com (2603:10b6:8:256::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Fri, 28 Aug
 2026 04:18:41 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 04:18:41 +0000
Date: Thu, 27 Aug 2026 21:18:37 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Sashiko
	<sashiko-bot@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Francois Dugast
	<francois.dugast@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] mm/migrate_device: Do not write past the end of
 the src_pfns array
Message-ID: <apEMHVQwZc5ONwvM@gsse-cloud1.jf.intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-3-matthew.brost@intel.com>
 <4312740f-2aa2-41f1-8442-d4a80682753d@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4312740f-2aa2-41f1-8442-d4a80682753d@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0197.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::22) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS7PR11MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b096eb0-11b0-4eb0-1a7b-08df04bb70ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|18002099003|56012099006|22082099003|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info: RWVo92UCM6gN5OkQWQl3wF9mMWPVwCW4WugIgxXrXqzzaSo2ovgvdpZBdz3yovR0H1Wj9VBkphU5VaPqIg2ejivyAi1ou3csB5t9OpHfxNqqlVrKKkzmOy5zFIVJKxGd9DS25GcYNyC7+1MgNJhq/oPOrzfy8nnqP8b6OQqdcQ9zJgBUbtiIwUXJbUL5ZN2/7PL4fsCr8r6DuZNrrL+PVxDCIXFDC1wtOYlPK5F3iYJSdOt/HC6HligZg4W1ddUfdRhgzmhZUZMzDIYZzFNMgkN4swdM0N1jb0dN5oWQuewtemA7XXvOwulw5CPPkN+pHLV/sqBuj5MhuJ3L0uQyWVvZky5KWvhiMyEbf/o6K2cSggaPUcUsIRUCkli9Iv6TGvuR1vaN0302dNv5KSVyUT9r9pVetsC432d5YItirUS1/0RGCYNJhmj+DxDI3YmISIYj23njUnQvTCsElcUhNhMFc9/PA9H9r5yGjIZq3MjGx304R34AWChZc77LI5zC1rPeAFjeKpwK6Pumwvb/5xvYXmcCJnYWFsWnG7Rp/+LqFjs0fGvFazy1LHgmfIc4px9SmPImZ4FD1UJB+Azrdn9cDEbcaNYca09BTCxZKN4EZqcETFFjgIK4ImjyP4X5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(18002099003)(56012099006)(22082099003)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EIygY2CMAWqaLUQdz6Zid2MWm4i+U9Tqoem8rd12cHxmajcUjBAd9GLkBr?=
 =?iso-8859-1?Q?QRP0YFYtLqCJFvgJIpmyWZvqe12ixum0HUNTaX0Pl+VFDoTxBGD5dPPzco?=
 =?iso-8859-1?Q?AlW4QpKrwsR/mEQtB2Y5wKAYX4DPBYKBlvarTPBNrmFeLYsAZmXzoc+iTk?=
 =?iso-8859-1?Q?x+l4hk5YPFOEaBUIfd5DffSMR/tLqjVMt83LMPknpCTM97BM8s5lKQubC0?=
 =?iso-8859-1?Q?2AAOzZaRBNPXxQF/236QGDoiGpvpFDuof7e1nPdTEQoegU0zMcwN0pKmJk?=
 =?iso-8859-1?Q?IF3a8x8uBSIlRe1E96QojH/bte1VWjm0TFCcqehFCNEbyBFZ6n9YFhoyq+?=
 =?iso-8859-1?Q?SMVIml8+gqFMVRQUnB36fHnvs+9gVlqXc0c7I3G1Pgf9gr91/YZTrSm3j0?=
 =?iso-8859-1?Q?61KCPOCVdVyGofX41fDztTsk2+IKn1EP5UcEqm8JBJrhEv8gmnBfxfLPhi?=
 =?iso-8859-1?Q?SBFIatqdL6ozwB4ce2GG+g9aGnKraUQZ6i4tcFxj6TJv3ticY8bG729Zqe?=
 =?iso-8859-1?Q?0CZce/GOcIH1XPaHDLtEgzFmqgfyUYDC48+8DYpg86YBulxr1ba5mnOM11?=
 =?iso-8859-1?Q?ICdonGm7EdtRPX54dwb2c8VzhumxvaNYPqEk4VaufhdHrTSVWRAPGFuwkZ?=
 =?iso-8859-1?Q?xrB+Tbnprc50jmgGTrH8335UBgv9c78gMfpsZc+2l/ZUMEfbCGDM5C2UZA?=
 =?iso-8859-1?Q?PjmZDnoJaRRW5jVs7rsaCCvNRmkgX68b0us7WEKoh280roM6VUpevHFupy?=
 =?iso-8859-1?Q?6IwuH/M7kXqA8x+JqLuBxInUPz3jB6oP0003Vaxx2IYeENx1FdoYAgOgXB?=
 =?iso-8859-1?Q?h/0Xfi04dRWc4r4QdK2+E86AmPIc/SNHuaDlC/YEaxCdkUpizjzxkcuoZg?=
 =?iso-8859-1?Q?ITuYN5cSI++JHq8PN3WZ/XMHVpFtdan48cHyTyxXzAoF/YzuCLy+WR/6i/?=
 =?iso-8859-1?Q?fSN0c13Kk/EmC1bh+w4u8DkzjzDUFZTX5+tvtpYwKbgh9CFyusllE5MsUQ?=
 =?iso-8859-1?Q?YFy0v8iAwGpCzw0AdMYHiwlKDM1YmZG2Y6A6S3ReLuTYcD7W8guU5HirN/?=
 =?iso-8859-1?Q?wi5xWRPGeIqXeUkYO2v/ynHb+I2caLjB9iAVWq0wTJBRhKRCHkMbnm97/p?=
 =?iso-8859-1?Q?JnlHnJVvSZR3Pmm9s/WH/wzeMCOjXMU29slbKeulpn3IOXK7Sk5T5BdwlX?=
 =?iso-8859-1?Q?wJZruWnVtESLNbaCh+LalbcuGK7J4jAl0tagTnhZCUyMNtj2oe5DCfzYc8?=
 =?iso-8859-1?Q?egdAV8Zdo5Uf6j1RyQ6RG38Z+cAY9IOIjId/OnvEmH8YWcxgWFzmH2cXZo?=
 =?iso-8859-1?Q?qLizCrjyRMvFFp4IPBB8hahI4Q4dxmS9Rzrpi9HhebUPpFknqEL4wmiZse?=
 =?iso-8859-1?Q?rtPkZT9xt0AXNFWgOIpcbfFNUMqrB0AX44QwFF+1UkdrRv+CT0oAVlLPON?=
 =?iso-8859-1?Q?inkmgsDo+qweVrLERyFNQ8FS8sH38iSugdU1V0kLVvET0XTmjX7nzs/n/j?=
 =?iso-8859-1?Q?oEr7UDwRF24oHGqiUC9l3W4qrW7GLNh8HUqgrqSfw7lYgs8WkQ1+k9kU/f?=
 =?iso-8859-1?Q?nBTOtlVrZftN9f0Q7HipNgvkVSjyg8W7UD30wpeywdKNtOodzY4eC/pfWj?=
 =?iso-8859-1?Q?+cU3O31ae05dKA2VYN6l1JvCWb10Q7qQt9mLzHkdVpFF98ChuBp4hqdRse?=
 =?iso-8859-1?Q?HMaNmstF4apXBFwS+pDYaEQF7qUD8sOJs7OqsAmi1/Cl+8XxVN/ERBMsJi?=
 =?iso-8859-1?Q?CDazBsFu1gkoK2hweextKcjYilVuOmsafsMr+e992ISvtm2PRfQzuDiaDq?=
 =?iso-8859-1?Q?PRg5oyFvzK9MVgWscXiwxWB49ozQCXc=3D?=
X-Exchange-RoutingPolicyChecked: MPfuFKj0EU21NRwvzeo6cJFCHFj3+JGby5WZoR7xPXXa7VMRLwX/mAzcuIxUtxeL724SgwguXPVDy/SNNfwKP6ICf0hSPgV0qCvgH7TKjIbNcrFhqLMAEM08OXI4YOE9V+K5oSY1oZtrcLUAGz/ESzlbcf9hdd7PRe51NH3ru/dtK8ouic1q7yfkTK02Q1KPoBa9ry0T6PT4co5FImRMIFqeYX7mhmYeDn99ND2hXa3n1UFyOSJB2I2C9WnkwJB8ENS9TXMVmEIRDq42+iKzagasrRe6aMudvUA0gGLo2WuTeZmVsEDKrjJFGWNGlde6MA7dB9y+dzxn92yCV8lv/g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b096eb0-11b0-4eb0-1a7b-08df04bb70ec
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 04:18:41.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSHtYCn/xl2zXrNKqNVhqiX6mLzOeiamBrvQBHKNLcLWGNWemthVdPHxzuL9jckcLe9UJw3nYpa/vNAwzTKnng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8781
X-OriginatorOrg: intel.com
X-Stat-Signature: u6ngd7u7k6yoy11suxf9piwg5odryb7c
X-Rspamd-Queue-Id: 545D620002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787890728-254983
X-HE-Meta: U2FsdGVkX189frDyY5fWr1eYs/kPw9rkiQ9y+ppfrd7TKVutUvTGL5R2v+4xsAjRsV8gz7I8Np/BsxoVsTahd51t4Fla+PEvT6SOgYrA3BLg84TTea4hzcHFTk/m4d2UzHGTM7Q7XoJ53QCpB9IF3jz7BUmZa4ZgHyZzQGE55YmxntLgdhss/5mQH+Yvctd8tHgo6IVW4bL8UxuYL/8IUJoUjpxdmYkMVOu0Ykt8kUUS4EBq4GBCUdlPjPVCiPCTNCqI4LwknZ5JNwSl7uvouaOHn3QKYJCNd+MP/aN8hBD/ZyuKrX8Z2fKj/fkd0WINfDN+LXYILJ+kgTINvAThV+CgAppkVapXkykwEcp28O5jdsahyx5huoL2yzQmac4PBAql70v+kTPNs0AaWIjWIFxdKyrBUQcXRbXlQ6VZOdJFikG+7VPyVI0eoc+RPFQGLk5A2tivCBRJu1s5J6hYNsQGNfZR4fnhjAgYRPkzZ0jQHYx6zsnh8L1BWcTHBSDIXEB74ansRrnSgU1BBvuL0VDGr/FLoTAQ44NH0kKaBwhUz4xEyK+1Hx80Wao6X91jJzQNuibZDmo2o+OdbENyUrrDp4IcvTkov2qylRfoJhcOVc9uGC3aQNkNRl1YdUvUn3+CvhISl97bvGx9lUxWzV1pO3asQoeWl1cELTgDxxoHNdzvEgFR2Dgmzy1G2nvUa+vA+2HneiUZOEyEuVR6FhD0YjBTnRA2rg3HahYC74a+ds1WuPdCm8vpZe5E2jx1DuwZoH6jdd1AaRniFoY4iLw3bEPl/MuRbB/7PzoptSuq4xkaouWwoPzAekoF19fVDBHmP9Q8UZm+JuDYicxNcoDoC0PcWw3a5tjHMsbHn2xz5q9iMLYZaw9vbwXRQzncc1gf0zoPFHeKrHwcp4Qeqqwdezz1b2ut+O0i8gafHpM9mcT3j199cpnZbmMq/9SlAhO10Qk+kDCT6OH2BQH
 L53u+vZH
 XdY5sfYZ5WVgUe6QA4WYIR7QiiV4d5u0+Yndv6r14BpntjxiUJwXffVsJY1DRbHY9qnKae2CW1qXVHgp0ZwLpY9Izg0RnDnk5deH4EgCdQxuZ0rixrsZ4wtCftRgLm0Wtg6QbqQELMQY8uuIY2hNsNr9IIJrs2g7FqBOwValsYWT5SWwypHD0mmM3r03PXYXCjhUXievsTVvlfbGQJMy2sI/SvVriWedEYo0E4EaNkphWcV/KnkNbYpIBn52o7uNZdwoR+Cmco2K2RhVQcBT8ZYnff9irULQFcL/8ZgPXV3zp5Cl153GiYTEGQJWkYmcl8Q9nmjFzf35m33z9NtpHDofHgIv8yg7/kYcXagauZNsdf7VqnEL6HnanbP3S8zNytYqZ0bWil8Cq+VxpIntdf8xqJcBt0VrHQXnz8tHrHaZcN+zH2WvsbYcKYL/jTt0z0dnoqy0h8VwzxuAKE9rnuqWgaNrArtY3FKH7fiuu2zP74kJB8CBy7zPjmI3Vu9Fc7TUe8vU4aZQbMLdn8xQZh20DyGGrtJvkiojCONqJhBLI0rTONK+ZH3opEVEb4RZUnXsOJ+ipV2aR5sU8XK9OAWrLDL2A8kFLtN4svM6LWTh/XCHAMaJeg3YWTYKS/ojGzTgRaBDn5nRfJZ1WIItoVGSgpt2IFM9f8gcDEZLPBsVeQSYWFdsoaRPx+HEfLLd1VsmTCDX43h9XDUkGI7vLrBTv7n7LUS+U/vF2fG4SYtHDID5zox9nP3QpFBCukMIHF4zpejiky2TqyMuscGOpZwxSZaVVyZyXn/n8EJfWIBjBCqHhzcr3xzIygIDojBgHokW//sssqhKtqo5cBXd6wM8pG4xoYmilP8cVulNhO5mcaY2WMKbPk8RZjaBN6sJLkqgVCxHuBXN6Qjpi7f6kpBeyhSDjaS0FC/LE5xHs7s5Bi7JJBAKGDQSCOgL5ATka5K0WxF1DXTjynYYi+z/rrgBNK5kk
 +9F2p3eP
 +j7IFHfvcp/5rnpDJheUVssecJ/wXZdIZmf+51VQeDmAC0HhjdUbt98DrHDCeF0lE6ASxYdRHCCmlamepJrkTUgJsRiRA7xC5KDkdtBzTMRbFSovOMCfCGObkrVo2Q94aT0TPJZWbzWr7B6pLeBEtdcSPhZaPaHkGfKoEzgFRZoyrGoJj9JpBSQE8qZrCXDQbblR6jII794kf+/LnWqFeO79DxO408FwlnBNkZQdlnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:05:09PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 01:10, Matthew Brost wrote:
> > migrate_device_range() and migrate_device_pfns() zero the tail entries
> > of a large folio without checking them against @npages:
> > 
> > 	for (j = 1; j < nr; j++)
> > 		src_pfns[i+j] = 0;
> > 
> > @nr comes from the folio, not from the array, so a folio that extends
> > past the end of the range being migrated writes beyond src_pfns[].
> > Callers size that array for @npages entries, so this corrupts whatever
> > follows it.
> > 
> > Bound the loop by @npages. The subsequent "i += j - 1" still terminates
> > the outer loop correctly: on a bounded exit j is @npages - i, leaving i
> > at @npages after the increment.
> > 
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Liam R. Howlett <liam@infradead.org>
> > Cc: Nico Pache <nico.pache@linux.dev>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Barry Song <baohua@kernel.org>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Usama Arif <usama.arif@linux.dev>
> > Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Cc: Rakie Kim <rakie.kim@sk.com>
> > Cc: Byungchul Park <byungchul@sk.com>
> > Cc: Gregory Price <gourry@gourry.net>
> > Cc: Ying Huang <ying.huang@linux.alibaba.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Simona Vetter <simona@ffwll.ch>
> > Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > Cc: Francois Dugast <francois.dugast@intel.com>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Assisted-by: GitHub_Copilot:claude-opus-5
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> >  mm/migrate_device.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 162d29b2807a..ae9027421b80 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -1415,7 +1415,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
> >  		nr = folio_nr_pages(folio);
> >  		if (nr > 1) {
> >  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> > -			for (j = 1; j < nr; j++)
> > +			for (j = 1; j < nr && (i + j) < npages; j++)
> >  				src_pfns[i+j] = 0;
> >  			i += j - 1;
> >  			pfn += j - 1;
> > @@ -1449,7 +1449,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
> >  		nr = folio_nr_pages(folio);
> >  		if (nr > 1) {
> >  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> > -			for (j = 1; j < nr; j++)
> > +			for (j = 1; j < nr && (i + j) < npages; j++)
> >  				src_pfns[i+j] = 0;
> >  			i += j - 1;
> >  		}
> 
> What's the status of this? I assume this is fixed by
> 

I don't think Andrew has pulled either of core MM patches in this
series, so we can discuss a bit more. 

> 	https://lore.kernel.org/20260817120758.669807-3-sh_def@163.com

I think this version plus your suggestion is probably better here - we
likely shouldn't hand back compound pfns which don't overflow the
requested number of pages. Let' continue the discussion there I guess.

Matt

> 
> instead?
> 
> What is the right direction?
> 
> -- 
> Cheers,
> 
> David


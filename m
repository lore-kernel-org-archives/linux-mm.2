Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E119109C038
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4676B0005; Thu, 26 Mar 2026 03:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E9E6B0088; Thu, 26 Mar 2026 03:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8036B0089; Thu, 26 Mar 2026 03:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9506F6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:39:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45257160C5B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:39:15 +0000 (UTC)
X-FDA: 84587413470.19.B1FF2F1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E31580008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:39:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=isWb+gTb;
	spf=pass (imf02.hostedemail.com: domain of yu.c.chen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=isWb+gTb;
	spf=pass (imf02.hostedemail.com: domain of yu.c.chen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yu.c.chen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774510751; a=rsa-sha256;
	cv=fail;
	b=vnbEtTS3UQ8UmDayTR18prkiS19myrbxcadtD6D2TMC7dnAaxhHsj47/1zs+/M180YSgmR
	q1FXD+BmtWdFchUhq1i3nub0HjM//y0twy9DKRkht0JlZFQygoDBtMOPjVaUNEJXjRmfnw
	rqEKoBrRicOjHciwmt+uVgiRMr8yeks=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774510751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hE3SmS6Fagi3i9nAil+QkqeK9MdBhHeHvW5wZCOj+o=;
	b=E0gAPm1LKc264b4zJslzipMBqOM7eBmbbTN18hlDR7sTLFk4X3DRxxv4GUQVLIzqRXWEVd
	SupfoXk3BJyIwiUmfQ2j/b2688+xkBZmzO7Kl6Rd8oKNzxXy+abEUleKtpRPlkv5R410/d
	m6TJTieLlbbEcaIc1z6uSwyJEjgb7Pg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774510752; x=1806046752;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KPDBb4qeELZyhzGe8rwD6/KBWxiNlRvk3Y1vAs75o4s=;
  b=isWb+gTbvkW/vEnwdgThtt6RwrDaSWVPH6dkAqJ+vVqnBhY1awkmEg8b
   UOsqFT4aOdAFneZ0hS+v9tURs1HYilQ/Bq3YgohlY453G+qZPgbh8lone
   xIjzJvwDfg+nLuqKqWuLA1p5s46JGz+vrE0q2SN9xwx3vZWuubtDYfsQJ
   1fTbgLBEO+DgjVUACp8t4l0g/G13vssvFfxihM7as4dKbFsnMdgSFz3Vf
   G3vSBYL5VL2kuBYv5sjjnSWBIg9nEvY4HL/WWg8a7Gw2jd6IhK5Br2U7k
   nxq09TtsZzyFyT7RmXNVsosOtnRFFdpapzfHA+itFPCcL0WiqdxqCeLht
   g==;
X-CSE-ConnectionGUID: kjpOtQquTLyegClqk3Eivg==
X-CSE-MsgGUID: ktCz2vMMQFa6cQeURgi3AQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="85867508"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="85867508"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:39:11 -0700
X-CSE-ConnectionGUID: trlPQN1MTaeee7ZX0vIm3g==
X-CSE-MsgGUID: GhTPXIo8SE6Q5D0+VQ0ihw==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:39:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:39:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 00:39:09 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 00:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejDcRaXk9JxR2Ak3mrogDdFo/WIocFtDAe9GDOYk3dzUwDTqLJMXnBm+6jlWB9bAk6O6kSZzYyNDjcDOR1BZLq2SzwD/bDMok4TFVG7J89w9Lg7sHFnaKGunljMpNoEjKt1f9FcG7arYHOU9/IFuKIebYYWtJkKwPrq+Avj4Ue0xX2WsMCpwnIsruhZM/v8fxMma8HB6Ld4hmwblEsIZJRWL81Hw6WMByMyerMKbIpa+uoXi3ytqFESj5JWfTvONyzDzM8zpZPLDK3gwpr8w89DH5W+P70aOYON47JCs2VJ54GdH1VmxS12XhkL7DQrGavucngwYrAmqtSyyIngOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hE3SmS6Fagi3i9nAil+QkqeK9MdBhHeHvW5wZCOj+o=;
 b=Vhpz94RvNuY7/FTdZv+wDG2aSKUMYmuaS74bBILuELlem5bmImpFU7xB4CaLZS2FkbDU2qwoYisQuXAC/uQhSq9aa1dlN91WoiHVOYCZrUVZ4E2tAPIwwArFjDGgS/7oY7Zy+4nyrjvBqjJ4hyjZLjOIRz55FnWzkqa6h3xfLQ9AUcv66bWLGUTFMYWEIDDx59+dCmEZEHrRyoMvPcxrjHWTbbu+YgYeCkACyDl3Jw/i8iJHFx0HskKJnxLTS+ZYbosTGXeubu/Tc/m0QmIrXwZz8+U8zbizf0W/qPf8ChOCMv0Hyj1hIMC4titAyX0VTHKgRLmqS83SJ466i65OqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA3PR11MB9328.namprd11.prod.outlook.com (2603:10b6:208:579::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.6; Thu, 26 Mar 2026 07:39:07 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 07:39:07 +0000
Message-ID: <cc8ee2c6-a169-4cb1-9c16-e76ae08fcc58@intel.com>
Date: Thu, 26 Mar 2026 15:38:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <acEkfaycrJI-kWjk@kernel.org>
 <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
 <IA4PR11MB90092536DE2D9DF404E3B3EDA356A@IA4PR11MB9009.namprd11.prod.outlook.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <IA4PR11MB90092536DE2D9DF404E3B3EDA356A@IA4PR11MB9009.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KUZPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:d10:32::10) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA3PR11MB9328:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d9909bf-8ebc-4f6e-a55a-08de8b0ac2db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: /J9yy1bISlM7PlXixtaMw7t13DrNiXpFDAUJEi2F3IgJEFb36vFFM4q6S5f6FcplQrjEmN/2+eximEi0Wgq2SMS81AQh//bpqy2q5R8bQuyr0Hbg8YWZ4PcCNn/QJxLFYwDY2FB7NFkJsxyWUayO8mZ4ZxHy9gwnciJf1ii27gXpd964EwLabeh+RHcTmw3wBrkxcM5LCzX8+SRXliEblVqKHFH7iw353d2T6fPpb26aNQYYQWD3uNBQ0rHba1OFQunBGdpLeL85JT7CdyPLy1I/GMebaVQEdLZUKgKNrddvqhbwIyaHOIgYL5scQ1nb6Cfaia2CA/upwDVKuoexPrCWwhQLL3HyTF4l7onGrzipHfNHPDKRbiG35PrvXWZpFslkqoTuzr7uE/+Q6tMcVqDdkiLhGcdQPsH6YI64JQyPsgpUf4fJmPzyV/RE+1qgOErmSDkWcwFCDNuuejICkzYmCuU/IxvxfM8VHJzq4C4666ce7sLWx6pHDl0J1G4kyxhX7tw3sV1IoTte1w7YjgdV1Kj5gTmMrCQoyKBA64Kn70Uma0Uo3wzXSEYsFV6ti/jvQN5O9sNa4U6VesUUvE8KTLYVYVmmWkm92uKjOBFqIa/eJthWz59hByRWTsHcNq5kh7/TwCsMYNYavley5VU9k2EsO50Ee0xdX3+wwFTFznlMcGFo20WY/dnfoxGqv3ov3liKuoUWjzX7IuTcFdm2VU7Fv02e+G04q9HJ2gw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cyt5dE56Si9iRlROWEYxdWlmaElsZGdEV1hYM0pYZVUvNGdkN29WUXNKakht?=
 =?utf-8?B?aWtUTHBXVkhmM3R0bU04THlUektGUWxzTWJEbTUrZWlKc2wzMXVoYnY0Z0dr?=
 =?utf-8?B?VkM5QU9HSzcwbVdOVTNuZFRVK3NOUmZ2Sm5KWG95SWp5bXg5WnNKSUJjMTNK?=
 =?utf-8?B?TEIyK0UzNWJGV2tYWjM2dVM3Qm1RRmU2c0gxRks1bHh2TExNQXRFdDdDTlgr?=
 =?utf-8?B?L3hHZE8xTjlkRUhRclRHcEd4ay9aL2hXZHRoYkRLVnRHcGxmdnlVNWdneTFT?=
 =?utf-8?B?T3RNelhzM3RwbXlQSFIySWYva0NZUmllNy9hc2FxZWx2aGorZ1RaL2VuaExP?=
 =?utf-8?B?ZmpmNWVXdWppa1cvUHVvdyt3WEZWcUtjYmVMc3ZNaDR3eGdJRHN3b1ZJaWhJ?=
 =?utf-8?B?TzFBbUdaSVNDNURZY1VPMWRRWkdpWUZiWWhDMURJYTd0dW1BVk0yY3Y4WUJo?=
 =?utf-8?B?Zjk3VVZZemtaa1VySEtXUGg3L2FYc294OVBVODZHbVQzYzJjOFQ2MEVOOWw3?=
 =?utf-8?B?NS9IWWRIWkxONUxUZ2N3RENJQXB3aGVjRTRBVHE0R1JTRkNzZHJVWUVqZWMr?=
 =?utf-8?B?MTVEcjBMS0ZlR0thT0dXMDc5cko1MGVQV0Z3NE9pYm4xaHBLM3ZHSlhaZVg2?=
 =?utf-8?B?OVovSzZPWWRzaU9MS2JkMnNZQzZzSWNmU1IvNGVrditCcTgxczhHNkk3Wkt4?=
 =?utf-8?B?T1JPb3JDVER6aVJZQlhoV2doL1BCTUlZL1lucXFpNmtUeTNOaXNMRVNoVlFp?=
 =?utf-8?B?NldtZm9pYWhWQllJQkQzajZ6UVhMWkp3UmFDZTUzUVBkOUg3eGZkWE9jOFJX?=
 =?utf-8?B?SlFZMjQ0Y0FwbFFoTWZvdFZ4TkRKYzhZaEl4OUZRWTBLL0hIY29nQ1BYOG8y?=
 =?utf-8?B?RnhaT0pBRytlVVh5cmViNXRIcHQ4SEt4QVBRZm9qK1NpS2Ixckt0ZWdscHlP?=
 =?utf-8?B?TVMyQmlSbVQrK05pSkNZQVA0Q3VpZVRvblJpNGdaakxRRUJ6Zk55MzhBZmdO?=
 =?utf-8?B?TVp4bVdIcG5sSkt5TTlxNHUzZ0VWd2hRVElrTGtUbmUwYVRLNGhmdUYxK3NN?=
 =?utf-8?B?eVByYzZjWjRWSEorRkdZRVFOM2k5VzdRUE1xU1I4RVRkVHZVN0EzenR2UXJE?=
 =?utf-8?B?dXNReWlQcmx6MnhSRU91ZDIrSTRkbmVGYURsMGU5UEtqaFUvMzUvOVRRYkJx?=
 =?utf-8?B?TWYweGxJb05yQVBQYnVGM0w2L0ZzQjV4L3gzYTVobVI5aWhleDVKelBUcGxJ?=
 =?utf-8?B?cm4vdHFsaXJjZUlpUDlvUkM3NzhVMjR0VWM0Ukw2cU82NytVZGx3ZUk5VnNK?=
 =?utf-8?B?T3N0STBESmZqK2QzNE5uL1NKaTgvV0hrNG10SGwxZEFhMnJvSHh3YWNhTUJJ?=
 =?utf-8?B?SGFuS0UwaTNsTzU2Vy9QTHdKUHFuSWhZb3ZGVHo3bmtXSkZGWjdkMFAwazBh?=
 =?utf-8?B?NkVwKzNNVXdvRm1qbEZqdDVPT0RVdUdkWUl1NHVVaUEvTko4a045OGVqVzFt?=
 =?utf-8?B?T1Q4YlVMUHR6ZjdscW5WeWx3U1FWM2l4dTNBVkFrMitBNFVlckZ5TTU0TmNX?=
 =?utf-8?B?dFplYkl2Q2NYa1FPMytSOWRzNGswTlBQdDVvcXN6bzJZYkpnK0JxdkIvMTR4?=
 =?utf-8?B?VzlOVCs3Yld0S0dkcVRpRHhvUVhFN2Zpb0RZMXlDZnk1T3RTTUVMZjdVT2Ew?=
 =?utf-8?B?c1N0NUVNRnBWRGZ1RFNHT1lvcTZQQXBrcWQrQW5QTWMvazNDbk9oL0daNVZ3?=
 =?utf-8?B?OWEwZ1NLa1pKaC9PVncvZElJQUVmclhYZzI3RlJRNzUxanM1ZXVsVGRMRHp4?=
 =?utf-8?B?MURrekFodXRjNlJHa3h1Sk13Y3BTQlhoN0M0MEZKNCtqSDNxa2hJNDZialh2?=
 =?utf-8?B?U3hqSnN1MEZwSU84SXljQ0ZnYW4wSmlhVGd1elFTcnBKZEtTUHUrc2NrU1RD?=
 =?utf-8?B?NWQraVprV1NFYTIrbXcvdU1pR25GS3VDSXBZRXBmOVFlM0c4WDhxOWUzdVlz?=
 =?utf-8?B?SkRWNUU0akh3NFNWUlNRRHZDMGdGbXJTbW9MT2hDZWdmTFJRTEh1Vm00Q2RU?=
 =?utf-8?B?dkhxNXFUL3Y4UkpQRTA0SzBOdG5wRXFncGxhRVRhV3U0Q3ZFblBYaTZ5dG9h?=
 =?utf-8?B?UXl0aW1IN2hVcjQvYW9LL2lGcXlMcGFTaGFFTjVJVDNLOFFiQ29kaGlBYkQ5?=
 =?utf-8?B?bytEb2w0eVVMdkFPQ2tneHZ2NE5STWk5MFNRU1A2TXgyU3RXb01nMjdWbTVI?=
 =?utf-8?B?ZFhaOGhwQmp6dGsyUi9PM1g4czhMYWFPSGpIQ2haRnRPUXBRT01HQTNpL0Vk?=
 =?utf-8?B?cytUekE4Q2h3WDVHNEFyMmVpUlVqWnFCdlJUdEFLZkd1KzFOQ1h5Zz09?=
X-Exchange-RoutingPolicyChecked: ONwjtXwwtV/nZ5nrc05WCBWaqaPTNHWvUT05+MFHaWIOx+Q2xcfM5zOFsQPf1EamBIl5pGOoBP1BRm8/hZo+KVFJ8BcLgi65dDPLDoQ0kD+g09HYGb+BXvQYY4yXQ4nEeH2v5m0Y1qaR13kG3bK/xzOvu3+An1wt6CO3i5YRu1JvVjca08ufUcklmw8JcSEir1Nw+ZdxwhwHvvyuFbz9l96ohvBRbjiu1ZXNwcnAvYkvbflPA/n2X1HaVzR9g2oWaxeTxNGB1LSb0wlfV5ymwybNHsfbWq8ScbHiJiYraAfJ8mihL/WWdQAJBLUQIp5EmXPGeCsTnBb9DiZygSWw8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9909bf-8ebc-4f6e-a55a-08de8b0ac2db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 07:39:06.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCMPk4hoXct7sgMJ60udl+bCx5HMs81f/6auLQlOnY1yaTxajv+DOFjiowo93km0r3S2EhFHdBB8/eRBJcpWUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9328
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E31580008
X-Stat-Signature: s8g1qe4ean637t93oe16ufegqzn6mbtd
X-Rspam-User: 
X-HE-Tag: 1774510751-550993
X-HE-Meta: U2FsdGVkX19gTST7/JZMHdjL8ka7MMts2eEZsCjaS/Q+L4KRj0D0MyHRW5dT+MiwPKEN0Czx2Y9YU7hA/McV5kH5hIVx/YufHDuWAeitjrEZn+wY7I4Gua6pGjDqYuFEboEO5omQVccvSTHkK2PyToJBRA35FcyVswbcNF/bCs84ZPKj9l5KwMpygyPlwefUffSRQDDmcF6WTeyige7noa0v89gbui5XyHk4LDdDXC7ZWPM1QrHNijbKxOkHMnTyxw7syhKj2hmXuTPiyigZorE7rgXnZFzAivZnpDn2gXnm9h6K2l4ny4tGrCw6iymxCh3+JejOaWzB0syqe3AobjqMKERL/NuMvU0Z+1Tt8lG4FH4Kwq9T7qv5eN/+MYJRk+T84YvsV1FOBdRyX7/TEXNv358JbSocTfnbPrAtN13L27SbTwqHW45uDWDVFLCr5svI1avI4+PSVDEHmXIXzxGzIT8jFOGuMy7fHApfXLBivzYh/KltgvQQDCud2olgWKTJXt4JnNZ1en1PEjD9Wcr5bBGXKLrJRvTa7S1GrdH8oUniFFBLxk8OAlVetIWpGM0njMhkZbvTL2cVlHhCqvTLl6CsiOqzQ3DCjfVAq6AzyToj1HSPrvtY9/9gjh9Sy7fNsjvAe5GXf3Fy2LdkuPizeMdAcXke7oq/6LpiNVldPkq4HL3EItnobX5MDvHByMfj4e5caz1MUG62EaXh7qiqhtSUNRb3m4l4GjhxN+y7Qu34mokAO3v1zllbRt6hzSKA+hEqpNihBLPWnjOM6mEa65DCZeWDi3HmR9ceHpqGWutBtQeWzVrwY+CdD6Y9cXrAAb9Pwq1zmRyE64bIitLHcbUSykGhLRLx2BuHAariFUu+9G52B7Wj0yhzZD6OL6nKu1Q5i4ZXCHsEhWCjdwXwDUkQoR99vvYVu7WMVDpot0iwBQjab8BTbHYUZ0BWdqJJ4vXH8l+20U0Pjp4
 5RI+WtYL
 xL6xtdnUki1i2FmigF91RcVZOBPjHLhDskdPXpr4uFNivxFzFq9kaZuaWNGhe3+NjD3EL6QZrpYlC/GCGCLMIh7ZAvd1pG1d+FgW4uX8IwbmJ+XPaWJmSvbbThnMP3sWq34JHizinuOTm5or2Zjslo1VWoIg9t51v4gnHC20ufE6FgPMmX2jBekg2wgUoiWFu74ZAKYKXftOmnS/L06yEOtbW6Xu2lNGtLXEhjbdFrgWofq+at5hC1WM1QXohfgCT3zIbBZADcqZVMcWHDprKXk77mtAJ2miS8tEp0g/ufRUxjJ0P5gkIeiWyDcAxwW2IjQgOqpiFwVY0l8v8gw+dMuI2XogiAGXcHucA8KnQVf7blyoiYpUMjxNPnJbveVT6aD0wFRwW/BisKBDuo+UdDVYTHgGIgcRxjATAdSdtyrgsMX9wzL8PIj9MGh9YubNs7FCVFCyG00pJytnH69DbVZB94KNvOoxVvgbJUm26FQJQLnRiI7AAT91xGKxSH9hwUW/j+DWzNthnMOvGbX2/rUraxfiAr7gpileb3dzxyRG+ucGBMppGAdn+e/kJnTVtmwG8HTBIzVwKHLz8n66SlTx93A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/2026 3:30 PM, Liu, Yuan1 wrote:
>> -----Original Message-----

[ .... ]

> 
> Btw, can we introduce a new kernel command-line parameter to allow users to select
> the memory block size? This could also address the current issue.
> 
> Test Results as below, memory block size 128MB Vs. 2GB
> +----------------+------+---------------+--------------+----------------+
> |                | Size |    128MG      |    2GB       | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |       3s     |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |       7s     |       81%      |
> +----------------+------+---------------+--------------+----------------+
>   
> +----------------+------+---------------+--------------+----------------+
> |                | Size |    128MG      |    2GB       | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      11s      |      3s      |       72%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      7s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> And I see the UV system has already this (Kernel parameter is uv_memblksize).
> I think if we can introduce a common kernel parameter for memory block size configuration?
> 

Is it possible to turn uv_memblksize into a generic commandline 
memblksize without
introducing extra parameter?

thanks,
Chenyu


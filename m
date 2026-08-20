Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8825BC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF276B00A6; Thu, 20 Aug 2026 09:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7D56B00A7; Thu, 20 Aug 2026 09:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5B26B00A9; Thu, 20 Aug 2026 09:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40B016B00A6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:21:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D17080148
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:21:34 +0000 (UTC)
X-FDA: 85121709708.09.DF6147C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id 443A8C0011
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:21:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aRJrHpwt;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787232091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wcu4C3RyuwGr0PkgRmgBS5ekGUg7V2uXJgWrRXuNcOE=;
	b=7P+0Qlqh6OgzChzdzg44DISzcNOpUo6dXrn1EYpBzVtPCBmCQF+H2EzE9d+94O4vZQRn9U
	h4DMkyG/RprsQlzN7MPSCEL3DstbK1y5AiZg38jIzO7w0N1nEx9Ufpoj7DDMqxpU8YVZSM
	7RIDMvEPiXTxnzqd2Xnmmt+CRTXlTPQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aRJrHpwt;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787232091;
	b=5efOf41cQW5EaMnZgqpSyjcrNk3xKgbzLwLWGoCEqkwG+q+AxV0NP/pf9/nLp5/hCfAUjG
	MeWeFrQUTQFLRlZ7xroHZx6y6dTogFZ3mJ7LhCHEbmRvpaYsEvqoFNxXDkPCRb3LAxvmTt
	kd6pIvzPCE6zzQj+g9ztKizOEouyvGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787232091; x=1818768091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wcu4C3RyuwGr0PkgRmgBS5ekGUg7V2uXJgWrRXuNcOE=;
  b=aRJrHpwtEogEe8/CGpv2tKg1L1nt1lSoxyQ2bhJR0D73nsDGgUeakeAB
   8yk/7iNB4amX4p0dbGxqSTPFw4hpETUQxJWOEzlW/JepvCFfhVzmn6+X2
   PLUDi6Nx0uL3bxIeKZqgl6+uPSlNj3gvrIytKUzrh+NZP3ZpmlIlb+UD/
   e1amSYtk28Msfnhq6qP05B3WUDZ2vwFH4SO/beyIAvaaTAkdEvMmcXOyW
   7y4qFGORTD1PnHxWVGvk/8gO/caEQmtoD6EWYXWbko/6iqVRqsZ46ZEuz
   54DBNIpQPL6KttzaLXrZLp3qaIhg1NMBHaZEcfw6ZKpVSS5b0n+A2Af9E
   A==;
X-CSE-ConnectionGUID: UumsPBjhS22oKx/TrQ/cyg==
X-CSE-MsgGUID: 4E5WZv2IRlGXmKOEZVzKGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87971772"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="87971772"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 06:21:29 -0700
X-CSE-ConnectionGUID: +7+6ZEt5TTaCzQS3HzXRgA==
X-CSE-MsgGUID: dzLHZi6jRMW9rImmWiEIOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="270264213"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 06:21:29 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 06:21:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 06:21:28 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 06:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6GGE821BjIjEWvds0lkaJfIfss1gskGOtjUUtVuMZ3sqiHTJGVDGvl8eMRdtHQ/snDVG1cE1U1C8oAtKsQG+44PY5JZFl1RMP0awCujSOiDGtqqZmgFfqV++MkOcBQCgyjdhSmNmkK3LMW3feZuHsNzH/thK9KZjNrtEwU+eL5Rtp9734TC7UjGfsdpm/aHG4FEaB80y07UjqBY5MCgAKUmgSNp9wrZQz+h7jaonJm3ASy8mes4JCDRQyrZ3DDrdtJdL6+WTjj1kXR9/iU7QpvFv+gKCFD5eFTntE+J3qlgY8f/02xwRc/KbRJ6Cv5omN3opXjsxQNn6CsWRxJ1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wcu4C3RyuwGr0PkgRmgBS5ekGUg7V2uXJgWrRXuNcOE=;
 b=VC/NLfiW6bFq/V7srpKabuP5Yq0b9gSlbBas8zrkSZor7RvFvMk7LCzzZpJKht5gcQBpcf2B+g2cxxCdn5vma4a/e1OGq6eKEhdPjRMYI1zpDtODiZaDIf7J8gXEI83K0CLq1w3WWBjzFL3QaP8UIDq9n97VKeLNRlTo4QphaOrWHtcFMRW7IXc7jLhjF4COsbZifzPYk07H8YmKBw7XTm0PFEzxOO+GLosU4nR9S8uUwVMJunJGPMyH6rnBO5Y5z2Lg5GvzO6oUtlF39YCSWwSO4EgGkTVKw5yoa4jqBANGaDPgwYo7XdrvobA9Qyx/VKPeDGGaKlXraUDLvk/Syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DM4PR11MB7302.namprd11.prod.outlook.com (2603:10b6:8:109::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 13:21:25 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 13:21:25 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdLu8R8F489m5sRUGA8lOjA7/dwralh/aAgAFm0GA=
Date: Thu, 20 Aug 2026 13:21:24 +0000
Message-ID: <MW4PR11MB69369259EB8B2FDF237B863AA3A42@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com>
 <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
In-Reply-To: <ac77571f-4a10-4511-83e0-c6372d5b4a09@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DM4PR11MB7302:EE_
x-ms-office365-filtering-correlation-id: 676ed809-19ba-4a16-91ed-08defebdef45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|4143699003|11063799006|56012099006|38070700021|10067099003;
x-microsoft-antispam-message-info: BtJM/sM5rVIjXYZdZGcl03tF98gH4QrZEZfydNOZ7Vl+uF7UzMLQ7FIdmtJfUyCi0bdciaQPec2PO/QGjnJQcjLbsxTI0oFXNg5VXAt+YPPNFFJQKDgo/v7Iq+QfrkKXI0bk5E75l0XTbOEUuz/d68k/Cx6hLIx9mucebp2rjRCsclQsb0DEkzLkPtxvd6uFBesh33hueQYCfp2SQk+70hTLv28Bwgh9PSqwriNzeaMLaoQuPf5sQZ6HCPNu6H78UGSQ9ATWJj7MOoxL71Q3VoapOrgHTwq9PRC8kPDivwXUuT5fCEzun+x9Jd7jkLyACU4llYQ7ekQPo6cQ/JHhlWAMl9yfhRalkMpDS98yAztJCA9UBmiAcbydHTskX58e/IKnaSL6rarAkdz1dmOv/LmrpPd9bUcsLRM36H32npO/FMjlbO5vmKjL+hQbaLdUi5s9UWLFPIS0lv+ejPUfrehETGGuQM43OutL9rpOxsUHGoedrfgBRXun8d6n9pwuZfySExcC/+c5zExuH+euEhY1bSYI7lbEVVE9p9EOmJOUQ3qtUTHGuqBgfp4JtyKAeSy7Od8YsyCW+c+GrcjpEjj/lbLKNxzaXdGIoUngUMGZO7+8NhIAYh+lnv7vyjQ6y1lD8/sUow4pGQtWhGFJBRY2ElMqA4378rbDjmwYUsteL8kUghKOPjvHFUwtijtw2oMbOqtg6+KwweZ69iaen0zt1hugCcMZ0ZrZXsGRGOE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkdnM3hkUzM4RjJuMGg0dWpFc242ZExqT3V6b01vN3B0SXFPM3c5cHpPbE5J?=
 =?utf-8?B?REFqTGZDQ3grQ0FZaWRDblVwNzcxelo5eE05V1grVWNBWU04NGlMYlRzQ1Iw?=
 =?utf-8?B?NHJMUEZDZHk3Q0NLQWQyQTVySGNEVzV1bDY5OGE1MzVFQWlpT2JlcWowVDIw?=
 =?utf-8?B?Y0s1c0k2Mll6L0o0V1l4S2NpSkU5V3VvVjk4RTIyTU42VWdMVUFoUnc0RkdJ?=
 =?utf-8?B?RDlLRFU0cStWTjV3L21KNy9TdHcvelZ1RjdvOVVmKytzK25wNG0zYWxkUDdo?=
 =?utf-8?B?VVNkaDBBZEczanBnSlpKMjUzNmRlWkJLTzR4dURISmtJNHZ3TUpFMnRHRzlE?=
 =?utf-8?B?S0ZSSzB0U0IwNnBoYTRNcGYwYjNMdnVNQUd6VlZlVFFjWDF2NmxBQm1PdFg3?=
 =?utf-8?B?VGZVdkp2TXBPQUtuZmUxNDJBcTVPZFRmbUpzblhRM1NodXVxbElVZDJ4Uk44?=
 =?utf-8?B?dE94bGJ2eWZpcUhOQ2phWW15MTBkNE91cHdZVVZENnNHY0JQcGwvWDU5Y2c2?=
 =?utf-8?B?bnN2UWR0VFcvTitURXN3ZjIzTDVPV1Qyd1B1YmpQMmFuVGlLTTRDMUtpa3Vu?=
 =?utf-8?B?T2RPV3BkVGJ0Q3pMK0pqTjZRM1djT0ovNURjL3dZOE5NVWVSTUV0TkNKT2ov?=
 =?utf-8?B?NVNOdExFT2RnYzNNSktqV2hVSm56bExoazduL2dOYm5hVkEzMkRGZTFmbUw4?=
 =?utf-8?B?Q3AyRy9QUXNuWkJseHl2VGdUV3hPT1FjSDlZbWdXSzJKa3RLenA4YTUzY0Iw?=
 =?utf-8?B?YmZWVDRDcDhTWCtEbHBlZjV0bTFDMDQwR01aMXhndjVYME9ENThlWXYwZWRz?=
 =?utf-8?B?azN2WTNnd1FnUTdDNTFsTVRkVUlBODF3NFNSa0ZDd3g3YVdzaWgyeUI4SXg2?=
 =?utf-8?B?VFhpZ01kbFUvUVNBb1Vtcm9zL1NjbTJ5UEJtbzI1NVBSTlBPTlF2MTdJSU4y?=
 =?utf-8?B?VXVYcTJWOCtOOUUwNFhuQU9WYVV6aFVMNkN1RlVhNE9vTmd2amJTcVBhU2lW?=
 =?utf-8?B?L1lZUkFkWEdNZ2h4b05SbDRrd3VHWkh2Q0l6N1BMSmNYcVloMlNHSXJtbmVO?=
 =?utf-8?B?dE1wZkhOcEtsVXlZUnU3QVpHQlRqZkZkdVFyRkpNZ01lUTBUaTBPeVkrdHBM?=
 =?utf-8?B?UEFsMGR6MWJuSCtzbDZWNWtwN3VMNlVVRXFmbzZvSWRJMlpJbUpaOG0yMi8r?=
 =?utf-8?B?T05jcFppZzZPQVlGcE5nNXBrdE5MMHR2a1ZsdjRFNzBObC9DcEdVc0s5Unlu?=
 =?utf-8?B?RGFUcXRWNHZjUTdTVkVqOXRZYUFHS25rSWdOK09MdDVQMVR5UFc0ZDJFc0pQ?=
 =?utf-8?B?dmJJNER1MFNoZlVFcVZ6MnRkMzdHOW0wZHdmYzB2a3dBcG5GYk9aVkJpQllJ?=
 =?utf-8?B?dHJzTkxvc1dOL2szNnBnQ3lDM2NPTTNOdmdmRVRXdDRJWGNseDQ5dVRGNHg0?=
 =?utf-8?B?QThGbGZMcjFtaGRxdTF4Q290cE1SR01hQmpGK3lCN2M3Q05WanJzeXA2YTli?=
 =?utf-8?B?a0w5S0xEUlZGS24vNVYxek1wRFpzRHV1LzZxV205a2N3TmNaekVNS21lZDJ5?=
 =?utf-8?B?bHBqOFNZRHBvd0ZwYUcvc2R1ODB5Y2VRakg4b3hzdFM5d1p0aEpNRkUraU8z?=
 =?utf-8?B?bnFyMW5Bc0o3aTlwKzhwK1dUS3JZVnpRTzdlcFQrQlZ3QWV1RFNHdzczSlJz?=
 =?utf-8?B?UWVwK0UvL2xJOU8zb2dnK3ZvcHZZaTdTSERlVStqamhicjFvVFRhcDIycFA1?=
 =?utf-8?B?S1dWVHY0c09nY2lxcGhoWWlFOU1NSVh4SGYyVlN1ZzZCdUVnWnROTEN0YlBx?=
 =?utf-8?B?QzJQQmN4T1ZmRXFEekRXZzNlT1lFVG80TkZPVUxOVmhZT0szOHQ5cDRybk91?=
 =?utf-8?B?NDI5ODRxOFhLaTFVWDNzN25xK1JpT2E5NHhwaDNPWnB4b1ozSm5zd3JwNVE1?=
 =?utf-8?B?QzVYWkZFeEZVWk9mQzUwajR1aWtiTVdydjBqcEhGK040Sm9ONktGdGN0eGRC?=
 =?utf-8?B?Mm0zY0xKN1Boc0hjNXdBZ2pBaEI5SlRqclpUMDJ6djg2ZjN3em55Tk14Y0Zt?=
 =?utf-8?B?eHAyMHpRRWgzbVVLcFY3c29Ob3FZUDBCVlYxRXlQVlgxb3IzejNwYzU1NExi?=
 =?utf-8?B?UFdlNVB3L2RKZDk0OWhkSU5GZ2NnVkxvRUpLcXF2aG5BbmI1S2VkMXVNaWh4?=
 =?utf-8?B?VEh4Yk45R05TTXhDbUt2aHdua3c1MGR4b1dndVpFZktNS1BjWU1FU1FXVEc3?=
 =?utf-8?B?ZzgzbEFZVnQ2U2JxZmszOHBTOE1qUHJ0bmxHM2s2ZUlqNC9zQVVwSVY1dVF4?=
 =?utf-8?Q?gZkczpbrcuwhfKZRiH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: LCHYgEgyKjyAq/PsMha1LCdoTUcmHmNVt1paoAkSfFnvPsvIqVFDA8XZ4oeXEEdo8yMFDJnKSZ+1boaPQ4V6uziKfFmoXnclL3KSJH9iFF3OpNVqWsqUfI4UbRZTefvoKc/1AN6w4vaIhZOtOhsD6NMaTf/ylyUvFejHDV5qkVgf6JnlYYyneJEwtGdoi87uIjOadfplm7M4/cMDoxT+WfUIXr9fTeWiLmopRdxeWdgRIsBIWoiJPvKPLSYaEOPLD7PnYFoThefaTs3uh6D5Y2Bx5/rChctyoPyEoVcNonJ626U3+4SwSRUQfH89/m4p3Uyvdx/EgK4Pz0dJsYT+xA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676ed809-19ba-4a16-91ed-08defebdef45
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 13:21:24.9493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQcXkc0/7sX0veaENioZ5KQ7s8wyzJwHvqiiS5CMESVDChp5XPe+Ef9rSrBZYPs/d/vEZ9p/NljzrwwcTYG1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7302
X-OriginatorOrg: intel.com
X-Stat-Signature: c7n7g1w1ho3cabziiizt58ipwmud39uh
X-Rspamd-Queue-Id: 443A8C0011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787232090-960308
X-HE-Meta: U2FsdGVkX19hfpE5rhiRg8AHlqHKwwkApzamUswALmsRp5ivW+BCpuj3fuJdNJ4DWpPR5M0iAZ41zDzgFd1JEv3aCuBU+zU5IkT3QoSYHJuFRGG6myNnlBnPEN/2u0REk90U/iDq/4lMGomvhrwNN74ggw6L9Z65lHufh4kR4ZMSLUBiZ+i7aydpY1iPFGWBhSyeyS+ibRo8zru9hNOoCqv1JbxElVmPBLiGib6EDcVUvpWenGIb7/nF40khTIEGwyVk7iD0fNte8mJHWdVifkhP+igw0TLcykYQtrIjk6tgZhJOTq6/F9pp5eY6jeHJtbITbVrLjTxQFc9C6qv+hWQvWoh4R4bOea//hAHe/elRA5Xm2mheZ95jCccMk5w7/smqma2hvUcYNJDPisvRNFwagMSSBPTYVK+/3m4FfJfPAVXKqAW9DmCOHXXawZqYaOFAEXt7FR3hMNcT2PHal8aLXTelQGkNp01B6Y6Ci2fBRjkCVMZFYxmuE592pc/IjDE5/u/Pheo2lQ9PRCSsjF9rc57DYV39I25cDxrQioi+dxQkFt4Wuc3+KzZ9J5YLOOmIT02E1ZSfX61KfQa+F2u8kxE+KJuE15N27yIkos5n1msiJBkmlR0WWzNKAk/gu/1jWZ/GCr5peVa1AFGMLm7Ba4bXnPryp8LjHlGQUqiH3wZqpQLdJwnEFpY4irBWZdLoy5f9KBFuVVXBkN5OEOmSf2oPyV5tFeHI1Sj+lNZeH7ceO3Pi3cChyrHzLkpOu8jp/L3HDHCrlVGC0X+R4gVjzpMSOIm1psoVE0dbKuy86ucB+bjnBeNsbjqssQisZerJ2zejwwjM3xiHCr68g7xiqbJ27DCr50zKv4ylGxN4ttQQQlnTAuep4rh3mDWrHDmM5CU3ghtQ8yH5LDMBGsxjcJS4neBs6DAZtN82iJva7Y57BtjLkQbloHqcSiVhkR5XIVG6SUjkHzEp4pI
 fmt5n2LD
 W2lz2f3Lp92pGi6PulUL2giUYLPF2+1KnlAo2o57XVWlKdGlrBILqKUZyUMVmPutMFOpvro3VM2jmaTp3NcEETdOpd0vRXyrIYCK0oanrBYx7ZbypW/tHM0CctCkcFbcoKx9TMxbVJZ7lpEgIiYxOWpt9KVypXMqXPLVCGs6uClI7LpbSHbSmFOiQicvmUZY6loMbIISGuHtDlU4sh17ayXsYlR7jRMkzObI6mXjjFw1ZXOVPEStVDqt0340TXTOqm08XKDu5r5VZL3sf8t0iYo8kYldsek/Ktxk0lS05NFtNX4EBGlm9QJjhU7qhhIiO40GCu/aLZsHSp6HMu1hay8odcGiif+ES0uhL6JwMeQU7VjxeejQLYyFjFxMiCE+7Epu0ZYvadKZ60JcM7ArxJ0xqplmbZKeXOU7nHY5bi4fWWQx6OFn48SPqmvYaMPf2THldQKuR1aey0Kl6eU3Iuy4Jg4ND+0YMg0KC2UxWswFhNvcUSpwbWQu9YG0a8mQtsFtsHQOALX0RUD3l+0Ge+U9gKqkJw2uQnFxTEe60klF7oFKZy2BNYOqhUDMOVgHU+mWSyM2hoRQpVZ9EUxBB6FHguuXZgOf7vf2UAASCl4jMNbnHmbuWQKCZaTu2/BSxbkHTwLLnalkXLW4vgY6o+LRXl4sk50my1gxVinUyqyoVU8FLRYTLFZEtgQqWlRaiP7C9Xu7Apf09uG4FtJCUNnPTCUf2sK/2fGChtCflz+uVEbjRdfO/gAtZljfNrwquQe+vDvTsiPQ8b8oTq1C6Utx5G6kI1QosguRjZUWFoKiIHheFjk1YuluShn0Dz/iKibmbePQIOjy+N9fw/dj7Vs8QKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMTksIDIw
MjYgMTE6NTQgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2Nh
ciBTYWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtl
cm5lbC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxp
bnV4LW1tQGt2YWNrLm9yZzsgWm91LCBOYW5oYWkgPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgQ2hl
biBaaGFuZw0KPiA8emhhbmdjaGVuLmtpZGRAamQuY29tPjsgWmVuZywgSmFzb24gPGphc29uLnpl
bmdAaW50ZWwuY29tPjsgQ2hlbiwgWXUgQw0KPiA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcs
IFBhbiA8cGFuLmRlbmdAaW50ZWwuY29tPjsgTGksIFRpYW55b3UNCj4gPHRpYW55b3UubGlAaW50
ZWwuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHY3IDIvMl0gbW0vbWVtb3J5X2hvdHBsdWc6IG9wdGltaXplIHpvbmUgY29udGlndW91cw0K
PiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiANCj4gDQo+ID4gIC8qDQo+ID4gICAq
IE9ubHkgc3RydWN0IHBhZ2VzIHRoYXQgY29ycmVzcG9uZCB0byByYW5nZXMgZGVmaW5lZCBieQ0K
PiBtZW1ibG9jay5tZW1vcnkNCj4gPiAgICogYXJlIHplcm9lZCBhbmQgaW5pdGlhbGl6ZWQgYnkg
Z29pbmcgdGhyb3VnaCBfX2luaXRfc2luZ2xlX3BhZ2UoKQ0KPiBkdXJpbmcNCj4gPiBAQCAtODIy
LDIyICs4NDQsMjcgQEAgdm9pZCBfX21lbWluaXQgaW5pdF9kZWZlcnJlZF9wYWdlKHVuc2lnbmVk
IGxvbmcNCj4gcGZuLCBpbnQgbmlkKQ0KPiA+ICAgKiAgIHpvbmUvbm9kZSBhYm92ZSB0aGUgaG9s
ZSBleGNlcHQgZm9yIHRoZSB0cmFpbGluZyBwYWdlcyBpbiB0aGUgbGFzdA0KPiA+ICAgKiAgIHNl
Y3Rpb24gdGhhdCB3aWxsIGJlIGFwcGVuZGVkIHRvIHRoZSB6b25lL25vZGUgYmVsb3cuDQo+ID4g
ICAqLw0KPiA+IC1zdGF0aWMgdm9pZCBfX2luaXQgaW5pdF91bmF2YWlsYWJsZV9yYW5nZSh1bnNp
Z25lZCBsb25nIHNwZm4sDQo+ID4gLQkJCQkJICB1bnNpZ25lZCBsb25nIGVwZm4sDQo+ID4gLQkJ
CQkJICBpbnQgem9uZSwgaW50IG5vZGUpDQo+ID4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIF9faW5p
dCBpbml0X3VuYXZhaWxhYmxlX3JhbmdlKHVuc2lnbmVkIGxvbmcgc3BmbiwNCj4gPiArCQkJCQkJ
ICAgdW5zaWduZWQgbG9uZyBlcGZuLA0KPiA+ICsJCQkJCQkgICBpbnQgem9uZSwgaW50IG5vZGUp
DQo+ID4gIHsNCj4gPiAgCXVuc2lnbmVkIGxvbmcgcGZuOw0KPiA+IC0JdTY0IHBnY250ID0gMDsN
Cj4gPiArCXU2NCBwZ2NudCA9IDAsIG9ubGluZV9wZ2NudCA9IDA7DQo+ID4gKwl1bnNpZ25lZCBs
b25nIGxhc3Rfc3Vic2VjdGlvbiA9IC0xOw0KPiA+ICsJYm9vbCBpc19vbmxpbmUgPSBmYWxzZTsN
Cj4gPg0KPiA+ICAJZm9yX2VhY2hfdmFsaWRfcGZuKHBmbiwgc3BmbiwgZXBmbikgew0KPiA+ICAJ
CV9faW5pdF9zaW5nbGVfcGFnZShwZm5fdG9fcGFnZShwZm4pLCBwZm4sIHpvbmUsIG5vZGUpOw0K
PiA+ICAJCV9fU2V0UGFnZVJlc2VydmVkKHBmbl90b19wYWdlKHBmbikpOw0KPiA+ICsJCWlmICh1
bmF2YWlsYWJsZV9wZm5faXNfb25saW5lKHBmbiwgJmxhc3Rfc3Vic2VjdGlvbiwNCj4gJmlzX29u
bGluZSkpDQo+ID4gKwkJCW9ubGluZV9wZ2NudCsrOw0KPiANCj4gQ2FuIHdlIGF2b2lkIHRoZXNl
IGhlbHBlcnM/DQo+IA0KPiAJCWNvbnN0IHVuc2lnbmVkIGxvbmcgc3Vic2VjdGlvbiA9IHBmbiAm
IFBBR0VfU1VCU0VDVElPTl9NQVNLOw0KPiANCj4gCQkvKiBXZSBjYW4gaGF2ZSBzZWN0aW9uLXNp
emVkIG9ubGluZSBob2xlcyB3aXRoIFZNRU1NQVAuICovDQo+IAkJaWYgKElTX0VOTUFCTEVEKENP
TkZJR19TUEFSU0VNRU1fVk1FTU1BUCkgJiYNCj4gCQkgICAgc3Vic2VjdGlvbiAhPSBsYXN0X3N1
YnNlY3Rpb24pIHsNCj4gCQkJaXNfb25saW5lID0gcGZuX3RvX29ubGluZV9wYWdlKHBmbik7DQo+
IAkJCWxhc3Rfc3Vic2VjdGlvbiA9IHN1YnNlY3Rpb247DQo+IAkJfQ0KPiAJCWlmIChpc19vbmxp
bmUpDQo+IAkJCW9ubGluZV9wZ2NudCsrOw0KDQpJIHRoaW5rIHRoZXJlIG1heSBiZSBhbiBpc3N1
ZSBoZXJlOiBQQUdFX1NVQlNFQ1RJT05fTUFTSyBpcyBub3QNCmRlZmluZWQgd2hlbiBDT05GSUdf
RkxBVE1FTSBpcyBlbmFibGVkLCB3aGljaCB3b3VsZCByZXN1bHQgaW4gYQ0KYnVpbGQgZmFpbHVy
ZS4NCg0KPiBBbiBhbHRlcm5hdGl2ZSBpcyBhbiBpbm5lciBsb29wIHRoYXQganVzdCB3YWxrcyBp
biBTVUJTRUNUSU9OIGNodW5rcyB1bnRpbA0KPiBlcGZuLg0KPiBUaGF0IHdvdWxkIHByb2JhYmx5
IGJlIGV2ZW4gY2xlYW5lciBhbmQgZmFzdGVyLg0KPiANCj4gSSByZW1lbWJlciAhdm1lbW1hcCBh
bHdheXMgb25seSBoYXMgZWFybHkgc2VjdGlvbnMgd2hlbiB0aGV5IGFyZSBhY3R1YWxseQ0KPiBv
bmxpbmUuIFdlIGNvdWxkIGV4dGVudCB0aGUgY29tbWVudCB0byBjbGFyaWZ5IHRoYXQuDQoNCkhp
IERhdmlkDQoNCldoYXQgYWJvdXQgdGhlIGZvbGxvd2luZyBhcHByb2FjaD8gSXQgcmVtb3ZlcyB0
aGUgaGVscGVyIGFuZCBjaGFuZ2VzDQp0aGUgcGVyLVBGTiBvbmxpbmUgY2hlY2sgdG8gYSBwZXIt
Y2h1bmsgY2hlY2suDQoNCisgICAgICAgdTY0IHBnY250ID0gMCwgb25saW5lX3BnY250ID0gMDsN
CisjaWZkZWYgQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQDQorICAgICAgIGNvbnN0IHVuc2lnbmVk
IGxvbmcgY2h1bmsgPSBQQUdFU19QRVJfU1VCU0VDVElPTjsNCisjZWxzZQ0KKyAgICAgICBjb25z
dCB1bnNpZ25lZCBsb25nIGNodW5rID0gZXBmbiAtIHNwZm47DQorI2VuZGlmDQoNCi0gICAgICAg
Zm9yX2VhY2hfdmFsaWRfcGZuKHBmbiwgc3BmbiwgZXBmbikgew0KLSAgICAgICAgICAgICAgIF9f
aW5pdF9zaW5nbGVfcGFnZShwZm5fdG9fcGFnZShwZm4pLCBwZm4sIHpvbmUsIG5vZGUpOw0KLSAg
ICAgICAgICAgICAgIF9fU2V0UGFnZVJlc2VydmVkKHBmbl90b19wYWdlKHBmbikpOw0KLSAgICAg
ICAgICAgICAgIHBnY250Kys7DQorICAgICAgIC8qDQorICAgICAgICAqIFdpdGggVk1FTU1BUCwg
c3Vic2VjdGlvbi1zaXplZCBob2xlcyBjYW4gZXhpc3QsIGFuZCBQRk5zIHdpdGhpbg0KKyAgICAg
ICAgKiB0aGVzZSBob2xlcyBjYW4gZmFpbCBwZm5fdG9fb25saW5lX3BhZ2UoKS4gV2l0aG91dCBW
TUVNTUFQLCB3ZQ0KKyAgICAgICAgKiBhbHdheXMgb25seSBoYXZlIGVhcmx5IHNlY3Rpb25zIHdo
ZW4gdGhleSBhcmUgYWN0dWFsbHkgb25saW5lLg0KKyAgICAgICAgKi8NCisgICAgICAgZm9yIChw
Zm4gPSBzcGZuOyBwZm4gPCBlcGZuOyBwZm4gKz0gY2h1bmspIHsNCisgICAgICAgICAgICAgICBj
b25zdCB1bnNpZ25lZCBsb25nIGNodW5rX2VwZm4gPSBtaW4ocGZuICsgY2h1bmssIGVwZm4pOw0K
KyAgICAgICAgICAgICAgIGNvbnN0IGJvb2wgaXNfb25saW5lID0gIUlTX0VOQUJMRUQoQ09ORklH
X1NQQVJTRU1FTV9WTUVNTUFQKSB8fA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcGZuX3RvX29ubGluZV9wYWdlKHBmbik7DQorICAgICAgICAgICAgICAgdW5zaWduZWQg
bG9uZyBwOw0KKw0KKyAgICAgICAgICAgICAgIGZvcl9lYWNoX3ZhbGlkX3BmbihwLCBwZm4sIGNo
dW5rX2VwZm4pIHsNCisgICAgICAgICAgICAgICAgICAgICAgIF9faW5pdF9zaW5nbGVfcGFnZShw
Zm5fdG9fcGFnZShwKSwgcCwgem9uZSwgbm9kZSk7DQorICAgICAgICAgICAgICAgICAgICAgICBf
X1NldFBhZ2VSZXNlcnZlZChwZm5fdG9fcGFnZShwKSk7DQorICAgICAgICAgICAgICAgICAgICAg
ICBpZiAoaXNfb25saW5lKQ0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBvbmxpbmVf
cGdjbnQrKzsNCisgICAgICAgICAgICAgICAgICAgICAgIHBnY250Kys7DQorICAgICAgICAgICAg
ICAgfQ0KIA0KPiAoSSBoYXZlIHBhdGNoZXMgdG8gY2xlYW4gdGhhdCBpbml0IGNvZGUgdXApDQo+
IA0KPiANCj4gLS0NCj4gQ2hlZXJzLA0KPiANCj4gRGF2aWQNCg==


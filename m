Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFDACA5FA2
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152A86B044B; Tue, 20 Jan 2026 11:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B30D6B044C; Tue, 20 Jan 2026 11:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74E76B044D; Tue, 20 Jan 2026 11:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDE1C6B044B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:03:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85CFF13B326
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:03:25 +0000 (UTC)
X-FDA: 84352811970.16.FB2D515
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B44814001F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:03:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rz3P+oN+;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768925002; a=rsa-sha256;
	cv=fail;
	b=C/LTUm1G+UWuYyjqUJbCKlrfwhgf2vbHPeqYgwsuMUjzuicIeswhcTvfzEWwp1a4yn5s90
	r8ZL9fy0H0Bx04jOKQZ0iGvC/jRgCKCfSjI7eNpW4Te1qHDnIhMrobDvAeAzmZIXNPjZQz
	vxDqmyIPqwPMEhtJHD2EaGIk2iu75Pk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rz3P+oN+;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768925002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh0k0608kHFbBLxngMK5DbnlS22RlKy894GoVdCSHUA=;
	b=p7VAxZnB58sFkQKECg6tP2iNZ11wLe6C1llma5mnkFRM4aMDHfL2wcd1XkASowiwYwHVtd
	wzvACFBy9e1z2af2IOGxk7R3linOc0RHHwUNp73SF7ypKS1fEi/BTS4npOCOGbEAdpxrqh
	cIxCS6HCKMaygK4arlN3vwMkFeFUQrc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768925001; x=1800461001;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=XqQXFacKkW+F6l2c3sKyYba0rfoKaiwP5Jy14U1qvbY=;
  b=Rz3P+oN+fAHP07J0Fouk32Qw22vl0k3YaJonqE/m62iZQaoZCDIf8ddt
   0Nrjvxdt3NNuhTzlJF+DhxKfR9e7RBwYEdEOTt6F3QRhxlH6/hNlh12oy
   0s2De/sz5keCCntbhPu+mvGc9X8w6x/6uphpgcjWjd5Wf0KYFU8M5cN3H
   jzvlgCOyE7Y9sp/d3rppC+s9k3kbnYkKlISiuI9xllUfFmIH1b5WHGkwC
   3EzW+ovBG+SY60UGpkMMadLpmAuXflnghmDWTk9kGaB9gL3FJxkry59iL
   Rg02IOpwMnsnhrJTRpHo2uLnqrR1BOLle3OBwkthiuNJhz4QcLb3cA7DF
   A==;
X-CSE-ConnectionGUID: WdiRt8iaTH6rDg+/d9t2Pw==
X-CSE-MsgGUID: Q9hwXbugR1W3y0pt8JJmBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="57698010"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="57698010"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 08:03:20 -0800
X-CSE-ConnectionGUID: 2Se2CwDwRa6+ZsBS5wkaWg==
X-CSE-MsgGUID: i/wSQ5A5TCS10YhWIC48eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="205773292"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 08:03:19 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 08:03:18 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 08:03:18 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 08:03:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVzf44vxAuMYY4RIgaayhvLyoiev5rpMBePi0BiSiw09rGpd6f3viqGNOniuC7DhqAVA80QErLOfFwDSyfpkv6/aiTveLFfcSfQuGtrhqIxbObFxPwwow6Wuo+XtSInJL+onhfXfIeFzBebRBHJvWNo3UKp6ftiN+AH5jFCuMDzhGub0ON8W+Klt744odpuGt8r84eSNzFqjW1WF2r0wf+QEVtOuM0LkVZEA9BykGBRxd86QYHdMHtUIq1tnpt06SLqLeuuRFf7cqCxF5ti8oW0IpgWx11+yjMFuXioEoJBJ6Ib4jHuU5YvkX4x0WUMpTTi4UjHuoE52m3wc2TD3og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eh0k0608kHFbBLxngMK5DbnlS22RlKy894GoVdCSHUA=;
 b=AEjvGIOJlc2kQuT1x/JoKmDrdjTVzGtooQkaVChhvSuZ/gJJciuDs0jNo+2RroEZusL5B7+pNe6dKhu12Xs/3s6MlUJT8X92jeuVVpJuFvgaR1ZxUVAUhIB+UIU96c+gxxo2LPj1YM1aJRSpSTBlxGoUyb4PU1FQ3T36IekFn2dlTPW07z73l2CgdYrsbNPsWny1b91/dNfvIaHrlSXY/bnkqgeiTF6epoHhoJD+YKYkuZJDYfpZuEGOsqivW1gZFcLG5Ym/zEAVz0XIZF3HsE0mBUBOAtse7nHH3iBBsyAQUfWrMVeyv4NSj5WsQh14SEzTphnz7lh3amSCu8O26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by BL3PR11MB6435.namprd11.prod.outlook.com (2603:10b6:208:3bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 16:03:09 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Tue, 20 Jan 2026
 16:03:08 +0000
Date: Tue, 20 Jan 2026 08:03:05 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: <mpenttil@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, David Hildenbrand
	<david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky
	<leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>, Balbir Singh
	<balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <aW+nOf33ojgyaQUv@lstrano-desk.jf.intel.com>
References: <20260119112502.645059-1-mpenttil@redhat.com>
 <20260119112502.645059-2-mpenttil@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119112502.645059-2-mpenttil@redhat.com>
X-ClientProxiedBy: MW4PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:303:b7::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|BL3PR11MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c778531-26eb-4e83-06eb-08de583d674e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QUZFZ2xzQ0w4aW1hOVNtSnM5MXhwblNwNVVwTlhReXNVN1FHdGpKQkpOOGh3?=
 =?utf-8?B?azIxcVZWZlNEK0c2b2xGaTlBa05lc2NqVVhIVXR1NFRrREk5cVYrdHNDWDdt?=
 =?utf-8?B?KzBuSCtoYjZmNHdIRjQ0YzBjN255b1Jyd2pjU1k3VGxSSXRNUTNYS0tCUXY3?=
 =?utf-8?B?eStQdm1xOHdDNDR3cUt2R3kvS1ZVMTV5MDdZSCtHTk5JKy9sckRtRnM5RnFK?=
 =?utf-8?B?QmZ2SFI4Z0VuRTkrb0VXcnEvVmthaysxaEdiT0xRNVd1UXltS1czMnJRbTNJ?=
 =?utf-8?B?MzBNUUlzaUV3c3NvY2pydk0rNTVpV3hMYVRFbXprdDFyb3p6eHJDV3pzUGxE?=
 =?utf-8?B?NEZoUHdPSGJ5UEdHRURseVdDeTJuUDNQa2ZZOUYxWk5XTW9FcVlSVXNqQlVy?=
 =?utf-8?B?SkFtdFV0OHlnY1hiMGZGQVh1Vm55bFhvWFl0V1prMjhWbHJLR2F1TmdWTlM0?=
 =?utf-8?B?RE5ld0E3aFJnNjkwSlM1aFhhcUFwMWlWVEhOS3dlOU5zV2RtNWxHRldVRjUw?=
 =?utf-8?B?eW44QWorRnBKSmFNdzU3bDlwalpWZ2J2YStUQ1hnQzBOTXNpNUtEVmlDbXps?=
 =?utf-8?B?bEtHMVBzWkNwWkJpZ2NLMUlyZENOMXFWdVl6MnNGUGhVNzhxU3BxYWR6UUFr?=
 =?utf-8?B?QnhMUDQrWnVBdE50KzEyWU5IbDN2Qlc0VXlPTExRYWI4UDhybTliQnBzbkhZ?=
 =?utf-8?B?T3VBaElNSzk3S21RM2s1TDYzb2Z3WUdQc0FLdkVyRDgxZ2pkRW0vK3JiT0xF?=
 =?utf-8?B?ZnJFODRubkFtdFEvOWc5SmNkSlBpTktZMi8wU2E1cytiZjlJRk9WUUVQdzVl?=
 =?utf-8?B?ZlhDcS9Dd0hLNEtibXFvWEZhRmtxdHhNK0U4QXpOQm9vVHUyNWlyc3owNitH?=
 =?utf-8?B?OTNTOWwvSzRqdUkrQkhDNjF0OGsvd2t0QWRBWWdVYTJqRlBkVXltayt3OTJ1?=
 =?utf-8?B?aFhpWGtzVjVXOXdPa0RqTmtLYXZqbG5pdDVwZTFpNnArTDJoMzNXaTdiRjhx?=
 =?utf-8?B?WEEyTCtpZ1U1ajFjbjVURW1WU1ppODVTbzlwajR4bWIzUHhqUzdDZGRMWE9L?=
 =?utf-8?B?cU51Z2dPdHJqY0dvWXoraEJEbGw5WDVFdlJnOEl4eFJrdSsyanNaNzVsYWt6?=
 =?utf-8?B?UHpEY0o2S1VXTFV2ekkwaHJ0L2FuL1BNd1lUdVovVGVsaTJ5NkdDQm0xS3ZM?=
 =?utf-8?B?OE1TUnpPL1dWcEJUM2JqclV2QXhyTEZXQUdadkVDNG9CemhjTXFWRStwSUF6?=
 =?utf-8?B?dVArL0ZzVktsM0h3Vk1kNVFRd3h6WUw2dFc1a1pEcUFrbjJLNnB6bmJnbnIw?=
 =?utf-8?B?ZUJEQmVkV3VRbGlzNDhtYkJyeDNzc3c3YW1UNWVIUVZLUEtGc3BpQmlvakts?=
 =?utf-8?B?Mld6VWM1bCtJd2lKK21kNnR6WVg3Mm9EQ2taSGhta0thaTVteVRnVEVxTnh3?=
 =?utf-8?B?M2pkSlZJNmd2WkxIaHpCQW1lVEFBVkVza1hTN25rU2w2cWdNWmY3ekpreWRP?=
 =?utf-8?B?eER1WTg4WGlKRXkxQzNTNytqNmsrT3dHVVY2ME1iSkxncGdVUHcrY05ORVNZ?=
 =?utf-8?B?T2NvSEpHSVdBNUdPNDE2TEFNMnBPUWtoT1Z5NFMzdzJBUXg1bjlsaGw4UUdz?=
 =?utf-8?B?QTlvc2NWK1l0MDZYYXRZeUhycU9pbDZSY3BlWlpCZ0ZpODBjS3Q0bDZ0cTJj?=
 =?utf-8?B?Z0ZzRHhla2wxRWJtVnVvSkRhWlNpc2I3NmgyNUtXRTFQSXdwbFM4czlTOG9l?=
 =?utf-8?B?bWM1WUI3eklyWmJpNUVpTXp2RmVMQnliQndRY1Z5TFh2WlFwUk1Zenh4YmVU?=
 =?utf-8?B?RFo2ZjlpZS9EVHJKdlRYa3Z4TktWdWNQRURTQ1NJK2gvci9jK0NpbEUzRUkz?=
 =?utf-8?B?WlNBTVgrSHErZnM5TWYrOEYzd0FFZmo5TzQ2dGZuVThxMmoyOVJndncvVmJF?=
 =?utf-8?B?TVFzdkQwMEplMmd2azIrMnlCTENIRkQrMjdTako4TXJoaWhSTDBKb2g5d1Ar?=
 =?utf-8?B?ZG5BK1V3U3JHbGNLUERaM3drT3JacHpwbVhqaE1tZUt2b3ZFM1lYTHJONDRv?=
 =?utf-8?B?NlQvV2RRVXlWRWw2Yk1KeE93MzJDYS9JOG8wR21jdHV0NVpqWXl2UXRqTUJp?=
 =?utf-8?Q?Sd5k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnBqaWtJbTdqYWZUVFEzQXN6V2IvNDl0Qi9IQzZQWUE4OWxMaTFsV0tuRG1T?=
 =?utf-8?B?cW5lZDhDZCtpcUFzNjBuTExueFgrcVRiRGE0Qk84WUFSM0JvYTNnS1hmT1FW?=
 =?utf-8?B?cWJicWJ3QkJqbGNmUFJiUEhEbkpTdmxhZk5PNVphQWlYMFZPMU1DcWx5NW9t?=
 =?utf-8?B?VWlaM1pBSUlJYXNid3FIQlhHYTROMVo0S3lXdVFTQjF6WmZHTm9ZV0lwOHhS?=
 =?utf-8?B?KzlseTBJVncwQkxrQXhQbUJ1Y3U3NVJzdWNkTlB0MmdOSk42Tk45ZXVUbmt3?=
 =?utf-8?B?U2VhcVMvRTh5ZUdjZEVVbTF2dFUxOWp4WW1SQjQ1MzZyUUtUTGhmVlU2SVlk?=
 =?utf-8?B?bVpBelBvK2dUVTJFdzRIbHY1bUVYWm5WZ3pVd0g1MHBVb0ZEdDl2c054Z2ta?=
 =?utf-8?B?bXlGdDFBSys5ZkM1Q2wwTWhBcFJNRDQrZ2RZTTJOZHc0ZEJXRnpCdlZ1VDVM?=
 =?utf-8?B?NGlPYkZmSHVzQjk5eU5FbEFFbWtBVUZaRmJ0WEJjYWVNRGFoOU5QemxFYmph?=
 =?utf-8?B?TnI4dEgvSWtIUXM5SS9nY01Eb0tUV1VEMGo3YllFWjJQY0JKelNUd1V4Lzdj?=
 =?utf-8?B?ejdPZWdPdXJKdWJ4a2hqc0NKT1RacnRTcHEwQ3RFVktmVnFZNkZtSDlxTGor?=
 =?utf-8?B?VTZiUDFKOFR4WExsZ1Z5Vlp0VUlUZTJNOHRKYS81dHBCcFdPUk8vZzRoN2k3?=
 =?utf-8?B?WHFPWHovY3lZMDA0ZzRQT09RRk9xUWs2SnJRUmtYWGRkNGxtTmE2N3B3a0cv?=
 =?utf-8?B?WW96bkx6TGxSUWo0ZnFTcXVXZU5xSWI2all2NnRNK25TUExEMXpDd0lLRmVU?=
 =?utf-8?B?VGxqVTgybm1EbUROSjBDYjMyeWRhbHlraVhiVSswTDd0dEpIYjFzeUF4d0F4?=
 =?utf-8?B?OVpTWTFMc0tHZ2hpaDFPbHk3dnk1ZFJna2p6SzM0VFk4UDZuTTB5aE5PMWE2?=
 =?utf-8?B?dlZlK21seHBYZjRiWVU5WFBJbW4yeU5LcjQ2dkxjSXRXSkxDeVB5VjA4azV6?=
 =?utf-8?B?QjdWZXpMeXV2bk5venpnNVNxUjBLSm16RUd0QWRHS3hCZXpKUDUxWHcvZ1Vt?=
 =?utf-8?B?bTd2ejFPdUV4cmI2Wi9UK040bVIwelRONUxGcTdXYitHS2tHOHNQaVhWeTdo?=
 =?utf-8?B?dzJxSFNIUXJOMWwvdDlXaTk1ZTJuc0dpQWVNcVVqZTA0U1p6ckhlVEg5WTJF?=
 =?utf-8?B?TVF3cHNoajB1ZVVFbDQzZ3ZkMUNFV2JDTkE2aFAwZ2RWcEw2MGtrRTVaanVC?=
 =?utf-8?B?b1N1R2grQWlqSFBaYXVFQUlTc1N2T2xjaSt2YVFnVlNKTnA1SHNqcUt6Q1p6?=
 =?utf-8?B?c1NPdE5qN3ZxZGlnVlFDMTRJR0oyVjVBV21CT1o5VXZtOUdXVGVOcnI4U09K?=
 =?utf-8?B?UnhiL2FGOGVhMUNNdkl2MXlVc3FoSUZXSlVNR3pTYzFpenV6TlZoWjQ1dXJy?=
 =?utf-8?B?eDRYbmFKalFmNjdOeUNXTVY4UWM5WHd6SmZyMWNKakFZQTVyaVBabWx4RWdY?=
 =?utf-8?B?ZWtvZC92K2M1cWpQeWdSUUd4SWg5MzNrNHU0Y0NWWmhLUHdQWXJiSVdZU0xu?=
 =?utf-8?B?VjBDM1lWYUNETVBWUnBPeTZVZVV5a08zellld0hBTkVhSElyc3NBaE1nRGh0?=
 =?utf-8?B?ZFR3QWkyNHpONS8wVUNtWERGY0xMOFRESDNYTDFiRUJHUW9UcUNubGM3TXpa?=
 =?utf-8?B?cGp1ZFJ2Q1dXc0trdXdqVUN6bndvZkpYbk4zcXJqZ1EzRkFkQ1p2M25zRkRm?=
 =?utf-8?B?RzZMVVB1NmRNWktrbTdpYkJ4ZmlpdVJXak5IYW02N1lXQ1JKZk5UbHdBVWVI?=
 =?utf-8?B?TWF3YWUvd0o4M0gySkRYTml3dTI0Y015Q0pKWVZ2OVJMSW9vY2dUK0ZrZXN3?=
 =?utf-8?B?djVjekNTWkF3U29ZMlErVmdwbEtCc3RjakFzWVNWS3lEMWUvY1hZUi91NFg3?=
 =?utf-8?B?Wkk3YmtjN3hnY2JXS1UyR0c4aTFJMVZ1cGYrY2ZBVkJ6WW8vQVZrdHlMQ2tY?=
 =?utf-8?B?T0R3MWFaSE1nMHhsTXZvYlQzOTZCVENKZ0Z0N2tVWUdKYmF2bzBmamcwREJO?=
 =?utf-8?B?cDJOL3pRZHF0QnNjbmxrQzdVT2xpRk9EVm1rS1p0bUc0eTcwMTU0ejN0R3kr?=
 =?utf-8?B?U3BqYlhjNTQvNi9nQ3phN29lQlBSUnZHZUFDa3ErWDE1QVZmMnh2TjN3QzBh?=
 =?utf-8?B?R0Nvd0FjMUVGelk0czgzRWJNRE9HcUFqVTQ4M3FaTlBHUUNpY1h1bHBOSlJx?=
 =?utf-8?B?bm4xRngrME15cWk0MDZzSXdNV2MzR3o5bS96aUZDaEJud1I3TmNrK0FPcEVS?=
 =?utf-8?B?RGN5VmkzUUNFdjFDcW1mSWJ2VlRxMkUvMlI5cGUzeWU3b3Q2TC9rQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c778531-26eb-4e83-06eb-08de583d674e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 16:03:08.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +OfxkVgf/O41abl9CEtJcXniBgh/OoBIdTQ76NPiVJAJTdeS+Sh+kx1nUsvZjRFml+tjaTsevkEwZP9zWPM+Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6435
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B44814001F
X-Stat-Signature: znajze4565mdix8pyjge88jehn1nyhzn
X-Rspam-User: 
X-HE-Tag: 1768925000-192244
X-HE-Meta: U2FsdGVkX18CJBtLJMlz5UavPrBDpI4M+fJEVHIwgR1Rjje/N6zXS0Gj936NlOrpaizl0E+MY6LmbiDRgtXaqDZpVe3JQ8rOuo9mQLdG8Lw0aeoTMRJz5mQZjceqEz7GE+8XGXeeHpEZY7GOP9Y4IKdGBx3UiCnCDzRT77UuFq+b7GfQ+Zhhfbm1rxZfsygLe5KVIslvPxs4jkX0xNOUIupUUcVhHihCBxZGT1gmjtLcY7ECijNoiQDFg8PhrkVGAgsOkVJ2bnDy8P18SpqHaph9j0sYwz2Nk/2NWVJ3efdP9m/DN3w+zXtK5O6tqxYaYsxyfCEWPlYIQtHgw+1KTP0xAzZWNBV4IC8uAlFLCI/cZIZhpKvjwfpyBmQmYEnx4EBHKhVxDthtYseKTQLUySQZA7ehwvUc4NlsywVkZ7h7KBJ4cSsJjTwoKdA/2HViC7Dt2hEklmAFH6wzQ1vKoHzuxlTkh1Mjkgfy0ixXctRcFbqmAHyCW8Xhll+Kk3RWCrESD/5L1P5edC29sTRkE8EmUlLp4Gm/VztcqARTmzZn+Jil54OSEGKrr5JgwqwuqgbkIh3d6vj4Ubrwe1nxtiXu+35XLmnzbiTnf/BqRN4Jgrom/kQJwe6mUJVGj/EW1FTi4tkCllBL7dI5/oD5xWMChepQf8cq5U8+U3CMbGD42OKOVTjfiJK84aqwS+CTVrPbfzIt5ozWp2J82yI2qjv0++m3iY2QXaXcT4mV1aDx7kDsr0D1J9DVWKizuKRnxRCgNKGObjx/FBlhBdpCcpnITyNa7YycyrH11/RN9GS+BXoPt7PxBEF+0aLO6inI1bRD2hxEyEiR3oyP2d5BybatJP2vRnvgGxut3x+Jx2Wn35ocp/PeLmUZX6Cb18E2IPa/lV30HoWHdqIESMwTtjXM2Y1ZuSlsPowOFj/QomgcGh6mRPNifjo7LhEYijRWZ4Q1NIKl2wsdjCWRG6A
 7dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 01:25:00PM +0200, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>

A couple of comments/questions around the locking. Personally, I like
the approach, but its of the maintianers if they like it. I also haven't
pulled or tested this yet and likely won't have time for at least a few
days, so all comments are based on inspection.

> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/hmm.h     |  19 +-
>  include/linux/migrate.h |  27 +-
>  mm/hmm.c                | 770 +++++++++++++++++++++++++++++++++++++---
>  mm/migrate_device.c     |  86 ++++-
>  4 files changed, 839 insertions(+), 63 deletions(-)
> 
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index db75ffc949a7..e2f53e155af2 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -12,7 +12,7 @@
>  #include <linux/mm.h>
>  
>  struct mmu_interval_notifier;
> -
> +struct migrate_vma;
>  /*
>   * On output:
>   * 0             - The page is faultable and a future call with 
> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>   *                      to mark that page is already DMA mapped
> + * HMM_PFN_MIGRATE    - Migrate PTE installed
>   *
>   * On input:
>   * 0                 - Return the current state of the page, do not fault it.
> @@ -34,6 +35,7 @@ struct mmu_interval_notifier;
>   *                     will fail
>   * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
>   *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
> + * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
>   */
>  enum hmm_pfn_flags {
>  	/* Output fields and flags */
> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>  
> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> +	/* Migrate request */
> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>  
>  	/* Input flags */
>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>  
>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>  };
>  
> +enum {
> +	/* These flags are carried from input-to-output */
> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> +		HMM_PFN_P2PDMA_BUS,
> +};
> +
>  /*
>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>   *
> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>   * @dev_private_owner: owner of device private pages
> + * @migrate: structure for migrating the associated vma
>   */
>  struct hmm_range {
>  	struct mmu_interval_notifier *notifier;
> @@ -117,12 +130,14 @@ struct hmm_range {
>  	unsigned long		default_flags;
>  	unsigned long		pfn_flags_mask;
>  	void			*dev_private_owner;
> +	struct migrate_vma      *migrate;
>  };
>  
>  /*
>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>   */
>  int hmm_range_fault(struct hmm_range *range);
> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>  
>  /*
>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..104eda2dd881 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/hmm.h>
>  #include <linux/mempolicy.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
> @@ -97,6 +98,16 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>  	return -ENOSYS;
>  }
>  
> +enum migrate_vma_info {
> +	MIGRATE_VMA_SELECT_NONE = 0,
> +	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
> +};
> +
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	return MIGRATE_VMA_SELECT_NONE;
> +}
> +
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_NUMA_BALANCING
> @@ -140,11 +151,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>  }
>  
> -enum migrate_vma_direction {
> +enum migrate_vma_info {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
> +	MIGRATE_VMA_FAULT = 1 << 4,
>  };
>  
>  struct migrate_vma {
> @@ -182,6 +194,17 @@ struct migrate_vma {
>  	struct page		*fault_page;
>  };
>  
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	enum migrate_vma_info minfo;
> +
> +	minfo = range->migrate ? range->migrate->flags : 0;
> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
> +
> +	return minfo;
> +}
> +
>  int migrate_vma_setup(struct migrate_vma *args);
>  void migrate_vma_pages(struct migrate_vma *migrate);
>  void migrate_vma_finalize(struct migrate_vma *migrate);
> @@ -192,7 +215,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>  			unsigned long npages);
>  void migrate_device_finalize(unsigned long *src_pfns,
>  			unsigned long *dst_pfns, unsigned long npages);
> -
> +void migrate_hmm_range_setup(struct hmm_range *range);
>  #endif /* CONFIG_MIGRATION */
>  
>  #endif /* _LINUX_MIGRATE_H */
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 4ec74c18bef6..1fdb8665eeec 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -20,6 +20,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/leafops.h>
>  #include <linux/hugetlb.h>
> +#include <linux/migrate.h>
>  #include <linux/memremap.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jump_label.h>
> @@ -27,12 +28,20 @@
>  #include <linux/pci-p2pdma.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/memory_hotplug.h>
> +#include <asm/tlbflush.h>
>  
>  #include "internal.h"
>  
>  struct hmm_vma_walk {
> -	struct hmm_range	*range;
> -	unsigned long		last;
> +	struct mmu_notifier_range	mmu_range;
> +	struct vm_area_struct		*vma;
> +	struct hmm_range		*range;
> +	unsigned long			start;
> +	unsigned long			end;
> +	unsigned long			last;
> +	bool				locked;
> +	bool				pmdlocked;
> +	spinlock_t			*ptl;
>  };
>  
>  enum {
> @@ -41,21 +50,38 @@ enum {
>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>  };
>  
> -enum {
> -	/* These flags are carried from input-to-output */
> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> -			      HMM_PFN_P2PDMA_BUS,
> -};
> -
>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> -			 struct hmm_range *range, unsigned long cpu_flags)
> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>  {
> +	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
> +	enum migrate_vma_info minfo;
> +	bool migrate = false;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (cpu_flags != HMM_PFN_ERROR) {
> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
> +			migrate = true;
> +		}
> +	}
> +
> +	if (migrate && thp_migration_supported() &&
> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
> +		addr += PAGE_SIZE;
> +		i++;
> +		cpu_flags = 0;
> +	}
>  
>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>  		range->hmm_pfns[i] |= cpu_flags;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -171,11 +197,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>  	if (!walk->vma) {
>  		if (required_fault)
>  			return -EFAULT;
> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  	if (required_fault)
>  		return hmm_vma_fault(addr, end, required_fault, walk);

Can we assert in hmm_vma_fault that neither the PMD nor the PTE lock is
held? That would be a quick sanity check to ensure we haven’t screwed
anything up in the state-machine walk.

We could add marco like HMM_ASSERT or HMM_WARN, etc...

> -	return hmm_pfns_fill(addr, end, range, 0);
> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>  }
>  
>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
> @@ -208,8 +234,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>  	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
>  	required_fault =
>  		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
> -	if (required_fault)
> +	if (required_fault) {
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;
> +		}
>  		return hmm_vma_fault(addr, end, required_fault, walk);
> +	}
>  
>  	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> @@ -289,14 +320,28 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  			goto fault;
>  
>  		if (softleaf_is_migration(entry)) {
> -			pte_unmap(ptep);
> -			hmm_vma_walk->last = addr;
> -			migration_entry_wait(walk->mm, pmdp, addr);
> -			return -EBUSY;
> +			if (!hmm_select_migrate(range)) {
> +				if (hmm_vma_walk->locked) {
> +					pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +					hmm_vma_walk->locked = false;

I don’t think it should be possible for the lock to be held here, given
that we only take it when selecting migration. So maybe we should assert
that it is not locked.

> +				} else
> +					pte_unmap(ptep);
> +
> +				hmm_vma_walk->last = addr;
> +				migration_entry_wait(walk->mm, pmdp, addr);
> +				return -EBUSY;
> +			} else
> +				goto out;
>  		}
>  
>  		/* Report error for everything else */
> -		pte_unmap(ptep);
> +
> +		if (hmm_vma_walk->locked) {
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->locked = false;
> +		} else
> +			pte_unmap(ptep);
> +
>  		return -EFAULT;
>  	}
>  
> @@ -313,7 +358,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	if (!vm_normal_page(walk->vma, addr, pte) &&
>  	    !is_zero_pfn(pte_pfn(pte))) {
>  		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
> -			pte_unmap(ptep);
> +			if (hmm_vma_walk->locked) {
> +				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +				hmm_vma_walk->locked = false;
> +			} else
> +				pte_unmap(ptep);
> +
>  			return -EFAULT;
>  		}
>  		new_pfn_flags = HMM_PFN_ERROR;
> @@ -326,7 +376,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	return 0;
>  
>  fault:
> -	pte_unmap(ptep);
> +	if (hmm_vma_walk->locked) {
> +		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +		hmm_vma_walk->locked = false;
> +	} else
> +		pte_unmap(ptep);
>  	/* Fault any virtual address we were asked to fault */
>  	return hmm_vma_fault(addr, end, required_fault, walk);
>  }
> @@ -370,13 +424,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
>  					      npages, 0);
>  	if (required_fault) {
> -		if (softleaf_is_device_private(entry))
> +		if (softleaf_is_device_private(entry)) {
> +			if (hmm_vma_walk->pmdlocked) {
> +				spin_unlock(hmm_vma_walk->ptl);
> +				hmm_vma_walk->pmdlocked = false;
> +			}
>  			return hmm_vma_fault(addr, end, required_fault, walk);
> +		}
>  		else
>  			return -EFAULT;
>  	}
>  
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #else
>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> @@ -384,15 +443,486 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  				     pmd_t pmd)
>  {
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> -	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>  
>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  		return -EFAULT;
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  
> +#ifdef CONFIG_DEVICE_MIGRATION
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}
> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		if (new_fault_folio != fault_folio) {
> +			folio_get(new_fault_folio);
> +			folio_lock(new_fault_folio);
> +		}
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> +					      pmd_t *pmdp,
> +					      unsigned long start,
> +					      unsigned long end,
> +					      unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *fault_folio = NULL;
> +	struct folio *folio;
> +	enum migrate_vma_info minfo;
> +	unsigned long i;
> +	int r = 0;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return r;
> +

Can we assert the PMD is locked here?

> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	if (pmd_none(*pmdp))
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (pmd_trans_huge(*pmdp)) {
> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
> +			goto out;
> +
> +		folio = pmd_folio(*pmdp);
> +		if (is_huge_zero_folio(folio))
> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +
> +	} else if (!pmd_present(*pmdp)) {
> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
> +
> +		folio = softleaf_to_folio(entry);
> +
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +	} else {
> +		hmm_vma_walk->last = start;
> +		return -EBUSY;
> +	}
> +
> +	folio_get(folio);
> +
> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> +		folio_put(folio);
> +		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +		return 0;
> +	}
> +
> +	if (thp_migration_supported() &&
> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +
> +		struct page_vma_mapped_walk pvmw = {
> +			.ptl = hmm_vma_walk->ptl,
> +			.address = start,
> +			.pmd = pmdp,
> +			.vma = walk->vma,
> +		};
> +
> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
> +
> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> +		if (r) {
> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
> +			r = -ENOENT;  // fallback
> +			goto unlock_out;
> +		}
> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +	} else {
> +		r = -ENOENT;  // fallback
> +		goto unlock_out;
> +	}
> +
> +
> +out:
> +	return r;
> +
> +unlock_out:
> +	if (folio != fault_folio)
> +		folio_unlock(folio);
> +	folio_put(folio);
> +	goto out;
> +
> +}
> +
> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					  pmd_t *pmdp,
> +					  pte_t *ptep,
> +					  unsigned long addr,
> +					  unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	softleaf_t entry;
> +	pte_t pte, swp_pte;
> +	bool writable = false;
> +
> +	// Do we want to migrate at all?
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return 0;
> +

Can we assert the PTE lock is held here?

> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	if (!hmm_vma_walk->locked) {
> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
> +		hmm_vma_walk->locked = true;
> +	}
> +	pte = ptep_get(ptep);
> +

How would we get without PTE lock being held? Shouldn't the caller take
the lock?

> +	if (pte_none(pte)) {
> +		// migrate without faulting case
> +		if (vma_is_anonymous(walk->vma)) {
> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
> +			goto out;
> +		}
> +	}
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry = softleaf_from_pte(pte);
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page = softleaf_to_page(entry);
> +		folio = page_folio(page);
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->locked = false;
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		pfn = page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable = true;
> +	} else {
> +		pfn = pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> +			goto out;
> +		}
> +		page = vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap = page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner != migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio = page ? page_folio(page) : NULL;
> +		if (folio && folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->locked = false;
> +
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		writable = pte_write(pte);
> +	}
> +
> +	if (!page || !page->mapping)
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio = page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio == folio || folio_trylock(folio)) {
> +		anon_exclusive = folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte = ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		if (pte_dirty(pte))
> +			folio_mark_dirty(folio);
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry = make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry = make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry = make_readable_migration_entry(pfn);
> +
> +		if (pte_present(pte)) {
> +			if (pte_young(pte))
> +				entry = make_migration_entry_young(entry);
> +			if (pte_dirty(pte))
> +				entry = make_migration_entry_dirty(entry);
> +		}
> +
> +		swp_pte = swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> +
> +		if (pte_present(pte))
> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
> +	} else
> +		folio_put(folio);
> +out:
> +	return 0;
> +out_error:
> +	return -EFAULT;
> +
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *folio, *fault_folio;
> +	spinlock_t *ptl;
> +	int ret = 0;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +

Assert the PMD lock isn't held?

> +	ptl = pmd_lock(walk->mm, pmdp);
> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
> +		spin_unlock(ptl);
> +		goto out;
> +	}
> +
> +	folio = pmd_folio(*pmdp);
> +	if (is_huge_zero_folio(folio)) {
> +		spin_unlock(ptl);
> +		split_huge_pmd(walk->vma, pmdp, addr);
> +	} else {
> +		folio_get(folio);
> +		spin_unlock(ptl);
> +
> +		if (folio != fault_folio) {
> +			if (unlikely(!folio_trylock(folio))) {
> +				folio_put(folio);
> +				ret = -EBUSY;
> +				goto out;
> +			}
> +		}  else
> +			folio_put(folio);
> +
> +		ret = split_folio(folio);
> +		if (fault_folio != folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
> +	}
> +out:
> +	return ret;
> +}
> +#else
> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> +					      pmd_t *pmdp,
> +					      unsigned long start,
> +					      unsigned long end,
> +					      unsigned long *hmm_pfn)
> +{
> +	return 0;
> +}
> +
> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					  pmd_t *pmdp,
> +					  pte_t *pte,
> +					  unsigned long addr,
> +					  unsigned long *hmm_pfn)
> +{
> +	return 0;
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (!hmm_select_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma = walk->vma;
> +	hmm_vma_walk->start = start;
> +	hmm_vma_walk->end = end;
> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;
> +
> +	if (!hmm_vma_walk->mmu_range.owner) {
> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +	}
> +
> +	return 0;
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -403,43 +933,112 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	unsigned long *hmm_pfns =
>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
> +	struct mm_struct *mm = walk->vma->vm_mm;
>  	unsigned long addr = start;
> +	enum migrate_vma_info minfo;
> +	unsigned long i;
> +	spinlock_t *ptl;
>  	pte_t *ptep;
>  	pmd_t pmd;
> +	int r;
> +
> +	minfo = hmm_select_migrate(range);
>  
>  again:
> +	hmm_vma_walk->locked = false;
> +	hmm_vma_walk->pmdlocked = false;
>  	pmd = pmdp_get_lockless(pmdp);
> -	if (pmd_none(pmd))
> -		return hmm_vma_walk_hole(start, end, -1, walk);
> +	if (pmd_none(pmd)) {
> +		r = hmm_vma_walk_hole(start, end, -1, walk);
> +		if (r || !minfo)
> +			return r;
> +
> +		ptl = pmd_lock(walk->mm, pmdp);
> +		if (pmd_none(*pmdp)) {
> +			// hmm_vma_walk_hole() filled migration needs
> +			spin_unlock(ptl);
> +			return r;
> +		}
> +		spin_unlock(ptl);
> +	}
>  
>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> +		if (!minfo) {
> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> +				hmm_vma_walk->last = addr;
> +				pmd_migration_entry_wait(walk->mm, pmdp);
> +				return -EBUSY;
> +			}
> +		}
> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +		return 0;
> +	}
> +
> +	if (minfo) {
> +		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
> +		hmm_vma_walk->pmdlocked = true;
> +		pmd = pmdp_get(pmdp);
> +	} else
> +		pmd = pmdp_get_lockless(pmdp);
> +
> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
> +
> +		if (!pmd_present(pmd)) {
> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> +						      pmd);
> +			if (r || !minfo)

Do we need to drop the PMD lock here upon error?

> +				return r;
> +		} else {
> +
> +			/*
> +			 * No need to take pmd_lock here if not migrating,
> +			 * even if some other thread is splitting the huge
> +			 * pmd we will get that event through mmu_notifier callback.
> +			 *
> +			 * So just read pmd value and check again it's a transparent
> +			 * huge or device mapping one and compute corresponding pfn
> +			 * values.
> +			 */
> +
> +			if (!pmd_trans_huge(pmd)) {
> +				// must be lockless
> +				goto again;

How can '!pmd_trans_huge' be true here? Seems impossible based on outer if statement.

> +			}
> +
> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> +
> +			if (r || !minfo)

Do we need to drop the PMD lock here upon error?

> +				return r;
> +		}
> +
> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
> +
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;
> +		}
> +
> +		if (r == -ENOENT) {
> +			r = hmm_vma_walk_split(pmdp, addr, walk);
> +			if (r) {
> +				/* Split not successful, skip */
> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			}
> +
> +			/* Split successful or "again", reloop */
>  			hmm_vma_walk->last = addr;
> -			pmd_migration_entry_wait(walk->mm, pmdp);
>  			return -EBUSY;
>  		}
> -		return hmm_pfns_fill(start, end, range, 0);
> -	}
>  
> -	if (!pmd_present(pmd))
> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> -						 pmd);
> +		return r;
>  
> -	if (pmd_trans_huge(pmd)) {
> -		/*
> -		 * No need to take pmd_lock here, even if some other thread
> -		 * is splitting the huge pmd we will get that event through
> -		 * mmu_notifier callback.
> -		 *
> -		 * So just read pmd value and check again it's a transparent
> -		 * huge or device mapping one and compute corresponding pfn
> -		 * values.
> -		 */
> -		pmd = pmdp_get_lockless(pmdp);
> -		if (!pmd_trans_huge(pmd))
> -			goto again;
> +	}
>  
> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> +	if (hmm_vma_walk->pmdlocked) {
> +		spin_unlock(hmm_vma_walk->ptl);
> +		hmm_vma_walk->pmdlocked = false;
>  	}
>  
>  	/*
> @@ -451,22 +1050,41 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	if (pmd_bad(pmd)) {
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  
> -	ptep = pte_offset_map(pmdp, addr);
> +	if (minfo) {
> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
> +		if (ptep)
> +			hmm_vma_walk->locked = true;
> +	} else
> +		ptep = pte_offset_map(pmdp, addr);
>  	if (!ptep)
>  		goto again;
> +
>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
> -		int r;
>  
>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>  		if (r) {
>  			/* hmm_vma_handle_pte() did pte_unmap() */

Drop the PTE lock if held?

>  			return r;
>  		}
> +
> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
> +		if (r == -EAGAIN) {

Assert the callee dropped the PTE lock?

Matt

> +			goto again;
> +		}
> +		if (r) {
> +			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			break;
> +		}
>  	}
> -	pte_unmap(ptep - 1);
> +
> +	if (hmm_vma_walk->locked)
> +		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
> +	else
> +		pte_unmap(ptep - 1);
> +
>  	return 0;
>  }
>  
> @@ -600,6 +1218,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
> +	int r;
> +
> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
>  
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)
> @@ -622,7 +1245,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  				 (end - start) >> PAGE_SHIFT, 0))
>  		return -EFAULT;
>  
> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  
>  	/* Skip this vma and continue processing the next vma. */
>  	return 1;
> @@ -652,9 +1275,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>   *		the invalidation to finish.
>   * -EFAULT:     A page was requested to be valid and could not be made valid
>   *              ie it has no backing VMA or it is illegal to access
> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
> + *              is too low.
>   *
>   * This is similar to get_user_pages(), except that it can read the page tables
>   * without mutating them (ie causing faults).
> + *
> + * If want to do migrate after faulting, call hmm_range_fault() with
> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
> + * migrate_vma_setup() and after that follow normal migrate calls path.
> + *
>   */
>  int hmm_range_fault(struct hmm_range *range)
>  {
> @@ -662,16 +1293,32 @@ int hmm_range_fault(struct hmm_range *range)
>  		.range = range,
>  		.last = range->start,
>  	};
> -	struct mm_struct *mm = range->notifier->mm;
> +	bool is_fault_path = !!range->notifier;
> +	struct mm_struct *mm;
>  	int ret;
>  
> +	/*
> +	 *
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +#ifdef CONFIG_DEVICE_MIGRATION
> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
> +#else
> +	mm = range->notifier->mm;
> +#endif
>  	mmap_assert_locked(mm);
>  
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
> +					     range->notifier_seq)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -681,6 +1328,19 @@ int hmm_range_fault(struct hmm_range *range)
>  		 * output, and all >= are still at their input values.
>  		 */
>  	} while (ret == -EBUSY);
> +
> +#ifdef CONFIG_DEVICE_MIGRATION
> +	if (hmm_select_migrate(range) && range->migrate &&
> +	    hmm_vma_walk.mmu_range.owner) {
> +		// The migrate_vma path has the following initialized
> +		if (is_fault_path) {
> +			range->migrate->vma   = hmm_vma_walk.vma;
> +			range->migrate->start = range->start;
> +			range->migrate->end   = hmm_vma_walk.end;
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
> +	}
> +#endif
>  	return ret;
>  }
>  EXPORT_SYMBOL(hmm_range_fault);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..bda6320f6242 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -734,7 +734,16 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	int ret;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> +	struct hmm_range range = {
> +		.notifier = NULL,
> +		.start = args->start,
> +		.end = args->end,
> +		.hmm_pfns = args->src,
> +		.dev_private_owner = args->pgmap_owner,
> +		.migrate = args
> +	};
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> @@ -759,17 +768,25 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	args->cpages = 0;
>  	args->npages = 0;
>  
> -	migrate_vma_collect(args);
> +	if (args->flags & MIGRATE_VMA_FAULT)
> +		range.default_flags |= HMM_PFN_REQ_FAULT;
> +
> +	ret = hmm_range_fault(&range);
> +
> +	migrate_hmm_range_setup(&range);
>  
> -	if (args->cpages)
> -		migrate_vma_unmap(args);
> +	/* Remove migration PTEs */
> +	if (ret) {
> +		migrate_vma_pages(args);
> +		migrate_vma_finalize(args);
> +	}
>  
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have
>  	 * stable content and can safely be copied to destination memory that
>  	 * is allocated by the drivers.
>  	 */
> -	return 0;
> +	return ret;
>  
>  }
>  EXPORT_SYMBOL(migrate_vma_setup);
> @@ -1489,3 +1506,64 @@ int migrate_device_coherent_folio(struct folio *folio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
> +
> +		/*
> +		 *
> +		 *  Don't do migration if valid and migrate flags are not both set.
> +		 *
> +		 */
> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/*
> +		 *
> +		 * The zero page is encoded in a special way, valid and migrate is
> +		 * set, and pfn part is zero. Encode specially for migrate also.
> +		 *
> +		 */
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> +			| MIGRATE_PFN_MIGRATE;
> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> +		migrate->dst[i] = 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);
> +
> +}
> +EXPORT_SYMBOL(migrate_hmm_range_setup);
> -- 
> 2.50.0
> 


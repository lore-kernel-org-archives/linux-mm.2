Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A83D12672
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E3C6B0030; Tue,  2 Dec 2025 15:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE826B0031; Tue,  2 Dec 2025 15:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C808D6B0032; Tue,  2 Dec 2025 15:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1C9C6B0030
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:48:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F61716032E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:42 +0000 (UTC)
X-FDA: 84175719684.13.088C05F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 48AD040004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RdATUhDR;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764708519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GS2h4Qo1FwCe6izFZ6zKWn3UqYARAOngylH3jZ6RgI=;
	b=qOEPiuamjOV++lOOvMNo2aMSspvSU9nSjXDk8G85HXnKTaKSVewDTyMY8CBh+PqxYSl680
	CKBvCxyqphpAm9jYtMwUK9b/A2fQhGcIi4idRkd0AOYQ2syX+nfmpfkMGLNSnRQzIHBdkI
	ndv1End1xyPPyYc5ytFTzGjmxd3xxF8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RdATUhDR;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764708519; a=rsa-sha256;
	cv=fail;
	b=O3DvDVgsBklNbiutd24rG4Y5r/hd/BORUZAlNkx2AE0HIX7yyP9WMPm/3A/ViuFt0P/Gcc
	3xJOaNoZE+xtXghZwl9cEuYo5kNYm6qQmfiYVFeyMpaDPl6erPhhQZrDiTrmJ/AwCTJArQ
	pzeztMXGeiF/DoS6BqxKGxiqTV2lIiM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764708518; x=1796244518;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NAwaiwnHtIpiS6s3WI8PuYGyW94qCMNyBHGYrMMm05Y=;
  b=RdATUhDRlV8IZQU5xjlU22Funh+vG1Vlq4irSnMDqNNi3kHqJJxvUrBr
   vE5l17/t1BvuMwGqQ971bQn8IMixabYzJHDJDgA1RFCTaYzRWXDbA3Vxw
   sGTT+WtalSvTVuDGhaqHRnZQMkinaRWpRtk9WabyuBMRzdcYxLURb9y7R
   MzV11dvzQ3cFHxWnhICxVbsXOqXROH3mrFS3H2qugoCOnUdCnrHltLdmV
   H0Optgq0OGYgHGu1ka7fES0RhpvwXMKIWlZu7nBfuGmW/3+ONQvobjPMZ
   Kc5kfDztX5z23WIcAvKlTDqp83DUcuT0au60qK6/jdIpGkCpSdVRJS2KQ
   A==;
X-CSE-ConnectionGUID: zDLppQuvRw6MjAydxm4waA==
X-CSE-MsgGUID: abMF17SPSkW9fdiWuzP1Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="78038310"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="78038310"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:48:36 -0800
X-CSE-ConnectionGUID: oPhNQFjJSSO/Jc+pJBPhuw==
X-CSE-MsgGUID: 2gt6s1MKSxW+gqLQQuhxwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199431116"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 12:48:36 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:48:35 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 12:48:35 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.11)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 12:48:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6uvhP9dd/eLe62d18VdgR58QNYniRost8q+xShAijtseOpJCdP4pHeuvCL6CWdMxdJcwq1EBmUZRMW0roURkDNw9SlxmG3SD/uLsUajOXHj+q56zGYCWU3BPg443V4i3pYJdnSc1XZ9H9mmsVr3FNBpR2vWibdt4aElEriiVy1BqgOEXaTtEacSJUrjGwPacO3arxmhXrzTzRPCCB3uUUTEOWwQIHyBnko6vnl0SNiU24LliHsnUPWCVuaCS7qylfT3t+xrXdgL0MUjmcQOXPDDSVuIHdGajAZClpYUpz6SYnWvcotZFT1DLPFuI7ImNdkFciV8whQGCFG+SMceLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GS2h4Qo1FwCe6izFZ6zKWn3UqYARAOngylH3jZ6RgI=;
 b=VUkEK8HRcqzOIc+O3teB9qyw7HNekbxznU3kv2jbhroAE6BxKAFB+lk7Aq1VEDNWdFycLnEhwp9w+c1/P3ImuPlZLmfdh6QyUqZOznElc57yJUw0Hfx2od/OuxN4SQWfc2iBbcSv37YLUmq9xFw5sOLemh5YNdytR43J+WUzULWNxMzJu97xDU5MRNGexLkfN4cdbFFOmfM6LjO8FA4L+/+1XlMmFpN99EXcNuftftzX6DdkI0gVy+DfGxfrsqfz5ZesloTF5a6bZKTgn/psF4ZOAtdz3BmegtdivYHe+weIsZs/u8EpLPdk6R4h3pqE8alp7PKyyhWID5jRRW0OEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3282.namprd11.prod.outlook.com (2603:10b6:208:6a::32)
 by SN7PR11MB7043.namprd11.prod.outlook.com (2603:10b6:806:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 20:48:33 +0000
Received: from BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19]) by BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 20:48:27 +0000
Date: Tue, 2 Dec 2025 21:48:02 +0100
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
CC: <linux-mm@kvack.org>,
	<syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com>, Andrey Ryabinin
	<ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, "Danilo
 Krummrich" <dakr@kernel.org>, Kees Cook <kees@kernel.org>,
	<kasan-dev@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
Message-ID: <xfqnzil2oiidogd2drvjrzg4dymydywkge4zws2dildgqvcr2v@ns45a6frntpf>
References: <20251128111516.244497-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128111516.244497-1-jiayuan.chen@linux.dev>
X-ClientProxiedBy: DUZP191CA0041.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f8::20) To BL0PR11MB3282.namprd11.prod.outlook.com
 (2603:10b6:208:6a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3282:EE_|SN7PR11MB7043:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c19f9aa-8d77-48a9-e203-08de31e4245d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S0M4VGE0eUFMYUxKck5sWFV3cFV4NUNkQ0RVcG5VV3o5RVpFN3dJY0Q5cGp1?=
 =?utf-8?B?Y1FXeG81S2RKanJiQlA2YnBucVEzM1Jnc2dGNUpEcUJacmI0UEZuODBxNHds?=
 =?utf-8?B?eTB6anZSbExiODF3bHNlWG5kVlltZDdVRDIyWmExVit6OEg4NlA1OFNmUUY4?=
 =?utf-8?B?RzJ6R1RsRXhOdWw0aHNWMGFXaFlFazd6c1lZRG9VcVJUeEg2M2pGVjlOUVNy?=
 =?utf-8?B?YkFJTzVyK0Y1aEhyT01GRTFHTFhZS3RIVFE5bnk2RTB4NHJyMEt5R3MzNWJi?=
 =?utf-8?B?ZXRCdGpqWVY2eVMxYnBlbDBxTDVmUWhZeXhkQ01jWXBVM1hiU29wdmZLbk9n?=
 =?utf-8?B?OW9uUFptSmNWLzAveUlwbXFHQmpoQlpidDlSMjU5K2pBRUxzTWkxTWtQNVRM?=
 =?utf-8?B?eGo3SlJhMERUZ0xjemRheVFlRldUdXhheFRYSmpqUUU3K2tmaXA1emh4Z0Jq?=
 =?utf-8?B?bW5HdUo5c0JNVFBHRllPR003bFdmTlFESU9wdCtRUUFERzRDS3UvS0VXSERV?=
 =?utf-8?B?L3RjdUU0aDBxaVpYU1d0L1VmSHE2cUF2Q0l0RkZza3Jiem45YTQxcVVFTVV0?=
 =?utf-8?B?Sy9NWjFFaFF3eEZvTkltK09CVmo3SHZiMFVsNGNmSHJtM3hRSmFORStSNWRE?=
 =?utf-8?B?R20wVmRlbWhoSER0ZXNpYTFOQS9FNDhKQ3BiNmlzVE9RdVUvR0oxVkNMV3Z4?=
 =?utf-8?B?ZitacThnNjNmdVZTVHBrWWNIazNuSVdyY2hOY3pZeDJualRScm1pVGxjbzFN?=
 =?utf-8?B?dEdOSW9valkxRGhtaWlId1FZaVdEeXFRWld0N0IzcWg5L2NTUnVOa3diMEFl?=
 =?utf-8?B?NTNyWWJLaXo0VHZndHpDbFFCUTR1NGxYTHAxMHdPSE1XVEJFYkdqTjN6eU1y?=
 =?utf-8?B?SEdnOHZOM1BHZHVFTVhWUmpLOVpad2lxTldrNDUrMHVud0VDQmZCZlg1R3Zk?=
 =?utf-8?B?Zjdnc0xpcnZnSU10UXdFVTNraG5DNHRTb3FFYkI2c2gzY0ozWjVLZVJaRGc3?=
 =?utf-8?B?NTRkNm53WVpoWGh0UG02Vng4MEZrOEhsVmwwRDZua2RqM0g2TFl6eVY5M0Nx?=
 =?utf-8?B?VEVQN0pIT2lXcnFNekVEWndLTjRhTG1xMHBIemdPRXpNc3BqVG8wNFFZR1Qz?=
 =?utf-8?B?R3k4MnlrYzNGRHN1dDY4b25QU0t1M1E0cTZuQTJVbzFHczFpUG1ySURpVkE2?=
 =?utf-8?B?R29weGd3UkNqRUh5WlpzQkF5dCtybjl4Q04za2JHcDFoRHhPMnBLOGwrd25K?=
 =?utf-8?B?SUhlb2JQSkZ0VE1UZ1UvaWZlajlwdmg0TlRRQ0dRM1Q4RGtDL1ZUMmZIOUNC?=
 =?utf-8?B?QmVWaGpYT0wwRmNJcmFOYk5CL1phbVEzaFIyamN0c3BEYlB2Wm03UnpwVlph?=
 =?utf-8?B?dVJ3aVN2Q0M2b2xIQThDTG9LbjQybG9nSHdLQXc2WUdSTjFGcFI2ak5oMGNl?=
 =?utf-8?B?VmF1Z3ArWlk3QS9IbXVmdzZNZFlmOXQ4VHNKK2lRNkc1Qk1hSElFZkpaTldm?=
 =?utf-8?B?aG1hYitzN0JqUUVLNW9BT2tKM0tVMzNrcHJINXFVdjZMZXdoMkhiekU2dWlC?=
 =?utf-8?B?dmZoR0dzUExmZjhLT0NiaVJYam8yV1JxWVhZUU0zYnFqbG9RQXBTTkhOaEMv?=
 =?utf-8?B?VFlDOGZHbnB5S2pvQXpOREZyZGJKV1E2ZFcydFQzVGcycHVmYVdsN29IQTZU?=
 =?utf-8?B?eldJbUZGem9DTDJxM3hSQ0JPNnV5QnMzQTR2TDRBYXpkeVBCc2xIMVFLSEJ4?=
 =?utf-8?B?VHd3YU1Nc2pMWTZiUTNUNHdSYmdPUE1CSWlVcnA4WEYrdGxpKy9aNm5ISVJi?=
 =?utf-8?B?VE9NTzV3T2hGMThQYWxLcm5IdndMTEJHMUQyN2w2RmRRZUVabmdTOUZFS1dK?=
 =?utf-8?B?V2FyK1U1clRKWVNJaG56dFVVWUVXckl6RnpCK3RzaSt4VlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3282.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXlHbS9NNHp4MlFkUmRHVTdGci9VUzlhbTZISGVNVjlwM2lWbmdNaVRIMUN6?=
 =?utf-8?B?RkcvNjdhTGJmUFhRQ1lQTzk0d3JiT1ppUmhyRC9wVVJ4TmtEWFVkRVZvZmFy?=
 =?utf-8?B?SlhGMGRBbVpWcVNUa090dUd2bkhRQXBLZDI4NXhodmRDS1dmQXFuR2dFaUU5?=
 =?utf-8?B?WmtFTUdGelhra0o0bjFwSHk1UFJrcTlkR2N3YzRBdTVhVkRDanBZdEh6VGhR?=
 =?utf-8?B?dG1tVFVqSXRrKzRCcWJUY21kRXFuZ1B3TzNQOUNwWlA2WE1uSUNYNXQ1Q1NQ?=
 =?utf-8?B?OU1tdWlMZTl3MmJtMlBZQTZIZi9ReG5kRWhEREhJUThuSmVXWVBZRDFBQnps?=
 =?utf-8?B?OFhTUjhGVnF0WUtYZlA1NFFvY1BHd21ncjFiVEZTMUNVazI4RWQyWm5Sdjlr?=
 =?utf-8?B?YzJtMWdmdzQ1Uk50MDNWbFVJRCtDNGM2VGpiM1BESDdkKzVxSFljZ1gzWGxi?=
 =?utf-8?B?bnNBWC82WGpkNXoxRkw4RUQwdGpqSEt1Q1JqRnl3V21kL2tXZks5VFd2Y0RO?=
 =?utf-8?B?SjMraDA1WW1LTU1VdEowU0lNSGlXb294N2hHVGNZOFhzMFp6WXVteFMxN0xK?=
 =?utf-8?B?TU5weHE2NEFKTDJ4MitOT3VGYmhXVE1JNFZHdW8zY3EyT0IyWlQzeGpXcGlO?=
 =?utf-8?B?ZkpxVy83WEUzbFJCTVZlQlVSekNsM0I1RU5XWGFYdkUwN2dOVWdVWWc1c0cx?=
 =?utf-8?B?QjZYUXdHdGpoMkxKZE5saDBOZC9VY254c1ZTU3B1cjNaUFNPd0NERkpaWDlT?=
 =?utf-8?B?VVN1RDhUaWRRMDN1NmFTWHI1L2dFUzYvcHcrWkhrenR3NVNQM2dqMXF2V2Jv?=
 =?utf-8?B?ZUNkWERxWXJpMUtsOHVsQ1FReE5rdjkzdGxRalVmVHdINjJqWGtCYkxHQTFJ?=
 =?utf-8?B?akdDa0xPWks5eWd0Q1pESUkvZS9vZU53TjU2OE51dWxWUnNoZXZoRHR5QzBj?=
 =?utf-8?B?VUh0TXhGeWpmb1A2b0h6KzE5ZmErN1FOdGtKS0Nhd2tPaFdKSS9heVkxQk1U?=
 =?utf-8?B?dllBOWhoNURUODZTdUpxY0lRUi80Wko1d09USUIvTWtxTGxTYWFVTjB6YlFl?=
 =?utf-8?B?eGZwRlpoaHhPTXBvdFdrV0FCNXYwTFJGdDB4RzIwWEVsR1VmV1BPbTNib2N5?=
 =?utf-8?B?WThudElpUzA1SlpIc1pPRUJyTzNVL1cwSkMrcUxxZjFZblg0N1lQTjJhVTlv?=
 =?utf-8?B?MGVKdGdkUG9ORzBKbUN5ajB6eHBjUlF3QlYrQVZRVGxGbzJTdCtUMnBLV0lJ?=
 =?utf-8?B?NVFKbzZUNDJhaFplNFhpbFZZQllLT2FtUTRpMTBuVFphSzRFQks0K3l5OHY0?=
 =?utf-8?B?OEhJYlNsMWRmNnNuc2E3eUtidVN5eEU0S3Q3bUhMWU1STlZjZjRUNzZKMTJZ?=
 =?utf-8?B?OHhoWEpvQjBQSHkrVFg3MzdkTkNjdDMyck5wRUh2SE5oNXJQY0hJUzBxcHRm?=
 =?utf-8?B?QnpmR1d3Ty9UekYrcnlZMVBUaEZ3V1pRWWpnSGt2WGFGVkxXRWI0c0JzdWpD?=
 =?utf-8?B?dE9MRjRvWWZ5OGN2clZCWUpyU0x6TGk1WEwxYWFwR3Q2MjJ6TnVaTVUvL2VI?=
 =?utf-8?B?T1pHK2NoMmlSZVE1NlFYV0RKYXpQTzd6a2k2QnQ0a0h3aUQraU9Nbi9qTnpJ?=
 =?utf-8?B?SXRINWFISGRiLzVTcTZnQkRDdUVlbnpPbTNod2Fza09oajJicXIyMnh3L1pS?=
 =?utf-8?B?OEZlNjR2VzVEVFI4b2dQS0dOVDlDdzBpSUV5TDVKZU82ZzRnMWdnRHlzS3BV?=
 =?utf-8?B?SGxKTW1oYTV3aFFQV05hNDhOUktNUzlkWU5CdGRtd2tJZmxSNFJUM0FJYVRG?=
 =?utf-8?B?SnhxWm4vaWVsU0l0VmlXRktPZDRiZlZ0NEY3c2JOZEJKOFQwQnF6eUpHQXFa?=
 =?utf-8?B?WnJPMUtaTVhuUHZkanZPblRMOVlRa1NOeUNWVXBHanc2Qi9DRFRSN3pFZ2tR?=
 =?utf-8?B?bGhLOGpXeXhFVFZhMEo3OGRuV04wMkpkQzVuWHIrUkVhTHFzTFVHcU5uVm1x?=
 =?utf-8?B?MndWQXU5cmQ0N255SGJPL0t5c2tEOWx2STVOOThmaytCdFl1aFhBd2d2WTE3?=
 =?utf-8?B?Zk56YVdUOGwyVzU1N3Y4a2h6cktkcFFmREFXL1BFWWVPSk56MnI1T0ZWZ2I3?=
 =?utf-8?B?WWtvTDZyVG5Ka29WTGExRGxnRFV0cmJRL0NQcm0zMDBGMS9hR29RQTkybkxy?=
 =?utf-8?Q?kMubvgWgddKhUQ4GD9+WHw8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c19f9aa-8d77-48a9-e203-08de31e4245d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3282.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 20:48:27.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwiPKGTFAWLRDSeOR5iugTn+ghUySDgr5MF3L49ILiqtp7McbA6EGhdlsXruM2ehyURKzzycg1yoajJ2Rg6EpMbylLy6wPicpVMaW+aWpLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7043
X-OriginatorOrg: intel.com
X-Stat-Signature: dph8oggozfo7raw6wnnxjfmahtqqfsb9
X-Rspam-User: 
X-Rspamd-Queue-Id: 48AD040004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764708518-791448
X-HE-Meta: U2FsdGVkX18O0fzXvRJM5eH/QDpSl3M/N3c1DperIC/rGDdkDUF+e0mgBg6iW0ddniXuIAIZwYQGvoY64hFm7+ZuOtAyL9IqZy6xxPVJ3BSvdcIV11pkr47cPZE/VreGweVCZrGaJ7ozBnMvR22NW2nyjoQNjLJn+NDxR/QTy5DD9rpi76VmE2xmKqCgyRXSKNajfx7pISPbOfTov7s5HO00NrgWuccf6VIMOXSP0neFSP182u/zhOb2a2xzIaQzKgfjaL8P9RDMg5eEjgqcgOGXCH3ujQ/rSj+UI8Kc1Di9xP4WhN/PYj85lyQFYt2hhXWSBWSTlfyaRSqpRAJvnO1wU4kHZlOEYrSBUnlumLqAzFAXaPXs92PAUlKv+hXCbWDl52wyZyxWXpQdAByeuPvj5127v3hOKjeBaXh7d2YmwlhEDyzy1a98FBkFl9DsbNSwb4ZFJuD5lQ8UjPFsyipsHWwOdG8AqLRppgvyMP4uNQSxswW/ZDmgt+PBi7b32hfolP7S1VecdHFdYSiEubQIpdRST3dYZugIQ1pwnRiwe0GK5leh3DGZhW9Cj4KQ+wL0cBJT3e33K7LAsYmiaCYmE/Y7pyaz0YvaWq+Wfr1MozhU5iTjIHgv3xmkvV8G7LiduyUGokUj44yCB+ok8Ie3yePUA5P569OxspuqHtnuHk0RDTxDpjFro/dAFE2HQc8ya7bgLBAWmbjvzkRCF1NXbB7myMD3jxICMPhGuN3urLmau+PMCs9TFnHJhlag4kBkX5cdUHYurCuDoBSHqqZ4oAoQUv6cMB0QIs33yrEpT6QCijuZbs3h65bsFzMd5wMDIebN1z9PrZMRl1D+C1dZQxp0gc1irjuPICktsO9jJ+TMYYspmJW1YSeMESWm/nTtcNvEHEL1q1fQjOauH1x6DiH+nd5OtxUWEenM/dMORhPWgGUZA7MBUJqAe6Y4gXjPIjmt3FJ1B/NtkSc
 pMKMaHmI
 8JGLQutuayyzKyxnnkElx1uGGVUMoZiKk9I78H8MuKI6nhREwMaMYdpOjLTdRlYjI1NJZNRpKi7DtJXOPsihbs4/QjwFVtVkOCpNzDr/VyhigYDh4HiDd0E373D18McCFXMpaOnLEMXukdTKQg3rkvEt+BUNXXyf+yBzmcTZ8DdtvA84k58GMeF9UuwiitezTQCcCZ+eS19hjJ4nnUJF+FFOLKMZbFU8MX4Vav0IP6iX+mTbyzOs8/35pt6CliR6rDSGyYN5DzYs3/JuyNf+Uo3RqcaKjLO+ZBPj+rzsHcQjRooSVH6+PXtlIcJsp0YcfNrrexmsmmZKj3fTEUbjse6fY1Lv8l1JWrsDM9CDmz/rPhrKfCD4WWJrXTC6rFoBZqcGivg2siTMkZg8+wF3ItPVeEtzG8Jmasi8JegbQODHELt3LlYMn1WrGM1xyz0BRDkMp8/mfp5jIz2xj3PZbWbVxSGyi7Ip458HKyKVoKFsh9nEf0CK5Zr7AeLNOib284SBH2x1ub6rvmL+JlXeMXWi1XG4859NDl4hD5P4rmBEdcDV6rXIFADFrMwvLEOBw3IQKQ5OiAb9+bnsHIaODDpZ2qOFQiq+mproZTIXNXDqIXZww4OqOckImx+b5ZWVk9eImKujKJkrSIj6Un+vmDrpDckNNVcUtu/SzHsX823l7TbDKytMQVRLyj5R2R0VKuVsFuO5Wwu1NnEFtlm9IyNSqF8y5W/oAYe8dcK6LVUJ9D6h30ESSpLbiPBsZMclYM3wm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, I'm working on [1]. As Andrew pointed out to me the patches are quite
similar. I was wondering if you mind if the reuse_tag was an actual tag value?
Instead of just bool toggling the usage of kasan_random_tag()?

I tested the problem I'm seeing, with your patch and the tags end up being reset.
That's because the vms[area] pointers that I want to unpoison don't have a tag
set, but generating a different random tag for each vms[] pointer crashes the
kernel down the line. So __kasan_unpoison_vmalloc() needs to be called on each
one but with the same tag.

Arguably I noticed my series also just resets the tags right now, but I'm
working to correct it at the moment. I can send a fixed version tomorrow. Just
wanted to ask if having __kasan_unpoison_vmalloc() set an actual predefined tag
is a problem from your point of view?

[1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@pm.me/

On 2025-11-28 at 19:15:14 +0800, Jiayuan Chen wrote:
>Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
>issues:
>
>1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag when
>   unpoisoning the extended region. This flag is required to correctly
>   associate the allocation with KASAN's vmalloc tracking.
>
>   Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitly
>   sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it.
>   vrealloc must behave consistently — especially when reusing existing
>   vmalloc regions — to ensure KASAN can track allocations correctly.
>
>2. When vrealloc reuses an existing vmalloc region (without allocating new
>   pages), KASAN previously generated a new tag, which broke tag-based
>   memory access tracking. We now add a 'reuse_tag' parameter to
>   __kasan_unpoison_vmalloc() to preserve the original tag in such cases.
>
>A new helper kasan_unpoison_vralloc() is introduced to handle this reuse
>scenario, ensuring consistent tag behavior during reallocation.
>
>[1]: https://syzkaller.appspot.com/bug?extid=997752115a851cb0cf36
>
>Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
>Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
>Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@google.com/T/
>
>Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
>---
> include/linux/kasan.h | 21 +++++++++++++++++++--
> mm/kasan/hw_tags.c    |  4 ++--
> mm/kasan/shadow.c     |  6 ++++--
> mm/vmalloc.c          |  4 ++--
> 4 files changed, 27 insertions(+), 8 deletions(-)
>
>diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>index f335c1d7b61d..14e59e898c29 100644
>--- a/include/linux/kasan.h
>+++ b/include/linux/kasan.h
>@@ -612,13 +612,23 @@ static inline void kasan_release_vmalloc(unsigned long start,
> #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
> 
> void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>-			       kasan_vmalloc_flags_t flags);
>+			       kasan_vmalloc_flags_t flags, bool reuse_tag);
>+
>+static __always_inline void *kasan_unpoison_vrealloc(const void *start,
>+						     unsigned long size,
>+						     kasan_vmalloc_flags_t flags)
>+{
>+	if (kasan_enabled())
>+		return __kasan_unpoison_vmalloc(start, size, flags, true);
>+	return (void *)start;
>+}
>+
> static __always_inline void *kasan_unpoison_vmalloc(const void *start,
> 						unsigned long size,
> 						kasan_vmalloc_flags_t flags)
> {
> 	if (kasan_enabled())
>-		return __kasan_unpoison_vmalloc(start, size, flags);
>+		return __kasan_unpoison_vmalloc(start, size, flags, false);
> 	return (void *)start;
> }
> 
>@@ -645,6 +655,13 @@ static inline void kasan_release_vmalloc(unsigned long start,
> 					 unsigned long free_region_end,
> 					 unsigned long flags) { }
> 
>+static inline void *kasan_unpoison_vrealloc(const void *start,
>+					    unsigned long size,
>+					    kasan_vmalloc_flags_t flags)
>+{
>+	return (void *)start;
>+}
>+
> static inline void *kasan_unpoison_vmalloc(const void *start,
> 					   unsigned long size,
> 					   kasan_vmalloc_flags_t flags)
>diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
>index 1c373cc4b3fa..04a62ac27165 100644
>--- a/mm/kasan/hw_tags.c
>+++ b/mm/kasan/hw_tags.c
>@@ -317,7 +317,7 @@ static void init_vmalloc_pages(const void *start, unsigned long size)
> }
> 
> void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>-				kasan_vmalloc_flags_t flags)
>+				kasan_vmalloc_flags_t flags, bool reuse_tag)
> {
> 	u8 tag;
> 	unsigned long redzone_start, redzone_size;
>@@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> 		return (void *)start;
> 	}
> 
>-	tag = kasan_random_tag();
>+	tag = reuse_tag ? get_tag(start) : kasan_random_tag();
> 	start = set_tag(start, tag);
> 
> 	/* Unpoison and initialize memory up to size. */
>diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>index 29a751a8a08d..354842c7f927 100644
>--- a/mm/kasan/shadow.c
>+++ b/mm/kasan/shadow.c
>@@ -611,7 +611,7 @@ void __kasan_release_vmalloc(unsigned long start, unsigned long end,
> }
> 
> void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>-			       kasan_vmalloc_flags_t flags)
>+			       kasan_vmalloc_flags_t flags, bool reuse_tag)
> {
> 	/*
> 	 * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
>@@ -631,7 +631,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> 	    !(flags & KASAN_VMALLOC_PROT_NORMAL))
> 		return (void *)start;
> 
>-	start = set_tag(start, kasan_random_tag());
>+	if (!reuse_tag)
>+		start = set_tag(start, kasan_random_tag());
>+
> 	kasan_unpoison(start, size, false);
> 	return (void *)start;
> }
>diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>index ecbac900c35f..1ddd6ffc89c1 100644
>--- a/mm/vmalloc.c
>+++ b/mm/vmalloc.c
>@@ -4330,8 +4330,8 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
> 	 * We already have the bytes available in the allocation; use them.
> 	 */
> 	if (size <= alloced_size) {
>-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
>-				       KASAN_VMALLOC_PROT_NORMAL);
>+		kasan_unpoison_vrealloc(p, size,
>+					KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC);
> 		/*
> 		 * No need to zero memory here, as unused memory will have
> 		 * already been zeroed at initial allocation time or during
>-- 
>2.43.0
>

-- 
Kind regards
Maciej Wieczór-Retman


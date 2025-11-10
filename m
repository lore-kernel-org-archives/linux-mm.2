Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FE1CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22528E0024; Mon, 10 Nov 2025 17:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3498E001F; Mon, 10 Nov 2025 17:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1DD8E0024; Mon, 10 Nov 2025 17:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5718E001F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:34:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B8FCC023B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:34:39 +0000 (UTC)
X-FDA: 84096153078.05.C054B32
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7E30180018
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:34:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RMRdP1cl;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762814075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/fY7tvI5R7rAsEHMgLP+uXYW8XH0Rx4cWFzDnIBSGk=;
	b=Yqyl+qGI0Bmmbkg+U9VQVPbti08kCstkMAtxSPtJ5izfs31iQwbP1Xt1E/aywu1WZf/uG6
	Eh8iY5FC5SF9FRempNbW000vGwzdNy1KWLHFJCFXWpCMDmvsT2kQLTQzg0c//r3Jt9qO3/
	zlwEwDMHdFLUyTyfHEWdEH49Rpo02/Q=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RMRdP1cl;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762814075; a=rsa-sha256;
	cv=fail;
	b=VxbN6FYeUU6fXp4U5CskNuc483Tcd6zMi9bj9Tr0aFf84ERYCX87rw6aCgAjsH6TtI3aEo
	c0OHrQCXkNwW4+3qjnLCB/4APdNM/RVD8S9LC5eD6Raukm99TCHqsDi9Dmy0fD8HYrl+x0
	cdH3LNVMsCH3xZzMh8vENlOWNAUfZfg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762814075; x=1794350075;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=0sos2Ez4AY+vSl+Tax/Wi4Z8J7QduZL0Re46Z8p9eKU=;
  b=RMRdP1clNLptX6oQtJNGc60mrQqBA8jznNtAfoE5/DDaNcUyZF9VS52y
   2ZkWR+MkiZRVnWT6zGHN3zfTxOP7MuQxxEiwr5zy72GvPGKBRspA9/yG2
   wVaSKZ5oVHAI4FbPL8xJ05BiA2mIbqOLeHnNz9F5cEW3dQl1boRmyaz/O
   5bcInBU8irCOzx4JSAGUDD5IyxtlxuODtfrAMEElgM3Jq0Dhy84llvrrl
   p6JrtYalAJyKgOir9uYxZLmsZ5beEhDOfNEu8stJiSqTuGXtVUv2Rv0vU
   TKkEGJ7I+yqU1HlAmpUya46VuIgQ+3nSIVrXwKKGyuHRp687FLxWuC+KC
   w==;
X-CSE-ConnectionGUID: mzQj5+2pSXWntlTs5DasaA==
X-CSE-MsgGUID: xT1txMKLQNOAhd69MElhww==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="64906606"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="64906606"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 14:34:33 -0800
X-CSE-ConnectionGUID: tJ25cxe5RnquxPOuFzgeVg==
X-CSE-MsgGUID: zotyXG1fQ7mKRS8Ivvw4Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="188627801"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 14:34:33 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 14:34:32 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 14:34:32 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.45) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 14:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQKGjg95T+sR1sKEXK5Nmk9NjZyBEMa5Cp2gl2fFDL4mOg9kZ38k6+Wz9nBSF5ZsesOA7v7fRo8OhAnYX8eIy9DkIEd4VZqf4XUk8u6Nly8s6oJ1IqwDok82gfK9AEcLG5RDU8FBeVDqnOdaR+YAIatBcWmhFwHzuiracbE/w/uc9asYmH0n5dKw+f+PUZ5uKUOugAWIXdbBKVbORPO3IvdilMbHt1F6Q2tEqVivEMZnelsXl0Ej6seR6WM+0rFIBEAH8nrMR3GgQtYbL/smz/xkvY/+3yxwEy8xs4VtkPt3VWhqetIWYayKG9BZycxUGlJxXv8ssDugx1btoE8i0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/fY7tvI5R7rAsEHMgLP+uXYW8XH0Rx4cWFzDnIBSGk=;
 b=idSS6RT2a0hXEwpeFiqvydw0q+Fv12diy8EWMi7BB16vGZY2vY7lhB/if1RLLUaDDnZ5GSTKtTYDWuYdceOonoWaavs0FtTsL9Fc5G/jsiosLd3JLn8AKrDnDQA4Csf66kgWj23luhAvwhrup0zf9BPjREFoTHP90lVTHPeE1YQq4Np9etGa6mAcwjLysMricxbHgodEQhDkQQL0phB/EVoz3S53TbkIjBfr+eWRtQD4WYq1lXnlEG4ZbjFcWKQ4rIikvvCPnqiRYTwFTsPtfxBc0Dh2vXe8o2csR58tiN03kOIVaunjrxvTX2iFVZpX9NUjFw4eROIttPlkIIf/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7538.namprd11.prod.outlook.com (2603:10b6:806:32b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Mon, 10 Nov
 2025 22:34:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 22:34:24 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 10 Nov 2025 15:34:22 -0800
To: Balbir Singh <balbirs@nvidia.com>, Dan Williams
	<dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
	<peterz@infradead.org>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook
	<kees@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andy Lutomirski
	<luto@kernel.org>, Logan Gunthorpe <logang@deltatee.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
Message-ID: <6912767eb60ac_1d9810070@dwillia2-mobl4.notmuch>
In-Reply-To: <d6ad21dd-82f1-486e-8a0d-b007b39b4d32@nvidia.com>
References: <20251108023215.2984031-1-dan.j.williams@intel.com>
 <d6ad21dd-82f1-486e-8a0d-b007b39b4d32@nvidia.com>
Subject: Re: [PATCH] x86/kaslr: P2PDMA is one of a class of ZONE_DEVICE-KASLR
 collisions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 7deb052e-38f8-4a71-1d62-08de20a94cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzY3Z3Z1SDRkTnI0L1NJRU52OW1MM08yaGlncGsvTDcyOFUwUDgyNWdHN0pK?=
 =?utf-8?B?c2JFMWIxOEc5OVRLYkxrNnBDV29FcnN1a1BhUjU3eWFpNVdoV00xK0dFdUtY?=
 =?utf-8?B?YmM4d2x6bjV6UzE3NmZpeTBFM2U4ZlUzbks4NTMyQTBFTmpmektxdll2ZUtR?=
 =?utf-8?B?Vy8vMVpuT2s3aE9lQzZ2YWJDVWt5ZU1hRjh1ZU96cEl5MUJGdFFRb3ZEOHJC?=
 =?utf-8?B?cUw4dHRLVkk4VG1UUnZkTzUyZnJHc0J6NDJKQ21RQ25BTncwa09zbmlRdDZG?=
 =?utf-8?B?cnliNTFGWGVKWlZjbUI4bm1SNHFObHBBRVNRZ3JuRzYrdnQyb3cxMlpoUFZD?=
 =?utf-8?B?L21YbUlvZUVHU092OVNUWWhQZG9sbmVOdU9rVzVKWjZkQ3ROS3pVQ1lBQ3B0?=
 =?utf-8?B?T3JHYUl3T3lDTnVVS1BmYk16Qjh3a09Kb0YyK3lxZndpUzM4KzZEK3pIWmtr?=
 =?utf-8?B?NUpZN0o5YlFRS0t6aG41NGR5cFVOZVJhK0JxODFFS1MrZHJiRTJySEZQVnZF?=
 =?utf-8?B?ZHhubVg2aEN0QXY0YkZLRjFtVEpIenhERzZDcUdnZTNOeWRVc2JkbzhpYnFj?=
 =?utf-8?B?Ui9lTnYxak9BQVVzK1R2Q1BVL04wblQwWkFaZW94M3Y1Sk5LaUNKa2dYTk9y?=
 =?utf-8?B?U0hQdmZydEl1UDI3OUYyVHIzbkJVSFFGdk5SU05mclh0Y1YwRVQwNVZUNUJv?=
 =?utf-8?B?RXd2WktkS3RHUDdMamNwWEJhWlVuRkZlVUNUZlpMN3pONGE3YTAyUlpGenFp?=
 =?utf-8?B?MXdKZ0JteGg4RXJLcU9BSFBva3FWamhHVmc0dENvWHlkUkFpWFdwUmwrQVla?=
 =?utf-8?B?VkIzV21RTm91bWdWb2gwdlNMYlR6VkxsV25LYUtpN1FaYzlCQTcvaUs2bVlk?=
 =?utf-8?B?aUljOUx3YjVSVFdXZW9DVlNlMjVzbVlDVGpXOVpRNFJDV2xTc0ZESlhjdFY0?=
 =?utf-8?B?UXI5NTUxWDA4WkZXWUoyYmU1L3JKM0IyaStHQWp6Tm5VQjE2TWE3OEZ0UmxW?=
 =?utf-8?B?eEJaQTVhdStNN1QyYkFMOStiMnBHWGNyK0tndkNRVlIzaEVPWFVHMEdKNGJz?=
 =?utf-8?B?VWtKZm9KV2tEVk0rUWdjVVExd0t5enREY2VRRTFQYUxMSGFUYWo0YXROcCs3?=
 =?utf-8?B?M3BvMzBjS1NvUm5NcUY5blFTbElDOTIxS0lvSDRKYlNlS0l1Y0VqY2Via0hx?=
 =?utf-8?B?SmdIYWRYaUJTMEIyMHltdS8yVUhzc2NpWXA3cWVRcTFrRnNOeU9DOGJONk5J?=
 =?utf-8?B?a1NaWFFXVmRkY3h6MzdWMHhnMk1IamM3WnlJUEo4YlVNQVBJVjc0clgxMHRS?=
 =?utf-8?B?cjl0UWNIVjdhZFhkTzVJRG5uQTFrcXdDamM2ME9OalQ4WmV3TFdhVlRJUisy?=
 =?utf-8?B?eG90Ulo1S3hyWmp0UnM2L1dnT21VNmNsa0ZMbVdqdGpVOWdZaXVPMjFIUHU5?=
 =?utf-8?B?cEg3dlFzbGdnTTNqVkFhZk5SNkdJRFZ0RmRzWjBFMlp2d3JkNEZLb2JXZi9N?=
 =?utf-8?B?aENmcnRkc01SZzdSbUd0VE5rb0xWOU9FY25vSUgzVWgreldJZ2QwaVpPZXRv?=
 =?utf-8?B?dVNaSjB2WHhaZEFOM1BJRCsrOXBpakNxNE11QURFY1M5T2pwSjhZaW5qUFB1?=
 =?utf-8?B?T29nZzBmd01HS0pzMkdUbHM3eStlQzJxdGNqR21ROGIxbGxkSGZCRXR5MUdy?=
 =?utf-8?B?eXVzaFVMdTB1SnVNZmZQbHBWbzdZZDVZS1hud3A1K1lBT1JkMzdCRGlvYVlo?=
 =?utf-8?B?ZENldEJudzZhYzlWU2U2bXpWU21wQmM5WWxlN2tOUEJCM29nSzVVbjVNcnhF?=
 =?utf-8?B?bHV5NDV6YmFWc1VNb3ZaUXYzSTRwckJMclhhZkJURG1rSTh6TkxtSlQzOGdP?=
 =?utf-8?B?cnljeEpjRGEzWThoSkNQVmw1SlowWU9BRVNsdjY1MnFYbzJCQ1dIZVY5czNY?=
 =?utf-8?Q?pO24X/xacNyPQi0s9gDEPRlwcbw8p0HC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGVOd3BSaXpvWlNaQ0FzSjE4YW56bTBYL3ErbElXd1Ixa3NvUGgvTkZkVERN?=
 =?utf-8?B?YVlwK3ZQRjRRZjZXRjdhVGVoSlZGMFJOL1ZDUTZ0ci9TanYxNlpaVlVNQytv?=
 =?utf-8?B?dWc5NlNwVGxtOStNNVc4T3ZCSjc1TTJURGJpTm5mV2FRbGxyVXZSR2NReGZa?=
 =?utf-8?B?V2JrdFpTMllQQ2ZRazYzRWRrK3dHdFBGakxxNCswbkJNRnRCcmFoT0pvS001?=
 =?utf-8?B?Ni9NK1BZdnpsb1o2ZEpsR1dyaitocVRQOFlZbHoycXNJMFFrS2I1YzNzQmti?=
 =?utf-8?B?VTNQVU5oeUczVE1mWkVKMS9iTmNPUm8vNzk2RzZCZ1RzTFFYSzE1Q0dKbWly?=
 =?utf-8?B?ekhTMFVENUR4QlA1Q2tIUXZHbHJiN2x4eWZxS1hxN1ZlcnpZbDUxQU9BeFNB?=
 =?utf-8?B?UmZmSms2Mmo0VW9PajI2N2pJUXhwTjRRWFE1RmdsR25HSERZby9DUWhCUnJE?=
 =?utf-8?B?NXZHUDQ1NGtEVVNrREdsQnUzamRmMGpuOENFNjlNa25DR0ZhdVlPL25hM1h0?=
 =?utf-8?B?V0Y3ZGFTWUlGSitzWFVUeEhlajZlWTZDaGFiMlhRUHJEbWxXUFdydklFVy9E?=
 =?utf-8?B?UFJUMmx1R0lsWlhlT2xQWDl2RzBvVURXRmI2bndPNmNxc1RlbUNKUkhQVVV1?=
 =?utf-8?B?MHlON2FQbHM2cEIxUVZmRUszNWRnQ0ZiUnNuMzNmSlREa2ZKUHlPM2pGVkg0?=
 =?utf-8?B?Q0FBeFVITUFRcFR3TG9WcjJZRjJZaktrN01MaHNScUxPSWk0dWJVajJ2dGdt?=
 =?utf-8?B?N1FBa1BHUXRQeEFxQ3pVdTBYUUgvbDFDdmV3em80RElnMFArTnRwUGMvMStM?=
 =?utf-8?B?dW1uRHVGVjNsSG1GM0hSdm9GMy85dXo4dVhJQ2t5REU3aXR3c2RUUHAyYnk2?=
 =?utf-8?B?QlVnbnlublZZaGlUbE1BWHN6VVRuVUZVT3lZQ2duOHNncmtNd2x3Y1pOeTYv?=
 =?utf-8?B?MFZHQTNpUjg5d3NCdVgzN1ZKY3czcFA3SkdiVzlCenE2ZUU5UEV2R0hDelBs?=
 =?utf-8?B?YW4wUGhZQ2VBeldTOXZLOW5zV0MreHZiaFltVWhuUWJSYkFGMWJDMWVRRVVQ?=
 =?utf-8?B?cEJYTmZ4K0x2Z2NzOHdOWVRaYkMvNVRUdmlBNC8zNFpmcTVuRzRjQk0rNFBl?=
 =?utf-8?B?QWR2WGVoQWN6TzBmSGVQR2lNeTVId3pURGVRY1ZlNkxGODJ6bDJVdmNrZHNJ?=
 =?utf-8?B?aWZJK3N3OUVpTXpjZTRkOTMvS3JpNW5CWHRLd3lvalpQZTNkZGswWUpIdnEz?=
 =?utf-8?B?UmpWTFpKWVJOdWtlVG42ei95U01aOVlvUm1Pd0JqTnd1SVFBT0FBMFZXMUpZ?=
 =?utf-8?B?VnNwWTVLSW1wdGFTSkZpaG1aSFh3Qi9ubkVoa0NCOEp5eVl3YWxoZVRhVVFR?=
 =?utf-8?B?OEthTElYQmxsWUx1bFlZMW81aGwzLzhyVExVRVN5bDJQcm5tdDN5QWxtdGQr?=
 =?utf-8?B?UThnT2RXdzhUMXFRSWNBZE9tTUdNYVF4elhKcVoyQVR5RnFYT2swVkdTbWNY?=
 =?utf-8?B?N1RPQjIrTTByMnV4MlVIMTFnYmg3ZFYrbW4zYXk2MXFCYnNXTWlVYmR5TWt3?=
 =?utf-8?B?Z0xSNDNSVjdFVjVLblNwMXM1T1AyUit0Nk4rZXRRR05sc0Q0RDJ1MitBSjBR?=
 =?utf-8?B?bHlwdVp4Y0xKdXBISXNUSkdHSUxxb1JreGRaMXVFWXYxQVZYa2ZXTkIyNzhT?=
 =?utf-8?B?cWYvOEdPVkZ1VnNZN3BXbU5UQlFPY1lGZWJxL0FWYzZrdlBMdUFSdXlZb1lq?=
 =?utf-8?B?Y0RlT1k0YmNITWRqNnZNcys0QXorMTNHK1BYZjVMaGlNek1hczRNUDB5QmJE?=
 =?utf-8?B?VkNRLzVPVW10Z09iREhON0dqcFBua2orSVdtTjk2S3JjZWNDSFc1Q1lQTDFv?=
 =?utf-8?B?aURsUDRBUElVbGU4SVhKanFtK1lkRWFubHYyK2JFRHRaR3V3N3FIdG9NazNO?=
 =?utf-8?B?WjJQcGYxOUVHcDVXSEtPV0dPQXVUYUxhbE5GT29CRldxRXdna1dnMHFpeEp2?=
 =?utf-8?B?Qjd1MGEwWGZqblQ2OXZnNXk0VXBtRG9ZczcyYUNtK1RGN2JSYTZxS0d2WWZn?=
 =?utf-8?B?Q2o4a1F1Qm9TWi9nY3NsV3RWRU02NzlKZHo0QlpKeHorU2RVWldMeU9IOHlF?=
 =?utf-8?B?SmR5SS8wUHBQcWNJSVQxekpJcUFqbXd1TWxZWVhXSGdHa2x1ZWxlU1k5WVd5?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7deb052e-38f8-4a71-1d62-08de20a94cf4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 22:34:24.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTRPWcjAAP3zL2dgAx/DvOtsVQxlnWz4IbYrzA4JJbMj5fEYv+37IdipGyXyKI9DAUFakHNPFYDBBb2r/ykjSZojh6IIGJdC063q+rSee1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7538
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7E30180018
X-Stat-Signature: owzzq8d5tz6u4cyf9nxabhpbwbnswdfx
X-Rspam-User: 
X-HE-Tag: 1762814074-687949
X-HE-Meta: U2FsdGVkX18LneaZHQ1lPS8/hnzE2H5YlBXo4HlWJillEFH84fMaDjPUTWz43S8xzF0+We9qiqeEC1dONw0Dg0NAY8pHHEyiprxxWRYNojY248c5D+ts9T7VeP7yi27alGD0gYpprBWoc7YWmHUnsjH9xTkjBeFtUceHYcrseoGE32NgpUb43iBvOv8qjhn/TUS1TDnpXUVmOM4UB8yZSwqnJdOReSUydm+/8Af/gGsJteVOh0rzH+bItElQsSczwYqggLdb7t1q3v0kiKL1VdtAd2aav4gP3FpOJXNzEOVIN8XMmyekCs8IxWo1iq9MTdsyXc91tUYUHz6vY9w8B0l5tkOtpylyp3itGLLTfMsR4na0zZsrmvQhPTxh9MKQR+tdV9U6SBskqIVFvVIi1vVzZYPQYMo4ah9iUTJL1/Xu/fLveZs0v723ld6pPwN0KNO3oq/xCzLjH0PO57kMHNSTkWckqFLO5tDqcENpSFBw8v9y/qFzOpIL0MaasPQMlbfECDFtSDUmHAdab72Yq12kyrxjrBCz6iClKTBr0UiwdlqlfWZkmPF1nDuDoqZE4TWgPmczg1sEcRSzjq0Ke6qXL0fB/NyxEVxlv0O5IqMvcisHa89Jdi7rgR8KUvvoFyyloYScKlAY4mA6dMUKkiCrfwsorybVkHAHShxdd7IohkgEr0TCHoHdg/nRVyvqqcuYFpbCKwXtyofDb6PTrelYKWZBR0Auk+tBIkZptgh9/PigcVYZ0uydlYXhRTvDbPUR7I0n9h4l+GddMnwYQWrOx4Ea8UhJOKFlHtQejiTlCemPi5rz+VulnJ6yWaUWM1WMu4QkGQxpROWC1uuEIY6ZuCF8FANuclGCHy3EXDi69ieIl1l/I0U3eFFDNLpXuAxNKUxSAeUSePByTXrX354UDWm1dc35RWeBpvSw4MwJY3qrx0bGn7m/cHe6f1A2Zkc+SNgIWLef9W8pdJD
 4u12kFA8
 BeLjVO84SER4dDxUY+IGryTC2EU3/FZDqYdpjEiu7onQHf/Nw58+H1VZtxlY9hISBw+ftg/23x6FMlTCt3+v/Tu3nzw9p2s077XFlR10t0GgPrMKSA+lY/N0tlREK+OxcHZmVF9V+7cS5b52pB2pvJGV0fIm8kyxQT7atpOA22FXduh/w2mOfAWdkfZIfAHnFd2gzGnwqwVutAVTyGUFH8MDqZpTkp/3R0ZOxPcL9+X3KP6abDu+8+fjscyHMiBxoH7Xbd6tC1pKxTfFf/rGsThS3OjJQ0rpD2s8jcXBfCEWJOZAh6myurE/craIhDpI8mR5LDYTgD+rvNEsJEWyJ1fTGq4HB5HakpNyXOJfD6VF2B/AJ4lRBTm1mXkrJa8YN5WFW+FIslxbqFXfBPOxd0tGYzgD4lSAbjVVWHyn/IaEMHM2K1uQ5cRiFvE2bYklbIunY74FXnUCWpP8xn5IrQHYQ8SB3rkp4p7KyMrAAmKKclFOz6glW7k9FQVB3udl1wHAYnixgssLue0dK4B98pB1kQCsVWdzvzvxro9Sru8IYBduNfCb004FcDQGl1/NVe35KOPVJsSM9vKP04hKgYJqi7tTCY0V+KNBQN7pXR+hqZeSASQVSrIHMbtEnbIveA18wnnkJzT/7A4GxYRq3SExxcwDGvmM66qDwl5qY4XAIWJt3dskcOehgmWgZEQnRAOPK0qUcBK6MDDzaONGjd8F7iwrj/r8ANop2XmijSNA21WDJco4O8GOoC8MkVxOQmeNXRtBPRmjHaIpGUXvGbjR6Uwg6zuPK/FYxgkO2r/7K6WPZDk9e8MXB0OcLtflU/LzSW3BVxn4t6T9S0yGWNiBJMQMMZ4J1doMU8Bs2SB0rGj4u5AmaxFale0mzuRLqwDS5VHpGF5A7btjj8s3hEZixJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Balbir Singh wrote:
> On 11/8/25 13:32, Dan Williams wrote:
> > Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> > is too narrow. ZONE_DEVICE, in general, lets any physical address be added
> > to the direct-map. I.e. not only ACPI hotplug ranges, CXL Memory Windows,
> > or EFI Specific Purpose Memory, but also any PCI MMIO range for the
> > CONFIG_DEVICE_PRIVATE and CONFIG_PCI_P2PDMA cases.
> > 
> > A potential path to recover entropy would be to walk ACPI and determine the
> > limits for hotplug and PCI MMIO before kernel_randomize_memory(). On
> > smaller systems that could yield some KASLR address bits. This needs
> > additional investigation to determine if some limited ACPI table scanning
> > can happen this early without an open coded solution like
> > arch/x86/boot/compressed/acpi.c needs to deploy.
> > 
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Logan Gunthorpe <logang@deltatee.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
> > Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> P2PDMA requires ZONE_DEVICE, Most distros have P2PDMA enabled, you mention
> smaller devices - are you referring to kernels/distros where P2PDMA is not
> enabled and only ZONE_DEVICE is?

There are 2 considerations

- Occasions where P2PDMA is disabled, but ZONE_DEVICE is enabled.

  I started looking at this after a report about CXL failures with KASLR.
  I do not have the kernel configuration for that end user report, but I
  can only a imagine it was indeed a case of CONFIG_PCI_P2PDMA=n and
  CONFIG_DEV_DAX_CXL=y

- Occasions where ZONE_DEVICE and memory hotplug are enabled, but ACPI
  does not publish any hotplug or CXL memory ranges, and BIOS did not
  find any large PCI devices at initial scan.

  In this case even the default 10 TB padding is overkill and more address
  bits could be consumed for KASLR entropy.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559A7C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD436B015A; Thu, 22 Jan 2026 06:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5046B015C; Thu, 22 Jan 2026 06:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D836B015D; Thu, 22 Jan 2026 06:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 964F46B015A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:42:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B48C13A5FE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:42:48 +0000 (UTC)
X-FDA: 84359412816.08.FEFFE4A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18D5C140006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:42:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aZsi22qO;
	spf=pass (imf26.hostedemail.com: domain of kai.huang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769082164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQpzXOpngcRXhGi8sXjM1bYN2z0BTBsnCN6zxqtbgPQ=;
	b=VXKYen7nTEtv1WPOVyjaXDO7TuYPEfAYCReQyKqFbeGkV1UC+/9z04u+crdwK3rQTl/PlB
	8y0LP/ZlqbhHcZvAkNFmN9Y+KwEDoD8Rr8Ly/SmVJPquDAnUZ9hK2GhdcRBn6IuXdl0sfv
	Zua6tLOJKSFZiESEdgSw3xGe94uhyMc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aZsi22qO;
	spf=pass (imf26.hostedemail.com: domain of kai.huang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769082164; a=rsa-sha256;
	cv=pass;
	b=SvX62gJYyN3e5+L3mdB5AyBT6yUJ2dZQJA4K7fxukv0AKwd3CIqK5V/rvKnmlz00cMF5rx
	+TOO+4Iq8q+EnP4ILDx1hV8EaI1ivHb+7Yc0OnEYfHN8SFzXegG65R5cUScxw3PtQnKF0g
	VW/ENXroIvTC3DI6keFeSrMvdhJnVRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769082164; x=1800618164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pQpzXOpngcRXhGi8sXjM1bYN2z0BTBsnCN6zxqtbgPQ=;
  b=aZsi22qO7vcXbKtcCNw8iADN6ZCPYGXGsprsLzhoLaVzD+5LvpUmA+aJ
   xvUeSPZNgrS0zYdJZdKszFzjSwBFobPaMlstN8ImlAo492nM+yOXrvnOg
   SQKjbJedUHdKbp4mbCXZ3V2KHexGX4XuAqRYWG05xWKy+prR2Q4Y5kMqi
   5vwuKMpLVMHWjHE6kOfVSi4O+Ws3yxcXNnJFgX17uufepOYbUwgI2nQGC
   BlDryB3K0Bve9DsgA5NVaM2HSQCJkGY/ZNrx+KpHpz7qiEclxPV3Mf7Au
   57JKyRb2GC+yovA/JJsCNRnUJD021cMBlCQAbGCFwOb4GQrrYFjYH8sGf
   A==;
X-CSE-ConnectionGUID: a2owBXqWT+a3lXwIYOTACQ==
X-CSE-MsgGUID: VX//qAwPRou+G8bAUu8QMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70413819"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="70413819"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 03:42:43 -0800
X-CSE-ConnectionGUID: lGiQEMFrSBSlP9ZmmDJNag==
X-CSE-MsgGUID: UwJKVQB+QAeH7HtGJ8n5og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="206766589"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 03:42:43 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 03:42:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 03:42:41 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 03:42:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBrUT1D/c8XylLAjfOGOQsQwS7R5ZX0lPitxXmAFmUFAIbLNYVPrE+mQeVPqTt5StW0G6kU35lREUsR8Nv2aExr2ZTv6cKxU92yAbWZV4SImO0ZwPKACJVupGRsQyp1nC4m0MYfPAY9Y+RM6bnKNAQymVZxZ+iULfKThX7cs1xc+B4elbQ3QoS8DuTSM0UWbqdsKuBeJHhpjG1gBJOVuZslvA5qHHx7sZ+kEQ7DjwTm8r8/f5/xCBynF36rzAvQP40k+97z4e32A9+VTFSDCAvDgaENcPM9hX3259+Jo0L9k7u44GCebd+EYgWR0SabLpKFAva8I2G3QdTBBzPI2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQpzXOpngcRXhGi8sXjM1bYN2z0BTBsnCN6zxqtbgPQ=;
 b=L1zQJEL4EsZtWsNxUrCn9o6BnsRm7xuCWloBb04FWTl8pZWF9jFwrO4x+DkCUApi9wn5RJrBDxKImCRjfHd+IBF4e8M7q5Fb7dxDP9U/2+Use1zVkDUWC2LXos0U4GBDTOUa7Hjhut141doghfSSPjnqXyaTeo9GshuEp6rzpG8FVcWCjnyAtHbxpQwT/ir3/JpcfxH3mbohnlmyBWFklsGqn4JdBl/bcLZDBrpCP+Sj28rd2d8bYZ3gYEL6kcmdbSxtiZi2N1Xvw0TqJ1f9K2VRN64g7K0SvClVnxwm9+aBX3E41iROdJFlOSCqkTCVe2YM0iJoStu2SEBOb4g53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5303.namprd11.prod.outlook.com (2603:10b6:208:31b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 11:42:40 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 11:42:40 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tianwentong2000@gmail.com" <tianwentong2000@gmail.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Topic: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Index: AQHci2OvrVHiW6G4B0+G6ZNtoMAEMLVeEaAA
Date: Thu, 22 Jan 2026 11:42:39 +0000
Message-ID: <bfaa49c58626932e65096b433c7f37a2c35ca382.camel@intel.com>
References: <20260122055435.95911-1-tianwentong2000@gmail.com>
In-Reply-To: <20260122055435.95911-1-tianwentong2000@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5303:EE_
x-ms-office365-filtering-correlation-id: 67ea5738-a35b-4bf8-281e-08de59ab58f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZVNtMGkyZ1hBRzlhTXU1SHVIelZNVXNqSTk1THRzdElKTC9RTWQ0S0lVbmJ5?=
 =?utf-8?B?dVRPN1I3NTlVT3RydWpaZ0lpU2gwcUZxeUpHeHBnRERHZ1h3VXZXbGRVV3pB?=
 =?utf-8?B?Qkw3VUxzRnhLMSs4Unhic1hqeFA0bEthRTBhQkY5Z05FVWhuWXB0VWVVankx?=
 =?utf-8?B?emROWGZ4cG5xdFJPQkVCY3FzTnk0ZVlEZXJpQW9uaFlhbnBSWnpZdkdaK3BC?=
 =?utf-8?B?SjJwT0I1clVMeFFOcGUyU0NmMEwwVUx4bVorOWl5cExVL2R3Q2pLSmphcVlR?=
 =?utf-8?B?Nk5zUUtIUHF5dzd5Y2IxSWdFeUJhZTVCMWJMTFdWZmxXeHpYUnQ4WEFzOUti?=
 =?utf-8?B?VE1rUmRyeWRZcjZpaGRIMDhoZEIwSFVnVjVVMjdoeVdpL1hJODhQTWIyVjBU?=
 =?utf-8?B?N1NNM0pYR1VYV2RweG1GV0dCUysvbldpckRsQS9Ed08yVEwvRFJtSzlDbDU3?=
 =?utf-8?B?cmxGWkdzNkUwdTcvT0krb2JESmhDdjdGWWZRL2wyRGhTWDZiYTJiZGl3UUQz?=
 =?utf-8?B?S2ZWNjNYMlVlTHJFcVdSbDBob05Ia3h6SnhTbTdWdXhzWmpjckRpR2NuSldU?=
 =?utf-8?B?SFh5ZitRS05kYnkrMExuaFFvTGZ1bEsyRGdDQW45UnZvVjFDQkJtckVHVWdp?=
 =?utf-8?B?RnA4WTJnOWozNVlhbk9pa3phNmFzTS9TYW1DcDlQNlgxVVRFZFh1TnFPZHc1?=
 =?utf-8?B?dGtDU3Z6MHE3Y2kybWVFV1JzdUVscVpiOEt5Q0M5aXBLVWFUTysxZFJvZ0VD?=
 =?utf-8?B?WTFmd2ladWtwZjV6MFhSWDFhUDdJd0hVMGRreTB3bkhmOTJ5NGwybnhFelRm?=
 =?utf-8?B?WFg1OVBuQ0RlZEFjdmhkdkxjTXNWUkxvRXE1Z2QzS3ZXU3llQTRsMEFUL0to?=
 =?utf-8?B?MDV3VjhZUVNoNXUrK3pJOW5VSis5VEwrQnU0cU4xOVp0eFkxbnB3eEthamJp?=
 =?utf-8?B?OUg5c0JHTHlkb09aQ3FNZFpRK0FHY2V6VXN6Sk94MVVPNjdla0ZkY1V1ZklP?=
 =?utf-8?B?aHBUa2VNWi8xa2VPVnhmTE9ndTZvSS9NM3BabFB3OGhVeWJ5MUZjbW9kUjVU?=
 =?utf-8?B?d2RyMDNaMmVraUE3ZWhjK3RCRVVhcHQwTHI5MGg5RWtZY2l1WmlzaXp6cXRj?=
 =?utf-8?B?NzR5bUZESXk5SUNuUE4rbU0wMGpvV3Zja3lOek1DOVdvSHF5Tm1kdk1IOExG?=
 =?utf-8?B?MHE5K1BXZGV0aDZJdlNUN2dhNG54ZktQOWlNdVU2UmVSVmVHZmdrV0M2cnR3?=
 =?utf-8?B?VGxZNjRmMG1uaEpycU1xSWFpOWRkOTQ1QVJ0ZjBrTUd1QWs3Z0E4c0FmdjVu?=
 =?utf-8?B?blpMQ3lOSVVJNjMzTGxXSEJWVVdseUVMV2dhMDZOcldNTG5XbVFuQzI2WFBD?=
 =?utf-8?B?enYzcWNvS1N1MCtsQVU3UEZGcmxpNVZpMWJqQ1ZpcGYwY0lHNTFHUzdDOVpx?=
 =?utf-8?B?TzV5dXhSc25GQ2FVZDlKb0JmWDFrY21Lc1JRY1NPdVE5U1dUSUtzZzlrTDdr?=
 =?utf-8?B?bDF4QTNoMnp0ZEdKbGgyREd5WkkrT1JEcnVNWXRDS2ZyQXNtN3RiSi9od2U0?=
 =?utf-8?B?ZlBkaHB6TWwrQlpIOGtNOWt2VVRhVkd2cE1vcC9nZ3lVZWE0dDM2bDRFTFl4?=
 =?utf-8?B?SGJWQ3p4TWJ2UkZLVC9UY3VuUFBNTk14U0JqZVBibThwc2dsOUkySnBnZUg3?=
 =?utf-8?B?a0JWN0VVRnlRN3UwdmhjdDA5UXFpenFIYk5HaWlPR2NyT3lBeitEUHB0bEM1?=
 =?utf-8?B?bGM0dHlhQ3I1U2MvTWVuNWJlbk5BQzkwcEQxemFlcDV3ZEx5bkpybnNrNGh3?=
 =?utf-8?B?ZHpwaE56aGFYaURMZit2MFN2Q0ZqbzdNbVhCbEUvd0VrS0JYTnA4OWc0VWh6?=
 =?utf-8?B?MnVoRU1CWnMwdUtRN05pWk9qT2dNdFNCSUFhTTdKdkFpUmROUGpBUkViZkdj?=
 =?utf-8?B?bkNYNkJINDBuYUhpem1wb1B0bWN3eTdVUENTYmd5N2NWZzU2VHNoNnhmTEpJ?=
 =?utf-8?B?WGlnRFVRS0ltejdsSDNPZU5SSVVDVVdwTk9aTGtlTytWeUFubktPb1ZTWmVP?=
 =?utf-8?B?dFdhUXRvTHNwVXFzTFY3bVpqcTMvdW9KQmZqSStvOWI0dmtRU29JKzZzSVlT?=
 =?utf-8?B?R2ZWQzExZXg4anFHVEF2TzZ6dG03anlOL2hXTlBIWDJ0ajhXbWFsc3FNbjRT?=
 =?utf-8?Q?cT6Ad1AatqPFAZiDdHn5ofc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnBmdGE5WTIwM0JKa2dQWlI1VURmYnRwZnNvWUdwTVZJcjc1c0NNbWhzbjlq?=
 =?utf-8?B?bUdvZGNRVFpBeDZjbzd5RExqSzJ4SGFyaWhNMjZ0dUR6RHFKYmRiOEMwUXN1?=
 =?utf-8?B?ZjMwYjRqTVd4OEpHNTVGTEhkdlkyMzBvcXl3L0tZTXdRalM5bkJMekVxZ2FE?=
 =?utf-8?B?aDZEUno5YWZQd01RYkRCTTl4WjVCc0htbTdZdlVuYnp3L1FwK1RGUWxQUHdM?=
 =?utf-8?B?QjhadlVHa3h5UDc4ZVNudFlPdGhYelJEdVZwTHlzZ1BydWpmNzliOFdSV1Vk?=
 =?utf-8?B?MjJBNnF1M2t5ajV1WG03ZHlqYzVRc2dWWVlwVklMRTA0UGhwamwxTU4xYlVh?=
 =?utf-8?B?YTgySXI0aXhPYVhlUjVHMDljOUtiOHczMG9lbHZYbUM2a3F4azhOOHRGdENZ?=
 =?utf-8?B?cDZrcnlDZ3dBMTVUTy9tcFE2bXMya3pXS2t6MG5HVG14bFlkT3VXcHluVWVJ?=
 =?utf-8?B?eHA3SFQrcUdzUHhlRll3aXlRTHFvQnl0RTQ5YWRobDlCMkttaHVHN09tSy9w?=
 =?utf-8?B?bFZBdXc2WkpLeGVTdGMvN3locEdVdFVSVkxmbmloYUtxaVlyZXovRkRuRVA5?=
 =?utf-8?B?VkNQVU9qS3FDZ0lHSU1RVzJwbVdQTFg2bjN2aXdyRlRncllpZFR5dE5reGhj?=
 =?utf-8?B?QTR3amV4N05BZEx4S3RZTkRPT3A2bzZmYWl0Tk9vTThOSWhHMExGSkx5dTNL?=
 =?utf-8?B?QS9hdWJWcHZ1SEQva1d1N3IzWlBvdUx1dUhmei9OYWpMUzBjSW10TUlWWDBo?=
 =?utf-8?B?Z0tWSmFoYXdOUmZIanFTa0JtTUVPWnR5N0MrV1hGZlN5QmI1V0xlMkJFc3By?=
 =?utf-8?B?SlNEcFFzd0t0djFjTEhiZjJWWlNVS1pZc1lqZE1BSkZOYXpEcjhmNktuZmN6?=
 =?utf-8?B?LzlWeFovSFRmMSsxbVpOVjhBTDE0R0ZuQm1ndGo4QXV4UFN6MkpERCt6K04v?=
 =?utf-8?B?bFgrN1RlRnNTWnIyZWRkZGwxNUJQalowZEVCS1p0bklkVzdrNEF5ZlFEMkNz?=
 =?utf-8?B?SlovRDBLVG8wYllzN3MyR0VFanFBQXg5U0tYbk1VN09ocStDU1k4OXVuQzZ1?=
 =?utf-8?B?UjlzMG5Cd2JLZVZNYUY3V0FEbG1sV0E3UGZiSW5Vc0I3UmVJQjBqczAwb2gx?=
 =?utf-8?B?NWtLVFZXSVVFMm9CWlNzSGdsa0pUZDZ4VUhEYTNxSXBiTGhWa0ZZdFR0bnAr?=
 =?utf-8?B?NHUwcG5hdlRxMjA0QW9IOUZ0NHZncmpZLzU1bTk2SlV4UzBiYXduQXpnbEpz?=
 =?utf-8?B?Z1UybTliTldKc2VRakxJbXFsUkdvV2RHQ1QxVjJoS25MRFFncGdQRmhTaVds?=
 =?utf-8?B?SDJ0QkIxbG9IKzVibERGTmZ3RmpVVDlZcU4yRUFRWFZtQ25BLzhGcEhBUDZ5?=
 =?utf-8?B?WE1jYlRvSmpVWlBlUitlZUxqRFIrT3BBZTJmR0hSbkZQcFlNQkFHM3RNRVZl?=
 =?utf-8?B?enhzcHMzY01KcWR5OGxuSHFjRU5tbGpRWDFtem9zbWx1ZlZKSXlrL2pRc1E3?=
 =?utf-8?B?TGtvR09mVFVNeWloNzVGN3JZREZtVktzaEdyL2EzNUhiQWl5aHBoalVsMDRa?=
 =?utf-8?B?aW1zRDRwYTF2NGZMakJKWUc3SWU1ZkNjOGFtZm9TZzNVSFlNNDU4RFIwdFY0?=
 =?utf-8?B?WlpjM0pYdjFDWjQzbFpXS2grcEE4UWlzV2pyTXR2anBTZ3pIdW5sNzRzdUhK?=
 =?utf-8?B?ZUExNzVwWHJ2anBzc1dXelcwT2JCVnUxeHRVczFQdldLR0E4d0dyYURaUFRH?=
 =?utf-8?B?VTBjZ1F2ZmxWNFpKTHpkSWxzcE9LdnA2R2xFZUVZcG5RYk5iNm41WXhLTUNC?=
 =?utf-8?B?aHZqaU5OS1hZZWlGOGdHZDZoOHlvci9yODF6S0FhVDVZelJFRVkyMys1UVhK?=
 =?utf-8?B?RFpwSlRRNExJM29SVzVyVWxwVHFQLzh0MXFORCtyRnVXQTNwUEhyTVlpL3Z0?=
 =?utf-8?B?WVlRMUpuWUcrL1Z1cXJKeUJ4NElzZ3FKZm1DTzRCZExCa2p6MkdTYzRRTU1B?=
 =?utf-8?B?R3piMUxQSjFFcGpySVZvOEhldHVwMkVYUVVQbENDeU5qRlNjcUxTUVVYQ3pk?=
 =?utf-8?B?T2FXSjhuYjJsV0NKb25QMFI3ZytiaW5GZGpVbTNhb3lSSDhWeHZCbGVwSjlp?=
 =?utf-8?B?R0tnczFEV042SWVaR1F5cjlGWDRGajJlNXpaMHhEMXd3UnY2T0o3ZGNpMFFB?=
 =?utf-8?B?SnFKeDIzcTg1bEFRRUV5ZVd0dit3bXRxb3k0YUdJL2VycS95Y29MbCtuOEQr?=
 =?utf-8?B?UjV1d2ZzZ0k0ak5xeC8zR3VXdXNnVmtIRXhGQURDdGM4czluOFp6VjhpMWFE?=
 =?utf-8?B?TmVEaHdsQTJCbERxVlJQbEFNZjYyT1RWL3c1L21yaHNaSyttUjA0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43F73B57B5556E408B37BC83EBCC26A2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ea5738-a35b-4bf8-281e-08de59ab58f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 11:42:39.8844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REPqsE67fliFGXo/KvDz6uTaROPttJdpTrJpTIwfvxzlOsF4fllD89puWeOlQmgyvZr1zHe8g4o5V7De95pufw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5303
X-OriginatorOrg: intel.com
X-Stat-Signature: 7zkfwaipmmcjw8h9ip9r33xqwjdmakt7
X-Rspamd-Queue-Id: 18D5C140006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769082163-366630
X-HE-Meta: U2FsdGVkX1+ZCOCbDuON+zDRnSwkA3N78ZGem9ji84haOljN3VlEUVh+J5duI7gobI54oUshdPzj4cuNwjW7yYQMRCOIT6I33gOXkSa7XcLfGiAGWhD61/yj18M27N/eFpfBaoxrZaYi9RdA8JzXLY/qwToE1ZNVywHY6i09a4A5GFDbpllrdGEW23OA9PUIs9xxHya5AOJsCBplmO8r2VfZzRqlT+SfOJlSNheQBGJUwpnyAWn3RdorQpDfyi3USaSXpQKtvynJ3mP0C/Ws/x2r6jPn1aJV0FYEOO+ITLeoGcyQyQfr8PmR6aW6xs7SZCuet2QowGsgfv8Yy9iegiIcWomb/MqvdizZxgGXtCpl5LIK16ewH4gdopoh02jL1vO176rrBMZg6CLtPvupEvh0qII+fFJvfWYUUbf6IIE5I21DeGBGPkkluNkmBEczg0RIyBjTMJijItcYUapCyw0Vosm8c5SRkPrER/nlOvs+lFa66Yl8hOwK2+X+Q2U6UxyAZEZekxko3pcx9V4OPYvgS6YfwzQI58qSmZ2tIrjtDwBnsevBnFvFewW8dStW+0gYNs4keKTFa7eaH20/nejWl4YwwEQyVZJ1rleLeS0lV5giSsiUNUZglVhlyVTLefoOiEdKUghat/45kYYNnKup2Kp3VDU7Ugr0xJTVooj6HH0sypnq2GIlcpSSiCIuvVP6UOQcJdyaTUPfuMsCjE4LHwgkr3rSv27it2Tcn4bGj9eK/0XsxuQcAfBOcJLs/iuSyQWCkcmyZElSDH3eIb9p0QMferux8lCk+ER7V3jHZrBal94JBC6oW+iA824WrSv7qfkGMAc1xpLxO52aXfd5NaKL1iko+6eYlrIbXY8s5+b5hSxMBfxFWXRVG6VdpfFrW59wZewb6KouiTndZif7LEg9tMZBAfy7mJtj7RnAGVypqHa5g6Ngp7ZMyAmqyKz8BWvxMkwyuxbo+Om
 yuIAMDID
 kK//XTQiOGhmf4Ds8ZyFGjmQXuPgCYlsDQb9c6YHJqNt8++Sk6ydk0nAGlFtfHEUgU4b7/qJQap5B9qf6g6AQS4Vbv256ZTJg2jPIaZ/4jMxwZF0I7qMUXoL5hIiw08Ny+r9pKFBNxosqzZ9ZV/BUnp6biJ1se0K0LUDnOYoHHZmAb9hRwqdOcuddP6gdffzpzuWOE2MrjRPWgY7oL9FCml1w/LkowsDccPglPpSErGIiXMNO9b0JROyAIs9u5yA1ADIqmiGgpE73qsQZrqAStifdPmZG2U77aBqHaAXPpzJWx5VYSn2tvcC7KdpMCOMSfLDJu1YBrEfnjeO8sN7916hZRX3Np4aNta9FXXPxHajwwvffsWf21ysKfFbj9Ft8VFws+1y70PBWPwQMgJjiArWL3KCZn9/GSBPEEA5X7mEC4x1bpOyzxn1Hl0u+BojBtbZT8W4MJObAZeR/FTeWFJAghQIizBsOHkkno9zRo/uCt/HRo6f4RhbpFk9h5OVQwn67k7oaDgaxOxPsMOsqgjeJ4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDEzOjU0ICswODAwLCBXZW50b25nIFRpYW4gd3JvdGU6DQo+
IFRoZSB2bV9mbGFnc190IHR5cGUgaXMgdGhlIGRlZGljYXRlZCB0eXBlIGZvciB2aXJ0dWFsIG1l
bW9yeSBmbGFncy4NCj4gQXJjaGl0ZWN0dXJlIGFuZCBkcml2ZXIgY29kZSBzaG91bGQgdXNlIHRo
aXMgdHlwZSBpbnN0ZWFkIG9mIGFzc3VtaW5nDQo+IHZtX2ZsYWdzIGlzIGFuIHVuc2lnbmVkIGxv
bmcsIGFzIHRoZSB1bmRlcmx5aW5nIHR5cGUgbWF5IGNoYW5nZSBpbiB0aGUNCj4gZnV0dXJlLg0K
PiANCj4gVGhpcyBmb2xsb3dzIHRoZSBjbGVhbnVwIGluIGNvbW1pdCBkNzVmYTNjOTQ3NTAgKCJt
bTogdXBkYXRlDQo+IGFyY2hpdGVjdHVyZSBhbmQgZHJpdmVyIGNvZGUgdG8gdXNlIHZtX2ZsYWdz
X3QiKSBieSBjb252ZXJ0aW5nIHRoZQ0KPiByZW1haW5pbmcgdm1fcHJvdF9iaXRzIHVzYWdlIGlu
IFNHWCBjb2RlLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBXZW50b25nIFRpYW4gPHRpYW53ZW50b25nMjAwMEBnbWFpbC5jb20+DQo+
IC0tLQ0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jIHwgMiArLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvZW5jbC5jDQo+IGluZGV4IGNmMTQ5YjlmNDkxNi4uODE0ZWRjZGUyMjVkIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMNCj4gKysrIGIvYXJjaC94ODYva2Vy
bmVsL2NwdS9zZ3gvZW5jbC5jDQo+IEBAIC0yODEsNyArMjgxLDcgQEAgc3RhdGljIHN0cnVjdCBz
Z3hfZW5jbF9wYWdlICpzZ3hfZW5jbF9sb2FkX3BhZ2VfaW5fdm1hKHN0cnVjdCBzZ3hfZW5jbCAq
ZW5jbCwNCj4gIAkJCQkJCSAgICAgICB1bnNpZ25lZCBsb25nIGFkZHIsDQo+ICAJCQkJCQkgICAg
ICAgdm1fZmxhZ3NfdCB2bV9mbGFncykNCj4gIHsNCj4gLQl1bnNpZ25lZCBsb25nIHZtX3Byb3Rf
Yml0cyA9IHZtX2ZsYWdzICYgVk1fQUNDRVNTX0ZMQUdTOw0KPiArCXZtX2ZsYWdzX3Qgdm1fcHJv
dF9iaXRzID0gdm1fZmxhZ3MgJiBWTV9BQ0NFU1NfRkxBR1M7DQo+ICAJc3RydWN0IHNneF9lbmNs
X3BhZ2UgKmVudHJ5Ow0KPiAgDQo+ICAJZW50cnkgPSB4YV9sb2FkKCZlbmNsLT5wYWdlX2FycmF5
LCBQRk5fRE9XTihhZGRyKSk7DQoNClNpbmNlIGNvbW1pdCBkNzVmYTNjOTQ3NTAgKCJtbTogdXBk
YXRlDQphcmNoaXRlY3R1cmUgYW5kIGRyaXZlciBjb2RlIHRvIHVzZSB2bV9mbGFnc190IikgYWxy
ZWFkeSBjb252ZXJ0ZWQgb25lDQondm1fcHJvdF9iaXRzJyB0byB2bV9mbGFnc190IGluIHNneF9l
bmNsX21heV9tYXAoKSwgdGhpcyBsb29rcyBnb29kIHRvIG1lDQp0b28uDQoNCk9uZSB0aGluZyB0
aG91Z2g6DQoNCid2bV9wcm90X2JpdHMnIGlzIGxhdGVyIGJpdC1BTkRlZCB3aXRoIGVudHJ5LT52
bV9tYXhfcHJvdF9iaXRzOg0KDQoJaWYgKChlbnRyeS0+dm1fbWF4X3Byb3RfYml0cyAmIHZtX3By
b3RfYml0cykgIT0gdm1fcHJvdF9iaXRzKQ0KICAgICAgICAgICAgICAgIHJldHVybiBFUlJfUFRS
KC1FRkFVTFQpOw0KDQpCdXQgJ3ZtX21heF9wcm90X2JpdHMnIGEgOC1iaXQgZmllbGQgb2YgJ3Vu
c2lnbmVkIGxvbmcnIGluICdzdHJ1Y3QNCnNneF9lbmNsX3BhZ2UnOg0KDQoJc3RydWN0IHNneF9l
bmNsX3BhZ2Ugew0KICAgICAgICAJdW5zaWduZWQgbG9uZyBkZXNjOw0KICAgICAgIAkJdW5zaWdu
ZWQgbG9uZyB2bV9tYXhfcHJvdF9iaXRzOjg7DQoJCS4uLg0KCX07DQoNCk5vdCBzdXJlIHdlIHNo
b3VsZCBjaGFuZ2UgdGhhdCB0b286DQoNCglzdHJ1Y3Qgc2d4X2VuY2xfcGFnZSB7DQoJCXVuc2ln
bmVkIGxvbmcgZGVzYzsNCgkJdm1fZmxhZ3NfdCB2bV9tYXhfcHJvdF9iaXRzOjg7DQoJCS4uLg0K
CX07DQoNCj8NCg==


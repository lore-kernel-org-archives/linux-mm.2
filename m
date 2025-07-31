Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAC8C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 03:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7DF6B008A; Wed, 30 Jul 2025 23:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868F86B008C; Wed, 30 Jul 2025 23:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7307C6B0092; Wed, 30 Jul 2025 23:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6661F6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 23:14:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E976140600
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 03:14:38 +0000 (UTC)
X-FDA: 83723092236.20.95EA147
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id E515440006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 03:14:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aVl9seXz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753931674; a=rsa-sha256;
	cv=fail;
	b=ZkFSl4qZE2CSEVU8d/FvWuAH/q19uuAvDfU52EdNzzctGV/VlDEEfXRm4mgW0Gj+Cn5Vkn
	prnpaLdH4pxUGauwFSDX6jfcfIt7FtluIAtGl3m+vSUi69+RJGYMGh308ziemJxPI1hwaG
	aOQH1MduF7p6USSytmCauXGi1l53KaM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aVl9seXz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753931674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi5sZdQ3GxeNGWMB/ADMGPM1ojU7f8z/cd1bIZeHTxs=;
	b=TEckjPMqepqsipkWVRBBP7C5ioAjaWrDiPt6gabshwmhp9GIZ6/LleRBgk8nHoRl/1M1el
	klh2u0jpSM+SA5gujfNeLjN+Djl6SPu+Z7Yg6099zyXqb1n81gPQQBrCTGeDENKhO7/1hG
	11X2ogctObn5/G6BLavzfuwcP2J632c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753931674; x=1785467674;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=YIkledevWPkchb7MMTfi16WaD+iRMEkIuT7+EGcFwbg=;
  b=aVl9seXzQFeX+mpaiRLaKwgJuWgEVXb4mURyAV/XLPglPa2MJjuoE6Dk
   JHAqif46IBS6s9z1Eqg0ukt+6+479cFy1WPds9ijLB+M9nP3vTYojHFfG
   XJMJEae2QEKyEvHt8Ni9qqpgYcfe6i0blPAI/0V233JxRt3f+lVcBp7nV
   JHM0Cbw/jyNpHqdGWVRksMjApezMycIh/RiQZWLDKhOYK8UD59ji2pcOb
   Je+Ud8uadz1Jo7F2VEczL28ORbdO2F+hmb3jLeNQFFhjdZkCCQCbMhu2f
   Xn/o0kbDPwYLjOUh/EixlPI9tZHsroDNygrA1fY0Ww2ouSHYpJh0nhFOq
   w==;
X-CSE-ConnectionGUID: azqd9GHqQ1+Tev3v6vM72g==
X-CSE-MsgGUID: TkvrBK29QGa8M5tMym9G0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56176245"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="56176245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 20:14:32 -0700
X-CSE-ConnectionGUID: /jLf+JYgQ5uM2+FLgfQdAw==
X-CSE-MsgGUID: 9Kvmp8U1RYiuBr5XkYqYXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="167396161"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 20:14:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 20:14:31 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 20:14:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.87) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 20:14:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnHhBhloV7scaYtZLanBBYkyOVYazVE4yAO7CauHwokwWY56jAGqXqp9oV16vOgh6BZay4XgEhGpVm/aooBGr28Mi8KPxp7n8pf7q73zldM2a3o514KhERqo5sabTQqxHhx6LD7UaiDQR1s2NdGhWiMsNJMch0pLEYX99cNQHcnq6MEf1mOYteZ6UWSX6omxfuOtD5BFPtc0ykQutVU1Bl2/T+CoBCqVadZJTMOjZSQOcO8OKs5CWlf8cooLt/iOLnwjXWgvC7jOfiaT+/u2LVuDAdcxT6hdyknEbm/vxoJh1NQBUJt2/phojx0uzSP0eZj84lP24PO74q6PdyS/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xi5sZdQ3GxeNGWMB/ADMGPM1ojU7f8z/cd1bIZeHTxs=;
 b=wg1t7ZO6ZdheCWkcfRDNUt2OztcIXCbFaqNd4ZqsgCzqCsn7roQf/bm7Pb4fKjgo4c5D+3z2I+0zI8UrwVqbSu3W4eciT9TZnphlznAdaZ5gkoegi63dpTVjSZzFct4+1Ct8hbjottyjcxEXnYPHK9nTEzpiLSexcD2gvJIJIQHeofle8cF8v5K6NzZKgqJEt8VECHdYvHAdc9RfwB8U+6XkqPXOO2YO/26N8z8hVF7fwbjUKOSz1NGSvlFtpGJBn16JKMtHYFhwPvPpNDjVKR/OoWSZyd/XEO3ycEtzm2hxWYSnceiEMNWcCPDZl+PMdir1VXqPE1MBI+TDQkZuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7254.namprd11.prod.outlook.com (2603:10b6:8:10e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Thu, 31 Jul
 2025 03:14:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 03:14:22 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 30 Jul 2025 20:14:20 -0700
To: <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-rdma@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <a.manzanares@samsung.com>
Message-ID: <688adf8cc7e8f_48e510047@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <688a9b2d35c97_48e5100af@dwillia2-xfh.jf.intel.com.notmuch>
References: <688a9b2d35c97_48e5100af@dwillia2-xfh.jf.intel.com.notmuch>
Subject: Re: CFP: Plumbers 2025: Device Memory (formerly CXL) Microconference
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: c474c5c0-7253-4691-466e-08ddcfe058e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dHVDOEVrYmJyaDVGYUwrYU11WFRzUG02RjFUYUY1aXhnbkdmQmU3UXJrS3Iv?=
 =?utf-8?B?M0RrUStHaElJYitnYmtmekNvRTc0WEZtaXF6T3lDcTNWTkFIeHRrc2xaazFh?=
 =?utf-8?B?YmNydk1hV25qOUZMZVVnUS85T1l6YzBGUVpBTU0yNW8vcC9GSlVpQzV4aXZj?=
 =?utf-8?B?ZXVUV0w2bVA1bGRqWTFlTTF6V2lENHZ1QWphM2hmU0QzczExazdFQlpnMkZp?=
 =?utf-8?B?L1d5bnZlYlhTbjN3bWZTaGJ4dlZMcmprTGFQWklTQ2s5QWpzdjVQMnIvZTYy?=
 =?utf-8?B?MnR2Wk9YWlJ1ODBYZFFRSFRlNUlhRjZsUE1SWk5hTmdPWW9UOThQSFQvRUNs?=
 =?utf-8?B?TDE0elU5cGFOTzFlT0ZVbW5icWxSa3BzOVNWNjVjem1wWnpFQldWMFpDYkcx?=
 =?utf-8?B?bmJWRGJlR2d5Q3B0OW8yemxwcGNHV243eGZiVXVWSldjTzV3M0YvV0ZWK0tF?=
 =?utf-8?B?ZjVieVRwMmt4NkdDbmt6dFJXT2xJZm1GL0VYQUx1WXA0em1aZWFTd0MwNVlI?=
 =?utf-8?B?VDNVVGJ0TU5mYUMyanFUQzB5aHgxZHdhTWk0ZnFINHhYWDBnelNRQjN3RnRi?=
 =?utf-8?B?YkRFUzJvbkNwQ0tFZzc1U3BYTmk4QzFHS0IyQ1NReEVaUVAvTDNMYlJWMGhO?=
 =?utf-8?B?TTZkcXN0aTRaZHBJSDUzWXlmd1hkSkVkMjQ5VE9vbmVPdFk2QnFoekNXNDMy?=
 =?utf-8?B?aDVtOFNZeUVncXJuaC81QnBHYW5jTHc5d2xoWTZieTdiaU8xZXdCbjlrSC9G?=
 =?utf-8?B?ZW5lZGg0S1I3NTI5b2t4YmtRbm53VGg4dkNmTDRrK0QxQWozbGoybVZYZGd5?=
 =?utf-8?B?TVAvRkNrTU5TRmMvWXZDTFpwY1I2TWkrQzN4QmIrem15YW9yalNjUmcxMm1m?=
 =?utf-8?B?T3pqL0ExK0JWbXZkR01aUVowQVlJWHBTQ2JYYmZhdk9jZjVQWUkxbVc5emRN?=
 =?utf-8?B?bE8rdkVpVG8zVm1HVDBtRnpTNHQ4R1NtRUhDQURoWmJ1bExFMEZpV0tSY00r?=
 =?utf-8?B?RUEwbVlkQ2Y4a3BhY2xUMzhtT2RhSVAyd0ZHS2xrM2hwUVc3RHNDM3BKS1VT?=
 =?utf-8?B?VjRYbXZQVlNkNzYxN2FMR3dtdzlrd1ZVYU1POVRTY0J6dzZCNXZrTkpISTZR?=
 =?utf-8?B?d1dWRzBGR21lcCtaS2RnYS9aNHFOanBzS2VRMFc5UWdJWTRNYXZ2YWZWVnRS?=
 =?utf-8?B?VTl6SUtObWdoUktjYllXK0lHTEYwTUxVaTVFbTlqelZnQXphTGUrRUd5SDdt?=
 =?utf-8?B?ZUR2UnFPVWZHZjBEOVFkUEhadHdta1VjNDN2NFViM05Zdkc3NVdRTzdsVlpW?=
 =?utf-8?B?LzBGQ1lRWTFnTHU1ZFZzdGd1amduUWZRY0RpekhqMGR4MDZMZEtEMFRSTVg5?=
 =?utf-8?B?aTFLVEd6MHpJT3NJVFpLTi9ETS9xQkR6Rms0ai9vVnVmWEF1RGk0UDNHNi9Q?=
 =?utf-8?B?U3Jmbm5JMGRUK2F5UWtWUTM3citncTZUSFA2RmFDRUlHamlLUGVrTnVaMkRR?=
 =?utf-8?B?OEthQ215UGhFb2FDSmViNk9QRktpRTlwcTBnZjVPY280bFl6L1ltRE5iaWRS?=
 =?utf-8?B?aHVpbkkrUG03V0NpYkhKV0NmdERVVjdmam44aVpCQWtSa0twdWZsbTk2U2ww?=
 =?utf-8?B?VFd5QkJyRjBMM01MbzVrMTA4RUFMYXUyTUZDYkpPTlFXYTRuL3BiN3c5ZWU1?=
 =?utf-8?B?Zlc5TXJCT2pHVjlOLzZ3VzJaS3pBWnNlSXhuMWRsMnloWEFIdHVQcmY5clJD?=
 =?utf-8?B?VXEyY2hnWm9RY0lnUGVZbDN0S1h1SkdPc2pFVjFpL2E4SEx6N3JxOXpWOUpo?=
 =?utf-8?Q?FFqAm7y3mit2rJnZ0x+U9I8hf9wuTEh8EWnYU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MytVa2lUMUk4Y2NGNjZKclJZTFpwUXgyNXA5cmkxd2J6VEVUc2dVRjdIZENy?=
 =?utf-8?B?UEVoY1VlbXo0OVZ4TzNrclpuRUJJOTVsREIyTGZRdlFZampsWXhlU2VEMFB5?=
 =?utf-8?B?cjF6ZUhmTEdhTlpjdDd3bi9mMUdFS0s1aFdFTVA0K2huamI0ZWV4SEZYZEdi?=
 =?utf-8?B?aHZxOS9PWm9wWW4wTzFPRlREbmUwTVBLc2ZHRUFGR3FQNXFhdC95dE5XMlQr?=
 =?utf-8?B?SGhoRkx4VWQzVDJaeml1UTZ2aUgrSEIzQW5FRHhGd1Z3aW9xMHU4U2czbTds?=
 =?utf-8?B?blJRcXdUMDFoOUhZWnJaS0VBcnE2enJldFpqdEE3QVJibFFrQlcwK0p5eUwv?=
 =?utf-8?B?bGt3UEZ6VkdmdDFmNXRwQTlxN2RoKzJ2K0w2OUdZWWs4cmR2dmc4TURmY2NM?=
 =?utf-8?B?RFEwMVVCQWtvcEU5WFVOMkpwa3g4UkwxWVJTY2xuSmZyOWljc1BqZlh3UDFR?=
 =?utf-8?B?aFh0UkdGZ3F5QzYwM2FEdndYcEFMTnpiSU5CUFVqWllNdHpwSDBuc1cxamZw?=
 =?utf-8?B?WmRndmJUNDhYSktUWU5SQmYwaWZDMEI0VmdEZHVhb05YQ1FGQVhXMTJML0k5?=
 =?utf-8?B?VzhYNW1tV0lxbkxMK3ZNYS9jSzJhMnRBUzdsd1RyMFZhVVNWaE81SjVGQlpH?=
 =?utf-8?B?TjNzWncwVlBVRW5MTjNqZlkzKzhzWmhEY0RFVEFWK3ZrcXAvNXpFRVdLZGlI?=
 =?utf-8?B?RnpnTHVHZU5oRkJzZVgyMmY5SXhrUVdndHNOUHBUcTJZTEZJWmlSSEZtMkNt?=
 =?utf-8?B?ZnNIeVIrTjhNTHJxSmh4dlBTaVNxTTZUNy8xTW1KL0FzQ3lpR0hnRyt4ZE14?=
 =?utf-8?B?ejZMVGoyS1dJbVY5b3d1Q2pIbUp6UnY5MXFDZ1Azc1hEdjlkT0Q5T3ZDblFm?=
 =?utf-8?B?ODV5N25RSTROZ1RBZ2lQdHNuTnRjai9TUGVBOGFrb0U5NnZHNUhVOHJOUElS?=
 =?utf-8?B?c1Y5ZjlQcnBNdk9kZDcwUFIvaXF4NytLelhZNUdFb3FZajBBRG55QXhoTllw?=
 =?utf-8?B?Nm5EcTNyRGVXcWdaaDd1VkpGb1dzU3JndTd0VTRPeTJ3VTdtQU1WNm9yVWZu?=
 =?utf-8?B?d1ZxMXZ1cGlhZ1QwajVRRUI0WGYvTTlQcmV0a2NDQXJTMWkzMU9hRmhld2hU?=
 =?utf-8?B?L2szRnNOQUtuckxQWVlEVFM2R2x5UVZ5OWc2aFRuWE41T041QmhPQ3VZcjRZ?=
 =?utf-8?B?VnF3UDNtTEIyNXBIaURuamlpaEUwcURnWi9SQlJ3ZkxkMXN4UmRIV2tZWW1S?=
 =?utf-8?B?MTlwUlRKSklmU2RvY0NqUzgwVXlSZFNGOFJHWXZ6RDR2QU9ZeUt4ajBkbzFj?=
 =?utf-8?B?cHhjWHZRaitySU96UmVmdUVIamFFVlEyeVB6QmlXUzgrY0Y5YVphU3lHUjl0?=
 =?utf-8?B?a2pjWkhvWFZKOWZURGMxRFFWajUxMlg2NXBRSDc4RU92Q3IrUlJQTklLaWRQ?=
 =?utf-8?B?NUczeDRBUGdibmhqNWRnMUNhdk82UlROUGxiYTNKVE1EWHpYdlVCazUzMnlp?=
 =?utf-8?B?Yy8wNkx2R0sxbk5CeUtsdVlLdHVIOUp1dlZjZDJKREV2cWJ5OGtlSEgwbmcz?=
 =?utf-8?B?ZklWNUpMdUY3dkdJR254RURIQStTMXZnWDVHRHNtRmQzdE1OYjh3b3JWUGN1?=
 =?utf-8?B?elpQZG9ENFdYYk5icVl2TDQ0dkh0cWFjdjZRRFVkVUovQ2tMcGszY3JiY3lU?=
 =?utf-8?B?SGJLbFhNZ3hlajJESHhIRjNLa3ZPQ24wWVBWZFhqeUx1Zy8wS0cvVUZGckpw?=
 =?utf-8?B?YzY0QzlCZk43WXhUT1RqUVFSYmtTWERYaTkvMmV4ZENySlp2SWdldXloL1lH?=
 =?utf-8?B?djliNUdBejFPVERuVHdVTk9CWGhZR04rdGREbm92M2Z6YURiUm1kR2lNLzU0?=
 =?utf-8?B?RS9NWU04YWR3L0hYd3hXejVTTlc5NzlwaThlbGxBS2dsb1lsTGV5SDMraTRP?=
 =?utf-8?B?M3NGeTFNdURKVGVjWE03dDZSenRGV0FtcFE1cTkzNUZUUmxCQ2JFNkN1RmQ1?=
 =?utf-8?B?eEhpTWhkZUFKblk0Ym5uM3hzYmxhaFdaN1dQNDdKdFV2NlNvcGozMVZrUnRG?=
 =?utf-8?B?WHFLSWgvcUxqclZqK2JvT0U2S1hMWUhuWHQ0RlB5YXVuSFZIRitlbnVWT1Jr?=
 =?utf-8?B?OU8rV2Z3N243U0h6VmxOSFdGdmpWUmVvOHZjNlZKWVdWM3JNYUJ1aFptYTJs?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c474c5c0-7253-4691-466e-08ddcfe058e9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 03:14:22.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKzB9csoeTEQEBFHSFjLqt0k2Q7ZzQ0I4xzedTNylsAZ+016wUSNgir3td7YzQJZk4nsZc+O5ti1vT0h1Q9GninzhoYFajZtyjcXFtwQ8YI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7254
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E515440006
X-Stat-Signature: 39xrm7gdosy7fp5baskjfibkybgx7tw7
X-HE-Tag: 1753931673-343780
X-HE-Meta: U2FsdGVkX197F3G8lPM3VO0R6X3xCJsuOLRaL2V7eph7pGBEt3w6J11CanajJE5cyPp4rPOCXQ2zQi3R2eydpClulRFr7DbnzYkaH7xqVPEQ5F/u++qjaRTM8Ri0jm6M6g+E5G2E/J2X2EbLofD4WMI97jg4zxfyXjM1Wl0/uRdjWP4V0tLXNHV0nvmk78dK4jM47telASPVnfqLLm1/Y3r/HV15R3ObmkjlS6ULMkm1KpxqcmEKyptQ7NeFaNhdQwDE4UDUfpFjRvFA+S2G39yYCmhilVpLAjS8Bcx3lnl47uJaMfQn0SZhux90jcHfn8NhArflfgOx615C8E+DPN1cfsaELNOxl0YGae8G7dG932j/0LwwK+pJT9abtqsTRZ1wWiFtVO5kLGAoQSH9+iAwVHd8VLjGCLuWhXy97HfZ5R5EC7GXfFNB6gDoZC4UNl3Qh3Mm12X4bkDp+orBbyOxFHJSUsyxmTuJ1q241miuosGXctHRYB9Ew7DDoH3CCFdq5L4lOZhX/CG30DqgUtqdqu0Z2HI1N1sp+tfHQO3b8w6T/376F2h2dmfDT/TGKctqp3+cUUxTtfrUZ0ZWZUwhl7Uxq+K+7jpkRHVVrBoBZuGiTdEHFoLHikTTQkrYXfSEvdlg7frbjONtz0XL6FrCr9gad7XIF1vk73BYgftWZzwTTQ1jTgAoQqcOZBGpdXN4pfzkb7wfHzlAiJUkY1MJMBLEkR5koUwIUN1bWAYQZMVrrIdo3Nhc1RA3Pv14JH2QbmOrCb1wkagqWUkF0nGTmvk2d8Izgj/wiy9VvomfNcuBGVVAQEYt8cqLCG9fs0eICTrrboeMG5hvl6ZNUdTwDK83D775YX9CSQHQg0fcR66mpH/nta9kmLfzbpyn0tq9xj7zFDMudKKoWpNf0XX1Gi0SjzXKvpRjjU7enf4X8rbLv5AxGGZ7qwGIGfZupvyowvV2BmypIMrGDsr
 8iZ/dxos
 4mLL+ubnCQS6B4OobcZKG8jIEct3EMmAtvyFyX/r0GCSizWXd+LydHidk4ZPugH35DjWts5Z3eLY3xcNj11mBLXTxewICzMGLwAk4Dam0+L8aI/ndaiHQFYW/6EjhJ9l7NeG7vla84RfoT064dDEZCBe6lUnUA8KpGkcQSUGizdm56gAMQT6Nx46SakbXxcsToj0GeX87YdkyBnxkCE5e7FoOe9lO+B28bL0+zu6rgScdrHlYsDValHpP16gqynejNLtrgR+vf/MFmhT8IGQ7DEbe/8ybnv3QRjQ/PLcB4xjgz0T6UeZNEuxmlQUhQMUWId8wssuLPnkPCxkQ6HTDzV2DYTLZ0KFwWxi+Lk2tfyB8KiWABJhxCyreaa6f5OUG70aJV14IE4oslolN3lH0qA6TSselzYGLvAkWacK5zWJluTPHQs9cNaDlhpWkVTsFxJ2rgdhRXM70TfzH7XizVLZ4ZBRis8yq3CcuVCUAkiQMPu0if6SXoS+eFYjLctNA0F3D6aBc8GIJSR/BHf1OSB+chAI9fTjCUD20lgBojZemH+nFwygstFmCRwFFpRNSUhLxkx0BYcj+C7KAyvvPQI2tPxlVj7y95eav6ywnWd+99SI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dan.j.williams@ wrote:
> Hello,
> 
> Linux Plumbers 2025, to be held December 11th through the 13th in Tokyo
> [1], will host the "Device and Specific Purpose Memory Microconference".
> Topic submissions are now being accepted.
> 
> Go to:
> 
> https://lpc.events/event/19/abstracts/

Whoops, that's the wrong link, corrected:

https://lpc.events/event/19/contributions/2009/


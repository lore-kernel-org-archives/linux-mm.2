Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7538ED0D170
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27C96B0005; Wed,  7 Jan 2026 15:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5BB6B0093; Wed,  7 Jan 2026 15:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F6C6B0095; Wed,  7 Jan 2026 15:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5C736B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:43:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72427C1D5F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:43:02 +0000 (UTC)
X-FDA: 84306342204.01.29E7477
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6DD5E180007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:42:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CWcLhJPg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767818579; a=rsa-sha256;
	cv=fail;
	b=NwRYdi2//D3GmWw5kUH6B01DvDNGNIAp7cnz7oOldXaardIZ0JIwJR6jZJr69LSquFji8z
	Z5wOb4A1skA/1WQqktOUiKRcxFcsJVNGi58p3W4O2ckHeS68yqy3ziQu3bWiuw6VOgFVzr
	5Hn82cNsCMxgXEhwQ0oYzKaU9MRBFpI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CWcLhJPg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNIvbLbHhUoKuxY0KWv6sN93Df7Vej1n0SuapD9VF1c=;
	b=4cUZnL6SWyq41RDJ0fgtpejAp9L0dQrXqZvR2fELcTay0+N16esgAwzwX8CV5fnnJtYUvu
	lDLuqOOUhJ/MLBkzWu1B3ulY5rCMtK5U1u1sj8Nt3Lt/hVMaIvRrNAz/9t6Hmv42Ttrp3s
	L4iAoeOf31whWhMHKZaU5EQOWU9ht2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767818578; x=1799354578;
  h=from:date:to:message-id:in-reply-to:references:subject:
   content-transfer-encoding:mime-version;
  bh=RPJU+GMtCcSGhinhzlh3/cFsFjvflyVToq7A5lpcdG8=;
  b=CWcLhJPgpCzN7kGbpjslDph3jPVnpGA+5tEOO6FjJp1pyE+6+joZPY97
   N3i3oAO5peu6gmPndsXJAUHBZPFiLrt5qWtLv/cnRBnN5TtYYM4di+JlS
   sROuJmL1Hoj8hTHA20Vz0ycjVmNvNePBHzhYADREVb71mka7NBZmcJD75
   idr5kwXuU2uXJbSGYz0FqCJKhULUPv+OhNdtNgK+o/hf9TkHJBzqqSdTU
   +0JiwZMtMUzd76D/Udbws3LfzBrvLwjIxWusvYvWtWNb3/jGDldvasZC7
   +HpOj/Q4UhlWrzzNch6CrySkAdEGmeW8VwLb6m1r3+wvYeCMqkAHdFDqf
   Q==;
X-CSE-ConnectionGUID: xLFLys06Rhm7uEgAK2lHPg==
X-CSE-MsgGUID: AjggJya1TIGbO2QaZJfGDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="80556835"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="80556835"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 12:42:57 -0800
X-CSE-ConnectionGUID: sDWz6me+Qoi+w0LekYR4+A==
X-CSE-MsgGUID: sCEZp2okQuKXRDwkbxatPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="240499271"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 12:42:57 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 12:42:56 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 12:42:56 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 12:42:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugSW/b/5Sj1g+isYz6AFt9O2KPZGoW5e4+aIxUCfcrena2oLi6bP01XApyU2zICPZT+6u89vv488o6US5ZsECqzgbxYt9mKeCGNUGHTj3KqmDscbYzje0VF5jzHvJM3/ddY4XPUOAE2MFX/MqdHb3QY6OZf0zp2YGpe22uHndDFXeru1g/sAcEJfERD/Vdoxn5EP7fzACF/5Lp0HRN45etgm0OXV5iBwQX5VloBfyyOG+s0LaycivccU3/ULRn0yd2xZ8MuzyTjoP/lRuHLBiAnqSoj51/cvazzu12R7PmcRk7MdP58gC6sqZNFM+Ip3NevgAYa28W0glrXE5NQefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNIvbLbHhUoKuxY0KWv6sN93Df7Vej1n0SuapD9VF1c=;
 b=h1Zr6j5sZRIaRyJEPikSQaM82GK+c4QAwPTXIBevXIqqhDDKVxQOxhUPA0foqYIBzL3zGVGBm4uD7DPJS5ejkunNZB+ivhUByRKu4YA3YqF/1SHJMNrmciTrwSs/OBbe2+NGYQbQvD1nslNfrFljQ6ZEsfcIz3/rzLm0FdWW3Wq87uBDohddWG2yNxzA/e/1EaA3BSPAb9gd6ZnevlInw/1bsEeBmkX1SS8BOF/QRxq77MLHMXeAywzASbfVwX/XW7eNsOyylZ85WoU5gy8rUH9dv0YtDj35sUADeYxszPpEKsB+/wuvXCxWBvJ7SGBRqN6XxCW+q8cJmr5hY3vamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB8182.namprd11.prod.outlook.com (2603:10b6:8:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 20:42:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 20:42:53 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 7 Jan 2026 12:42:52 -0800
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Message-ID: <695ec54cf5c3_875d1009d@dwillia2-mobl4.notmuch>
In-Reply-To: <66c32ad4-a59a-425e-8a00-bcfb918e7559@kernel.org>
References: <66c32ad4-a59a-425e-8a00-bcfb918e7559@kernel.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-12-04
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0098.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::39) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB8182:EE_
X-MS-Office365-Filtering-Correlation-Id: b57d8847-4eac-4b8c-9c6b-08de4e2d548d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MjhVRzloRVlvK3g5QXNqRy96MUZ0akhLc1Awbk9ibFhJdkordEltZ1d3RlZI?=
 =?utf-8?B?VW9SSWNyN0IvK0ZCelE5bzFNYWQ4YzNJTUhkTmsvMXBVSWVqMnQ1Qk9RdkU3?=
 =?utf-8?B?MUcwblljZlhQakRjd3BYMlpjM05rbHdkb2dHOWFENXRUVy84TjcyOGQyZ3NZ?=
 =?utf-8?B?Yy83UEl1QlJQYXhWb1RLN2craFo4OE9naG9zTE5EQjdYNy9FazMzR0preTR0?=
 =?utf-8?B?cU96NTMyRGJTZzhBa0xvOEp0WFJ6djIrMVEwYVppVko5VFJwNU9sMngzNmw3?=
 =?utf-8?B?em1hQmFDWnpQTTgreEJFV043czk4Z1phMG1OTDl4RS8wRmlVOFIrWmkvakRC?=
 =?utf-8?B?SG9QWjMrMG9yNktISkVOSGxJSzhETlppSFZOWGUxZkNkN2VZcHpMY1h1S05P?=
 =?utf-8?B?NzNqVmxKZGEySzJPTG1ZRmdPbW9KSmptR1lrMVkvSUNHRnE4eldGUkJYZzFx?=
 =?utf-8?B?QTdLK2pNd1NvTFdWNXd1cGxBblA2N1pHY04xQUVJcERKejZVcUZQZm0rZ2RH?=
 =?utf-8?B?RldxTVFmekxySWxiQlJLa3A0RzV0NFZybGQ2NHk0bnZyaEdWQ1lRdGR5T1hU?=
 =?utf-8?B?THVJN1d5K05QUGxXQTBFYzVjdjZodEozOStZRmdFMS9KWi9DOEJnUnFZMExD?=
 =?utf-8?B?TkxwRlhRWE04OGxWeTcvNEVPVkZZcFdxWnRxZHBOaVg1S1B5U2YwTHJsLzVL?=
 =?utf-8?B?MHlwN0lEelpaaDNITmQvTUVPcGpWek9ReUFJRExuQW5DaUdzcGV0aUd1RTE5?=
 =?utf-8?B?aEczRjNyZnNsWno0NVB3UHJMWDRkVS83Vlp1RDJHR25UQTBPdWZYVnVoZW9a?=
 =?utf-8?B?cnNLbGYvRVRhbmM5VUxQenFJckhmMERXSVZ0QWI4TVhHNi80dEt1T05vUVR2?=
 =?utf-8?B?bTJFeHV1cGtCM2t6SnUxc1E4RisyUFYrdE1acWdmdnBnRjJySlFZbURTYmRi?=
 =?utf-8?B?Wk92VG45MmtGN05GdlFFazZ2NW9YeTFweDlYMUE3anIxY285dUNGNjgwblZu?=
 =?utf-8?B?Mkd5M2RRRzNCZmxhZVBTRVlud0gxWG5wdXpScElQZkFrMVgrVzVJbXBabTE3?=
 =?utf-8?B?RTBLVm5sSXRJOUVwckZZZmhDSGI5UldUZWVxUldkM25WelhGdjRwUjErc2d6?=
 =?utf-8?B?VUVreW8zL05FKzZHNERoeThUUmlzaWRKRFR5WTlTMW1tdTZzZkRNWktHR3Uz?=
 =?utf-8?B?NHNVUkRadW11L3VCM3JOOHVLTHFkZThIWlNacnFWYmNTc1lKQTBtaFJMQ3B0?=
 =?utf-8?B?MlExNkk1eFdpRFFrZzJDNUNHSExzcmx5SE1nem1VUHltQStmNlhLajAzM29r?=
 =?utf-8?B?NUNXL01nZ3JwSDI0NC9mcDlFL3Nqbml4Nk1WYndNT0toYkt2aVRUaFAyTUU5?=
 =?utf-8?B?MXlmTG1MVmVtR1RLell5dUZwcVorbWZ3ZkZLcmtpY3gzM0QrRjRXYm9UOVdi?=
 =?utf-8?B?T0c4TXFEcXAxTlVFOVRueWxLMVIxaE52VlZlYUkybXdSdHEwQnBoa1p2MmlX?=
 =?utf-8?B?bktyQkI5eXpxb2JIcVFkMVAxQVkzd0RvM040eUZnb1lBSlp4WlNDSmZrTGxY?=
 =?utf-8?B?ZVNTdDExZ0pMQ2ZKVWJYeDdrY0czYjVHT2lHRFkzOEZUZGhSWWdabzg4NjAy?=
 =?utf-8?B?V1J3aFhXc0ZINjQ5eVJIZW5iUDd3MCtob1g0Y0dBaXB2c3BrYUhlNjVQK1RP?=
 =?utf-8?B?UzUxL0c5aTRxT05rRCtkKzB4bGRaOXpwTnVmVGxTL3V0VEdvRXVRdXdqTThh?=
 =?utf-8?B?VkhtbFNCODlIenlzT2lkSk9EQlJMcCtjZ3p1ZkxndFd2ME1nWTdzWUo1b1d0?=
 =?utf-8?B?QlEyQmJDVFB6S2VFN1JMaUNiSUl3ZzRMYUM2a3FlMlBuTXZublFWdTZ1NVpw?=
 =?utf-8?B?ZVRITEhmQ0syazhvRjEvdlZuWDg1Qk96QkxYc2pxSldGdzNjb0dtUmtsOERm?=
 =?utf-8?Q?WSzbAiJHHQ/1sXmEGG0QxZIvjqM20WZs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkJBYndUVkpsS0hhNGpjM1kydGcxMzZlZWRLTGVocjdJTUN2TUFxQ0JoK3Uz?=
 =?utf-8?B?QmllUmNPV25LRE5IUUdxckpRLzBiSDBpWmNLOXBranBBN09mdHQ0MGkyRGRZ?=
 =?utf-8?B?bEhIdjRjZ3lzOUZRTUUzS3B2YUxuTGp4MXJjL0pma0VhYTRERGVFQWlXbEx5?=
 =?utf-8?B?T3c4UStLUUFxd0lGSXorcjIzMndzWUV0cUFiZFRQd3pYbXpjSGp0c0VZdDNO?=
 =?utf-8?B?YXhvdURRLzFkdXNLRXFvZmJJTHVBbGdtV05MVEZKVTNzNS9oRlJzTXRPU0F1?=
 =?utf-8?B?cUh4K2RCdE5QS1ptekF0M3VjYkpGV2h3dUpKTnhnaDlwVjRkMXVDUG5ROVZj?=
 =?utf-8?B?UklvbU91Q0F4dUttbUM2eWtxOEY1d1hQWXJQNFRMT1ZYTms5ZGxNc2dJNG16?=
 =?utf-8?B?REZrK2trMi90ZHZzRjA1S0ZZNWZOdjVCc0tMNEhvK3VaS0k3a05wQlBEVXhn?=
 =?utf-8?B?bUJIUGVBT2RtTGV1bW5ZenQwU1NjclVGVEljcWpPMS8ycmNXekNWdmMxUmdW?=
 =?utf-8?B?ei9zaFpoaFluOUhFWUJRanhJZ3pNV0FjZ244Y1JCUjdMck0vSjlkUDcxY2V1?=
 =?utf-8?B?ZEdMYTFrTDh3L2pEK3h3SVRQZ3RoNnN0VG9kVXNoTzVXZTR6SkZvSUdObDlh?=
 =?utf-8?B?K2JFQm9ubTB5THhXR0xRUnpvb0VsQjVuTEZGejZDalhQbXo0Q3FZTy9USW1s?=
 =?utf-8?B?enNQOTBFU1llOXN5NGhUdkdkbEo1RDc0QTRrMndVbXVhOWUwUVNwUDMxb3p4?=
 =?utf-8?B?ZWFvcXpzUjZGZTdrZTVFeWIrVk5EL2o4MzJ6K0NCZFRNRkgrdG9MSzRlV1Fx?=
 =?utf-8?B?OWdKQmVDU2U2bGZnWjBIbGVjaDNxeHU2YWFFcGRsNHhzK1JEcmxjSjhCSVQx?=
 =?utf-8?B?KzJpWkNueER6c2g5cmVLc0YvMkVWL3RzV0NuRWl1c1Bjek1LZHkwUmhKdVBM?=
 =?utf-8?B?RnRENGFRQ0xXT0F2OEZNZm5mRXZtTkdoQVkxeW5YWjlIb1hodWlhS292K3Jr?=
 =?utf-8?B?Y0gwWVdNc0ZUMmhCWVdjOHZmRlRSM0VnQVNoVlp2QXdYa2pQb2lzYzE3VXlW?=
 =?utf-8?B?MTY0N0ZFNFlqdnp0VHNwMVp3UjZ6QWdudmZLUmJWaVpmZnVwUXFENGg5Qkpw?=
 =?utf-8?B?YTE3S1VtUFdEUDV1elFPaU1LN014anh5cTJQeEpmK1RDM3NVekV5UlNjNDdB?=
 =?utf-8?B?ck1zY29YVFFSNWtTeDNvakVKR0tLOVNmWHordUVYTDRmVSswK21teis4OXNL?=
 =?utf-8?B?UDhrNEF6a2hxYjdhK2ZWZDBQVWVsV2REMjEwaW5lZVlpaC9uNzl3N3dHVW9o?=
 =?utf-8?B?ajBETk1JNDc3OFdOVWduMWdveUlhTnBmSzFWWjBBangrZ2pDWFBQR3I5aU42?=
 =?utf-8?B?Q3FOTVJ2Qm9Tak9JZDVqUk5FVnUvbVdTMi9NRzBpdytRUTZiT0VVaDVCdFNx?=
 =?utf-8?B?YVhYRlhNdERJR3ZEcUEySk9QeHZtM1c5N2daVGpRQVdnYmNKWndEWW00bGJ6?=
 =?utf-8?B?YVZzY0hhdU9DMHBvTGh1SjkvYmt1eXkwbnJ6bFhUVG9WZS82cWtXc01lc0po?=
 =?utf-8?B?TldpQU1YbXBadTkwNGJGeTVwRHZacFlBUGpLNmFpM1NOREt5N2QzMExwQTNs?=
 =?utf-8?B?MmpYSVdSampoNGQxV0l2Sy90T1M2MlhydzFQRUZIZW96aUNkTVRZelVEalBW?=
 =?utf-8?B?ei9FSHVlSGZMSWMyUzhjdkR0aWdTdEphc3J4a3pWaERGWUlWYTUvZFhmNVJh?=
 =?utf-8?B?aGRmek5YMksxS1dUNUptNU5iQmtlVldqbDN4SmJybSt6bmdNdDc0L2lzQzZC?=
 =?utf-8?B?U3o4cVVHWjJuUXFjWGJyeXFDdWRENFJVWlNiNTVXY1RGaXJkdlpLd0hEZ0ZW?=
 =?utf-8?B?OER5U0g0Vi9jbElYb2VycnJsaEpjZmZ1Q0MrRlJpd1pSTFFnemFmeUFlVlBi?=
 =?utf-8?B?cUtWQndaQUJSOTRHdWRZdmMrNGhEc2JaVTNndkVwRjBxeEU2b0crYjJLNk5V?=
 =?utf-8?B?dFpHdDVHMU9oM1g4c2J2M3E3aFcwRkpNai9lR0IrVlZ1N1QxUWpRcGJ4cGpj?=
 =?utf-8?B?UWVTSjVSZ21lWWU5ejFISkZSRjhIYm1XQVkxUytXdHBqZVlRNkpuVFhYUys5?=
 =?utf-8?B?MHBxaFdoM0hWZ0M4MG1LZXIwRWJSQmlBVUtmUC9WTmJ6Mm4xZXFVTVdiN1Zm?=
 =?utf-8?B?dTlLZUE3dE5xaGtFZDdJMnA4SmhQeS9LR1Iyek0vK1lyUm85RThrdHpEVnNy?=
 =?utf-8?B?QXZCV1NHMUpraVJQbVVCTnB0cW91YW84ZGxDOVlhaS9WV216VEVtL01PZnNq?=
 =?utf-8?B?V1pESzMxNTkwYnhUbitUbEtGeG1nQnExNm5hSWp2QVQ5TWZuUXl6MVJETzNo?=
 =?utf-8?Q?8PvYgyCZTVcK6BMQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b57d8847-4eac-4b8c-9c6b-08de4e2d548d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:42:53.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcHCMeYBF1UVKbVbeqCf5w56i8INrTCjqW7JV+3I9B+Qw2UzPi571bAEgwdojS/5QAvIaLi6nmPvLHY4wnxcXSvuYN5cADgcOu71YPw/0mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8182
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 6DD5E180007
X-Rspam-User: 
X-Stat-Signature: kwh6hrg4t4k7mbfsqn3t5sbf5p8su9mc
X-Rspamd-Server: rspam07
X-HE-Tag: 1767818578-950564
X-HE-Meta: U2FsdGVkX18tjL+smHnXN6KeAMHbFmlYMCc2njUpMyDSfJFZO4te6ejcRNsCGIFGvWmIbe4FHCUnNUwD79dlbr5r1U8liPxMBDIITgbzasR734JSWCqyEDbemDFAFuNuzXLocb2FhuvVxrVE1emUh5xePrUBQEGhgUDDWuuOLYQCFp0hh0lHrYSw4uELvMZkQ1ryS13u1MNimWwFLIWobR9s2tBueCSLxiRErJ2M0UH1C2gYGVhq2XmZiJDRZ+jxlzNeQEgoTg/gBWWHX6rQSd7XIavk7tk2nny59bSes+VVIXbq2+0uled3swa1S3erwUFM3rQvXIQXigw0SuFPX5y08Gie2KHWp42JytqW1rzPuOzSd76fT7ZBJAWUJcTHuwFqyQAOmGEnOqW77SbQcoQN14wsltyTIMq3N4x1tR+Py5kjoJ8NJDRLklqdw49tOr1fvDQunr7r3y+nVsOzdNJ/mmNi+/U1UZ9duAVuvRBiru646xBv4t+caYHSv0Zs2ZmgXSakR8TmanWO/FQjMsQwawN9afU27EBtLmrfV09IyU9IMkItSq7HhI9plrt5H5jQTHgwl08RQmK1AkPxgpd7IrEaiCAHLw+xI15ec3oN6UpFmPoW774X2SzWbc39hxj5jjeVsmkTnAruWPKdDoD7wX5C6vVF+In5b2C5jVJKGJNrZ2UoYcxPEjTXAs4Hxx0NhlErTvws4UtJ4VLsD4HjDcYcKcwY9MFPFlWy2pvB3m/gEjFrFceq6xTYwddePGEFimNWI7QxI4xwkZgs0Yp4cxqbBO7Wkm4MwayhC7oDEEN716wC93AXtIBAiHOgaOEWtJvbxruTelg0PIETuiABHLHCo59kP7TdnogH1v6M2c8aGT88H4MddvDmSupCMh/IiQpfefWdS1hB0xSb7qwZlTHK453HKOz6hrLZz2DNRJM2PpH4tTrsBwkbogQ0kg5IqXt9xDTGahAN+Tq
 /s0Dt3pm
 M1gzG/zKVfFbXRkctmQe3ZHYz2Y9nTy3FT3k9H09q+oOuYG0Sy++6vhEeIIch5/skw3yCvIfneDdRgkLq4VT52YJN7FHxY2GaOsjm+ouvAqvyYq+B0hL2ztfGk7Een7eedVUsFbF/m7GVeXQFJVw8X/QFBVub6KP5fBa2sSDimr9PN3wfWx8sPzXes4wmpYwFGftQiWtiTgqB5yUpQ7KptZv0wkIY0/LLr/hoAa4Ly0DbhtBjVic1tLAHIBgLjv2QdyuDvYg4jD0lqXFh5ucHb/OLV3gBgJ0Z5VFyCsbX4AmvpCxDKY0jYd7wbxqQ5HCRbV8HR0WKnRMEiPD55TK3QICQYYwdknnY1lP5T7BMvdwirwy3gypiOqilTEh/LXkiJSBgk1PJVDIJMOuF47ORHv8xp3pQ4cKwhLKghUudAocuLOke1TsvgFP7d0A1kgDlpgIJLwslJbdkDAHrAZD6yspD2io07nDACSbMK/HCjZ11L1/J2/JfjIYBDKNFHZVeZr0GHUYjFq6mwxU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Red Hat) wrote:
[..]
> This might be the last meeting this year: I will be traveling for LPC on 
> December 11 and December 18. Then, Christmas is already around the 
> corner and we'll skip the one on December 25. So we'll probably have our 
> next meeting then on January 8.

Hi David,

Great seeing you at LPC! Can I grab some time on the agenda to
brainstorm the next level of detail on the topic I briefly ran by you in
the hallway track? I.e. is there a path to decouple dependencies and
land some of the low level huge page support upstream while the
guest_memfd reworks for in place conversion and hugetlbfs backing
continue to mature?

As you said this at a minimum needs to be crippled / not production
worthy to maintain focus and momentum on the guest_memfd rework
completion. The observation that shifted my thinking is that, given the
timelines and remaining work, there are solid steps that the low level
implementations can be landing and maturing in advance of that
integration. All net progress for upstream.


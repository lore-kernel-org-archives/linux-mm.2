Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A3ACA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221B28E0130; Thu, 18 Sep 2025 14:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9198E00F6; Thu, 18 Sep 2025 14:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1108E0130; Thu, 18 Sep 2025 14:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFCA88E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:45:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B88BEB8960
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:45:31 +0000 (UTC)
X-FDA: 83903249262.07.13B4D9C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E092160004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:45:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNavDof1;
	spf=pass (imf08.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758221128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL6T4UVCU6ZtwWU+A/w83y8j4rPnadBtrcwpVJcIg8Y=;
	b=GnqW2ichfDdSNiwJUiWLnOVw7SzTuNLUIS6C1ut/WMmrBMIq0rmTJDXOOykULNNYiXYgad
	eUsjm/7YP+4YbCCiysM8VFQ9NZY5awbauO3z/bB+pWpkvBu+r+LzM2UYqzEcQgjMzGav2V
	pxWO+LsCx5IwFDGysYy7YCX57QXx8Dk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNavDof1;
	spf=pass (imf08.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758221128; a=rsa-sha256;
	cv=pass;
	b=0/959XB2eXYJ3GJ3+VvgFuRbxrJVuvdfXBO/PwmFL07OPwoNJHXz66aa5AQCF3XwrOLFV6
	7wXe7T/8dFbwje/qOE1NYN+5NXjXyQv2g5vi6wv3kviEI6FCKLWRWNqDFyaFEQSOtIeupP
	VBp1MAfUWT48dN7AOVhvebUb9ipXzc8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758221128; x=1789757128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wL6T4UVCU6ZtwWU+A/w83y8j4rPnadBtrcwpVJcIg8Y=;
  b=dNavDof1FaIpvO7zp0WgwGHDfz6H9F+4SOaN/CXYw8XfMULhmyQutyYf
   v+IyEFMghgRfl3xZyZq0iVUI+G7A44I5UPI62Q9Y4o3jkkUsohUo9vmJI
   D4DN8Qbt9DqnBT2uicl1yK4gg5NRw3LXxAAFHxcAhTROBb7U/Ows7t4xo
   itht79q73ZRadCEg63mF8ZuplOG2EDljdX5dBteVpmf7X3QuAVbnO+rsG
   bCpXo5OqNrak9e9n7DtgIaaqq5uqf9kHfYAsbAAJfyPmz4WCZEtAZc0b0
   YQ3KF0anX64OdwPRISw2QEADuLJ05kHPeqkV/i/FfCVdzQVarYvQMeCZy
   g==;
X-CSE-ConnectionGUID: JQXo8xSlT167RxGbCVoEQQ==
X-CSE-MsgGUID: 7NbuMbbTQoSLxwcXZzagjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="86004149"
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="86004149"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 11:45:26 -0700
X-CSE-ConnectionGUID: YqqGUcDGSIiT7ZTRwDngqg==
X-CSE-MsgGUID: D4Fbsvm/SGSZ38FDI1DO3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="179625766"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 11:45:26 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 11:45:24 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 11:45:24 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 11:45:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buqoutP3/5DGmb4BMgbaZmrzSK0lAcJrLTZCaPAhezXyRUcBEnRO705E3/NL4hTMP5ZmtnOhKntyIg4nrwAEBcFu6YGbrZHKu8MlD4zESPYIiijhaQul/nzvRlMMEiu455hcDSZyRBbOqPQWgvpGfE6uIB1pWpPWrEGGfWNAj5W1dTaXxUwToLOJ8hvrBoTx7yGMDhtH3+4ZDgAnsLH/rFnGKUdh0CL27OtD2GzZ1H/Ahl6m+sMX84AecANOTPpIiKGtXExCtAhSTaVuE6idVcv3ei3kD4QR0Ag9nLEemnFlhu7UoX2FxIDBAmaRGRqqVykiFdipbZtwDzO0pWCoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wL6T4UVCU6ZtwWU+A/w83y8j4rPnadBtrcwpVJcIg8Y=;
 b=yl1T/FVN4y6nRYgcXOil5tMkeGRO7jOqoT+oePu9kZaepHomX+TQtwydLeCdn+iUNWHTdPArcTOZGWmdFoKiINYaYcItOLTaV29Z6Vh964OimCqCo7M7odk9m6Szx9k5Gfyq06aBwDX8g55ESbKiPNPEWbvy7uEdYuV5jVf9GrXmnbJcDF1XxuirTPN2dqWi4YmudyonmEFZP2qt4fGPZXbkVUzvIzKo6EdSqfrSk+VpBeq96PHzOymAEWDTcUoASw/wggEz49yB1nwPAysQZ25rUCg9Sxft0Wc33jfWR2Zeu6v7JddrUYe1dSSwCFLpN7rCXgHn+zRDc5v9wpqx5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ2PR11MB7576.namprd11.prod.outlook.com (2603:10b6:a03:4c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 18:45:18 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 18:45:17 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiaqi Yan <jiaqiyan@google.com>, Shuai Xue <xueshuai@linux.alibaba.com>
CC: "Meyer, Kyle" <kyle.meyer@hpe.com>, "jane.chu@oracle.com"
	<jane.chu@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Wysocki,
 Rafael J" <rafael.j.wysocki@intel.com>, "surenb@google.com"
	<surenb@google.com>, "Anderson, Russ" <russ.anderson@hpe.com>,
	"rppt@kernel.org" <rppt@kernel.org>, "osalvador@suse.de" <osalvador@suse.de>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "david@redhat.com"
	<david@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Fan, Shawn"
	<shawn.fan@intel.com>
Subject: RE: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Thread-Topic: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Thread-Index: AQHcHpFNghz0HBmU602rHD1MDcKklLSE/FYAgAAFkgCABKqdAIAOshaAgADKUoCAADDh8A==
Date: Thu, 18 Sep 2025 18:45:17 +0000
Message-ID: <SJ1PR11MB6083B887B3EE4DBEB6438C2EFC16A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3>
 <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com>
 <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
 <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
In-Reply-To: <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ2PR11MB7576:EE_
x-ms-office365-filtering-correlation-id: d6ef2eae-ae95-48eb-4e8b-08ddf6e38359
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S0liQzZLcjQzYVNxT3NpOVdEUjZYRFFwTzM1N1F6WmVjRk80VlNYNzZTMEoy?=
 =?utf-8?B?cVJCaE9hRzZOZEJnaUtOeTJjaUF5NVJKR1VpK1dHMDNMT0M2bjJ2cVVmRGh1?=
 =?utf-8?B?VGhNTkN1Qkt1djJPOFpjK2N3azI4SGhjL1FnMlJ1K2EzbFdNZVB2YnB5eWxI?=
 =?utf-8?B?OVI4cmMweVgvRjR4SlhrdHdBMDhxQlpPdjhSS1lZMVlRWm9wUEV5YjcvUDVo?=
 =?utf-8?B?RlZpeDVSV01QNFgxcVZiaGtIQmE1SER4bkM4ejZacmFtdjVWb09SVmtzakE2?=
 =?utf-8?B?R1BQL0Jjc1V6Wm5FaHpqUFVwR24venBtR0dWc0Z6dTM1akhnY29uS0RUbWFJ?=
 =?utf-8?B?eUdtWnJKN01FY3hFMm1mcmFWN1JSQkx6eXZvZHVDOFpncFRuY0gzV3RiNXhn?=
 =?utf-8?B?S2prWVh4YlBLZU1uU0NQeURpWDJYU2hGYVRIU1d4U3BvUzcxbFZudGFJTkN5?=
 =?utf-8?B?U0I5SFdIcWc0SG41OWJ6dy9UNGhnaW16Nk9RZGZqWEtiUzF4MUpxZWV6d2M3?=
 =?utf-8?B?Um5MRXYyK0J5cVZXaUd5NWFSTkJQUXpPQ0ZKbGttMVN3NkZPSnV4blJET1NL?=
 =?utf-8?B?Y2tqMkpDczMvSG9xeEZrSmtlK3R5dHVBWkRickxucU5SY2xjVlhtekFxOXRh?=
 =?utf-8?B?bnMzZ3VNMDBNakRuY0RoYjd1Y0NiRFFSUGdvNnNQRE9iRjlwR3FoNk9hZEJx?=
 =?utf-8?B?enVBdHRyRDBHclBzaGl0MVVMczg0WmgwQ3I0RlA4NVB0YzBDYkNqS0FuTkpl?=
 =?utf-8?B?QVY1a2VFZ2trVEJab0NaL0hQbTJBanRaUW4vajBMOG9WVmxjVDRjdVpWNEF6?=
 =?utf-8?B?RzFpZlkxRks5Q0VTN3NSK3JlWWdjbE9MY01aTjJMWW9QcXV1NkpWWnB4N3JU?=
 =?utf-8?B?Q2pBS2Nick9EUENDeXd0NzNsZ3JtRC96QXE5R3lKTFZWUWxUZjFSTG1hcEFk?=
 =?utf-8?B?azlFa2lpWmJjTE1zUS9vWThENnZ6eFNSYTlNQTlFV1o4YkpQSXIwR3hMTjhl?=
 =?utf-8?B?QXIwM2U1K1BEc2RGK2JxeThjeXdxRmdOVHQ0T0RrRTdBQU03RDEwU0JZRjRT?=
 =?utf-8?B?K1pNYmhGSFBoMzRLMjRxR2tuNXBjTWtzZUJKSENnZGl2LzFJVXRjSWZENTlM?=
 =?utf-8?B?NFVFdkZjQjlrT3BFYjNacE9nQUR2TWVEMDUzRmRVSlZzWDdjZFc4dUx0WHRL?=
 =?utf-8?B?L0JtRGs4dHJuQVNoVENBeFdCbWU4U2dhUDFxR0FRZklVYTNXWWNCNjJ5MWgz?=
 =?utf-8?B?eFNUcTdVUGJpWFJwSzVwc0xSbENISWh0M0g2Z1BjbXBVZGtmMmlwaUxVRkVN?=
 =?utf-8?B?VWhUdnQvajk3KzNhZkpxRCtlY05leFNRR1MwTTU2bi92WmtKZjhrZ0srb29N?=
 =?utf-8?B?TCs2VkJRLy96eml4R05BNE56UThBNzdXTGplNG5xaFczUFlySFpSZ2h5bkxJ?=
 =?utf-8?B?STZua0JsZ0Q1aHU3RXBMMStYSXRSejcrYkZQem04aTdUazc5MGZORkgydEhv?=
 =?utf-8?B?djRCeUE1R3hsTVRGZHV3MURUZUZya2hJaWUrZFFYUFlhMTFHa3h4NGNvVG45?=
 =?utf-8?B?bDc4L0w3cW1CcDM3MTJMZG1xWDFXRFAzeHRmNUZaNmZ6cUhBblR0MVdJaVEw?=
 =?utf-8?B?RFU5M3Z6T2NURG9BdmpSRHFWSTBBTmx1c0srVDFFUytvUW9lRGMrM2hnNE1k?=
 =?utf-8?B?VERFUjVLR1dNb1R0NkZYdy84bnBGeXlicGJ2VmFjVWVOdUpwdlRrT2RJTGlk?=
 =?utf-8?B?VjA4MUc1T3VzOEFnUnBuMlArVytQOU9FenJRZUZnR3B0SkIwSEFvcFY5UlFD?=
 =?utf-8?B?bGwvOFR0R1NBMzNkbXpyN3NYVys1NENBM3JES3RKNjNBd1p4Tk1BYnc3anNE?=
 =?utf-8?B?bm11MjgvTklnaWlxYzVRcGtrUWhTR0VmVHFqeUlzR2orNWZpdUpNWmJoRFNp?=
 =?utf-8?B?QlZJOWxnblJFc1paTGdwbzJRY0M3c1VRaHZORVROVklrTmUvc0d6V2cyTmdH?=
 =?utf-8?B?Q2hGbHVoVlZBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anV5RDdNMzF6ZjlWT28xNjVNK2d1ZWUzMmFtNnJ0UUdlWTVrTTBsZ25WdHZB?=
 =?utf-8?B?bnJBUjFoUEMySUY4M3VZWTZ3V213M25HelJNTG9IOXBPZnB4SHJESURaUVFK?=
 =?utf-8?B?UGU0ZXFWOXg5cTBXNnJLMTlXekxSbjJWSWpiZzM4ZFA0b3EwRUdvNkE1V01O?=
 =?utf-8?B?emI2UjVPdzgxZjVGUzBiYnpCRUFZakRoR0RQTUR0QlF0NzFKclFtUlpXNmV3?=
 =?utf-8?B?d1BGYUtTdUtsVVdkRUovSEYrT1BCUFFReis2QUVJZTF1RFNqZXlWSjUxRkEw?=
 =?utf-8?B?S0k4MmVheU5lK2RIaEpZYVB3ZXV6cis3emZKUzJxL3FVZGZmMHJwUjU0aGVM?=
 =?utf-8?B?bE1uSHh3VDFwZk1YR2lXdFNmVk12N2ZaRlgvaWdVOUYzUzNoQXlnQm43Ylkv?=
 =?utf-8?B?c015aWE2NWJFcTh4Qk5DRGpScUJabmlKNTVubm02VHAyaTBKNlc0MU9XREJU?=
 =?utf-8?B?emsyUUdTM1E3NTNUQmsvRDRJK3gwTUprZGllTVRBcklOcDhaZkQzLzlVNzVm?=
 =?utf-8?B?M21rVHV5Q0hZM0pWci9HVHQyLzVyeUpONUZubzZaUUs4dVR3a2x4WmE5NWpu?=
 =?utf-8?B?UExMenV3YmwvWnkzRFR3eWFGQVF1NFZtOWVQeXB1bmZ4ZWpQSjhFMmI3ZnQr?=
 =?utf-8?B?NnE3QktsY2duUEs2NjFadUdGckhENEtRZC8rMlBMYklidHVNdGhRQnBNaXR4?=
 =?utf-8?B?OGtwUk81K2w4eUlMOVp5RnBuZkN2UFlKK3I0dzNNdnNabGVsYXBkQ1UxMFRp?=
 =?utf-8?B?bktJUDdyNHRlanFUMDlRb1hFWFFsVStLRHVuVWRHdW9rWmw0TnhOUXNCUUJF?=
 =?utf-8?B?djhRdU1EMVozcDJLVWdFU2piWXZCTlMrMmdnS2pRbXZ2Y0pBZWlhYTRGQ1p6?=
 =?utf-8?B?dXo2ekE3cjQrTkx1eU9FR0xBdCtFNGtvMk5PMXRpUGZPY0VyRWlMbi9EbVRG?=
 =?utf-8?B?YzErNW1QMnhzdHdUUmxNSCtMSzZ4WTVQb01zZEFCdmMyZ1pvRCtRQ0k0alFq?=
 =?utf-8?B?aEt0M2IxY3VMSGpwcDlqaHhSME5wOTh0dmlQalhzaWRhcFlmakFxOXZGbGkz?=
 =?utf-8?B?Um90OUYzZVlMejh6eTVpZ1hwYWlQZ0V0cW1zUHl0bk5jWmY0OWJzcTUzZHcw?=
 =?utf-8?B?RWQ2Y3gvMDFQaWlVRkV6MWF0K0MxSlhYYTVZaFRHSjJXVmMreXpjaS9IUE5v?=
 =?utf-8?B?OHRDU1k0RmV2K012VEVicjJRNExrSWV3VjhqeEdlTU9hUmwxOERPNEZzdGlU?=
 =?utf-8?B?TmwzdzBINzRWcVU3MjIrODRBbjh4YTd5SmY1NUJ0N0hvUGx2VEx0dVVLclU4?=
 =?utf-8?B?aENTSkkyMmZaay9lK3MvOG5KTTV0Y3A0YmhSYkNncW0zTmlnUk5IU2E2cmhh?=
 =?utf-8?B?Q1RJTktVZUt3QUJHN2pvSzF3RXhmd2w5bmsrSkxSUWJjTzZQU2lYU3ZyZmsz?=
 =?utf-8?B?U1dXenNnR1ZKaDRYUWc4a0JzcXEzU3pCUFNZd2xXYzVqa2tKQ0RRRlhWbUZj?=
 =?utf-8?B?TXNDRVBqU1cvZlRaR0dJT3Z6ajRpSmF4a1FtR1RpaVJIV01GZEY5YThUM1V3?=
 =?utf-8?B?bFBseU1Mc2d3K0VuN3Q1OC9iV2pWTE1oNW9XTDl2UFlWQzBTeWJmaEJVa0Zq?=
 =?utf-8?B?RDZIMVdVZ1FyOGJHRDk3cDRKNmgrN3BMTmVrenp6KzlLdEI3Z0hsRW41SXpX?=
 =?utf-8?B?OURkT1pKaS94VTJOMUQwZ2U5VWd2UW05SlgxenQ1TlZUeExzV2dJVjh3TVp6?=
 =?utf-8?B?SlBlSUJRWTF3TmZpTDlpOUFNOVpOcUxwaGRYb0ZQS2tEQUFyVGc3cVM1UFgz?=
 =?utf-8?B?ckduWDFPUTNES3JyMzJUMy9heXNUeEJXdmV4RXEvVHdJZi9NTzErNTFZem0z?=
 =?utf-8?B?QkRVOWpUaHZqamFHbTJod3doQmp1YWdWV0JWN3AxelNlWllCTlBLbmc3T0N6?=
 =?utf-8?B?cWdiZWRLc2lQZlgrdzJJN2Y2WnVyczIvVmphbjZ2cU04Y1NrTURkU2NUWlkz?=
 =?utf-8?B?TFJtb3UrYVJXUXRWNTVlZy9ZWGhOaHA2cU9EaGJ2ZlBUZGtVd0ZPMkhjM1Q5?=
 =?utf-8?B?UU0zb1cxY00vK2N0NVpNNWtrTm1ySVVaUktBU1gxd0c0RHBJTlBaazU3cUp0?=
 =?utf-8?Q?fOVc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ef2eae-ae95-48eb-4e8b-08ddf6e38359
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 18:45:17.7767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zT14QK5VM5lZApS9FbKdVow3O6yvweGSPRcsxHdL780YIZguGEb+FOLI7QT/8umWnDzMjy4Ac6pFYyPL3jDHLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7576
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7E092160004
X-Stat-Signature: uhrzgrqfjn4dj9gcd74mu5az3yah3a35
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758221127-701649
X-HE-Meta: U2FsdGVkX19PZeTmLamOgFA+yWo33cv18wiSx5Yet9nlaFGn4D3cFVxDcqMIzVAboXNvlnYYeVPnLaCPjpt/NmnLTB8nuOgHJP1SKgHbFXCC7w28+5TC9cej/ZI1k3tJgSKHLFYPQnmJQVpyiqdfEvdE8SKGsUc1NMxnLpwUz89bsXPdahlWYBRFMWYGoRPbLdVSjXOE7TU1YMamZEv5sLtjqS2T/DeEVBOHSlJOgMrYECn609/3uhXcTN6iroJk+NHisRfF9i4ceYowq3CPPJSHdKnple5PyIzJpqIndKTForGIqTfJBJY+kmHTnXXWh/JSv2q5Mp8XtQeUZqo2nF+3dFMEZOTwk+CRSZJysbJx79QdL1AmiW8upz/DXfUxy5iOlPihkO2JG6zGpMirABS2jdEOK1FbSPzS0SAn9RBKyLVQsCE3brCTozsKMI/GBSgq65SoGLwslZpqNyQiSIEL1Hr3YbUrMQO8NmnN02Al69YsbAyPyhEV+iUfUSFVOfjJIKSoXQWO7UOFy7tHdxm4LO9xDrDztcNpjerMItLt6N1+1WQbI6wWf/Ygq4f+5NERYxLDJ1pDyUSX6cvbZqawWpBB3/y3UmkG2tW8x70qkK3/thJ+SUv2XRPjXmSBHsUdzy/Swb7lNnXuccKSFVeu7gZ8VlZReCHb3C27kAwYOu2/OCaWOnF15DxOCI3MHNKpGGhswpb2Ajqv9Rj1fWf9C2P5d5u8fuu1cIdyOxPQ8YbM5mQjyS20n3r3Yr0E61RpP+Ks7LvoSln/hiWTZiYDRxl9NPJnwfCQr1QefRJkmoiWd057O2x5aRDswBfBuDIIZdoPICm96a1TZ+H1/dN1XUJkfKC3LtnhSGMvgSHmoPrqsHc2rgL8HfKRqG/qk4EOOjiyEZZTHXejZ5xLk0tEgBUJuUpJM+W3HrvbgibfYt+IqklxgiSVqZdidI0jybS4xuUMnPVb2MDGzaG
 nJG7P1+Y
 dTaTuzBgzQX5kPe6zuWKYcm7g8VvpaihUCzoSbxhUrP0XI+6Nb1G7s8kFhGMRaijf7TQJvdbxzzPgZ+YogIekAUy2k7l+cx1CEM6VQxvva3i6YTW9KkEikKBZaEz+jQE0lfKHpY4w3koGhfvChVlNo+25XGXYeGpRu/ExHZVqauKBwYJ66ce57Bai2Z7Z+z+5/iyrpXVbP4QVw4mwJumJl2YJQLQsNBBg8C806cbw1iJ2pL7QzgP/JNvTaR2d/klVvMx/uL03JROaYVNeMieFybRCZpP+XpJUKDEJfTLuL/9K9ftT3wP6wsbvI1ChZYSycl2OKnLYD5hu8uDh4jCgt35SeE9AGf5VMUsKDBpg1Kg+oIgZK5sDgjwMQSOcemYZCyiz+KXFvbx5eRmVWG9TqWO+sD8UBBXcKGLtbAsemPCpWbPgmG5E6gJ7D+3kgPlT9wU9Y3SA7iK3l8H20cbG5Rx6dAakTjMdsiAWARUQVRcWAt51xT0+RcrrTeubeqbq+a2zHs9oRt/Hx+60kCRVYsdz1NTyKEHdSnVmg1p9VAbT2M3+hlMt0niN/B1dm7hLfXir5GKpZxcBO3LVx+x89wlTT2BHErmfY4o3j+pn3uTMCd6cgeN+XGj58CkqE4C03K6FYgvzvYJdqxx4sve1k5Wsmz1L0cuZFYE+TWXPtvkQ0JjJO40LmEzoGp7F1ho/XtffsoQ6HwEPjy9AmMRKaC3wPiOJOvFxqG+7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBUaGFuayB5b3UgZm9yIHlvdXIgZGV0YWlsZWQgZXhwbGFuYXRpb24uIEkgYmVsaWV2ZSB0aGlz
IGlzIGV4YWN0bHkgdGhlIHByb2JsZW0NCj4gd2UncmUgZW5jb3VudGVyaW5nIGluIG91ciBwcm9k
dWN0aW9uIGVudmlyb25tZW50Lg0KPg0KPiBBcyB5b3UgbWVudGlvbmVkLCBtZW1vcnkgYWNjZXNz
IGlzIHR5cGljYWxseSBpbnRlcmxlYXZlZCBiZXR3ZWVuIGNoYW5uZWxzLiBXaGVuDQo+IHRoZSBw
ZXItcmFuayB0aHJlc2hvbGQgaXMgZXhjZWVkZWQsIHNvZnQtb2ZmbGluaW5nIHRoZSBsYXN0IGFj
Y2Vzc2VkIGFkZHJlc3MNCj4gc2VlbXMgdW5yZWFzb25hYmxlIC0gcmVnYXJkbGVzcyBvZiB3aGV0
aGVyIGl0J3MgYSA0S0IgcGFnZSBvciBhIGh1Z2UgcGFnZS4gVGhlDQo+IGVycm9yIGFjY3VtdWxh
dGlvbiBoYXBwZW5zIGF0IHRoZSByYW5rIGxldmVsLCBidXQgdGhlIGFjdGlvbiBpcyB0YWtlbiBv
biBhDQo+IHNwZWNpZmljIHBhZ2UgdGhhdCBoYXBwZW5lZCB0byB0cmlnZ2VyIHRoZSB0aHJlc2hv
bGQsIHdoaWNoIGRvZXNuJ3QgYWRkcmVzcyB0aGUNCj4gdW5kZXJseWluZyBpc3N1ZS4NCj4NCj4g
SSdtIGN1cmlvdXMgYWJvdXQgdGhlIGludGVuZGVkIHVzZSBjYXNlIGZvciB0aGUgQ1BFUl9TRUNf
RVJST1JfVEhSRVNIT0xEX0VYQ0VFREVEDQo+IGZsYWcuIFdoYXQgc2NlbmFyaW8gd2FzIEludGVs
IEJJT1MgZXhwZWN0aW5nIHRoZSBPUyB0byBoYW5kbGUgd2hlbiB0aGlzIGZsYWcgaXMgc2V0Pw0K
PiBJcyB0aGVyZSBhIHNwZWNpZmljIGludGVycHJldGF0aW9uIG9mICJ0aHJlc2hvbGQgZXhjZWVk
ZWQiIHRoYXQgd291bGQgbWFrZQ0KPiBwYWdlLWxldmVsIG9mZmxpbmUgYWN0aW9uIG1lYW5pbmdm
dWw/IElmIG5vdCwgaG93IGFib3V0IGRpc2FibGluZyBzb2Z0IG9mZmxpbmUgZnJvbQ0KPiBHSEVT
IGFuZCBsZWF2ZSB0aGF0IHRvIHVzZXJzcGFjZSB0b29scyBsaWtlIHJhc2RhZW1vbiAobWNlbG9n
KSA/DQoNClRoZSBvcmlnaW5hbCB1c2UgY2FzZSB3YXMgZGVmaW5lZCBieSBJQk0gWzFdICh0aGF0
IGRpdmlzaW9uIGlzIG5vdyBwYXJ0IG9mIExlbm92bykuDQpJQk0gQklPUyBlbmFibGVkIGEgZmly
bXdhcmUgZmlyc3QgbW9kZSB0byBoYW5kbGUgZXJyb3JzLCBjdXR0aW5nIHRoZSBPUyBvdXQgb2YN
CnRoZSBwaWN0dXJlLiBCdXQgdGhlIGNoYWxsZW5nZSB3aXRoIHRoaXMgd2FzIGhvdyB0byBoYW5k
bGUgYSBjYXNlIHdoZXJlIHRoZSBCSU9TDQppZGVudGlmaWVkIGEgcmVjdXJyaW5nIHByb2JsZW0g
b24gYSBzcGVjaWZpYyBtZW1vcnkgYWRkcmVzcy4gVGhlIHNvbHV0aW9uIHByb3Bvc2VkDQp3YXMg
dG8gdXNlIEdIRVMgbm90aWZpY2F0aW9uIHVzaW5nIHRoZSBDUEVSX1NFQ19FUlJPUl9USFJFU0hP
TERfRVhDRUVERUQNCmZsYWcgdG8gbGV0IHRoZSBPUyBrbm93IHRoYXQgdGhpcyBjb3JyZWN0ZWQg
ZXJyb3IgbmVlZHMgc29tZSBhY3Rpb24uDQoNCi1Ub255DQoNClsxXSBjZjg3MGM3MGExOTQgKCJt
Y2U6IGFjcGkvYXBlaTogU29mdC1vZmZsaW5lIGEgcGFnZSBvbiBmaXJtd2FyZSBHSEVTIG5vdGlm
aWNhdGlvbiIpDQoNCg0K


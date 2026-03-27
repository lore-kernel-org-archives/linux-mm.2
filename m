Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9D910BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9968C6B00AD; Fri, 27 Mar 2026 03:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EC96B00AE; Fri, 27 Mar 2026 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DB76B00AF; Fri, 27 Mar 2026 03:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 710946B00AD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:47:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E90B141007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:47:37 +0000 (UTC)
X-FDA: 84591063354.14.80A02D9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 30821A0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:47:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z0q+mL5x;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZpA+0YZuM3cPG4alytK57J4e9kQMpBxndzYODYtteQ=;
	b=X3V4PaRRla284Cwhm7B19PuEiYNkjXeRA090ALh2mXB4wvUKWX6DI5RssSmMnEHl9D1QM2
	GsC/wM4eNkJ3Tdh4ov21PLAH6ycaZ9wPI2OB1IIAM0iJ0hvry/xg2kAVztZto1zxGlm7i5
	OUBLu3Fk+EBy/zw6ZONorqe9NSneIqM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774597653; a=rsa-sha256;
	cv=fail;
	b=tdB57qzk6rXEOAuXNpWw5ZCRJwLdQKweneyv7y+q/GID3F3AM/6d24tXRCt7ZghnZdEOnd
	bAywSraie7RBfa/4WuCzfLpi9ObWI7kLv0cHfHWpO1v8/765vfShgMOX4flzOOKq3eEguT
	7o4m9GGbPT8ybjaZThuys3BO//3FsWY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z0q+mL5x;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774597653; x=1806133653;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AZpA+0YZuM3cPG4alytK57J4e9kQMpBxndzYODYtteQ=;
  b=Z0q+mL5xQiMybdHM4bRxR/h4hedFuNgmyRlEcda7FsWhXAI8EyDcoPRQ
   HTImVysaCYRqri8Q8MiXfouEUv/XsyvnVhlJrdYE7UB60p7Wmgyw/jR8G
   mvDC2VkFKBoZLzEiy3vR7wpRcZoApSvDZ6W6UwA8Nhn13N/mGl+J6InFB
   9QOdSe631L4jmamHSxKZXHs7iaAnQ3NhLs980Znw2pUSnVudsgU0t9a7f
   cEbBu7e4zqddzK3I735ksQLt7cz4TchFuoEShUH6WMOcYPe/GSKx8eCQ2
   WjJ3aAKCl2o8Df3rw1vRj8vONgQxtYkFMt5CzrQ2DrPVAwbK+oOuGRGk7
   g==;
X-CSE-ConnectionGUID: eGQSH5rNRn+vWkn+cBvBSA==
X-CSE-MsgGUID: Qr5kwZgRT2ufuz39fw1p6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75735240"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="75735240"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 00:47:31 -0700
X-CSE-ConnectionGUID: CgjP74r9SViW/NmJlxEOkg==
X-CSE-MsgGUID: s+R/QyFKTbymXCROwEU8bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="255743056"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 00:47:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 00:47:30 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 00:47:30 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 00:47:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JE5FgsyK8LIJRwffa2WvZkKdEKjqsJwjKe1kGrodXVJICeMJ2A2cnxNOIGFtB3uhnAF6FbliRa8PaOYfBBNi3F27Trp67niUt/w8I27pxBvinwjBvR8RruyoxRr/PPwvZR4nQRlIgzKhjvOS9FgcWL4MD82CzHzoawe0pyWZbALnVMT/6KtCepnJJzZHQEPr4jfeS0qL8LVNOqH+wFYw1HvtpVwVSK3w+ujLy/dQm35HD31mzVE1sJDsWr58ZB5GhCGkqysnNxbFyr9sTkyvm0RhLF8SGcFBIk2iYVf41JVmuKRu0ExDmnvgClKdIYKE/KFag7bPwa1D6uKDhIPi9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZpA+0YZuM3cPG4alytK57J4e9kQMpBxndzYODYtteQ=;
 b=PeFri5xFfEk+Zu8Z6lHwtRocdWwVUa6HuPfoMgZL1yLwSiMBwo0dew7TTX/muX2uxJvRcgWxrKqJV5BLVflf1hxn7vN3++z5O6bsF5lSy4nDUOAZTdS5KpJ/7rRre5TkBSabLXNFIsvWCf+l9QRGnKN8JhIK4AmJNtR4FSdleslXfe0bH+JZag+/4SWxieTUMuG6A7GYGy/PT7oIprrJEiaZa+IbijUj3mXd7wPL67st18CCamTW83hRxMgBchgUe9rsqpudTBKBtr4NAJ+jeBTQdF8VPXNY4522sLIx/uBn//oMrQc9DFspYXuTZTE/OP8ZNP0g23e7t26Ox9qxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 07:47:27 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%7]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 07:47:27 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Chen, Yu C"
	<yu.c.chen@intel.com>, Mike Rapoport <rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLW7+GGAgAAJqICAAAMeAIAEZ1oAgAALpQCAACWwgIABbOpQ
Date: Fri, 27 Mar 2026 07:47:27 +0000
Message-ID: <IA4PR11MB9009D72746B910E2FC3632D7A357A@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <acEkfaycrJI-kWjk@kernel.org>
 <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
 <IA4PR11MB90092536DE2D9DF404E3B3EDA356A@IA4PR11MB9009.namprd11.prod.outlook.com>
 <cc8ee2c6-a169-4cb1-9c16-e76ae08fcc58@intel.com>
 <72934683-0409-4e6a-9d34-daabade131eb@kernel.org>
In-Reply-To: <72934683-0409-4e6a-9d34-daabade131eb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|DM4PR11MB6359:EE_
x-ms-office365-filtering-correlation-id: 685821cd-bdea-425d-f82a-08de8bd517bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: ctZroNmjYdPBiwyT09DnWQc2KmaPl8CWW9vaRGEJGI1M2Q/VtpDT72QzITbIRs0RGx7Jos5i8rlvraeyavfzMi6v8p9ShiP07pUR0ohid14ijqqGs7gnr0D2UBrsfWjlHuPn0fme7GSL1NCBuUyX86g2yAjCM0SIoY3toOsRv3SOJWKFG9xhIoE4pFReALpBYmnsAs0uyjm05GztdXcR/vnERqFP+Z8KDMbMGdHa1zTV3GJhb5JBVvAn3xyKFIZPUIV282AW37MgbWxMpJTE1AisiYG6MHWRJJO+ideBGNlHOqJa6p2PzMXxX/j86gDaU0mOCUrbgcOr6FYDCKTrysokBOufaN6xGGaUksWL9SWewVJsvoedmZ1tkslQrXWzA+Cw3UNfB4bOULhEJ/ep3k8I9cn5Ib7i67eeSZWdwW2B5RJCq1Y5rAFxOGuRMi2HX4HTjWshAJFQQ23cZImEL05q6yBTFPD6zMh6koBH9hofNEeNIPwcbxUMPWXAzaS+vY99+Uqc9dnL9rjitSUVivFAbdPv1DbL/lSym52M6lNTv3X0eIkEg6RtLWfIBeAPqHiZQIeP9ynWwjorGj50/DYMz6PiUreKLyBuz/Y6Fa66GMnThzxb4U2pS15BarAsPOxDLQgurVUG734o4yPrFReNU0MHvWBkPkqNDuvoDgt+TbE4VFOxxOD1/v6E/uaVh9LxcuEqe1AjiUy+EJWv8Z5xywXd7XFZZBX8GZgAOizrv9KHwB4Tzh84OZJFiWcZj2jjBz4tXd2e5sJQ1KjxxWGaRHapKexfKD4/0sefqwM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHlMU1lLWTlzblN4SlQ5N0JNTWxsenQ3RWlnMnJrZnBXZitBc0RpZEJLeTM2?=
 =?utf-8?B?bTJ1c3REOGk1T3RsZ0RZeTMyYW5TdkRiZk1sb01HdmFkUlV2OVZqdjNrV1hB?=
 =?utf-8?B?cUdaWlprMzU4S21BRnNZdFh0ZTlETDFPcjEzTUM4UHVKb1llN3JjVVZEZnRK?=
 =?utf-8?B?d05UZ1YvK051V0pReFk5Q0tWREUwNjNrT0RXZmlsQVR0WlhhS2piMnFZbTV3?=
 =?utf-8?B?WWJUMTNVOHlQQlR5UERCbS9WOGVzQm1XYUZxZ1kwM1cwWGtpQjFCajB6V0FC?=
 =?utf-8?B?UFFPeU9iUndKVkMvSHMwZDlIUWpkaVE4WGhQNFFJM3B5MFhSMjNjU3ZWTDR5?=
 =?utf-8?B?Tkg1V1NINUdqL1VNQUxRRlllbmU4b2ZCV0pWTTI5eHFOZzREbzRKaXNjREVR?=
 =?utf-8?B?RTJLR3Y3MU1YUXhha1RuN3N0RmM5eTV5S3UrYTQ1STdGNzJLK1dyVFFFYkxR?=
 =?utf-8?B?N0hJS1NiZDZzaTZiUXlQeXZPYjRVcTFuT2RkNHFGOTEvb0lST0ZGZjAyaXBV?=
 =?utf-8?B?cEt6WmhoQXFuSk5Pb1NNNmQyNSsrZzEwMi9yajF0OVdGM0hsTEpxYXJJemUw?=
 =?utf-8?B?NXM3OGZJWERCRHoydk5mbHphOGRjaUYzQXdubmU0d0Y2NUU3TmR2REx4a0I2?=
 =?utf-8?B?YjlabzdLU2J5N3JrRGNycTBCRUNiM1FUMUkvaDNkVm55SEdPQzd0eEVsUGdM?=
 =?utf-8?B?VlMrQkErTnlINDMwSzQ1Z2R2SHNXSW91Zmw0SmRXRXNTR24ySUpVTHBJbDlN?=
 =?utf-8?B?UG9XQzJ2OGpBUjg0b0VIU3hpUi9od09udnBKMmhzamVLcGJ2YUE2YWIvMit5?=
 =?utf-8?B?ZFBmL2pjVStYV3NOeFZHUjBibFMyUlpvb1QzZUxWb2lwVG1JQ1JPeVBhdzVz?=
 =?utf-8?B?T3p2ZTRuNHZQYlpnVmhCc3RJNnA3T1ZZY1pUa2JmTTB2Q2pvZnBxWi90d1Yr?=
 =?utf-8?B?Sy9nQmRmYTBPUnNZNjhFWTEyazNiS1JEa2txUFZIZjJoaFFFSEdZQlA5Tlcv?=
 =?utf-8?B?WVBOSnJRL0kvOFdINzhsbFgzbDhydmN6ZjNjekhNTU1qQUppbjNhYXFDYzdC?=
 =?utf-8?B?d1lTeVhVSWJUbEpMTE0yZlZSTEo3K2lOYlRTWXkveVFEZmxQWXMyQjlmby9Q?=
 =?utf-8?B?eGR3bFZaaXMxWHVwdUdvbEMreUw1UEswUlB4UGQveUYyR1h5SUlIMTJDak9r?=
 =?utf-8?B?elJ4dUZLRWYydUtUS0JTekttNEtneUZxNjNqSGszUmtRaWhXdmtnSEZQands?=
 =?utf-8?B?NEtJb3pIU0pCRXpnTmRoN1BqTzZOZXpQdXdUbUIrUjlqWThqUHlDSWpZT2NB?=
 =?utf-8?B?cUV0dWh5ZDN5aW15cWNyREpwcFBRT3BRWU9odmQxUkhYYlIrbmFBclE1VEx3?=
 =?utf-8?B?QlNZdzBzU0UrNjhIVENjNm94eXBWd1F6MzBrajBYcUJiNVBqeGJnelJTdldh?=
 =?utf-8?B?NHl2ZTF1aWNHT0dqWkFocFhHVnNRTkdneHdLL1Bybjd4VkM4bWRhSGRZUERZ?=
 =?utf-8?B?ZHU5NDlCdjloSmt0a0krSmMzenB3N1g0YnB4SUt2TU1SMThCY1dqUVlNT1JF?=
 =?utf-8?B?MUZ1TlhYUjQrdHBhS2NhRE01V2RQc01jOWNzRWhRTjdtWGZmQitVemVHZFN5?=
 =?utf-8?B?azB4VmhTaVF2KzFSRW1Tb1p3TWMxSm8vUDBOcFVkSUVOUlR3Y3NMVnNwSmtk?=
 =?utf-8?B?VlovRUQ5QUVwU1lSS0lGaDM2SmhnU1kxN3Y3K2w1L2NQWmJIYncrdVZkNnJ3?=
 =?utf-8?B?WVNWUkFXMzBVM2wrdUJxalFKWDFxWFBqaTlqNHU1dlpUVXlFbXROMGNjT3Bt?=
 =?utf-8?B?ZUdrcjFkRXVqSHhoZDdkYjJpQUJGOE5KVmdRQXNTTFlBdGRxb3JzVEkrMHYx?=
 =?utf-8?B?QWtqNndpQW9WSlBJV2JnckhpM1RCbGJjclJJT1o1em1YTlBZRStEVEJnd2ZD?=
 =?utf-8?B?dVlBQlZxY0psVnVTWkdCeStJOVlHMXlYb21ENTdFbThoaDJlc0VtK09lVGp6?=
 =?utf-8?B?R0xmdUo0TG9PZzNhMFYvSGlCYXZlVWhNbTFvU0Q1YkNOZjFDanFGUFd4R0U5?=
 =?utf-8?B?T0wweG1MOXgyam01NWd2WnRDU0FibitZTWlRZ2MvMENPSXpZbTFHcDliMENM?=
 =?utf-8?B?dU85OTBOWGx6SDJneG9lK2J4SFBYMjZZRjBwVHJQSHk5Rkw5UGlOVnpxdFRB?=
 =?utf-8?B?VFhDSGV2WHV0aEpoUEk4SEtXWVlPYi9YaC9YMUcyS3BoRFRDOWZNaHh4Q3A5?=
 =?utf-8?B?aHMyL2s2WXJiUWFFSVc0UGNsaFRuL1pnOEw3QnlGVWFUcXhDM25LM1RTOTRR?=
 =?utf-8?B?R1Vhbmh0ZUREY0doZUN1K3pJTlpJUEp2S1VJWUJ2QVc1SXJQd3N0QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: dA3G1mFmbGeJhMDK+pnHFDSTIoQ/FHPNnBv35aJTzDr+T/Y1YheMUbap95wtGdExEc5IBwAk5nnhxsq2JNfN/mec4YvsxObBf0qUPzXfrPFzFbTefn3UtxVsJEhkzMwvixFX1WYH3N/54iyj+A16p5+XQbZjLKqln0JucDH33IrqDJtBkuYobnCmxY6eJO8jBVGhbQJIf65aLshfhhf/RD8ErRNtbTVK/Fmx1UUMbNVzCViUFxCY8r+1y6W5v29w7aP9TIgsyzZvnLbqG6D08kjrC7KcE1tc4iAvBqAW9wxfwfLDwpLI88cw3TJwsjZdz6djdEeC4K8IIv8su9KeUg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685821cd-bdea-425d-f82a-08de8bd517bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2026 07:47:27.4830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: unhsY9yXlTYci82GPBhYaQhlyCR9A6eGcpIpRfnJW6WDmGlpfHYZ1TXwBYs3eK72YKEJDKcRzXieE5BOhDDnpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: yn4ep8bkp3juchhbqkp16qkhd97y3o99
X-Rspamd-Queue-Id: 30821A0007
X-Rspam-User: 
X-HE-Tag: 1774597652-837146
X-HE-Meta: U2FsdGVkX18RghqX0IkkoaPYuMbxVF6BWcn2IswjcaJ5eOxq4GoVqXfW5fwYjBBm6HBfXz4tpYe92VhvoAf2uOlZ+Dvw7BJLcYzG5moABj+v7ylpMKd+gRR0OQKPoe+06Cv+E4OAYKd6fcTrztmLbqqyqVSDuMw2JVA+jD11iJyaaxbSXL0k5pZ23Up77SNvgOjVJ9SoiaO187a2dtoS0p5Xk1EySrnJrv8bji6h6GyViF+Yb9RJ91+9eQa64VVlVRL9MOles+pGm/RkfciaK0mcy1XWOcTeuToUaLpZzwRSkapjIkbEr9TorIKbPuiL8rn8QS1MC3iA7Z+odM9K69eQHgO7s/RTh4broTvC2wyEztsK6MCAmzwx4K05uU6EAVYjidzjVSxcsnZDciQ9waLWa+QBHxjnffGbobST7d0VWq2AVRATlHvxzvNpUOKXgzr869Ne2xTZZHS+5FjNa06VY09XUNswRhafqDW34CJErxEcn8M/HNmhST13RjijtPR83l/WUd1D0WibNXAB3rZ8/i8JziSPr8Cg3WiiiASAxA7Wdv7a5SZHgHrqLNYRImhtv0gFcGYpFAv1U+0kYVOttOcT6njtZfGHdkAdEtQuCU4l7eLG73SMyPM/HmnaqFcpbmKghfZlmnO14OVQP3QPFGkn/3WwBlbPHVfZoHvWK35a8gwe2Dp0vPRst1fdXoMq3DnCVf0NltLNbPrNrQxTLtB5PHyjF67ThAoFEczinjym2Q+SWlx2bZROwFHftKwayZfrJYZVseecXWRSy2NYetdl/f5fUrPuL6BY/DYlIJCjtWzDHYayrEj7GNTI+f20LGmcFtBgQSdBJ4GtfWDuYCH4ZZTBnQmQbWe93i5Qmo+cKQsD2nXL9Ixy/Zx2p/LFlVDvTR6TqFC9a3fR/6Fg3sCJQZF5X65u0m7MumPFFPrcAljQa6kmCgzXDQq0QIfLYrEQZTbtupyQcpr
 547lgpCR
 nbYyUWgGdzuV0O5SGMCtpwhH0tC/kyA6M0QFMFP4qb9IE7Y8J5F25GVDHCYMLojks8D9N8lfSyUJUj4rQlku6fo+zjoyoMQ2v6YaakkSRMrY9fr+MGxg1TP9ahYiRNAKEQhp+Hm/N5yp75Zzws5RBWsy6bmUMnYEkaqES4qR3yV3LvbROebXPpXK3LzYwuiTjIxr436jTT/thpE1jqaWmWnU8xhmLP8OW2SvVa1wau9zmuwbZFaGwzBa4ziRaXvO27bQvssiF+OaNldPt7KyPbrgIviDQBDQzfnCezqXVbNrpXXhBQArayHD+GzGtfjoDNNl+tnPgXKyA0tDw8YPZNDQe1+HK8VOiLNaUxtYC7SURxih6/qGY2lmwDgxu9r+/PO8LrMiCjXC8cuGyXjtjDwZ5kKPThJE5Tn45NyoVl/ArpTP/9uvs1WzhD9FRBC52fFxeMmdXHVPhltoPQ+egMKJQ4UvqFsMX57o1bSxwLmkrWvWEumrrfGKpqKYKJd1Otgb+6iDF7qyEoBBDVgFwnDvMd3Puw2cs+/yN98VN1QlEJ8dxXmkSNX8idAq0POAgR6wmE6db9ezHpBtc2yNs9i5VuHvYNbn33AMuwOkLZ2UsyZDP5uto3Ffw9yljwv3eh1mC48XDTBjD7/tVLsgG7AMnhoiSg8knUh90VtAQ4buK7zThEtLwpwo5EnwtiWAsJUltVvSLOJ666Q5VlPxpz6/Agqj+ZOS/URxCKERlvpMsKgsRRQjJsP4BMEWac3B5M5tj1/nv3nZyQxWwDiKTkZ2/jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhdmlkIEhpbGRlbmJyYW5k
IChBcm0pIDxkYXZpZEBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMjYsIDIw
MjYgNTo1NCBQTQ0KPiBUbzogQ2hlbiwgWXUgQyA8eXUuYy5jaGVuQGludGVsLmNvbT47IExpdSwg
WXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+DQo+IENjOiBPc2NhciBTYWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+OyBXZWkgWWFu
Zw0KPiA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT47IGxpbnV4LW1tQGt2YWNrLm9yZzsgSHUs
IFlvbmcNCj4gPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5oYWkgPG5hbmhhaS56b3VAaW50
ZWwuY29tPjsgVGltIENoZW4NCj4gPHRpbS5jLmNoZW5AbGludXguaW50ZWwuY29tPjsgWmh1bywg
UWl1eHUgPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgRGVuZywNCj4gUGFuIDxwYW4uZGVuZ0BpbnRl
bC5jb20+OyBMaSwgVGlhbnlvdSA8dGlhbnlvdS5saUBpbnRlbC5jb20+OyBDaGVuIFpoYW5nDQo+
IDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG1tL21lbW9yeSBob3RwbHVnL3VucGx1ZzogT3B0aW1pemUg
em9uZSBjb250aWd1b3VzDQo+IGNoZWNrIHdoZW4gY2hhbmdpbmcgcGZuIHJhbmdlDQo+IA0KPiBP
biAzLzI2LzI2IDA4OjM4LCBDaGVuLCBZdSBDIHdyb3RlOg0KPiA+IE9uIDMvMjYvMjAyNiAzOjMw
IFBNLCBMaXUsIFl1YW4xIHdyb3RlOg0KPiA+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gPg0KPiA+IFsgLi4uLiBdDQo+ID4NCj4gPj4NCj4gPj4gQnR3LCBjYW4gd2UgaW50cm9kdWNl
IGEgbmV3IGtlcm5lbCBjb21tYW5kLWxpbmUgcGFyYW1ldGVyIHRvIGFsbG93DQo+ID4+IHVzZXJz
IHRvIHNlbGVjdA0KPiA+PiB0aGUgbWVtb3J5IGJsb2NrIHNpemU/IFRoaXMgY291bGQgYWxzbyBh
ZGRyZXNzIHRoZSBjdXJyZW50IGlzc3VlLg0KPiA+Pg0KPiA+PiBUZXN0IFJlc3VsdHMgYXMgYmVs
b3csIG1lbW9yeSBibG9jayBzaXplIDEyOE1CIFZzLiAyR0INCj4gPj4gKy0tLS0tLS0tLS0tLS0t
LS0rLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0N
Cj4gLSsNCj4gPj4gfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IFNpemUgfMKgwqDC
oCAxMjhNR8KgwqDCoMKgwqAgfMKgwqDCoCAyR0LCoMKgwqDCoMKgwqAgfCBUaW1lIFJlZHVjdGlv
bg0KPiB8DQo+ID4+IHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKy0tLS0tLSstLS0t
LS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tDQo+IC0rDQo+ID4+IHwg
UGx1ZyBNZW1vcnnCoMKgwqAgfCAyNTZHDQo+IHzCoMKgwqDCoMKgIDEwc8KgwqDCoMKgwqAgfMKg
wqDCoMKgwqDCoCAzc8KgwqDCoMKgIHzCoMKgwqDCoMKgwqAgNzAlwqDCoMKgwqDCoCB8DQo+ID4+
IHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0r
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tDQo+IC0rDQo+ID4+IHzCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfCA1MTJHDQo+IHzCoMKgwqDCoMKgIDM2c8KgwqDCoMKgwqAgfMKg
wqDCoMKgwqDCoCA3c8KgwqDCoMKgIHzCoMKgwqDCoMKgwqAgODElwqDCoMKgwqDCoCB8DQo+ID4+
ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0r
LS0tLS0tLS0tLS0tLS0tDQo+IC0rDQo+ID4+IMKgICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSst
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0NCj4gPj4gKy0tLS0tLS0tLS0tLS0tLS0rDQo+
ID4+IHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCBTaXplIHzCoMKgwqAgMTI4TUfC
oMKgwqDCoMKgIHzCoMKgwqAgMkdCwqDCoMKgwqDCoMKgIHwgVGltZSBSZWR1Y3Rpb24NCj4gfA0K
PiA+PiB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICstLS0tLS0rLS0tLS0tLS0tLS0t
LS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLQ0KPiAtKw0KPiA+PiB8IFVucGx1ZyBN
ZW1vcnnCoCB8IDI1NkcNCj4gfMKgwqDCoMKgwqAgMTFzwqDCoMKgwqDCoCB8wqDCoMKgwqDCoCAz
c8KgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoCA3MiXCoMKgwqDCoMKgIHwNCj4gPj4gfMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCArLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLS0NCj4gLSsNCj4gPj4gfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDUxMkcNCj4gfMKgwqDCoMKgwqAgMzZzwqDCoMKgwqDCoCB8wqDCoMKgwqDCoCA3
c8KgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoCA4MSXCoMKgwqDCoMKgIHwNCj4gPj4gKy0tLS0tLS0t
LS0tLS0tLS0rLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0t
LS0tLS0NCj4gLSsNCj4gPj4NCj4gPj4gQW5kIEkgc2VlIHRoZSBVViBzeXN0ZW0gaGFzIGFscmVh
ZHkgdGhpcyAoS2VybmVsIHBhcmFtZXRlciBpcw0KPiA+PiB1dl9tZW1ibGtzaXplKS4NCj4gPj4g
SSB0aGluayBpZiB3ZSBjYW4gaW50cm9kdWNlIGEgY29tbW9uIGtlcm5lbCBwYXJhbWV0ZXIgZm9y
IG1lbW9yeSBibG9jaw0KPiA+PiBzaXplIGNvbmZpZ3VyYXRpb24/DQo+ID4+DQo+ID4NCj4gPiBJ
cyBpdCBwb3NzaWJsZSB0byB0dXJuIHV2X21lbWJsa3NpemUgaW50byBhIGdlbmVyaWMgY29tbWFu
ZGxpbmUNCj4gPiBtZW1ibGtzaXplIHdpdGhvdXQNCj4gPiBpbnRyb2R1Y2luZyBleHRyYSBwYXJh
bWV0ZXI/DQo+IA0KPiBXZSBkb24ndCB3YW50IHRoYXQsIGFuZCBpdCdzIGtpbmQgb2YgYSB3b3Jr
YXJvdW5kIGZvciB0aGUgcHJvYmxlbS4gOikNCj4gSSB0aGluayB3ZSB3b3VsZCB3YW50IHRvIG9u
bHkgYWNjb3VudCBwYWdlcyB0b3dhcmRzDQo+IHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCB0aGF0
IGZhbGwgd2l0aGluIHRoZSB6b25lIHNwYW4uDQo+IFdlIHdpbGwgbm90IGFjY291bnQgcGFnZXMg
aW5pdGlhbGl6ZWQgdGhhdCBhcmUgb3V0c2lkZSB0aGUgem9uZSBzcGFuLg0KPg0KPiBHcm93aW5n
IHRoZSB6b25lIGFuZCBsYXRlciB0cnlpbmcgdG8gc2hyaW5rIHRoZW0gd2lsbCBvbmx5IHBvc3Np
Ymx5IHNlZQ0KPiBhICJ0b28gc21hbGwiICBwYWdlc193aXRoX29ubGluZV9tZW1tYXAgdmFsdWUu
IFRoYXQgaXMgZmluZSwgaXQgc2ltcGx5DQo+IHByZXZlbnRzIGRldGVjdGluZyAiY29udGlndW91
cyIgc28gaXQncyBzYWZlLg0KPiANCj4gV2UgY2FuIGRvY3VtZW50IHRoYXQsIGFuZCBpbiB0aGUg
ZnV0dXJlIHdlIGNvdWxkIGhhbmRsZSBpdCBhIGJpdCBuaWNlcg0KPiAoZS5nLiwgaW5kaWNhdGUg
dGhlc2UgcGFnZXMgYXMgYmVpbmcganVzdCBmaWxsIG1hdGVyaWFsKS4NCj4gDQo+IFNvIGluZGVl
ZCwgSSBndWVzcyB3ZSB3YW50IHRvIHRlYWNoIGluaXRfdW5hdmFpbGFibGVfcmFuZ2UoKSB0byBv
bmx5DQo+IGFjY291bnQgdG93YXJkcyB6b25lLT5wYWdlc193aXRoX29ubGluZV9tZW1tYXAgd2hh
dGV2ZXIgZmFsbHMgaW50byB0aGUNCj4gem9uZSBzcGFuLg0KPiANCj4gVGhhdCBjb3VsZCBiZSBk
b25lIGludGVybmFsbHksIG9yIGZyb20gdGhlIGNhbGxlcnMgYnkgY2FsbGluZw0KPiBpbml0X3Vu
YXZhaWxhYmxlX3JhbmdlKCkgb25jZSBmb3IgdGhlIG91dC1vZi16b25lIHJhbmdlIGFuZCBvbmNl
IGZvciB0aGUNCj4gaW4tem9uZS1yYW5nZS4NCg0KVGhpcyBsb29rcyBsaWtlIGEgY2xlYXIgYXBw
cm9hY2gsIEkgd2lsbCBpbXBsZW1lbnQgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KPiAtLQ0K
PiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K


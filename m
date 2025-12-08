Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B70D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD8B6B0005; Mon,  8 Dec 2025 05:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E146B0007; Mon,  8 Dec 2025 05:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7CA6B0008; Mon,  8 Dec 2025 05:43:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 979CB6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:43:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26562BC78B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:43:31 +0000 (UTC)
X-FDA: 84195967422.12.E123095
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 937CD40003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:43:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EF30qrS/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765190607; a=rsa-sha256;
	cv=pass;
	b=dGWoSvEd4T82ouQXdhfL8qwJdiPKzh2VB7D6LLNmJBkP5MJNlaRZZk6z02GR6id0kJ2hnT
	wK1ePnCk7xMT7w7NG7XwSnoQO7HSxgxb0ucZZy+6dpKE5jH8AcWUOMnJlrqFsD1IH4D294
	AokgEoWATpl59oOQ5uGr9c9dnX0ukzc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EF30qrS/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765190607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MnNG9dcpe3eF8xzZr7Ua8wTvVtd5xkvwPWhaYMW68Y=;
	b=SEX8MiJUNEc8Z2i0919CvxNMovCgY8oPP4BRUqYQ4UD7ZJJHaGFqHohI5LjW7D3md1iw0m
	GAbVrC5nL0HHpgeRjNTjyjgk7AzFlAbYjXh8UOLKBaUyorexAzLJiZERkyFcbmUPdoWckR
	BMXUCr2mONDITYysFVGaYTZ41VAhpsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765190607; x=1796726607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GeLVhaHZY9ThhKXu6jVmgUAojDwxV9YqbHqDzrnNFyo=;
  b=EF30qrS/n+leYiEz9sfB199PPZF3Sr73LjWyq5zxE6MsKVZtkbYzq21o
   Xfx1rFC1oghL7uYPnQnXDCxGIU+kRwyv2vCE7WA+Y+OuqrU8WU5xUh78r
   OwgL9AK9v6lbpSY/QeoaZ8RkoW0SWNqs6xg+eGwuu4ykks3fK4FbFx/Vj
   ls1CENIODmsPGpB3H1jC11Yz+V77eYxhEd2IWPHztp9PiK9o64BRn5Btb
   9UQfUN80Lg0vO86bRiriwMu2cK8Vb8YXs4stRqfzJJoNvQWFhy9xwStG7
   aVR2b64ewr96JfpGmA+ZSCstMkGazFFOVhB6IU3bsSsXzJvYpaUMBBQ7f
   w==;
X-CSE-ConnectionGUID: 1Ar11Pi4SE2nlF/EThJHTw==
X-CSE-MsgGUID: nbKF3KMqS6KGxkVWSB1nTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="54669481"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="54669481"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 02:43:25 -0800
X-CSE-ConnectionGUID: P5M4U2IyS0aX/I78ZfLggw==
X-CSE-MsgGUID: S/3/uXCrRNCw1wN6hlc1KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195704060"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 02:43:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 02:43:24 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 02:43:24 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 02:43:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+7pQjWWwRLSNxO/fKrZb0ka34dDPRVAiqvjWufoHf7lbUEvKY6ocHsEg4oeXFNXjqCw4lsW0ppCkOranbfqgRWzOSV/2nPBU+EqhCIQzlrvjgYK6qEK/E0bJ0NLmiMSX65+q69ySN+iB83vA3LcqvqBDvVoKtSz230INWU1Pk2UtHOoN0Z6hxsRypjW7gPfu18p2uxkuoSJIZqkAwq6zdpU4Fgpm469xAtS+f+PdhoQbEhUO5J1QMzOgRq6tqo/wejB990WWKjI+VlDrBPt8ZaCnk4XeJrEo1bmk21vGmATGfg98JuSfIUZzq2HF7BlMEg0IW1UAhODePDcJIqSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MnNG9dcpe3eF8xzZr7Ua8wTvVtd5xkvwPWhaYMW68Y=;
 b=ciCNQGCk2DncJdb/mVgWyCz15v/1iia2AJpUAZIxmt7X9JquLze0ndlSs+kDja2KMQvzzBUSCrjZ19EvetOGItCZWAPeBtkYTdBsmGvsTo1HVCkxAFo4Zv8Adzf6ulRp7XY2+975fwFvPIkAN3MyXVL005gbibjGJf6QA2QOeReOzm/mlPc9On48oe1BNe+9gVNmUWJNvbW7kXpHNLh+ykbdqHyE+SG62dcRihfKNgYSDE/AvRIPV3OQaH/1cn/nUnVydcgRtn6ALOE4YLz7PMRzi6aO1d2RoxgbUJin301nbxXj4HuTgj3k7CtZr3mFX87qYcGmrSjtLiF4T88kEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by PH7PR11MB8570.namprd11.prod.outlook.com (2603:10b6:510:2ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 10:43:23 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 10:43:22 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "vbabka@suse.cz" <vbabka@suse.cz>
Subject: RE: [PATCH] tools/mm/slabinfo: recognize --partial/-p option
Thread-Topic: [PATCH] tools/mm/slabinfo: recognize --partial/-p option
Thread-Index: AQHcaCeJEBEt2OIJo0uD0R6/4iQ71bUXjfKA
Date: Mon, 8 Dec 2025 10:43:22 +0000
Message-ID: <LV3PR11MB876896644D26432F92500615F5A2A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20251208091018.2701315-1-kaushlendra.kumar@intel.com>
 <aTaeUEnPFIO0lxWX@hyeyoo>
In-Reply-To: <aTaeUEnPFIO0lxWX@hyeyoo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|PH7PR11MB8570:EE_
x-ms-office365-filtering-correlation-id: fd5740b3-975d-4029-a686-08de36469c29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?0OEIi82CdNIqaxTgVelL5d+DJ6ii5MyupJACSmVnpSwYO5Ypt0x0wCGH6WBU?=
 =?us-ascii?Q?mwRYxgwxCKVusdeJv9+oLRczjb+o9Wyd1Gd0T7F1Bqap68bw0K5As9KaLg2P?=
 =?us-ascii?Q?NMm0jJrVpGH1eIjUYQhK2D6c2KqrGIQ6slkle3C++iSwTDOC4y7bqOIvoJ90?=
 =?us-ascii?Q?mIX8D0mb3qmsg/Lq8DhnPnTbkwXQ8Yw3JArOd/f9ort9m5VFXabcgdW1M7VV?=
 =?us-ascii?Q?d8rNSrNRky3I6eGhT7fB0xCfO9DuXr2moxnsCyuW0ZkQobUPbrhdj2fMVtTs?=
 =?us-ascii?Q?V2KhfytdEnYafhz9v11Zz3jMG0wDpqRyxr477DB1NypPKbUp9L5R80aDPt+3?=
 =?us-ascii?Q?zyHnvxFsd+Bu4RNP3UUcAnVDqvfqW3Ugs9DKDUjpfyLIRwO9XbK+jP7XXUPH?=
 =?us-ascii?Q?9sv5i+CH5u/rkMNinxKJVPXsUgxfN3i3oIJQLhtmI4mvpkebmvnFqSeYZwP2?=
 =?us-ascii?Q?iLruYISowxEB3o8UszpB6ysO7uYQ7VGjqWIIUY8Z3u7Vm0KcOSObiqFboTXx?=
 =?us-ascii?Q?0ipbh5Ie2dsmRktWhHp8szQHRtnYjeqzfZv0eXI7KB7aDKL9DqKEgQDMtMJ/?=
 =?us-ascii?Q?ycoWtkSDKK4+86upeRP3886T3KvrdqYqpgpNoksQVJt7BoZBit4bz1/zK1xU?=
 =?us-ascii?Q?N4UFg1hyMASiDKwF8sk6nC75nhYkW6Ke44MuN4biXzmJMVJk23p2ClS/K15B?=
 =?us-ascii?Q?sOz8QJT90tFi6frwztDfRjL9U4EMph5tp7CI2uN4OkIZGf/zGgPdagqRbAek?=
 =?us-ascii?Q?NTy5CX+H4DFjFw7qG88WZwTPu09ba7/akXUhOaCXTP/ExLiOO5r9EGidimwj?=
 =?us-ascii?Q?1wWxhYcFBLXfEaOchNa+H2pAnXOWlIFGZ9L3R+0AEWmPsSqB0Hxmd/dmJXHM?=
 =?us-ascii?Q?0LTblAktU4pFE6hoc/pibBRFOlMD8LqL0BSX1VF/YHkR+IOty/qzG6jG+USe?=
 =?us-ascii?Q?mo3XAJ5eY4iS3vMgc6GHWiJcf7ZHCi4ogO+/64qQ5eYo1Hze3xC/3Eu05RMF?=
 =?us-ascii?Q?5QWx3Yt6D9s5G4RF4Fdc4T4Z+ghCr8XuUAj8xnopEUahAm7ANlhfBoMgS1b7?=
 =?us-ascii?Q?eiLtlqAb7FmAdC+V5+09XsSeRcdIGh4c/zhT0Sw//cYpBx9tcMmipan/upMd?=
 =?us-ascii?Q?BXidqRj0Gc1dz5hcqUoGrIc7fNe3MruEoa4JC5uIbmyKGGaITseMjOtbmjtL?=
 =?us-ascii?Q?Y5bUjgsQjnDhmfUKeZqlO+OLwHmTtTL1aqi5DkRdDUNB7LEHKUAcOchw9WfY?=
 =?us-ascii?Q?kG1u0/LvvkXzNOxoheJabDj4YboUJJWISQ7DeORJU65VqducITyrJoiQIiiE?=
 =?us-ascii?Q?Vmq3r9QcnMr8uj6ziHSbVDb1qGLIKDnblrtj0EyMzfq8xGZ7ADv/a4uI04gx?=
 =?us-ascii?Q?hkLE3oO8L7TYT24IrCt+wSiaYFBB3NPIyo4Hdt//WgnPjzy1n2lZ+Sw/rwQD?=
 =?us-ascii?Q?SdVCqab+ZF/6ckjMcHDm8eCXrqxaQSqfAgctpvYiU5QTfuOhtLsmzntxDLe9?=
 =?us-ascii?Q?DbtXXvpQfSo+SIF2ChBs7jlGUWVMrdODwLHZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U7dJyF6Kiu/6ZQ+yR022XU+AgxlZzREBlOxx/9CO43jAwQvNHBnElZcULTwk?=
 =?us-ascii?Q?oFVQlwTNc/xaZkWeJqFwFGbhWhbDItvOUP9wHQZr1nacs86afd/czYe1xmn6?=
 =?us-ascii?Q?bRqTNolimno9bTPrNenWa868t0e+DQbb5k6DoyXPVaJcs4HbuV6IaMekm6d9?=
 =?us-ascii?Q?RJKbHfgLH01kfI+czVO8Pr2jtF5u4iXvh1a9qc5z34ZZufbrSYuB3tWL0XGo?=
 =?us-ascii?Q?CXBowrt8dbSIqq9HrwCqDX5xrrc8r1F7XFrNBNzRxa5FTs2V+AJ8cnM3rFuE?=
 =?us-ascii?Q?4/5TFVWBVTontE8J7qQXQxOSxCMsQL0CgJSqIDuxbgRmAFLZW+Tfjlk90Auk?=
 =?us-ascii?Q?dc81GQiX4mBBFpqgiPE4s3B0wIBUYW+bMsayObM9yChf/homZR1h8g0mmk3y?=
 =?us-ascii?Q?sDt2YJ2cdss1GpMRIFGqZFY7BXQtPk8ae6M0Zd73VS+P3zXBZx1tr2QbzdA6?=
 =?us-ascii?Q?1qES1LNCHnudQ/AtMkbzYm4XWlaimX6HbEyAKmXbN8oHW2vOky2bTEmnK6QH?=
 =?us-ascii?Q?IIqUStiG1qoHVFWJ+rgZ31rBj3XPsyiciuhIt/6BkOUdg4vVZ1M2OSdZhVBJ?=
 =?us-ascii?Q?Yv/f62kSQTCu9vxkWBk9BEaHbNOuFI06smbS4vqt2jTwKSZ+4Nf1nf9IfxWp?=
 =?us-ascii?Q?YEYGFiLxaDChd1F+EWgRrxfsxOSBPdCyiYip3ZJSpk4F2smYLOXSKnZaOn0y?=
 =?us-ascii?Q?L4r4WFbW73e/Q9ouTQ6pa6QEsMXMeeDRw2OxiUvLncsUHgRRPSHCs8lUCqgY?=
 =?us-ascii?Q?ZljGAa38XvYP5BCNK+UGen5RJcNeqybYlMxZiTUMFDRMKDQlPt8SWeSa13EW?=
 =?us-ascii?Q?yU3BhsfvnEMh3uB+Qx89JEGYuxZ0VQsNQiCZDpDfNzEVnM7kKK09vFC4ty3E?=
 =?us-ascii?Q?d7EE1GyNN1hmQI5Znd4UD4K/f59QbmD2pxGT70AnxAimhiubkh5eqgVhSRk8?=
 =?us-ascii?Q?F7t33PJlsVTW+Dxg5zz25WHje6eSfbkH5Z2LlDTXEk+PkUQUslXtCqrQCRSn?=
 =?us-ascii?Q?o3OLU0uNkaTR+VoqsYrV3drSCWfDsML9xcNP4wAxPVxIYam2Zr4m3u2HPLie?=
 =?us-ascii?Q?sbijUKP7qmAMBJ0yhU6qgYksZj8Ha93NgvQlTpXo7Z9ue6WmW9mJRw6R8Xhh?=
 =?us-ascii?Q?KWpq9XZfcu0s3XBrdqKd+SYxa6L8DFiYpWsstVcJgJ+vws3l0Wk2BwbdjvQL?=
 =?us-ascii?Q?42X43DMK1ql/UUQJ1rf7v040hXlW6MDVYKmpfGmIDO1lAF7jKS/q7r2DXIh7?=
 =?us-ascii?Q?o7bOKpuMHtN0TzB4BMMP3RpJrdn2/OnCfBgkD5OYFGR5f93HlCpukWdWA1q1?=
 =?us-ascii?Q?DlAt2lAmIRiDWBtpTzOfSGITaViY+jZcpFi6vbfKD68DREy2HejkwBLmFwK5?=
 =?us-ascii?Q?D635fKJ2gdvhgx+Q7IlwGLvi3dIv/gkMq7gLG3kEzzDu+EXLvG1fE8Eg6ark?=
 =?us-ascii?Q?khNNm0Ilf/gwz3RICt3OjYURxKmwxE5xTLNwaK4iqRTz2RKHVrFTbIMM8v8O?=
 =?us-ascii?Q?odu9xGxBVB+CgJzR394ZJYu4IklAQOqjAf/6YqdyHVB1Q6F3RLDznYs75Mxb?=
 =?us-ascii?Q?Us1W/l2ixZUZHvahhpqGV+K1s1zCfoqlhcEGzf6mChqMYh1XNt2BLJ3q0GxV?=
 =?us-ascii?Q?UvBsU0oo9DnZBlW08+wwyZ8cgg0uWt9L6oJ8WOk43P+uuwwXi5PsjW3TV2dm?=
 =?us-ascii?Q?TUnoyQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5740b3-975d-4029-a686-08de36469c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 10:43:22.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xe9gWLilh6DjJfGKIrOZrIVOI96IuKY6OU2VvjMxwkP991LtdIriGMe5yA4juESMFH7m7vB0LiUAc1K3TLX0ivOianK5f/CmKoq/RPz7eFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8570
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 937CD40003
X-Stat-Signature: mn5eo17xgzcxyr81mwpr84sgpjzscz4t
X-Rspam-User: 
X-HE-Tag: 1765190606-269994
X-HE-Meta: U2FsdGVkX1+t7cGlqTwBkN5qaiYDqUXqwdGnvYxHkDb8NFZkctkZX2/E8jsRmbpS3XB3kjfUQkbbCa50YvTz3BwzlZWohD1E4r+bJuVUvqMA14jzjwzJoHmEYm6CqUTQq8H/cCGHtrVxX54m17b2mbrGecYLJ9grjUBAlPd3uQIjoEpVNb+4V8djfiuRuDTcvbvZpzWvjpNcyPBfVto7jkssak9FbgnxAY4bDWvwj1ykxaR9nwVpuoUQ40wJ3SruEZCoumKOrIUcwKmZDPg39DXsbZmi9o6h4a5dogfEmynzqw87itevQ+xzHi4anKBYKjcW/tEWdKWlV4SgLQAC+fp8ZVKG93yjrHfd8Ltan/D4W5Git+h3PJbkWSvD/mIUKA5S3PkWJcDsNVLeKjp3QK2K1xFC3Vb7Yu9ZyV1k4zZIV86dRRJisN0Tg2z9uj4YNSDr6RLe2AulO8G4NEZ/28KUCrFkD5yo+8h7BjJU/DZU4qSmN9r2IuKRRuuDd4Y73b1YEhLdQPhulwVnqnWjKA9ZtVSrdfUjqFrMzUiwr0ZbQMTxe12TFrz630OtH1a3R03CnLeB8TRs1wWPer1JIo/aPCzOFn1jn24UhIHl7TNxJNNcxqTcv15VbH42aEDu/rvI4sI8IYQU5uY9olDq+1JKZ32WlIArMiYApkqOsWxiLI+9gYsyHa5T4/oew+varVDm8Jp8POTN74VAajOe4nOjfz8h+ar5anYxtDy8JHsfxZPNf3/ZvklUfcaTlZRM6SosDENge42DH9fbWOAdePQDhgbtGnksIQybXYmGboIfWqBjCeIy9Qd76+YTvGGWe1FX8oR2QR5sCk0rOVgdtPeUzlZD69iAf/++LXXgY+L2oNULKD09eqFXENZlCVK7/to0l6aPPl+a7enSIKp729Hlz6wLl7M6uvGIuWHXLOWMVfAuUOTBRtedlKbfGyY0VKDDtpRmJvkPikqcrut
 eYLWGHri
 4Vgcgaychbi8z1lOyBFbcCbfHHhimq6lnk1O6vL1uLzyA3GxNW1IozwT3yxuaJuJYwlOFa//Nmg7xRkvowcZf0ZBzP+2oauU651eeHMpGhWa0KzIduaQnaDSHUhUF+ZwFUv/FTCt/LWfaDajpLRUSx1rD7T/FNd+tngf1BK9CQDKMN1qW7k86zA35qlz5W6OGOvyq/aShji6Ub/JyR26ZyO7QUIqiULHyS4IAAzJULAKXWN+HR013CaDVH3iKuLfjtOtW+zQr4dTgKjb3gNFq3OGdMwvCtc5zD2c5xOk0HV2sULqIrPg3Qqhs51vG3xvpNmrltrPD9StCVXnff14v10Q/WvXBXItdo4oxixJi2iQyhRJQFoin5iVSHtvrJ5u4PSeNcgoOqMjSpovAgKLy9WvOYs8hrIK9Qo6yq/G2LUrFUt2tvoD3fe8P6S0iZZAoBesnFKhYV97tyT8KrrUtyc23P8Lc6A8A5P8Y5NAHL2C8QKeUchdLt8jpDgUzbny4Kwkjl79ApBZOYbcCiYc9dYkpXKlntilbci4r3hgY3RA5AGhV+mLbM9hGQAcC4DVTwf5t0rZfn8YjoXvgazEi/YJSsDgPY1wxk88XdJtXJoKDroRadSMttPxwZKYKKC1VlteDz7ZZS03Teto=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



-----Original Message-----
From: Harry Yoo <harry.yoo@oracle.com>=20
Sent: Monday, December 8, 2025 3:16 PM
To: Kumar, Kaushlendra <kaushlendra.kumar@intel.com>
Cc: akpm@linux-foundation.org; linux-mm@kvack.org; vbabka@suse.cz
Subject: Re: [PATCH] tools/mm/slabinfo: recognize --partial/-p option

On Mon, Dec 08, 2025 at 02:40:18PM +0530, Kaushlendra Kumar wrote:
> The long option "partial" maps to 'p' but the short options string and=20
> switch handled 'P', causing -p/--partial to be rejected as invalid.
> Use lowercase 'p' consistently in the getopt short string and the=20
> switch to enable sorting by partial slabs.
>
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---

I think breaking an existing option -P is not a good idea.
Can we make --Partial work instead of breaking -P option?

>  tools/mm/slabinfo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c index=20
> 7c51d283504d..7f239da26ed2 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -125,7 +125,7 @@ static void usage(void)
>  		"-n|--numa              Show NUMA information\n"
>  		"-N|--lines=3DK           Show the first K slabs\n"
>  		"-o|--ops               Show kmem_cache_ops\n"
> -		"-P|--partial           Sort by number of partial slabs\n"
> +		"-p|--partial           Sort by number of partial slabs\n"
>  		"-r|--report            Detailed report on single slabs\n"
>  		"-s|--shrink            Shrink slabs\n"
>  		"-S|--Size              Sort by size\n"
> @@ -1427,7 +1427,7 @@ int main(int argc, char *argv[])
> =20
>  	page_size =3D getpagesize();
> =20
> -	while ((c =3D getopt_long(argc, argv, "aABd::DefhilLnN:oPrsStTUvXz1",
> +	while ((c =3D getopt_long(argc, argv, "aABd::DefhilLnN:oprsStTUvXz1",
>  						opts, NULL)) !=3D -1)
>  		switch (c) {
>  		case 'a':
> @@ -1481,7 +1481,7 @@ int main(int argc, char *argv[])
>  		case 'r':
>  			show_report =3D 1;
>  			break;
> -		case 'P':
> +		case 'p': On Mon, Dec 08, 2025, Harry Hyeonggon Yoo wrote:
> On Mon, Dec 08, 2025 at 02:40:18PM +0530, Kaushlendra Kumar wrote:
>> The long option "partial" maps to 'p' but the short options string and=20
>> switch handled 'P', causing -p/--partial to be rejected as invalid.
>> Use lowercase 'p' consistently in the getopt short string and the=20
>> switch to enable sorting by partial slabs.
>>
>> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
>> ---
>=20
> I think breaking an existing option -P is not a good idea.
> Can we make --Partial work instead of breaking -P option?

Thanks for catching this. You're right-changing -P to -p would break=20
existing scripts relying on the uppercase flag.

I'll respin the patch to keep -P working.

Will send v2 shortly.

-Kaushlendra


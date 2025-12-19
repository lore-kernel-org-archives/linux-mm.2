Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CC9E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222E76B00A6; Fri, 19 Dec 2025 15:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0AE6B00A9; Fri, 19 Dec 2025 15:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B2E6B00AA; Fri, 19 Dec 2025 15:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E83396B00A6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:09:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9815313707B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:09:41 +0000 (UTC)
X-FDA: 84237310962.08.B028DF8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 55F3D4000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:09:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpusBSDo;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766174978; a=rsa-sha256;
	cv=fail;
	b=xoRvtZZ445cvPFxzFJrglVJ3cdAQ2mfhb49Gu+2MzkNHIjvcRW/L+aSPE8X+BfJam+9+f+
	uF9mrOAiy+V4YqYFoPkZk88SIQGTxNrpYFaIrYJAf4H5IM1UjhTaNlobsi9WYmBMcT1v1v
	X8cz/0/PzxdhdApkAM4ATG8QZCwJGzc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpusBSDo;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766174978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiLSgw8nmf8f1MgKMOR00gdgBTUVY+zhs+D5OQjoqnM=;
	b=JZJq5Kav6v+nZbMBnOSwXJu+DixQ9O0dchaYMhnVRtEABadxTudhP1tdxaOchJw7nQCqQC
	gx8T4S+C6XdPCrLGaLe7poe2Sct5Gd7FBMCrVS2+vgFzLeD1JCblj1c53KsX4LDdp7c5BH
	91ndOXn1STT9zFbq+9JSUdoP5M6IdC4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766174977; x=1797710977;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=fPh2SCsz/yYDOUOCr/sCVuodYOgoK3dKz6tgAexpQIY=;
  b=OpusBSDoj0tuBWMhvE60+rlliqpuYOf34/+V5E+CmEzwVgOcI3/5feUR
   ryj+t2cehDd7m+oKv3JAyeUCjqq0NW4OQQt9VTk4ZLH/vBHgcX4WdOoRw
   yK+5zo5mBclquf9DkdaicgnQABZhXZkHbdEi5BtoZpkOMK4wuAmu1xi85
   1nsv5viQhoIVfXYl2mHcTAgfRlN9MWRdxBXpi4LA7f8o30iIH/Fkdhanj
   Y30JgaDL/BTDtG5nuMlOjZYs/yygsC89r/SmAFB/k6JfdAtLRPIfmmTUK
   DgHkPfo6wjRyWMSEM7g5sdzzO2CYRwifdySEPUcn235yolQBUW/UE0lKd
   w==;
X-CSE-ConnectionGUID: 2sPWRXk5QKKUbw7eKAGCrA==
X-CSE-MsgGUID: 8Rv3kr6ASOO0Pdf0oBFktA==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="78853646"
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="78853646"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:08:53 -0800
X-CSE-ConnectionGUID: m4vvNz+5S/qBgmcvdjpaSA==
X-CSE-MsgGUID: t6RZFUH3QlSE1cNiRBx+tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="198202394"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 12:08:50 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 12:08:48 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 12:08:48 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 12:08:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zRE4DP+2nEDSi2P2VzS7RhWMMbqwNqGY8Tiu6XvQg+fRKD/lkJ4Fe8KolBuRQ0UXsu4GlwVqeAq+/tgqK70EFAByNi/FY1L9ttTHKtQLoIwStQXWEd8XOc7K/YwE3biQwQZ1kiz16XWaOCqAatyqzzEHbo8bb5GQ5J2tkaMv0Aqckj3uqVHcZ4FFnH4jG/GAlMgR+A3Wq5MBwpY60fN0F1ilHb6TWMMlP5M/u8bvpaUmoarjhl8dV9yLddk20bNDg4cCvZAqCrS3pf/nn6XoBd/oWk8xt60MVGHLp8baSp1nRiZuTaLDQBoj6txOsp4MbNdEhrxsAI972VEgexrXiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiLSgw8nmf8f1MgKMOR00gdgBTUVY+zhs+D5OQjoqnM=;
 b=A96B7PhF94/huifsRrgoQpmTRPwgkdyqCyQO9Y4BXE4ZWK/+8Tq+aQMFA1Y72WbourhUb9/uLVE/ZvFLb8F4croMHGk1zulvHrQD6jvCrCi3sWcI5U3+N5HNgQEnX8J/VfbFo9nnf/AMHYxSlLe6YIOyLCwB6AM9/pfnvkaEdlWgYMqpzcQgp0tzy7zX83r+zGiwFoK/9bXHr7picv5f5hureejMdVHqTAabzbPTsx/YIdqnd/+bfQvNbiIUJl9IFSivbVgN09je1OEgk+poOASqVnvgW2QveLfx7HXyAhr0ZSEnPQjR2oKRz1Hf6XRxqDnTrW8Aek76/Bw0alv9Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BN9PR11MB5273.namprd11.prod.outlook.com (2603:10b6:408:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 20:08:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 20:08:40 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 19 Dec 2025 12:08:38 -0800
To: John Groves <John@Groves.net>, David Hildenbrand <david@kernel.org>,
	"Oscar Salvador" <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
CC: John Groves <John@Groves.net>, John Groves <jgroves@micron.com>, "Darrick
 J . Wong" <djwong@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>, Balbir Singh <bsingharora@gmail.com>,
	Alistair Popple <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, Aravind Ramesh <arramesh@micron.com>, "Ajay
 Joshi" <ajayjoshi@micron.com>, John Groves <john@groves.net>
Message-ID: <6945b0c636de7_1cf51005e@dwillia2-mobl4.notmuch>
In-Reply-To: <20251219123717.39330-1-john@groves.net>
References: <20251219123717.39330-1-john@groves.net>
Subject: Re: [PATCH V2] mm/memremap: fix spurious large folio warning for
 FS-DAX
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BN9PR11MB5273:EE_
X-MS-Office365-Filtering-Correlation-Id: 9faf6412-ea2f-45c1-4b4d-08de3f3a66d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y0ZYRWliWU1iMWhVVmZRR0dsZmxIS2dBVTBFNlNHdEIwNWlZRnBxelBoNXFk?=
 =?utf-8?B?WStxTmF3aXM2VGFsb1JWZ3dOSmY0SnNDUGM0TStHa0ZrTmNoMDZnRjZhUE0y?=
 =?utf-8?B?Tjd0K3BhTmkvdUw3bmZkSTM2Ykxrc0FxRktFM2l5dGxYbUFjMVZ6VXdzaFdx?=
 =?utf-8?B?Ym84ZCtqQ1dUa0ppNWwyTm45bzB1MFd5ZE9mN3hzc3hoQzZMdXhMaTFLRWEr?=
 =?utf-8?B?eUlScXR6OWpLYm41NHdFOU5yOWJsRTcwTFRGNXova1Z4WFViLzFoNnkwbHdL?=
 =?utf-8?B?MkJvbUg4RUJleHAvMUw3RzdjeG1FTFpSbjR2UDB2MG0zVVNMV0tlTFVrSkRh?=
 =?utf-8?B?bXEzV2NwSnZBZGpOcmFmTGZSVmtYZyt3V0JrNGs1U1Avd3BFN3pWdGFtR09z?=
 =?utf-8?B?UFVraUViOVlhZnhTQUovYldFYkZ4WkNIcWFTN3FVWm9aTU1sdDBqK25nTmZi?=
 =?utf-8?B?OUNLZWNaMVZZRVpXakRHNDJmYWllVVNiSW03eG5wUitXeUQxaThacWxuUmRk?=
 =?utf-8?B?ajVUWUdLNzAvUkFGbXB1ZkdwOTVpMlA5QXR5VDNac1pFTElzTjkwWEtRTEo3?=
 =?utf-8?B?RFErMWM3cGFVOVI3b25SYk5Kd0tQb1Z2bFRWV3VaNi96SXZFZFhCK3lxNkFF?=
 =?utf-8?B?aVZSWlV5QWg0NUh1Ny9vZCswZlJyQW1WcG9GV21jTFFTQnQ1ZkpyejlETlY0?=
 =?utf-8?B?SENPam9kWk1CMmRpMG52dmFoSGJ2TWFBTXRlUXhRMEVSSlJhT1p1bHFkQXpa?=
 =?utf-8?B?QjEwNll2aFlGWXdqTXRaL0xiME1kOUdsMGZaZzJYSzN0K25UR0dTQitta2xx?=
 =?utf-8?B?M1ZLaHFQckNpWk45eHZ4ZFF6TlNxTnJBVlI1R3I2eG1Na0pLeEllMkliS1FM?=
 =?utf-8?B?dUF0T0p3Z3Zoa2dBeHRBUDNlQldYSm1MdWV4OWtBZ3VNR1crRlNYS0xqWXBQ?=
 =?utf-8?B?U3hCRjBPUm5HdklIUm9lcUswNlpLUDBBVEJyakQ5aXZxczFmOVlneDB4Q1Yx?=
 =?utf-8?B?MjZHRWVOSHVyRXJ6cWY2UHVoQlJzQmtnMWM2TXRoaHU2blJhZWVJYmhQQTQv?=
 =?utf-8?B?WFgzN2ZVSDFEalErKzlqOUtQOWxLcmdWRXJFL2VzMXp4OHBYZlN4T2FEaVBB?=
 =?utf-8?B?cjFXWDRYWjNvUlpOdW5TOFlxeE9DV2pkc1BpcGVkclAvSnNOYkpSNFFuY0FS?=
 =?utf-8?B?cWs1MklSTG5VVTFWWHNKZ1VZQmxEcXhTeVkrK2FqUUZSN1N5bG1JU2VtUkZJ?=
 =?utf-8?B?SWxBYWFZeTAyRkhrQVNwQUlpY2FWYmEvcUo4VHdpSmVhSlNIZVVKakRqeDJa?=
 =?utf-8?B?MFpOa1M5YXlCMnNwVk4zbyt6c1ltYVZtMFdNbW1WcGVXcFdFMlV0djVmU3pk?=
 =?utf-8?B?OFZhWWZ6MUNsdWZQd3BiMXZkeWNFY3MraEp1TmwrWU1jUE90ZXlUYnAvS3R5?=
 =?utf-8?B?bm1GQUo0bGdJcmpUb0p4ZElBdi9heHpjTUpaYnNteWgxOU85dmx1b2ZHN1g0?=
 =?utf-8?B?ZG4yS1RjUXVLK0ZyRTZORlErdzlLYzRFeGRReHkwS3VSYUVjdkNvWUg3c0VE?=
 =?utf-8?B?TWVnZk1Cd0dyZ2VIN0lubXRCY0V2cTMraU9GRzlRaVJjM0dDNERGYmErdWpX?=
 =?utf-8?B?azZmNURvUjZBMHp2aytNVkhlc1NrZUtxdlRWRDdaTXpCMFY1ci8vYUdscVk4?=
 =?utf-8?B?ZW9BeFNFakNyQTFmTWxjSHFhajRQN0FSS1dHR0p0cklpRXl1MCt4bmM3cUg3?=
 =?utf-8?B?cm4zaGlKVGtLd0R1bFF0Tk5zRnc3dW9vYzZOR3kxYzM0a05Ea0pxWktjYWM2?=
 =?utf-8?B?M0RQeFIzaGlPWU9IMkNwU1dlTE82SU5NNDNtSlBsUnhzSHpYMFlHVW9rdWVV?=
 =?utf-8?B?TGhuZER3M0o2WGZwaldRbFRqcHROcTRWeXB2TldUWmxOMGlPSkpVeExqeVJN?=
 =?utf-8?B?MkxEaDd1U1oybkhZVjAvckxtL2FCLzFCWngrU01xbG92ZTdsTFhQaEpuVWlH?=
 =?utf-8?B?VUVFTDZLa2FnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WC94MHpvdnM3VU9pYnZzNjdteDZ1VlY0dHZvQVRrUmRUMU9HbWNBZnYwMjhH?=
 =?utf-8?B?SlhYTnhxRThUM0Ewc0VtVE5lVnlRVGZuU0lsbEpWN25uM0ZwZXRxdHp5SWhW?=
 =?utf-8?B?Z1AwalVNVkNndUZVODBaV3BubkMvaVJaTSthZHRBQWVSTUl0NnQ5ZUVFVlNh?=
 =?utf-8?B?Q3BWRXZNNi9lNUJ1SFpQQkJ3YllmYTk2c25lT2gvWVZFU2dvQi9mZ0w3UUl2?=
 =?utf-8?B?bGJ2SjdrNVNKTk4yUUFxRzVhVy9sbGoyRlpnTWtKNTVtVTdySSt3UEZPZzNa?=
 =?utf-8?B?ZlNBQjlYZDJrMkNMdzM5YmdlaUdBWk5kenFJSEFHNHJrOUgralNCTlNTRzdk?=
 =?utf-8?B?aXRvYWI0MSs5WFlKUUhwbGZXdThSM2RtMzBSNy9Cb2ZDTldFWk9XYW9Jc3V4?=
 =?utf-8?B?d3EySlRVY3M0NlliTGMzYXA0UHI2eVRDYkNvMmE1NTM4WmFYQ3Rkai9DckRx?=
 =?utf-8?B?amJTY3I2Y21oREpiYnYyWkdoNEs5VWdrUWtBTTFRTkdIVU5VQncxYTlzV1Qr?=
 =?utf-8?B?QWtkM3lNY2REcDBMeVREZnJIMzU3cWYreDBMMHdhbDg4M3BLdlN4bWI3QTVU?=
 =?utf-8?B?QklROUZxSVNtTFhGVUJkNndZQnhRTzd1bDVwYWtVek84REQ1MFhlN05RMlNq?=
 =?utf-8?B?azAvU05pdVN1QkNreU5YTEt2OUQ5YTQvbTMrU3RGbmpLcEhRb1VnTHhtZHBK?=
 =?utf-8?B?UzJoY09nWXNNZ3IrQWhNYmJnaVVTQW5vRnRrUUlPVlNTUXB2TjlaYlBDaDlI?=
 =?utf-8?B?WElmRDljZ0RBUDFBbkt4d3JkUm1ObWh4MjN1Tld6NlJRcm04Q3E0S1Z3UlBJ?=
 =?utf-8?B?QmdKd0tnY25TOWhFTU5abzQxZTdoZktqUTZqazNXOWNxMVJoaThhMXVpaTRO?=
 =?utf-8?B?OHF1blZmVmRxQjVQc0FxNE14RzFJNkQxU1RIWi95RDNYL05IbXBzaGxVQUJw?=
 =?utf-8?B?R0ZraHE2WUpIRmFwV3FJM1kwUFhua3N5RzFhd01xcUpmeFhvZFNpbmxlWkda?=
 =?utf-8?B?SWx3UWZlNXlVcm9WV0wvaStCajJiWWpPYkdhV2ZHZWNBTWpUSEsyWnZWVEhP?=
 =?utf-8?B?Q0VrZTB3ckd6a0VVdlRlUStzWTA0MFl4OFlLU0VrSE95ZUF1M0JqRnJVbUFp?=
 =?utf-8?B?N3BTcTI4bWxHOHpxMkNscnpMUkhWKzdDQTZLdWF0bjdMVlNISnZlQUtIQ0Fi?=
 =?utf-8?B?eTNGN0NYblBhbW9ydWd0a3dGeDJsQXp0OXN0MWVBOU5EblhGelJ0ajJHMGZ1?=
 =?utf-8?B?cERrMFNqUzBoakVZcnZ3d2h3cGtFYkNnbHNxa2lHTkNHVGpqSDhZdCt6WVpY?=
 =?utf-8?B?ZTJNYlY2bmlSdmlyUDFWa3JMQU1GNEpJWkZBWVl4L2lEa3dwRjZZV2dsV2dZ?=
 =?utf-8?B?ZEhwcW9HOEFNNGo2QUJ4TE9PYXNSN3dDNEl1cnNmUGFkaWJPc3lUTzhZOWJ1?=
 =?utf-8?B?Q3UrRC9ybDU2cWVISTNKYVlWWlA5QzFSdURObGpVNU9qL05UNkJxUW5BUE03?=
 =?utf-8?B?QVFpbDQrdXRPVTgrM0lCOFVQQkFnVnFUMmFxVGlER1dwQnpaMmorZFlTa21u?=
 =?utf-8?B?OU5rQWFjWVUzWGhyZ0I3d1NvNWJaOHdobm9IdklhcUpZemhpbittWEMxanI4?=
 =?utf-8?B?bmFXUTdLZXdCbDVYaUU4a0dVNlVic3RWaW82d0FVZWFUV2w2Y1R3N1ZmOVZ3?=
 =?utf-8?B?ekxLK3dYVkREdnJHL1dqQUpWMzFBM2xRQ1Y3Skk5d3NRRGFKdzIxR0FFa2pa?=
 =?utf-8?B?Njhjc1VoVmhqYUd5UEdQR0MyTFRVQ2lwUVVWa3lXWFljMVdvVGMzQUNxbDFr?=
 =?utf-8?B?NUVCNXMzZzR5enlvS2UybEVDcnE1ZnpLVjZSa1BzZU9LS3RYSUFQWktwWnU0?=
 =?utf-8?B?eUdhcndPUjRDZk1GUkV3cFJHSkVLMFRXeU82SmdIblZKMVNpNm5FdWVwaHk4?=
 =?utf-8?B?WVdiNFBDNUd5MVpCOG1TWXZRNC90c1dPbTVPb1BnTkFET2VSemsrbmF2Q2ll?=
 =?utf-8?B?eXlsUVhXd1VwYWlCV0YyOXphTWx6TlhlWWNtZ3czd2Jsb3hFNFRnUXhibWFy?=
 =?utf-8?B?QW4vV2dWWVprQ2xnbnI2ZlcyaUpZZkNVTWF3Y09jblA0eTQyL1dMbmVJTVY2?=
 =?utf-8?B?OWdacEhNREM4d3kwaU9WdGZXRmsva2J0bkZBYUdqNkVOWTd3UkZlcFdyQTBp?=
 =?utf-8?B?b0xKb1hYT1lJOUg3ZUZFeW5aN1ZPNjVHcDU0RVVmWlplTHBiYVJEbVY2cmNl?=
 =?utf-8?B?Z0hoOEh4SFRBNUQ4N1lBbUpmcTViaFpkRGFPYUgyUzhtT1NFNmRkUmZERHhV?=
 =?utf-8?B?K0NURlhrV3ZnWjNyajNDV1ZmanZGTnRuVXE0Z0c2c2RCOG4wdzhtSG5GNGVh?=
 =?utf-8?Q?3xdp2ZNsOqZKf3z0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faf6412-ea2f-45c1-4b4d-08de3f3a66d2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 20:08:40.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IZmcLskM7rednTYYWnm/ykwKbne4GkVqYfod9RU+x2b7/ryuWXQNTnp69tGchL5cRiqS/7cYLaW2d6DH+C5nVl7IJSrZfDPFats2rrb7Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5273
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 55F3D4000B
X-Rspamd-Server: rspam10
X-Stat-Signature: zgu4i3pxzsjcmoatum74rq1nnh7wfyy3
X-HE-Tag: 1766174977-305747
X-HE-Meta: U2FsdGVkX19ae/wEb2XBGAGX2L4sNlDHToTNmlXQZACLUOTvY6QExkIlp8vfr6oFPRnD70Ud6hny4WHd954gRy4vQPpe1+BJ92g0M5iOUpiVRaIYUExG54AOkInf1Fx6G8Qq8EUqif4FcdG949dP5B0jD6EcduIkwsLtTduJ3TP7RmmGbpsEs25sKgQv3DPZndGgCXKDLls5Ia/Mk3WXFqrsnzy+qkOGD/HJ9Q32GU+x4i3umBV27tnfFB54Sni/4pUHpGWewnon4/NbXF6iivcuqDTtMJ27zY/WKHqVVjejkD9trYNV1owB6X/KIb+LiaOuxewq4UUd5TPWyf9E7Y7u0EGN8m/M+a0TxPsu7OzEpxPVQJIuKzDvDSgGnoO6dGti5aoVY+1NXB7Iux8g6whJ/Vv9ORqpansomvNY2ngLy5Ip8CQu+MFXiuOyls74U38PdBjky3EfqzujT86hPGak/VN3bo292PZnj7aHSS4zZq/MUV9pBguDA4hjZet2cNIMnxg84wyjUywIelydR+fJA23937mzml3uwN76Jr2pvdr81cNWhSx7WJ9VSyr7/YxjUxAGDFiFcxGgabqkgJpdwJDhvRhhSQyRT5vrPY2oJbJgwY7NfdQSIAKdB+nrdOyXV8U7GfN7rjfe4sOHUxp4lOt/RAcevYQRvqGaqxdmOdMH+nzw2sIzmiI5Hp5VZb3LXqLHERCIeafHHC5nuMPkaGQ/DMr/UL1ZsY6K2IeIVMkqQ5PUVVklL7almhzUHfD7WXn5qx9BrtWQ8Uo+IQcmZA0QOlB1p1QgqmXzB4TihCauxtTUzJQ0SacAc9QAz/zsSsClmaaPvpMejaesZsPozevwOdJMYZtWQ9n9EgVhy4P/WrBmbBuf5BKwpRdkRz/J3zKKYcSwcc6+IKvWU4xGILyWn2UxYaRv4BgIE2Vjlxr4L4GroWaNV+52rOjq1o3kRb4p2tO15JIRpSb
 q3q7sBEy
 gfoHc/OHzu+y89vMwMIQQ8YrkdquKtbvjlpfIRRN2N7NUVIglFspN0sMYIYEWNzavtDePQh9Pqr+h8hmeimJGqbkcZ0BuLiKURrDkCdUVDIC94Nk8auJbSMHoFKFdghgWLz+KWe3p3hZczYe12MBAw1hY5P1BLmkh72nM/XvYxeEpdCkSUDwwoxvPbvCqjARMuOlzq0hKX/Baceh/USxG1NK4aXrT9YWmKh4COrLVgtGmIc44cb0pWd48DeNvUYAoJa9QX14jFb6V3ixH/0a46tElFS4b5i7lpiVH6LSUdb99K5/zyNwp34z2zU7xNgR+kSs2vnuUWlb0+F61OBZyblyi0A8ilnYDQqAymnF/WtMaC0v+PQsI8nfKCBJCAaGX5rBXo6+4hEuIxcazej+QvcIGutU5kt8YB2DTw3GCEQFC4XNWQRrQW9U1isE1IvStvp4Q0I8iUZzKkQ6MhHrNjeO3DBUbmdXoGQanYT9AAuauzsFmwSeZYYkcwNKhqF0dPLceCzNeTiay+OXYlK576G1NsQubI9FvaYYwCpG5YzFu6jh3mISueVcw79zz++9IThf5rsRTtHt6HlDtwrsLgBCGhQJs13PNvWvi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Groves wrote:
[..]
> The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
> allowing FS-DAX to continue using PMD mappings without triggering false
> warnings.

As you note, this patch no longer exempts MEMORY_DEVICE_FS_DAX explicitly, it just
removes the bogus warning, so maybe Andrew can adjust this note on
applying?

> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: John Groves <john@groves.net>
> ---
> 
> Change since V1: Deleted the warning altogether, rather than exempting
> fs-dax.
> 
> === How to reproduce ===
> 
> A reproducer is available at:
> 
>     git clone https://github.com/jagalactic/dax-pmd-test.git
>     cd xfs-dax-test
>     make
>     sudo make test

Thanks John, outside of the fixup above, this looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Now, my first thoughts when seeing this were:

"ooh, I want that test in the regression suite"

...then:

"wait, that sounds exactly like the existing dax.sh test [1]"

[1]: https://github.com/pmem/ndctl/blob/main/test/dax.sh

Alison reports that indeed that existing test triggers the problem which
indicates some process problems to solve.

- Folks touching mm/memremap.c (and anything dax related) do not know
  about / run the regression tests.

- The bespoke nature of the dax testing environment needs some work to
  get it into a kselftest amenable flow, or otherwise need more
  automation to run those tests automatically upon seeing those files
  touched in linux-next so folks see breakage like this earlier.


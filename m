Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5939CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9FC08E0011; Tue, 21 Oct 2025 07:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AD08E0002; Tue, 21 Oct 2025 07:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F378E0011; Tue, 21 Oct 2025 07:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB5CA8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:30:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D0791A044B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:54 +0000 (UTC)
X-FDA: 84021904428.13.FB3284A
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5FB781C0015
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=MxRZ+ROm;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b="Lq/UBX80";
	spf=pass (imf21.hostedemail.com: domain of "prvs=382c0ee48=Johannes.Thumshirn@wdc.com" designates 68.232.143.124 as permitted sender) smtp.mailfrom="prvs=382c0ee48=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnegZYtqZ0uvDHbO+5L/yp5jL+q556Eb7mqV5dSowOI=;
	b=aN27F0RsSSDfDA6C2wCqF86+P2gfQ7xH2u8Fz12klL9laJERmwpXJK2xZwPoqBsMbszB4x
	NQnRBDo8Obzx+Be+4TpzUl5t7v1YWsK9/EHagmPjvKqDp6ipY6YFE+5kNWC/ublm2Dk4cb
	n5TmuJxWNJ3NqNO/xX+VHHBW2O329J0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=MxRZ+ROm;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b="Lq/UBX80";
	spf=pass (imf21.hostedemail.com: domain of "prvs=382c0ee48=Johannes.Thumshirn@wdc.com" designates 68.232.143.124 as permitted sender) smtp.mailfrom="prvs=382c0ee48=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761046250; a=rsa-sha256;
	cv=pass;
	b=8L1Z67WMxopbwM834UvnKJGRoGXfaKVUOjvU443DG/cYB3Suz6Q1s8vI+x1RTOUg6rCTt2
	fnjBFz2akBISFMWaH26hf4B1MOMxK3MHahhMBDIUJ+pqYF+xxOCxrKubmKuevbJOskTg7z
	4r13xWBOtIKpPaJ4VkyEPuMzE8M3eRI=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1761046250; x=1792582250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YnegZYtqZ0uvDHbO+5L/yp5jL+q556Eb7mqV5dSowOI=;
  b=MxRZ+ROmINbda8LWtvrhHN/cBXwn3loROL8WktMBZhTQXAKqfs0kHN1i
   JKsGRprcmPj6CzJj0SruJ6mmkVW6L9WrqGHJbf8mA1wKTSRVjqEaPivBP
   kIxzXdsoFmbs6qvCwR4ECcdMXAmOOBiYJ+c6vIzdxW8BaUxIm8/ZqBVeO
   IhIwKHwYsAytovN+m28cOk58C03DG9vf8HjQx4oipYbRRK/sHGJT0ZSpA
   uHwywlR6cSHDz037mlDqYLQjilz/z24PhNN3jBbhW5Q7tiKTP7PlOkZTV
   vMZwQpIiMxe0z3qwx+Y0y/DX7fsegx2bn8xOvA+oheLBch8D+yQdmlZKK
   w==;
X-CSE-ConnectionGUID: dNS4K/ZeQjOVl1mTr2Dr7g==
X-CSE-MsgGUID: VOStqeN2RBqikvCOz+b6uA==
X-IronPort-AV: E=Sophos;i="6.19,244,1754928000"; 
   d="scan'208";a="134868425"
Received: from mail-southcentralusazon11013054.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.54])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2025 19:30:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcVlFpq6/mZ/m3txzI1PoDe/BXaxqmFq8ovL5P1xTkzYxFoag3NUgJc0nae5Lmw9ugr/MsJGc5/lZKmldd/NkgoexTlPv5Rxkb9h0HNSkbq+eS+7LOU5la9B4LhNcE6fTNOItLkKSU9pudmgPi7scltrEKzEcfHpz7JtpJobfjCN99+NHIfANs96rIDD6pxhXXXN1MS9UXIlaeJyw7n1kpYfIIPCvm1CVW/OLIeJCPoy2up72lfRozVGTq5cOLXJQRW2x8DkG2wHq/AnCUj1dQtwTQl2ba+Illi5UgypYCipLZ4D+ldllMDlfzgK90DR5XrgIh8mUUIECq76blz76Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnegZYtqZ0uvDHbO+5L/yp5jL+q556Eb7mqV5dSowOI=;
 b=FJEABoxqk0W+gJ3A2KyqYuxSFK86cBGpJiFRpsYPV/wQJHra8nEmez4MRsEv+W48u4fkoieZhFNVzljkzYbqd/CgZxnEoNC5ZdWBl29ROl5AD36qlCQb46rBDOfNsKL/+yAsBt2IrpUOPuV+nnK8KqndrU/TsZFFRopQjfccOgibz7TyErXtqZGfkuZe7A3VZeq2W4Omz1IBV4AKTEcKacYQ8ERuKmpA4qfe0RrCQxOiDdzUSMbAgN2SPDo4WQIWqJuZrMA0utzzjqCgX7/uliAa5x4n4EA10hIUoE8KrNWSAfJJPP5GSBRFvA2iQQGlBjtkNq7GhLpB+0piRK40VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnegZYtqZ0uvDHbO+5L/yp5jL+q556Eb7mqV5dSowOI=;
 b=Lq/UBX80Nc/H9aRLFQV08yyvcyXIBllBm1SJRjJN5xsrLSArlKHAoGMOCl82ylONGwXoWH3NIFsI8S0rhTnkF6OK1FMZrtV9pplNyoy9JcpDB1Q5AZchR05xMLMeJfjy1ow/z2jywsHl/TrnfBK5VR6tiJv41Ck5jOvIcxEhfZs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CYYPR04MB9029.namprd04.prod.outlook.com (2603:10b6:930:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 11:30:44 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 11:30:44 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: WenRuo Qu <wqu@suse.com>, "hch@infradead.org" <hch@infradead.org>, Qu
 Wenruo <quwenruo.btrfs@gmx.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jack@suse.com"
	<jack@suse.com>
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Thread-Topic: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Thread-Index: AQHcQaLQW/VaEMy5706D8S0d134oFLTKzYWAgAEhjYCAAEu9AIAAB66AgAA2gwA=
Date: Tue, 21 Oct 2025 11:30:44 +0000
Message-ID: <25742d91-f82e-482e-8978-6ab2288569da@wdc.com>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
 <aPc6uLKJkavZ_SkM@infradead.org>
 <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
In-Reply-To: <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CYYPR04MB9029:EE_
x-ms-office365-filtering-correlation-id: 8d999fc1-80ae-4d34-5183-08de1095463b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|19092799006|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SENoNVlwZUVXdXA2cll3KzhOMGd3TnViVDg3czVDQVRLaENPek1ZRnV6aWdF?=
 =?utf-8?B?OHA0bEYycG45WW13NGZsUDQ0bzFOKzhVaEdMelE3VUNtTVZFRHJnQVBSL2dy?=
 =?utf-8?B?eEYrM3RKRm55a3VJbEZrNCtVMFRMWXN1aEZ3TGNGejZDRW5tejlkMHJEK3gr?=
 =?utf-8?B?OGtwYk0wNWhLSVpsL0Z5WXVkMytMSEVuYkJ6VU1iWS9jSnp3bkNZNVBpN0gx?=
 =?utf-8?B?cHVCVFYzNWZwbWoyNFZDUkVBa0ptMGVpVzNQNjlTR0xlZ3M4SlZ4aVJWMENX?=
 =?utf-8?B?L1dzcFR2M2RuZXB6QlM1RXpPRUpQY0pYT3ZrTjlYSEpCbmlrb3JyTEQ5MmJl?=
 =?utf-8?B?TUlDM05LZ215NEJZVG1uVER0a0NubUtzcThIMTB1WExIc1AvendSZ3FoOGRv?=
 =?utf-8?B?Nm1vekRtQjJ3dGlHSTJHOWtITEJyVkhtNWkxR2RscERIWDlnSlZxU0FpRkoy?=
 =?utf-8?B?ZGFmcmtuZDJXQ24zcTVrZGU4SzhlUWhMTEVqOGExbXd2ZHQ3U0hzNEJQb092?=
 =?utf-8?B?U0N0SklEdFhudldNM2xISW5iK3V3b3lSck45OEVtV2h1ODRNSEc1RkRjSlYz?=
 =?utf-8?B?VEUvWmFLeDVVUUhTMTdyUnJOZVV1dnl2TU5PZUJBV0JBQTJBTkZITWN3N0cr?=
 =?utf-8?B?ZDEwTWZ0aHJtSFdlY0doSXRjRTBNK3IyUTJiM2c2dms3eHlxak1uVXlTNC9h?=
 =?utf-8?B?NDdTSHVHYy9jbG5CeVBobmZlUjc4MWZlT20xaVRwdzBPVTNjNXRLam4vY0xS?=
 =?utf-8?B?WjI3U3NWQ0Q3TzIwRStPa1JqaWNWRE5PdnhRQXpEUXE1WS8yQm1icVRJU3JK?=
 =?utf-8?B?UnFBZVBoQWpqOHpaK3lsbDRRSmFXR1g2NlVVeGZndmVDekh0QnFBUW1LSEU1?=
 =?utf-8?B?dmdNSHM1SG8yREE2VXROTXlpaUxlYUJ0blhqQmhQN3RlMnhJc2p0b0JQRXFN?=
 =?utf-8?B?NWhKZEF0YjFNYngrR3BaRTdyUlBLYlgvQ2NRWXpFV3YzQS9OSnEvSjlwQWM1?=
 =?utf-8?B?U3dsSWRTdUxleDlwb3F4RXo4Vk1oa0tBNEVpVllXV0E5c3hHL3ZZdWpOeTJO?=
 =?utf-8?B?aG9JQlZqdTVtNXh6Ynlscmt2LzNqQWdWODNHQVJiUXlRN2ZucUxoa1NOaGpE?=
 =?utf-8?B?ZVpkZWdJM1VBeGFXS3h5WUNGektTTDZ0WTFKL3lnTTFoYmd2QTBJZ3JvR3JB?=
 =?utf-8?B?M2FiTEhvalZTanlhSm1QMDJMZE1qZmduQUJlSkVQbCtxMzZPQmtKUnZXVzZo?=
 =?utf-8?B?RXVzeVZhcElaYzdNTnB1bVk5bFcxYjE3OHBtZnF3a1JlNFZPZGdqTHRMZTFT?=
 =?utf-8?B?U2orY1RDUDBVaFVocTJMRmdVSk5OMU1kNVpPT3l2SnBzZ3I0S2lXcThtWi9D?=
 =?utf-8?B?MWFNVjdvcUlHdGZBU0ZpVVltOUtDWnc4YWVxaHhMUmxMMFJHMkp0SjE0UnIr?=
 =?utf-8?B?eTlzY2sxSTJXa2VmOU5neHY5QUFrU0R4SUJHU29QcTFvWGlFTWlSVmRRTDBr?=
 =?utf-8?B?UjA0QnR2SjVnZk85VXNzZFlNNXhMcjU3T3BwdkUyRkdROUcva3BTWEZBdUg4?=
 =?utf-8?B?WmV1MVVYSHFHZTNsODgvK2xTV29kbE9DUXV2ZXNRQ3pBeTU0WW9tY3Z1V0Y2?=
 =?utf-8?B?QzFuWjRGKzA5Y2FOZVNkMVViNUg4S1U3WURCV2NjZ25uOFNVSlJGLzJIZ3Vp?=
 =?utf-8?B?cWNCTGFGdXcxSHhHZmlIQjVsSStOWTNGZVlEVWJnd2Y0bGpEczA0TE0xbHlV?=
 =?utf-8?B?UHQ2ZFQ3WG5RdnovZkZLMFFKdUlucUF5L01KaVEvSlpLODVvUVVDL1dDRDZu?=
 =?utf-8?B?bHJTRXd1dm5xQkdRQWZTMWhlckxFTU9mVXpucThhbzlibjhMZEtLWlFRTGNS?=
 =?utf-8?B?bmR1YjcyeTJ2bkZ6Tk9hZTRod0J6SzdYZ2Z6bnRpaXBHWU5UbDJ5YmxYM1N5?=
 =?utf-8?B?Q1hSUEJtUVdMdGdZUG80MElWbnNOblhsRWVtWTU5T0NNMkNVLzhQcmlzaHRx?=
 =?utf-8?B?UkkveHZVd2Fkc0F0b1pJSDZQYVIwKzRpVkd3bkxETG9idzBHc2pWZ3NOald6?=
 =?utf-8?Q?IbuU2Z?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(19092799006)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cnNoclhOM1hjZW9yaUpsQ0taUnpJeGlEYXJCUFBCVE5hL0ZZYWx6UEg1RVVo?=
 =?utf-8?B?UStmYlFvV0NKbFlXRCs3WExpYkhKa213UGEwSFlaT2NMZ1o2S1BEWUFYS0Y3?=
 =?utf-8?B?REtOZGYrN0RFTW5ZbE1qTkZkUkp1eGxaK25HTHpBeXdzODIwU0Z0UXUrZGJC?=
 =?utf-8?B?K0NaTU9pU2c4TjlPWW5DWmxPcDdtT3lzM3pnY0YrMmFzUTJRRHM3R1JlVW1X?=
 =?utf-8?B?NE5jQ1B5ZVJmMjZ1L3R4RVA5YnRGQVRobitLWHpjTUtlOFJ1cDlTNHlKMmFG?=
 =?utf-8?B?Nk1aOGdYam9zanR4THJkbU9aVXVFeHVxc01qYWtNQmJoT2dVOWNEOGpqdFcx?=
 =?utf-8?B?cXN6YWxxRDBHd2pMenJpV29LVEdwTTJVdW13TVBpd2c0SVFSczJNNnZTTXV5?=
 =?utf-8?B?QWVBTmNLWFFsMEdOMTd6bG5qUDNGVGxKOVZIeVFGL1pmdmNrYXYrM3kvU29D?=
 =?utf-8?B?Vmd2aFdqamtCSUNwcVJCLy9GN1JVQUZ0SFFWVW5YcTlHbFlZM29Vc05vUHVH?=
 =?utf-8?B?MDZUamFSN2NpN0dEMGgwYjBrUmhWRWZWLzYvQXE1UnZPR0IrdW5wOTNpZEVQ?=
 =?utf-8?B?TjJhQWhOR1RXdldHVE9MaWhrYWc5c09hamw1VGhSS2lWVGZUS1Y4MzlxbXFk?=
 =?utf-8?B?dEk3WU53cjk2aEtENkplQ1dpaDdJSmxmQUIxS2ppY0w0WnhjVjhtU0JqdVV2?=
 =?utf-8?B?cHFHK21tN0QzRkJZY2JCRDU3YlVVeHpLdHZ1eU5XWUpVMGtEenc0UzRPakVY?=
 =?utf-8?B?L0h6b2hUQjZ5VWZKbWYrdnRtYjYzd1l3L3YvYnZnb1JmVVBNc044ckpLbE1M?=
 =?utf-8?B?NXdIL0xHR3dzRjRtd2R0K21zMERza2FUQkpyaXlDNjh4RjdsR053aDJ1UE5J?=
 =?utf-8?B?RVhzVStzTEtvZzNFajRqUlNOSGpYT1lHZkVXWlhCdFBiU1RTOUJJb2dnWFBC?=
 =?utf-8?B?T1FoZnRoM0JLeUlMRGx6dTNVb0pQZHBVMHRiSERYOERYVGJ5VlpCRkJhcWE4?=
 =?utf-8?B?MXVIeGRwODJoSDhHMW8xL2FkelpReTdhSWdqL2xpMCtzWTRqeUVSRVNEQWFP?=
 =?utf-8?B?YnRFN2k3em1OK3JkaEd5SkxMSkE3Y0VUV1EyZHlRdXRTelRYS3ZZdE5OQTJv?=
 =?utf-8?B?OVB5MDdkcVU0MkZjeVdIUzlqdlZNbUdNTVVRTTQxa1VMSWJkeUxBWVBnQmtt?=
 =?utf-8?B?dldhTjBzUGllZ2NucGJ4Y2xNSk9pVVFUdEo3YmxSbSt1T2VGLzJyU0tOQ1M3?=
 =?utf-8?B?VjFiYXl4WHl1T1dGMGg1b3gxZjVNekRnbStyVC9ONkFmVTE0ZVNOYTREdDJv?=
 =?utf-8?B?VnZPNXAwbXdrbWozM1c0RTNhMkhJZXpTWXJrck0yK3NJQjc0VHozNDZ1Y2U3?=
 =?utf-8?B?cGk4SDBLNzhXUUlhdFRoV2xEc0U2L1A1ZFdLU1N5bElKS2FrRCt5TU5NdHRY?=
 =?utf-8?B?a3NYbS9hT05OWjNmdnlvL2phWENKTzFHLzQ4QXVPSDhzUzduYlhtMW1QaDRa?=
 =?utf-8?B?YXBYYXRIRWlGSTdkdkNEdVN1VWs2eWFyODF6cTI1OWhRaVY1bmpFRDIrcVRh?=
 =?utf-8?B?QUpOZitidlhGZmVXbFFFT0l0L3F3ZHU2VVZNdjN0MzBSWTBtdUMrTURhOUUv?=
 =?utf-8?B?UlFaNERuY0NxQjZ2SDg2RU1Rc2VPbERpNTZ3eERlVFY1UmVjME5wQ3E2QUxM?=
 =?utf-8?B?TTBvUGF0RWl2ZEprWUNiQS9TVEZiSEwybmdib21FcXZmYUx4SDZvVXllNVh1?=
 =?utf-8?B?MlB2QVlSOGlzV1dKVkp3Ri9BMnFFVGpVeGRQNVNMV0FmVE5TbEtaWDBleTdD?=
 =?utf-8?B?dmtFQityR0VvRHdsVEVsWk0vdUpQWHNTdUpTVmNVVk13UTJJWW92dlYvNzVI?=
 =?utf-8?B?UmU1RHVvRVdoZUMvNUhHYVdiS2Y3cmNKUDM2UHpRU3hiVEUxUUJtZlg3SnBU?=
 =?utf-8?B?VGJBdGNUdThrb01ITXhYczB6VVdiTW9MYWlHMHVldGo3KzJCck1IeEtDczVR?=
 =?utf-8?B?N09ldkJpcmkrWjZxOGJEdS9iWTRteGFKRHQ4SVJsVmRWanNRb2RleUo3MDRw?=
 =?utf-8?B?YnUwWi8wVG9GeUNIcWNJZWxJUm5MRytrRy9NeVJyakdzSU44aFJrMlNzN3N2?=
 =?utf-8?B?Z3hObGsvQkJFNGpaTFpzNzg2YXVwRXVzMHpMZmJaa25xdWYrSmc5MW5WNjF6?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6F5D70BCEA18246A89BCAA4A52F850D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VCP9LnPkCpQ2RQeLKuUAVS8uaQxB52YZgCKgO2tqeD7ArX76uceyHIsnfR57UFwVu6h1B/veGg1oVIk3+7NKveVdNrMrl59uCMf/+MCFFhsJy0fjytIk7T+7OsQZqP05/Dc+BET+/Gl2+GxnEKfSXdtGoFP0Zt8hC2VAkNAfTIOcxOgEgXemKOEiEhLUW3M6rQEnTP9Chv7WVBlLTqPwuU8pLp5wEQTKzMMr0tk6Nm7hnJlpCAKJdL5YxGDGsN9Ys+pLL4cbD/VzxT5DOj9iwvkjV6/gqW1nN8QlEYV3xdAEYd4iPDdl5LDU8kkfI52Zr7UVFAyTrP530lQqsILg41phps2WdT4zzmbEZwsOik3lZVJ0J+zyF0RTT7LjVM2sirDDpjNHZ5jj2iJSv3MDGKvj2+bafoFViElHYSC3JJ9woNc8VOiDRthGj6HVQL+WVf/jDH3871uksT96vexFPJeJTYmQthcXsRI6lYLfcbABIePAb3+UOm6eYFtH6vAsser7mt9CVsHkvnfxlH3bj5sIdUOFETZknaTr7e71Kr1iKfiWh+QKSjeOkBzO4bDvdhP7lDXL2QnXT95XMq+SCfC41TcaGWNpReaduzIoMaHH8BIqwKFlBsbxOKPDM7/t
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d999fc1-80ae-4d34-5183-08de1095463b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 11:30:44.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n84j5vRYUwIaw2cdBXR2ctZgygWb5J+rOIVIzFf2sNq5mI79BixmhWBveO6hmOsZtxZqUrWtcPkc26rano/wT3BLyFOFXj6EiGUVWzkfE7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB9029
X-Rspamd-Queue-Id: 5FB781C0015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6tqd598jjqwkspeq7657cqri166bhi9f
X-HE-Tag: 1761046250-746354
X-HE-Meta: U2FsdGVkX19gcszjJA9wu3LrgWxz34ChW2bKDEByMJqUFZzZ8zNxPsSADZFW8k/cH6J9QZECAxixrYLkR8x7eKZaq55BDomRYjbUFd1OSbmhAStrK0bPo3d7g0RBfnc94jDA+bPoAcm+0yYS0nZJZDNSbzy8j9Fk0ygdAygV4fw1x3rssNgp0BS5RUA5hKIlsZDcjVDSLOFc3WMY+9bDWxSX1cjCBU984f02PY/MAfISTdavL4w91g7Kii0fVMRAsjclOuSXeJIgoGJRbul2Hey7/mSOGejI0ODMX464POAKI/vbDNLcSVShBvtY+nWvqQLxnBuZ2Cr9j+g6JIwtJj79oQdMuESltGngcWvuJKqLBZuVsOfVwE8lMo0rK80qcF4j/ijEpCo2dO3Qa0DU4HGuHyz/6YwMb5OXzXXK2Tx1WjS/yAI5+GX9FtEbG/98pXebJXhsw3l4Irx8ZLDfYIkO1fGTuBScilz76wXChsIkqYodiaUqNKk8WzCpB0zRLBH4oBXBlPt03BGWGWAhu2MK8fdIeRtSWkN4S1W52OMVL9tRiBxX3NetidGRaXjcWDFhR1zpufV5f1x9jAE36Cx1JxtosNCLcAAp04ujm3T90EuJcN1RpM1f4CEAorAZwbjugmIiJJTTerij7vWFUNoDtm4AmhyPzKczRPNf8upJxWUDXCiXknkNu5wHEtDpTJDqmYpXjWWs5EaEwBEDIzUFn5ZQ59DbssGNVpogzx7h1UiP6gyFicYhQReTyBZ2ZoNzaw1TThJNGDPnvnGEt35l9lAf+jD0qsNgfWyZFjTHYxvRCZaRly4r9tiGoqgWnsaSDLjG5po5BAenIJhbh+z99OzaBY8A4hrcOnRcNsEp+6UFa/BizgHGamjiSiwOKWseQ2bbr4m7G5N9wdV3XGOHnlC22tQ1LSIl1EYr6czPELKUs/1iWyx8YXGgDBNNcw74WJbpPpNj382u+ML
 daKFsZ44
 txL23VkF7MbuZYcSPJIG2nZBobZRGCJW9wGSHjFxsq8ia5yYf4kCiEfTNuwHEVGr0ybvNLCy9QLSl5NR/gORhwa5+qhWVxNnxofY9vGdlcYzk2eGrFXqkKGShD1dJ1ML1pgMAq5FoguCvhW30iuCo3MSygzQG/1uEYNBTkLmVqOCsVMWYhGHDlSGN1PbCozx+aSBWlDoIekIiLlQzZzdJlDdiCJrczvwmXjHdT6x/BqyFCyAEE0gfj53ykwPO4IpbsoURECU9wPyoc8vFfSSGTcSvnLR8LKE31tDcKjVlVB7NtDAGF5jNGoBrSzbPGZuMFW5lPORYQbb2aRMlsI6gQ7NDjW9NxquKEc5Zmp388iSvc0f5CE/C8mPB6SE6R5QRpFiuUfhwK57QWNXjoYn7TPwocqU39pPTzwFKY6pXUW0bcbQTRgf1Wh/J95SPUGJJ0XVhQGhh84Y73JLsO3XTdKC8a0QkGQBS9n4qDcphwT6mUQQKXvF3NEL/h+8MDnL0ssC+yC6Phb4Je35oVtkgztp+vUJBnqG+GKAWQpieveUaFDUc9U3OH2CRMuSe0wwoU0uy7WCCrSNg0d5g6qJRelHtYlf3bAkXbx1ZbCOznl2XP2SbWJdRqz0X5R5TOTT64bnbR5sveY15dej4z19UAAax8uY0F4nCImCQH9ayT6m2fa7kIiOUEZK0SU9Fv1IvJ9nLaSmdqTQdaaPE1DHgBifeqNrzXYhSkCnAJ1vFn3CUhnX8HAox7hO/25Hjt2qclzuScl/TpDTBzvTiTaBX+1J0wlZOkyZrh7qG999d37VbbGHKEGsiAIqu0Z89nJTpxwUPUo5v3MjzBx56Go8xpCjIYaU8ElAgjL6ap1+RAgsCkgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gMTAvMjEvMjUgMTA6MTUgQU0sIFF1IFdlbnJ1byB3cm90ZToNCj4NCj4g5ZyoIDIwMjUvMTAv
MjEgMTg6MTgsIENocmlzdG9waCBIZWxsd2lnIOWGmemBkzoNCj4+IE9uIFR1ZSwgT2N0IDIxLCAy
MDI1IGF0IDAxOjQ3OjAzUE0gKzEwMzAsIFF1IFdlbnJ1byB3cm90ZToNCj4+PiBPZmYtdG9waWMg
YSBsaXR0bGUsIG1pbmQgdG8gc2hhcmUgdGhlIHBlcmZvcm1hbmNlIGRyb3Agd2l0aCBQSSBlbmFi
bGVkIG9uDQo+Pj4gWEZTPw0KPj4gSWYgdGhlIGJhbmR3aXRoIG9mIHRoZSBTU0RzIGdldCBjbG9z
ZSBvciBleGNlZWRzIHRoZSBEUkFNIGJhbmR3aXRoDQo+PiBidWZmZXJlZCBJL08gY2FuIGJlIDUw
JSBvciBsZXNzIG9mIHRoZSBkaXJlY3QgSS9PIHBlcmZvcm1hbmNlLg0KPiBJbiBteSBjYXNlLCB0
aGUgRFJBTSBpcyB3YXkgZmFzdGVyIHRoYW4gdGhlIFNTRCAodGVucyBvZiBHaUIvcyB2cyBsZXNz
DQo+IHRoYW4gNUdpQi9zKS4NCj4NCj4+PiBXaXRoIHRoaXMgcGF0Y2ggSSdtIGFibGUgdG8gZW5h
YmxlIGRpcmVjdCBJTyBmb3IgaW5vZGVzIHdpdGggY2hlY2tzdW1zLg0KPj4+IEkgdGhvdWdodCBp
dCB3b3VsZCBlYXNpbHkgaW1wcm92ZSB0aGUgcGVyZm9ybWFuY2UsIGJ1dCB0aGUgdHJ1dGggaXMs
IGl0J3MNCj4+PiBub3QgdGhhdCBkaWZmZXJlbnQgZnJvbSBidWZmZXJlZCBJTyBmYWxsIGJhY2su
DQo+PiBUaGF0J3MgYmVjYXVzZSB5b3Ugc3RpbGwgY29weSBkYXRhLg0KPiBFbmFibGluZyB0aGUg
ZXh0cmEgY29weSBmb3IgZGlyZWN0IElPIG9ubHkgZHJvcHMgYXJvdW5kIDE1fjIwJQ0KPiBwZXJm
b3JtYW5jZSwgYnV0IHRoYXQncyBvbiBubyBjc3VtIGNhc2UuDQo+DQo+IFNvIGZhciB0aGUgY2Fs
Y3VsYXRpb24gbWF0Y2hlcyB5b3VyIGVzdGltYXRpb24sIGJ1dC4uLg0KPg0KPj4+IFNvIEkgc3Rh
cnQgd29uZGVyaW5nIGlmIGl0J3MgdGhlIGNoZWNrc3VtIGl0c2VsZiBjYXVzaW5nIHRoZSBtaXNl
cmFibGUNCj4+PiBwZXJmb3JtYW5jZSBudW1iZXJzLg0KPj4gT25seSBpbmRpcmVjdGx5IGJ5IHRv
dWNoaW5nIGFsbCB0aGUgY2FjaGVsaW5lcy4gIEJ1dCBvbmNlIHlvdSBjb3B5IHlvdQ0KPj4gdG91
Y2ggdGhlbSBhZ2Fpbi4gIEVzcGVjaWFsbHkgaWYgbm90IGRvbmUgaW4gc21hbGwgY2h1bmtzLg0K
PiBBcyBsb25nIGFzIEkgZW5hYmxlIGNoZWNrc3VtIHZlcmlmaWNhdGlvbiwgZXZlbiB3aXRoIHRo
ZSBib3VuY2luZyBwYWdlDQo+IGRpcmVjdCBJTywgdGhlIHJlc3VsdCBpcyBub3QgYW55IGJldHRl
ciB0aGFuIGJ1ZmZlcmVkIElPIGZhbGxiYWNrLCBhbGwNCj4gYXJvdW5kIDEwJSAobm90IGJ5IDEw
JSwgYXQgMTAlKSBvZiB0aGUgZGlyZWN0IElPIHNwZWVkIChubyBtYXR0ZXINCj4gYm91bmNpbmcg
b3Igbm90KS4NCj4NCj4gTWF5YmUgSSBuZWVkIHRvIGNoZWNrIGlmIHRoZSBwcm9wZXIgaGFyZHdh
cmUgYWNjZWxlcmF0ZWQgQ1JDMzIgaXMNCj4gdXRpbGl6ZWQuLi4NCg0KDQpZb3UgY291bGQgYWxz
byBoYWNrIGluIGEgTlVMTC1jc3VtIGZvciB0ZXN0aW5nLiBTb21ldGhpbmcgdGhhdCB3cml0ZXMg
YSANCmZpeGVkIHZhbHVlIGV2ZXJ5IHRpbWUuIFRoaXMgd291bGQgdGhlbiBydWxlIG91dCBhbGwg
dGhlIGNvc3Qgb2YgdGhlIA0KY3N1bSBnZW5lcmF0aW9uIGFuZCBvbmx5IHRlc3QgdGhlIGFmZmVj
dGVkIElPIHBhdGhzLg0KDQo=


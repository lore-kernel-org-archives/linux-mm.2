Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDB2C87FDA
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 00:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993296B00A1; Fri,  8 Aug 2025 20:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B5E6B00A2; Fri,  8 Aug 2025 20:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832976B00A3; Fri,  8 Aug 2025 20:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 725116B00A1
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:03:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1665C0581
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:03:22 +0000 (UTC)
X-FDA: 83755269444.20.81FE668
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2378D100007
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:03:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nCTEUTZp;
	spf=pass (imf05.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754697799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB+2ZORq8pKrOcNvrTtvnopVSUXfgHTZx3gL2BoEPOk=;
	b=Ey7iMhsdTdCX6jOVeflSUQTano7cYlfKGQgib6EV6qoshIRsG5Vd7VK8OIUSL3HV1KOl6+
	R0Ek1SVMYQBTdIEN3AhB5dR6qd18DO0W8EOVAcpyQ6R/ZKZim+s6vpPe7Y6j1BRqVn7dHK
	H1CWi+nHGCu5dLydMbHMSWC3SVBKEyo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nCTEUTZp;
	spf=pass (imf05.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754697799; a=rsa-sha256;
	cv=pass;
	b=DF6XTagmJwJE+0th3tPINGBHiLt1a2L4VvwrPMUmLWHdVkJwp/ixgnW/xZGmo9+ogTCmFy
	x3iGNMQsbsLPBSY5rUQrACX9JkQ0QceuJvZoH3YAY393ZgBu1z9ZkNAcvVra9QAfSazUne
	owgHIfHUYRaF1b+yHkPF9HjyMGdir+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754697798; x=1786233798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CB+2ZORq8pKrOcNvrTtvnopVSUXfgHTZx3gL2BoEPOk=;
  b=nCTEUTZpL4n7H/GOZsRfXlBLfhmBUrK2uEA+2NTKwWEiQjtot8vSeYrd
   asg64fLDIBBLfV/g4MTD2nMqxFi+eME2OimqqPMkOS5g+PT92U2S1uQaM
   FBrRiKCcSXeHUswDfQTUCfF08txsOuYUxMmbviyTRV5qcMWbJSc6kb3Ow
   0a/L3XvkrCZT6ybqs+D/alCqCvWXyulSzBpXnWd3IKMyqXRFIyvL0pz0w
   5Q6PHAA0qBi4OsvOhHu9LPpiNZAHPsN2eCwWHFaV7tclzkklxoNPH8cwx
   z6Q/sD8xUzf5gA+ilkSvKeLmwgATCo0ZKhh0Emywu7FfhriIIQ0qTsxav
   Q==;
X-CSE-ConnectionGUID: HJf8HW/zR+aPzqLqe+wqRw==
X-CSE-MsgGUID: +m5fhUpETymiZgdqYKYvEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="56252289"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="56252289"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 17:03:17 -0700
X-CSE-ConnectionGUID: 5ChJI/VgR0+vzYqc5l4EMg==
X-CSE-MsgGUID: fFWg1FagSBaVx5qBlYmdMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165337184"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 17:03:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 17:03:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 17:03:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 8 Aug 2025 17:03:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2/B8t5RVr/oxvygqUSXyNOTXCUJ4GtCLcAtDv2C34JrzbZSMAHwPM9v204XZbfXu6ZB9GKJEIX9wA4Jhlu068O3t6WhnVJ4pZlqaX1dqrrkm480NA5PPX2rbicaZ39372nWmMk6iV+Qey58MwWzanjeGj0Pd+1MF2H9bTb6AeZmhiStLa30bhjY2XAp7+eiEHLYTu2vqHZ4MPIiALxnKje2Fh/XXzkjFKESix1IaCg5NBjhxD/Y65tJS/Yb+zA453NDhWs599+y309sFNJraxNkEQ2uviTiRuOj41BXgj3usS8AKfECFwkMuANdeoo7H6T7CKN1RhQah4Rhys4veA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CB+2ZORq8pKrOcNvrTtvnopVSUXfgHTZx3gL2BoEPOk=;
 b=oNOLUBig0eujrhS9IJvCDi/nIgqdT8Urrzu7QISQh5bDr7rMkBn+lQcEQjE+V0TlrCF7/fN1cufA9oGMIYlvrZ9p0WdWCjmoqLPzCs84vo+DlaLIKHbYyxJy3kXtqslwI/FbM03dk47NivfbQ0cknJgUX+OXN78Bu5ojxrdpCcOKLDag9aEahR1w1q5AF2wVmhyTTH16CZ33COdX1W6Dl+Cl6fvpquRCe+AN8FoCWH9fg5/3ifA3tPb0AuthngBqUKbGtDK01z1muIs//S36JrfgO6k0oQd/kVMGKYsx/Ss9552YcmDb9miIMoIs8uf6d9INdTzYu+5idZK6HDsjNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by IA3PR11MB8919.namprd11.prod.outlook.com (2603:10b6:208:576::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Sat, 9 Aug
 2025 00:03:09 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 00:03:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAAB9sA=
Date: Sat, 9 Aug 2025 00:03:08 +0000
Message-ID: <PH7PR11MB8121ABFBC6FFE836099B1CF0C92EA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
In-Reply-To: <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|IA3PR11MB8919:EE_
x-ms-office365-filtering-correlation-id: 7097374a-0ded-415c-78ee-08ddd6d81f94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVUvZlN0d1JQYmkrYWd3UzFLV0lPSEtpTlJjWTJBcThNczVHK2xSTS9Qd0VU?=
 =?utf-8?B?WHUyeGxRdEV3bkh2VkJRd0k5V1NFU21DdjdtWElDbDR0YzVGd1NUZHZkZDd4?=
 =?utf-8?B?bXAwWW9KVlhjVnBZQXJzZWRsOG55SlIwNjgxb1Z4UWsvUmVBdXl4SUsyZmhx?=
 =?utf-8?B?SHZTbmtiYW04czU3Y3kvazlwRm5CTlZrU3pBMzdrZU5lNktqZW1OeExpQmtn?=
 =?utf-8?B?THdtNzBmM2pseDZzUTZnZEZpSU1Bc0s3eEQvbi9IV0NQQkRCMVlyTUhYemNx?=
 =?utf-8?B?ZDNhbmJKYTJWVkRjazJMMEhXczFEOEJ2eVlzb1Z1VitISXU3d2VjU3VTaWZl?=
 =?utf-8?B?UVNtZVZIalg4THhKSis3d3Vjc0tYdzl2M3daTnkxN1c5UlNGcnUzalExSE5q?=
 =?utf-8?B?RlJDMEE0Y1kvaTRqM1g3RDhISHRiKzFVTUhiYnNWR2V3WldrS1pZNkk5cW5K?=
 =?utf-8?B?eFRGUlBZdkhFMmFneno1czVVWWNUTzRpUUdOeVB6dEhURy92YXNlSnkrdHBa?=
 =?utf-8?B?dWd4QnQrYkt5ZjIrbmUwRkFhSmJVbENzdXV1SmxFcktzbGlRYUs4c3BLQ0Rn?=
 =?utf-8?B?OVBoeFZ4c3ovQ3R1aVl4bXNsUGtrc3kvYlJMeXF0bnRFTmFZRUdtdXpPRTlu?=
 =?utf-8?B?UWlPdTRLNzZHMXRvQ2hUSmltcUhwekJvNzJZY09ldkFLTlE2SUI0V0dlL0Z5?=
 =?utf-8?B?VnF4S1NONUJWaklrZC85OTJndTVnUEV3cytNMW5zUk1lVitjTGNPUjlQT1Y4?=
 =?utf-8?B?VjVMLzJPdXZKTkFXem81R2x2YUVZK3Z3NnlhYzlqNHJVS3ZVZjFNMEZtMG5B?=
 =?utf-8?B?NEprTkx0UUxkM1RpVHNjcW1RTmF3V3ZweFh0MVVMcjhwRDB5MVllZkloaTFp?=
 =?utf-8?B?OXpnb0U3Ri8yU3JYR0ZLTVlqTGlvdm1CMTQzc1UwcUFDMTUwU1J5QjdHMSts?=
 =?utf-8?B?S2tEN1lSM3pPNkYyeWcwRStUM2tzb3RDUVl4MkJMNERjRll0ZWxuVHZxcG9V?=
 =?utf-8?B?MzJCVGxVWjJHSysvb3BsUFhLcVhFeDFyK0NtQ3hTSFY4NXFLd0F1R2QvS0tr?=
 =?utf-8?B?ekJqdHlQWERFOVNWVmVjdWtuZG1KSVdlam5lRVg0NmlITDRVQVlkOGZJWjhF?=
 =?utf-8?B?VjFOaWwybGd5b0Y4QTZ6VnBhekwwRldiNWYxRGowZnVJZmtSUVRqajZtaDQ1?=
 =?utf-8?B?ZXZYVnlrRTFtL2c2NlQ3MmdCRHpTdXNscXNqN3FVdkV6d3dwV1RmMUNBU2NK?=
 =?utf-8?B?aFZWYm9mMHRXdmxHL0MzL2U2cGNaSWVvbWNjY1dwSTIwRjRhUFE1M0R0UUNr?=
 =?utf-8?B?anFhdUlhS3NzTkd4MFBqUjFFTlplKzh1RkJ3UGtwWU1KUVNzSUJIM2NuUW1F?=
 =?utf-8?B?cVNQbUh4QXlxS2twM0JtenpTZVBJUWloQmdZcUtEL2JjV1JBNzI2eFFWY1VY?=
 =?utf-8?B?aVNseWVyQjJlUW9sYTJ1Wmo0Q0lUbW5oblhHTkJrVXRLTEFZWFNMRnk4UTFE?=
 =?utf-8?B?aHBYcjhkSGhQczlacFMwQ2hiSXpXekt5M1dlL2Y5dWpCb0dvTzdXUlVZL1Nj?=
 =?utf-8?B?dkx6QllMbUM0UjZ3MHpnVkRaano5MzFKYXJnS0VSRkdkSkFJZlZHMXEyNE0v?=
 =?utf-8?B?TG8yd0tnYktMeUxRY1lQdGFtbG9pM0tIVTczNUc1SXhJYzEwNUxlcENDVUda?=
 =?utf-8?B?czdic0ZOdzBEejJHREgxYWl0NFd5VFIvV3FPUFJ4MHAyWjY1K0M5TkY2eC9W?=
 =?utf-8?B?UTRoZ2tEMHE0VytjYmpVdjAwdlFwMEtKSG5vRm5PcTJYbUwzUHVSdTRZNXhz?=
 =?utf-8?B?ZmpXeXhmV0xqcUFaeEpIY1ZIaFhJcHRRYURjN2hVdlpOT0l1NUMvOVNEN3o2?=
 =?utf-8?B?cWZXcHhZY1JEK3NSU3RHK1hDcXQwWTVQdmIxNTRYWWxiM3RXNXZLQ01lV2RX?=
 =?utf-8?B?TnkvRDZ4NWc4eDF3ZzRURjYzVVdQQ3lTbDJCTFhpNk9QWTQwRE9kWG5WUzdt?=
 =?utf-8?B?QVdHbGgvdXdRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDhYNHdxMDZRRFdFVWNaaS9CYXZBSGl3cmVOQ0wrTWROMllIRjl5MDNTbDdM?=
 =?utf-8?B?bzYzQUlGNGpXb1AzUFUzMWl1TWhkN3dzKzVYUmhOcHI0K0p3dWFUNno5TmNv?=
 =?utf-8?B?Vm1QUXh1L1p4SUtVVGphNzB3aDlhbDY2QTdHU0JTVEZTZEN5UmpIOGx5dzhR?=
 =?utf-8?B?R3gwdWsyd0hjSElJQldIbytFZ3NqTHE5KzdRUmR6ZGFsdTltaVFERjk5bE1h?=
 =?utf-8?B?OVc0ckxVd1JQTThTdDlLQXpjS0p4dVd3dU9qRFlTT0FtaWFyNVJyb293MmhM?=
 =?utf-8?B?NXIrNTNoa3ZrK2tZNkJSLy9hdGVkQis2Yzc2Q0pTZWsweWRMY3RiRS9lTUs5?=
 =?utf-8?B?Wk1iTmFSU2M2aUM3c1crR2RPM25yajRBcmFJODZ3TzNGZkNJMnE4S3QweXNG?=
 =?utf-8?B?ZUVrLzQrekRkUFBkM2Y1VUsxdmVTUi9pZ1RZZ2pkWncwT1ZGVmtwRTJwblJ4?=
 =?utf-8?B?V1hESUVHTVFQNGdFdDRKNUM1U2ZVRmlJWVRzMkdiZUhUOWFTdkNlaU1YaDU3?=
 =?utf-8?B?OW9ja3hzKzFFZnRlSFlFSlNoSjJsUEZJZlhQd3M0RFBWb1YzRzR1d3pONGRs?=
 =?utf-8?B?OVpORFgxdmJrZTY2a0phNURVMUpYb3hWaWd6VEtjeERqbTd5K2NQYjloTy9y?=
 =?utf-8?B?bllhSWx1am1vWVNEbUk2MzVMR3FLbG12Njd6Y0hiN1dIbkNtOFN0NnpKZzUx?=
 =?utf-8?B?NlN3dkoybHlmcWRQZis4dEo3TEM2Q1BGYXhzZmtSTDBzTHFya3VkeDNiLzBo?=
 =?utf-8?B?eEFEcHg3QXErUzVGNGMyanV4Sk5ubWQyRUliTjNFYm9vMmZVdkdhTDVmcGQy?=
 =?utf-8?B?NzdpODl2TEwvYXBRdmk4a1Y3V1JzeXJQRFdaOFVVMHMyWVQ3Z3EwR3FMWEFm?=
 =?utf-8?B?WmpzT0ppMGpiUGQzZTlsWlZSRi9icVJBeHVhK1J2cmZlUkV2Y3N0YkZ1czJH?=
 =?utf-8?B?WTJjUUE4eXJOTHhNWWxxWmEycGNXTlNMRXI3Q3BRa3BLRUlHZWNNeE5ERHpL?=
 =?utf-8?B?QW55c1h6L2doaGpyOGFZKzhmNUpGNzVMNjhnSEl3YitteG81ZHVZR1ZDcjhv?=
 =?utf-8?B?cmJ5eHFTa0FZdytjdWhWRGRxMkpibEpFNUExMUhIK2lTcFd2UGIxOVBKNzd6?=
 =?utf-8?B?RFI2ZkFMRVlWWnRrU2VmYnVhT29DamJ3T1NLS2hYSlRoZzVPL3hzbEFRV21a?=
 =?utf-8?B?a2gvbFhqSGs3MmJMUW8yRFJHeFFsT0hua3U2QjEyRkNqcU9Td1VXYWJDWjJZ?=
 =?utf-8?B?aVJHcTRhYTV0TmNYY1V1R1dBWE1meDdIWENUd09TdUZjdWd2elNHSE5PMjdK?=
 =?utf-8?B?RmhjSzlKRVFybWNYaWxQeWx3UUdQNzZKdEJ2MDQra291cTZZTlViZjM1bW9K?=
 =?utf-8?B?Rk5RYW1tM0lTNFlIRGU0MzlvU2oxQncxaWdOdU14VHRiV0Jjemk5KzBlOFpG?=
 =?utf-8?B?T0RHMnh5Snk2MzlWUVlOK2tNV0w2bURaK012cmhPditURTlHaXBuQWtnejNU?=
 =?utf-8?B?azlCdWF1MElwVGUzYy8rZ1Z0cmpMNmdzS3FLT3dMTzNNdHVSdkNzOHBYWnQ3?=
 =?utf-8?B?ZUJkUXFWZldWVDBKUGxWZnV4SzQ2d05aOVVVVnF1aWhtY1Y3dGwxQVRPSDFm?=
 =?utf-8?B?clRQOTNqWUxsdmd1QUpkeWV3UlRDQjVkOFljb25VY3plakNkY2V6ZXpHejgr?=
 =?utf-8?B?WGhKOVN5SXhnYS9hOStIdUdzSS93TnoyQlIwdDJhQnNyRE0rcUgzWEpNYk9K?=
 =?utf-8?B?L1pQWGUwd25GdkFiYW9BbXN6QVk3cW4zcjRVZ2xWeHB0b1hNYWVFTUMzOXlj?=
 =?utf-8?B?akhudXJNeEJQM0RkdmJWQ0Nrb25JVFJyRmpubFB3M3hDUEk4ZllJQVJBZkF6?=
 =?utf-8?B?ZWwvVFdFMzNiTG9FZHRwd0JDQmRHWVJnUnNYZDlGOEREcktkWU9RUFVha2x4?=
 =?utf-8?B?a00rS0F5cFcvaFVOWTdhQkpDbDRNMlg1MitsUjdtcWt1Y0x3ZWk2VjFJalNG?=
 =?utf-8?B?TTMya1haUUFkYkd3Nlh2RWx2ZUxmVGdHdW1uT01iS0Vsc244a2JLWlVNbFBo?=
 =?utf-8?B?eXVLdlRsc21odjRGRm5jOFF5K3p2cVZCc1g5dDZ2WEdEOEVVZTFGNWkwRUFo?=
 =?utf-8?B?WC83S0NRbmNJRm9ockVONWFHNWFBd0xKc0tuVkQ1NWZGSDdYNFBSdGYvaktr?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7097374a-0ded-415c-78ee-08ddd6d81f94
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2025 00:03:08.7553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7vW2K2fmlN+g+1UKv6h4zTPC+NY4e7LRw9p9Kkca3YkKArVVW27JH2bOSlSFPbl3eur+YAbLU9P5L7VdotniA0R8mRZRGCI89XplbrVi/rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8919
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2378D100007
X-Rspamd-Server: rspam06
X-Stat-Signature: dc1u968xq1oa964f4phsh99kw9g15jqt
X-HE-Tag: 1754697797-11546
X-HE-Meta: U2FsdGVkX18JO4hqrHVnIpNj9eJmB2jhpU6qK5VnfDTi7lBTQTOwOudmp6X2/FtPqIOPJS+tZjz0/Zr8TY59erLu2YWWMYwzuYoQMahBxVjcfNjLAwDOkpbyxblWC4M+kdihO4JuDuYWN71S5+fT0+42brUIpbAwbclXeO6xxSla2eSU6OLMKCDtk4PfDaQLZMWSvjJY2iO6IGkTGK2nM6rgOV2exC4eceKnCjlOxNxAMQNYh51A/JyfWwJRYWbd/mJayfsUFXdIaOLEcTz6ItH8QU/qhmZQLNxbk8tGvHynC6YMmWFTuvg6B3HZiEfzuRilXZL+jyMo52gUDQWfg4/BM7zdDSfnlsJAKjXZQVHmuEAMTMyvKETMr9hlZRnmV31rBUsYoOHpbjJNiBppatDH7rALZxbl8qMDaONp8Cpq6gJkEQoEQJGi1AvJGoZ2SNgqpcI1Ir+CljOjU1Vl4AAjoO/XXzzvqDgFRPBse3fHqHisX6rJkZ1e9OKqESLdlkdcbxWHaFOIO5JeVFxKDMN4i16YQ+DMRBQqxBKFT/uTfW+HTRfZkheFVbnN+WFZhC2IAwfML9Vcb6SS/wMrofcKg1lFr6QcG5AQhfEClx3aHSv9y784Y23eCJSxfXPMKS8ENwnuTsivW64Jy3OQ+t9Hz7x0+0F664H9BgLU/QMNtwuyWL9Hp7sDI/KeSCX2wRgqSxevz030mB00gu5FR3rp2iJ5HNe+koY4Agh9ScOuJmWssKywQgLnUzinaqJBa4fGKfUaVuVzZNBRumiKJeOWvtiEioN1z3QfZGpsLSTT0xjiJpCO1/H6RjseK/vDwqbI8AsFMnQHaoWje44+cu0jllDclGuABHjudxgSAbUcbHKuLSq4ZQl5y+9qmAbkvdXjVdLUFeJiF2ZO2JR33HSzVixDODj/52PBq2dbMHi8bJGRIkaTfHQZ4yMmtt9IwXbqV84fw40jBuj9PTj
 g4vwygae
 DIy7JM4CZbeQ/TN96IDyhm9ejFL0nBAc8RL3UuKFVscorTv7wK2SZDdIqOdB/VdIM9I29AkDDm8XXvtb+VeocF5MexeqbZgFb/yy1xPeMuesd679lsqdrV/uLoKYo9dIV9Fn8+4m2CxCqqrBXe8XQvtxs8drczsNC1Ca0Q+v8Xv6ATNB+7mw+54XBWbLkRdASc0FkSh5QG6iYODMqFeo0FJFfCMT0NMlI8KutL7bPGeGVzV1WV2uMN3GHHClw/xKfvOvnGI2M0HSLugWGQim7ehsn0lvmUj4vNzjmeahQeN5NHwcpaHlAR5SKa68bZI3RuWZ87TSphJ50K7BLl4yyFBWrl8E7cgOh28bEiWtHdTp7TJQx+mLu//kXQrzsxlNizlxEY6fja5Ftni2aMnoCFBaRaloNnFQzwOjNPG8+3mmHw8HbPQFgjWNmEQfFhiowbBqxVLMgvOWLfT8SFPjojLwEuVaZ8jDD80BOI64x5swOJ1ICS/SXZpK1YcNp7lcGKJxLjwVgbQLmyEicO4mA83Ve4SRMbhxkpVyCO7PnutIXp6Lf9hBgTuWmcSR/4TC3s9KUp6jtGEo4LPDX1mNl2TF04omHy97MDguZWtnYkjgD4RAJxlFinck1ZSXgS7PECf8BSz84v75s4O7QBn1bSLfTJE70smQZGMS/nppy4FwKUFEerdSTJx1NU4HWGSlZa9VxaTIxEk8rElr1rerYdhxXGfz5hx3PUg8Yb2QjqVZsYzmWZSjcGC/zY8Tkf4hNwAkmByfkEaeHptSgwR1LgZtKwijswFefQn3UCWXzdvDiMTmui/tan2UcaVTSj3QWB/XZUeoSmE4407RhDl6kKYKFOCDupMtr3ypvQZRk+MyeSM0QbEL+xknNxCglSP7Bkkt2yvaAgFuHLaB/rBrcXbh8JTsHY1VfSR4aIIyHb7BR/OykH2s9AOikpV0K0HC3t/M9L5Vgp9o0lcQTrC5wQ0u6X301
 4OpyAvuu
 2yucq+Q/q958/zEbOTrp+vsVr7e3AshES7jm8Ki/KGkW/UdTYzjZh3A36g9nQidqjVVCity/jtTSqO1AI3odobjTDJ+Wb273xVxKQ8WTVPggMRtj7IHuR7B31g+NfVhQ3D0zgNhuuhFvatM9J/VdHNZxMMG2lnFniK7QsGyReLM41XXknesw53yOokQQyWJFdX4EZpeXsBwlA1A9NmRZkPAmeM3KUubHSP1mshR5JP54QQG4M7sMAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDgsIDIwMjUgNDo1MSBQTQ0KPiBU
bzogU3JpZGhhciwgS2FuY2hhbmEgUCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4g
Q2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4g
aGFubmVzQGNtcHhjaGcub3JnOyB5b3NyeS5haG1lZEBsaW51eC5kZXY7IGNoZW5nbWluZy56aG91
QGxpbnV4LmRldjsNCj4gdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsgcnlhbi5yb2JlcnRzQGFybS5j
b207IDIxY25iYW9AZ21haWwuY29tOw0KPiB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBh
a3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOw0KPiBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IGxp
bnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5h
dTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBrZXJu
ZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOw0KPiBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNjYXJk
aSwgS3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+Ow0KPiBHb21lcywgVmlu
aWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47IEZlZ2hhbGksIFdhamRpIEsNCj4gPHdh
amRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoIDx2aW5vZGguZ29wYWxAaW50
ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMSAwMC8yNF0genN3YXAgY29tcHJlc3Np
b24gYmF0Y2hpbmcgd2l0aCBvcHRpbWl6ZWQNCj4gaWFhX2NyeXB0byBkcml2ZXINCj4gDQo+IE9u
IFRodSwgSnVsIDMxLCAyMDI1IGF0IDk6MzbigK9QTSBLYW5jaGFuYSBQIFNyaWRoYXINCj4gPGth
bmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQoNCltzbmlwXQ0KDQo+ID4g
TWFueSB0aGFua3MgdG8gTmhhdCBmb3Igc3VnZ2VzdGluZyBpZGVhcyBvbiB1c2luZyBiYXRjaGlu
ZyB3aXRoIHRoZQ0KPiA+IG9uZ29pbmcga2NvbXByZXNzZCB3b3JrLCBhcyB3ZWxsIGFzIGJlbmVm
aWNpYWxseSB1c2luZyBkZWNvbXByZXNzaW9uDQo+ID4gYmF0Y2hpbmcgJiBibG9jayBJTyBiYXRj
aGluZyB0byBpbXByb3ZlIHpzd2FwIHdyaXRlYmFjayBlZmZpY2llbmN5Lg0KPiANCj4gTXkgcGxl
YXN1cmUgOikNCg0KVGhhbmtzIE5oYXQhDQoNCltzbmlwXQ0KDQo+IEkgc2VlIGEgbG90IG9mIGdv
b2QgbnVtYmVycyBmb3IgYm90aCBJQUEgYW5kIHpzdGQgaGVyZS4gVGhhbmtzIGZvcg0KPiB3b3Jr
aW5nIG9uIGl0LCBLYW5jaGFuYSENCg0KVGhhbmtzIGFnYWluLCBOaGF0ISBJdCBoYXMgYmVlbiBh
IG1vc3QgcmV3YXJkaW5nIGV4cGVyaWVuY2UgOikNCkkgaGF2ZSBsZWFybmVkIHNvIG11Y2ggZnJv
bSBhbGwgdGhlIG1haW50YWluZXJzLiBUaGFua3MgZm9yIHRha2luZw0KdGhlIHRpbWUgdG8gcmV2
aWV3IGFuZCBnaXZlIGZlZWRiYWNrIG9uIHRoZSBkZXNpZ24sIGNvZGUgcmV2aWV3cywgZXRjLg0K
DQpCZXN0IHJlZ2FyZHMsDQpLYW5jaGFuYQ0KDQoNCg==


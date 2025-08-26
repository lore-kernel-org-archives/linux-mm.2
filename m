Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9672CA0FF3
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81648E0095; Tue, 26 Aug 2025 00:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31C08E0090; Tue, 26 Aug 2025 00:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB508E0095; Tue, 26 Aug 2025 00:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B06528E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:27:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E6FD13984C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:27:34 +0000 (UTC)
X-FDA: 83817624828.06.2004E79
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36AE5140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:27:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LbJoRQi1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756182450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIMmUcJmNdYKqL3VyhWMC77G49/tm5BuziPDjqVM1RM=;
	b=R6H/sm1j00KpHhQoQGtirBlLtMF3up/pmuBTbvPF3Jvcjd4yRpIv+RX9HbS2VpI1WNqeJL
	b0N/tbCxZqfWRGjMLjMOQdvmbbiZ/eQn/a7hp2Xjk2G0QQ+ol+a8UsP0F1sk79QSsVgawX
	KkhBYWPnl6Gvk1Nq2ACGllyQ6K6OxHk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LbJoRQi1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756182450; a=rsa-sha256;
	cv=pass;
	b=xQ4GHVoxCP6sAX4MfVrUacW5II2h09e4u45el3OV4tR/FcV+LQGCEV4zOWJhmNY+ROBPTc
	mg/1U5oxGP9BKgNjisBHqp+1p7CREs6wpEEDxIEfZQxhz5wr+7Wr1jbUG4KXYHWaFZsehB
	R8+lpiWTw1E9LxvPPrFCVQnInLRsCgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756182450; x=1787718450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bIMmUcJmNdYKqL3VyhWMC77G49/tm5BuziPDjqVM1RM=;
  b=LbJoRQi1tXehNciGH09zSbMScXWXUXHrQtkcTAq9tipUsr6SPvLyUdhN
   1nUVB7GQFm8pB5JXIKzEamw4Pab/xxnUbcaIKHu87bKVt6oJEftQamgZR
   5tj0V561HFqD6noJCOEBK7hqp4Q0Y8COcVjgHfgq2YnjuTuVAvloIuC9z
   jWuMART6EokziKDW5vwtSETh9qaJYbVMuNpMdKoiUfi7Zt6XmcA66B8IV
   nuf+gVnFCiFLh4/aVSz39wBsERDfFzgEO5ETF9JnNndl8JZPZfNJ7spAb
   IGegt+G3bQ8srTNSw7ehRRNphpGG5Zcsr8n7qsNhvJvfdtMYJ4YFMr7s4
   Q==;
X-CSE-ConnectionGUID: BcTApWMpSnKcBeEw65uFdA==
X-CSE-MsgGUID: JGWqIdJbQquUj01R7Eii6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="80999944"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="80999944"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:27:29 -0700
X-CSE-ConnectionGUID: SWiuXgkdTsKAxATpegUDGQ==
X-CSE-MsgGUID: s+WWvUF5SMiO/A+/2chkeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="174740983"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:27:28 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:27:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 21:27:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.82)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:27:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lExK43BjxzXnB6sW+ZSi2jAeVuDcyy8dWzQIRZz4OADhw3jTom4CBzP48Kk8lfHi3YyyiQNnjXTc9su0hJYVFjBVV6UwYmbKki0AU8Sd6SQpAnM23Gw5BiXP7zAsM+kW0knSyd3rJeJeNKVzecWiSRRqHKUkCbTj9p1b0ScIk1urX4O3XsbDdB8KlFZUKqiKu5/BsGslahCUhEE+F07/bOFMi+0rT/t2I8ArGPyx7GMRKJORSG7kwUg40YvUzGUSn94SvZhW1iZLxNdfUc88xzhwkf/K6Lj8dBVsnnDU7MxJRZ6koidAqZH4q1jZ8T/2rofVrUAdrio3onMul2Q40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIMmUcJmNdYKqL3VyhWMC77G49/tm5BuziPDjqVM1RM=;
 b=oBBjvo5g2Lqyi/TpmrFhVNWq3Aqi8ApExWVzE1oSQ5EATYJNDQFRSqRJ8Pu/aXqydtkhlCR+nZIaxjbR4xG1pMdTpmUD5jkzS/Y9tgHZkLt8rZkCJ33Rag+iHT7TXaZ6FPcX+VBtqdVy8aaDrt91ks2tNfy7nVhbV8IXy4hXp9naUsR+mFV8pfg035BmLz5lTuJ26iB7vz7Yg8Zr/jv9/4r4a8lhWRM3dil+vd/0WTp+XBJltsuAmXsGqzTI8nB7RUQjImc4Ktgbql2JBweN/LTej+kV2g3yj9qpZxUUP1v8CrrgrWaTmQ997FrMKP8EnFRAxi4B94+/XphMIgwuNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Tue, 26 Aug 2025 04:27:25 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:27:25 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
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
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGA=
Date: Tue, 26 Aug 2025 04:27:25 +0000
Message-ID: <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: b9765725-aac2-438b-8478-08dde458dbe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K1Jjamd0bnpHdjh6RnI3ZkpqV29HUkdEUmFzOWFQbXFHaU5ZQmhOZWZ3dHZt?=
 =?utf-8?B?MmM0UDhFOFA5dVlwZ1V6bnBtdXdRelRiN3FGK0U4WjM1UWJ3c2dySnhVZnBs?=
 =?utf-8?B?ZHQ1WDFCRW9JVTUyMWxWUXRybDN6dm12OUo0WTZFVytZVng1T3FDaWR5bFZq?=
 =?utf-8?B?MDB3TTNoUjh6MUVwdXdHaHpsaVlCZDVxRWFpVTZGU3gyK3M4dlAyYjdrWFdJ?=
 =?utf-8?B?NkhHY3ZPVDN6dS9uWURtYkszNEgrVHVWMWJ6V0NERk9FaENET1lINEtBNWRH?=
 =?utf-8?B?cFRJczYrRTY4YnJwVXExSFR0MjBVWlhBQk5QMHhSWjA2YXkybHdER01KWGsw?=
 =?utf-8?B?NWc2OVdIV05yaEdsdUZJSThnVDFaUjhRRnpZTkZ2SGI5YUl2empiWUQwT2cy?=
 =?utf-8?B?NCtPSFB5bTcyTUpIbWpPdFgwVlFCdWpWRWtJTWQyeEM5UHM2S2xDQkh5dFRQ?=
 =?utf-8?B?dzVsVERmWFRodWdSUVY1UVgxajkwQXV4bEVTNWxHMWFFdmN3cjF2REpyU3Bv?=
 =?utf-8?B?UGk0allVTDB1cDMvVDkwY0NNQmd1V2tvVmduR1dBbzUrbHZhRE4vLzJaU1V2?=
 =?utf-8?B?UytFRWNFMFZVQ29id25wK3V0Wmw4M01ibzRUVWdPWmFvRVphQ1IrN0IxR2xW?=
 =?utf-8?B?VWN5T1Y5Rjd5WjlyVWhOQkFUU2R3VzE0SmdSRGxQN1FIaW9KbDhMVW1yNVRN?=
 =?utf-8?B?R3ByZC9CTVlUbE45Nlg1YWp2K3J1RWFWMlJrY0pXemVIQWpTbjF3WkpleTZX?=
 =?utf-8?B?QUN3eTNyWVZORkU1Mmhod2paemwxSE1JM2JiTlVvenZMMnhUaDFyQXBTWnh3?=
 =?utf-8?B?MC9acmR2cDlGQ1o1aFdrOTVIQkZrdHdTUHVkMU9zS3l2VGlDb0FZT252Y0xa?=
 =?utf-8?B?OVh5LzFSRngyYU1vTVhpWnEyTEpnNVBFSUhha0VBc3g5RmQ2NHhLSVd2RU5v?=
 =?utf-8?B?bkJycm5kMmNVSFB4K2k2dVZmblBYKzRYQXRySUJVZ01WMHA1bDFVMHppb0tw?=
 =?utf-8?B?ZUJ0T2t1V0ZUMzNwb3pPV3NhTE9kcHRZV1dBcWRmZVU2NExiNzBYaHJCNzd1?=
 =?utf-8?B?ZkJ5a1ZWYVBzMStQdmZ6WHdoV1VVSWMxbkErTE1xdU1welFUQWl5M1o5VzNT?=
 =?utf-8?B?enBJMmNsK1I3QjdiVDQ2aDJPR015bUFqazRwNmtsbUJqbVhZUDNXaGh3MUdF?=
 =?utf-8?B?UXpVTWpnTkx6djY5cG80Y2NLckRqN2dxTnRqdkRIWW1Yd0R2MGxtWFV6VDZH?=
 =?utf-8?B?ZkNUdW5rRlJ1K3ZBMlY1bnhQYlc4WVEyNW5MNm40cHlyMXZxWnl3aU02ZEVL?=
 =?utf-8?B?VnZpMTlkNTJ2ZjVjZUZ0V2V0cFVMbDVIWEFDN0pqRUZQSEsycnR6WTdLMHIx?=
 =?utf-8?B?UVN4emE0RjdiYUE5UWt6NDJYNzFrM3VRRXBsM1ZuU1RwcklrZVI2SEhRdmEy?=
 =?utf-8?B?ZnNHUTdXRUV1MGZGMzBydXlLZE9jYzNtR1Fka1hqbFVPSmEvQzhaeUlhK3Nv?=
 =?utf-8?B?anVrZ3ppVlZ5dnRHZE5ML2hwS1VUNjNWQllQZnpaYWtVVGFIVXB4cjVDOE1n?=
 =?utf-8?B?ZGE3QlduUldBdHJ2aHF5MHVlcld6TUZHVEtRaDRMVXFhei91d0ZoZU5NVytW?=
 =?utf-8?B?VVd6eHJUOXFSbXl0M1ludDZJWklHaDdZcG9FSzdpcmJ0SUk5WFFsWEN6QUdh?=
 =?utf-8?B?Wm5HNC9SZ0pueFMzVTBuNEZaVFpmWVI3S2s1Q2ZFZG5vRDZhMzRsRjRkRy9n?=
 =?utf-8?B?N203MUJ6OWtIN1VPa2ZBdVRBOE9zdzRoUTM5WGt4cVpyUFJScW82Rkhxc2N5?=
 =?utf-8?B?SjBWZ2UvTTFpMlVyRVpRTFpSeXQ1WFdsZHF6VmJjR2o2YTNPVDZkb0F1YjJE?=
 =?utf-8?B?djRzbGVSZlBUcnhSOXRCNy9Yb0p3aDU1dHY5bDNGSzlzOUFBQ0l6MUZQOEpY?=
 =?utf-8?B?SzA1ZGxDcDIvajBmbEo4bFZTWG85U0I0NGg2N0pzUm9DMitoQm8vSFVuZDVQ?=
 =?utf-8?B?bmFNVjFXVENnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VURTL2NRaWY2M0lnMEo0NlBSWjdPZTRBK1F1UWlaZkZJZ1FaSHNxSGdNTE9C?=
 =?utf-8?B?REcyTXB0LzNia1p1Um5PR3JId1krNys4SVlGOVorRmVhdk1pMnVnVFpSZWNL?=
 =?utf-8?B?K0VRZGRnTjE2cGxCUDEyRmtSeGxWeFFFcjZWYzRPSElFenFQNkJGZzVIdHJR?=
 =?utf-8?B?WW9WcDRiVUI0SWNiczI5dUdjN2VubDNaOGlWQXBCTmVLck0zaU5vUmZvdVVI?=
 =?utf-8?B?elROZUdPbnhTUHhoZ1VQUEgwZUhLblp0VHA2enlPdjNzOTRLNVdCUEVwSlQ1?=
 =?utf-8?B?emlJRjJ4TjcrTytDT2N3QmJzYmZaZ1U4MnRsSFFQeGEvZlp6c0hnaDB0NzhL?=
 =?utf-8?B?SVRRbnRhY1lEN3UvSW14Q2dsWitiZWJXeFZvSC9mbXZHdE15NjBJN3VZSU9k?=
 =?utf-8?B?ZWZmOEhlY0w4N01nZ0Y1OElkTDBBZHI5OC9DR2d1L0ExVmRlNWJwY0VjTGFV?=
 =?utf-8?B?T0tZR3FiN2xHamhkRzdEdDBOeEJLdVlyTDJscmsrVWRCZFdNNUlpMDQ4eGtX?=
 =?utf-8?B?UlE1R3ZEeVNsRmNkWFU5UU9PM0tIYUJRVWxJWE5Eb0s5RXpGMVFBdVZJU1E4?=
 =?utf-8?B?em44cGpER1BYbHhwblp6c1dEQ0diWHBJTlkvdzJtSWlDK1pSWGpiRDF0bVZl?=
 =?utf-8?B?cXRxRWhRQnV5ZzJZVDdCMUJQM1Q2TUZhQnlwdkJwcXFCU2Z3OEdDRUNhczJ0?=
 =?utf-8?B?TjBGWlJxMEJQSlFTZTVXZnBxMGtyME5vUWM0Q2NtWVo2Q21pNUJ2dW9WNU5q?=
 =?utf-8?B?N2dvcm42dkZYVXhYekhVc1VHaTBQRlhuWkNnUjFvOUZDeW10aHY4THVFclBC?=
 =?utf-8?B?V2NEaXNUWmtzNlZJZWQ0MDlBdExvMEZ0bVJ0UUJFMHFiTFIydkk1NUlwTXkx?=
 =?utf-8?B?aUhGOG9rRnZ5NWJPc3ZhYVhvM0RCUkhsREtlWEtnNjhROWgwMjAxNlhCN09D?=
 =?utf-8?B?bUdXSkREQXZ2ajkydG1NZjdwM0tnb2FjZkdHeVdQMGpVeGxEbnUrZkFRMlox?=
 =?utf-8?B?QzVBbmxQdDdCTFUzK3UwUkFndUJuRTlCOUNkR0tFNW9FdUFRYUVDd212czFW?=
 =?utf-8?B?T1p5U0ZBTzB2ZmZhWG10KzBxemE2dXdLMk5nc3kzb0xxRHlLeVdBcDZSL1A1?=
 =?utf-8?B?MWtIYmhoL3R3enhiWVp6OEc1TmxQSjYwUmhxbkYrQjRvOHoyeTZvQlFrdllB?=
 =?utf-8?B?aUVrOFROaTk3bEx1azRMVXN6NVhvQ3I1YkZHL3habE0xMzFzR0o3ZUpoNnBM?=
 =?utf-8?B?bkNQQTd6U1lwTTRmQXdycllSK0hzdFljYXY0bFczNnNyTHNYOVh3TlNieEh0?=
 =?utf-8?B?MWxiSEtQdDJQM3duOTBWTVltUVl5dVQ0emliMTZjZkw5ejhveGpqakJZWVFz?=
 =?utf-8?B?UnBlV2diM2NhZzROdkxaOGZBWXp0UW5WQUMrSVdlMmtrV1pDeGUwZkpNK0k3?=
 =?utf-8?B?czhkNld2UDY1QzJCM0VENmp6UythMm9JNFdoL21oTW9QNktEZXhqYzlrQllo?=
 =?utf-8?B?NWRZK1lTaXdrbzRMUlZ0cGU2UmMvNzRVd3lFbW43NEd6MWZVc3B1SE9tTkFs?=
 =?utf-8?B?RVBCditFZ3gvTTlZNWRLNkJsMmVpakxxMFhGYkwrQjhVU1BRQS9RbTFtSzh2?=
 =?utf-8?B?cEV5YksxYXFZMG50T0V4V1NNQXdSbDNybmxyQXJpMDdINHZOOXRGK0RMakpV?=
 =?utf-8?B?bEQ0UVR4c2xjV3hCbGFPUDBtdlc4NGxPei9qYVJyQzV4dmlhWDhkY3lodG1l?=
 =?utf-8?B?eEVLRFhhc3NNT21oU1hBMUIvTmNCeEczMmVPNGlZZGoranhjWkNZb3l0YXhJ?=
 =?utf-8?B?TkJoQkd1dzdvSlNZSENPeVhtc2tpZnpCRGoxa25uNVhsamJ4dHJYbFNWZTBF?=
 =?utf-8?B?NC9za2V6SU5YME1ucVU2T1k5ZnloVEppOUZDaFRLeHFYU0wzMHh1T29Mamxy?=
 =?utf-8?B?a2J5blBJdGJnTmEva1htWlNPZFE2QVFBOHJXTi85RkYvVUlJNkdMMXRabjVO?=
 =?utf-8?B?YkdvRGZLVS91anhPcHZUbk9OUlR5bGxjamZYd2dwTEZjNXZEdU96dXdZMyti?=
 =?utf-8?B?R3dDSitWd2Q3VnE2U0pKVmJTaGUxYTJCWW44UjBGdEd4eEdKc0xmbHEyakxY?=
 =?utf-8?B?VExGMk9lVmNJSHQ0NTlRRHNMT2NIRFo1V09xRHJnREVwMitTTnhiMm5TREtX?=
 =?utf-8?B?amc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9765725-aac2-438b-8478-08dde458dbe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 04:27:25.3193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVxOzkat0M0mLfqu5v6pxdpMMfdVA7SkRxqFKsFVDHcu+KplYFvsanQdBkVV3JIq8SXNQ7rk+Uj7Q0n+rb5E25HAHrGqHLa37p2W/R+/xgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36AE5140003
X-Stat-Signature: uq8uow16go641isqby1jpgarctuk61yn
X-Rspam-User: 
X-HE-Tag: 1756182450-404813
X-HE-Meta: U2FsdGVkX1863GaIANLMioIvkigEE+URGYglm4voNrQisIE/1qRvuNALVqzm8hLngWVZIV+3hCJ5mz1EidukXSutXnbks3YrhmUtbvx45ME0zBm8YQ/vRc33dsEdcktA+sAE0Kc9fXG5tMfvkVU99pktSCFum7F01T7T57H4KZxvHwlEjOZDU7t0qYjajdWXOfZ85GUbo3biESbVNXz6J4y+B8+SnK3oTHK+rhOn700gcF4Y+BW7wGyTIhEgR4XcBoyDPajvgPm55WFlQXNW5vkIFjd43ZFjID+72JOXRiNhobEWbtWnpskoYrY1/D0m/4ga34KLvN9jQnBqBLtTSTcAt7zUj2Rn79g+WU+x8mcu8qBc9ntkjvD1coHGP2zZC1gvjqiGv79LCh9r/oQqOhK49cgWg8N22vryhoP3HdGpYyTiUD4xTmLNGw9LC4At9IsUzcVGxcZ3uAxU7QXIGesuvyXGUjSy3/ev+we/nJpn5mphFDwu601/abz7ziAVJa/AAPcsBwsPeH7ptUzTHFCNUrJlDLaw/xp3mxk3pE0qJB3Rhmy6LMGtWZXONv5rcFge9xHs+zjoShGfQOrMS/Ek0M+EZGVfF7Vr9RyTcbtrbaaHiIAnvuNQD5cRbv1hE/MfkFWwbErjMVE5+oa266SbEBxg04Oo+vG/Zz7lHTh8fCVOiNx31a48uihHUH9pkXJAyROvR9BVWnigO775GHJr4HWa/pvvJzaHt2L40HM1ytp8MU4EV2xhmAqbGD2KVGbrvtcrgHtrDfWeP7Hq3sxrreSXFSwFrayQL1ga86+GsZOjFEwCAD5n/qXZIg1j/V5qSPdRfQRRctC/sRf8Oek1gVpcENiqViMT3Ls8NKZIC2kY84MtDRBHa7ho2h+TH67ynpJeJkEk7V5YUcLvB2snIRz6fKziZULvUhNcNxr5mBOQaD29GmORszJC58Fm/aQNlQpqx9HEx7p9esi
 ZnB3l3uL
 GUaIYAfZm50E77SWrQn14ZuQTx42c3r1YJUlAJh1E/glYyWpWbN38BxR6o3Wxk5F2cBUp0wJhbfUToAxBjBcHtMxQ8UC+dmODcmI75Um6YzUaLccdvJBw8B9KfkAk9RWGXcc9dQ7/N8PlnynqyxHdwvYl+QzYQLoB/JUkAen1w1q4j3CF0+BqrNor+qeIHCAbSmvf+yHG05He1/JvoOVMbQ/s7D1rbuFqyY8k1du781bhdzieR9NBQnI3h3Kryrvjau3xWvn919DhhSiq3M14Zyww+3tcSbLlkURxxxS+i7cSTn4VsUGFlMjwqOKMJRVaWekJ0YMnZ0Bdb7da2pgZ9fvwlXWndTuVIsav3AhTd8XBTbljsHMMGfIOYKRWoYzRlQ5iDRVgRN6GnCFljZM6Q4OzU+WxS3kQYmkNlaRBmpAH1ruvKrCeGPDENEHQ5TRg5bxjFn76Rd64KbRA3KLDeI/YgFH+oy0Sq57HYyk96SnDH/dCYiqGt9xKVGLtnLOjUgE8yGB7PR9g8MZBVmPs4+xOJIGrmvWfApCcckbMtq6cHcb8NNULveCKEvKg4mrWrC2jTrtCtj1/LkUJ2T0fOnNsprLBBv14mxiwUS1/fkTTcUILLTH2w0yr8j/51C6jJIKcrjPcrfFBWJf1d4F/hfikXx0Ma65DjzqmcDRrIKpW0X4UnsFgHdEr7PRMFJ4qbcDmg3qAnwi5XDxtuz7GWp1OypLwr5SXgiaiaiDTn3L9p8cAptz5PHLZhXQ1/IWgpsSTjI6vAyXfYBKYkS/J5c5RBtuEEEQKt5xpgJqDbK8x6DksrVXAG2M/xHqS1Q/SfGrrJx3X8u4+zY88I8C+4A/qDZ/VoVJKaP99ay1XMBxUIC/1gP5w3epPxDyzLv8SlUOtEJDBfG24XLe+d3tymWKYg3xFQ64gshh+/gMKov2ZY/d00btJijxY+avkgVHMBsTL8jgrhCSoXFoZwdZ/rXIAiO52
 AWbaJMl+
 2JyNJMn8XfilG+BxGonLFQ+r1zcIofvHuIdYR2WPsTKvrQu90HKGuIwt+xiQXamIHiKB5AZjjz71MFPPwKafGHS6PD2Zz9ZIqPQMFzLxOWKvJ2Ei09UmSCkJiBgt5uwhG01D901s92ywZ4p7VNK8BoHoJM5b8d19kmSnn8vTtTTbOaDuGX8CJhvbLpChgakm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFycnkgU29uZyA8MjFj
bmJhb0BnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDI1LCAyMDI1IDg6NDggUE0N
Cj4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+
DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7
DQo+IGhhbm5lc0BjbXB4Y2hnLm9yZzsgeW9zcnkuYWhtZWRAbGludXguZGV2OyBucGhhbWNzQGdt
YWlsLmNvbTsNCj4gY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyB1c2FtYWFyaWY2NDJAZ21haWwu
Y29tOw0KPiByeWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNv
bTsgYWtwbUBsaW51eC0NCj4gZm91bmRhdGlvbi5vcmc7IHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gaGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRi
QGtlcm5lbC5vcmc7IGViaWdnZXJzQGdvb2dsZS5jb207DQo+IHN1cmVuYkBnb29nbGUuY29tOyBB
Y2NhcmRpLCBLcmlzdGVuIEMgPGtyaXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47DQo+IEdvbWVz
LCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0K
PiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBWaW5vZGggPHZpbm9kaC5nb3Bh
bEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDIyLzI0XSBtbTogenN3YXA6
IEFsbG9jYXRlIHBvb2wgYmF0Y2hpbmcgcmVzb3VyY2VzDQo+IGlmIHRoZSBjb21wcmVzc29yIHN1
cHBvcnRzIGJhdGNoaW5nLg0KPiANCj4gSGkgS2FuY2hhbmEsDQo+IA0KPiANCj4gWy4uLl0NCj4g
Pg0KPiA+ICsgICAgICAgLyoNCj4gPiArICAgICAgICAqIFNldCB0aGUgdW5pdCBvZiBjb21wcmVz
cyBiYXRjaGluZyBmb3IgbGFyZ2UgZm9saW9zLCBmb3IgcXVpY2sNCj4gPiArICAgICAgICAqIHJl
dHJpZXZhbCBpbiB0aGUgenN3YXBfY29tcHJlc3MoKSBmYXN0IHBhdGg6DQo+ID4gKyAgICAgICAg
KiBJZiB0aGUgY29tcHJlc3NvciBpcyBzZXF1ZW50aWFsIChAcG9vbC0+Y29tcHJfYmF0Y2hfc2l6
ZSBpcyAxKSwNCj4gPiArICAgICAgICAqIGxhcmdlIGZvbGlvcyB3aWxsIGJlIGNvbXByZXNzZWQg
aW4gYmF0Y2hlcyBvZg0KPiBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0KPiA+ICsgICAgICAgICogcGFn
ZXMsIHdoZXJlIGVhY2ggcGFnZSBpbiB0aGUgYmF0Y2ggaXMgY29tcHJlc3NlZCBzZXF1ZW50aWFs
bHkuDQo+ID4gKyAgICAgICAgKiBXZSBzZWUgYmV0dGVyIHBlcmZvcm1hbmNlIGJ5IHByb2Nlc3Np
bmcgdGhlIGZvbGlvIGluIGJhdGNoZXMgb2YNCj4gPiArICAgICAgICAqIFpTV0FQX01BWF9CQVRD
SF9TSVpFLCBkdWUgdG8gY2FjaGUgbG9jYWxpdHkgb2Ygd29ya2luZyBzZXQNCj4gPiArICAgICAg
ICAqIHN0cnVjdHVyZXMuDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIHBvb2wtPmJhdGNo
X3NpemUgPSAocG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSA+IDEpID8NCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHBvb2wtPmNvbXByX2JhdGNoX3NpemUgOiBaU1dBUF9NQVhfQkFU
Q0hfU0laRTsNCj4gPiArDQo+ID4gICAgICAgICB6c3dhcF9wb29sX2RlYnVnKCJjcmVhdGVkIiwg
cG9vbCk7DQo+ID4NCj4gPiAgICAgICAgIHJldHVybiBwb29sOw0KPiA+DQo+IA0KPiBJdOKAmXMg
aGFyZCB0byBmb2xsb3cg4oCUIHlvdSBhZGQgYmF0Y2hfc2l6ZSBhbmQgY29tcHJfYmF0Y2hfc2l6
ZSBpbiB0aGlzDQo+IHBhdGNoLCBidXQgb25seSB1c2UgdGhlbSBpbiBhbm90aGVyLiBDb3VsZCB3
ZSBtZXJnZSB0aGUgcmVsYXRlZCBjaGFuZ2VzDQo+IGludG8gb25lIHBhdGNoIGluc3RlYWQgb2Yg
c3BsaXR0aW5nIHRoZW0gaW50byBzZXZlcmFsIHRoYXQgZG9u4oCZdCB3b3JrDQo+IGluZGVwZW5k
ZW50bHk/DQoNCkhpIEJhcnJ5LA0KDQpUaGFua3MgZm9yIHJldmlld2luZyB0aGUgY29kZSBhbmQg
Zm9yIHlvdXIgY29tbWVudHMhIFN1cmUsIEkgY2FuIG1lcmdlDQp0aGlzIHBhdGNoIHdpdGggdGhl
IG5leHQgb25lLiBJIHdhcyB0cnlpbmcgdG8ga2VlcCB0aGUgY2hhbmdlcyBtb2R1bGFyaXplZA0K
dG8gYSkgenN3YXBfY3B1X2NvbXBfcHJlcGFyZSgpLCBiKSB6c3dhcF9zdG9yZSgpIGFuZCBjKSB6
c3dhcF9jb21wcmVzcygpDQpzbyB0aGUgY2hhbmdlcyBhcmUgYnJva2VuIGludG8gc21hbGxlciBw
YXJ0cywgYnV0IEkgY2FuIHNlZSBob3cgdGhpcyBjYW4NCm1ha2UgdGhlIGNoYW5nZXMgYXBwZWFy
IGRpc2pvaW50ZWQuDQoNCk9uZSB0aGluZyB0aG91Z2g6IHRoZSBjb21taXQgbG9ncyBmb3IgZWFj
aCBvZiB0aGUgcGF0Y2hlcyB3aWxsDQphbHNvIHByb2JhYmx5IG5lZWQgdG8gYmUgbWVyZ2VkLCBz
aW5jZSBJIGhhdmUgdHJpZWQgdG8gZXhwbGFpbiB0aGUNCmNoYW5nZXMgaW4gZGV0YWlsLg0KDQpU
aGFua3MsDQpLYW5jaGFuYQ0KDQoNCg0KDQo+IA0KPiA+IC0NCj4gPiAgICAgICAgIGFjb21wX2N0
eC0+YWNvbXAgPSBjcnlwdG9fYWxsb2NfYWNvbXBfbm9kZShwb29sLT50Zm1fbmFtZSwgMCwgMCwN
Cj4gY3B1X3RvX25vZGUoY3B1KSk7DQo+ID4gICAgICAgICBpZiAoSVNfRVJSX09SX05VTEwoYWNv
bXBfY3R4LT5hY29tcCkpIHsNCj4gPiAgICAgICAgICAgICAgICAgcHJfZXJyKCJjb3VsZCBub3Qg
YWxsb2MgY3J5cHRvIGFjb21wICVzIDogJWxkXG4iLA0KPiA+IEBAIC05MDQsMTcgKzkyOSwzNiBA
QCBzdGF0aWMgaW50IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUodW5zaWduZWQgaW50DQo+IGNwdSwg
c3RydWN0IGhsaXN0X25vZGUgKm5vZGUpDQo+ID4gICAgICAgICBhY29tcF9jdHgtPnJlcSA9IGFj
b21wX3JlcXVlc3RfYWxsb2MoYWNvbXBfY3R4LT5hY29tcCk7DQo+ID4gICAgICAgICBpZiAoSVNf
RVJSX09SX05VTEwoYWNvbXBfY3R4LT5yZXEpKSB7DQo+ID4gICAgICAgICAgICAgICAgIHByX2Vy
cigiY291bGQgbm90IGFsbG9jIGNyeXB0byBhY29tcF9yZXF1ZXN0ICVzXG4iLA0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICAgcG9vbC0+dGZtX25hbWUpOw0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHBvb2wtPnRmbV9uYW1lKTsNCj4gPiAgICAgICAgICAgICAgICAgZ290byBmYWlsOw0K
PiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gLSAgICAgICBjcnlwdG9faW5pdF93YWl0KCZhY29tcF9j
dHgtPndhaXQpOw0KPiA+ICsgICAgICAgLyoNCj4gPiArICAgICAgICAqIEFsbG9jYXRlIHVwIHRv
IFpTV0FQX01BWF9CQVRDSF9TSVpFIGRzdCBidWZmZXJzIGlmIHRoZQ0KPiA+ICsgICAgICAgICog
Y29tcHJlc3NvciBzdXBwb3J0cyBiYXRjaGluZy4NCj4gPiArICAgICAgICAqLw0KPiA+ICsgICAg
ICAgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSA9IG1pbihaU1dBUF9NQVhfQkFUQ0hfU0laRSwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY3J5cHRvX2Fjb21wX2JhdGNo
X3NpemUoYWNvbXBfY3R4LT5hY29tcCkpOw0KPiA+ICsNCj4gPiArICAgICAgIGFjb21wX2N0eC0+
YnVmZmVycyA9IGtjYWxsb2Nfbm9kZShwb29sLT5jb21wcl9iYXRjaF9zaXplLCBzaXplb2YodTgN
Cj4gKiksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgR0ZQ
X0tFUk5FTCwgY3B1X3RvX25vZGUoY3B1KSk7DQo+ID4gKyAgICAgICBpZiAoIWFjb21wX2N0eC0+
YnVmZmVycykNCj4gPiArICAgICAgICAgICAgICAgZ290byBmYWlsOw0KPiA+ICsNCj4gPiArICAg
ICAgIGZvciAoaSA9IDA7IGkgPCBwb29sLT5jb21wcl9iYXRjaF9zaXplOyArK2kpIHsNCj4gPiAr
ICAgICAgICAgICAgICAgYWNvbXBfY3R4LT5idWZmZXJzW2ldID0ga21hbGxvY19ub2RlKFBBR0Vf
U0laRSAqIDIsDQo+IEdGUF9LRVJORUwsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjcHVfdG9fbm9kZShjcHUpKTsNCj4gPiArICAgICAg
ICAgICAgICAgaWYgKCFhY29tcF9jdHgtPmJ1ZmZlcnNbaV0pDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZ290byBmYWlsOw0KPiA+ICsgICAgICAgfQ0KPiANCj4gSXTigJlzIGhhcmQgdG8g
Zm9sbG93IOKAlCBtZW1vcnkgaXMgYWxsb2NhdGVkIGhlcmUgYnV0IG9ubHkgdXNlZCBpbiBhbm90
aGVyDQo+IHBhdGNoLiBDb3VsZCB3ZSBtZXJnZSB0aGUgcmVsYXRlZCBjaGFuZ2VzIGludG8gYSBz
aW5nbGUgcGF0Y2ggaW5zdGVhZCBvZg0KPiBzcGxpdHRpbmcgdGhlbSBpbnRvIHNldmVyYWwgdGhh
dCBkb27igJl0IHdvcmsgaW5kZXBlbmRlbnRseT8NCj4gDQo+ID4NCj4gPiAgICAgICAgIC8qDQo+
ID4gICAgICAgICAgKiBpZiB0aGUgYmFja2VuZCBvZiBhY29tcCBpcyBhc3luYyB6aXAsIGNyeXB0
b19yZXFfZG9uZSgpIHdpbGwgd2FrZXVwDQo+ID4gICAgICAgICAgKiBjcnlwdG9fd2FpdF9yZXEo
KTsgaWYgdGhlIGJhY2tlbmQgb2YgYWNvbXAgaXMgc2NvbXAsIHRoZSBjYWxsYmFjaw0KPiA+ICAg
ICAgICAgICogd29uJ3QgYmUgY2FsbGVkLCBjcnlwdG9fd2FpdF9yZXEoKSB3aWxsIHJldHVybiB3
aXRob3V0IGJsb2NraW5nLg0KPiA+ICAgICAgICAgICovDQo+ID4gKyAgICAgICBjcnlwdG9faW5p
dF93YWl0KCZhY29tcF9jdHgtPndhaXQpOw0KPiA+ICsNCj4gPiAgICAgICAgIGFjb21wX3JlcXVl
c3Rfc2V0X2NhbGxiYWNrKGFjb21wX2N0eC0+cmVxLA0KPiBDUllQVE9fVEZNX1JFUV9NQVlfQkFD
S0xPRywNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNyeXB0b19yZXFf
ZG9uZSwgJmFjb21wX2N0eC0+d2FpdCk7DQo+ID4NCj4gPiBAQCAtOTIyLDcgKzk2Niw3IEBAIHN0
YXRpYyBpbnQgenN3YXBfY3B1X2NvbXBfcHJlcGFyZSh1bnNpZ25lZCBpbnQNCj4gY3B1LCBzdHJ1
Y3QgaGxpc3Rfbm9kZSAqbm9kZSkNCj4gPiAgICAgICAgIHJldHVybiAwOw0KPiA+DQo+ID4gIGZh
aWw6DQo+ID4gLSAgICAgICBhY29tcF9jdHhfZGVhbGxvYyhhY29tcF9jdHgpOw0KPiA+ICsgICAg
ICAgYWNvbXBfY3R4X2RlYWxsb2MoYWNvbXBfY3R4LCBwb29sLT5jb21wcl9iYXRjaF9zaXplKTsN
Cj4gPiAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+IEBAIC05NDIsNyArOTg2
LDcgQEAgc3RhdGljIGJvb2wgenN3YXBfY29tcHJlc3Moc3RydWN0IHBhZ2UgKnBhZ2UsDQo+IHN0
cnVjdCB6c3dhcF9lbnRyeSAqZW50cnksDQo+ID4NCj4gPiAgICAgICAgIG11dGV4X2xvY2soJmFj
b21wX2N0eC0+bXV0ZXgpOw0KPiA+DQo+ID4gLSAgICAgICBkc3QgPSBhY29tcF9jdHgtPmJ1ZmZl
cjsNCj4gPiArICAgICAgIGRzdCA9IGFjb21wX2N0eC0+YnVmZmVyc1swXTsNCj4gPiAgICAgICAg
IHNnX2luaXRfdGFibGUoJmlucHV0LCAxKTsNCj4gPiAgICAgICAgIHNnX3NldF9wYWdlKCZpbnB1
dCwgcGFnZSwgUEFHRV9TSVpFLCAwKTsNCj4gPg0KPiA+IEBAIC0xMDAzLDE5ICsxMDQ3LDE5IEBA
IHN0YXRpYyBib29sIHpzd2FwX2RlY29tcHJlc3Moc3RydWN0DQo+IHpzd2FwX2VudHJ5ICplbnRy
eSwgc3RydWN0IGZvbGlvICpmb2xpbykNCj4gPg0KPiA+ICAgICAgICAgYWNvbXBfY3R4ID0gcmF3
X2NwdV9wdHIoZW50cnktPnBvb2wtPmFjb21wX2N0eCk7DQo+ID4gICAgICAgICBtdXRleF9sb2Nr
KCZhY29tcF9jdHgtPm11dGV4KTsNCj4gPiAtICAgICAgIG9iaiA9IHpwb29sX29ial9yZWFkX2Jl
Z2luKHpwb29sLCBlbnRyeS0+aGFuZGxlLCBhY29tcF9jdHgtPmJ1ZmZlcik7DQo+ID4gKyAgICAg
ICBvYmogPSB6cG9vbF9vYmpfcmVhZF9iZWdpbih6cG9vbCwgZW50cnktPmhhbmRsZSwgYWNvbXBf
Y3R4LQ0KPiA+YnVmZmVyc1swXSk7DQo+ID4NCj4gPiAgICAgICAgIC8qDQo+ID4gICAgICAgICAg
KiB6cG9vbF9vYmpfcmVhZF9iZWdpbigpIG1pZ2h0IHJldHVybiBhIGttYXAgYWRkcmVzcyBvZiBo
aWdobWVtDQo+IHdoZW4NCj4gPiAtICAgICAgICAqIGFjb21wX2N0eC0+YnVmZmVyIGlzIG5vdCB1
c2VkLiAgSG93ZXZlciwgc2dfaW5pdF9vbmUoKSBkb2VzIG5vdA0KPiA+IC0gICAgICAgICogaGFu
ZGxlIGhpZ2htZW0gYWRkcmVzc2VzLCBzbyBjb3B5IHRoZSBvYmplY3QgdG8gYWNvbXBfY3R4LQ0K
PiA+YnVmZmVyLg0KPiA+ICsgICAgICAgICogYWNvbXBfY3R4LT5idWZmZXJzWzBdIGlzIG5vdCB1
c2VkLiAgSG93ZXZlciwgc2dfaW5pdF9vbmUoKSBkb2VzIG5vdA0KPiA+ICsgICAgICAgICogaGFu
ZGxlIGhpZ2htZW0gYWRkcmVzc2VzLCBzbyBjb3B5IHRoZSBvYmplY3QgdG8gYWNvbXBfY3R4LQ0K
PiA+YnVmZmVyc1swXS4NCj4gPiAgICAgICAgICAqLw0KPiA+ICAgICAgICAgaWYgKHZpcnRfYWRk
cl92YWxpZChvYmopKSB7DQo+ID4gICAgICAgICAgICAgICAgIHNyYyA9IG9iajsNCj4gPiAgICAg
ICAgIH0gZWxzZSB7DQo+ID4gLSAgICAgICAgICAgICAgIFdBUk5fT05fT05DRShvYmogPT0gYWNv
bXBfY3R4LT5idWZmZXIpOw0KPiA+IC0gICAgICAgICAgICAgICBtZW1jcHkoYWNvbXBfY3R4LT5i
dWZmZXIsIG9iaiwgZW50cnktPmxlbmd0aCk7DQo+ID4gLSAgICAgICAgICAgICAgIHNyYyA9IGFj
b21wX2N0eC0+YnVmZmVyOw0KPiA+ICsgICAgICAgICAgICAgICBXQVJOX09OX09OQ0Uob2JqID09
IGFjb21wX2N0eC0+YnVmZmVyc1swXSk7DQo+ID4gKyAgICAgICAgICAgICAgIG1lbWNweShhY29t
cF9jdHgtPmJ1ZmZlcnNbMF0sIG9iaiwgZW50cnktPmxlbmd0aCk7DQo+ID4gKyAgICAgICAgICAg
ICAgIHNyYyA9IGFjb21wX2N0eC0+YnVmZmVyc1swXTsNCj4gDQo+IEhhcmQgdG8gdW5kZXJzdGFu
ZCB3aGF0IGlzIGdvaW5nIG9uIGlmIHJlbGF0ZWQgY2hhbmdlcyBhcmUgbm90IGtlcHQgaW4NCj4g
b25lIHNlbGYtY29udGFpbmVkIHBhdGNoLg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=


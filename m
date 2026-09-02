Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E25C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E436B00C3; Wed,  2 Sep 2026 18:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B562D6B00C7; Wed,  2 Sep 2026 18:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D3E6B00C8; Wed,  2 Sep 2026 18:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68DCA6B00C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:02:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 021A8A3EB6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:02:14 +0000 (UTC)
X-FDA: 85170196230.23.109065F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf21.hostedemail.com (Postfix) with ESMTP id E793A1C0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:02:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcTLNj+D;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljx4TatskMwE0UghqvTwwcrLXVzxY8buAC5kjlwHReM=;
	b=33RjFJ2jzO8dPZjuGlSCkqlZ2NYJ1qkRVtQobzCUy+K2lylSN6ZBj08lv3D/6TJ2rOttAm
	1mlslOpQMZcIZlFN5yfhkRXJ7xwzEImpd9YeWprrCreyy3bDW2XSP4BGWOYf8BaRvML5yD
	0Dly4IzTr2CW3OvB49/l9KCIrPLfETk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcTLNj+D;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788386531;
	b=qxjRlJC14MvhNrILPEufiTn9nvG1WsAZBm+MVtBNIM/o8DXte9wPYJfVy58IXXxg/xyzXH
	LlI6EIyDEt4L0x+XuYWEwG1i1KHdgXJBgSlkwNneKh5U5U2/l3HBknoqkBBvZTU6TVPO1d
	x0rrGIYvj2gAtXYqTViyMUN0LeIVlJA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788386531; x=1819922531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ljx4TatskMwE0UghqvTwwcrLXVzxY8buAC5kjlwHReM=;
  b=bcTLNj+Dtv8bYGJ9TOWeOcqEXbqCKVVXl20FZ5tOeN6LZxrO3ffjrlzu
   rJlkJYStU0wjuzRmDcf/it6xeWCn24oxJ3JAdsJ4hsPsAv3eJYHmK04S+
   74ot5V2Gnp+vcMrHK6RdLZjDTVHo8HATK2FVfxF6gWvxRi8DGUGLRMYqo
   yTxybvUDMBTj9pax6IRD+Ey2HkR760BYXoijIOXIMisNMPMcfiSla2ePW
   zOy2/KwWAa2I+s4aPaw5yi5JkoFIicMwd12zk8IGrrhPEZ9XNy/HbmcH1
   ekUqNN62hoaaAgrtdT6bWrqU4ljnVKuHpwVjLKNEzr3e16BdxWd/bWOSz
   w==;
X-CSE-ConnectionGUID: TMupzN9vRdO2sgo10qvYRQ==
X-CSE-MsgGUID: svIJPx9GQAazCJmVQYSmUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="114398664"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="114398664"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 15:02:10 -0700
X-CSE-ConnectionGUID: lilVeJxLQJykwMl6wQQRJw==
X-CSE-MsgGUID: EbQ+EszATy2lCv+lRDtChg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="263364161"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 15:02:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 15:02:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 2 Sep 2026 15:02:09 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 15:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlHsqQTJ8sesM2Oqd/hKABzMOEsl+YTvSWnziidLjWOdULE4X98VD+GzTkZybeYOBrCQojdh8CLYaEhjjS+vWsxWWXKWQBsEYOkDpHAuxB6QnVRZEJGqHh+7Re5+hX3k72ljhK8x83GG3TCqGL/GwgLYohgyxXWYSHtk6zkXe/8rY+i6uhpqExCuO3XoKcV8GxKlrAP83T3PcPcFnJNnG5iC+T8HuPnIH24WJossfIEcSujzxvxxuXSVKb+ynwZ7MlTFQHSEkDKBYQw3YM1Gw/8gaXM8Mk4FzR2D7ettSoqDFGt7u2ULDB0lvZlF79OBTH+dMNkmfcj7v7LHwtbktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljx4TatskMwE0UghqvTwwcrLXVzxY8buAC5kjlwHReM=;
 b=FO+iVTJnO/sMzhWfYIyuKYz2G2+mOBGw7gleExTbeiAw2kHwompt86kLksBK3ShWczCfzes/MI5E1/Xp0vwl0cWMTPT0ofZTwX3MAr+Sx6iMCDEWXuVwHZpciVse1dpXIi8FilAQb4ggQiMGQTpeXRgW4jHST9rEn+q5rZa1zOQCsZ1d2/5X6Iog+QczaoOmpI73e78olOiy/i3PuwyfPmLdFmN8K96QnX+y3sIc7704a6PJJWTzHEGQjFeWk0juhKtN+nQahRyCWw4guSFhJQHhIPrb4RWO5fH6J1leMcYw2vGr3xHzcruZ48kE7afzkTZd4+AHpRz7gkXozqml3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by DS0PR11MB9479.namprd11.prod.outlook.com (2603:10b6:8:296::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 22:02:03 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 22:02:02 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>
CC: "ryncsn@gmail.com" <ryncsn@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "weixugc@google.com" <weixugc@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com"
	<yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAAAX2A=
Date: Wed, 2 Sep 2026 22:02:02 +0000
Message-ID: <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|DS0PR11MB9479:EE_
x-ms-office365-filtering-correlation-id: 527aee36-f0e0-4f29-69bb-08df093dd16c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|38070700021|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info: ePiBB5zeOzOdnk989s15ubD0//LgXYnf7zLx6D8qcYKT1D9RjhF0UUEPACKH3eLnqTBGpO1mzHxNXgh9jhUF71doF29MpBdkBUMU2Aa5jpGrIlkTxQuNxZJZ+CrIcFs51X06jIc8x6OFQN5uNiNU4ttrJuLrj+9mWP4th9gqRRw2zTINbv6KdztBpH5ispuD85kKDn7b2lN2RVBSUUeAEN0LGPeJVl3l6mtP8+iCyigeQJ/qRYxufZuYDUzDcTGHIXBVpUpDGxzmn5grSfgu0rPl/OraveIyqEDqlb5Rbf3WdyK7dnkLQ7UFwR/EL5+5/EGWvlfEulJ6qJUnURQ2D7uEh7iqvWj2pQX1WQvLy8IfLsWSedlfz8zdhvIlCKkQFAFhkF0sHPo3dBu7MgXy9exNezjDDEkrdzR2W7zhsJ02FAYLo3RpF7ej76SvKIROO+IB24io3wLKiNxHdCM3tiD7uOvIi59KdPJhwg4akyIrd8qmUtWxPCD1qESsu6YxLrmh6TigX+jM4fzJoc1yTwbth4lN1j5MYI7wAy1vb8UbxW0gEpqdQUu7dw957jl9XfokdoDTeYO+ObKdFWS1iWxrBrjDFzXr2n8yidEmgLtIAqvLCfns/kxNNSxdjJvXTdrqQ8NGPg8UM+zXNQgoer169j2SaQhck31KEu5uzucOAXMSPY/uiEdYv40fEpFriAzxDujj/qkQXVOsR+uj+6k/nw7zJQw83Sr2cS18Au4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnI0eHZhQmNoTU80d2dTVFdub0pNNnJmWWJqZERFcmhxTmJ4eE5jWWZxZ3Rl?=
 =?utf-8?B?b3gzV1dLNGdiRUxHOStNTzBWRnhIbGhOcU1yamRxTnYvNU1vVXpFU2RCdlNV?=
 =?utf-8?B?UVRMOWdSckZmVE5zOVNjQnJ6RE1WZW5ZY1lyaW1CYlRER0hKc1dSeDM2akVC?=
 =?utf-8?B?Y2czM2xSOUpvR3REMHdHZHFRYjJYZDlhR0RtamY1MlZZTFZYdEdnWHllTWVv?=
 =?utf-8?B?YVVpK1hYalRuc0xZVWsvN1BSSDdMMEZpWUpFem9kVk1xTVNnTTFzQVJSZDR5?=
 =?utf-8?B?cEo2OWxMOVEwNWRpWUN4UktZR05Rb1A5NUtLS051a2Y2QTB6S2Q3c1E0NVkw?=
 =?utf-8?B?UzVReHhEbE01M05lNERpWU81YWdUTTU4Sm10SWc3aEVLNjBZSjBhQk90SW10?=
 =?utf-8?B?SEs4NVR5RDZ1VitrMDNvb1ZWQkJ5RVZkeGlva0gwRVFqclFTNnpuQm9kSmFB?=
 =?utf-8?B?aHdiVnU2WmJmVGhBOWVRSTZiWjZUQ3lLUVdDWmJ4eHFESUVMalNxNkE5Y3FG?=
 =?utf-8?B?emc2a2gxWnowRzVjVXpZRHBsNzJ2M2xzOXBRRHJkYno1WFVDbGZpeDB4YTJq?=
 =?utf-8?B?dVhqMVhjSkNvREpaZjFPTnltQVAxZzQ2SkhDMkxJRVBMQTJ3R08xejVyVTdB?=
 =?utf-8?B?dkxoR1V1ZXRZQi9sY2dRM2xXUVhVVDFwcFFpZmlaWVBFK1FVY1NwSmZGRGFU?=
 =?utf-8?B?N3BaSUlXRXFSWUVMMXgxSlVwZnVqNTNuamlNOFV5R0JyVHN0a0IvYmM4ZjAw?=
 =?utf-8?B?Y3JGMWw2NnQ5emRsMTJkMmV6SDBVYngyeStKcm1UT3FtVHhZMGNvZXhyZjBK?=
 =?utf-8?B?UGFCZCtWeDVOUzFDRlMrNWJzdGVqMEZISGJyTW1tTHhMUXZSWWF0Um5DWm8z?=
 =?utf-8?B?WGVwZGdLaWd2NVdJSEMxNmhndzJXVUtDL3AzcEhqSG5lU1hzSzloUFdxclRO?=
 =?utf-8?B?d0ZFMi9ZdmwvTlg1SXRZdkR2ZGhBR1MyUlVoYmR0bG9MUlJBQlVQRCtWUEtT?=
 =?utf-8?B?Rk9GYnl1ZVJYb3J5WkJOWDZMUjJSWWRQS1BmR1dCd1NNb3BxT0NHNHZaNkRt?=
 =?utf-8?B?dTF2dGFCU1lEeDZ4UG4zN2hMRUQ1Y3ltbUJvV0podmUxRjRDVHJlRS9oTXBa?=
 =?utf-8?B?ZjFUWCtIT3BHaFYvMkIyTER1UFlrdEliaDN3b3RHS1BHdW1qWDYwZUpVT2RE?=
 =?utf-8?B?Vm9pM2E3OHduWU0xSmRQVyt0aURqeG14ZjVYb3RGZU5JN2NKZHROTVU5aVFo?=
 =?utf-8?B?ZzZqN2xlWjZ6Y29HZ251ZEJveHJyaStmT0M0WDdPTDA2SGZWRE1kazFrQzNh?=
 =?utf-8?B?Qmp1ajIrNEF6U2VpZHFmUDdxcUNKcFNZWFU1VUZpZUZEQzBTV0ZncW1rSGUz?=
 =?utf-8?B?aXZ3cUZFQkhZSmw2K2dFSTNrUzUvQzJKWTRtdm5iUzVtcUN2TFdiUFdVbWFF?=
 =?utf-8?B?SlZGQzRONEVxTlZSVUpZQUMrUDVIK2RNczcrRHFSZFdwSW9BczNrUGhZcExQ?=
 =?utf-8?B?SXQrNGFFWjZzYVBVM2RrNkkyeTZoRUx3RUx5VmRScGdCUzhVQnNHUlcrc0hx?=
 =?utf-8?B?SlVrb1hkRmRQeVhlZmxCSGdvOElNYStmb1g3VkQvS3g1dkJLc3RCYjAxdWNM?=
 =?utf-8?B?V21reEVsZjZiKy9WdVZueHBOeXdqWEVDUnlqQktRTUI3a3c5alRnMlNkR2FQ?=
 =?utf-8?B?RmNqL2w0ZFRLcDAxY2tZb0RSWFNQZVkrbGtyd2FkZG1DczVqa254SDA3UFZQ?=
 =?utf-8?B?QlplUkxRTnBBWEJhWWR1eXdPSXhGV2ZwNm9zb1hFVHdQNmE0Z2dMZ0lOVk0y?=
 =?utf-8?B?MjdvRDVUL1F1RVZma1c1TjFtS3k5OG1BZzFsV1o3NW8zckNrT1VVNGhUQ1FH?=
 =?utf-8?B?NlppM2dsRjI5V1hpWjN3WWdaOFJhWmxlOFBRR0U5Tzg2NzgvZ3AxRUxZbk1C?=
 =?utf-8?B?dEtERlhhbDdPWFJjNzFsOHRMNUFoMnFlZTNVWC80UTFCRjA5b1NjY2RMQkFQ?=
 =?utf-8?B?UU1KL0lpVzNLNkcrb2JUb3YyeU1wSnJ1Y0N6R0w3ZW92WGIzd0tScmlGSTdC?=
 =?utf-8?B?M0lSY3h2L1M5Q1dpWjE0eE5mNVM4bFBJSFpwNnpFNFozb2t4b0lXRzRUMWZw?=
 =?utf-8?B?eE43dnBIU1k2M0MvdmozbGk4ZWh3TGszbk5uMmVOL3hvUzBYRlVZWERIUWFW?=
 =?utf-8?B?bzgwamxSRmY1VStuTjUwU3ZYZGpMM3dtTDkyWDExQkYvMGRtTDlvdkxCRGIy?=
 =?utf-8?B?RVJ5bmJNOXg3RE1idHRudXhjRkt1dnpXcDVBTzFzWjRKaDNQNG0zR2lreTRq?=
 =?utf-8?B?eDVhTEJUL0lEZkJsVjZSWnN6UWxBeEhuMDNOTklYak84Q1h4eWhLdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: b1BoQu5uAlUqEUK92oVWOJkjM3IUN+e6ELB53rB18lBujo8pqE4FiTRodRYtC9O/C7oc9cmmv/IbVW0w5e57sA+mMd71PUPa4MlCym4y8/7ilXJ1wuCKAwkvjtHDZeafVEtqctd5gVYrZzMk+nqlrN+GUdYuNItCizbzpj0hO2YY1KRMYb2gIQJ0i6i/+6I5rGvDaBhATtejSKEGAdn0O7YiUVAUfxNiuDfDgxDI4eeCN0TNW+Zm3dNxjOtKNXjFeTkEupLIkst6Eol6UNxKvDi3xyEjcR/ERaCvFJr1Zv9T3DomSBMOxQ3Q93PfKhHoYz1aUB4GKkYeQQfjYUpagA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 527aee36-f0e0-4f29-69bb-08df093dd16c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2026 22:02:02.0948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: or59AIk6Uzdi8PQKwzVZCFbczY44MTnKHRfoqc2zBc6CEDUTVJL3kj01fwuOesQCQrnqZZusmlMDkWzTvQlCdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9479
X-OriginatorOrg: intel.com
X-Stat-Signature: 6urm5b7iqpzmpp573qm5yxwriion68qd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E793A1C0004
X-Rspam-User: 
X-HE-Tag: 1788386530-790433
X-HE-Meta: U2FsdGVkX18AkRp8vEUugIWPKyTxdW0Pt4cvBB1q6sVbIpt3quUCNhi3YWafyC6uURMNnPeTcN18wIRDW6bXNL3uXBSaImDxYmm5tmbWIaAUb19PP7yPPtgmSQy8l95eWF7ZRyQJT9iW+bJipRp2ZkrBuWpudGN86VEoW5oL/DRfoU2R/pdK9a/H5KxiF2EMtAXrvvVEtxbir8UGJJIIduUXtx9Wb2f++cns9hxhiwXhWxryYYzWW9vjyEoVasgzcox7rqL2sy6/Vntr0XOTVtjoDrGup9l7KPYUCSaHPysJ0Ahpjd5Ld3qPRxtMjhwjI9DjHUkemik1Y1a1KEVXlRrYrVybqj8IZTSlSd9QyRPZvuu/qiCRKNeJvehIyVQVpx+3xNSUYQjExxrDwdfODDFX5Xh3yFxfUMbBkOq1cpRtVCxUzZ4v3l4hh3l5yQheu3/7sRf6zFJ2eDzZtUogrzhJZNesATKHT+TCwhyEFyINZGQInCfLhZE6S++j8ADPnJLKJl6Sh5UXMjmDpfpuTh2zeB01Amfr99ZlA22omsITbVagb2iZ+g2iJuBJNfIj8uPM7p5Ok3SeLCRBC92Gw6WZQUHuw0lyMUdqJcF3DlEEuEtj+yi9SION+9IXziajfit0Oc2WSHcanaBZjH+4hgGI1QUqHtR/zcv0vrmci3taNTrbxe1QkI11d3d5s5Z3MyCszNy3FnsVKtLmfKmd/VvnivM7epwITmOs/lpml8TR//jO2ke0/D+Gxf4atOHjrg+JpjlXKxS9od6xcQ+1i5bQugpAR1m5YWvSG0NhyYOHuJFSnPrYI2ADauAYbO7XoxTqdBz2V1R2ccDhRiRcqbL8M5Rqs/KtMlv8VnU73s15TmHphBib+1mcI6qzVOprwdEQLPuwpPYhxAD6bhrotSTSOHJtHjTcVVtUl7lngegNQwCNSKEfo4edjH+syijgk/OMcIIGrkWfLuxyGDW
 49tkJkZL
 NW103Z8isFq4BR5bIrvpQY0IjLT/VRlhVGnLvUx99nQGDb0iWSxAklqEtxXJUE+Y02ThhnhdHW0kXz/9ulDOSTSsKpoWr6c39b8a7z0ZptHoKwbR645nqtVk2gr13IKdg4H5hLfb6hM6GAniFlJWNcZ4kjJ/7kMRDauI0fkzu2B5EK1dTq1QJ+ffbIc1LkjpjmQyfte0uFgOv9Jcw5H2saLMux5lLEnNwxu2z+QmBCIyepJYZyDw6MOjWzkiSHN0Akh7NnvNWBegNggYZZ9uy8qh1U2sBsCjwFMfSxcAoq3KNg6qByyKzCuTjwSSsZEEQSBAXBMK9BUSNENwag4dOpAqy3FgmVfzBGuixDlDBSJ2yrtg89hxLSwxf2CtBTKJwYhOQlV5iTBgewejY98K1hLQuSSxmjSvOyhGDxaOU3lN9YyWMptZ5bYFA/RtYtOay3CQWeACI4/4Mtc17mthLwWui7GtGLi1pEvToT5Xem0VMb53eXpu9XGwShy5LfKPG2M3qyHJ+Br9GheZW+E+0Pw2TUFEfNLmm6fgs7v3AHUiW2G/5v7qpX1k0E3oy8Gxaqlf0aQKPaLsGbc9KY5nrOBxttlBVg7ruvD8ufQExu5G7dt1t5Es9ah1eomVDUYFO4Um9TflOk3ODRGUYPuraVvs5hP6ef8noYhxfncpFq5VoCT6LusQO7tcII5w4/NR6QTcozhGsZTd0K0LouTYOWjK17i0kFijETMaNPzdPJFg91XAeK8MyvB5Knz6g30z7DkV4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFycnkgU29uZyA8YmFv
aHVhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDIsIDIwMjYgMjo1
OCBQTQ0KPiBUbzogQWJhYm5laCwgRWhhYiA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT4NCj4gQ2M6
IHJ5bmNzbkBnbWFpbC5jb207IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IGF4ZWxyYXNt
dXNzZW5AZ29vZ2xlLmNvbTsga2Fzb25nQHRlbmNlbnQuY29tOyBsYW5jZS55YW5nQGxpbnV4LmRl
djsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOyBx
aS56aGVuZ0BsaW51eC5kZXY7DQo+IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7IHdlaXh1Z2NAZ29v
Z2xlLmNvbTsgeXVhbmNodUBnb29nbGUuY29tOw0KPiB5dXpoYW9AZ29vZ2xlLmNvbQ0KPiBTdWJq
ZWN0OiBSZTogW1JGQyBQQVRDSF0gbW0vbWdscnU6IGR5bmFtaWNhbGx5IHByb3RlY3QgcmVhZGFo
ZWFkIGZhdWx0DQo+IGZvbGlvcyB1bmRlciByZWZhdWx0IHByZXNzdXJlDQo+IA0KPiBPbiBUaHUs
IFNlcCAzLCAyMDI2IGF0IDU6NTLigK9BTSBBYmFibmVoLCBFaGFiIDxlaGFiLmFiYWJuZWhAaW50
ZWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEhpIEJhcnJ5LCBLYWlydWksDQo+ID4NCj4gPiBU
aGFua3MgZm9yIHRoZSBmZWVkYmFjayBhbmQgc3VnZ2VzdGlvbnMuDQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBCYXJyeSBTb25nIChYaWFvbWkpIDxi
YW9odWFAa2VybmVsLm9yZz4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAxLCAyMDI2
IDM6MDUgUE0NCj4gPiA+IFRvOiByeW5jc25AZ21haWwuY29tOyBBYmFibmVoLCBFaGFiIDxlaGFi
LmFiYWJuZWhAaW50ZWwuY29tPg0KPiA+ID4gQ2M6IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7
IGF4ZWxyYXNtdXNzZW5AZ29vZ2xlLmNvbTsNCj4gPiA+IGJhb2h1YUBrZXJuZWwub3JnOyBrYXNv
bmdAdGVuY2VudC5jb207IGxhbmNlLnlhbmdAbGludXguZGV2OyBsaW51eC0NCj4gPiA+IGtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgcWkuemhlbmdAbGludXguZGV2
Ow0KPiA+ID4gc2hha2VlbC5idXR0QGxpbnV4LmRldjsgd2VpeHVnY0Bnb29nbGUuY29tOyB5dWFu
Y2h1QGdvb2dsZS5jb207DQo+ID4gPiB5dXpoYW9AZ29vZ2xlLmNvbQ0KPiA+ID4gU3ViamVjdDog
UmU6IFtSRkMgUEFUQ0hdIG1tL21nbHJ1OiBkeW5hbWljYWxseSBwcm90ZWN0IHJlYWRhaGVhZA0K
PiA+ID4gZmF1bHQgZm9saW9zIHVuZGVyIHJlZmF1bHQgcHJlc3N1cmUNCj4gPiA+DQo+ID4gPiBP
biBXZWQsIFNlcCAyLCAyMDI2IGF0IDI6MjHigK9BTSBLYWlydWkgU29uZyA8cnluY3NuQGdtYWls
LmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9uIFR1ZSwgU2VwIDAxLCAyMDI2IGF0IDEx
OjA2OjQzQU0gKzA4MDAsIEVoYWIgQWJhYm5laCB3cm90ZToNCj4gPiA+ID4gPiBDb21taXQgNmNi
ZGQ5NzI2ZmI1ICgibW0vbWdscnU6IHVzZSBmb2xpb19tYXJrX2FjY2Vzc2VkIHRvDQo+ID4gPiA+
ID4gcmVwbGFjZQ0KPiA+ID4gPiA+IGZvbGlvX3NldF9hY3RpdmUiKSBpbnRyb2R1Y2VkIGEgcmVn
cmVzc2lvbiBmb3Igd29ya2xvYWRzIHRoYXQNCj4gPiA+ID4gPiByZWx5IG9uIHJlYWRhaGVhZCB0
byBrZWVwIHNlcXVlbnRpYWwgZmlsZSBhY2Nlc3MgZWZmaWNpZW50Lg0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gVGhlIHByb2JsZW0gaXMgdGhhdCBNR0xSVSBjYW4gcGxhY2UgZmF1bHQtcGF0aCBmaWxl
IGZvbGlvcyBpbg0KPiA+ID4gPiA+IG9sZGVyIGdlbmVyYXRpb25zLCBzbyBtZW1vcnkgcHJlc3N1
cmUgY2FuIHJlY2xhaW0gcmVhZGFoZWFkDQo+ID4gPiA+ID4gZm9saW9zIGJlZm9yZSB0aGUgd29y
a2xvYWQgdG91Y2hlcyB0aGVtLiBJbiBvdXIgQ2Fzc2FuZHJhIHJlYWQNCj4gPiA+ID4gPiBiZW5j
aG1hcmssIHRoaXMgcmFpc2VkIHA5OSBsYXRlbmN5IHRvIGFib3V0IDkuMi05LjUgbXMgYW5kIGN1
dA0KPiA+ID4gPiA+IHRocm91Z2hwdXQgdG8gcm91Z2hseSA0MS44ay00My42ayBvcC9zOyB0aGUg
cmV2ZXJ0IHJlc3RvcmVkIHRoZQ0KPiA+ID4gPiA+IHdvcmtsb2FkIHRvIGFib3V0IDUuNS01LjYg
bXMgYW5kIDUxLjlrLTUzLjFrIG9wL3MuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBSZWFkYWhlYWQg
aXMgaW1wb3J0YW50IGZvciBzZXF1ZW50aWFsIEkvTyBhbmQgbW1hcCBzY2FucywgYnV0IGl0DQo+
ID4gPiA+ID4gc2hvdWxkIG5vdCBiZSByZXRhaW5lZCB3aGVuIHRoZSB3b3JrbG9hZCBkb2VzIG5v
dCBiZW5lZml0IGZyb20gaXQuDQo+ID4gPiA+ID4gVGhlIGdvYWwgaXMgdG8ga2VlcCB0aGUgb3B0
aW1pemF0aW9uIHdpdGhvdXQga2VlcGluZyByZWFkYWhlYWQNCj4gPiA+ID4gPiBwYWdlcyBhbGl2
ZQ0KPiA+ID4gZm9yZXZlci4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoaXMgcGF0Y2ggcHJvdmlk
ZXMgYSBtaWRkbGUgZ3JvdW5kOiBrZWVwIHRoZSBvcmlnaW5hbCBiZWhhdmlvcg0KPiA+ID4gPiA+
IGJ5IGRlZmF1bHQsIGJ1dCB0ZW1wb3JhcmlseSBwcm90ZWN0IGZhdWx0LXBhdGggZmlsZSBmb2xp
b3Mgd2hlbg0KPiA+ID4gPiA+IHJlcGVhdGVkIGZpbGUgcmVmYXVsdHMgc2hvdyB0aGF0IHJlYWRh
aGVhZCBpcyBhY3R1YWxseSBoZWxwaW5nLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhlIG1lY2hh
bmlzbSBpcyBkeW5hbWljIGFuZCBzZWxmLXR1bmluZzoNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IC0g
YWRkIGEgcGVyLWxydXZlYyByZWFkYWhlYWQvcmVmYXVsdCBjcmVkaXQNCj4gPiA+ID4gPiAtIGFj
Y3VtdWxhdGUgY3JlZGl0IG9uIGZpbGUgcmVmYXVsdHMgaW4gdGhlIE1HTFJVIHJlZmF1bHQgcGF0
aA0KPiA+ID4gPiA+IC0gY29uc3VtZSBjcmVkaXQgaW4gZm9saW9fYWRkX2xydSgpIGZvciBmYXVs
dC1wYXRoIGZpbGUgZm9saW9zDQo+ID4gPiA+ID4gLSBrZWVwIHRoZSBmb2xpbyBhY3RpdmUgd2hp
bGUgY3JlZGl0IGlzIGF2YWlsYWJsZSwgYW5kIG90aGVyd2lzZQ0KPiA+ID4gPiA+IGxldCB0aGUN
Cj4gPiA+ID4gPiAgIG9yaWdpbmFsIGJlaGF2aW9yIHN0YW5kDQo+ID4gPiA+ID4gLSBkZWNheS9y
ZXNldCB0aGUgY3JlZGl0IGFzIGdlbmVyYXRpb25zIGFkdmFuY2UgYW5kIHdoZW4gYW4NCj4gPiA+
ID4gPiBscnV2ZWMgaXMNCj4gPiA+ID4gPiAgIGluaXRpYWxpemVkDQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBUaGlzIG1lYW5zIHdlIG9ubHkgcHJvdGVjdCBmYXVsdC1wYXRoIGZpbGUgZm9saW9zIHdo
ZW4gcmVmYXVsdA0KPiA+ID4gPiA+IHByZXNzdXJlIHNob3dzIHRoYXQgdGhlIHdvcmtsb2FkIGlz
IGFjdGl2ZWx5IGJlbmVmaXRpbmcgZnJvbQ0KPiA+ID4gPiA+IHJlYWRhaGVhZC4gSWYgdGhlIHdv
cmtsb2FkIGRvZXMgbm90IG5lZWQgdGhhdCBwcm90ZWN0aW9uLCB0aGUNCj4gPiA+ID4gPiBvcmln
aW5hbCBvcHRpbWl6YXRpb24gcmVtYWlucyBpbnRhY3QgYW5kIHdlIGRvIG5vdCBrZWVwDQo+ID4g
PiA+ID4gcmVhZGFoZWFkIHBhZ2VzDQo+ID4gPiBhcm91bmQgdW5uZWNlc3NhcmlseS4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IEJlbmNobWFyayByZXN1bHRzIGZvciB0aGUgQ2Fzc2FuZHJhIHJlYWQg
d29ya2xvYWQNCj4gPiA+ID4gPiAoNCBub2RlcywgNzIwcywgMTAwIHJlYWRlcnMpOg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gLSB3aXRoIGNvbW1pdCA2Y2JkZDk3MjZmYjUgKCJtbS9tZ2xydTogdXNl
IGZvbGlvX21hcmtfYWNjZXNzZWQgdG8NCj4gPiA+ID4gPiAgIHJlcGxhY2UgZm9saW9fc2V0X2Fj
dGl2ZSIpOg0KPiA+ID4gPiA+ICAgcDk5IH45LjItOS41IG1zLCB0aHJvdWdocHV0IH40MS44ay00
My42ayBvcC9zDQo+ID4gPiA+ID4gLSB3aXRoIHJldmVydCBvZiBjb21taXQgNmNiZGQ5NzI2ZmI1
ICgibW0vbWdscnU6IHVzZQ0KPiA+ID4gPiA+IGZvbGlvX21hcmtfYWNjZXNzZWQgdG8NCj4gPiA+
ID4gPiAgIHJlcGxhY2UgZm9saW9fc2V0X2FjdGl2ZSIpOg0KPiA+ID4gPiA+ICAgcDk5IH41LjUt
NS42IG1zLCB0aHJvdWdocHV0IH41MS45ay01My4xayBvcC9zDQo+ID4gPiA+ID4gLSB3aXRoIHRo
aXMgZml4OiBwOTkgfjUuOCBtcywgdGhyb3VnaHB1dCB+NTEuOWstNTIuN2sgb3Avcw0KPiA+ID4g
Pg0KPiA+ID4gWy4uLl0NCj4gPiA+ID4NCj4gPiA+ID4gSnVzdCBhbiBpZGVhLiBGb3IgYW4gc2hv
cnQgdGVybSBhbmQgZWFzeSBmaXgsIHdoYXQgaWYgd2Ugc2ltcGx5DQo+ID4gPiA+IHJldmVydCB0
aGFuLCB0aGVuIG9ubHkgcHJvdGVjdCBpbl9mYXVsdCAmJiBmb2xpb190ZXN0X3N3YXBiYWNrZWQN
Cj4gPiA+ID4gZm9saW9zIHdpdGggUEdfYWN0aXZlPw0KPiA+ID4NCj4gPiA+IEhpIEVoYWIgYW5k
IEthaXJ1aSwNCj4gPiA+DQo+ID4gPiBUaGFua3MgdmVyeSBtdWNoIGZvciB5b3VyIHJlcG9ydHMg
YW5kIGRpc2N1c3Npb24uDQo+ID4gPg0KPiA+ID4gSSdtIG5vdCBxdWl0ZSBzdXJlIHdlIHdhbnQg
dG8gcmV2ZXJ0IGl0IGVudGlyZWx5LCBhcyB0aGF0IHdvdWxkDQo+ID4gPiBpbW1lZGlhdGVseSBy
ZWdyZXNzIHRoZSB3b3JrbG9hZHMgaW1wcm92ZWQgYnkgdGhlIGNvbW1pdCwgc3VjaCBhcyB0aGUN
Cj4ga2VybmVsIGJ1aWxkLg0KPiA+ID4gQWxzbywgZm9yIGV4YW1wbGUsIEthaXJ1aSdzIGNvdmVy
IGxldHRlciBtZW50aW9uZWQgdGhlIExldmVsREIgYmVuY2htYXJrOg0KPiA+ID4gICJJIGFsc28g
cmV0ZXN0ZWQgdGhlIExldmVsREIgYmVuY2htYXJrIGZyb20gdGhlIGNhY2hlX2V4dCBwYXBlciBb
NV0uDQo+ID4gPiBJbnRlcmVzdGluZ2x5LCBtYWlubGluZSBNR0xSVSBhbHJlYWR5IGJlYXRzIENM
UlUgb24gdGhpcyBvbmUgYWZ0ZXIgYQ0KPiA+ID4gcmVjZW50IGNoYW5nZSBpbiBscnVfZ2VuX2Zv
bGlvX3NlcSB0aGF0IGJ1bXBzIG5ldyBmb2xpb3Mgd2l0aCByZWZzDQo+ID4gPiA9PSAxIHRvIHRo
ZSBzZWNvbmQtb2xkZXN0IGdlbmVyYXRpb24uIg0KPiA+ID4NCj4gPiA+IEkgZ3Vlc3Mgd2UgY291
bGQgaW5zdGVhZCB0cnkgdG8gbWl0aWdhdGUgdGhlIGNhc2VzIHdoZXJlIHNvbWUNCj4gPiA+IHdv
cmtsb2FkcyBhcmUgbmVnYXRpdmVseSBhZmZlY3RlZCB3aGlsZSBwcmVzZXJ2aW5nIHRoZSBvcmln
aW5hbA0KPiA+ID4gaW50ZW50aW9uLiBEb2VzIHRoZSBmaXggYmVsb3cgYWRkcmVzcyBib3RoIG9m
IHlvdXIgY2FzZXMsIG9yIGlzIEVoYWIncyBjYXNlDQo+IGFjdHVhbGx5IGRpZmZlcmVudCBmcm9t
IEthaXJ1aSdzPw0KPiA+ID4gKFRoZSBrZXJuZWwtYnVpbGQgdGVzdCBvbiBteSBtYWNoaW5lIGxv
b2tzIHF1aXRlIHBvc2l0aXZlLiBJdCBub3QNCj4gPiA+IG9ubHkgcHJlc2VydmVzIHRoZSBvcmln
aW5hbCBvcHRpbWl6YXRpb24sIGJ1dCBldmVuIHByb3ZpZGVzIGZ1cnRoZXINCj4gPiA+IGdhaW5z
LikNCj4gPiA+DQo+ID4NCj4gPiBJIGFncmVlIHRoYXQgcmV2ZXJ0aW5nIHRoZSBjb21taXQgdGhh
dCBjYXVzZWQgdGhlIHJlZ3Jlc3Npb24gaXMgbm90DQo+ID4gdGhlIG9wdGltYWwgcGF0aC4gSSBl
eHBlY3QgdGhlcmUgYXJlIG1hbnkgd29ya2xvYWRzIGFuZCBzY2VuYXJpb3MgdGhhdA0KPiA+IGJl
bmVmaXQgZnJvbSB0aGUgYmVoYXZpb3IgaW50cm9kdWNlZCBieSB0aGF0IGNvbW1pdCwgc28gcmV2
ZXJ0aW5nIGl0DQo+ID4gY291bGQgdW5uZWNlc3NhcmlseSByZWdyZXNzIHRob3NlIHdvcmtsb2Fk
cy4NCj4gPg0KPiA+IEkgd2lsbCBydW4gdGhlIENhc3NhbmRyYSBiZW5jaG1hcmsgd2l0aCBLYWly
dWkncyBNR0xSVS1GRyBwYXRjaGVzIHRvDQo+ID4gc2VlIHdoZXRoZXIgdGhleSBhZGRyZXNzIHRo
ZSBpc3N1ZSBJIGFtIHNlZWluZy4gSSB3aWxsIHNlbmQgdGhlDQo+ID4gcmVzdWx0cyB3aGVuIHRo
ZXkgYXJlIHJlYWR5Lg0KPiA+DQo+IA0KPiBUaGFua3MgdmVyeSBtdWNoLCBFaGFiLiBDb3VsZCB5
b3UgcGxlYXNlIGFsc28gcnVuIG15IHByb3Bvc2VkIHF1aWNrIGZpeDoNCj4gDQo+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjYwOTAxMjIwNDMwLjc5ODEwLTEtDQo+IGJhb2h1
YUBrZXJuZWwub3JnLw0KPiANCg0KU3VyZSwgSSB3aWxsIGRvLiBJIHdpbGwgcmVwb3J0IGJhY2sg
d2hlbiBJIGhhdmUgdGhlIHJlc3VsdHMuDQoNClRoYW5rcywNCkVoYWINCg0KPiBCZXN0IFJlZ2Fy
ZHMNCj4gQmFycnkNCg==


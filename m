Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1076BCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 04:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B258E0001; Mon,  1 Sep 2025 00:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652E76B0012; Mon,  1 Sep 2025 00:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540E88E0001; Mon,  1 Sep 2025 00:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 404D26B0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:57:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFAAA160643
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:57:56 +0000 (UTC)
X-FDA: 83839474152.26.DC3ACF7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C6B5120006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:57:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZfZo+4Im;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756702673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9I7OP7eeeQgwx1Bavsuy31Cxs1uuONIPUOywqSMGqY=;
	b=4cKYli0vlS5dGCXlCIw0cHAy4WCbq5ob9covJpTIW6mz62v1SPv4V1odUBCRiY8NA2mJ8Z
	hrCu6pLKbfPNglp9SqCkijpXcYPz7ZvVF0tIg7Hh94pTOnfBNr1l5Uxo5m+sai8iflPm6n
	ukjJv0YQRjlMdiO5IiOF4H8Ylmk1nQY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZfZo+4Im;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756702673; a=rsa-sha256;
	cv=pass;
	b=SnG5B2gCCsGA6+F01ZlSU0eROc2LyfMDFgQj6rjgclnEe4JFnNR+ZoIBasEdpQnLOa/lyr
	+TkyxqH5qOoMew6z7voyphFYGKbH6SGy+e0P/0vMNs9Yw0M8G7gWy9KmYpcsk5PmPE3kgq
	VBNKvXeU3ierI3tRAnd5ZrpQJwI3fjk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756702674; x=1788238674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=Hw0HqvVSTnE4JswGc2KEpPewJCzvJv51cmbPwBDUmHY=;
  b=ZfZo+4Im7jmYruwbxanzCklP25JVLDX5DfXuBLcA9qolJiPeBr1dc9zh
   N7gLzRiTLubYc7bALy2+N/vb38ksYvQM4t2Ld4fImPe2POlhVfGDGeMW7
   +zolMoDz7uDRhpORo2h6Q93mY4gxNJTSNvsubyrQCHWOHhPcdazmNgcTm
   nRRKDuV9NfE/7tNMQJNO/2zLw1Pwtbw0lktxbJ5YWU8Xl4PHrdbLVuicm
   nQrn3VBfXtv6jP+FuVduO+px14GP30X2lgT1qAv+l8MBKWtdvqYf14QcL
   4uvxbRlJw2l8OpwcyravpC2T4AZem3Eg9deHhT21dSGElHWfJzJMq0gQ5
   Q==;
X-CSE-ConnectionGUID: id/7j5aIRbGGcgWqCO5COg==
X-CSE-MsgGUID: d7QZt7mTS4WwTcynpUom6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81482512"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208,217";a="81482512"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:57:49 -0700
X-CSE-ConnectionGUID: 5aN3qN6cQ0OvZRtvEBsH6g==
X-CSE-MsgGUID: CAf7ZzhcTWODiHNt7Q/P+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208,217";a="175029683"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:57:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 21:57:42 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 31 Aug 2025 21:57:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.86) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 21:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJ5Ve6xusEk6dWUtQi3/buuEIXAuBIAwI5+Swbfhe/E0sPbVDkok74BLZFwZP8ZOuyEPUgcagIO4GGgnyZk64hjsqxUnmnxYaAUM3Op0IsGxHzGzmMyNwi4ayNUUFNYSstoju3RZuJvaMVH+3ul/RKK/qSebOq/qEdBIazObye5GrGP80G/TO+nH2R3e+5JjveWon97UJ7nZFtU4jrks9OhPV0MPfkMabIokOSqEKxzhBc21XXudRX1gCLSqyBF4/wMzkMMoDZxpkAg2r4fpjY0gQn8tqQSD1ppf7XCgdsBXqxRmgENR6fgKOYpLU+1dAB4baT4acws1DIVeCzWMSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9I7OP7eeeQgwx1Bavsuy31Cxs1uuONIPUOywqSMGqY=;
 b=NrkK9PHtTxxlTzIh2NsnNmi+TOkqWJat+/yJUsVHYkVbv2QK4yKzFdM2n7l0RPJFqHQW9EHzKpLRn2p93mDTBQwfmDcz7Lc19b6P9YU9cDZjpwcn+3Xs3CfUr7UCZA9codLIgCakENst2qSFV1sfC6wLjvcF9/HItvdppbCPWIPRgB4k0mxImLeZjT6Wkj2Cr4jUbvUx8KJaiFKsRL++SQfa8qffCX8TplTR32e2HTJPoFfsKtv4H7CWlTfLReR59ZIkly/PJbGB/7ENuYRsxW86CzPgJN4jHKK2thDMUnxzEvgkWP0Vv5Y27/2TRvY3j2n91ICu/TI31j9L+0XUdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 04:57:40 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%4]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 04:57:40 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in
 string boundary
Thread-Topic: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in
 string boundary
Thread-Index: AQHcGu/LBgr506cTwk671GD+LyyI7rR9wsEK
Date: Mon, 1 Sep 2025 04:57:40 +0000
Message-ID: <LV3PR11MB87685BE11603E4C8545549B2F507A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20250830172022.1927448-1-kaushlendra.kumar@intel.com>
 <20250901032320.59995-1-sj@kernel.org>
In-Reply-To: <20250901032320.59995-1-sj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|SA2PR11MB4778:EE_
x-ms-office365-filtering-correlation-id: 8df2ae4f-1fc7-42e3-3226-08dde9141434
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018|7053199007|8096899003|13003099007;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?UGodzFfT7eJ1oxuomrMmZW7v9bi2QOIBlpMXLMBltJbNx3o9788TQZmXOQ?=
 =?iso-8859-1?Q?IJSgxnh5txQkh9b4gNBuqHVTpZCwAvq5bzH4xpC4gKFLCaUQFB3QoBKZSq?=
 =?iso-8859-1?Q?plIISMo3bFWBqj42x9L1Z+DCS6OfZHYMbM6nZD95K++fgzkJfrDpmwoTuP?=
 =?iso-8859-1?Q?Bn4zP2iLc+zhBa+vZya7KMyDRkcVFpDmM/UOtvF6SniAGdjrUjq2WsOT4q?=
 =?iso-8859-1?Q?irXiYgs+5fq3p+M1c5EO3+9VsZlXM0Nxu9YzFcOdfWmYOCfXXlEiEpKXjm?=
 =?iso-8859-1?Q?oP2YAJjaLGFJmtKUzbLFZhScaHipp3tV4mD+3TwLXsftHrX1b+mu3EezTJ?=
 =?iso-8859-1?Q?N1Js0bXKSYf1YAHWTV+skReW6VXV3x3qT+o+yGMn99JQOwcNlQmZuGQJdp?=
 =?iso-8859-1?Q?o2O3WEfc5+Csr7kS75zDIUzlKDX+I1s4VXlym57bYcZCwCHVsfhF7QA5p1?=
 =?iso-8859-1?Q?qDE7NR8Lv4FmGaMdW007W11yZM6HjMRzDHSsQE4errjfBMWMB/xPx8XPpK?=
 =?iso-8859-1?Q?taSFSzK8Y76u29qQG9dQe7fJrSPTTbPzO2gt9QeJCE30hQXWc3gaJsGsXE?=
 =?iso-8859-1?Q?fsewBw71Ud6L8yvgWkRahf0ytupRdjz7yRGli6rwF8+jTEo/IDv6R9MGl2?=
 =?iso-8859-1?Q?nExjMd6uSW/RQdFOrANDe9oqXnbSRKZdZxqNqM5J8ni8fYD1sp5yPlLzY7?=
 =?iso-8859-1?Q?DqagFr9YvEE5CGvlBIwIdId+U7eF9herj9kJ6Gl2RspRkFJ3Ot3R+GwNEv?=
 =?iso-8859-1?Q?HZAbpvLWKGdSnhQZXlyAELM5J6DQpEJoxIzlwAeQXe4Dn6E1LYUpfWoUgY?=
 =?iso-8859-1?Q?tmzsyLPbAkDlUR0jyjV740SKF3GmHSbWYD6iYndGfBNaG+fubQkXbD+Vx+?=
 =?iso-8859-1?Q?o43M7R16N0lw2dEUFuLwLX3bNZ9xCnlR97gWoPLXBg7H9yHD8sRja3Mldj?=
 =?iso-8859-1?Q?mK9IGsx3NoskREpgX23aFGgVJxVEZaiWHWBjb5oN6+eVxuCWAGbFbcySp7?=
 =?iso-8859-1?Q?1Kjq1BIySJfvrwRgEUDlMp083ifEEawgzjMJvpqE7Hhj6GonerlfaxTO9t?=
 =?iso-8859-1?Q?6rtI/eQpzslnEtKWyMah1Kc3/7ByTBx4qsNokY1biv9enh4jIIMkWLqr16?=
 =?iso-8859-1?Q?tJXUHv62kLZRQ7b8BsFKthRHKrwUBHpoE2AmcdS+1wEsnPwV37/E3dmw0F?=
 =?iso-8859-1?Q?zg3RlXKL2cHw2QonbI49i/wq97iCs6ZcYaoFe56rJsWkU6eGqrz4JVkrsH?=
 =?iso-8859-1?Q?hHkk6TuLe5creOO1W90VebYRIihBiLQ5qfHYtZyXEGqkW/NNvDR3neCivE?=
 =?iso-8859-1?Q?HSI0iPMnVZ5JwKJRravJginAre0WH9YcrwkdBDgNDoxbSqpulRSxhZDHSp?=
 =?iso-8859-1?Q?mlN9im1nKm8BHIPJAFI0p+vgu22ON0U12DApccbM5DQnVU/4OsD5lb2hjf?=
 =?iso-8859-1?Q?eYTApAGc8H3QjRU1RE9VJkoBcuf/y48o5qo6baW/jSwqwJ938+s1DtLlcn?=
 =?iso-8859-1?Q?fCOKfPEQH4Hkl7Q4uvMQ3xDZjj0v6YTrNEumvpCxJbG1TPvBVMszSzcZuJ?=
 =?iso-8859-1?Q?aNGJNAQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018)(7053199007)(8096899003)(13003099007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tteexnUCZEIAESS/lFfy7ypNd0UnO8DS3yh9TBU+Uzkhnnk5Nsgd7uwuIj?=
 =?iso-8859-1?Q?8gq5OUrKiqu1k9RioBzc/7D/0YYPEYoUVqmKJIP0zcUDdq+vyEp+OoYIY0?=
 =?iso-8859-1?Q?Xhqb3XNgw/Znk92lvopGguft5xprw2TAxUAl0AEYn1aCsezKfahG7Mv1O1?=
 =?iso-8859-1?Q?LnFXixSJuLFXsifhMDcW+XwOMfjLSqdfmrsEbfIKX/fHEPLsSuQngugw0/?=
 =?iso-8859-1?Q?vTFMVWJHWcBS/1dZ76dmmJIlhXifm+gw7Csl1ESFrUQ0HOlJOSxBGCWeAN?=
 =?iso-8859-1?Q?bklal4I6H8+iwy7daljBfEtV+CMxoGgHgyjMvSnpZGeXhbtDAj/vYA9Thn?=
 =?iso-8859-1?Q?wC1F/LYIhWoIerwQyC4BRXyVVxdjuAibduiuCFK9Xt1GLrAEUl6jISilkK?=
 =?iso-8859-1?Q?uhqP8wZ9chZzVj7etiQ0C5DDR9zTmRlOK5M4bUEk2/Wjz9T1hMmoFDtejG?=
 =?iso-8859-1?Q?YDjnK1qqk96y3o8JG+Vbl3IWKZ8gszpFT4nB4BZd+4XO8OFaTyjZeAi+6Y?=
 =?iso-8859-1?Q?MnVD8/nwItHoiOcWyrPn4NIneOkgTk4GD862xjQMRxnDEiPbrhV5l18ErJ?=
 =?iso-8859-1?Q?zBLdCPV2dtp0e1/q26yu2FHaIbQ0D0vIGVNvPP7AIvL/ch/Md17XtnnMw9?=
 =?iso-8859-1?Q?tcOV6Pax4j4waiCBcTKF26UE6ONqQ0i1xGT3Sib2DM3Bsquemu0bs9Wb2D?=
 =?iso-8859-1?Q?W4OlPeDK8KTp8CiWw/rQeuRsykAX+bYUiZ8Clk5+Ihwo99jNyVWI79LKe2?=
 =?iso-8859-1?Q?Z2GuqrHejydMA8QJZ6PzTXJJeNHzqJYE08M72s0AGwYjG53NSJhdsCF4JR?=
 =?iso-8859-1?Q?hV/gQQJpqXRJkO6HVeDezihM0HGarTH9F4FM4jSpe2ZNM+4+t+1FZoAUAR?=
 =?iso-8859-1?Q?auPA3PAjyM1A5GGioD5CXnAKbTNYLXXWdOZH7Zdmspe5F7k0WKhrFPph72?=
 =?iso-8859-1?Q?f5XVZKxrhIeMDCcw63OEoEI0vsW7MDRyo44GT4zvaBwVFDu+0JYCNMmWZm?=
 =?iso-8859-1?Q?sKcSc0y9/j3CL1NkqQ2LPFmjSThDU8D439Z0hZR/Aqu0J8fTOtaYPryZW5?=
 =?iso-8859-1?Q?T8T139c8MGepObq3hBep+b5gsk39xC1VgpQirvYxFHrSS1GMjLJTZRhWfh?=
 =?iso-8859-1?Q?0mCbpg2LHxGl1f41XUpweVDPg9ggMb9F33QD4jHOlT7+T42euZrh3qGphQ?=
 =?iso-8859-1?Q?REayxg8P4OXR7azoaalzSsuS3jLRiXKYORYDLtNvIIVDgQpKcP3U7bROvG?=
 =?iso-8859-1?Q?M9rphgj4YaQQZux6Gr1QpvB5DW7IKGgpMWzP/wbcoGwfVMnJ8C8qvj1mq4?=
 =?iso-8859-1?Q?OUWgiCVYtX+P3DjK9z1NMSLOycDd27zfnK0rHS/bpt0859Yb2kgoqmF104?=
 =?iso-8859-1?Q?3sLmBCQqj1/3+oyPtpaRXhXCQhoGaNaNuA2PlxW3HS8yaRBd43HZEOAykG?=
 =?iso-8859-1?Q?U0UCdFJO2p3WpryfWqXz5NTwb4N1X0sKRelWon05KfKxV6ppS/FmtcmOMQ?=
 =?iso-8859-1?Q?id0pHQzmAiym2FMfnne0+DVDiD4hjqmagJIJXxAGLuregjFi/zEYQcxJTB?=
 =?iso-8859-1?Q?Smf8ESfDO9aiIeUZLGwC30sYvpeq2wRfrKg8HWx1Hkq3vyYDVJgVuzzxAF?=
 =?iso-8859-1?Q?M+PEKZC82paVHADUa0U4IS/LTDPWbRFoCp?=
Content-Type: multipart/alternative;
	boundary="_000_LV3PR11MB87685BE11603E4C8545549B2F507ALV3PR11MB8768namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df2ae4f-1fc7-42e3-3226-08dde9141434
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2025 04:57:40.4035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWM7n26NExCMZb6SkbIdLM6MQ59SpZxBwvgaphSq2sd5fX3fIyDjM4l7UXY6QTGZlsdWFimKKhTIOvgocDnNKhNmcgi8OPLdrmpJcAaN0+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C6B5120006
X-Stat-Signature: 87dkjiurygwz919z8xtwp7s7riqyosyy
X-Rspam-User: 
X-HE-Tag: 1756702672-800209
X-HE-Meta: U2FsdGVkX1/Pu0ad3VDmFcZTsew414BDjguu85Is20NafgM5ABzod9Le0G9mZCP5q0RGBlhNmpi7Sb7Ea2vgHgnDPR7mNsdYOX7/Yx0x4rD9ExMl0jzxLkt1ag4EJgGzYwkvnFQZ6lDtBv+TC0ItdhT9mcHdJojA8DLBCmGQky2/wlv/cow4Dr6jBEyJIL1e4mx6yWt5uO3Bg6iiiZJP7lZsJNWG9+OxIULrNMx5vFAo0OjraBUs7jMJNabdaVrihx+AOzE0fF/s/p79YLJfIsMIBbxRxyo5WeHfzTaFiSi+duLhHJuwTQqXXGcJReQStCIpuVlrVzwrihmZoB8kxAtqN0tGe88Dl9Mx9wfNTuHIW63yKhHYNHlgT5ZvAYhvwY8JezmYjnTdTljl6s/pfSMXzbLlBiS3L8MVhann4EBpOTBra9YEG9ftZ+XRXLYcra+u+pBp7ppz8kNfBuuKI1SZsgOJOqgyYeppu32VSRCZCkDwU7ajDsnQTV677RNvw4COE1P/NDIZiyy8DeRhCw2G6NynOUKliYxxE1XuX4Pr+k60G7wliciNEz6MXHxEO4JEZXpKx6+DMUeSL6rOaGbvTdEVfWUgFfD1InETzkUVXv0qhIfatXGD0QQ7EZt5dsF0qtSQr5SzqTaBK9R+uIBd2HYuQ1OpAhcCYHFug1RgzOjcLc475aSwZK5E9yfvponrTB/At2RJYJYvzxFv3idf0L68s9RtIbpQf+qSzhCgBnt8Jx6/b0IJTnFSKbB4dKsLIQzhOV+NGe7ZiryKRY+LFx0g14rbWuqf5fRvyYM7Njg1eAtz6KW9Gj0gh9mNwgdgY9ZETev1MnHRjOThCrOVmMvWXP1JhjCWijyiU1VQUZ0FS7pWx1WodZR8KT+InfIZUW+Yr9THDW08gtZZp0m6Lv7DNLa/fOq6nPHGWnEY7OuouSAJu9wHkXNaNPRsinaM1DZhLaWXzr3WeMV
 jje7WeL1
 daRTy0vz7ijyQKFRG0aV7rfexDVIDaTHUIyfpP/gDV2eM/xUAwv64LRvU7t8qCafLQ73GM28/czoMpXF8l//qZZKaLuRtbRs4KZiKfvYCbaDAcLfs7kIpeslh9XkEtUdhZexI28F3ZPLj6FzsGs5/ArhyrtG9bglgsaBjFtrDzgGROLqx4L/jm8HggRNq9eLlp5+VYnRFzPs8c1UzylZMVmiQbh4s+A+A3CzWgm+D/2oYY/ooiP6dUELL7KBW+2WscFhKRgsRsDRsGiBRd3w2sLbOFwDZOb3RKE04sb0prK5u6Q4K/1y/ymaRKAMO8q7RkDclVD9VrJZMS++us+G5QYo9mXOla+xfcX1W08YsyKIPv3EzJQ85Xxl+f8gs/uURBnyam6CAVbVcwk9MQipqyMiFvlX1n+JkgyTf70kxF53g+9mlJnYtPoho/h00NnMQdkfx4XwRNOTcv/apfFONis9sMg3BB3gfAqrCx1uzo78xnMZyqw40nctyGOrzpT3OIRPtTCrovq9wpjV22GDOEzQKhO2ZT12U+mAXeo3HuesI0fzM//SWF8jm82nhRWNr+7LgjoKBpkaNoKln0iC9saGMJ7kKZsUOR0jLbnTkB9Hn8VbTdwww1TT9Wu744IGlmgUMdCz1bo3PxKSCMUwW7njbBnX72WK4ef51Y4q3DUTEbszcDIu7MS56+wegnMBhBHBo/UFfgA5rAV+I+56S7mKKC96EgbItKa1gVggfmglkcRDwkVe5+23pAMVVxjnZ4EYKF/t4sHrc+56wKiu+Gum8jGLPpHQZh+DIJETWy06weOliWbfyoXSmNWVw+fLh/ejyzuA1Ksq7a8IQhSaCSd7CEwkYdMKXaiwnpYetg6Qz8Hzr3xUuUdz6QrZH7StmbC6smzg/Ceg+wMm8IodeG6B94cNlZXPf0A+XiXolIC60XcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_LV3PR11MB87685BE11603E4C8545549B2F507ALV3PR11MB8768namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



________________________________
From: SeongJae Park <sj@kernel.org>
Sent: Monday, September 1, 2025 8:53 AM
To: Kumar, Kaushlendra <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>; akpm@linux-foundation.org <akpm@linux-fo=
undation.org>; linux-mm@kvack.org <linux-mm@kvack.org>
Subject: Re: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in=
 string boundary



> Thank you for making this change.  But, it is conventional to put the abo=
ve
> changelog on the comment section (after '---' line).

> [1] https://docs.kernel.org/process/submitting-patches.html#the-canonical=
-patch-format

Thank you for the feedback! I have incorporated your suggestions and submit=
ted patch V4.
This version fixes an issue that remained unresolved in V3

> I think the above blank line is not really needed.
Addressed the comments



--_000_LV3PR11MB87685BE11603E4C8545549B2F507ALV3PR11MB8768namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
<br>
</div>
<div id=3D"appendonsend"></div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<hr style=3D"display: inline-block; width: 98%;">
<div id=3D"divRplyFwdMsg">
<div style=3D"direction: ltr; font-family: Calibri, sans-serif; font-size: =
11pt; color: rgb(0, 0, 0);">
<b>From:</b>&nbsp;SeongJae Park &lt;sj@kernel.org&gt;<br>
<b>Sent:</b>&nbsp;Monday, September 1, 2025 8:53 AM<br>
<b>To:</b>&nbsp;Kumar, Kaushlendra &lt;kaushlendra.kumar@intel.com&gt;<br>
<b>Cc:</b>&nbsp;SeongJae Park &lt;sj@kernel.org&gt;; akpm@linux-foundation.=
org &lt;akpm@linux-foundation.org&gt;; linux-mm@kvack.org &lt;linux-mm@kvac=
k.org&gt;<br>
<b>Subject:</b>&nbsp;Re: [PATCH v2] tools/mm/slabinfo: fix access to null t=
erminator in string boundary</div>
<div style=3D"direction: ltr;">&nbsp;</div>
</div>
<div style=3D"font-size: 11pt;" class=3D"elementToProof"><br>
<br>
&gt; Thank you for making this change.&nbsp; But, it is conventional to put=
 the above<br>
&gt; changelog on the comment section (after '---' line).<br>
<br>
&gt; [1] <a data-auth=3D"NotApplicable" class=3D"OWAAutoLink" id=3D"OWAe9a1=
8709-08fe-80b2-050c-1c7b8956b267" href=3D"https://docs.kernel.org/process/s=
ubmitting-patches.html#the-canonical-patch-format">
https://docs.kernel.org/process/submitting-patches.html#the-canonical-patch=
-format</a><br>
<br>
</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 11pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
Thank you for the feedback! I have incorporated your suggestions and submit=
ted patch V4.</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 11pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
This version fixes an issue that remained unresolved in V3</div>
<div style=3D"font-size: 11pt;" class=3D"elementToProof"><br>
&gt; I think the above blank line is not really needed.</div>
<div style=3D"font-size: 11pt; color: rgb(0, 0, 0);" class=3D"elementToProo=
f">Addressed the comments</div>
<div style=3D"font-size: 11pt;" class=3D"elementToProof"><br>
<br>
</div>
</body>
</html>

--_000_LV3PR11MB87685BE11603E4C8545549B2F507ALV3PR11MB8768namp_--


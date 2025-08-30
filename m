Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C44BCA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 17:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4FC06B0022; Sat, 30 Aug 2025 13:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00696B0023; Sat, 30 Aug 2025 13:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE9F6B0024; Sat, 30 Aug 2025 13:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE666B0022
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:34:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B462B6BD5
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:34:42 +0000 (UTC)
X-FDA: 83834123604.18.D25F3F1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C201C0004
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:34:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+nzjYGu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756575278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFLap0oiPXUd9zQji3KsoaQIZaP96wcfCugzsI/qdF8=;
	b=YNmcW0jmpbydcTBnReLglKej3BysesIK25SjoZ5OSjogxbJ+J8LDsVA2uT35AeZSlovCN0
	qmmuMYEJ85bOoCvTG5kBYqAAPSi0cCtfvrcG04pdejoIzU0vWFUpGzCQpb/pmTNPFBwRFD
	mK7hm4tysNlR0gxhJd8gSZvilpJ7T5U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756575278; a=rsa-sha256;
	cv=pass;
	b=EgDQbPI1UG3Evck3otvmMVgEL4+VujPK3DFdDM4i8MIM63PvvnSWXWol1SaPhJrdxbkeE/
	WAF+gkNQhcNuC/v3Y8VhL8G27Pbr6feG2nOuj8Teu/5jy93H4i/I0pYDWJLxWY5VKX3XkS
	HJRF+B8TvzHQqCHf67kCdGFO5DyFE6U=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+nzjYGu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756575278; x=1788111278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=vQappeBiUW+lahI+QhKMP3Wyjs78shdXwkLaqkcwlbE=;
  b=W+nzjYGuYpXtqlV8x9dQtO2+6xmVw1pq5REf8AZ7/9z7U7ZbWGHM9yng
   fCveLBjM5FRBuZuSLpPt/+SZPH7fa7p0CtU/hvX5GOVU9s0rqGAAgTNYt
   O+CvODY8pG+SnVEOXvflbN5DGoZIKZSyv33veF2/L4ayR5bAV0cd84nQq
   H0LXN/DFdD4lD9VJ4xAZLmvkqtd9mhmVdqK5yuvUs+j7WWZ1G5OtQolnU
   B1P/E/KtgajnYqJDUs580LWMBsVe6DuLukCXdq7IxgOkLLsHJr0ljt+BD
   /HFuRLfsoLSLweHBUHn9Ul+Y6SLZl1sm5bDbzJA3CDoHpKuJ7NYfLK2sY
   g==;
X-CSE-ConnectionGUID: mvr9rpqlQ0GfG5q4UjhTuA==
X-CSE-MsgGUID: vmmO4WAyTsGJo839d3RcEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="57857682"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208,217";a="57857682"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 10:34:37 -0700
X-CSE-ConnectionGUID: kUKmxhDYSQaliHngpM6WWA==
X-CSE-MsgGUID: N16uRJ3fSEucYrv8PviqVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208,217";a="169923204"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 10:34:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 30 Aug 2025 10:34:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sat, 30 Aug 2025 10:34:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 30 Aug 2025 10:34:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nS6+12N3doooBS/GZF5FfEklBBoy0DfjxhXA1+WopBWuhlFFqbIOWi2O4KwBf1YlDUNudC0p9mJLNkeVUVUjt6yj0CGRqvkYLJc1ay/gy1s5vLxaQp5Q8vFJz4UYN2tNP2J6zhPhg42JcR5qyH2wtk+BuRm8yBVereICUEfNdnQdWPWHwhJ1W+llfyWmKyMFx/oyE18nkDGvwsGkvJIDVF7JQyQ1mE1Qb9oQ2XN+7QM4Bd267T5NmkyCO6+Vm6NSpBFrcL6MS6zdnNmUyaZDWkkLWegTwyEyj9tQZdBEmX2QgQIltEFAOF89qF6vtX43EFjUNHdHbb8bSWRHtBX+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFLap0oiPXUd9zQji3KsoaQIZaP96wcfCugzsI/qdF8=;
 b=wUXZcPIWq6xA66WJKYQXTopKf0n+0NyQRcKvdTCdjbP9wiafLamYmigkJN+C1CLqf6uXnYTPb13kDpLsyY7QyHh4fPCmkXSVrwzPo97Px+VE/IXsNFUQlPbQ+YWBmvln4QQVsD1RLtLN2wbMqYsCSG9xZNtIHguksIdf0Ood+eCKzOEZaFtn2h/rVyj9fA1J1N33TZ94AoW0T9ozGdjJLTt25Xmzw03JWc8Op5ES/nyQ9WpMdZPbD5vgMm/IhaC5bqk0eAs7Jj8y6sUfFiDrZjjda7UEZ6Iq3Tqk6iTDnHS5IbQvEi9hj+80pBJmJmfe45h7xkSBSzFPmf26Q1l93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by CY8PR11MB7338.namprd11.prod.outlook.com (2603:10b6:930:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sat, 30 Aug
 2025 17:34:29 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%4]) with mapi id 15.20.9073.021; Sat, 30 Aug 2025
 17:34:29 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] tools/mm/slabinfo.c: fix access to null terminator in
 string
Thread-Topic: [PATCH] tools/mm/slabinfo.c: fix access to null terminator in
 string
Thread-Index: AQHcGRokOByLPodwAEmqUlJcnsovMrR7dEeo
Date: Sat, 30 Aug 2025 17:34:28 +0000
Message-ID: <LV3PR11MB87686F53ECF79054F3AF70F9F505A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20250829084738.1349383-1-kaushlendra.kumar@intel.com>
 <20250829192125.60930-1-sj@kernel.org>
In-Reply-To: <20250829192125.60930-1-sj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|CY8PR11MB7338:EE_
x-ms-office365-filtering-correlation-id: c0a7282f-b35a-48e7-a9d2-08dde7eb78fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|8096899003|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?xqsXYy6OxE6zEFBdBoWaBTSqGmXR/IqU2gK2Dr26/OkUxZkwbFLZ6taH+0?=
 =?iso-8859-1?Q?gLmmOscAKNWDu4Psh4xLPVoqTbOd52bNOkLHEgyLC3Pqg5jN/5Rv4vBclQ?=
 =?iso-8859-1?Q?qAu9Fw9U1FW927y1iXXml20dA+fJiyJuoVStxzHAmgb6hfB+iU1yMWySI/?=
 =?iso-8859-1?Q?xYkO2IwMRorb9pbnn35JCywpnHDQgb53SJVJGCt9ymSQ/qC9anqIoEkrak?=
 =?iso-8859-1?Q?hmmcSOBXhgNN0Ft1xf/HQ/2JCtsh9ynxgQo5CBnmvHp9cUAcWUQ1Rd/qMT?=
 =?iso-8859-1?Q?OarvJj+SP/0dbAVo6KTj9TsxprmJq/P+8LQzmAnTgI9G80iEP0/Nu6wXlR?=
 =?iso-8859-1?Q?31/UiZIrYazk52YbYzL2H5SK6VPySihx2+9ykR1cqm0/uXg8b57q7AhfAB?=
 =?iso-8859-1?Q?yAxmHYNzpKxIb9AuPtp3iB3rBZxg0hE7GtPn6Z2flmx14cgrlJZUVdC4Dc?=
 =?iso-8859-1?Q?JOz3CogE1eKPYkudUWzEPcZPPDpiO+4a7xk+m816l5XzqobKyp5/pxtpG0?=
 =?iso-8859-1?Q?wImf5yYYHoBJa0X5TLDROw8ycy6BAxsQqnZhFhMw+UPuk0l/Oklrfm9Iz+?=
 =?iso-8859-1?Q?NHGZvLLUlVbi+QsrZV8W4zs9wnuTv8+rdIj/PwpJkD2sZCaFQTsXTUfCM1?=
 =?iso-8859-1?Q?0AOy8CDXjCyUoQNDKjm1kwMMdfTLvM3yV8ldOsKfvJiC/5I+kG2i8b8l5I?=
 =?iso-8859-1?Q?VltJqovOo/SK0ocFh2DtUqefCiokMwErmcWTk/6JIkiehqjV6VYBvLgIXz?=
 =?iso-8859-1?Q?W80Zzz3G5XHoamCaCCcB49rKXvLMk/sA4c6cGSXzZqX0j2DaRsJXIAoHjY?=
 =?iso-8859-1?Q?MRC741Me7ZrhuFXzqfVB29AYKhPMB0yyEtyukQQ+8biDVzaCyLD25o/Ql1?=
 =?iso-8859-1?Q?c36mYcuChl47bgATYO4JCTGg/eNSvfzRlBM+IR72OCXdw2xEzkL5Rpcs0r?=
 =?iso-8859-1?Q?aZGsV5qaKeSY1GcEdpnmtDr3fFdy7qgeNn3QjQpfgChJYUNICb3H7BAd7w?=
 =?iso-8859-1?Q?WmuAwS1GcSDU/CwTEAzXZBO8ILr5SQBy7yB7Kb7W9/cI0FVvsLejissrwQ?=
 =?iso-8859-1?Q?wM3Wr8gvTD4i9TWLvXq26Wq/+mCxh7pdhwvyW4YlAED74OZmyF7NNtsvBM?=
 =?iso-8859-1?Q?fjfjm2hScxUMnYGMLPNCAZon7860rbgYpgk3EAQvAtwX7ZU7GY6j5NzXiz?=
 =?iso-8859-1?Q?t8yz/iYFb8mFz9oxduHoik2W3K5k2tnYU2dAv5sUk4LHpIDno2TgVOzI0m?=
 =?iso-8859-1?Q?9D9ZN59cacY7b4XoiMo0Io3AM3yuEl2YOn+0nryePhEljUEoUBZ/oKKo7X?=
 =?iso-8859-1?Q?r6j7b+6pP+FdYI9mProPiTRkWfw+GGgDxhuup6JgadlimNdVYROWJLKnDx?=
 =?iso-8859-1?Q?XhPBJJX3SfvHI43H5bu74jRbf9muq3K/tfR9PRp3D4NOxilUy4aeCuC2ST?=
 =?iso-8859-1?Q?A28OLn0AXESPoK3FpTqS2SiVK/XlXfl/PHdZVgysm3fwLdBOXHs9WvzW5o?=
 =?iso-8859-1?Q?pmWDLPVbgagdyR/9nI24lQ2HhyOiAVnNN2XOVQwQ+BdQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(8096899003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BViQ3lbFBBWRe3JD9B/gYOCmGqPfKoNNj/xB+CtfWJiwiBxdVoK9YQ0C7s?=
 =?iso-8859-1?Q?pM2Cg6UHOPq3rZTi1BdysPO4z9xe+o/UHYmWI9gMggo+qDDSFVNiH1xojZ?=
 =?iso-8859-1?Q?PR8zz7qp3LEYH4NDTqAFhjSgzkmO1IxCchuDBPR2J6t1ufHVJThEVPB0fS?=
 =?iso-8859-1?Q?BdbE4bwPGmf8tGkpdDD8nk22mb5rXdhamYXtre79cphfV598Rcmh/oRaP1?=
 =?iso-8859-1?Q?FQtY2a7sd2M/QbRe1mGoN2ZvYInsKReLsYm+W/2jOGMPkhu3CmoxD9eXU4?=
 =?iso-8859-1?Q?VpOcST7W1Dr6b3QNawb1C/1MtcVIt0XN8I6HwjGBf5f3NG/L07gP4f/epU?=
 =?iso-8859-1?Q?GfRQoV+wvGNtKweNSz+OcOnEdrRk99440hMfsUJfwbSv7SUyrhIT3wYuw7?=
 =?iso-8859-1?Q?x05hfJ15zvOmMtfogoFfcv6SZvIoJj+2ckUozOhM7gjaFtUdu0Bfy7s5ed?=
 =?iso-8859-1?Q?bwwu+SK6+Y70xo+k08WAKf7se/gpwCbGOsswRiB4j7W+Lxfm/EGiV5aCnZ?=
 =?iso-8859-1?Q?Z+x/nEttajssMI/8bCz4iyhTmsNKaRay0m6EIqpELllvmbeODjvXleZ7K+?=
 =?iso-8859-1?Q?ghTDjykgzLAkB8jXYmXr+ZsXCU90MS7NPfMiTmIfm2wgGO66rYovujp7/9?=
 =?iso-8859-1?Q?xtdz8XCXPLHqpDCkCNfP98OXTpuq8jArohPHqwPzcTdE0XP3MjjEsuNcFt?=
 =?iso-8859-1?Q?0bKYtGDlwBKDDvDji5TVQrNjGbNt4tJxe3HzC12p84+HbWp5faHuIJqbcU?=
 =?iso-8859-1?Q?Mx6TLgv1GymjiYyVlTW/XXh+Vqc2F4kxvPo7XNIKoIdxLBadeWqZ6MHgBs?=
 =?iso-8859-1?Q?d2cPFdJ/9yKmVmMuwDZmlZLI9vqoBdm5z8OahQpkGSIFrykLu7wXgNHwgn?=
 =?iso-8859-1?Q?MBhB6e9OpJ7ZP4g5rRMHLkIvmBjkY4iELOn5zjCksGEmsgm3VLPvTDV1SQ?=
 =?iso-8859-1?Q?RsvvSKqhwM7xwKmXGAXCIIw3w15XQ3WjDWUe4ONB+yo/3ZUwLxDnfW+Wv9?=
 =?iso-8859-1?Q?f8bjxWnkpe1vcm5r0Xj3URAo+Fgl+HVAODVtr7z1qAoTcN5e7lS5Mmma9V?=
 =?iso-8859-1?Q?ek9X3UjytwvhRbfPHRn45DNwvDPlHp5t5pAoinFSviA2qB10+aM1bYySxo?=
 =?iso-8859-1?Q?SkbTNedaHGQ1EcJYE4vdYk+zM23mfnEysBf/ZEvwnkZ/cIAKrpnl3dtxZR?=
 =?iso-8859-1?Q?AhIzFB2+n1WXrWfzDHKvG4J3siPuksHvsdR0U1sL+4lCCRpICcUEsynMZY?=
 =?iso-8859-1?Q?x402t9h1zZhV20bHQsQhzY3zkQRdJXl+ZR9QQqst81EiqatxhZz7D7ApQx?=
 =?iso-8859-1?Q?7ccmlIhkqdXqiNYpJQdkfGytJmadPnp6jbkW8hsQs50g8n6BQx/+/GnE7A?=
 =?iso-8859-1?Q?dVWYboNA05oUbpjYJr04GBpPDEvRHhRegb7EnKQUFOVf3xD/XA4WYBAap1?=
 =?iso-8859-1?Q?n+FwxIMmsmoWVtRZu/igN5e4LAWfBerdn++uFQCSUBV1Gm8SrgiXeQL8qB?=
 =?iso-8859-1?Q?oLhkONXuI3W58czCr2YAQYYtgZu/9zKRQ18qN150Let3eSE8UPeEC1ToGn?=
 =?iso-8859-1?Q?oHpDO8gy+5J6rOuCcW8HC0/4lKm3VA4We9CJuUhvq/dzEnyoGPvPkVIBsV?=
 =?iso-8859-1?Q?74SZs7Ea8NutdeuhBKScAeQSmEKNPwPqTg?=
Content-Type: multipart/alternative;
	boundary="_000_LV3PR11MB87686F53ECF79054F3AF70F9F505ALV3PR11MB8768namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a7282f-b35a-48e7-a9d2-08dde7eb78fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2025 17:34:28.9123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qTaqWS3aX188mROFC+mASTjYQPg76dyQ2RmfeeV+uOGXxdi1mJOfVaNlRcERf2WHb8dhKeCzldl3xkXUcXNAv7HZTvyvP6L0k6HgqmdT9TU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7338
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C201C0004
X-Stat-Signature: tepessfufz6em9wixap8g48pwkroy1ih
X-Rspam-User: 
X-HE-Tag: 1756575278-534255
X-HE-Meta: U2FsdGVkX1+JzzBFtC2+tjcVXRrgG+YiGIJArUOnjS2q0pWLPe5ob4IDqhW/MKyIja1QLwmyAmomLq4FhlhCNl5IJMd6ta/Ug3GdSxmWd8ZyJT8Ip4mC0tkl2NgGCa5zhp8fzZOAx+Waca0mJ7lWQTfVLUSiZ9TzrUzxDb4oRtJiV00dRgJrIeX+pe/+V4nxdCbsBitay4i/tF/1W7iPeFuKP6agIbZH7eEXe9dDR6VDFOo+jJ866eI4O9Sf/MAToY8dWpaGCVUTQfyxXfEDf7XJ1UE4IR8LmX7QegsSLBSBNuq0DenXUaObulvw+cnm9PAgm4G9FCL2OsO6dJz+K4cfM4o6RNKHxn4J++Vxg/gwNnkm3aCIlY5TObDDAyv9G6ACwUrXK8sFfZ6+z1eWSxwRjY78UVflQjP4hERYvqGpaLCuuhSvwG4JXTuDSV4oLWR9PqshwZ+tLHfRldg72ic8gl7MxETWZFpWzFkHIGEpj7ZPqapxCo4ww8e9G65UwFOgu/zTXUEUZsGF7QFOBHOc828CPbWtY33OT+kVpxKD3CX9raUQYIxKhU4PfafLwyNm4k4MTwo+ZCjCU9gFddWCu3en4j/7c5SjaGHcq2hVTdMpjmRxQzTnz37opyMt7tG1w6YUdE9ORqI15N5Y9BaRvvzDiaB8ggNi+fP7U+AiOlbxUDuXYjTBINahwjGLw6u5sO/R8O6mXoAGxDmol1efKdCix0AsylKyyFp/kj5m4i61dUfBdHGBEn0GKNmI39GDClx+NYvYH3UCnNi0fihl5H+BRxxN1UNMY4IbEIxsNPaGXtJdjSfdc4jYAjq4G/zCHIDNuufd+8qBOVeiGFtFnR8F9PRSikRGQGQZYMWGWUxr73E9WfGmhALtTaPR3ROLLbDFBSucFVIAAgYfNFjengo9QR8/AxQVXGWnyQUmAvnXOXLZ4dC51Zz/MskdGI22CcLkT4scSa9N8TG
 80+g0ajb
 8cMnX1VqxN1p7yPTWEbLIo0mdWGAnIxv3Gu8HeqSbSHpQICNDz1FDeXwZ+Ax1tw1zSdu9jfyGrmQQYgPLcI+gKGYt+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_LV3PR11MB87686F53ECF79054F3AF70F9F505ALV3PR11MB8768namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


> I'd prefer not mixing declarations with statements.

Thank you for the feedback! I've addressed this in v2 by moving the
variable declaration to function scope.

v2 patch sent with the requested change.

Best regards,
Kaushlendra
________________________________
From: SeongJae Park <sj@kernel.org>
Sent: Saturday, August 30, 2025 12:51 AM
To: Kumar, Kaushlendra <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>; akpm@linux-foundation.org <akpm@linux-fo=
undation.org>; linux-mm@kvack.org <linux-mm@kvack.org>
Subject: Re: [PATCH] tools/mm/slabinfo.c: fix access to null terminator in =
string

Hello Kaushlendra,

On Fri, 29 Aug 2025 14:17:38 +0530 Kaushlendra Kumar <kaushlendra.kumar@int=
el.com> wrote:

> The current code incorrectly accesses buffer[strlen(buffer)],
> which points to the null terminator ('\0') at the end of the
> string. This is technically out-of-bounds access since valid
> string content ends at index strlen(buffer)-1.
>
> Fix by:
> 1. Storing strlen() result to avoid redundant calls
> 2. Adding bounds check (len > 0) to handle empty strings
> 3. Using buffer[len-1] to correctly access the last character
> before the null terminator
>
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---
>  tools/mm/slabinfo.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 1433eff99feb..ac0cc6c1c87e 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -165,8 +165,10 @@ static unsigned long read_obj(const char *name)
>                if (!fgets(buffer, sizeof(buffer), f))
>                        buffer[0] =3D 0;
>                fclose(f);
> -             if (buffer[strlen(buffer)] =3D=3D '\n')
> -                     buffer[strlen(buffer)] =3D 0;
> +             size_t len =3D strlen(buffer);

I'd prefer not mixing declarations with statements.

> +
> +             if (len > 0 && buffer[len - 1] =3D=3D '\n')
> +                     buffer[len - 1] =3D 0;
>        }
>        return strlen(buffer);
>  }
> --
> 2.34.1


Thanks,
SJ

--_000_LV3PR11MB87686F53ECF79054F3AF70F9F505ALV3PR11MB8768namp_
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
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
&gt; I'd prefer not mixing declarations with statements.</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
Thank you for the feedback! I've addressed this in v2 by moving the</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
variable declaration to function scope.</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
v2 patch sent with the requested change.</div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
<br>
</div>
<div id=3D"appendonsend"></div>
<div style=3D"font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, =
Calibri, Helvetica, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);" clas=
s=3D"elementToProof">
Best regards,<br>
Kaushlendra</div>
<hr style=3D"display: inline-block; width: 98%;">
<div id=3D"divRplyFwdMsg">
<div style=3D"direction: ltr; font-family: Calibri, sans-serif; font-size: =
11pt; color: rgb(0, 0, 0);">
<b>From:</b>&nbsp;SeongJae Park &lt;sj@kernel.org&gt;<br>
<b>Sent:</b>&nbsp;Saturday, August 30, 2025 12:51 AM<br>
<b>To:</b>&nbsp;Kumar, Kaushlendra &lt;kaushlendra.kumar@intel.com&gt;<br>
<b>Cc:</b>&nbsp;SeongJae Park &lt;sj@kernel.org&gt;; akpm@linux-foundation.=
org &lt;akpm@linux-foundation.org&gt;; linux-mm@kvack.org &lt;linux-mm@kvac=
k.org&gt;<br>
<b>Subject:</b>&nbsp;Re: [PATCH] tools/mm/slabinfo.c: fix access to null te=
rminator in string</div>
<div style=3D"direction: ltr;">&nbsp;</div>
</div>
<div style=3D"font-size: 11pt;">Hello Kaushlendra,<br>
<br>
On Fri, 29 Aug 2025 14:17:38 +0530 Kaushlendra Kumar &lt;kaushlendra.kumar@=
intel.com&gt; wrote:<br>
<br>
&gt; The current code incorrectly accesses buffer[strlen(buffer)],<br>
&gt; which points to the null terminator ('\0') at the end of the<br>
&gt; string. This is technically out-of-bounds access since valid<br>
&gt; string content ends at index strlen(buffer)-1.<br>
&gt;<br>
&gt; Fix by:<br>
&gt; 1. Storing strlen() result to avoid redundant calls<br>
&gt; 2. Adding bounds check (len &gt; 0) to handle empty strings<br>
&gt; 3. Using buffer[len-1] to correctly access the last character<br>
&gt; before the null terminator<br>
&gt;<br>
&gt; Signed-off-by: Kaushlendra Kumar &lt;kaushlendra.kumar@intel.com&gt;<b=
r>
&gt; ---<br>
&gt;&nbsp; tools/mm/slabinfo.c | 6 ++++--<br>
&gt;&nbsp; 1 file changed, 4 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c<br>
&gt; index 1433eff99feb..ac0cc6c1c87e 100644<br>
&gt; --- a/tools/mm/slabinfo.c<br>
&gt; +++ b/tools/mm/slabinfo.c<br>
&gt; @@ -165,8 +165,10 @@ static unsigned long read_obj(const char *name)<b=
r>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (!fgets(buffer, sizeof(buffer), f))<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buffer[=
0] =3D 0;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; fclose(f);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if (buffer[strlen(buffer)] =3D=3D '\n')<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buffer[strlen(buffer)] =
=3D 0;<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; size_t len =3D strlen(buffer);<br>
<br>
I'd prefer not mixing declarations with statements.<br>
<br>
&gt; +<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if (len &gt; 0 &amp;&amp; buffer[len - 1] =3D=3D '\n')<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; buffer[len - 1] =3D 0;<=
br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return strlen(buffer);<br>
&gt;&nbsp; }<br>
&gt; --<br>
&gt; 2.34.1<br>
<br>
<br>
Thanks,<br>
SJ</div>
</body>
</html>

--_000_LV3PR11MB87686F53ECF79054F3AF70F9F505ALV3PR11MB8768namp_--


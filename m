Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C672CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 17:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0416B008A; Thu,  1 Oct 2026 13:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623C96B008C; Thu,  1 Oct 2026 13:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D4D6B0092; Thu,  1 Oct 2026 13:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4376B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:21:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94775404C2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:21:39 +0000 (UTC)
X-FDA: 85274724318.15.535EB07
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23B24140004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:21:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cqWNsrmK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790875296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEbCd+JFY/Wn6WL8qaahWYCiMBzENx300t/BaqFMGQM=;
	b=RcdZplnqPlDac84M3vp2qy8hl+ogZY0vSV9GDlxKtXf45DQBpYVJHlVhtXNJvbRF0QPoS9
	/WIPT0lw2NzooOXIdbq5SdMBrPXNKTZVisGmaLXmW2f3UhsAj/7siIxtRR4C8+CYgSOKpv
	EH8r3F0xTbpODuFvZLeb1Pm5qVF30NI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cqWNsrmK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790875296;
	b=2+0B50J11vr2ytRMY87RwG1d1VqCpKVJOa7P8lc4EMyyPTaruCY1v6F4aClItKk4IBQHE/
	PZh8NK7iOTCZ4/zZLxkN5S3rXUilgXLWDRDDFgf25h0YC3zqZRaNPsEg2vDBGZ1jCI1tvP
	HJkOaqp1IAzlw7QbBfO1SC8ca5lMJB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790875296; x=1822411296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YEbCd+JFY/Wn6WL8qaahWYCiMBzENx300t/BaqFMGQM=;
  b=cqWNsrmK25YM0YPscBBPqx7lxO3apg5x0YKtWBVkaYmPsb2LQS/6r6R7
   iBXeyIlM3CIHpPrKi6l4bPbZvN6aYwyrGxewDrjq34gHoPW2osPvL7oI9
   sLFMNJa1ng/l98K3SsCLa3YWrZUE3oHl5xZ+DLxLj6jvsu2KLDhBuyY1/
   DVSoPEaif9oDeajyBKHcjJDgR0p/c61kQdF14sZLiocpmLG2E3C4QVcR5
   IehiprkkxK89HmHyYpdy2y3msfd5gsEx8Jq85UN2vQr2KX8eVXvmLIlka
   SEsLefvnzSFZueBuj3UBuWh8+KAc4ur/zwxcRC+rHWqGyS7afrjL42ofw
   Q==;
X-CSE-ConnectionGUID: QQMUoYfQS1qEQrG3CePdfw==
X-CSE-MsgGUID: exuiwEfoSsWoN0K7bHCdLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="102163364"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="102163364"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 10:21:34 -0700
X-CSE-ConnectionGUID: 8jQpaWcXTrirnmKX2LDTPg==
X-CSE-MsgGUID: CbyD6iXsSlKTeEB2uJAbCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="59783"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 10:21:33 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 10:21:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 1 Oct 2026 10:21:32 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 10:21:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j28TMOq25B6PyMbcI+z/ZBq7rjuZplZr8sIQBrcS8sF2Idxbln8os8q3EesmedqeT1S5yJxbCtiNjoapPE6e5bnyk6U8PkZsI+YG5xLVTGmxaSAuIMl/1dDPWKmChgKMMdt1ovN0mYHxFmx5ypLN1upgsCNniyy6Y3zvnffvUQhZG32ZSuNQck+vTE3pPo9M0JaZWu8HLNC0ez/LC/GozDxAjPdkdrl0XxA0q1zoP3h8BDF/M4ocPUtKnjW6eU4we3gPlGiishE0shEwcXFIqdoFdNam2QVhXgjfUeYkW3RN6Y/3xeEZDXf/erQlT+P8QcAImo5HfqZFvCDOIEowLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEbCd+JFY/Wn6WL8qaahWYCiMBzENx300t/BaqFMGQM=;
 b=V8/MrUhVhspvImrZVFpbcXHLQyhn60CNjY0E64Le1svUttNPJPI9LtaQUZg5FfuTREzJ2dkOEj61dm4IRbfkaXRPod2XoPSIFbJ6pvdXMjTpoNNnxPicIso7/a7zWQ0FYrgn/o0/P8fx210SeCwb6zEMauOcUWS7FfqnOyl4vY3209QTjCowGXB0Jmo1dAK/X7hG0J4cCo2WZqWELzl664hLE2fiC90fVK3XO70ByjbM+maCZWO8zdZxqZ+rHyYgdQvx8JZs4V5vkuLkcr8GS5kJGwMCUPrzTMMCTU+9gasp/EGA2DnlfqF8wmu3G5JzTGDMBrMtXPlHIEi+gFuz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by MW4PR11MB6569.namprd11.prod.outlook.com (2603:10b6:303:1e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 1 Oct
 2026 17:21:24 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0472.015; Thu, 1 Oct 2026
 17:21:23 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Kairui Song <ryncsn@gmail.com>
CC: Barry Song <baohua@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, Lance
 Yang <lance.yang@linux.dev>, LKML <linux-kernel@vger.kernel.org>, linux-mm
	<linux-mm@kvack.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Yu Zhao <yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAAAX2CAIV5sIIAACU+AgADjkECAAnLsAIAIhulA
Date: Thu, 1 Oct 2026 17:21:23 +0000
Message-ID: <SJ1PR11MB6105221B1EC807109A380C6A8C8A2@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
 <SJ1PR11MB610584E71CD980C9F85952F38C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAMgjq7CMd7v=kYwWGSyt2LmMep6tQcFFsdyBpwc_X+s_Km=rZQ@mail.gmail.com>
In-Reply-To: <CAMgjq7CMd7v=kYwWGSyt2LmMep6tQcFFsdyBpwc_X+s_Km=rZQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|MW4PR11MB6569:EE_
x-ms-office365-filtering-correlation-id: c5c6104b-fc79-4b76-d58e-08df1fe06afc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|22082099003|18002099003|4143699003|10067099003|38070700021|3023799007|11063799006|56012099006;
x-microsoft-antispam-message-info: Xi7JHMbP5zWOX72jqNg2HHENzWFfkZCpYs3jEbjPmYLzb8hiFSPWLKlOmGwzLnGzAT99eMZ8s8WNeW3DkYrHHEN9H7aEuZPJj02QEHLJhR63skh3ADz8nSyE6IE4vBjPpBlymw/74lq5ezV18MgRxG63jVnIJ3VvD3RXvhUDSXybDuGOYpWb2RRHMklN3pq98431No7tmu0338mYiroRMqKoxyxEFOvEbZubwWksXDqt4ngkBxeM89sU7n96pkghqKXoL6RDVbT3XscN/MxGus8eGFEidjEI3qyZx/P2jJwwUwUMzOSK4NnG9j6mttYBMhUMIAazXiXN0Iz6T0eNNfjg9Y/olTj7NHbpSoZxMMssAl/+4Mes/jq2DUYO1LS8lWNP3gw6d/RdUQMehT/lO41A6W3sBIwBcBxOXgSYxiYjzSDoBRGVHToghI/yCBohhzzS8J0wxBZP04zNmZRf/ucPa5eKBOd3IWzMIgX1uepXAwJrwP0Fdnzh4VPUvmyn4syCDlO0LfIDYNPJ2f4OkPRjXrmrQiivyBq90KtxEWERdGYPQlhblCTAnTXcBSRiAjOSTY3Ibz+DBxpN484ULVKP9vkfdXVsVFx7iVjZ8jIxSKtJ7KPnwi27yMdSTrmD7cQZtpFr/cYHcRTwQGWJE/CSAfw5GEAhdE+FEfAwvGgbn4Gl/SVIEizTKIi5mUk+sHRUsg24CRDHY0LMZNFfRyvVBh7+SgONU1i8IDWSAbI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(10067099003)(38070700021)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2RQKytGU3BRWnVIYm1SVzlNM2lKM2EwVFpFRkRpbnJhU2hXNkl2QUlqQTNy?=
 =?utf-8?B?Q21lMTBoemRmUmN2d3k5SkNSWkJaQUNGZ0hFbzZXUGxwRERXVlVEN2N0KzBY?=
 =?utf-8?B?VmZFRE1BMWRtWDBKbyswUkRJLy9JSVVkcGdtUmZ6WWlrMmZNR25hUUMzNm83?=
 =?utf-8?B?b00yY3FRMjZMN1B5ZnRwYlVOejVLSXU0VU5OY0tld0pxZGtuZnR0UGsrbjkz?=
 =?utf-8?B?WC94d3ZzRk9SWlB6czVnU244bGNqekJQNGFxSG5rcWJKSHViNE4wRWpVeTJo?=
 =?utf-8?B?ZFI0a0poOWhVd09BM29MM2tPZDE4ZnBiZGp3elo5QlNIL09xTjVxcGFscklr?=
 =?utf-8?B?NnRRVC8xVUYzcjkrbU1JUGI2M2lTMWlpc2N1bVM3SWFNOWY5Q24xcEpvOW9u?=
 =?utf-8?B?a1c2NTgvL2JVckNUZ29iMGhhQVFtMFRnbnBGbjFocExPQStxci93R05UNlBT?=
 =?utf-8?B?MFF1NEp2RDdCRWE2NzZZZDF2eHpFbll5U3lLOHVzZHlJdkZhT01MT3lIL1lG?=
 =?utf-8?B?V0t4UFBhNVhLcmhuUGtyTEFKNFM0OGxYYzZaMXdSczVqSHZsUkZhSGxub2tG?=
 =?utf-8?B?cW00ekZTWUgyUTAyN2dOMFBKaW5ueXVnSVd1OFZhb05nQnhnRjkwZkVScWNR?=
 =?utf-8?B?ejFmWllIT3dIY25wM25ZNi9vZzV5dHdJSVhIVHVCMERpcXIzUEIzK3krTGIw?=
 =?utf-8?B?VXllVDU3Q3ZBZytVNzNZY00xRXp2MUI5SHRpK2p0TWFPcHIxQ2piaDE4b3RB?=
 =?utf-8?B?UDhzQUM0R3NIbFhZRVBpNE9tcVhSa3RQS0xscTFaaU5aN1FQODhGeHVxcjZZ?=
 =?utf-8?B?TngxTEJwNUZDNjdLOTFWOWtlTERNRGV5eWNBREh6cFdUNjQxaHFENm5EcFRj?=
 =?utf-8?B?czVUbFJseTRob3p6QTdKZHliTUtRNGxocS9MVUpvOVh1K0cyajM5KzJNVk1E?=
 =?utf-8?B?UUlFUFBFUkFXendDQ01lWlNJNk9mcEtKeGpzTEp5ZEJWb1NIQVNMc3BIN2Ru?=
 =?utf-8?B?R2NXMmg1R2N2Ukd2NkhaTTBKUTd5Q1ltR21rZkJ1OS9hSm5PQ3VZTWhNS29X?=
 =?utf-8?B?NWxZSWxsS0hqQ1dFdm5jSDJDTlliV2dVeFA4QXhySHFJYVNqRS9IOHlmSGVv?=
 =?utf-8?B?OUJ3anlCczdKQTI3WmxJQ1dxTGtyOU9kZitBZHlSQ29FbU0rZkdMTms1RlpC?=
 =?utf-8?B?TXRQSEg0Wjg5UlZLMEVuUEJVLy9OQ2t5VmkrSXNycm9wNkdDTXAybFBXWjJI?=
 =?utf-8?B?UlBVKzlpWFdxYS9TeHhYWWRSOEd5aERyOHZ3bHJJZUpFMGhsNHRKZWhlMWZK?=
 =?utf-8?B?MkpVSUZzYTJNc1dYaVZjeWNYRlltajJWZ3lmN056azNrekVLOWxCK3h4UnpV?=
 =?utf-8?B?UVlhS0trbXRvaUtHTk9IL0ROVDRTdnl3N1RwNjBwR2JiRFNIV1VqSWFBdDRO?=
 =?utf-8?B?dzhXeWxLWlRHeGRaTHIrLzdlZWtGYTY0dmhBOVUvQkNPWHlnR1lka053cldR?=
 =?utf-8?B?ZUNUTnFWcUJkOFVkUVd1d3Y0eFU5bXFjVUcvVnl4M1UxNUF4TmFXdGhLQ1Vq?=
 =?utf-8?B?Ti9OWUp5aGVjRUR4U2R5ZTVuNm4yaTZqR2QrNi9kNnhpRk5oSHpUYmsrd1dt?=
 =?utf-8?B?Tm9TUC9SbEVYejJLRGVVSllQRi9GNXc0MklTOEJpRFBJRGVZMkxvd0lNQUtX?=
 =?utf-8?B?eHM5ZmxSNks0by82Z0RMQnk3RjZaL2lGOUxheUkxQXh5SG0xeGFCdlJaRDRi?=
 =?utf-8?B?M1AwSWlRU0IxeXJZSkQrcFZvaWtyakdIWTZ5QjZKWUxMMVdvcWo4enpoTW9t?=
 =?utf-8?B?TEtUb0tMVHg5M0djNlpjOUpQdlFseVdZSlBFK0FKUlIwTkVBV1RuVC9BQ1JN?=
 =?utf-8?B?alhkSWJ0V1JjaUZ1VFRkWXE3c2JOc1lnbUpHS3lXMzJmR05SU094VG5oa0Rr?=
 =?utf-8?B?c2RTY0ExRVFENmxjWnVoR3AzME1oaW95eGYxQzZmVFFkc3ZVMlhkQW00MGg4?=
 =?utf-8?B?US9OMVFBdEZxQVFCZ3g4bUVGQ1lkOHVqd0VYWmlKelMrUVBtL20vNkxaaWFQ?=
 =?utf-8?B?eE94dGpVeUNneW5GWk9NNE96MzlpaXlzclpJOXlxKzNta2l0Yy9QeEExeHlD?=
 =?utf-8?B?QkdqUmVFQmdCMEZNTHA3Vll0QkVqTGhqMXlSRDV1TEFjOUx6R2xxdklvNmp0?=
 =?utf-8?B?TE0zK2RzWnlPcHJ2N2xudWFYMUJCdGhyUnhxZFdxdm1EL2xGK0lPVU84bWFY?=
 =?utf-8?B?bUJaWGdWWlFod3QraEtmRDNwdEwxK0lsZnp6dTVWYzhyd3k3amZ1bGtrMU5K?=
 =?utf-8?B?WkRVU1dyVzNoWVZoSTdpN2xWWklrdU1qN1BwWGJXWlhpeUh4aExuUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ww9lIEhYN7CSLn6x3bJ1MEnBAtFi9EKk0V6H0XFtrqrgtp9FtuchnIPaJKdJUlJm/YmUk53woDePQHAq3TecqKfCzQT4OCWh+JjbnqR5lTED4dbXH+aOieVeHRDPjqRt3TmzPZgcs1tGRbp7RGLy3YSf/1EY0uvlYhI6wuO+Pa1aP3dLq/ZuF4kpwm8kWmLdY7P0ibbb5z03BIdyU7Tylu1sSygzpVMlriCINqYi03v29aaEODOO4wY55liDo2FI9kYKUmFXszOTIqjIBQ7xhwnt6twFCDO8cS6wP1h+bptjo5IAf3SMT0gVq1gP/Jd4KJ9pqzwvcyzyLRicw/QVlA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c6104b-fc79-4b76-d58e-08df1fe06afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2026 17:21:23.7473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wMMzu7S4fWdZOlUyeoSb3DfLFRuhCbg1I1nJygSS/URoVpQLx2lFHkfLscIWxUB3JDE2vxtnj11H0BMqnOPNYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6569
X-OriginatorOrg: intel.com
X-Stat-Signature: zczth7s97enmqre969c7izunxfnrkgb9
X-Rspamd-Queue-Id: 23B24140004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790875294-916657
X-HE-Meta: U2FsdGVkX1/rMyMUZ7eEKqADx/G4Jc5VNxvhPHebhncPrdApkeGLUaj276Z/1Irfr9Fp0pQ7L9iCH9XIrAHNF1rK7IjJSp1Bdyys5/9pzZQ+xb5Uu5YXJePzgu/aWmtOcrlqSOPYU+2/X7WJ+7wnyTZ2Uspm+x2qUUnozmFaUWZZtfPpGfp40di7FNHJH3ILZiBc/0b8GdbYP9xRuWQ4cx3xk3arJv218DjrCp3H3oGbVCG6OlQbvkXSoWz1yLMzW1J7EBmFovO+slW27WUwpV1XqEkKgX3rwEy2xkYrEfADxhbuCySsxbSgnK0/T/jLlQft8SXRDAnC+qY1NPVQ30Qxg2DSyk5QT7HuKnsB+0h9VHytQdyN4nkmIe0ZaqsgzlFi2wd26RlBovKQi2jzDjT+0Ol0trtGmjEcqtoy3JWS6Eaz7Rd9SAnk6cCbSXVr8I6G12wN3QgIwjxW4zJeGvdKNutTXIOkXJiyVx3pvlakzZMTCmifyE4ojU5gdz5PNMBJ3OdtGEVNnXfv8AcjBbMn0Sqk4uyfpuhyUxbdZYeow9hLuI3h+ZGFz10879xVEOiZLx6zQ1QE/FqMTWQybjWJ6bqDagSV6cKaAwJ9k/yo7j4hn3z1hF4t2X4x/Gj2Vyxu5lWIHDfU0IfmbL4arjKpW7HWvN7iWG6nFxATRf767zhsXNqfGXYp7rZR83VVf3Huhy0rczpClwCL7B0FFlhwZ+bSm+Qp53IpAcz7+Z45t2kPmrf3rJYOQbhHInA+5hkAjMfgfq3ZEiZ61gxrMGEKm579HWGTi481b/5tZPo2ZU1ZRomkCuHsnb610iFqySIVTYN+wJGJfoVmCaL9HycmOjd64kRXTs2xEkLmzIkiZp4xp46ozBmDzInpcx9OntT2hrTX+asI1BioSHSGRDWXtZNFC11vgVQ4y7jTMsdhWP5NmnBSIEMisgRaW5hRktjEf3YPrWsuL5yRU0p
 8gUiVZH/
 FVNoi/f83LGng9f2lc7m5SSHxMV8g2JQfg6Y0mnsdOSF6iH+7awPZb0XGTE9cY/9SjAVChM2UDyQDAbVaBOouqv7gmSk5Kma6VsJDVFUv6xKSpRQ9BLB9jgAQuCM+d5QWOim4olBGZHfkczN64xnbpjUt9jO38SU+Xo59BKVANTvcjHTPx+qma+iGakH5gGTDKIn5TPOVehRn/t5UAhwbShetS7jWDNs08XAiSoQbxpmJ6GFO21T1jvoHQShFcX8ORPgG6LIOgdTJVxwoRtEBEGRvDMoaIojZjnY7L5Cd8D0au8UmFjKZCl35wZ+DY28MQeu5FYUiu+8Xxjpm8M0M3ccEn8caZo2xEahztCvq4cJt3fk/QXTO886Ybgcr1J5ctPx2zhNFVITuMkyQhTKUDtPFtF1Vn0dYAM/y52D0o+50n+6mlVevO53o4bf9/259jdyJmGRpQvbpC0LhYVX4kJ7GAJlV7y9RX/RB1OpRBNR3FICxhYMg5X5UIBVdsJWZhRRy3Hbn0sOaNszfSfcjgB3koK8sxL314KrjOkD/i+/Q9ypSP8Y9RExIpZw8ceLk66kbl9zVD6wGzJXtMlsK7EPZjfsGTteTaVMP25rr84uyxKhMwipILyybYEUA0CrV9Nlj+YMwq4K4VHIgeT//eYSBXT1bcO/bpGqxccSOXUzDPNet2WpRwGwViZrJ2H0AaGCiAqMgrmzXrySNv/qiB2/w3XA6ilcPKBKQYbZ2QZ7d3wxhwiD4u9S+Gg2/ikxrcLVP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgS2FpcnVpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEthaXJ1
aSBTb25nIDxyeW5jc25AZ21haWwuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgU2VwdGVtYmVyIDI2
LCAyMDI2IDEyOjA2IEFNDQo+IFRvOiBBYmFibmVoLCBFaGFiIDxlaGFiLmFiYWJuZWhAaW50ZWwu
Y29tPg0KPiBDYzogQmFycnkgU29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+OyBha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnOyBBeGVsDQo+IFJhc211c3NlbiA8YXhlbHJhc211c3NlbkBnb29nbGUuY29t
PjsgTGFuY2UgWWFuZw0KPiA8bGFuY2UueWFuZ0BsaW51eC5kZXY+OyBMS01MIDxsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnPjsgbGludXgtbW0NCj4gPGxpbnV4LW1tQGt2YWNrLm9yZz47IFFp
IFpoZW5nIDxxaS56aGVuZ0BsaW51eC5kZXY+OyBTaGFrZWVsIEJ1dHQNCj4gPHNoYWtlZWwuYnV0
dEBsaW51eC5kZXY+OyBXZWkgWHUgPHdlaXh1Z2NAZ29vZ2xlLmNvbT47IFl1YW5jaHUgWGllDQo+
IDx5dWFuY2h1QGdvb2dsZS5jb20+OyBZdSBaaGFvIDx5dXpoYW9AZ29vZ2xlLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtSRkMgUEFUQ0hdIG1tL21nbHJ1OiBkeW5hbWljYWxseSBwcm90ZWN0IHJlYWRh
aGVhZCBmYXVsdA0KPiBmb2xpb3MgdW5kZXIgcmVmYXVsdCBwcmVzc3VyZQ0KPiANCj4gQWJhYm5l
aCwgRWhhYiA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT4g5LqOIDIwMjblubQ55pyIMjXml6Xlkajk
upQNCj4gMDE6NTTlhpnpgZPvvJoNCj4gPg0KPiA+IEhpIEJhcnJ5LA0KPiA+DQo+ID4gPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogQmFycnkgU29uZyA8YmFvaHVhQGtl
cm5lbC5vcmc+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyMywgMjAyNiA5OjA4
IFBNDQo+ID4gPiBUbzogQWJhYm5laCwgRWhhYiA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT4NCj4g
PiA+IENjOiByeW5jc25AZ21haWwuY29tOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOw0KPiA+
ID4gYXhlbHJhc211c3NlbkBnb29nbGUuY29tOyBrYXNvbmdAdGVuY2VudC5jb207DQo+IGxhbmNl
LnlhbmdAbGludXguZGV2Ow0KPiA+ID4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGlu
dXgtbW1Aa3ZhY2sub3JnOw0KPiA+ID4gcWkuemhlbmdAbGludXguZGV2OyBzaGFrZWVsLmJ1dHRA
bGludXguZGV2OyB3ZWl4dWdjQGdvb2dsZS5jb207DQo+ID4gPiB5dWFuY2h1QGdvb2dsZS5jb207
IHl1emhhb0Bnb29nbGUuY29tDQo+ID4gPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSF0gbW0vbWds
cnU6IGR5bmFtaWNhbGx5IHByb3RlY3QgcmVhZGFoZWFkDQo+ID4gPiBmYXVsdCBmb2xpb3MgdW5k
ZXIgcmVmYXVsdCBwcmVzc3VyZQ0KPiA+ID4NCj4gPiA+IE9uIFRodSwgU2VwIDI0LCAyMDI2IGF0
IDExOjQz4oCvQU0gQWJhYm5laCwgRWhhYg0KPiA+ID4gPGVoYWIuYWJhYm5laEBpbnRlbC5jb20+
IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBIaSBLYWlydWksIEJhcnJ5LA0KPiA+ID4gPg0KPiA+
ID4gPiBBcG9sb2dpZXMgZm9yIHRoZSBkZWxheSBpbiBnZXR0aW5nIGJhY2sgdG8geW91IHdpdGgg
dGhlc2UgcmVzdWx0cw0KPiA+ID4gPiDigJQgbXkgdGVzdCBlbnZpcm9ubWVudCBnb3QgY29ycnVw
dGVkIGFuZCBJIGhhZCB0byBzcGVuZCBzb21lIHRpbWUNCj4gPiA+ID4gcmVjb3ZlcmluZyBpdCBi
ZWZvcmUgSSBjb3VsZCByZS1ydW4gdGhlIGJlbmNobWFyay4NCj4gPiA+DQo+ID4gPiBObyB3b3Jy
aWVzLCBFaGFiLiBBbmQgdGhhbmtzIHZlcnkgbXVjaCBmb3IgeW91ciB0ZXN0aW5nIQ0KPiA+ID4N
Cj4gPiA+IFsuLi5dDQo+ID4gPg0KPiA+ID4gPiA+ID4gPiBJIGFncmVlIHRoYXQgcmV2ZXJ0aW5n
IHRoZSBjb21taXQgdGhhdCBjYXVzZWQgdGhlIHJlZ3Jlc3Npb24NCj4gPiA+ID4gPiA+ID4gaXMg
bm90IHRoZSBvcHRpbWFsIHBhdGguIEkgZXhwZWN0IHRoZXJlIGFyZSBtYW55IHdvcmtsb2Fkcw0K
PiA+ID4gPiA+ID4gPiBhbmQgc2NlbmFyaW9zIHRoYXQgYmVuZWZpdCBmcm9tIHRoZSBiZWhhdmlv
ciBpbnRyb2R1Y2VkIGJ5DQo+ID4gPiA+ID4gPiA+IHRoYXQgY29tbWl0LCBzbyByZXZlcnRpbmcg
aXQgY291bGQgdW5uZWNlc3NhcmlseSByZWdyZXNzIHRob3NlDQo+IHdvcmtsb2Fkcy4NCj4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gSSB3aWxsIHJ1biB0aGUgQ2Fzc2FuZHJhIGJlbmNobWFy
ayB3aXRoIEthaXJ1aSdzIE1HTFJVLUZHDQo+ID4gPiA+ID4gPiA+IHBhdGNoZXMgdG8gc2VlIHdo
ZXRoZXIgdGhleSBhZGRyZXNzIHRoZSBpc3N1ZSBJIGFtIHNlZWluZy4gSQ0KPiA+ID4gPiA+ID4g
PiB3aWxsIHNlbmQgdGhlIHJlc3VsdHMgd2hlbiB0aGV5IGFyZSByZWFkeS4NCj4gPiA+ID4gPiA+
ID4NCj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtzIGZvciB0aGUgcG9pbnRlciDigJQgSSBnYXZlIHlv
dXIgTUdMUlUtRkcgZml4IGEgdHJ5IGFnYWluc3QNCj4gPiA+ID4gdGhlIHNhbWUgQ2Fzc2FuZHJh
IHJlYWQgYmVuY2htYXJrIEkgdXNlZCBmb3IgbXkgcGF0Y2ggKDQgbm9kZXMsDQo+ID4gPiA+IDcy
MHMsIDEwMA0KPiA+ID4gcmVhZGVycykuDQo+ID4gPiA+DQo+ID4gPiA+IFJlc3VsdHMgd2l0aCBN
R0xSVS1GRzoNCj4gPiA+ID4gICBPcCByYXRlOiAgICAgICAgICAgICAgICAgIDU1LjBrIC0gNTYu
NWsgb3Avcw0KPiA+DQo+ID4gPg0KPiA+ID4gSSBub3RpY2VkIHRoaXMgaXMgZXZlbiBoaWdoZXIg
dGhhbiB5b3VyIGR5bmFtaWMgcmVhZGFoZWFkIGZpeDoNCj4gPiA+ICJ0aHJvdWdocHV0IH41MS45
ay01Mi43ayBvcC9zIg0KPiA+ID4NCj4gPiA+IElzIHRoaXMgYSBydW4tdG8tcnVuIHZhcmlhdGlv
biwgb3IgaXMgdGhlIGltcHJvdmVtZW50IHN0YWJsZSBhY3Jvc3MgcnVucz8NCj4gPiA+DQo+ID4N
Cj4gPiBZZXMsIEkgY2FuJ3QgZXhwbGFpbiB0aGUgc2xpZ2h0IGdhaW4gaW4gdGhyb3VnaHB1dCBi
dXQgbG9zcyBpbiBsYXRlbmN5DQo+ID4gY29tcGFyZWQgdG8gbXkgZml4LiBJJ2xsIHByb2JhYmx5
IHN0dWR5IHRoaXMgaW4gbW9yZSBkZXRhaWwgd2hlbiBJIGNhbg0KPiA+IGRlZGljYXRlIHNvbWUg
dGltZSB0byBpdC4NCj4gDQo+IEhpIEVoYWIsDQo+IA0KPiBUaGF0J3MgdmVyeSBpbnRlcmVzdGlu
ZywgSSB0aGluayBpdCBtZWFucyB3ZSBhcmUgZ2V0dGluZyBhIGJpdCBiZXR0ZXIgYXQgaWRlbnRp
ZnlpbmcNCj4gdGhlIHdvcmtpbmcgc2V0LiBCdXQgbWF5YmUgYSBzbGlnaHRseSBoaWdoIGNvc3Qg
b2YgYWdpbmc/IEFuZCBQOTkgaXMgdXN1YWxseQ0KPiB2ZXJ5IHNlbnNpdGl2ZSB0byBub2lzZXMs
IG9uZSBsb25nIHRhaWxpbmcgYWdpbmcgZXZlbnQgY291bGQgbWFrZSBpdCBsb29rIGEgbG90DQo+
IHdvcnNlLg0KPiANCj4gPiBUeXBpY2FsbHksIEkgZ2V0IGEgdW5pcXVlIHJlc3VsdCBpbW1lZGlh
dGVseSBhZnRlciBhIHJlYm9vdCwgYnV0DQo+ID4gc3Vic2VxdWVudCBydW5zIGFyZSB2ZXJ5IGNv
bnNpc3RlbnQuIFRoZSB2YXJpYXRpb24gaXMgdXN1YWxseSBhcm91bmQNCj4gPiAwLjEgbXMgZ2Fp
bi9sb3NzIGluIGxhdGVuY3kgYW5kIGFwcHJveGltYXRlbHkgMTAwLTIwMCByZXF1ZXN0cyBwZXIN
Cj4gPiBzZWNvbmQgaW4gdGhyb3VnaHB1dC4gSSBkaXNjYXJkIHRoZSByZXN1bHRzIGZyb20gdGhl
IGZpcnN0IHJ1bi4NCj4gDQo+IEFueSB3YXkgSSBjYW4gcmVwcm9kdWNlIHRoaXM/IEUuZy4gd2hh
dCBpcyB0aGUgdGVzdCBiZW5jaCwgZGF0YWJhc2Ugc2l6ZSwNCj4gYmVuY2htYXJrLCBtYWNoaW5l
IHNwZWMsIGV0Yz8NCj4gDQo+ID4gPiA+ICAgTGF0ZW5jeSA5OXRoIHBlcmNlbnRpbGU6ICA2Ljgg
LSA2LjkgbXMNCj4gPiA+ID4NCj4gPiA+ID4gRm9yIHJlZmVyZW5jZSwgaGVyZSdzIHdoZXJlIHRo
ZSBvdGhlciB2YXJpYW50cyBsYW5kZWQgb24gdGhlIHNhbWUgc2V0dXA6DQo+ID4gPiA+DQo+ID4g
PiA+ICAgUmVncmVzc2lvbiAoNmNiZGQ5NzI2ZmI1LCAibW0vbWdscnU6IHVzZSBmb2xpb19tYXJr
X2FjY2Vzc2VkIHRvDQo+ID4gPiA+ICAgcmVwbGFjZSBmb2xpb19zZXRfYWN0aXZlIik6DQo+ID4g
PiA+ICAgICAgIHA5OSB+OS4yLTkuNSBtcywgdGhyb3VnaHB1dCB+NDEuOGstNDMuNmsgb3Avcw0K
PiA+ID4gPg0KPiA+ID4gPiAgIFJldmVydCBvZiA2Y2JkZDk3MjZmYjU6DQo+ID4gPiA+ICAgICAg
IHA5OSB+NS41LTUuNiBtcywgdGhyb3VnaHB1dCB+NTEuOWstNTMuMWsgb3Avcw0KPiA+ID4gPg0K
PiA+ID4gPiAgIE15IGR5bmFtaWMgcmVhZGFoZWFkLWNyZWRpdCBmaXg6DQo+ID4gPiA+ICAgICAg
IHA5OSB+NS44IG1zLCB0aHJvdWdocHV0IH41MS45ay01Mi43ayBvcC9zDQo+ID4gPiA+DQo+ID4g
PiA+IFNvIE1HTFJVLUZHIHJlY292ZXJzIG1vc3Qgb2YgdGhlIGxhdGVuY3kgcmVncmVzc2lvbiwg
YnV0IHRoZQ0KPiA+ID4gPiByZXZlcnQgYW5kIG15IGZpeCBzdGlsbCByZWNvdmVyIG1vcmUgb2Yg
aXQ6IHA5OSB3aXRoIE1HTFJVLUZHIGlzDQo+ID4gPiA+IG5vdGljZWFibHkgaGlnaGVyIHRoYW4g
d2l0aCB0aGUgcmV2ZXJ0IGFuZCBteSBmaXggKDYuOC02LjkgbXMgdnMNCj4gPiA+ID4gfjUuNS01
LjggbXMpLCB0aG91Z2ggaXQncyBzdGlsbCBhIGJpZyBpbXByb3ZlbWVudCBvdmVyIHRoZQ0KPiA+
ID4gPiByZWdyZXNzaW9uJ3MgOS4yLTkuNSBtcw0KPiANCj4gRGlkIHlvdSB0ZXN0IHRoZSBWMiBv
ciBWMSBvZiBNR0xSVS1GRz8gVjIgaW5jbHVkZXMgQmFycnkncyBhZ2luZw0KPiBvcHRpbWl6YXRp
b247IEknbSBub3Qgc3VyZSBpZiB0aGlzIGxhdGVuY3kgaXMgY2F1c2VkIGJ5IGFnaW5nIG9yIG1h
eWJlIHNvbWUNCj4gb3RoZXIgY2hhbmdlLg0KPiANCj4gQW5kIGlzIHRoZXJlIGFueSBzd2FwIGRl
dmljZSB5b3UgdXNlZCwgb3IgaXMgdGhlIHRlc3QgdXNpbmcgdGhlIHNhbWUgYmFzZQ0KPiBjb21t
aXQ/IE1NIGFsc28gY2hhbmdlcyBzaWduaWZpY2FudGx5IGJldHdlZW4gZGlmZmVyZW50IGJhc2Vs
aW5lcy4NCg0KTXkgc2V0dXAgcnVucyBDYXNzYW5kcmEgNC4xLjUgb24gSmF2YSAxMS4gVGhlIGhv
c3QgaGFzIHR3byBJbnRlbCBYZW9uDQpQbGF0aW51bSA4NDY4IHNvY2tldHMsIDk2IHBoeXNpY2Fs
IENQVSBjb3JlcyAoMTkyIGxvZ2ljYWwgQ1BVcyksIHR3bw0KTlVNQSBub2RlcywgYW5kIDQ0MCBH
aUIgb2Ygc3lzdGVtLXZpc2libGUgUkFNLiBDYXNzYW5kcmEgaW5zdGFuY2VzDQp1c2UgQ1BVIGFm
ZmluaXR5LCB3aXRoIG1lbW9yeSBpbnRlcmxlYXZlZCBhY3Jvc3MgTlVNQSBub2Rlcy4NCg0KSSBy
dW4gZm91ciBDYXNzYW5kcmEgaW5zdGFuY2VzLCBlYWNoIGJhY2tlZCBieSBhIGRlZGljYXRlZCAz
LjUgVEINCk5WTWUgZHJpdmUuIEVhY2ggZHJpdmUgaGFzIGEgc2VwYXJhdGUgbW91bnQsIGFuZCBo
b2xkcyBpdHMgaW5zdGFuY2XigJlzDQpkYXRhIGZpbGVzLCBjb21taXQgbG9nLCBhbmQgc2F2ZWQg
Y2FjaGVzLg0KDQpUaGUgc3RyZXNzIHdvcmtsb2FkIHVzZXMgYSBwcmUtcG9wdWxhdGVkIHRhYmxl
LiBJdHMgc2NoZW1hLCBwYXJ0aXRpb25pbmcsDQpyZXBsaWNhdGlvbiwgY29tcGFjdGlvbiwgYW5k
IGNvbXByZXNzaW9uIHNldHRpbmdzLCBhbG9uZyB3aXRoIHRoZSBzdHJlc3MNCnByb2ZpbGUgYW5k
IGNvbmN1cnJlbmN5LCBhcmUgcmVjb3JkZWQgYmVjYXVzZSB0aGV5IGNhbiBhZmZlY3QgcGVyZm9y
bWFuY2UuDQoNCkkgdXNlZCBtb3JlIHRoYW4gb25lIGtlcm5lbCB2ZXJzaW9uIGFjcm9zcyBteSB0
ZXN0IHJ1bnMuIFRoZSBtb3N0IHJlY2VudA0Kd2FzIExpbnV4IDcuMy4wLXJjNS4gV2l0aGluIGVh
Y2ggc2V0IG9mIHNldHVwcyBiZWluZyBjb21wYXJlZCwgSSBrZXB0IHRoZQ0Ka2VybmVsIHZlcnNp
b24gY29uc2lzdGVudC4NCg0KRm9yIHRoZSBNR0xSVS1GRyB0ZXN0cywgSSB1c2VkIHRoZSByeW5j
c24vYjQvbWdscnUtZmctdjEuOCBicmFuY2guIFRoZQ0KTUdMUlUtRkcgaW1wbGVtZW50YXRpb24g
aXMgY29tbWl0IDZiY2Y0YWU3MGI1ZTsgdGhlIGJyYW5jaCB0aXANCmlzIGE2MTlhYjAxMDVkOS4N
Cg0K


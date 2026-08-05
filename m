Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519E3C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56EC86B009F; Wed,  5 Aug 2026 05:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F8C6B00A0; Wed,  5 Aug 2026 05:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7976B00A1; Wed,  5 Aug 2026 05:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E49F6B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:40:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 828E3A0428
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:40:34 +0000 (UTC)
X-FDA: 85066720788.16.E665DF2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94AB712000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:40:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WwCZ6pIG;
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785922831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MnuMyk8WHDQMLWQKiph4szwhZAhzdnAUyX8/9oaJNg=;
	b=S19YFkWBdu+VJj6OQOAd+Gw/VeK4TF3sL1Z6JrGi7qj95Gk2YPbUG/msQhIpmhZ3O6sB7v
	1AR0VJ2z0Nsav3wyJg+68+iA8JMU0xLtzXc0KsqNXVrsYEQKdZrgoeC7wdp5RLb5O+tzxk
	AHmfTuiP19wQr0KGPVxJNkA0xuj8LSM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785922831;
	b=LZ8BJgbO+m5z0a2V50myOuwufcjiqZf00Z8gRVbodsL3Mxs32MSaoHWepduSqgBXpmynPO
	mUOG/hz+cl/AeX165XX4xdHU2PUQT8yinh1fCjA7bDxRgqSBioqBxJXeFccEOEUK1TWK1+
	FtfdWk7acqQ3VcWWsHYsgIzsfvxRdDE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WwCZ6pIG;
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785922830; x=1817458830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XkEfj6zgy6vzF3O8xYTfCmwVH+mBwmRIvnAYYiZnQPk=;
  b=WwCZ6pIGfuQvn1tFf3kDu91BpwNoEyZg3rb/5ql5t1kLYB00IN/QvRL1
   411cxXHGyhq60XzRCpWyai6vpVjCXFnAXQF3TJlqdlWUpYXvkuXq3SAyU
   qle9cWV+tHDBlgLp4zpsTqVoZQJ83mWEDejVbgFBiAJ1PNQkHWVPlJvE8
   Zb0Akmq+vTQHu7GSywkRzzB3JPuoUV6IUwCNFAQG0ge2sZd0jAEfWx/7Y
   Bu8/+75+icf3qL3qc7rZKgawFr8ZLZWRVaUTBVSuVaPFYCiTvqV2CXMRv
   hnWca29Bl6fmoXnDo3UnuiW7+dXeEA04KD9+9Ts6G/5GE9y1eEvtJgoh5
   A==;
X-CSE-ConnectionGUID: H8fBQmCfQouOVlcVRmfFTg==
X-CSE-MsgGUID: E/ELgLP8TEyfhIiNU9/pRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86432807"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86432807"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 02:40:29 -0700
X-CSE-ConnectionGUID: NT3m8UA2QHWQFw5N0fWYmw==
X-CSE-MsgGUID: ieu6/n0xSQ+BMNUbsaSJAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="259136113"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 02:40:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 02:40:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 5 Aug 2026 02:40:27 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 02:40:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiSXSp19NYRfYxxLjIRD7A9IPk542eNvtwoiW/hylh4LMqdifwkpACiwjNcScZdTM4+fMs9rR+eNac1dhWE7dLVixWuufO4tHaqspUqQRAeBveAHzp+1f0tMtDdIPwz99eLJM4Y3FtCFGJZvAGoxKKwO5eCMI34Jpptd2HH9oM/mrW+pWW17m9dcY6X9ZYZiXZWeR43mM+QeFyrfIdIPEOoWQj5BRSCpY8BiMZaVlKLRWGo44e4gWBXAnnfIGz2voHLvucyuDoTFD/QoT8tB7+4hPFbVHMgW71MfrouwbvSAskgycLlI64Ej+MPGLB4PjYj/N5yvmhVakmaaWmFRiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MnuMyk8WHDQMLWQKiph4szwhZAhzdnAUyX8/9oaJNg=;
 b=st5AaMiaRLqWFumbW1/c7xRT0d3KXphrTjDh4aWFzK5KjsyV1Xc9hVrkBmKtyTCM4JIkkpPlQd0WoNKp05zYljExpZT1IYhcqM8rOLV1CarwYHLxPTe9VAlpArLrW0iv+yQ3XwP/ev3eo7FSG1yXqFLjKJhrepPC9XWqDNbve6n1qkmIoNugYpWFAOXoKrRqmYDF/OUS6HNBTZxb6K873kFoQBlAA0JewpnP5tIfgwK4TOGWloWi9D0/r8smMzoaqy9TUFsod1fRCptQHhcF1FCg75r2yE5SjgxYJDIiD3LOkrTNShX9ioYQs+tvCs9Qn8LLnOBxiS4tat9M+xe4ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.20; Wed, 5 Aug
 2026 09:40:24 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%3]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 09:40:24 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou"
	<tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, Oscar Salvador <osalvador@suse.de>, Mike Rapoport
	<rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 0/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v6 0/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdGn+uHm5iVj4kDU+ITvUFUKXMlLaPRk0w
Date: Wed, 5 Aug 2026 09:40:24 +0000
Message-ID: <MW4PR11MB6936F7C06801A241F2149136A3D32@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
In-Reply-To: <20260723084946.189392-1-yuan1.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|SA2PR11MB4988:EE_
x-ms-office365-filtering-correlation-id: 247ae769-080d-4a84-e5a3-08def2d59320
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006|11063799006|38070700021|6133799003|10067099003;
x-microsoft-antispam-message-info: ws/qNNkJLpaQy5HdDpGs9FPWQpF9CFp2Kas5IO6kBp6zXBALRMFFdmS+2Lb98tTSk1s7TyCc6O97D2WmoOSrYtzgT1fmvUaZv+mr4qy65adHH8Ge7ywsaRQiDiWydTM0YMS23kFhD8Nz5Xf/cN0mQ110IUZkd7D3rHK17czkvHOjvH3PuE0OpiSBKGplwLFTT7sLzzT8OUuvOj0JIlIYCRl1nWjYdr8kNyt74hMHmn42e2/ExzauBGZUNYmonGPk3swh9komaE/yKHBpHlse9tqxt00c9vaNIgaEw0E1w7UnX8ouWbwQ8seHRuF0z8AcIQajXEre6b2pBFrm6JiTrhPa2kFysvIYkd9z1EOTXm9dkUP3FSKOZ9HUU+Hm3KcKu6WNWNkxeZoXdydAixtPrH/Qb2xMETBBtBUAIoPv3eoPcJjOIYxVurGHi6lPPWM5wwEs8AufflrsNXE6H5dzdOTRNif/9hgmUDdM+Q+nsiuRrRy/6LaHxMy9LsQFKTl55M/z5FrAUyyfM8RhybWFKzs4ofVc1UoBaMzcKWFu91/IC5QonP0HgS8WMe3cIowbS41bVKm5l+7iPl6LB6/AK0iGuRj99iIhHjI8a0GJy21lT1cKyoa+x7qXjuOQW+moFB/1U0kEJI6BQjhX58oxiKoA0jhqC8o7jPIhcl/igvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bVGl9ZKOpAXrtlB9+1hKumHw9pXK2A7aUPS8OA+Ot1FuHI7wU/5hmcojMOZ6?=
 =?us-ascii?Q?a+Jf5j10APgpQzsvzJzErOBQjxzgKv3vtUBr9zmF+LgG+tuP9BgKu+btGL+h?=
 =?us-ascii?Q?45mvQCw/RJvftVyXkHPc4LLqu76tEHiyp4KnybFfKGDJz0hPTqGsLbcppkvQ?=
 =?us-ascii?Q?0s2vTimwA+f1DZsLaAsgrwUQfnfVNLN5wDN9hpd4fKOsYOET5AokZ/G5xiiz?=
 =?us-ascii?Q?2sEg9kYrxNvdX/pk2ubiuF7hNUGBjTLe508fjJ+OkuXFWF0N2IUguvdH4bgK?=
 =?us-ascii?Q?ouh/A2A+nhnZ+gaOstVimpygNQOSCR7CDPFLMLjh9Hx6Gcq2A96hv0HV96D2?=
 =?us-ascii?Q?HqfCTPRW8+xp0BEqkr9aNj/Ff3F900AeaEhc0+NKWysheaaXHSyLlUFzE6ak?=
 =?us-ascii?Q?m46TAx/I66zO0TXwG+9k6XP9vU2fCnnjSHFfWbYGSn64/i/MewoDjeA+GB1h?=
 =?us-ascii?Q?KH6igHip505zU0+eNLHwafk89VkP4Uf2OpAndUveezMA2KeoW/GqQeMEJOpK?=
 =?us-ascii?Q?WDA8xKLBdc98NPNthcvg8r+WCLOW2CrIFeZEI4nnGZsG+GadQgt3lrZSlQsH?=
 =?us-ascii?Q?puQcB5JAGopI6jHeiOZx9bYDFeoEtE/D3N3c27ZitQCi3WOjNXhkpLJTk3an?=
 =?us-ascii?Q?rswX78P4s7GLICc02P/hJVZk8LXzaJbQWU/mvLDJSovXGFcqWxJFVQiEB7Av?=
 =?us-ascii?Q?VmceQnZY0eZ2DDjRiJDXfOyNnNXsErgZiqrmHknBHDw0L8KnLLV/5vONPt65?=
 =?us-ascii?Q?G9pJSCdOnTpt9LHQCVIwZaLZ7w7Ioa5PRnP+6/3kBiNo0+oIKbVtGkKU3YwU?=
 =?us-ascii?Q?3ms7RGzxW0o6pz8GysQ5MQWgoSbcE6ssYZDb5xX2DwkaDZ+CD5112HyJwuir?=
 =?us-ascii?Q?+pFi/RcRkC9F3YqV/383pBFDouvafHxm6YTXu60ncc8zZd/jXcDdk7R9pRkp?=
 =?us-ascii?Q?0beJ3R/XhFQmkliuUOjm5rkiA5bEv+yaVXkMJ4c5QPzfff5uZM4Geb5WbSIG?=
 =?us-ascii?Q?D+hHksJPk7SZn+AK/AKTHqGrZZ8ECsOXx7NVKQPCIdy4qmfqFTL6tAvOiAKA?=
 =?us-ascii?Q?xI6dooIj9KGKtXSNgiIHWKVoKxj8LfH82IwlwbaBsu2pc+GYEUQD2fvuiXft?=
 =?us-ascii?Q?sJ3x4qGnsz2Wy7WgbHWjf40RVQobNpkvGEGNJY/6aPWHWpeIYJBGaBxLbFgS?=
 =?us-ascii?Q?+Bvm+rtpm1MUdL9w5ysAgcHlVJ5cigv+RPphiNcdEZ+Zj0nmU3ZBA5c2jq/0?=
 =?us-ascii?Q?/igtWifj8j1vP5HmTv0q1Gvuj61YphWGAXxpgH7eHXo8R5rMroPNhseth0ub?=
 =?us-ascii?Q?kNelPLR20f+GxqpEGsBj66mzpwN7fzPdTdfkgZjWovK8OEv0VdSGGKiuIo33?=
 =?us-ascii?Q?M4e+mQy03PUwsupa64xBNrqepNsWRodqxcBIf6iTwJlT0I0eUsk5oTah54aD?=
 =?us-ascii?Q?PvGhtAcTgfHD5Dx3f0mym05UQzLOZoUl9bJOU6WXrX4djce2nNV7RKC5OZVp?=
 =?us-ascii?Q?Xg6yB8li7Iuya+uXuu/dKa9epGgWsXN4VBmvUwOAINO40LrJsbZovP3wJjfs?=
 =?us-ascii?Q?3PMdH/C0/MhEDoIOnJylGCE4v+gjef9R1L1XSJiPSwJzNyryjxYrZnc+eS/J?=
 =?us-ascii?Q?PzH6PiriyeSIQKW+fhQwf6O6iMyFpjhJ3sBvXaC1yVRIwPIqGguBJA5IQnDf?=
 =?us-ascii?Q?XY9Q6ScEVw54ze4YubMb2Hoc0H0+seZWmEHH285gk9z1ZoF6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: kq40TMe3KhtHt9P3gsHtJp1rmUt8ea7RzUydiXJuHzEw2XUInhcohIkR8qLCgJULIa5nfIH0GY+Sn2uwdIGGq97vDO9gXQ4LbLrd/BWAUB6zPrDXKMcadCT1VUbQoxDjeaN3BXUQTiKAJccAZ7+8TsouwSrmUltwTniUDXxAZd3QdLvaSAPPh/na7cWHdVtTokvXNRMI/P0NchJCNRwZG3w2NpA0lJT3VnyzLDQ/iflWVEwtVbuyvECeKbw9g7kYERvC5d/6fHGmXxclDrYuWCSpMvrFyRbMhTPIlSNVgtf/wF1QEi/NGDESNdOlp4jSA3ZEWynvaIPc4xnBv6VjVw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247ae769-080d-4a84-e5a3-08def2d59320
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 09:40:24.2750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jXrvzo3KN6WdOpcYjwq3pmik0JLAdZ7c2FsvbAFKchX+C1k+C/Pkkz5N5CRn4tfyjhQO2ENQWjb25dFBDz+9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 94AB712000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: uq34ccpxf5rr1jgu1d83ps33x3iit849
X-HE-Tag: 1785922829-527046
X-HE-Meta: U2FsdGVkX19FntpBl8l0Td0n/QCjgfBRVE6GgXtBCqxwnAWn9lMtn73GRcIBRW+LlbAat7VA5WwIzWN9Z2fvofIv01LMh0GT1wShzmpcY/bpvvM+X5wbYTZPAkkDgF6iHA5eJCz5DBW+BWByrOoEVq84AF0F1El+QV55rfCWRBt77yCrPMuc+eD96GeYEkd/7ZX5YvoJMPGJgh7G72tSeV8Hog7/BYyaq74FlkGOPqyNcEq0IIqgz7L0qD2Qnr4euf9FMuVwh65Kkwr2o6DQrQ9+NaaJESkNRUT4srMggH9+nQeRGhvmMLGeXSFxlPjhGUsjxhmXIEdYKZq5BciZeQ8KJDR/aGmeFvn7JIaVTJAyHZgEsbKtC2l2kdh+gSKlhYuSnrAXlFkCnn8zqFlMe2zXwaUcDq//XsnVd1Mop0gaewtASlGAgUnip/fy6VCVyJHvhfg+IhTqdhjWAJ7sK8p/YwBx92+r7NDxzB8J7KmP9ktk4X7EQ88gPfifnaIuCTevNYuBse/Huxkq09Y5qJmjFm0IA6WdMJWcHgm4nq2YxdTZij0thIxXzHVYgUXRTPoWVR00asYaeptyBNPmF4EZ9Jknf0X30bfsK9m4pa889wdKjv3wKwJvFBRlWKu2W0G15b+tPbsa93B91wSqrUjXB1LT4N1fkWSBmnAOrBk9/LbeJpcFwo1jWnk3cVxGAvwxyyLQlovXp2yvvdbSCAMA3nCGbPufONtuMWhZx2WW78toxsOwzVP5YVwDoigyskuWw7coL0deGTONdr8nRIe7BVTS3giSgTmAt6abuAAAxwi27oj6eov+dK++YClBb2yGwCC5sdsa+nkA94WUFwCT0NJYZTlWH8fOfdP7oi0koCs2DF9cMxpjcT3CgvM1P5VXYnzvUipZbgOCOoR67toBDsIQBWmqwlgdHfSzX7kSlQtR5B5rI+g8z3cNCEd+aEEijc3ZzERk+Zn1Uzs
 3wmJGgu5
 CSVdWGzLTaq51oMFGPm6vgHHT/77wIBU9BeF3d6fBNxQ7TtkUz+YGrANs15LLSnQ0VaP7bcMYzLphTEYGdeekdX71m39pl6duYHqB7eMM8EdYKf3mAwkIce+j7qTgJ1SxxAL+ZGWwKWZzogPXmqZX4Jy5Asw5muYPtfNDgFC6syEKLn3/x5xcaHmkG/uiBe92pEDUOD0/x/c1n3LckGQoDwVlQ9SKUA2DWTfGOVr+2QZ80lC4hJmb2stN+4uRX0j6Y2Q86dN7ViVMVvhfPFs/y7XJY43IZT5hM9Hj9O5mfVYaLqy//UEzfxiKLNgZn7zLe1bg0LnE9nZTGlRBM8kz/R3qGrqE9+aJI38l7f4OHbj7HU1aRXa+pGYCzkL5fCUoIWa2DysyFjcrvOygzxGMwQMBRB2Tp7V1zVIo9fbclR7IRfNWkdI6M/Bnnswt4bApRxgTsZrXAB9Dt00Xc7Nfap09DS524lIqGHbx+15nQeqiyc5vqYAc8csRARhnnthuyV6BVCsSrUC5UrqSgIs66FvIWoSQu2QCSPEtimkiRlKrXz9xqRsCgJ0AtEiwRa6WnUuFVAxFTUbJeP6rpQ5rnXMdF9Tl2u1lndxC6ZzD8lUsZ+MRxl160umeipeItL/kr24D4ZqUJMDyY13S03JpSqQGkS3R51iJZBXhAjKx/wL3Q0kcmpoIXn5f8QV9xEopx4+hDRziFsfunbg3909MfKoO8fDU7m38Az7kj/sO3FEe98Ru6MFoG1uA0XeJ/VHr3T33JZJRAwaUsh5LLNK/Q+J7CSg4ZBOMFVIpgnycQSK9MoMyjhxEWlX9qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

The reworked implementation updates pages_with_online_memmap in
memmap_init_zone_range(), counting only PFNs that satisfy
pfn_to_online_page(). This eliminates the extra PFN range walk used
in the previous version.

Does this look like the right direction, or am I missing something?
I'd appreciate your thoughts.

Thanks!

Best Regards,
Liu, Yuan1

> -----Original Message-----
> From: Liu, Yuan1 <yuan1.liu@intel.com>
> Sent: Thursday, July 23, 2026 4:50 PM
> To: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>
> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Liu, Yuan1
> <yuan1.liu@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
> <jason.zeng@intel.com>; linux-kernel@vger.kernel.org
> Subject: [PATCH v6 0/2] mm/memory_hotplug: optimize zone contiguous check
> when changing pfn range
>=20
> This series introduces a pages_with_online_memmap member into struct
> zone to avoid pageblock-by-pageblock scans across the entire zone and
> improve memory hotplug performance.
>=20
> Reworked how pages_with_online_memmap accounts for PFNs in early
> boot memory in response to Sashiko's review comments [2], which
> identified potential issues with the previous implementation.
>=20
> Approach
> =3D=3D=3D=3D=3D=3D=3D=3D
> Add a new zone member pages_with_online_memmap that tracks the number of
> pages within the zone span that have an online memory map (including
> present pages and memory holes smaller than a subsection whose memory
> map has been initialized). When spanned_pages =3D=3D pages_with_online_me=
mmap
> the zone is contiguous and pfn_to_page() can be called on any PFN in the
> zone span without further pfn_valid() checks.
>=20
> For early boot memory, pages_with_online_memmap is calculated in
> memmap_init_zone_range(). Since every PFN within a memblock region
> satisfies pfn_to_online_page(), the calculation aligns both boundaries
> of each memblock range to PAGES_PER_SUBSECTION and counts the aligned
> pages that fall within the zone span. If two adjacent memblock regions
> share a subsection (i.e. the hole between them is smaller than a
> subsection), the overlapping subsection pages are counted only once.
> For hotplugged memory, pages_with_online_memmap is updated through
> adjust_present_page_count(), which is called during memory online and
> offline.
>=20
> Only pages that fall within the current zone span are accounted towards
> pages_with_online_memmap. A "too small" value is safe, it merely
> prevents detecting a contiguous zone.
>=20
> The contiguity check using pages_with_online_memmap is stricter than the
> old pageblock-by-pageblock scan. The old set_zone_contiguous() iterated
> at pageblock granularity via pageblock_pfn_to_page(), so a zone could be
> marked contiguous even if a subsection-sized hole existed within a
> pageblock. The new check requires spanned_pages =3D=3D
> pages_with_online_memmap,
> meaning every PFN in the zone span must satisfy pfn_to_online_page().
>=20
> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. For VM hotplug performance data, please refer to Patch 1.
> 2. This series also benefits CXL hotplug. Performance results are
>    as follows
>    https://lore.kernel.org/all/20260409023552.GA2807@AE/
>=20
> Tested cases
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. Hotplug/unplug correctness with both online_movable and online
>    policies, including partial unplug, middle-block offline gaps, and
>    edge-block span shrink.
> 2. Large scale (256G/512G) plug/unplug performance.
> 3. Boot-time subsection holes (aligned/unaligned, in-zone and
>    cross-zone) with correct pages_with_online_memmap accounting.
> 4. kernelcore=3Dmirror: verified no overcounting.
>=20
> Patch overview
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> This series is based on the kernelcore-mirror branch [1].
>=20
> Patch 1 introduces pages_with_online_memmap to replace
> pageblock-by-pageblock scans across the entire zone for zone contiguity
> checks.
>=20
> Patch 2 avoids incorrectly shrinking the zone span during memory unplug
> when a memory or hole boundary falls in the middle of a subsection.
>=20
> v6 changes:
>   1. Dropped patches 1-3 from v5. The kernelcore=3Dmirror overlap issue
>      that caused pages_with_online_memmap to be overcounted has been
>      resolved by the series [1].
>   2. Reworked pages_with_online_memmap accounting during early boot.
>=20
> v5:
>     https://lore.kernel.org/linux-mm/20260520093457.3719960-1-
> yuan1.liu@intel.com/
>=20
> v4:
>     https://lore.kernel.org/linux-mm/20260421125508.2317429-1-
> yuan1.liu@intel.com/
>=20
> v3:
>     https://lore.kernel.org/linux-mm/20260408031615.1831922-1-
> yuan1.liu@intel.com/
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git/log/?h=
=3Dk
> ernelcore-mirror
> [2] https://sashiko.dev/#/patchset/20260520093457.3719960-3-
> yuan1.liu@intel.com
>=20
> Yuan Liu (2):
>   mm/memory_hotplug: optimize zone contiguous check when changing pfn
>     range
>   mm/memory_hotplug: improve shrink_zone_span() subsection boundary
>     checks
>=20
>  Documentation/mm/physical_memory.rst | 13 +++++++
>  drivers/base/memory.c                |  6 +++
>  include/linux/mmzone.h               | 47 ++++++++++++++++++++++
>  mm/internal.h                        |  8 +---
>  mm/memory_hotplug.c                  | 54 ++++++++++++++------------
>  mm/mm_init.c                         | 58 +++++++++++++++++-----------
>  6 files changed, 132 insertions(+), 54 deletions(-)
>=20
>=20
> base-commit: b69c2a1fa9beb4c3db24b4013e07f5cb7e7260aa
> --
> 2.47.3



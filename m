Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E06B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Ycfg2BPo
Received: by kanga.kvack.org (Postfix)
	id 7B03B6B0821; Tue, 24 Nov 2026 13:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761D86B0823; Tue, 24 Nov 2026 13:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628D56B0824; Tue, 24 Nov 2026 13:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32B4D6B0821
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:16:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40B021C42A2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:16:07 +0000 (UTC)
X-FDA: 85470816774.25.8715215
Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5420100007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:16:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ycfg2BPo;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795544164;
	b=SxgAXFEg6xiFx8F1U1IE3o+Cq1CsuVWUEtj+onLd1xcs2m8kjt6gf4A7EUyf4iw3WGOtwo
	4YluLtS30tIUY0fach5FH7COPdMSEb7EDZhygfGMxHKzZvJhaVeph0t11lWoXK689J3jyn
	ESd24k5X66Op5NatCK6i4xYNFyZ0W58=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795544164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3L3jXxweWSWwcKv1HJ3+Wm1K1oGGA0ydSan4KUTWVk=;
	b=zvspnt3iCIkRFiAu2QCpsJA1WpPgWsVCaFTqS7moDMiWzQJq84m8UONUg9SnIHWc8wab4Y
	ZkWz5et4GAng4wPzVJSjWqgi1w9Qxvokf9S89cEsUNIbzzLg7/GNUTasPGxIw0s8HD/ZvL
	4mGUBhZ4DSy7DJOe/Tr9Uya5gt9jP8w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ycfg2BPo;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795544163; x=1827080163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z3L3jXxweWSWwcKv1HJ3+Wm1K1oGGA0ydSan4KUTWVk=;
  b=Ycfg2BPolEDVHO0osoH7hTlK4pyha1wo7xX8ngcUadiK7lnIXoxiwf93
   3Vd8pciBBEHmPxKZ7ulUefBYQEmmgrJavVdfxbUixBNT+HfXlIzGJeMXb
   fJFAfFjNMGiIj4KyJnChW55MNH3LSUtqxXXJHZtds3nqMCvxcLhbPrjVB
   6tkoiiOEb4NiOjg/1HWdjwf7MSGPH+rHB7yrg1oiNkQIm115Bt9qJ8rKv
   b+QDeSrE1V6Gfl0Vg8TUROgvFp1+n5KDJP5bsa6sLU6rNI9Wtag169qGs
   XiHEOcHGjz7UjBoK8uS1mJo7NPA39MgVthyL75GE6Y2aHznFo+5Lb5VCk
   Q==;
X-CSE-ConnectionGUID: U8QJ0iinRleTj1mdiMw4bg==
X-CSE-MsgGUID: wIhebacCSn+W37XZKbk5cQ==
X-IronPort-AV: E=Sophos;i="6.27,231,1787011200"; 
   d="scan'208";a="32321345"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 18:15:59 +0000
Received: from EX19MTAUEB002.ant.amazon.com [52.94.133.143:31817]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.18.35:2525] with esmtp (Farcaster)
 id 6971c821-a6f5-4133-ae74-50f893d66c75; Tue, 24 Nov 2026 18:15:59 +0000 (UTC)
X-Farcaster-Flow-ID: 6971c821-a6f5-4133-ae74-50f893d66c75
Received: from EX19EXOUEB001.ant.amazon.com (10.252.135.46) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 18:15:59 +0000
Received: from DM2PR04CU003.outbound.protection.outlook.com (10.252.134.239)
 by EX19EXOUEB001.ant.amazon.com (10.252.135.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57
 via Frontend Transport; Tue, 24 Nov 2026 18:15:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s1NAB+k9rA2Hv0mDCrANT16tOizVMNeiZiHgGkFPiInMKAve8yKEO6YgKWPJH9drXDAFFcu/Uz0GhPHRX2StrZGEbjDOuatJwzwZZ6WN4nX+CKei0vK4jEg+HCYjDhNDoKQ4HBuZ3pbOK1u0tpck036diLm4uBlT7f98ALleVDE1AWJDi4ISqxCn3Ekw+wA1TbuvIRj6q1IcmTT9VeB8fs59hulGqV/DLTO3ObrwvRTBKgX2n41YgxGh788h1eCLlMDML2112TDgZdveMe8VF5cwWvx6KJ7GmWD0PDoQTjiUrXrCIf5jKwBmK+YJ+hFoQxnbjgvbFn6OjAUyEe84kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3L3jXxweWSWwcKv1HJ3+Wm1K1oGGA0ydSan4KUTWVk=;
 b=GcqtdG/YXkEyJ7JNOyVUTZfYeVRFJi1yfUUFcUgeAimoJAPH81EFmfvnJwghQyu1dyeBTZdtnKN6+fHpWoeBdJe4/fXJJJ5t4xxcDF25h4hmMy1cFxVVpldbgfrQC0xScUYADj0SubCz9OKVKjm6JmaJU+MVE3VPn07OpvElIvXkSfxduRfvFq1lgFOuQW1RY4n3LgQWP8/AHZHr3ydNa0sFz+8OVNNs4SjwvjMe8v7hS2gvEcNwBaINArsdXg40q+crNHeL9o7MutDFZp7Svg/NJbc2t0U3wvfaWaVY8gjToSBi/Eu3lCwCfNR3fKdGzzJeAlQynx/gkpv5U+nSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by DSVPR18MB988458.namprd18.prod.outlook.com (2603:10b6:8:3aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 18:15:54 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 18:15:54 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] mm, uio: huge PFN mappings for /dev/mem and UIO
Thread-Topic: [PATCH v3 0/5] mm, uio: huge PFN mappings for /dev/mem and UIO
Thread-Index: AQHdfD/Y5rL8EZ9PrkKpjL+hf/TkhQ==
Date: Tue, 24 Nov 2026 18:15:53 +0000
Message-ID: <BY3PR18MB47229409964FC3BD80B7CE00C6442@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261124131510.38745-1-farbere@amazon.com>
 <awWPTMvlt34wPyux@gremlin>
In-Reply-To: <awWPTMvlt34wPyux@gremlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|DSVPR18MB988458:EE_
x-ms-office365-filtering-correlation-id: d8ca2174-0f4b-4bc3-1814-08df4a56fa8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|10070799003|376014|23010399003|366016|18002099003|22082099003|4143699003|38070700021|56012099006|11063799006|261028144727099003|261026140227099003|261026121527099003|261022105027099003|10067099003;
x-microsoft-antispam-message-info: kzq/t7gPahLkpo9ddq5l2z+7wW5r5oMrqa7g8UufdOtwqJiTuiSzqzV8ph9ZwkIX3z2oRVKWsja8vU8+uSp92qbUWA8aPOCIGSaL8YRXIrxnZCYfX0CNq1qmSw9djDjGeUxBsnRJL8K2k0/Bedm3H3BP2VLrnQ/V/F6vkgVFPoMdQ7jFlAHI1aV68z0o8GptMqJ9m2LZ3QzamkcdaLFS68ygYRblbgCh+SO8EVbmfP/rDX3Txuxmy15NsTkh4d/tLKFQ1tlr/wkoGtMQSp0SsrrnKxG5Z2kaybHjzjmo9nzzvArF4lYnA8Q7W7PFJytymet6nYkVD48u6xWk38xndMVnSxMhdod+gX2dZHpzzKkc3WDqJn93GYT2axaFX6wf0CMdmLE9XH5IUKPbZPhZsNq9ylXUrduJXmwF0gmXxhvZ+pJBeaFtuZtYxU3HETk5O5VewZruhp52Zgy105xCvj1ygn3BLpd+1bMHQGp37njguREDSyQa3eTiHjThVK93zbRZHkeQGeyt5hxfNS7tRMPmH0pc2GEIKdjz8ewo6zA8TL0FSXRAmk9zUKY7cYGVKdk4DPcU3Hsqf+UTIPg0VRWeiPYZAVfzbmgjesSfEVGpAepcrKUAq8VYJ/0crKLIzAWR4lay0rJ35TXC5lMMLgaD61H/fXDUbUPrMXwRbiMw1fcUevobDedZd/1ivGH/Qk6J+PAiCZCx/Nleadekc0hAPdF2psDjGOhcGiHrHgI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(10070799003)(376014)(23010399003)(366016)(18002099003)(22082099003)(4143699003)(38070700021)(56012099006)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+xEUqvhmP7n7O4bQSm1RFq19B08xQgHS4iNRkNKcFTka4ZIAqhHuh36wBwmt?=
 =?us-ascii?Q?bsbX+nQxp79cEoirW6/6hLznJRRrdx41dbKguUVu+lAWfurYs4kTcMqJOJCm?=
 =?us-ascii?Q?7Gq6C7gY4cgpfV4TI7uRC7ceGmazK/2fIrcb65OClE1HK6eCij+GzvoHtaFt?=
 =?us-ascii?Q?rgkhCphnJdmwCI6hmGo5LWxraGzlbDAL3jp+98got9c0XWDU5fCer9K8mOCR?=
 =?us-ascii?Q?8g69ls55MFFeLkxJZ0dX3sZ14pMvtECcxcOOTqCX1+FNjzM3HKfpg5gpVbVA?=
 =?us-ascii?Q?Hto/0NdS58wfq+/usp6cap4ZxnWIQ6arqiXz+Kbm/F54bShpxThtuHaXdA2i?=
 =?us-ascii?Q?45OwIGoVlFdGaWyMngbdqlpDGjIIOMqpYk8QFm+tGt7z1iHe5dPnHDiCk3kL?=
 =?us-ascii?Q?8E6H2muGOcfyupA0o/SmKRQJkunUatc9373xbX3WU3C5SD6DOfr5dkRyB75j?=
 =?us-ascii?Q?r2mFn0oWIh6ixgyHLmfDjmwOkCgjG9uSybCsgpI+0PeuBj2pSDHzJWe9sXGg?=
 =?us-ascii?Q?o3wS51TB7z5nbecoRKjQWyX//hehDgoLapk0l4NnNKm31DMRGvnOhpxQAGwE?=
 =?us-ascii?Q?gkkBhlWaWq/194+/hnuAlcEvzws8M0B+v2zotn0pVJ+PtUbRyEgby31M8eqe?=
 =?us-ascii?Q?/o/ZTcJsuHgVFK1GQ8WPw+r7Edc3bn5zcGeDWPATEkK39em+axR91Wo4PYe3?=
 =?us-ascii?Q?1XXVlb4oH5Lc4YwzIeBsHWk6dIkMgHl2hbSLtqJ5YLQYw489D9y+kPKKdtwI?=
 =?us-ascii?Q?1DxVbXs60/ureDYpfyUShTg6m2hIXlC27IDoULPOgxCw+vPuQAkPRf2ifgWF?=
 =?us-ascii?Q?LUeQkisMEDf8a+GIIXjnXp0Canx4JQtrOI0LU57yqg2UBHP7pxDxKqDhzKLj?=
 =?us-ascii?Q?d1HbjzLsvMKmmoC3/C8BvOSza1ms9I9ArlUb7QV7zCG1VOhYoW2V+zvdD+uc?=
 =?us-ascii?Q?hxx3QB8zbj2rqfWsh1/1fz+mVGIXRjN89jDn0ZOGgjeo0a7tFxoBmnU2SRyU?=
 =?us-ascii?Q?yHtY20FMuUZxP5OjxigFmEsork+jBoc3GEHZAnF3Kuz25TMlJO+zfPSAiCan?=
 =?us-ascii?Q?wZ/x7skXEFXGYuD9xpvuT+Gtupv0hUPb7pfTLTGeRHKVtgQT2OMZBkf9UoWY?=
 =?us-ascii?Q?BlgQH+bSfcype5tQ0YxconbYwxT+BtZe8p45TiVFaevgAlmvFstbRc6CqGO3?=
 =?us-ascii?Q?rQnV76kzJsirDf6fnkMpZlOYs6255uWflmGIR7I7XAn8PYwoU7ikYshP8hkL?=
 =?us-ascii?Q?j57ny1etFHsF/Ppg0FLfXIFc2Aiwe6k63f9JgT8VcPQdla2T4Ph9Cp3Dc0ws?=
 =?us-ascii?Q?LN2P6u97OgJ2vaIqb7WUfGsYnOCipSGC4PJ9WZElyFaA9gvKvEOTNr5AbwOT?=
 =?us-ascii?Q?DQrN85zIio8iDRZWQVfQHPLP4b0IJWwLtxIaBUoBMqOxOvRvkQw3Knbw/Fb2?=
 =?us-ascii?Q?sox7jDezo+MpGRvH6Qkq8U+0U6JEMtaQHYNJEJMOtLQChBcgpawXBUVbjI3h?=
 =?us-ascii?Q?eRDAcobjUKgbH1P9uwkQF1U5m8KZlO9xd2TKbH/qxzU7LWdJ4v0HES/aAMUN?=
 =?us-ascii?Q?7tgEgNn8CWHpyLRSy+rY+K6zUIsMMmTd0Jk9aIa9K7ydqC8uUbUDhTyOV7p5?=
 =?us-ascii?Q?aHou283BrAtb4YRFfaxG1IhBRzVX3Fmk1dvJ8xgct2BwOQszmOSgCnBznsC0?=
 =?us-ascii?Q?4PtZ1eJgt2uqERbLcoe40r0w9OTBTBsbTHZMRJ/n1pDUCeEeKbx03KI1I1vL?=
 =?us-ascii?Q?FVnvI+Dg71/sD49DiVfY2bUbtLG08p2CTSsStNpK0ExUD+8S/kkX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Rv8cDeUJqXCMPcouZXXlh2bQ+EWz79qJM45tmn7anZHVkU3xV+Wnlj9bCkrT/zMUxHeMxaH08oJipOqkcLlewaBjHT5w6kVbX/ubsVoXzmewEwLhTGZE0jTnkpVpLd21r9Ieov+OWgeEWeykHdRwpyOrUnJXmIpHbFyod/hp7gu0aLpXwwfpBTkeK9tw4iZDP6Ktf669GH3QHYuPGr3F/JSX5Ua2SC5BXQ0LByFW8+9XzSPZREDPRv0b0SrXw3vIp9YR7dEtygce8fPR9cF5086vkAmJluaAB5zwmkO1ncpn7FAw2dpRMHqx1xvP/6YbyB4liKwBOH0EYzx25l3XyA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ca2174-0f4b-4bc3-1814-08df4a56fa8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 18:15:54.0259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SCwhWzTmk6wFG4cU4zWGYqAGSrXbD+Znp9aEODVt4+AlPp7RUislMZ4LmqX27B7vVs1q9EXEIUfktiMVTevfLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR18MB988458
X-OriginatorOrg: amazon.com
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: rzgnmag98x55ynffnzous8htada48irm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5420100007
X-Rspam-User:
X-HE-Tag: 1795544163-597424
X-HE-Meta: U2FsdGVkX188FO69o4lc85o0+XrUOnA7VrQuK6C/kgsOdUedei6XVxdr8pBFprhN1ACN066oI20WLLKsDl4jtrwZhbrHlfIIFluv9lUabC2T7r5UuxHz26ksjXvVGpJl5odFFk09I3dGl8zGJ6hl0Cjdtz3Zi+iVw0cWTVw96HNPuhN7atRcot8P4eisg3k41g2uxEptf1DnqdCRoEREThHXCO+1jbyIdxqJhjordoAin0XNRoCa9+Gm16UntrH9aLXhJ0Un6+fzahn31JF/b1E78ZLzvkWxncZkalCS36DDj/gmToiREt7/Or6LmWvqMhkM/flonsAPHcHQ1AwzDTMxq5ebWLn3t9T7jkoGFmJvhCITqa2XK8zPE7PkwF2R3othXaq6j/MDpys9SZzqYDnOmsg+ClsZ9H6yaPK3p70OncidndNY7SopiHEa8zKwkV+Ib3yf77gEpaY+Ovr526tvXXLjrBUw4T1rRB8k4tYckw92SBe2/QOujZwJ7XySSB0Vxux5yQWjNrjB5kjzzpE/VZLisS+pue9KFJLLc5Mg6lhiLmLJhwfnsMw2rM0Wo4pkzuEmVd1kJQtoJcZwxcaF1M7r/ilutb/Rotp1sBGxSxqVXFy2zp3IcDpnm8oOkFVrUfzRnhEdGw6IGHNYDz6N3VvQ4BGIGcqhs2m91bNzHcpKVkbOV3HvAk4BuL6Cag1hSF8z5Ito+V2nkowsURw38TwKsouSikBSuM01lD0KyWSamgBgoqQV6uMq5wm6RA4zTjyT5Qsj/k8kPvvdJdrH0w1qSkMPLsFuNaU+m8LpHgYcmRnTGbxUtOSz3/jSLsKnV8eYsOYeVOnSoW4qap1IXqQu+9Obb8trybNNM7Hq+auwgPxlZwSKSTIp5VBHDr7OLlq6so5Anl8K7YoUJ4R0VyhfH37bLf55zmwb8jIj2MZ6JaM94FEl3HlpG5Y0ByoEH825kWPmbJ7slNx
 kkyEmTR3
 4NFSLeP4NCWko0NLvG8DxVZabZH6QAQFzd5xodFPwgztLjPrBw9LWGDWv4tVUFyQVc+VVXWNBjDVuKF7tjFy+NgVYLOZZY9YnV0WkF4d1yE/ocNklTEhD86zXkDS6bSDmU11xv6dZ1NiMnq/LYFqbwVxgTJhcZD0dJeeCgS0GkTKiPUVwZKM1JU/fNxLP5MkLOqaKQctS5Vuj7d0a7hf1o20AhdEa/u6XFHPePLe6phYwKkfS6B7i1nQaS1jFtK7Z+FZL5JeLTslDZFE6UXXUVpNu1vKfmw8QPEwTB2wu4Me8yGxHg7ukKDDh/sGfoBQgcizC469en+h1ymqXbgY1UK/QciwfDCsDA/3AjQs6FdCWBGUIdhd84ehZ2v0ivmRDq1WZ7bBpuFBI+h+/0otq7oEds0k0SCs27oF3zgXh177vx3E2w2pn/PhZOllIgWeICV9ayDJ2ptrzIbP8uEGqHPDDvMa6TCH7VXKKp8cTWF/kZSMX7YNVI6u+ue/1ddVNPueqOcTQuVcfw5QT8uBvlX/cvwe1AFitOR31+gd1YbWiPg2Y/UYhUOz7wsB4NCAlYLXliJznt1iKHsRPkAkCaxBg9wnH34hNgjVL+cwBssV544xA5tiGCZDMLF39hUEqpHFgQUymbapyDCTFznvhtUr/tB5pK7dZvt443xSloaygyNv7gQVJQZaFvOM7Xc/L52NjubriaUNwq1v8fhqXOWVFYYPze9R5BOOBw9isFQyyuUrQ/IjqoMqfGxU3aMfsrlGMKfwo4i/g3NhEueTttWSMOY52l8YfwW7KLCIEPtUGhhNVlPBn6nmmVRzUOlHU68XFi6AcBs/K67b2xzQZH1kzlXZD/pS3j16uinJLjQ8gX8NuG204+GHUapPwsfiJOuoOd51JuMGJrIgNKvGJw2Bbo1kQKn9R4oq2bMfkvDzXeL8zpV5sBoWIJ3lJbsn+7eSltvDHxR3p2mv7TAkitc4gHWCZ
 X0gfR7Re
 gOMfbk73gr9ah2DCPQoNWkPwYHX1eJ2y/BLvdVbrX1GhTTdUN2GIZ0BIULyuljz1j24rAAudHnBLg1dpQY6rd8EGAAL2mL0NKeXSxqmtaPo2AucNZaNtaqYGPBW4w2RiO3PmOKsa7TGWbR1Gq3IOjldRulBsovZ3qxMsAO1N/9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 13:28, Lorenzo Stoakes (ARM) wrote:
> What on earth are you doing, Eliav?
>
> There was outstanding review on v2, you replied to it with what looks lik=
e an
> AI-generated response [0], then instantly sent this respin out?...!

I did not mean to annoy you, and I am sorry.

Sending that reply was my normal practice. I answer the open review on
the old version first, and send the new version after that.

I sent v3 because I misread what David was asking. On 11/13/26 11:39 he
wrote:

> Before I reply to anything in here: did an LLM compose most of these wall=
s of
> text? :)

I took that as being about the whole series, not about my replies. He was
right about the series: much of the cover letter, the commit messages and
the code comments in v1 and v2 was LLM text. I spent the last days going
back over all of it and rewriting it, and I thought that was what he was
waiting for.

Sorry again for the noise.

Thanks,
Eliav


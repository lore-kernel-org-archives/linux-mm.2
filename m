Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F09CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5CDA8E0157; Thu, 30 Oct 2025 22:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D8C8E006B; Thu, 30 Oct 2025 22:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD50C8E0157; Thu, 30 Oct 2025 22:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B93EB8E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:37:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55CF614019E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:37:12 +0000 (UTC)
X-FDA: 84056847504.13.714BABB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47DF7120005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:37:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W+KT/Cx/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of adam.c.preble@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761878229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eyrkJ3WGgBMW1I0oNDs2A1rREmZoYSANYHKFbGdyRHk=;
	b=A4dEsrvJr2vCGN/Vfq1Sywced5g6PWH94L2cBpEvqVueX2hhzV5eOK9zIWzSzFT54LXuUM
	DiV8S9sf9H0my4rkMtoMJT0oimSbvZjLee+KQ9pGqBOLGJAa0pjbiqtsLzlQmaW4WwLMeH
	sGT4d0tEdKjt/8UtPLoGeBs2rmEbWeI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761878229; a=rsa-sha256;
	cv=pass;
	b=wz/LfUqxPxUa1hewzz+NEpOa3O39EVF0umDg0WmaCqrVyatzuaJ34os+BX1VzAlYVhaQpi
	o1oEit7JBVMnrNGjOHB6/f8OlfOwUsTNVugUNXIJg+UlsGuzZPyTtO+rKGAIftRSZMRgUs
	k5HnVWXmvTXEVDq+xf5mnljByrxU4PA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W+KT/Cx/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of adam.c.preble@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761878229; x=1793414229;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=eyrkJ3WGgBMW1I0oNDs2A1rREmZoYSANYHKFbGdyRHk=;
  b=W+KT/Cx/8YrRSvckOqVBtNyWH+rEzdMBA1gxupS3RKg9lp7UkPbvX+Db
   GWBjQGLjwD0S5NXy+ReY/4GjQWpL7Uw4ayz2Oe1wKM8zEzzQe/WlSX1mU
   qm1xyVpugM/oHBzE23iWhpobwv7PkQT/4AgQqGA9HRF4SK2I48Of0VizG
   LeXM4ouFWNGdS0WoNiesAaqOWwWLmHCO4YP4fv/Oa77UE8tvjcGg30paA
   7GiPw3DkRMEM0FPRyEdwCloOUJwczjT/taS3Qrm3Olj1/YZlZJGica62a
   OocIPu89BpgZfM4irnNErfbvovefSgxcXke79zSb+bMG+Y9DZCSbVN1kx
   A==;
X-CSE-ConnectionGUID: DhwfAnteRt2nKQBAM+CWyw==
X-CSE-MsgGUID: Plfqqaa0TreIamCXqPOxQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63960932"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63960932"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 19:37:07 -0700
X-CSE-ConnectionGUID: R7N2eACDSHyR/Lt/UYCrBw==
X-CSE-MsgGUID: Vt8ACPXSSPW2OZ5Gy4HnOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="190467747"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 19:37:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 19:37:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 19:37:06 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.22)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 19:37:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9i+QI/ARXg08BMSyla1/bVzszl+dbfldOWuzV8oPYQFjIc9Z0IeOcscvDZgOgdz4Ho9zxSLwJKLVKzm5rBJAKToNHEuFPdpFC/sJNC+wzw01IS+usGn0MA6k05p7wfzYj6/F73eozw2HktKJr7pzWB8bpv28G4LFx7xifJnrycCyfMAeDSk0ikXYC7rGOxr0rngpZoO76Yv0rqPg25J4T+/WuZEtZv9fULJvK3kfyU7eAIDafJqltf90LOrWr9JxxDPd9kr+cuwULRt2+ViEyColOy1F3CZVG2weT8Oz9uiLWfpOsi7X9sBgvVrNXnYT5GbQlsJV7hKHykuYuXQ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyrkJ3WGgBMW1I0oNDs2A1rREmZoYSANYHKFbGdyRHk=;
 b=PKxA2wPFp28WFlsXhap8lZaJClNOimCDELp7R3NnS4bJtOnuQQb8uAPbI3N3o2Ouafrn6Xxu8sMiAaAr3z0IbaXjKVhXlLIDzeXqdhE5Sx3TwMIK5Wi8fSkZ0VWDfcEE63K0Q55SNAqV2ZGfsaLRvdhRAN3hBnvAPIW8aTxjrcne7MwKxo8tVmxuW6w1k3E2IW12/rZI7B4c9qkmGoBG7RpDBTpdIF4A2UH9gXmR0VAlQp+VgWQz07/3jnHW9dWWuBjV8zRpmRCLnLDeLuA3VkTIxFeQap50+F6bZiEuIBy1SwAguwx5pZhC/N5Ql74rDvpdfKpWQ2RO9BI7eOqyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6523.namprd11.prod.outlook.com (2603:10b6:510:211::10)
 by MW4PR11MB6982.namprd11.prod.outlook.com (2603:10b6:303:228::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Fri, 31 Oct
 2025 02:36:58 +0000
Received: from PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547]) by PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547%4]) with mapi id 15.20.9253.017; Fri, 31 Oct 2025
 02:36:57 +0000
From: "Preble, Adam C" <adam.c.preble@intel.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Accounting for vmap_area object growth when kmemleak doesn't notice
 any leaks
Thread-Topic: Accounting for vmap_area object growth when kmemleak doesn't
 notice any leaks
Thread-Index: AdxKDzYkrd+pscpNQYqNN7VNL5I8ng==
Date: Fri, 31 Oct 2025 02:36:57 +0000
Message-ID: <PH7PR11MB6523C5200943207E879FB5CAA9F8A@PH7PR11MB6523.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6523:EE_|MW4PR11MB6982:EE_
x-ms-office365-filtering-correlation-id: f6dca3e9-bdb4-4816-5a28-08de18265cd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?16YjXCcbb4Ukk7JLbrVuzMl5E4vO2utiz2NNGOEJJwtLYRNfZizWtl+9CHxS?=
 =?us-ascii?Q?WnXNlx2diuy+RBUqd/N8r+esKgE3qihMRJX+sg1uRLil9PqgR1hu8pPN4eXS?=
 =?us-ascii?Q?j9XX42Ge6exuwc2i14nG0j4x8ydjd+Ijh5Fe/gI7EQC9/jLr5uvfBLapmlec?=
 =?us-ascii?Q?4l7jfbVMjRtpT/Z4wwpbXrnX7rQm0NMGlGR/XQniytmggJHtla371Gbg3RGs?=
 =?us-ascii?Q?lfO/yDQJr4jObbyQ/Du6R1P+6PEKV0KKDvgzsX6DScv5ZpscCdR//zbuDtc5?=
 =?us-ascii?Q?AajkBgB+SPt9k9yqJsWk0nbe/tTUliwwEltA4qwmqivTx9aM98lD0eTpMLbR?=
 =?us-ascii?Q?E0OR/tdTYq+vUVmhm96EgIrws7dF6wB4wTEohYesiqRDh0+v8Qcr4WKll8az?=
 =?us-ascii?Q?DaKMyX3HtIGKiqy5opwx6Wkk07psTfjykh5Lnvm3S7n5hxoHnmuG3sJyrS1L?=
 =?us-ascii?Q?z3NmWQTMUKeHc6osGP5hv76qzHOwkKyBGS8KfgnU2IAgN6cpUxgy2l9droMN?=
 =?us-ascii?Q?ZvME7ICBqOnCZ7SxpWe6QyDdPJzg3KdDsFx/phArOKV34ig08Az16/4ycOCj?=
 =?us-ascii?Q?EOzE0ju5mnCab52P74hznoUDNVXcI6VSJjEEVR4fISuH2jC6QkYtvcyMmLOt?=
 =?us-ascii?Q?bbpSlEdLOhttlgd6N4DyHENhspRf9bjsvdZPAhONadFtqM3qHpxx38RgMRjz?=
 =?us-ascii?Q?IUXSs21v/Y3vD4J1gfHNIKaSwygvkafdaH46tvevWGmhTH7Lt55gK9ZOLz9X?=
 =?us-ascii?Q?jvnAin5dsaSsPbojKoXR7niLyElz0+KbVZvnDPoilkdZlWo9a3yKQhVDkdfw?=
 =?us-ascii?Q?+67KZU43vRQSbvOoSxs7UKuKumnZQ2Xoyt/iGGz0/Mr+d4BtAhp6l9FsX+9E?=
 =?us-ascii?Q?6uONQf07STsTXzZC2uzQ5QMxQ7/9jaINKvQVXVCD/InPc+JWSUSRt7x2tCTe?=
 =?us-ascii?Q?7LEbg3mtGZCNRy+HlLCHTq+KF73DcJ9JAZPBP6WcSP1xORQkKB7puUGecL4K?=
 =?us-ascii?Q?4ECDkg1b801Yn7+KRFNO88wK3xsZtMTwebp9h4SNej0DHjEJ4DcbFujIrRqD?=
 =?us-ascii?Q?Hy/IALjRDfWLYWzwNQuNZXyvz8R5TRvWH+UOjpLCk+PWa5cdKrkwbGHIZJAb?=
 =?us-ascii?Q?aVuNwllgT0BHEkSVGWHFRhp8QROnQjzrw5557Ls6A/nDgVOewT0deL6Ztws+?=
 =?us-ascii?Q?OjmCztoTm1Id8iinJvixR18gxiTz+cclqhfKJb6G5vAKgDjj5P8/7ZKUW7me?=
 =?us-ascii?Q?OmpO+u5TUpLMdxvl16j7S+CjCS1DDIpPuvnxiervx3f3zxPwPH1qGdZTyIsf?=
 =?us-ascii?Q?azTPy6y3aPfzmeG1HNcT3NPFixVVAgnWywdokCynAFxJ+OVrsW3bie0G1UhT?=
 =?us-ascii?Q?xTb92ppTnOq71vugiR5Pg5pWZuggzjuzW+D1N3zXvjnJYeFEk60xqvNujvna?=
 =?us-ascii?Q?cwfDmCHDwsf37Uwy9XmU4tq+VimadaCoHt2h7WvjEHgibM6nx/uxnzpHO17/?=
 =?us-ascii?Q?EXr7AxmxHIAFOJKyZCPR6fS7d9/DwdHiqKTH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O5rUqpJ1JzE6cUlhglyTHDHxEO5clw9NsCrZI33bOtq/SckeWvCUONAwOr5Y?=
 =?us-ascii?Q?ZeTQ7fc+d+o14tK5Occm2i6s+Ngj/aR0QL4hIoqmEpthz8azsHtwktMwuLz6?=
 =?us-ascii?Q?J0RZGftRxH6X1qZU9AIO90TB4S3ANi8s2dx2VBWbIHKuRfb+wDVhn+B3jT/R?=
 =?us-ascii?Q?2nhue1R8u+9KJb0/Nsd00zXOcr3zhJAHcs9fhiFC1vEeUEyiEBOqJXZG4eWj?=
 =?us-ascii?Q?55R9iNC3rTQ+vKPrHUfVsVVPcp3MEdFTBtUX06Zhqco5FQnNU2xmejnBix/8?=
 =?us-ascii?Q?JwKT9IoIvTJeLkZ6Gz8CWEAPP6GLW3+/q5dvh43Tjd7hwG/OxX485sI5h6U0?=
 =?us-ascii?Q?EsdbRIcDF1iFBsZTSjVyZQh7dOmM9Y2cTfZv+khOMxjqXirGfcNppGtn1Kw3?=
 =?us-ascii?Q?hsOixN3sa7R0HiEiZRDebEEgbxA4d9XXbVNUY5ZmVqJV5TKmyoJotchvktgP?=
 =?us-ascii?Q?eV90+kcqeCxZ6fgkJEGZQgnBwc87zrB9hBObAlS6Sl/6hyly0nvXCtXAepF1?=
 =?us-ascii?Q?OVjDVv2v2Ob7BgofFFx9Pp7YkIM23T2jCqGY5EZTRksj3tfSOGjceWB5SG09?=
 =?us-ascii?Q?9ZXafzG81nEK2XXmRapYa1Q6BXoS7xpPk5f9ADsOyGnmUNLe+yGbYALRXvvs?=
 =?us-ascii?Q?kFzZm59uHcVxGf6jDvuK5u0Ia4Z4FBUkn0vFrxVgjac2Xf+cK0VL0q3zYj2Q?=
 =?us-ascii?Q?mUdv/hCk0NWouQPPC5jXRO452u18Box7kgZvOyTqe90SJcxoqZ9FafK/yvhU?=
 =?us-ascii?Q?uBgcAYqkxAEVnYRABYpX2BeekXjMBwP3qeeOnEZSqD32LaQcaZZCBTbxHNQL?=
 =?us-ascii?Q?HIeaCrjW1MGLJoS7KqDxH7io1xHMRKHJxxCcEtKpPZSITQABEylF+xo+R+nA?=
 =?us-ascii?Q?+otKuYbS0X56pNj3wovoKGKglmbO5yrmOLxnaeFdrAjFo2TkX04y2ghfjEKM?=
 =?us-ascii?Q?gLXAnnqP8E+1ARJh1rcvl4aau0ea4ry2d4h1K73bcEhVifAB3vB/HQ+G1mty?=
 =?us-ascii?Q?0sIXmspkATCSWOVo/9rQr5fVxrqzW5UM1vFSITS75ZbCZ32Tq5LLzAeD7CpS?=
 =?us-ascii?Q?MJy3K7EG5+UGNkrix6hvX+LgnA5A6NuLnQ0mk18/lXHqG5GU51i8LQjAwgBd?=
 =?us-ascii?Q?PX+Fwx0bhXOWlFb7igYjOb8rb3wA0NXTKXB9ZmE3hSsIyINHhKc1vUkh63w2?=
 =?us-ascii?Q?R0pOthunXoBZyXs/qcgrff6s+gdMUOnl1Wjljm7TrGrUPjyvbmxSUeq0ImLB?=
 =?us-ascii?Q?pp+8RDWUwH7fsOo9S8p4pGsId9i1xnHafB2xrxPeWd0q0JsYr4i1H2bJTzly?=
 =?us-ascii?Q?ULrDu4DapgxnfskqRkOJAp6Xq/0y7JqAsAdMR9FtSXdKPwzc/YfCc3Sr+v5X?=
 =?us-ascii?Q?P80cHuaNwnlJt/z6q+3Ezxx1a/NSApZjmmqDnkCR9SBPAjIhHmx8orQ1i/VO?=
 =?us-ascii?Q?d2q/DPGUhefBRamcRpsmyia27YYdMI9uCYDN6X7H1vnMZvdP/ghzW8atFlok?=
 =?us-ascii?Q?hGCCShynyFjKM4mcNQbU3DIT/0LsRZIYNW81AgKFDL+Fz6YUqYyaEKfrANJ0?=
 =?us-ascii?Q?bN3u56t7GJMptX6Zh70WDHLuMQ6t5HGVuKfN3m+G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6dca3e9-bdb4-4816-5a28-08de18265cd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 02:36:57.7982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MO3ADYgNX6hWVOEt2mh6285eMdDsJCRKoxRls2rKWPI13a9mxsBPcrKqfelV6hsLq/id8sPyBapFuGhIVTRQVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6982
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Stat-Signature: dsk9hu8jdgutsrdzzdynrrii7s4phz99
X-Rspam-User: 
X-Rspamd-Queue-Id: 47DF7120005
X-HE-Tag: 1761878228-569352
X-HE-Meta: U2FsdGVkX1/+Y9ZvQ9bcGRMais5K2sV54FhmEDwERDS/RHi9jSQpkcmJAv//er4A09u7t9vqU8wkmcLkYaL0t9F0GhHvy95IxaPOD8QveI2l6tNmmkpofwbr2gn2wRU3M/62WZsGBtPH1nZA3l5OWM4Y4mZJs82DeeEs8KO1Xfi4q3FpR+HfsZxzDg7qGmfltt/RdQPsydciz1kvacdRCgIO7IpmES6QznLukG9BNHXf0hLi9wmLJiPvNflyNEd9+4XRg8O4vAyDoqbID9JRsGf2bVBuZoszORdMft3jycBDL3hiY2XJYMfMBymUTzxoL8XGfsr0J2SrNMRS8yn+MR4pIlqhzhFYNrVXfAtQpGw7Bbjewl5ziuw5lL49KmNvCbjxdBSeBFviombNbRw9GynCeM1ohiHXXDujg3MvH9h62NcqgXywgHu60eaK9hpx8ls8qaNq/vwTlhpEKJeC0dKh846CPJ8YrqykGoHbWricv6JeQq6BRNKayNHoz2qP2c0rgi9nRTBtURbHFwTFUrrqjuRmOq0ApVez5WBQFp1gs8o2xNnu67LyTsd5VRXsp6ju3uwoSE0ffH6OaOiNu0BQyG+agX+LPDaXgX79B0xrwGz2ncvzptLuog4qaiWiLyordgwBQkBYVIu2BXxZYYBxZ4NmrkHHuRbzwKdj0XPfDvmt1YBTHznwYlOmWsBnIP+12liJOelwRM6rMRuSzuX72ZjMl+nxCTACPc6HvPewb8pWTI4KaQJ8MAoyHOQgj4GmnoCM+JH4gcIV7fjiGwJ+BJTbemdWMBN4PdANTBeX8AtIJqbsfoYs5Lys8wKAci+Lah1W2H0OqqPK91erI7Y0mdoZbk+stXA2JgH10x2ExkWjjpR60MeUk9DquAnfHJaLx+WDpvnDzvc1XaZ0W8pS5rSfMHzs9bMJ7BvTme9lbl3C27S7457YhI892VgBGMmXPWeXzHnmdDYs1+Q
 zOkDGMjg
 bH39S0tmXjYTFn3zPWjItKyQ058JClZmUJHPCFsCHsHKkJk2FuB6CL7xcebMsbyz50L1BtwiVPxyB1VCRy6pvuZqzSDnTKIGtjF8X5DEktggM+mJc3VlvgzKQgEIV1IoYiGlc5mnhGd2b6KR2Z+FEYm2Y+A/BQ+1BVSFvjqyLQoOdGgUaVNIJejCJn5fYYJqj5AJmphli4rYRn7MT88G6bOyiPiZEnyWzzMzvQhuveEqWeetEcZU6tK41WOxlSWygv5cPoQX2RGb5URlPVTSBeQgP+lmNVw949CKbPTx6Aw7LzhWVHiggUQhtkW6bb8hA854qcThBUCi2o3ZttDFmRbO7KheCbxOtGUshK3bQnUfpR8576z8jtKs0ZyQ4yeRpY45F379R8yYPT3AvmD9RdAZ4OfiPz6dVxQ6t1Bp3NVItU68q0klmshpxIdlqsT6sjRX+l49ClX1R433Rl1Ef3n7ch47mUjH/xt6/c4Il/9SI41P9hUbazlJAwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assuming I don't see any leaks from kmemleak, but I see objects growing fro=
m the vmap_area slab allocator, how could I account for the growth? Is it a=
 leak? If so, how could I isolate them when kmemleak doesn't notice anythin=
g?

I have a workload involving an external kernel module providing a filesyste=
m (no actual physical device) that had some leaks that kmemleak spotted and=
 I fixed. I still eventually (very slowly now) crash the kernel by running =
out of memory. The only real peculiar thing I noticed is that the vmap_area=
 slab allocator in /proc/slabinfo continues to show growth into the hundred=
s of thousands of objects. The workload involves loading the module, mounti=
ng the file system, running some tests, unmounting the filesystem, and ulti=
mately unloading the module. That should reclaim everything it was doing, a=
nd I don't think I'm seeing virtual memory fragmentation since the buddy al=
locator seems to stabilize on a proportion of sizes (disregarding it slowly=
 trending to the smallest size due to simply running out of total memory).

I guess I should add that /proc/meminfo shows the used vmalloc'd memory as =
stable this whole time. It doesn't increase. Total slab memory used does sl=
owly rise.

I have tried to track allocations and frees to vmap area with bpftrace. I h=
ave a kretprobe on __vmalloc_node_range_noprof to hash the allocated pointe=
r to the kernel stack, and I remove the entry when the address comes up on =
kprobes on kvfree and vfree. I get a few entries this way to kernel_clone()=
->copy_process() that I have to sort out, but I need to emphasize kmemleak =
doesn't point out a problem there. So I don't know if I'm just picking up s=
ome end-of-run chatter or something.



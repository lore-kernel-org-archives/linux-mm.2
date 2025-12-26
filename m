Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C314E7AD7A
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B976B0089; Thu, 25 Dec 2025 21:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5746B008A; Thu, 25 Dec 2025 21:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB2A6B008C; Thu, 25 Dec 2025 21:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE4D6B0089
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:51:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C56F7160927
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:51:24 +0000 (UTC)
X-FDA: 84260096088.19.7F7661C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25E83140004
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:51:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kYCTcsJd;
	spf=pass (imf09.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766717481;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4+GAW1vZayGvEPcte+KG8N6mygbVQKE53fFTP0ducY=;
	b=1gLUYR0crevY18RYnmltYMvgp4ySsuPxD8u7Q7RJ3n9F15Cpv26ynrBw1ATJNYO4ak7/A+
	EP/lLnTs8PgaNv7McLiTXQRAdRlni7SktX8WvsEiRdJ4jrHrgNm4R6zUJK9zvU9YiIl9G+
	3CmC1ye4f8pu1vhVpKfMqBP1vBZGHms=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kYCTcsJd;
	spf=pass (imf09.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766717481; a=rsa-sha256;
	cv=fail;
	b=kRMFSEWfDYJqe0MLcHkbEPUarAF6coyVa2DQHrmtcJeE4A5wljHM7Oa4pU57P1ICsq0iNA
	2JkHXjSf0HF00VBIOzqcYNRd1Om10sEhfLRiAa/Clan8aRd9+kg4GOpN1Y7rkr8O64kHdM
	eNDipMDIsxSDnCGHWWEbIzx4EXfQsbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766717481; x=1798253481;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YQSLAwceB6Qb9vxJ9ATo6uFdwk+Vl5r3hfZAxMeaFuc=;
  b=kYCTcsJdMelPXwgpN/nPEZGRipDb0ddJ+K2CkuQY+VQUu06Yip8WDfsr
   ikETdOagLT2uy2kZ1WnUAZyju+WpdVbleIrOvrCu+6PFyYYqOAfuCKibj
   EKDPfHwoqhAZkusyF3F+M30jINX030bJa9K58ZX0CN6u2wGUQvVTU4JJP
   X+RJetVB8KoZovDS4eDpq3WV9To3GPX+vjtdRJgT3xM6bLwnxXa81X4gS
   Qx1pxM566Kn4olYJpTjCCDuefCh1bh9ll6t9LFhQsf7XgZ7MH+JpAB/oR
   q5PHe25cvnjBdpwVSeUu0rqdEbChkmPoDa/SZZfgsaabuLOzUJfXlGPd2
   g==;
X-CSE-ConnectionGUID: j9/CbEqOSwCE7ckg9TWZwg==
X-CSE-MsgGUID: 4sU1X3s9TAqsOGwBvplByg==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="86072401"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="86072401"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:51:19 -0800
X-CSE-ConnectionGUID: LClLOY3QSlK0U7kmupjhGA==
X-CSE-MsgGUID: jT71dQlaQqODHpFQqnypbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="237708246"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:51:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:51:17 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 18:51:17 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.0) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:51:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qd8n1Oh8QGwKIekfanzhvTi4bPq1zOmMRKMuV7uh7VxTxrgFpihLxMitDGwuLPGZeoxemGKCeznC5QjXioI6cEQRj4rqpW+ZuhDOSuvjCo3cha8D11y2knQ7UMopsM7NicnqlYgjjnYyhcXI8LzZmmmIgMV7iW1STJSUhggF0EPqe050mVt4EA1DLut9zJ6Z1HTyJShk5XYGJH85z80orewMWbDbwat+u+U5cu3qOR3JzgN631dNRtn8TWqvH85nKq9x26lbOaEmxUaDePQEg41ltI3wH2JZCxwiYQ8i96u+yoBp9TPBbe3BPtrMXo4LXnIg2ysoYpHWyY4RE/pJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4+GAW1vZayGvEPcte+KG8N6mygbVQKE53fFTP0ducY=;
 b=wm3UqnSqKvhB2+nHO6VyEVBIyiLAv4cqKJROiYc0/6ByhM6FFZa7624Wzu6vP79TnII2ezQvgxIjahQ5cSs800vgSESjbWvli9o/V2z86VuarPBcWh8wS2BSumSIo46XM2x2MdjLvaXFtxp5puRrf4h7ASq+2sJrkKBM7cW5xhDwRCI0G2TRB+q5K6YhvF6mYSRS6qFBSRfJiR2mgNkFF5BLP6VDMbHXsVYaHeDNwMOabJ1L7y3dEscX8U5w+67YbKMswOTq7DyCw5XHfV/jez92LTWSzr3kB6Nl5sRQkjz9ixbF86gPygyu6jvgBb/KMJCfWloXCOWwKq3wdFHhxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.11; Fri, 26 Dec 2025 02:51:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 02:51:14 +0000
Date: Fri, 26 Dec 2025 10:49:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"david@redhat.com" <david@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"aik@amd.com" <aik@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage
 handling from kvm_gmem_populate()
Message-ID: <aU33qm9wwfdY5301@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-2-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215153411.3613928-2-michael.roth@amd.com>
X-ClientProxiedBy: KL1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:820:c::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b69aa9-3a6e-4f8a-49fa-08de4429a270
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X3b8qAXePXSAWqP6lJeSQXEsV4uAxn07+ZEz6GkUTdsK3AX7fAg/fgJOR5uf?=
 =?us-ascii?Q?3PcsRQpI5LRFpOxi55YQv2Pq8cWwkN+mh4IHqWYPi78JcgVyTyHNYppIV8mm?=
 =?us-ascii?Q?5CdWjc067b5zX0mfjDEZfBcKuuLkkxyKfR+GiZx2K8QNTRPFjWF4bNWOk5w9?=
 =?us-ascii?Q?7AxOuUy8n0oFlJLLowUZjHWgOIrweIvHrarhuAJhpYAqaaEUM12DQT7G/NOP?=
 =?us-ascii?Q?ZucUWCfs8d3kXsaK6qPVF9j2B6ON0UJ0IsVTVsqvDUaPq3Z6h3c/UJE8uh7+?=
 =?us-ascii?Q?hJcltNmvdN41S9GPeq4+H8s26LEigSetzj4S3OY19rYSujVCHQ1ivBLa0Lk8?=
 =?us-ascii?Q?UatS3MFOxAyVTZzXwwzGngKS3FiP80tnkUCX+wjxV6XVMHn98ISzbJ7WQdsk?=
 =?us-ascii?Q?8IYcTgHUmeoYLDXG4Z4XpVwitvq2q0ZQMeHwbPVQQKZq53Q8I+6vvSJLJeZj?=
 =?us-ascii?Q?epCCZ8A+VnYRFy0iZS+UXlbzN/b1UZKpzZU6ty1gAqUiXfsipuaMjPGMQf4O?=
 =?us-ascii?Q?zhHZkaEyA87curc+mbKmC7kQiv4OZv5SxZR0TVwBg2W1s2nxPFfagv56VtQj?=
 =?us-ascii?Q?QNkKUVrz7Vvm6WfITMCvsvggQ0LYIKMEG39UUCbTuvsZQmFGpm25qfYMpT1s?=
 =?us-ascii?Q?QOVCb80MlAfqUC9UnO4mTupo+L51w6SxS9r6dv5u6Et3EnRgRxhJUnD1w+X5?=
 =?us-ascii?Q?P+IwVW2r7UgXSHZLsEegB90H5R7By/qCvGuvtn2K+hwiYq/jTdTaOCYxZhI8?=
 =?us-ascii?Q?IMM0S6zCVRuwwOGwOsGa3cDP9FFCGIbRX/UT75fy8YS5W9O5q+jcVyvvZLz1?=
 =?us-ascii?Q?A3Y6aYP18iXZwW4+dj3s8KLd3GLKuItS7ZqMMxa3q4yM+1NHr8wq4FUsgeNy?=
 =?us-ascii?Q?B76xkY0nykUkJwKVz7rvjx9BGGrhi0PozhFSYEbvaTogbc23jtmxBaql475w?=
 =?us-ascii?Q?QEAOW2pdNH4LZR3pQYyW2G2lAoHK3mMqRHRvBElbXo6qa+Ngdf5VVoz2JrNj?=
 =?us-ascii?Q?nOqSATwgSl+Leyct7rQIPBUIsR/i+4Ntb9OqxghfhIhn5YcwAKlE4X2IDgnd?=
 =?us-ascii?Q?07XqmPz4aF+/fJBXsf4DKo7JUWVHfbfDRZA0zB89WRhtB3o/2w/C3d61e6SD?=
 =?us-ascii?Q?0/J01CgvZ145JQwK2o6yUZVZoFAbwY4VCK+dQHZfAQWyPZK97IfMrBXUheq/?=
 =?us-ascii?Q?i3O6KE4TPaQAIU+EA6rd2+3zOnOV5DNtegkcYTUi++UeAjUYzDRQuedgUSVA?=
 =?us-ascii?Q?Z7a1VMa24u/PlzqOK/2hiPAzEppHeQGHEIimDzZZQQjwqj7RzzLqiDQp/Eq+?=
 =?us-ascii?Q?5vgmG+2FndIto9mcXEegmsGiG0KnwVc7g3Wjxp5755RdXb+95tgf0WwLUefW?=
 =?us-ascii?Q?6+G13D/ywiJacdW7tIUE0NJlpdu0z1JFIDTEqSp2sy+k7g20aA/YXoP3g1gM?=
 =?us-ascii?Q?IYNSCu+UL6gWEJM2eyIGo2QNthAs+ZQk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ptMF1YpFxwr0St15fguQ+XowTDL5Q794oPGjreegZKJUWBhCHx5//kbmhW3q?=
 =?us-ascii?Q?eHF6sJhOeJcz00kUu/bAIFLHfACVRyH6hUNnGB4XmdDGk+Xyk2bRiwItmPzd?=
 =?us-ascii?Q?b0Vr2iaoVd83WcC4XGoPU6ANU7A6JiaKp8x0u9fRhbRrtWmMPJFzDzaGmFMV?=
 =?us-ascii?Q?Deb4eXTqVElgqN+v3mV9qodgjcTDk3QTqMDryUO1pEy3Q04VyG4bTjWzf7EX?=
 =?us-ascii?Q?d7GMeqGXJA79w343e0sei57dhGk4NKI//p6FOt+PJ7I8ie9m9YJTRZ0WqYuz?=
 =?us-ascii?Q?WaO5+rkiadGr0DnTHfBtQZxnrqFf0PxWdcOSYu5xcpq2nsu8ZZWUHBoH1jRm?=
 =?us-ascii?Q?L8N0dROUhzC3TRveV3OYtdPvGDQJbgQZZ1oPB6fzP1XnejGOLiZ0TPFhP5fE?=
 =?us-ascii?Q?2F/uTrJya4EP4S4IsN9qS4BqQvTzfn5FaqAcRn3xE1UwyKGcpeYSUya7r/Ai?=
 =?us-ascii?Q?praOg6xzqTqdUUIGCXDUOwV+LwYUHKilzFx33+cZ9dknCK+dNbxTVHlsjZRf?=
 =?us-ascii?Q?LnDg9FDR6AEu5fKMZCa9BqARmQBpxDuo1UfZ0ojm8nEozYmfqGWo9mc6AxAi?=
 =?us-ascii?Q?WOJ6ouODAaGbHBISHC4KEaC2Xzkw6DppJU+SEQ8coUbSY8SMyLhn9SUz/cTm?=
 =?us-ascii?Q?yNf1Jk7oXgY6fSXit4LJa2x5BNyvPRSKpTBauWZKTnf5+LJp2hIKovQ6OpeE?=
 =?us-ascii?Q?hmdK6BTSpLOq9o1e0dr+QBBCOj/mtpX2Jtq/SP0s/vyEU6WzK0CMJu1DA26K?=
 =?us-ascii?Q?S/hDAGVtzOoW042mpT7Oe2S11ogMXWfSpfSfZgUj1OyOLmNc6+OtpW1YoiAg?=
 =?us-ascii?Q?g3bFwvNFcL+25wSWbJujP+jxKFmBTCo/c+2Dw2ttCruvf27GoHKV3TID/UBW?=
 =?us-ascii?Q?fvoYUPJ93oW8ZuHerUq7K5U4j6EqMVDgrmEC0jg6RYPDOX1IXMeNZGIffAMQ?=
 =?us-ascii?Q?aOITpRNsMhySOnYIjj5j8pRFysuS26T8UswWrARCX8jklM5UFOCtI5n/JeZV?=
 =?us-ascii?Q?6bPXZfabbFE9g1e+E1jd+RtmnIE/3C8guv2lNsIAy+AiA7ctxQWya21rYPpu?=
 =?us-ascii?Q?eAV6RoTlP00h4yPhCSZRUiKxFVqAS+L+ZVSBE7ysZU6rgb8pHf6J+CaHHxKX?=
 =?us-ascii?Q?63toDuZL/OjkVPnZFWFk0pkZrynH53KpbXv8MYzt/ygE0N96ILE6Afc0uz1B?=
 =?us-ascii?Q?1piVpvQOsFOYItSGDyju4AIpzvdf1YgUNcliD/+POvcUH46xpAoJ4fiH+OIZ?=
 =?us-ascii?Q?gX/uNZxY9SmqRSdDqwbsy8BC/BdklcX9yn5KDPytnjcHZD055GjRmk1B+dPy?=
 =?us-ascii?Q?Hku92R2m3oBWzIAEiVhDIgKuZ2ghM5rOlZUxLoBPCKuXEh5Mkh8dD8N3bYRX?=
 =?us-ascii?Q?pqJ2HTqh9cimOJvTicpvD2xNpM38FrBdUOzEVXID55bFqydIRhgH2vgHfzK8?=
 =?us-ascii?Q?bVmZ7TntsT8PDyNxbVjR51o2y3SZxBl8ccBybIBR9FF0qkThUzUV6Q8EFEiz?=
 =?us-ascii?Q?HOF9j5QvjPzfPjgrm5seILzbYzv8ZggJ7WuCB1MYv2F3as3N+28DGnuSOJm/?=
 =?us-ascii?Q?cX8PoGy6PaI7O1Qj6yd615Xa0TBWuScD6oG9uhgiM2iQQrSvwrppdRAVGz4Y?=
 =?us-ascii?Q?eIHD601zj+7FUgnSAZjZ79sBJEG8reWVUpju2lK3wTD+cRfJKp13c00yUTVK?=
 =?us-ascii?Q?14OKAYkSuznHDFhBW8VMQUJUn0rMxiEhxPvCotJdVpEAFdxkOknKhYCBshUd?=
 =?us-ascii?Q?avm3P/yrDQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b69aa9-3a6e-4f8a-49fa-08de4429a270
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 02:51:14.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDZIWnjSRzT/XlwtWpUIcuX5dNtzPLt2cCc/IwfqHB4FTCVwXgv0XRx8HfXEUdlqcO8dhHSpBbNkNIH5fHnADw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com
X-Stat-Signature: 8t9ozofqbahmfgz8i68n4rn51kuqdmjf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 25E83140004
X-HE-Tag: 1766717480-7903
X-HE-Meta: U2FsdGVkX18AnTa8xq+dq4rlURC6NyBTNzERsgNIMSkRSmo5w3ZaWQpOhFyHQa6wC3WVX+ZyYtz0mxv4bl5RrKamqwJ6og21JVXckXSLlbllvnSlRPqss4TVLZglNPJSNmBIpJY4g1//Irb21JyHVrFsS0kaXrKSsLSiho+4eVrPMsjrl8cZJJtfkZMdryfEFBdKqd924pmHha6D/Tu45DtcNfkB7BWsSdm3xqx17hilN55sdvsb2Fe71b17v06EX/5PCNUjSaUTyA+DdpWGKizAnRt2bxeYAGAAJ+ha3s8c708RP/guitQ7tnE5EzOYV6U/5hG+3WkwGAkqcVf+lV3E9SG9aXP/gV6i0QEW56WcRP98MhzLuIeB3yJ11dYr1NTTZxfSlYSJK2K3o9qGh9JT7xmI2+JIxCW/i5CMfhreKHGIhI9NSRCFp2fz+twZWjZqrgUS47UaAsYGv/zsCKEAc82fAn6CbR3X70BKwgqtSJRoNC0F6XH9jGJ0ksdE0C3KTR60qYzjXLWZEZXB0ExPtLl/A9sswCMEywanBkCTHcVRyfSOaB8mKMtrtXvXllgArS1Iz+IiMHQBwrNcccTxKQHZVt8nMT8/qchG3et/XT+GSZizhRGTblDPOWGrMFg2cCm5t/5z+bTee61mmKDWqBkDsdq8IHzgEiec1kxn0ELUZ3ydAGijkNLaILP15cELBPq0bTpIKougB1GdqAhkDKL7ZjOntuk38vp8UgE/Ppi3yhZTAoxT16YuP0Spwi8tR8mSrWfWLKKUMKdzYEJjhmjEkHxRIDcatRupxRF2pDHFR6DaDIwJROObJfmcMCigbszbgjBkablKBPPEoheTCosYD3CFG6iREgiI0fRW11VenEA604HNeJWGdejmdUjbb0sBYlRAUlpfCBq9R1Z2gmg3daPZYw5fETYWsL0nMNPF57uI6e3tMeo5rvl6BveP0k5eHxvoKfifLx9
 eNMvsFq4
 ZWE6QlBJF8RpP8xdLha1k8A/2qKHAJbhpg7V9VVg0cFQ7851vCMhM9dug5DtqK4w8yqkNm+rCxcpPC4DUlhCkuWDbigKCuND3uPAMNC/83DeuSQDOfdyPB7N5xNldxRj5nBEMlW54hQLW2ujzpNVx6TYzYy6d4urucnAWzUoKoOlUPKpZIrrVoekAexyAqJCpnYvqDTfYbW4NXRJBtr5P9j5Fkliarq0bcSnSo+shYZpYtLp4qJFbF8SLPV5oUfu8GI0z85eIsAqdGCx7uyaF73Qd91l6CeSzk+lqqBegt3RQ7IZAbSHNioY5Hl33n1fm9NEwQRXnuMFBV0NIiaLzMRmpnkcrho9sJrA59Mw+mtymGEDft/oBqD8Ao57Wuj00HUAVqsKNnYcdhhQEK2kPzKwljbdFheFRvQFwwVmZE48Xy2O8gqna0yB4VfSmV3++AmoH9pfKfAmfher/E++QlDS0Sbh5B6OV5bph3POExof8sRslavKWdMRM3dw4ANTeuMUIpu2woU/qgvz9BJvLCah2MzS+1a1wn72iBc4P0k607+sCqT3A2P8PiJ0cseIlt87yOslV3cVquwlVIp3JHgRrSLokUihiljjYFnSBPbGiR6NYDMnShmbPxAqwXmeos5SDUbSC2JN5tK+1p7GFKCudPdk6Gv7Xctsk34UlISU/5NkKtSEtRL0m8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *opaque)
> +static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +				  void __user *src, void *opaque)
>  {
>  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> +	struct sev_data_snp_launch_update fw_args = {0};
>  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> -	int n_private = 0, ret, i;
> -	int npages = (1 << order);
> -	gfn_t gfn;
> +	bool assigned = false;
> +	int level;
> +	int ret;
>  
>  	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
>  		return -EINVAL;
>  
> -	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> -		struct sev_data_snp_launch_update fw_args = {0};
> -		bool assigned = false;
> -		int level;
> -
> -		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
> -		if (ret || assigned) {
> -			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
> -				 __func__, gfn, ret, assigned);
> -			ret = ret ? -EINVAL : -EEXIST;
> -			goto err;
> -		}
> +	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> +	if (ret || assigned) {
> +		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
> +			 __func__, gfn, ret, assigned);
> +		ret = ret ? -EINVAL : -EEXIST;
> +		goto out;
> +	}
>  
> -		if (src) {
> -			void *vaddr = kmap_local_pfn(pfn + i);
> +	if (src) {
> +		void *vaddr = kmap_local_pfn(pfn);
>  
> -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> -				ret = -EFAULT;
> -				goto err;
Please consider apply the following fix before this patch. Thanks!

commit 2714522d42263e0e250f21a0b171c10c4bb17ed3
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Mon Nov 10 11:22:28 2025 +0800

    KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
    
    sev_gmem_post_populate() needs to unmap the target vaddr after
    copy_from_user() to the vaddr fails.
    
    Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..261d9ef8631b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2296,6 +2296,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
                        void *vaddr = kmap_local_pfn(pfn + i);
 
                        if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
+                               kunmap_local(vaddr);
                                ret = -EFAULT;
                                goto err;
                        }



> -			}
> -			kunmap_local(vaddr);
> +		if (copy_from_user(vaddr, src, PAGE_SIZE)) {
> +			ret = -EFAULT;
> +			goto out;
>  		}
> -
> -		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> -				       sev_get_asid(kvm), true);
> -		if (ret)
> -			goto err;
> -
> -		n_private++;
> -
> -		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
> -		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
> -		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> -		fw_args.page_type = sev_populate_args->type;
> -
> -		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> -				      &fw_args, &sev_populate_args->fw_error);
> -		if (ret)
> -			goto fw_err;
> +		kunmap_local(vaddr);
>  	}
>  
> -	return 0;
> +	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> +			       sev_get_asid(kvm), true);
> +	if (ret)
> +		goto out;
> +
> +	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
> +	fw_args.address = __sme_set(pfn_to_hpa(pfn));
> +	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> +	fw_args.page_type = sev_populate_args->type;
>  
> -fw_err:
> +	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +			      &fw_args, &sev_populate_args->fw_error);
>  	/*
>  	 * If the firmware command failed handle the reclaim and cleanup of that
> -	 * PFN specially vs. prior pages which can be cleaned up below without
> -	 * needing to reclaim in advance.
> +	 * PFN before reporting an error.
>  	 *
>  	 * Additionally, when invalid CPUID function entries are detected,
>  	 * firmware writes the expected values into the page and leaves it
> @@ -2336,26 +2322,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  	 * information to provide information on which CPUID leaves/fields
>  	 * failed CPUID validation.
>  	 */
> -	if (!snp_page_reclaim(kvm, pfn + i) &&
> +	if (ret && !snp_page_reclaim(kvm, pfn) &&
>  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
>  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> -		void *vaddr = kmap_local_pfn(pfn + i);
> +		void *vaddr = kmap_local_pfn(pfn);
>  
> -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> +		if (copy_to_user(src, vaddr, PAGE_SIZE))
>  			pr_debug("Failed to write CPUID page back to userspace\n");
>  
>  		kunmap_local(vaddr);
>  	}
>  
> -	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> -	n_private--;
> -
> -err:
> -	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
> -		 __func__, ret, sev_populate_args->fw_error, n_private);
> -	for (i = 0; i < n_private; i++)
> -		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
> -
> +out:
> +	pr_debug("%s: exiting with return code %d (fw_error %d)\n",
> +		 __func__, ret, sev_populate_args->fw_error);
>  	return ret;
>  }
 


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117FAC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9896B008A; Mon,  3 Aug 2026 14:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A8E6B0096; Mon,  3 Aug 2026 14:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53716B0098; Mon,  3 Aug 2026 14:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9173B6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:48:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FC0FA221A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:48:16 +0000 (UTC)
X-FDA: 85060843392.25.472D1DD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F5F6180005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:48:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A+LRE/X/";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785782892;
	b=77BmfqAJ5hUS8w+WJpBUx3jsOAd10+RtqtI7NcBrqFDy3li4cNu5yIz+LxuIggoRrGeDL1
	+SsB0PVLSUdJFodujdLv0O6izkDXjLTjP9ry/xUV22eAAMiM2U761Ky5JxObVRgqtcJllh
	FwUzy81VZS73FweXcF2AgoDR07avTyU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="A+LRE/X/";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785782892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8SClt3akbnQ59iEeq1F/2UzurnedUjnSrfWquKA9xA=;
	b=j0QoVupCCqxkVuZtHLvnxh3xdFZtJvH3dt4u7fT697vpS5a/y5EE1P9bOyeR6/IftoU5/9
	ZER32QMFsKXBsFZpR2WT/8bepz11AG5mm69I/4evtcycHr/oWlj7+Jn+cUHqIpc3jLk6Ad
	yxxvM9mRyDh3V9HMNMlAxGs4zleAasw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785782892; x=1817318892;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FEvsqek4MqSIT7wmQFOBw2R0Pt+rFIRmPU4JcWGC8WE=;
  b=A+LRE/X/EGCoNJ1k6HOj6awWktH31TMAoPcQUexNCqIzIxUbW/Poscwz
   8FlIoq1y/sGwKZ74pC/LSfssTubeJUuyjYxjprdZiKniG6MM6XnjhbAIw
   8W3cJzWGOdtzQcH6bdYGn0nPT0VzzR6/n3naSv+RPIb/6sAJfPZderCy4
   MF5SHR2IHN9ah9Aql7Xz9eL7iX/H6UcISOIDGc65HKQ358rp+cKLBln4J
   zxPMe4+5qRU7vT1b2kPTDZvOJjDgA0AzEk1Xilr/syGbvrvOCAjzMx+Oo
   0w8CfgHwDY5z1v9yPFSOZmcHI8+0AciTQ1u7S1/TSEnWGwIug4aPylaoj
   g==;
X-CSE-ConnectionGUID: ZaUlVN7QS9uJnRuHfMCpbw==
X-CSE-MsgGUID: KULfmxcxRC2vjgTj4yap2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="103731550"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="103731550"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 11:48:11 -0700
X-CSE-ConnectionGUID: n/t/EYyEQ+K68gK08mZjbg==
X-CSE-MsgGUID: LdHhuF2LQV+jYu4vOgYQiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="299519656"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 11:48:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 11:48:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 11:48:06 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.30)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 11:48:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqKQKogDPFX4YoHQbENtiSi9yyvryoMVlSdXu3iqe2YbhaqcekH5JSC7NfULE51Pr/yoKu4oC8ismAQxKLK2yAjj5eLDGBOmTazVktaUtZitxfn5Kd3CUfM9mfUZWiqVlou8ncQVV21xtzyqjDnSy4CRbVIWkRiZ8F2VQVgFHCAfdX2i+kHiRGmBiYysv2OzRgxrgkGQ5QwF6azZnJCdjuXbA9kRmb62z1aVezNYtD/pIreX4Z+0V2EFpQsimg5tc1PVk8aP9HqSVklc7Le0PKFfgpWrZ6Ek9s8QdRvAy8s8lnS+nw9DlYrQtkbO9r/inA+6oh2Oi84pD3EAqo59ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pyZIpUi1IHRWDfgL+54cSMIw2XB1pJ2ujLim5OuOzhc=;
 b=bYMDvXnp2mBQvyuFZvIh/AjXDeR9d10woqIpbrGielEaiGs7CE0qlQbJyMFef82wec6W+lIv/0e9dMN/uMR138D6hxGDbrcAbBiGxaETjugWAsyaQy9GbHeU17BVSL9YNxyVEHyG1kh7hlN4q+I85+VBy1pWI7uiZoGk9p2S/ra0Q5DKoTh/rdOuDBLqNMLeb656DqWXQhLbcOfYnHeyrlp+B10uvpa+H1+AtpwUTrCRpIoFgtA4tLBCTPwkVj8Gok/9qhdiPhqSaSL9pdHKeTVdExeXXgppaQasE8s8hkNL//2vK8fx/uQgt66ihszRoh8WgNHhn6mPE8clZdXc3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA0PR11MB4749.namprd11.prod.outlook.com (2603:10b6:806:9a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 18:48:03 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 18:48:03 +0000
Date: Mon, 3 Aug 2026 11:47:59 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, Huang Rui <ray.huang@amd.com>, Matthew Auld
	<matthew.auld@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R.
 Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Tvrtko Ursulin
	<tvrtko.ursulin@igalia.com>, Dave Airlie <airlied@redhat.com>, Matthew Wilcox
	<willy@infradead.org>
Subject: Re: [PATCH 3/3] drm/ttm: allocate pool pages as compound (__GFP_COMP)
Message-ID: <anDiX4L3Oz8fKJCW@gsse-cloud1.jf.intel.com>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <20260722044220.1110278-3-matthew.brost@intel.com>
 <80fdf249-6f24-4cc7-bc9a-91bf23293497@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80fdf249-6f24-4cc7-bc9a-91bf23293497@amd.com>
X-ClientProxiedBy: MW4PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:303:8d::31) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA0PR11MB4749:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf27c39-3ef9-4014-a222-08def18fbf93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: q4GmUfpsSmBTfMgfDCQpzj8HfwY8ZP+gOfSMmCmFejyIcnqa9g778j47gPrHuApW/EZ0LzIsgZO3xw5f6ZxLvrztouUZdmmyq7jRAwMaBF64hKMKUynevFIJidm8KPY6POP+GbENsMUMMvWAp1Gd9ASqitCZdHQt1E2HNrsgvyFS9MZkOYLnCuGvBy3Grmw4uYf6SerpF1QgoaYAFkvdmjkPaNXtUhpfJazyh5D7kajttnrfOb+wtsa8Nbqt4jVIJGz/mhTdn38gBnsJ1urHsdYPazr5f3hgczCez4w2JiYvpouNbI/y/nzAe8jkVQYn2lIau4zLRP5By6BAM8E2EV++H22EzfJXDJM0DdjP1jml05u7pspHF+ACMkT8oD1FwGcHGCl641+rF62b7VsynstnidcRx3MwrUyR5N6t56QxVac88nwovxxgGoDnsMUcsQAxSHWlExbbh1COLSf+a1bqJIT0UXo6cpJGAiNWpaaB4DiZ4K3/NVHs/C0cUIuV2Xk2A0mIZtZtRgBwsHqkn9HDqbVbIpL3q7LNkP7kBYr9sTh4vX/yxS+tssBdq5ePfQhyunyYFbuc72mtaH3HeMaeEAcqB/FRb2a2b4T3RDU0MpZalFCV9EppNEK8Vt6oEN4/ae2ISgC9sAgcrJFyr2UPj1RuIYlsKv5Z+G+EZLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yvb2IOYcte7duJ+YkFbcxfzIQk+FixE3wM/1NDTgWEjMwCZ7myRJBkNBPH?=
 =?iso-8859-1?Q?7QWK159CP2IkzA+kvdbIbQE9aG5guzndETZ485/wVrJfu9gNIVWJs8xz7E?=
 =?iso-8859-1?Q?LO4OlsBJnHTeQVXDMWmCyBcnHkJ7Z3nOMbhuIwvkeOSBNhuLS80ks78/As?=
 =?iso-8859-1?Q?a8MEPL2M/TxuZbZiOYbohkDhunf+xyN1YpxodrYik6Uj3aqRtReOUmZgMJ?=
 =?iso-8859-1?Q?dC2MYkNI3xn+178hXOi41FAQgVVU55O2NAqwbu9QVFTCT6oKx7V+tK3vC/?=
 =?iso-8859-1?Q?xs/KfIw2dcVrrI9N14/u7/B5vNdfYOEqUODt+n6kU7z/CBc9xsm6dk9LMx?=
 =?iso-8859-1?Q?MEKxuIWHqcyYoLz0T3WaGZtWc27eqfHDMAouLpST5PdG4G0oJ3IggYL67k?=
 =?iso-8859-1?Q?HJEXGr23CdfbB+J4ZZFBnif2NfFDmrk9PgZnXuf6YWzebIz+erZdkFEG9d?=
 =?iso-8859-1?Q?s/D0SaScQLNB3m/CEqLuTxIFmggaqNK/wS9l5c8ZsXEUgKFVeYDR8DMxBG?=
 =?iso-8859-1?Q?EFXqJ6lq0Dd28jtabp+TJVhC6QDXm7zbKkwdw+zLy3ee6RG7OpkbM5NjJT?=
 =?iso-8859-1?Q?fSJ7Q6mIaktFYpK0OnrLv+SLgUByabwqLLPUCBkpBOCbTbAidEIsC9d47T?=
 =?iso-8859-1?Q?5EMT+5IEAKayHO8YH6xNZJBaQldc23gFSju7jrOQXZMr5C9graHb3Q0SxG?=
 =?iso-8859-1?Q?63vjquT1NNSCjMMZbwiDT7K3smxn64o+VAxEqaxP/bWjWnk9d9raPyDHxk?=
 =?iso-8859-1?Q?v2/ZBOjK+1x1LYf97i75O1GoLA18ScIbkIro4KiRD6Pxuv1yl/AIOo8OBi?=
 =?iso-8859-1?Q?KeU5YPWFWk9RIqF1umYryC9k+ZLUmkjKkzI2xueqh4wkDprL1Ha7IlGwRB?=
 =?iso-8859-1?Q?R0ctWiUaERaiKr9HFA796UojG8ae/L4LWo3leaZyFVehUWY/0MfAX3Q4Z5?=
 =?iso-8859-1?Q?GtoTT5oZLG/ruLkCjMm5NZRW7o+NJfemiZlL4VYNTHUYtxkhhROaQ9FD9f?=
 =?iso-8859-1?Q?dqrufAl8ogyivSTIx8XxI2sU25HxwJXBoCSxHND1g1MWpbEVVcrR7sI8j4?=
 =?iso-8859-1?Q?p7nJKX8jrDZBZ89Ayebt7ieDienvDxU1D8ngAi6TWpQpGF3wEVWa7P15ar?=
 =?iso-8859-1?Q?lhB/ZiQR2Un1eniv1qmI3ijSayTqHKIi2DOZx3l9I92HDd6/fbBv9vOIGM?=
 =?iso-8859-1?Q?5nTDgX/UGdgHiORMjPHg97jg2jujAMBGk71VfRI7F/1vAjGvOU1NgM5+rS?=
 =?iso-8859-1?Q?tbIMGoRM9WglW5Hp0Ag0EWNjFm00gvW9NFjETuT3hjsKc3c8n7kFprc/u5?=
 =?iso-8859-1?Q?qvV91Vjx7mYVtec8FKN1KcOJN9F6KVtPXv2wcEK2L3uzmKQqu5b45/aejP?=
 =?iso-8859-1?Q?ffavsxiCpp7G6FIZJ1BDaEbMa6b1G6r0WW+mln8rlWkQhnWbbzZAwWyclB?=
 =?iso-8859-1?Q?edKBFsp9Lrpjn5yNrfzAmNMWe+l77Dw4yDjc56qAOnbHK5zMWwn9FyukQs?=
 =?iso-8859-1?Q?W/IaA3QWhRztczCGzuYz8j7Hp12v20uhS8CYUKOA3+AuLcaA/2fyq3TjRZ?=
 =?iso-8859-1?Q?NswXCrakSjrGWKd9sB7gLYWLBOYz/c2Z3/4f0DceG5cEGlZ/b0G+ArDBWx?=
 =?iso-8859-1?Q?sM/syD2MG2w4Wkz979dkr3t6tvmCosFsHifsYjDrxMEw5QLS3Oqx0x0/gz?=
 =?iso-8859-1?Q?A/yF7WysXgR/KXhn/oPbW6EfmtEkMG5+Rwk8rFzHKeyqRMatkVCwKBx3BZ?=
 =?iso-8859-1?Q?hC+vg0b+KqjwO0O7KLecxjg//4pCKDQ5q4xRxoU8qURGXKjboRMGysrC6B?=
 =?iso-8859-1?Q?NBjPa81Ngw=3D=3D?=
X-Exchange-RoutingPolicyChecked: QoNI5YSH6ke9EfMNcr3slYzTj9rs2xuBSGWSyiqOs7h2RL8O06L+sSuyQbMFqIqVShTHfPjLlrU/eIeGuosZ3VrUaSGRQlZZIq4aZLRFeIYNom1otBxpVXg7DO+MCtGLvrxljbRfkwMXLd4u2RRbD+/SeFpiDFeWXw3oZZ0XuUFPtTKbD5cwevqKsm3J3Yty6ljQ8Gfms22ki3bENAqovEYXdWWMSk/ntRyg+DpI2l6ExOs5vKNoUG4PIWgCThmgtHHGg7ZBvR/d2UfdIcf0aigxTtt874TyGRJFgHDd8NxldvmNVJi0Yha8I+M0OFO35yXcSI1/MnWNWVgrBHLmTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf27c39-3ef9-4014-a222-08def18fbf93
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 18:48:03.2242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzeqzX02C5F1a6wjhX0LVrZYXLVsQve5mf43u+BNJUt4GGumDen12KJO18IHtqzzPBb/jTYVUx92KQyuaD3NKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4749
X-OriginatorOrg: intel.com
X-Stat-Signature: wnxi59thuipgrotoxqcyfski4obttek3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F5F6180005
X-Rspam-User: 
X-HE-Tag: 1785782891-849929
X-HE-Meta: U2FsdGVkX1+/MLnUhp87FnpoZ3kHfQljqmuVekBpOUzySrSyfRD+j9kFbXQg9g8bNyLb6Hn/8Ig+x0OiK5s26rqynMqOHiL6XOFlRTHGhsvf+oo5M5dtOkhJUMqyCdT1J1QxFfTppLwghbLBLKnxK+BmSqf7Qa5cbG2A442UmIaT3DI+tiRAgy0mAdDT/kyd8F7cDEFffOrHWi5CTM3yGdQA8D8lYfR8afQ7F+yP21Dv6JOM2ciRXPAITOI/jevr4793+M7qta/xHBho68kkm7hD3bICBEl71zWCOcEdz4ninCbDDSA3IC0fYWgJKSNiD2YW9wEllfPjJM53F0h8FvTkGaNlQ1jx8NA+pdR64+xpKBSKhrJbiYS5lR2oNqtyN3PePkRamTSeEbI3vrtHPOR7N91yAsQ1cS4ryi3uNBX52R7OwQqSLidHZBdan0Z5AsM84qZXMwA9UvREN3hIqTnDHWTgXmofyX+tdv54B2hjI4jkPM0OBJpscvK/CvtptPMLIP7KYJ3yjlkrD9jYW4wXBZeEPIL00fIW+N4Hda1bHZOYhofzEhEkG2SSMOrlhxkD5zIPbzkCBbPz9lQjkswlLVhpfF5Qv66BFDiHDcP1zCX1uWlS+eklPpp/9y41HMTVE/kG9MAckqE7kDu1MVeCfTxgXHdEbpw7kfdGzFmsaG1m0Y2hjOKykr7iy7BKj+iL9XE3B/qDjC5jYHMdYzV+MoOSVL1ccgZjyeRNSwMAYpIePO4h9nSE37qAnWNAqKYeB5Iy1izWh9Psl3+DYBGK4qs8wDJT37O6ZojfUZc3h3bGTE7R3ODD54ZKMHb2ch4Nwel6rt5LwQbODsx2Ufrs2lWmSymcxg2QDlP+gF7Y4iNpv0tiMkA27sPKVo9iYJHvbyIQ7J1ujHNbe8YdT0HM4EqgLJJBuVyT/EzIOriLwWt7PDiVUazwH7yRSo0oP2xWkrhKGfneQONAJbg
 xC+RP0+6
 SpYnX+EUrXR6dCZ5ziJVk9M/BqTKVF3QfBL2u0ZHWFulUCTnx7AXMoUGuUj6qlEl9/PkkvtDHmsB9pjSCT4ixqFX+271jk7y9UQvOjbDsHzGOSTrMJMpNf0kEsLDw4oa1IYoVwY+6qYWrZB1Rd/oXLAPE2AmCKCrRC7UawMEWOwb0CRkNKxtjNX+q9ssEcOVy7RKditW/CLLCAOJAxHNmMhxaEJgXlR44KJ7+CHCqqbyNVMlCAlt+4dsE43iCq4f/wpXuFnQjfLeMc3lyCpD/4sGozuXVwv+E59qdOU2i2PBoUiewFQzhzUjy21HgUwnrGU8jD1zxdJvgCrPMfqryHnNnLOgIcvet19jv06GcxaTYIGI5eUYYg0foYagnLx9QEmGVO5kuo6lHf0v5IcYN1zxWZXVTmE+Lr8Zz3CaSSaUozgdZltrkydomdug65kqqkpzhXroY29VwSFrTjfcH5QAUi8/KsPXdGESNvlFyleIrQai7+SJMIORb1riw+47pQ2u36Sis62QOxJyI5efNC1oyXDg/mepblIlwA+LW5i17PcAe9BjmDyzbIuriSexcbCN9kdDervSAa3HCbEYFzCFRvb1HZSUvM/iMLHEJ9XNnKS7GYVMoVDXT+10jdsWq/Y3Y/ZVGrl/4+Cxbwo9Gvzh4xKUqRgMleDbFWKqha8v8n1P09HYYVos6sSfZRY9VD+emeec6Bd8FEqvYciIWRQGStCpftZwC6OCSiK1PdGvxi3FvlUH4pI629kHkPekCa2N8KQroJTa/rLrvfpPUDqQlNRB2oSAN6Q5Up9mRzJjm9whc1aOhdk1/OT/NYoJ04knYZ/15NikpMrAJU9OzWlCztLqioD6ACuo8wggjEQkOhvnfF4siol12tPkM+gUQ6D2VRvF7RNHqZa3i82FQ6y09f18PFHLrvmAPdO66pca9h1geWFcF1J+jUG4OQ47dytMafiVsno4XjgScowsEbKiX3oWJ
 Xn6EIQo4
 +t1AExz4XNM6drRAbQKS2/2sgAiQNAdV/I5oyc7onnRxtZhixO05fQzHMKnzqS3dDL9NhR1q30CtMASQXAcEnSBGlrMxKfvY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 03:54:27PM +0200, Christian König wrote:
> On 7/22/26 06:42, Matthew Brost wrote:
> > Historically ttm_pool_alloc_page() deliberately avoided __GFP_COMP for
> > higher-order allocations and instead stashed the allocation order in
> > page->private. The stated reason was that mapping a TTM page into a
> > userspace process and having that process call put_page() on it would be
> > illegal on a compound page, because the stray reference would fold into
> > the compound head and could free the whole block behind TTM's back.
> > 
> > That hazard no longer applies to the non-DMA path. TTM faults its pages
> > into userspace via VM_PFNMAP (see ttm_bo_vm_fault_reserved() /
> > vmf_insert_pfn_prot()), so the core mm never takes a struct page
> > reference on them and GUP rejects the range; a stray userspace put_page()
> > cannot reach these pages at all.
> 
> Yeah unfortunately I clearly have to reject that.
> 
> This is exactly what we have thought before but that doesn't hold true. Especially KVM completely broke our neck here.
>

I haven't tried KVM, but it's entirely possible that KVM or another part
of the kernel breaks TTM usage here.

It didn't take me long to put this together after it was brought up in
the other thread. It makes TTM a bit clearer and also simplifies my
defrag series quite a bit, since that series included several extra
steps because there's currently no reliable way to determine whether a
page is the head page without native compound-page support or
reinventing this in TTM.

Xe appeared to work correctly with these changes, which is why I decided
to post them.

> But let's continue the discussion on the other thread.
> 

+1, I saw your response there. Hopefully we can figure it out, as I'd
very much consider this a nice-to-have cleanup.

Matt

> Regards,
> Christian.
> 
> 
> > 
> > Convert the !ttm_pool_uses_dma_alloc() path to allocate compound pages
> > with __GFP_COMP and recover the order via folio_order() instead of
> > page->private:
> > 
> >   - ttm_pool_alloc_page(): add __GFP_COMP, drop the page->private write.
> >   - ttm_pool_page_order() / ttm_pool_unmap_and_free(): read the order
> >     from folio_order() for the non-DMA case.
> >   - ttm_pool_split_for_swap(): for compound folios, split via the new
> >     folio_split_driver_managed() helper rather than split_page(), which
> >     rejects compound pages. Each resulting order-0 folio is then freed
> >     individually as it is backed up.
> >   - Drop the now-dead page->private = 0 clears on the purge and
> >     full-backup free paths.
> > 
> > The DMA path is intentionally left unchanged: dma_alloc_attrs() does not
> > produce compound pages, so it keeps split_page() and the page->private
> > order stash.
> > 
> > folio_split_driver_managed() lives in the THP split machinery
> > (mm/huge_memory.c), which only builds when CONFIG_TRANSPARENT_HUGEPAGE
> > is enabled. Drivers that drive the TTM shrinker and therefore reach the
> > split path must select TRANSPARENT_HUGEPAGE.
> > 
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Simona Vetter <simona@ffwll.ch>
> > Cc: Christian Koenig <christian.koenig@amd.com>
> > Cc: Huang Rui <ray.huang@amd.com>
> > Cc: Matthew Auld <matthew.auld@intel.com>
> > Cc: Matthew Brost <matthew.brost@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: "Liam R. Howlett" <liam@infradead.org>
> > Cc: Nico Pache <npache@redhat.com>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Barry Song <baohua@kernel.org>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > Assisted-by: GitHub-Copilot:claude-opus-4.8
> > ---
> >  drivers/gpu/drm/ttm/tests/ttm_pool_test.c | 23 +++++++++---
> >  drivers/gpu/drm/ttm/ttm_backup.c          |  8 ++--
> >  drivers/gpu/drm/ttm/ttm_pool.c            | 46 +++++++++++++++--------
> >  3 files changed, 53 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> > index be75c8abf388..771ed257778c 100644
> > --- a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> > +++ b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> > @@ -169,7 +169,14 @@ static void ttm_pool_alloc_basic(struct kunit *test)
> >  			KUNIT_ASSERT_NOT_NULL(test, (void *)fst_page->private);
> >  			KUNIT_ASSERT_NOT_NULL(test, (void *)last_page->private);
> >  		} else {
> > -			KUNIT_ASSERT_EQ(test, fst_page->private, params->order);
> > +			/*
> > +			 * The non-DMA path allocates compound pages, so the
> > +			 * order is recovered from the folio rather than from
> > +			 * page->private.
> > +			 */
> > +			KUNIT_ASSERT_EQ(test,
> > +					folio_order(page_folio(fst_page)),
> > +					params->order);
> >  		}
> >  	} else {
> >  		if (ttm_pool_uses_dma_alloc(pool)) {
> > @@ -177,13 +184,19 @@ static void ttm_pool_alloc_basic(struct kunit *test)
> >  			KUNIT_ASSERT_NULL(test, (void *)last_page->private);
> >  		} else {
> >  			/*
> > -			 * We expect to alloc one big block, followed by
> > -			 * order 0 blocks
> > +			 * We expect to alloc one or more max-order compound
> > +			 * blocks. page_folio() on any subpage resolves to the
> > +			 * compound head, so both the first and last pages
> > +			 * report the max block order.
> >  			 */
> > -			KUNIT_ASSERT_EQ(test, fst_page->private,
> > +			KUNIT_ASSERT_EQ(test,
> > +					folio_order(page_folio(fst_page)),
> > +					min_t(unsigned int, MAX_PAGE_ORDER,
> > +					      params->order));
> > +			KUNIT_ASSERT_EQ(test,
> > +					folio_order(page_folio(last_page)),
> >  					min_t(unsigned int, MAX_PAGE_ORDER,
> >  					      params->order));
> > -			KUNIT_ASSERT_EQ(test, last_page->private, 0);
> >  		}
> >  	}
> >  
> > diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
> > index 3c067aadc52d..9194747a1dff 100644
> > --- a/drivers/gpu/drm/ttm/ttm_backup.c
> > +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> > @@ -72,9 +72,11 @@ int ttm_backup_copy_page(struct file *backup, struct page *dst,
> >   * ttm_backup_backup_folio() - Backup a folio
> >   * @backup: The struct backup pointer to use.
> >   * @folio: The folio to back up.
> > - * @order: The allocation order of @folio.  Since TTM allocates higher-order
> > - *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> > - *         return 1; the caller must pass the true order explicitly.
> > + * @order: The allocation order of @folio, passed explicitly. For the DMA
> > + *         path TTM allocates higher-order pages without __GFP_COMP, so
> > + *         folio_order(@folio) would return 0 rather than the true order;
> > + *         the caller therefore passes the order explicitly. (The non-DMA
> > + *         path allocates compound pages, for which the two agree.)
> >   * @writeback: Whether to perform immediate writeback of the folio's pages.
> >   * This may have performance implications.
> >   * @idx: A unique integer for the first page of the folio and each struct backup.
> > diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
> > index 1bf37023fed6..364cc7ec7469 100644
> > --- a/drivers/gpu/drm/ttm/ttm_pool.c
> > +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> > @@ -168,9 +168,11 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> >  	struct page *p;
> >  	void *vaddr;
> >  
> > -	/* Don't set the __GFP_COMP flag for higher order allocations.
> > -	 * Mapping pages directly into an userspace process and calling
> > -	 * put_page() on a TTM allocated page is illegal.
> > +	/*
> > +	 * For higher-order allocations be a good citizen: don't dip into
> > +	 * memory reserves, don't retry hard, don't warn on failure and stay
> > +	 * on the local node. The non-DMA path additionally sets __GFP_COMP
> > +	 * below; the DMA path allocates via dma_alloc_attrs().
> >  	 */
> >  	if (order)
> >  		gfp_flags |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN |
> > @@ -189,11 +191,9 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
> >  	}
> >  
> >  	if (!ttm_pool_uses_dma_alloc(pool)) {
> > -		p = alloc_pages_node(pool->nid, gfp_flags, order);
> > -		if (p) {
> > -			p->private = order;
> > +		p = alloc_pages_node(pool->nid, gfp_flags | __GFP_COMP, order);
> > +		if (p)
> >  			mod_lruvec_page_state(p, NR_GPU_ACTIVE, 1 << order);
> > -		}
> >  		return p;
> >  	}
> >  
> > @@ -482,7 +482,7 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
> >  		return dma->vaddr & ~PAGE_MASK;
> >  	}
> >  
> > -	return p->private;
> > +	return folio_order(page_folio(p));
> >  }
> >  
> >  /*
> > @@ -493,15 +493,31 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
> >  static void ttm_pool_split_for_swap(struct ttm_pool *pool, struct page *p)
> >  {
> >  	unsigned int order = ttm_pool_page_order(pool, p);
> > -	pgoff_t nr;
> >  
> >  	if (!order)
> >  		return;
> >  
> > -	split_page(p, order);
> > -	nr = 1UL << order;
> > -	while (nr--)
> > -		(p++)->private = 0;
> > +	if (ttm_pool_uses_dma_alloc(pool)) {
> > +		pgoff_t nr;
> > +
> > +		/*
> > +		 * DMA-alloc pages are not compound; split the plain
> > +		 * higher-order allocation and clear the per-page private
> > +		 * (which held the order for the non-compound case).
> > +		 */
> > +		split_page(p, order);
> > +		nr = 1UL << order;
> > +		while (nr--)
> > +			(p++)->private = 0;
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * The non-DMA path allocates compound folios (__GFP_COMP). Split the
> > +	 * driver-owned, off-LRU, unmapped folio into order-0 folios so each
> > +	 * page can be freed as soon as it has been backed up.
> > +	 */
> > +	folio_split_driver_managed(page_folio(p), 0);
> >  }
> >  
> >  /**
> > @@ -548,7 +564,7 @@ static pgoff_t ttm_pool_unmap_and_free(struct ttm_pool *pool, struct page *page,
> >  
> >  		pt = ttm_pool_select_type(pool, caching, order);
> >  	} else {
> > -		order = page->private;
> > +		order = folio_order(page_folio(page));
> >  		nr = (1UL << order);
> >  	}
> >  
> > @@ -1124,7 +1140,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
> >  					       num_pages);
> >  			if (flags->purge) {
> >  				shrunken += num_pages;
> > -				page->private = 0;
> >  				__free_pages_gpu_account(page, order, false);
> >  				memset(tt->pages + i, 0,
> >  				       num_pages * sizeof(*tt->pages));
> > @@ -1214,7 +1229,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
> >  		}
> >  
> >  		/* Fully backed up: free at native order. */
> > -		page->private = 0;
> >  		__free_pages_gpu_account(page, order, false);
> >  	}
> >  
> 


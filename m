Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D38CC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 21:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ED26B008A; Mon, 20 Jul 2026 17:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF886B008C; Mon, 20 Jul 2026 17:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB72B6B0092; Mon, 20 Jul 2026 17:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE536B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:58:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17A741C03DE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:58:52 +0000 (UTC)
X-FDA: 85010520504.23.81E5C89
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1463540007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:58:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dTJjealc;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784584728;
	b=fhSld9MSXU6BlEfxTdvsYf99ZegBbNfK73bn5wf0pXTvxSSLGhHdNZ1B5I/qZF+QJCzYmB
	x3cXmaOo8scuR4u9G8ilndaa4DSy0he+oGt9CycpeIf0XwiNyKMP8JkwkU/kpgTFJxpPr+
	bBSS21D8acaR7x9Hl34vZJA0FzvMsgQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dTJjealc;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784584728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcybMXwKlnxAnDP0zZx4Y3rgM2lg7dnGIdT/lSeqogE=;
	b=dqwQjj/eIqaAzRcMOVjJ6cnGcYEB4dvNSXxSRk/z86aZIujmFdvs+mo4RkU+Ty4CVlEjpf
	5mosJZAN2T8Kj60RMMkp+/4fm7UMGzuQKKEXPIJnvv5JhVyMRhmd4ttDsM1uAgm9iujhqL
	ip3JCaYYuDEzDH0wy2wT3QVtwdGyLQo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784584728; x=1816120728;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BMERtOHxs4n+1uX5kyt1mB7o9X5p08QoPt7Uv7v5eW4=;
  b=dTJjealcH6DXWypW9Cq89ffsNTX6CbQrWX8IESm3xUduwr2t29wUmA6C
   8kpQ1oHM9ZVRTF4pLuvnICebQvsAjN257Ae4mj3M8ZuPrXFH8A2jlKJiL
   Rdm8C8bjgXvktQZJzelVQ4j5rieqCm5iUzP7x/DrY/kUF0/XppfARAr0T
   NcUg8M8uzh+faSrP10GH9LV87JlgL7MwA2hNY6LI0ZTIBZwwQN8fXAE9v
   /++87QV0TKHnZp3mzlVnz/ZWQ/V6VkG43cN8020Abve047MWNdSJOzkhp
   lV5utMw6WrlPyBOpr7MUYiEiAoQfz7EIUTB93mxVmfVhtVZ9A76CBm2k8
   w==;
X-CSE-ConnectionGUID: sxnOYkUlT9WNCH2P3lVPmg==
X-CSE-MsgGUID: ryWZLvBnQj617cno3i8LeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="72711402"
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="72711402"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 14:58:47 -0700
X-CSE-ConnectionGUID: tBOiHuHEQfqyo8T6x5VvLA==
X-CSE-MsgGUID: HVOLiDf6TvCanD0/Jvz+ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="257627567"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 14:58:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 14:58:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 20 Jul 2026 14:58:46 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 14:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntJbmzS+vNeVZESiQL02rz9UbUhNi5qSEyJqOMYjhcIlquDq993qvV/qXHP+vIj2DSJ0Aw33Ke2m08QPGyfbbjawHy1xRUGZDotV40ZGAhY/w9PyexjcOOXM44WupAwiUUI8BaDRAtNUE2iMl8jM7yKqRptRWCv3vkjOUD+2K+VKLmxapBnGaMW+hg9MkmQamctymx+7LCWV758p1i6acTQrnftyxnzuX2ZIZ3fRgqF/9HE/nbL4MJeIsWrlNV1abwrQGtNOVe/tNuiW47ETsuSL5mNlNB4Pap71UXmyREFgBbkFvD+Ydh8AsNe8PzoEMAr9mVPZYgTnA/V7IkfBeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcybMXwKlnxAnDP0zZx4Y3rgM2lg7dnGIdT/lSeqogE=;
 b=ekEQ10o7kwRKdXZ3pbvUgJKLJtjSEVJhIqhSGX32FxOboYGfgzru9uheKAlu7uDuHc+cZnrPZk535mi1GIsD9AqTMIlApAf9BlmGvW33tqysHjUyi6Zq0RmRsyJorl+NkVQjdQ8FpY1pC4JG5tkeEOf9H4ryyKgLnUhaIaMMhBAgX4eiGfwZQGC1Atceiw692q1JoqWi2J/fGa54QRPEMmCjZ+ik6yc+AwD3KV3FDh+lJPlXt8Tcbdxm36OWgKG8eyYsyRzJOItarKI03W5riwh5XfLhQgUrophOqnqBi21kHnwqtIL4un9Ywb5AQ6F+C1ILFfD8/1BdhDAfO6QMuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MN6PR11MB8169.namprd11.prod.outlook.com (2603:10b6:208:47d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 21:58:37 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 21:58:37 +0000
Date: Mon, 20 Jul 2026 14:58:34 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: Mark Brown <broonie@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <al6aCizqqilqQGZ4@gsse-cloud1.jf.intel.com>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260720144141.GA16699@lst.de>
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MN6PR11MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: f97dfc72-5f4c-4081-e599-08dee6aa0d41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|3023799007|10067099003|5023799004|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: F7i+v1nK2Gt/hRNdGYXOc+0UpCcfri5aKeLVIAXBBb513RVOvda4ZhvTxDHUR6lCuTOFUkcuP3OJqEUqm1SPNJtv36L123H/iH/ERC0Rbz6l3hIxoZopV5OzOeazACjH+hgsCrU8j39jDmTmneXg8rwP3lbWaZy/yEmzRkIWA+Lwr6oFeysQBzrxx62FTz0lKqbTS2vr0lJV9IsKVzWHKXstdzf2FFZQsrbqLG/eBpLUXVpUSCsq/arMGFQJf6ynjH8HZCjuNY7EOdmqAIHneBBnh7Tpz2ibKUfWUahydOPZBIvk3m5RoynSkQOBvidRyhAfnZCFHlOc+Cl3yQAvoojiauk4rSCetwJEK1+Yp8U8F9DxN8ZCYwudhKhsmbRO5X4DUNH0qr9zw7w2kK7ompEILivea55llKgBxVaEotr42czGQeUuUzAJXyPrFFANAFO9R/beO1IUt3eM5JS9UgotTv5eGyQ/KVxkrM8P0rDTB+6SNB4De78C4GH0En5qbRYKAtDlmpZ6JAoinqQr4UO40LcUNK6QiCA+SmfoIFVN9ulimW3OYyeSBNOhDiWDBeYgc17q0jPdTQOY2X0MJudYBWiaPYZivl3ZAI15ato3FV73O/ZTRzE29zI1+pbgA3lBVmaAhXLVdcsxG/h2+Dw/Lyoy3/lTdrWTYWklFJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(3023799007)(10067099003)(5023799004)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0F/iwzmiKvK9X2pjPp29l37FU3Wppoz8AhslEkRO8DWnGrzuMDJY5rIjOE2?=
 =?us-ascii?Q?0nBJliGhQ9XRhmvBHCchbvbfFSqfttnBAKK6Y+DoJnqTcQlpq45SMzW2lMNz?=
 =?us-ascii?Q?g2v6mbMZFvyuaGM56H2aAxmECPKgYjgizW6U8ldFs++Vs6a09LCIcoDI2HEI?=
 =?us-ascii?Q?PiWm9tu6Rhg+dB/1u+g/fM6oS2MHcWFIXpG8PqsM5s9a0ghf0oYLVLv9PUp0?=
 =?us-ascii?Q?qKgOoyrQL+CfZvJZpTkyH6G2MtvxfhxQ4JU3o6Rgc7CuHJ5TJn7sA4bzXusD?=
 =?us-ascii?Q?ZfqtjUfx35vlfx2Ao1Fa3KlIkXtEjaDBJsC3bQA9RerPjFxWCydK3mJEcJPR?=
 =?us-ascii?Q?hUQytCr3iS9Xj4o3JBwjgnUVljwxh/Wf+YNMF+qpunvPjlvdRSwRTf3WvCcB?=
 =?us-ascii?Q?kwpX6cbAufl0sqny8MVLbmltr4jxjcjVUBg5OLaIQHOOjLuqQrRB0/fS0Y0Y?=
 =?us-ascii?Q?cHpqDOj99shMWQhHNPc9JXNedkCBcq03NEPP8ujnD4LqYaTzY6rgMOnK5Nm+?=
 =?us-ascii?Q?hKCFHF1P3ayjRdZ2qqZ6lt41xQDt8KdA+nbQlLRaZRzKZDzTTl5/v22QDDvd?=
 =?us-ascii?Q?vx60oST+lMbiqTTrEkBAFhci13EovitFaS8HRgk2IhKM0OHk/L5WeOVJla+w?=
 =?us-ascii?Q?54cGvjPNW2PBmW1jSZ4R+yyQ8iIeJpMkAHni8FdYj78fYY7iJ3H84W7MivfN?=
 =?us-ascii?Q?1PKiLnB7VJQd+/adGb6KLaxzcZDPABVuRzBqvKJ0698Rp39eRbNUMLmPf+De?=
 =?us-ascii?Q?xtPW69qp2/4/PUuqrHEe3nUtJqYaYvWoEti/osFeYT3id2KSql0BgEEo4Vs0?=
 =?us-ascii?Q?i8qoGc/UsQjO9oDBHjvh0+R2eg0b9kVFomIpAq3Yd56ADIbaUfoLJGpUG8Mt?=
 =?us-ascii?Q?WxyhnMY2QHOUq0MfEVFWat640/U14ty+1BXtXyupCU/+U8D/mQGRFhj6EhAV?=
 =?us-ascii?Q?cDYvnzQV/vMTuikivrWToHl+LkqRBgrXxImTfFaNH1rguaJoHHicFwk0lvFy?=
 =?us-ascii?Q?lMxOzw8OKoMzDM2wQ7x/W1WrR9mBSfWRx3Ib1FFqBcsz9tHiRHpjj44/Lmvy?=
 =?us-ascii?Q?hjziFY9A17An6HSgyPgBKNsgBuO5DLLI2BQslj5Uxy66x9/H1NuJ3Rh6tMDz?=
 =?us-ascii?Q?BDH+b+WRyaUbP1pSDHzHNMPiwmopCNZdHRA6BPIZvvrC5LmWY7TTYZm65Ew1?=
 =?us-ascii?Q?5R2Ba7NkdGys5viPTVybirlLNohlZIp27hZYi2/65Z9/7ANo7urkhMr1Y6Yc?=
 =?us-ascii?Q?ktNfbh3deHFksTld6MGBAhOa8HUFI9kSaMwzkZ6h9CRiTc4h53DAIMDqjkpk?=
 =?us-ascii?Q?CDg/GqcjCZIkVReV1gwdCHedtZeqrcUHQzTldvUPV3jwk/S//T3AvPdnfbVY?=
 =?us-ascii?Q?YvrZQHDYBsmR6y2g+Gl4/lRP6eJLi5yLWDygeff5YQ7cGzBJLnInZof5+k42?=
 =?us-ascii?Q?qTZYByfrq8Kc6lyz/LRoJvRTxeGZVVXw5MJ1Qcj1I2NG2CFUUyeZyf76pbNS?=
 =?us-ascii?Q?rMa5rSp51EHEXb6LlAqa0UmZgp3HC8bChXgV4Wbv0QMcgGCe5detnqFJaHOb?=
 =?us-ascii?Q?n0G+kivfQ0vWgpQSgPmAxAsxYoPHoorJGo40/qsdQQMsAY1mCboBWzg0VhkV?=
 =?us-ascii?Q?PCQjCcw6IsBezxL9Jqcnw1Td2yLjgO9CnnPEmwi91BgdtOi0T7fhPIT1eptQ?=
 =?us-ascii?Q?gQIhBQc/sJFeYuB+lv3FJvKkbpmkdwf9cm7HqRKDDqZbDoJ9db+D5alfBieI?=
 =?us-ascii?Q?mtFpJQP2SrZe4wtReZdtY8RaGmipODE=3D?=
X-Exchange-RoutingPolicyChecked: gVVr2ZVmeUNjUu8K/VJM3/1GRSaXAUGMppV84zrq8V9Ed2WUidKTrXumO2GqTEwjQcTpNeE8pyejc+JQ8YD6Lag11BWMCysHKFmDTatD+EN+DhEXwUgOhipdFRQYvTIj+tHKiaaaSOQabHdWASLmE+R5KVpiEqz66GHT1py+MdPM1yK149j2WP0FkancA3UxNXTx+Cv5yuC79y2f4EE/4BcKEnL219MHIBn9PmehktS648MmXuA9g+zk2DHdQ10/u8XdGrySaafAIqdsHNT6Zqbbxwxgx1WY1T74q5k82ILokVgng0D+cN6BxggPrZ0Gn1NhZA7mG8BuEXNdJHZIUg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f97dfc72-5f4c-4081-e599-08dee6aa0d41
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 21:58:37.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrigBZSSnQaWzjNTipFy5Ex5xve9CHqJQ0ZzN1MvcWNtxQ+qH2b25DJ4/rdCCCtkzEiOwkyA6RO9y145jUZKsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8169
X-OriginatorOrg: intel.com
X-Stat-Signature: a6uhihe9edrrdo3iga7zzssyipkdo5q3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1463540007
X-Rspam-User: 
X-HE-Tag: 1784584727-187983
X-HE-Meta: U2FsdGVkX1+aZPf5bS5AErKrTHLG2JzH+3fvU14Zg/wa1oGjqfsoNuFQkIbj8Rj98+8MG33Yq942NDpOAKRmMe7KWfgi8jiVos9+JUnBZsgRDrf4NOtzhp/UZplp6OdYoIlY0LU1yute+fP55/2t5ga2qVW2IP/0fvBvv15AwzKRdO7+eu4vuhsABqx+dQPUc/VhvcqRQQrNXIUDbv8dgwBzR17BZyNJGaAgFyH+mXw+otJh1jAVxcMiJau8P25Yaim3RUDvhgswniZ+kStC/VZT0jELQFBSlO8e4+yck0D9EQRaTrEvWECoBJeZSilg55lMKUXSG6lbGNwcgc3vbcljHKsCSnZp5dQjcajAY/XovhhjHDVfx2uFJmr+gHwkAXF0ghHtwLPL+CzMFVlnjnOeYy0mFVuY7iGYf+XpbFlEJN0wSRBTreszR3Ax6Gc4fZ2tptgH+fVecW7NCE8fjMHP52ov6+phmaHG3qGjA4KdKavO70MVSgqrM7Lfgb78Nba6dToDP8ZjpYd0rngc2PZ/UY/aRUoGzJNHO6Pq205g/+IzhxDaMET2eYLrmpVJ5r/efOoxUjn7TM/uTBnYIAW40cENxL9VCZPdQYQiTF83Gsto7XVCZOLDpk9I/G2Ij1W+eNILqXeiKbCCM8BV8KliAWsCmjrI2XHUP02a2orT0o0q46hjKZmXi5I7HNwgXRS6z57y20mqzC35t8uWdf1A/LBunJxlwW6u8ht5uiWxF6gpZgOodVRYKI9x4/JpAPjHOkYAq/xtEzV1SswpQ8DwAWywZB6Jx7GGODVEN2+ejW5nPavcobuFqM8HY5557M7WR/HX7bxZ/oQ25nnCdNxrlb+IKhabHe5FKxFa9l0v5iWPW5FNLt8lX3N3jnsLkDseyPgzkPDAXhMk24xSDtAkaB8YVd5V8CyJvfRvU1JCxffKAL3ZjuD4kHH1JYQ0rcDzpXEunLe/XJH01H0
 1zWQZJgV
 zjJHDclGXvGD4N8D4/INpoHw3rOAOxGb3xJ0s7iFc9lx4Nqu1RXZyFgr+dP7UQsvO/ok81qRFAXcUGFz3cupe/ftN2aHRZbkAHhXCtnrNLvxftmrEoY/6GLcBCzquj6b6j4htHasAW+KFI6nB9iTSaubFeyYfDIkm042LaPtM5DNGjoMIvfaAuHRrad/zwbA1eVr51aEZDCKnEDLBtRYnW1XSpaGXUuyxlONWGlVrUzKOmALZ1tYDNLuTFL1hx/UVjnaLhf4CXFoh/zPvAc9GiwvehHbKFhjYbjdghMFFTGk//URaOdA7Wawdw5fNCl7kyhlCqaOsJGRKMxZqYhYhwaVIS3L7nFcyGdgjf97HzJnSRzuLaonI088bfsnHCd1AWoG1GSx8vx9W4PZXkeMyWCXjEHAf0LWXX0/aN1Oa19/jeInQYt77UZkDaJHEvJUWh/DNNdopZMuATow2hUoTiJNPS1iNyZirdR6O90MiebifYxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 20, 2026 at 02:31:04PM +0100, Mark Brown wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the mm-unstable tree got a conflict in:
> > 
> >   drivers/gpu/drm/ttm/ttm_backup.c
> > 
> > between commit:
> > 
> >   a3fdf74ffa596 ("drm/ttm/pool: back up at native page order")
> > 
> > from the drm-misc-fixes tree and commit:
> > 
> >   c6bfdcf16f131 ("shmem: provide a shmem_write_folio wrapper")
> > 
> > from the mm-unstable tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> 
> Much of the code here really should sit in shmem.c instead of having
> random drivers/subsystems poke into the internals of shmem mappings
> and folios.  But I feel like a broken record for saying that again
> and again without any action :(
> 

Do you have a suggestion of what parts to move over to shmem.c?

Pretty much all of this? I can take a look at this in a follow up?

Matt

> > 
> > diff --combined drivers/gpu/drm/ttm/ttm_backup.c
> > index 3c067aadc52de,c5b813a563e7f..0000000000000
> > --- a/drivers/gpu/drm/ttm/ttm_backup.c
> > +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> > @@@ -6,10 -6,9 +6,10 @@@
> >   #include <drm/ttm/ttm_backup.h>
> >   
> >   #include <linux/export.h>
> >  -#include <linux/page-flags.h>
> >   #include <linux/swap.h>
> >   
> >  +#include "ttm_pool_internal.h"
> >  +
> >   /*
> >    * Need to map shmem indices to handle since a handle value
> >    * of 0 means error, following the swp_entry_t convention.
> > @@@ -69,23 -68,17 +69,23 @@@ int ttm_backup_copy_page(struct file *b
> >   }
> >   
> >   /**
> >  - * ttm_backup_backup_page() - Backup a page
> >  + * ttm_backup_backup_folio() - Backup a folio
> >    * @backup: The struct backup pointer to use.
> >  - * @page: The page to back up.
> >  - * @writeback: Whether to perform immediate writeback of the page.
> >  + * @folio: The folio to back up.
> >  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
> >  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> >  + *         return 1; the caller must pass the true order explicitly.
> >  + * @writeback: Whether to perform immediate writeback of the folio's pages.
> >    * This may have performance implications.
> >  - * @idx: A unique integer for each page and each struct backup.
> >  + * @idx: A unique integer for the first page of the folio and each struct backup.
> >    * This allows the backup implementation to avoid managing
> >    * its address space separately.
> >  - * @page_gfp: The gfp value used when the page was allocated.
> >  - * This is used for accounting purposes.
> >  + * @folio_gfp: The gfp value used when the folio was allocated.
> >  + * Currently unused.
> >    * @alloc_gfp: The gfp to be used when allocating memory.
> >  + * @nr_pages_backed: Output. On a successful return, set to the number of
> >  + * pages actually backed up, which may be less than (1 << @order)
> >  + * if an -ENOMEM was encountered mid-folio.
> >    *
> >    * Context: If called from reclaim context, the caller needs to
> >    * assert that the shrinker gfp has __GFP_FS set, to avoid
> > @@@ -94,87 -87,53 +94,87 @@@
> >    * that the shrinker gfp has __GFP_IO set, since without it,
> >    * we're not allowed to start backup IO.
> >    *
> >  - * Return: A handle on success. Negative error code on failure.
> >  - *
> >  - * Note: This function could be extended to back up a folio and
> >  - * implementations would then split the folio internally if needed.
> >  - * Drawback is that the caller would then have to keep track of
> >  - * the folio size- and usage.
> >  + * Return: A handle for the first backed-up page on success (handles for
> >  + * subsequent pages follow sequentially). -ENOMEM if no pages could be backed
> >  + * up. Any other negative error code if a non-ENOMEM failure occurred; in that
> >  + * case any pages backed up so far are truncated before returning.
> >    */
> >   s64
> >  -ttm_backup_backup_page(struct file *backup, struct page *page,
> >  -		       bool writeback, pgoff_t idx, gfp_t page_gfp,
> >  -		       gfp_t alloc_gfp)
> >  +ttm_backup_backup_folio(struct file *backup, struct folio *folio,
> >  +			unsigned int order, bool writeback, pgoff_t idx,
> >  +			gfp_t folio_gfp, gfp_t alloc_gfp,
> >  +			pgoff_t *nr_pages_backed)
> >   {
> >   	struct address_space *mapping = backup->f_mapping;
> >  -	unsigned long handle = 0;
> >  +	int nr_pages = 1 << order;
> >   	struct folio *to_folio;
> >  -	int ret;
> >  +	int ret, i;
> >   
> >  -	to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
> >  -	if (IS_ERR(to_folio))
> >  -		return PTR_ERR(to_folio);
> >  +	*nr_pages_backed = 0;
> >   
> >  -	folio_mark_accessed(to_folio);
> >  -	folio_lock(to_folio);
> >  -	folio_mark_dirty(to_folio);
> >  -	copy_highpage(folio_file_page(to_folio, idx), page);
> >  -	handle = ttm_backup_shmem_idx_to_handle(idx);
> >  +	for (i = 0; i < nr_pages; ) {
> >  +		int to_nr, j;
> >   
> >  -	if (writeback && !folio_mapped(to_folio) &&
> >  -	    folio_clear_dirty_for_io(to_folio)) {
> >  -		folio_set_reclaim(to_folio);
> >  -		ret = shmem_write_folio(to_folio);
> >  -		if (!folio_test_writeback(to_folio))
> >  -			folio_clear_reclaim(to_folio);
> >   		/*
> >  -		 * If writeout succeeds, it unlocks the folio.	errors
> >  -		 * are otherwise dropped, since writeout is only best
> >  -		 * effort here.
> >  +		 * Only inject past the first subpage so *nr_pages_backed is
> >  +		 * always > 0 here, matching a genuine mid-compound -ENOMEM
> >  +		 * and driving the caller's reactive split fallback instead
> >  +		 * of an early, no-progress failure.
> >   		 */
> >  -		if (ret)
> >  +		if (IS_ENABLED(CONFIG_FAULT_INJECTION) && i &&
> >  +		    ttm_backup_fault_inject_folio())
> >  +			to_folio = ERR_PTR(-ENOMEM);
> >  +		else
> >  +			to_folio = shmem_read_folio_gfp(mapping, idx + i, alloc_gfp);
> >  +		if (IS_ERR(to_folio)) {
> >  +			int err = PTR_ERR(to_folio);
> >  +
> >  +			if (err == -ENOMEM && *nr_pages_backed)
> >  +				return ttm_backup_shmem_idx_to_handle(idx);
> >  +
> >  +			if (*nr_pages_backed) {
> >  +				shmem_truncate_range(file_inode(backup),
> >  +						     (loff_t)idx << PAGE_SHIFT,
> >  +						     ((loff_t)(idx + i) << PAGE_SHIFT) - 1);
> >  +				/*
> >  +				 * The pages just truncated are no longer
> >  +				 * backed up; don't let the caller mistake
> >  +				 * them for valid handles.
> >  +				 */
> >  +				*nr_pages_backed = 0;
> >  +			}
> >  +			return err;
> >  +		}
> >  +
> >  +		to_nr = min_t(int, nr_pages - i,
> >  +			      folio_next_index(to_folio) - (idx + i));
> >  +
> >  +		folio_mark_accessed(to_folio);
> >  +		folio_lock(to_folio);
> >  +		folio_mark_dirty(to_folio);
> >  +
> >  +		for (j = 0; j < to_nr; j++)
> >  +			copy_highpage(folio_file_page(to_folio, idx + i + j),
> >  +				      folio_page(folio, i + j));
> >  +
> >  +		if (writeback && !folio_mapped(to_folio) &&
> >  +		    folio_clear_dirty_for_io(to_folio)) {
> >  +			folio_set_reclaim(to_folio);
> > ++			ret = shmem_write_folio(to_folio);
> >  +			if (!folio_test_writeback(to_folio))
> >  +				folio_clear_reclaim(to_folio);
> >  +			if (ret == AOP_WRITEPAGE_ACTIVATE)
> >  +				folio_unlock(to_folio);
> >  +		} else {
> >   			folio_unlock(to_folio);
> >  -	} else {
> >  -		folio_unlock(to_folio);
> >  +		}
> >  +
> >  +		folio_put(to_folio);
> >  +		i += to_nr;
> >  +		*nr_pages_backed = i;
> >   	}
> >   
> >  -	folio_put(to_folio);
> >  -
> >  -	return handle;
> >  +	return ttm_backup_shmem_idx_to_handle(idx);
> >   }
> >   
> >   /**
> 
> 
> ---end quoted text---


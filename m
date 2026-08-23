Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F854C5DF9C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305EF6B008C; Sun, 23 Aug 2026 08:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6766B0092; Sun, 23 Aug 2026 08:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1583B6B0095; Sun, 23 Aug 2026 08:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D93616B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:27:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7485C1A02F3
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:27:02 +0000 (UTC)
X-FDA: 85132458684.10.6B9F758
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id C8DD4C000D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:26:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VQ4seaQN;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787488019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f61nISFTlYdv+0VZdCrsHbVtu7BJumiVUwXwFczri1c=;
	b=YCpy/2QxG15uItcPnXlvNvcFjCwOyn5cl8VTFHGqtKa8oOrKcNARfPevxs7MP+xu3RxW2j
	S8uB9upIErGPhZ9VSDjyxJN0kc5Cq4oPQZVS3rsYrrEEP60jeWHPbymXxHnPvZk8+SNx6B
	YK7oGIeyfAx7kZUUWfaQUODFmsymarw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VQ4seaQN;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787488019;
	b=aFHxYgigZbBkt15zvUlU97wzxKZjQakkxitUqY1pn0g7e/zYEDa4ew9d3xxasfH4ee2m8N
	+fb0xz6pZk/9gxK/GTF4ESZ3v+4fbaew/9Mh3xZJhcOy7tG/6uGRzPZ5Zn7QpYPpGVCFjK
	cqugaODEis4aAxvP1L1wIlEf+J7OkvU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787488019; x=1819024019;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7ZC7yAjOeFxsXFE3b55R4rh7U+tL9D+AkvbyA79hZ6k=;
  b=VQ4seaQN0UWz1UR02N6rblclUZ5jlsrnXAB5momjUrrFdyewAJTaWO77
   TPPwjqaS2THhuVAypLGD+4Vi0G99hq5JEoXBHvXyGmxOMCDV3MQrQt/Ws
   uTr7bvVnU3nOX79vDjArHKFWTeWmtL2KUg43X6oKQF9pLgF9bRTrKrC8Q
   EfhWNP//mgYfE6A3wIlCXcqyYdVtl/NKh3fl6MI03l2K3Kr+wuCRHDPpK
   CHwr+2gUDynlRIiVgYcwIxW9a5bF3GdsXI0pkf4k4hDEb+MthR4Ge2ULn
   MFNqniiC2RyHvmYZYiv43sKlIku9NDe+VNUnxuwm/eECL8jDGrgOq1UGN
   A==;
X-CSE-ConnectionGUID: ouBu8qy1TEaNMxIP53ozaw==
X-CSE-MsgGUID: Jk+F41CnS4S09ne452Othg==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="87076723"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="87076723"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:26:58 -0700
X-CSE-ConnectionGUID: GzYTMAZ5Q+S9ed5KfbNJQw==
X-CSE-MsgGUID: jZnm3+WfSq+EL/DSz/ipeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="270966344"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:26:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:26:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 05:26:57 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:26:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFy86CXELitHxISDaUAZa+iXcmuJaa2ASAvbLi+f+daEZgexwz7n5cf+BEbWsRDfGXHPKqrv0Jhx2Q8c40/cSDbvZhzFCTfGEqULonjYL0ieTL7iCjpgjXIroZVPjvDCKRQaY+0nlQxxiKNK3/2ALdQtyr0IOkf4LmiMaN8rH4KD5FVqAdl2WaPM4Eu1S7FJ8N2bd9kE5bOvKY8Ud0A6HJW4uCRjexXSLi5/I/Z8XzEYUBhWNTCZ7je3hQXBAdFP3NQTvcC0adhCpu0FzvO8E451Lch4/EdjYm5wVb2nniRnoKUbDUNG+R8YGIrssn+hSEB6nLlN92QcCpFieLcfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f61nISFTlYdv+0VZdCrsHbVtu7BJumiVUwXwFczri1c=;
 b=nxxp758xF/9xEuRTlpDi2jljKNSdMmksjFl1ogU1eIRHck/b/3pWprCpJglUi5KMjvpGw1PutJl+jlbkxC0equEfx41gBtaEOcvATWpDoo4uS6w6iRl9MFIIRR1E5Y2tu9cXsuxdbX9uJWhqaI2V1Y+mHHe8oVB442lQdOS3TPVVjbGI/bFyEq55aGvpeJg/xnOoau5NqKAP+Zwt0UjuXoRM8R7ZFnZerjzRAvkEhFk5jVkgMnlNLkpy+ld/ib5D4bTwi6OFKgXttf3QJmQ6rDKelUnUzPmNumsdHiVVspRLcb0YjnN8GtT4kqoV7bmCK04FWiw0ivlWAX8GDoGu4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by IA4PR11MB9324.namprd11.prod.outlook.com (2603:10b6:208:569::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sun, 23 Aug
 2026 12:26:50 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 12:26:49 +0000
Date: Sun, 23 Aug 2026 20:26:42 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>, <mm-commits@vger.kernel.org>
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 a032d41a86cb82a747bc14d9c82b3e153a9a9ab7
Message-ID: <202608230151.Bk7deCva-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: TP0P295CA0044.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::6)
 To SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|IA4PR11MB9324:EE_
X-MS-Office365-Filtering-Correlation-Id: aa6f89c0-4bcb-4ae8-56ab-08df0111ce5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info: C2QpuRfK4kFoi2jHKv/7yujoc0CPhIkkKkS4/rX1J6o5jJB8mgNui997NqzVZTjTQKtgjPq/jZHieX6cjt+g9RkoBf+43coQ8EeXzMpPhqGwn1JPUdaD44HH1r/FKJug/n0aDA5lmhd8vUeqpKgq58i7Ny7tOsl53z7T1c+zqa1sl+VVU/UpYU78TecQJ40doptvym3U8gbN7t8t+zoupBAsIkwSD9v+TA5gcDbUHUvJD2o5TY7iLKz8Hw0D2QIrYqm9US6nHHTRwBj0qWXBctUTum6zKJFmlunyfE/f2vxUwgD+TFrwvV3k39p0Il/aaoFsxLLSrycCd9j4kn7eyX2/bsMiKUECA3WhGHqtZYl59gGu/5zhjyjn0IfUu1ZKowDRYLTztmbYrPQQvTrTojd5KyXccC5u18F9p2GMoqxua0VlVQ7powanAuZKsDXGNBWKMPQpwfzY00NMigUKsMhTXyjPgBtx5zZ72G721OvGXNJJtStAHMuCv36wbAp0QaLn80BVlCxDmMIfgFvjEnYLE/RMNutw+UI38jjgV4EVBxj2HfLlHkfQ33yl/xo4Qrs1x5sw0+4HNMUVbl0nCZrmiVcxk/tzsRszhfiFqtLhdR/le9jkVyuLfJnX8+oZWMvxR3B20Tsdsiug1RJakcnrtnk49gAPh9GTUyFuekc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?En90hLwfp7ORStQ3zdYnh5cZKVAc3bHvDh38HR11+WpPu3zDP+PzLr6dbr3E?=
 =?us-ascii?Q?hcajuOVfEBNLSa9SOJIed6vE8vC7UdVnKY+0OzK22rIYrKFz71pj1rmON+oW?=
 =?us-ascii?Q?w98QceQD7sVZQWw3shKAkWnuHB2lMEXNeT6wtWxech1ItAueZtcZSDIMUJza?=
 =?us-ascii?Q?SZQ0jQo62PqPx/r8+JJdZSinyQ46wuj1J2OwfrnzTlJSdik/Bl8k4nEyef0v?=
 =?us-ascii?Q?tlYfiXP5x4ab7U+n+u+WWGWntVik13mcM/tI2PcLTC7xLFd5DcccN+ehocTW?=
 =?us-ascii?Q?ynUd/fSATfvJ+S06IpOiqlds6IJtRfw63LziplfBhxIo1vuJT9QDYUyhsv3C?=
 =?us-ascii?Q?pl1eSv0XcJ5T+hxvKcSGVYnlS50x/KsWADTrBPZqnXI1ofxZuMLMFint7G0Z?=
 =?us-ascii?Q?4Kcd1suh8p9v4ia0MyxvzE3bR4owVjCppNj7dHLLOXXMKwYbZzqp1d+ADK08?=
 =?us-ascii?Q?ESxerAfeH+9uT9wg6LfKBb2TzpgGsliqzs5gjEPBdiQu76GkLzoTHz6dX5Ed?=
 =?us-ascii?Q?qTpPWUp1UF+YcPR5Gr9zwUcobuXiWmSllLHGUhqsBlFnHbj70b2lBjgkuMa1?=
 =?us-ascii?Q?Ff5BQsUL8oGTxg1CWU+5S4rDiNieIEa5W1k6s4te/fLrCSHEXYPR8OMGY4je?=
 =?us-ascii?Q?r3I0iplD2DL6sOghUVh6I0mUYmGnVtDjoAA6P5FxFKIWS2CkOwkEjDbojKYm?=
 =?us-ascii?Q?vB7Ug2LjPJy8hrkYePYfwsOhNMOu8LH94OsKd4hfM3ozj8ieI6YUk7Wn7Heb?=
 =?us-ascii?Q?rM2bdEzeGTEhzfA1XxWD8mSc8Nyih9uwaUc4DZZfyUPYTn2VHtoifqYPxrvS?=
 =?us-ascii?Q?vCoGWvGX0DGg8fHnM1iTqnJguOhubojC69ZXooubPA0OC7wFXnvfQKX50jrr?=
 =?us-ascii?Q?KJaR35mPakP6FdngGiREiWXeflQxI7nNLyWcI6YmmLJtDwg4m2/C2jblQRuw?=
 =?us-ascii?Q?/zpFO6HNAeUiPrJP/kr3yrpnUwsBPde2mQzodhaOaaLmUBP6J8IBItBxSoM2?=
 =?us-ascii?Q?mAYDR/5SPrQwVZCAo7fm59ETQLlYBa8zkcx/Pq/YogMA9S9lw3qcp6yr1UX7?=
 =?us-ascii?Q?QgMvnDTRBhHZiy8aPlHuRz0OudGP6YDhtFshO8gZvEUk9p7nLCOnzZWsNhET?=
 =?us-ascii?Q?4/6NPxPJOuruGw4mwOOKhrzJUlaw5znEkJylt69pgNDleeqz1zYFPX2xTCla?=
 =?us-ascii?Q?dHH9NjFtGGiTpdbIcOGsJHnnkwZfUcqG23+QA/Gc2ALpGBbi+9x8uWvJzY9r?=
 =?us-ascii?Q?RaNSGrJYRfug/+pXyhaGTjpDG9WXMqBmtndGjPXALYazRmidf8mF3vdVj1Sf?=
 =?us-ascii?Q?IPmzVBiwqMnuJAp7MUHEpM/Yu8oppxv8zWt/uumnfTRy+n3BGOq2XYJ+EGgp?=
 =?us-ascii?Q?j/w2pDf9iHMlf+iMqwsCEYL0n2zO31cODlR8Nq2U2qwPhSKX1Yunu76UGybz?=
 =?us-ascii?Q?jmgXqG4OQdjPnzObLfL7GgwgH5syr7wDVWfNrOJkOFwqBZA5fb3ieCIW89Uw?=
 =?us-ascii?Q?GuDejMkX3GIcmPN2GdX7LBWf1Kl3Dqqvig3+ry85lEXO58qp3BtgLhrNllAE?=
 =?us-ascii?Q?K2GUNOUDtc/2eBI43oJ0WMs+fwyqbOPJHvyXtcQjsH7MkFtOLHIOextrNxbY?=
 =?us-ascii?Q?W5HwX+qyS76IMCUl7r+OtK5RVsf/aD3nHbDFxi1+fJRc08+Q0rKMBasU/ZPA?=
 =?us-ascii?Q?hysDvDoeAkDvyEQn857GH0FIbbjk9rTtLtx86+wtxHBb24p2EOwjMfMpsW5u?=
 =?us-ascii?Q?vSva7c2Q6A=3D=3D?=
X-Exchange-RoutingPolicyChecked: Z6KK8qsQjuQYW0ubl/uuwIlqzKdjslgNllZ/Aut2QoyPbHW1LuQkGMiHxS/bLz15aYU96W5tfoKGoWGZF+YICl5FrgcOshvlzYaAVse3hvxuU+mCE30SV3CdkyBacUwUcrnB5LyLA8Gov7cpSdVl0pZ1mgi6IGgL7dNa43PrWlRUP5CyGXEujajyYetGgrKgzm/e3sct8my6vJ34XY+KE7gF2n9ApwHqVdq5WlVAU3rIuVgjqZYB9agOby8LYaoIiQw5twYXI1KQMXcdiG02AeSggiydtkr4+7wty//1gtdbBf65JleNfR9+dfPchwURwSHzWfe52+KXTKhrqtE5Bw==
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6f89c0-4bcb-4ae8-56ab-08df0111ce5a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 12:26:49.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PHOg/IImrlOohlWoMMO/hQinRQpM3WocLhh/VtJ2oHsT3zJhS6H+BAcGrxnVhqLN5nsZ8/o8XEvaidQCCa26dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9324
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C8DD4C000D
X-Stat-Signature: w1bqcapmfjf1wp3ydkxz6u3zyjhu5rr1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787488018-752455
X-HE-Meta: U2FsdGVkX1+6bHG3c5S119vbvIPcfFBjRMb5mta7skaOWyu8s3XQMQhMRPjaIXWLD6W/xCzPnK/6vd1oxQmW4CnXcKZihXG/49mjHl2o1mIUi3OaLmFkqQfs5/IavjcKPiyOWQ1iSennl892Y1WyYijfK9cZo8p1sJ4EudYNJu8/sOAyoBydRaHYI365pPsmdfq5NuwERLginRN8xLzUJ3iA3z7sfRAoVvABqr5Cc4De+rt8+QzSqt2mvufkXg8J6tsrzJlhXto6aSZBHOGOPgnZhwwm/Y/7FK3cZxEwnwnaUj/acMCjXImBgYIuMzc9rgUk31PiVK3uPhGUNz3X/cqGcTZmA9IGZxc+C+BD3MLbuxHuDs3X2weN8qquUhzIO0cCuOHoXNfX3CO5CuJgPWefSzElLdjsVNfqLfVwwtdSKJZNPn9nvLdag58AANvnGSV/g4E/LOQCGZutMlAqtcd/zjOE7Am7deIYmJy0s3E/OPbsNHchr1j2Dev8KDrQxiCvpIay9S5BBUsUK5+bjMCJ63bTLdJtBhxwyXbAiY/mx9ro4L5B7T3ubZlH3CzWoQSlpy4mnNn+un9ZJiRrCMD7iimFSrf/opFJ4+g7bTSADEBgSpnooiSwA9Ql9ZOIyh+4ig4c6qIEGT2vYZa5aLuCtH6lYPzJounB5lMmo+qjM9wixhzO8iBkaHt/H8jBD/uFekeHa0YgoqgdYVnzWKLu8gWOGpCpN1ApEVhw5EKckbRyaDuSjWP2s0IA1+M8hAykJEwYNe/9gAxk/G0GC+RA7Z+DkoDX4nMdxfOYkeLI3dQ9VRHcdVOEuKiO+TTDMUF+a5Ooy4711Zp5oP5b1er/a1b0cMDGxKCCpGfJCy3PlsnIcVEmQTsJMWBpDdWrD9bzyvsf/UHXb2lc02i1mvdhuNfreM+RgajwmHEOPUctf1IxoRrxHt92U/r1/uqxlAmbhOjfM0HFHIWVA3M
 2/PfCkT0
 JjIM3gBcn5re9Q3vm2jcveODOHti7LiDpeSFLpTmySgKqwrDAXFkMtPZZNHyR99NCBLoavA+0ajbbgtuAkGgXSk7ZZwgwAj6WgLngnASFde/x5GHwOjBRpMHCeIxLHpRJ1SmvpekmGiJ/QZ9bzjjn+uCHOzkvAkOwlYTAX8rMOIVLELSm5sFixed4wzQ/w4p3dqtHGfbmCWu6JDJjFy9N/bzjjOQrL2kjau0XyaqMcH7IhVBV1nDGF9/nL8DuiM8zzjt4/GWVxaIEBoZK0G/DJfq79Py91RHFdPzLW5Ex74hr0HlqefP+ZG2rQT89gFOvA4W1n+/AsmIeaBQokPXbkXiFFUTqKrVoX0pinMiw6F+goZKaeMLUjrmOOZUHSOAIdvn7c18+R7lYHLK/a1rkEZcl7tC0TVtcghMl6dxYUeashIASSAqhboqVfceEhBc6mG2QVB1Y9BXW8uTGpjDQJB9zFQqIbCRyfaRFGSP/68X3nI1PyBCUWPWXADBIyI6GX5+HlnCfx+IR57U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: a032d41a86cb82a747bc14d9c82b3e153a9a9ab7  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1937m

configs tested: 136
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                  randconfig-001-20260821    gcc-13.4.0
arc                  randconfig-001-20260822    gcc-10.5.0
arc                  randconfig-002-20260821    gcc-11.5.0
arc                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-001-20260821    gcc-15.2.0
arm                  randconfig-001-20260822    gcc-10.5.0
arm                  randconfig-002-20260821    gcc-10.5.0
arm                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-003-20260821    gcc-11.5.0
arm                  randconfig-003-20260822    gcc-10.5.0
arm                  randconfig-004-20260821    gcc-13.4.0
arm                  randconfig-004-20260822    gcc-10.5.0
arm64                randconfig-001-20260821    gcc-8.5.0
arm64                randconfig-002-20260821    gcc-11.5.0
arm64                randconfig-003-20260821    gcc-8.5.0
arm64                randconfig-004-20260821    clang-19
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260821    gcc-16.1.0
csky                 randconfig-002-20260821    gcc-13.4.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260821    clang-24
hexagon              randconfig-001-20260822    gcc-16.1.0
hexagon              randconfig-002-20260821    clang-17
hexagon              randconfig-002-20260822    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260821    gcc-12
i386       buildonly-randconfig-002-20260821    clang-22
i386       buildonly-randconfig-003-20260821    gcc-14
i386       buildonly-randconfig-004-20260821    clang-22
i386       buildonly-randconfig-005-20260821    clang-22
i386       buildonly-randconfig-006-20260821    gcc-12
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260821    gcc-14
i386                 randconfig-002-20260821    gcc-14
i386                 randconfig-003-20260821    gcc-14
i386                 randconfig-004-20260821    clang-22
i386                 randconfig-005-20260821    clang-22
i386                 randconfig-006-20260821    gcc-14
i386                 randconfig-007-20260821    gcc-14
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260821    gcc-13
i386                 randconfig-011-20260822    gcc-14
i386                 randconfig-012-20260821    gcc-13
i386                 randconfig-012-20260822    gcc-14
i386                 randconfig-013-20260821    clang-22
i386                 randconfig-013-20260822    gcc-14
i386                 randconfig-014-20260821    clang-22
i386                 randconfig-014-20260822    gcc-14
i386                 randconfig-015-20260821    clang-22
i386                 randconfig-015-20260822    gcc-14
i386                 randconfig-016-20260821    clang-22
i386                 randconfig-016-20260822    gcc-14
i386                 randconfig-017-20260821    clang-22
i386                 randconfig-017-20260822    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260821    gcc-16.1.0
loongarch            randconfig-001-20260822    gcc-16.1.0
loongarch            randconfig-002-20260821    clang-24
loongarch            randconfig-002-20260822    gcc-16.1.0
mips                          gcw0_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260821    gcc-8.5.0
nios2                randconfig-001-20260822    gcc-16.1.0
nios2                randconfig-002-20260821    gcc-11.5.0
nios2                randconfig-002-20260822    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260821    gcc-12.5.0
parisc               randconfig-001-20260822    gcc-15.2.0
parisc               randconfig-002-20260821    gcc-8.5.0
parisc               randconfig-002-20260822    gcc-15.2.0
powerpc              randconfig-001-20260821    gcc-8.5.0
powerpc              randconfig-001-20260822    gcc-15.2.0
powerpc              randconfig-002-20260821    gcc-9.5.0
powerpc              randconfig-002-20260822    gcc-15.2.0
powerpc64            randconfig-001-20260821    clang-19
powerpc64            randconfig-001-20260822    gcc-15.2.0
powerpc64            randconfig-002-20260821    clang-24
powerpc64            randconfig-002-20260822    gcc-15.2.0
riscv                randconfig-001-20260821    gcc-9.5.0
riscv                randconfig-001-20260822    clang-17
riscv                randconfig-002-20260821    gcc-11.5.0
riscv                randconfig-002-20260822    clang-17
s390                 randconfig-001-20260821    clang-24
s390                 randconfig-001-20260822    clang-17
s390                 randconfig-002-20260821    clang-24
s390                 randconfig-002-20260822    clang-17
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260821    gcc-16.1.0
sh                   randconfig-001-20260822    clang-17
sh                   randconfig-002-20260821    gcc-13.4.0
sh                   randconfig-002-20260822    clang-17
sparc                         randconfig-001    gcc-16.1.0
sparc                randconfig-001-20260821    gcc-14.3.0
sparc                randconfig-002-20260821    gcc-16.1.0
sparc64              randconfig-001-20260821    clang-24
sparc64              randconfig-002-20260821    clang-24
um                   randconfig-001-20260821    gcc-14
um                   randconfig-002-20260821    gcc-14
x86_64              buildonly-randconfig-001    gcc-12
x86_64     buildonly-randconfig-001-20260821    gcc-14
x86_64     buildonly-randconfig-002-20260821    clang-22
x86_64     buildonly-randconfig-003-20260821    gcc-14
x86_64     buildonly-randconfig-004-20260821    clang-22
x86_64     buildonly-randconfig-005-20260821    clang-22
x86_64     buildonly-randconfig-006-20260821    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260821    clang-22
x86_64               randconfig-002-20260821    gcc-13
x86_64               randconfig-003-20260821    clang-22
x86_64               randconfig-004-20260821    gcc-13
x86_64               randconfig-005-20260821    gcc-14
x86_64               randconfig-006-20260821    clang-22
x86_64               randconfig-011-20260821    gcc-14
x86_64               randconfig-012-20260821    clang-22
x86_64               randconfig-013-20260821    gcc-14
x86_64               randconfig-014-20260821    gcc-14
x86_64               randconfig-015-20260821    clang-22
x86_64               randconfig-016-20260821    clang-22
x86_64               randconfig-071-20260821    gcc-14
x86_64               randconfig-072-20260821    clang-22
x86_64               randconfig-073-20260821    gcc-14
x86_64               randconfig-074-20260821    gcc-14
x86_64               randconfig-075-20260821    clang-22
x86_64               randconfig-076-20260821    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260821    gcc-8.5.0
xtensa               randconfig-002-20260821    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


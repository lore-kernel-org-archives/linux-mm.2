Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E54C53200
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 02:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60FA6B007B; Sun, 26 Jul 2026 22:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBC86B0088; Sun, 26 Jul 2026 22:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40956B008A; Sun, 26 Jul 2026 22:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7133D6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:17:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C346140603
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:17:41 +0000 (UTC)
X-FDA: 85032945522.18.0F6958D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf11.hostedemail.com (Postfix) with ESMTP id 597BE40004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:17:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ra1eDCJ4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785118658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqy/whu3i5iNB/goHiinlP2heCRMMvxBiNrb35rgYP0=;
	b=PzjZdjoyE+gyLB9xT6ygYahWe26YbuIo1EmIU3SCnePfFFq6+FKzILoi7xClAEhJnq+W0g
	R6INhKsUtEeRukqfCL9wMoyvg25KvzWN7DlSzMkVMzb4JSlcdwynhGEEFpiGl5ymcRTZJl
	xiZNe26+OYO8rhSnNagx3bSl20l9fno=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ra1eDCJ4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785118658;
	b=amhTjuXWZv15TgjO2SusiP9X6dKZsuK4Iaap9eybiRsNVMNN/87aZtBKOoG9GREzEM7in9
	aRnBfoAprve5o4IOLzC7siDC9OqbSy7FoWgOgBC4SfSCu3OiNhVrxSyyGaw76JdvlQJ4+y
	/gfVFC8x6WDBUY+QMbbf9YWU9aUw1g0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785118657; x=1816654657;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dCZnm7A9hF5z6+s+28xhjc0GGRvqdMzqUtWwYkQ+7PI=;
  b=Ra1eDCJ4gpknvS4WvqKYmZ7QjHlZhj77acFnYsP0LXq+biFmONB7NNHb
   1vYvWQYlBr4wtKX+Y3EMoJEV1RuafHH/fuxUQmlXmDjG0uJe9khs9l0uv
   /96riyEzI81zk4urEZEDaUbbqJnSvWSfUijMtaIul2di1uBAUneXVBC+V
   Mlvd9C6FqXGFr3iHPiBUk1TrYjlypsKlXihESoKzZ8KtS4XKBoN6HlY5Q
   36pL9TR3XQO0dGxR9s6NJBzQDLcd1sDUds5ULaH+aFat3UrfWVBcSgHoi
   5r20CQiz6Pf7CncXtz67zvvTU7TkgWGvevPLOt5MPVWKKd8RPEaQn0t3o
   A==;
X-CSE-ConnectionGUID: E1x0rinORjK2TdehXbmiRw==
X-CSE-MsgGUID: CgQgrc5vRQmFmP1yJfgz5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="85533349"
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="85533349"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 19:17:35 -0700
X-CSE-ConnectionGUID: B9cE0EVxRVKOw4MATRcy9g==
X-CSE-MsgGUID: Baj8ZlM3R2mAjEoOrLb14Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="255356427"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 19:17:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 26 Jul 2026 19:17:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sun, 26 Jul 2026 19:17:34 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 26 Jul 2026 19:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvtMf+t7u6Zvl1SntgIxs27EXb3DVnSZ6yrXMSc9AzT4Y8Bb+ElC9NOSR8fDkjY+EvnH4FxoRCERMpWFq1nj3vWX9I+wpCl0DfzMMzyZ9DP4FgSZO4A8zWNErXS6N9qcaV+TYmp6mEy98+9TdCa6SkbnSMbbT40105+T0QH6VyajImDq1ozTaVYssXkcSBJsEWV31ULj7w1fDqS+3sES9r4Q21w3xaQ0lb3J4bb0ehSaDSvn0Jfm8pv02LdQrpYfYQk7+qfz8/c1o92jcWDR+OWQTpMw8yD9aTVpnx+0ui+byQO38Qvl+V0ammJ/+8JycF+Yjz5hQTnJwhIM74mq2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rqy/whu3i5iNB/goHiinlP2heCRMMvxBiNrb35rgYP0=;
 b=j/zBGiKg4LiqSfn746gUMl5vz6irZhOB1sP+D3WPH42xd4ClMQueL5A/csChKVdfOYsSUq7Q8kAzUm52LftFVnN6N6iRWbKy7oN+6oMhJQa8Rbv92gDoR03aFCNUzbvui2P7aH2JvehdvCHCM2zb8w20rbBwSn9dJFJ1B4UCDoZmS7hOeXM6FfYtSqZZND0T/TmaMmqOu7fBcglCiFzZMBdEyHQdoPSvnOsSyyHqxipDCqD5zzR7/hspQfKgg0tyOGDOTzP6dYlkncqr7RWMAlxIXWqBlzBH44bwWddCR6slc5SHPBmvMfTm3famCqLaJMmIR6wKUPn7b08s58XiiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM4PR11MB5232.namprd11.prod.outlook.com (2603:10b6:5:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 02:17:31 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 02:17:31 +0000
Date: Mon, 27 Jul 2026 10:17:21 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Bo Zhang <zhangbo0325@gmail.com>
CC: <jack@suse.cz>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<fmayle@google.com>, <kaleshsingh@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
	<lkp@intel.com>, <oe-lkp@lists.linux.dev>, <surenb@google.com>,
	<willy@infradead.org>, <baohua@kernel.org>, "oliver.sang@intel.com zhangbo56"
	<zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <ama/sQIK2O0MphL1@xsang-OptiPlex-9020>
References: <202606181547.617a6967-lkp@intel.com>
 <20260723024527.2822383-1-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260723024527.2822383-1-zhangbo56@xiaomi.com>
X-ClientProxiedBy: SG2PR02CA0138.apcprd02.prod.outlook.com
 (2603:1096:4:188::12) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM4PR11MB5232:EE_
X-MS-Office365-Filtering-Correlation-Id: 23a23589-da69-4f7e-c694-08deeb853697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|10067099003|56012099006|4143699003|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: ba3zxHVyj5JjzJBojxhCoD5+xeSVhNPctq8hEKa0NP9AXc1zky2zqiKaAURYQdu+k6TeDZGXd9aAsRZAHr7KeZg9Q7ht0moYQf1l2c7zBunGP2891nljh4Mp66mqaJ+htf5McHRRGD147zxTydrxMn6iE3Ogib7q8ihmyMllnfyE9NGwXNDLwlL1N5eoo9YZS63nqPDtc3sDbEBYErqU46wGTYK3VQH9xiZibVpdSq8J3eu3v0tcoC+SRcHNl9bO8fKtJHTxSCOmu+Nz+GFf50KfqhT0KeEQ+8iQ030IrvXOMBVEiz8/qUSY1eEISo+GHK+6BF0ss2PigRSysxTals3/UYu0vF/eyVwHYuILM7yv/nmBtwYy8Xd41akK2I2VCI1YUddWRLTB20LOyRyobiMO1kfaaoJQm6rdt8nJ+w4S/T5j5viUzf+sR0z4w7iiXXqR278tdHQDCiAyekLy0qYJ1xuwMjBqCT4qXkE2jkobDQxuIZDr4DWXoJ6GunWcNg0Fbd4I5S4bGVLZ3wDrOLV7wgdRbsRZTByOBYVIk9FsbqEiGmOqpOD+7UFlgbXuHfkwdRrSjWO3rF++jGVbX1ulJvGPuJNpablmMbYThhZFKHXs44fEPEzGveet/8/qHRlTB/nqc0Mq7GjiNuHVGlBJbW65hR3/8nms2ulsNyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nmYt5T6OrCr0EIi0LI/QpK2IjDNTnA33/eZFMOhTDAxTEuglMy+sIdCoayCc?=
 =?us-ascii?Q?8CaLpLzNgRiClgIZ/WCoPZwgxgur4l/g5LmOHOzQ0abHcHhvoNtFLJzQmkeG?=
 =?us-ascii?Q?kyPfEqtmRRYhXV3yQVm5dzGYPNVKyW0Rv0UIuN8cWYmdX43DBWG9nWWdFd7a?=
 =?us-ascii?Q?ClrBdf0s9mE4i/zRkODU4WvO7UE8dlBzy55msUarDvWCuB1hkZxWG8CpTFgF?=
 =?us-ascii?Q?u+KVkX7aHjB6GPCAZ/qefoRCJQyYc57CN1DHnKT2Gsn3fKz0zIh7h02S/R3Z?=
 =?us-ascii?Q?2EPQMwKhOTqmXyMtHHYoq86haFPUz7RuB984SVkNi599bWIDkZdHWlUcK/UV?=
 =?us-ascii?Q?vLOEEoCtyJm9qtowpCZN7HNvvHtBxPKvn3cX1+ost0VK/lQoO9O5ZrpFIw9U?=
 =?us-ascii?Q?gwlyWhgMnx3EgzYcE/iQrfBlX+b5qIjuXHR2mHgdUzNWiBU6q5g94hi9iVeG?=
 =?us-ascii?Q?BzZLUcBI/xVZpvWxzEoE/nDVPsn+I/sEd6LS8K41FDZdPa4UIOv7QpHGsmaZ?=
 =?us-ascii?Q?Ebmc0P8Ppp4BZ7rNWpgpcs5HregYHg/sjTa4A4OLqeEIaqjq9IsxRs8q08yZ?=
 =?us-ascii?Q?CfEj7j5Y6vOY1iNegnwfTGEeEtKAly8YhfuWgBpEE2zxKABpySZZJvSaQpt4?=
 =?us-ascii?Q?73dS1Cz07+B02mUL9LpUy+kZTnBiWzlf6fapwNzXz8EunL9hYSMEpusVOcKK?=
 =?us-ascii?Q?WCnVC9rTwJF20t1Uk+T2krgWv5JeCbIDhhae2M0z6VvkU49PUG944wpqavX+?=
 =?us-ascii?Q?M2VDEFDUFo7uaFqF03r/O02dNFxqkcLOiNMwftr4uPX4WKA2yrrH7IdhsNv+?=
 =?us-ascii?Q?CJvEWKK+keusE0kf/X5+dcW8VZ8OzTy5j/gdLUXu4ETMS/swDZaUj/LP8Ae3?=
 =?us-ascii?Q?43QC7pfZ7eWLQrtPmlDb0sCQu2S4tFjzD1qd4OWLb1cZVz91xS8BCfKRo6D7?=
 =?us-ascii?Q?qIHq/RpOd4AamMuY5BD58mZtqtgxmZJssT5O/1tokrXHgECdnS9ZvyYwb1vA?=
 =?us-ascii?Q?TassJfQbwgGtvuACnkhSVTwHLTdB49X23kv5vMclLrAm89JVSoy0YefbNvPC?=
 =?us-ascii?Q?5CYwj5J2C1EUQz0veA+WjMvzURjpeLpWC4LpK6LFTbobodbymzP8+JrGV+QV?=
 =?us-ascii?Q?W6Ku8dIy+HJbj36/JX1pIMoPCxsEN0C2IIvGW4AU9q6RTDttpmpgEYAWk7qD?=
 =?us-ascii?Q?htpiimxlfKqXtiAuVlDmU7vD6RYe2qPIBE9U+ACG9U3l729rj6hCnZ2XasrZ?=
 =?us-ascii?Q?y0B6Ld5kZCik4vMT82C4MpvTcUU/F2mnZxQLI9lpl+m4Ba35alfA+zPC1WSv?=
 =?us-ascii?Q?7STE7AfPlgcGdE+FJzvmb7fc8nWvaaf3wjllzO+2eCOCPZHui98jKw2vVEer?=
 =?us-ascii?Q?JaTovdq0RZbZ0UKqsGQ24vyAHWxoLd2OT6pvxcImb6yWfaRIu+X6mnKiOLez?=
 =?us-ascii?Q?0i0Jrhs3U+m9NCYc77SlICdDLTpJtOPrf905yUNCpUQEcgOW1rbitw3lBEBD?=
 =?us-ascii?Q?ICWKP0i+8Sf2xPVfr5FO2mFjqsFpXZ4Bmis9p1jAjX2DKyxXJJayuNJUQc5I?=
 =?us-ascii?Q?NjmBa1v60ob+WAZQ3H37d1Y/wSq1y9+GuKb6sq2a/PK7GvGDsCWJviGSRD8t?=
 =?us-ascii?Q?T6KPWWrT+35z0LjMWcRzEmK8rM5UQ5qBvjD7LOWu4HcpqkNukTkMBvcpOYoc?=
 =?us-ascii?Q?fbIk9wOHQVBJyF0sUvhz1vFdZnBud3qFT6Are7To21zGNFZtE6XQiVf6G4JP?=
 =?us-ascii?Q?JmsyOdZUwQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: jqUsIkrFPmJzMGHSb+5SCkpkvkFum8c9fHZURwVlffwAOp6egsOUPjAqPqKxuUZwrE8SkR9xXy6h5BVkQsmtLI0ul+aBRXNDFPTIatkJWZF72/xnTGPrBeb6WclbeNEF0TdmZvyogLkRz2YXRKD0UjWAWEi36xUOcxKz45hkI+1A0OueynAqAmFjJ8mk7fzYn0lePjFk5awpfMRQIdIxVw6RjvU8st6Dz/5Y7excm4wS6aamHjdIl+V0oVXK8AiFN0pRB9vl/F/37VORtk74GJmwmumqrqBGMph+Bnu4ARFZJktDywZGL4n8duPG3U6IqpFbh/DqmHq+sOT+FbO76A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a23589-da69-4f7e-c694-08deeb853697
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 02:17:31.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XwyX+N4WHPglqsDNq10PV3pnjMhgsSDsi1YwnD5IcLeBwFAY8CY9uLIXt2e6j/m9afDXcilTtgujKTdmovyuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5232
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 597BE40004
X-Stat-Signature: gw53zhyqfe43ox9bw6ysdpo9z7idbheq
X-HE-Tag: 1785118656-154800
X-HE-Meta: U2FsdGVkX1+Wb1CD1pD1yXZ5JCRHz5uOocRT8dFHltMlMtfwoSj1Zixe4kfD8S5sGHOxlF2IlZG0T+ZtpErxmvG9SsJutPfZsDhzuSsuFSYWnxAQYVlvEuKDkN/pTNMXV8bTMyxlFeNldA3cAa36mdIDZUN5CSrJxJg4WvLANaETUTXuoeJnXGABOtOGxNQAEG+DgM9Ke4iJHq+gGAQWxZ0NiROR0sOq8y6njLJfLfEtpp8C0ru5BPM3PIzEMlJk+t2IJOeDgZPSfiCuzvcYddSGfcfPfflfsHibTp/eUUoQOrB1raz6KUuYITfuOEwqwMayT39gQ1Mi8kkg8GNVPK1wKdhzEU+r+CS3AAbAOm4x++/9U/aLkF7MClu8G9k84oJEAjFM9e1I+0ElkclHXTbFqx3a0+CpHOD1z83qDc/pnMm+Ab07y97qaTpTOfikBHpr/tX4HHnPewZcVXLuiB/iURaAO+WfZcXDv+jshbsTzoJkVKYt8XRA/zk83ElwOG4Tfbs3UOJw2CrTtrH8441t6D4/ShSUVVhR0eX69g7rlH5Na3X2kcUZGQzYFAGiOUAzjSVlXwiQJvgjHZzD4EL0O1nZLwRAtdIDhQtCFGJTWY1PNcBxtMoMzfOuVZTARsqGh1L0VgsQYlevu9InW6gRWq3bL3x2fnWAGq0PjoU32oIlNC6G2gPNnelG6Ox49Po43IT3oDrYCZDa+1EyeEjM47Tr0i5YaGkCpQRYmoLfNr7RSs5ilYpZEvXVdRP5vnD6dwKI4vvsOC0ntcy5b6S7jKM8Eo5I43RidgLf5rYmkwJUbngka8t1DkX7IJltu2KwLRCPMmDck13solW2FS0g9pOsyu1YUFDkyvROmKCncJJQffygsvey6sMlyYtAMmN/pZddkNDVISTfzMCDbaG9n6QSNYMi3ScP0V0JKuUGQFrQyuYRPNnkcqpqjBH7+3MO7Dd5+stgVteKamP
 iuRYb/fI
 ye6481hdTPPv9f30YNnEu3S9q/QB5zo0Ac0k4gsX7z+q8+geA8RTnF2ZmIB0sEg711Fbhu+IcbeSPL3MwJzR5X7qo/9Q9235gJN5DD+qr6zy8ZD6ZfpzYmJ5qTPzqJDPk5b3eSjTJ2bVe/HKOpHWpFjGXy05cZ5XyEzcHd74tEezEhuTl4QkV7ZGHGvkfvnJ163MRVEG6r/wgEu+ZqIiFy+VUGp92gU1Pl+5P4xQuwrZpiFh2WsM4cQFy4hLzE6KnKd5+RbLvHO7MlDnqHzVygxHJbcqyTMjpxmffxz4iBIB3/OXx1tEF8IbM/YnPK5xiVmRutObkMN2Hmi6jm5NluHoVvlciuLfneXTWQ9RvrnpfIGUL8PcWLrubFRcUBrvjSC8nV8YEbrSVVF7AGlEdjEn5WZ393xeZUc5Oe3HV0/zY763u/MI7xnvetwt2+XKWXMPguqBXuIuHVb/vIQqEOC9918Ji6hT5cU1R9x5hrvcJ9z1qREwhCtwpT0UBptuaZYnNvUtUHe1U+pxyyvX0S4qTxGiZy+ispCCkCOHF0XLoZxBiDjXeMJgHTFSDBMfGv7IywPjLSJFE3Mx5LvucFjYtNe3u75JZ9WRCCMzQmp2ks7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Bo,

On Thu, Jul 23, 2026 at 10:45:27AM +0800, Bo Zhang wrote:
> From: zhangbo56 <zhangbo56@xiaomi.com>
> 
> On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > kernel test robot noticed a 45.8% regression of
> > pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
> >
> > commit: 7b32f64bc512b40b268776c5ac4d354b325b3197
> > ("mm: limit filemap_fault readahead to VMA boundaries")
> >
> >     169.95 +/- 6%     -45.8%      92.15 +/- 10%  pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
> >     220.57 +/- 3%    +870.9%       2141        pts.time.major_page_faults
> 
> Hi Oliver,
> 
> Could you help test if the below patch fixes the regression?

quite sorry that we lost the machine we reported this regression, and since
pts running need some specific settings in our test framework, we still need
some time to setup on other test machines, we cannot start the test soon. will
keep you updated.

thanks for your paticence and sorry for any inconvenience.


> 
> The 870% increase in major faults suggests that readahead is being cut
> short too aggressively. The current approach unconditionally sets
> _max_index on every fault, which likely prevents readahead from
> prefetching ahead effectively for sequential access patterns.
> 
> The fix: only limit readahead when the fault is close to the VMA end --
> if there are fewer pages remaining in the VMA than ra_pages, set
> _max_index. Otherwise, do nothing.
> 
> For a 4MB VMA with ra_pages=32, only faults in the last 32 pages (128KB)
> trigger the limit. The other 99.9% of faults see no change at all.
> 
> Similarly, only clamp the read-around start when the fault is near the
> VMA beginning.
> 
> This applies on top of 7b32f64bc512 and can be applied with git am.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/filemap.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 97772a05a18e..9f1e1c9ea6df 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3313,8 +3313,11 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>  	bool force_thp_readahead = false;
>  	unsigned short mmap_miss;
> +	unsigned long vma_end_pgoff = vmf->vma->vm_pgoff + vma_pages(vmf->vma);
> +	unsigned long vma_pages_left = vma_end_pgoff - vmf->pgoff;
>  
> -	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
> +	if (vma_pages_left < ra->ra_pages)
> +		ractl._max_index = vma_end_pgoff - 1;
>  
>  	/* Use the readahead code, even if readahead is disabled */
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> @@ -3398,7 +3401,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * mmap read-around
>  		 */
>  		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
> -		ra->start = max(ra->start, vmf->vma->vm_pgoff);
> +		if (vmf->pgoff - vmf->vma->vm_pgoff < ra->ra_pages / 2)
> +			ra->start = max(ra->start, vmf->vma->vm_pgoff);
>  		ra->size = ra->ra_pages;
>  		ra->async_size = ra->ra_pages / 4;
>  		ra->order = 0;
> @@ -3441,7 +3445,12 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	}
>  
>  	if (folio_test_readahead(folio)) {
> -		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
> +		unsigned long vma_end_pgoff = vmf->vma->vm_pgoff +
> +					     vma_pages(vmf->vma);
> +		unsigned long vma_pages_left = vma_end_pgoff - vmf->pgoff;
> +
> +		if (vma_pages_left < ra->ra_pages)
> +			ractl._max_index = vma_end_pgoff - 1;
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  		page_cache_async_ra(&ractl, folio, ra->ra_pages);
>  	}
> -- 
> 2.34.1
> 


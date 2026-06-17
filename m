Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D733CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E085C6B0005; Wed, 17 Jun 2026 10:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91C96B0088; Wed, 17 Jun 2026 10:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BFC6B008C; Wed, 17 Jun 2026 10:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85E876B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:26:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CAD28DD7A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:26:24 +0000 (UTC)
X-FDA: 84889629888.06.606B8F2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FBC5A0011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:26:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WTQwogSU;
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781706380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dqbYo6Sb5eFZI0tF4XOEdJvEqYZqljb7do97ybKcGX4=;
	b=MS1a3tWHjPr4uwV+KFVqaXcVJfW4yzUJfmQrZscqnYipwNaXfAIb82Et31NbSm93kL9lqH
	p4okbmI3zehW3dgl0VbJeXXR+zMym3HGqYaovx0zf8EuoaZGZhitcMXVdM0otAOe9n5V0S
	2Gl9VXBtCiD5Sts8Zfo79xj+m2O3do8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1781706380;
	b=2VoI0f4Gbq9b4nmYQO4YvenBTUPfkUXnXgmlL72UbiWF9EDrQmEzKxbnNpLtaV01BSBhhT
	/gUQGCweGXydT7g0xK8X4V6qweQDqt+na14N8E2xGBIpRTIi3tzlqeuRjLrMeFQHtFaK7Z
	pQTxCIBTesRo4kVCYzLfW0bOdvoKKfk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WTQwogSU;
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781706380; x=1813242380;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=fSzluroP1pQyIiH4uI9pncfIs2mldjx14zHmvSxVONQ=;
  b=WTQwogSUkZMD2Nkr+Mw8mt6M9B2vLcFum2P5mRnzStlePhU+/rl7EJ5d
   OhgL8pw1CCUWFGpGBvlOq5y5p1kiZPHLaWmE/UWVVOxiz/8/9MKZK1Hx5
   R2KpoL8j3AvRQuPYmSWDQhoqxORNRasjTa3o4QKUNF33/Sp6FCU8KNaMg
   gSFvaFNfD+emqPzk5hibN8wXFhIH1a6iTSKsOO+Dm3qus/Jn0U9m6tuSb
   YDloW64RupS1lfVWWPbDoZrKQUPX93Oy75wx55N7Px4E7iJDTLN3lmUUC
   QpSx5NUbumC4Afo67kpLBkh618z7nYeoUuGSWInpjyhCg1pMYrQW5NjaA
   g==;
X-CSE-ConnectionGUID: ZAtSMe0/SmS+l1waIoD+rA==
X-CSE-MsgGUID: WZkoy46VSii9f1LWL58u6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="107974769"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="107974769"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 07:26:18 -0700
X-CSE-ConnectionGUID: QLoWk94fRJq9R0phMsMRXw==
X-CSE-MsgGUID: uvyqMG6RQfqI1bqNKqxHuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="253042296"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 07:26:15 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 17 Jun 2026 07:26:14 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 17 Jun 2026 07:26:14 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 17 Jun 2026 07:26:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKzCUlYnMQkqQDT3E0CNuZkrOH9kNH1CKI6+OxJnuLMgJklPMqaAjax2IGdTNkZv77gROCkOdk6ySD5fM155CgHjTF/NPTUYsJKU4IbZWev5+QImxMKQy9NOG8L21H/zctloCvmFqVS5ZdeBcryylMj18NZOokrNvyvUD7E3O2hZqVpBq8k4jjGxc3Az++CR6O2pow9OC3JGFYNa1QwCQkOpoHiT2hNoMRoZKSGJ7vfk+dQP0q8SoVy636woVplEgufM42umpyIaeyppfug2p2ZJgqwrKeur+LOheeHz9ve4BZ3TdIK6/OUETmKW8m5ECZwCMIIDx9D6DcI8JUmQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/7onEP4berimWllZp7GVhbAw4gJytidncCOAjqpb8o=;
 b=acay4zIbFckwizZZKJYZeeyrUUzRgHdF5J83D19NDyf4W1DyS8f8hH+oZRCs/THcWI0AeZ4HCRIAI0szy/pAir4Uv77XGMTLyvL+pjWoGAg1A2nvzKTu5nVVidXLcOR/R8Gje8x70aaG8B1OIcHwelDjfw1TRPhYljXDHBsyw29wkO5YnIZ2A1ALpUcgrrXiQZx+DMJa0QTjjggAPyRbcKBkb6030Ii9aciy+Eval5EZ9WWVAzdLgAbGxHpK+KP5zHwbEEIfm/+qv8yeIlfyQOERp0I/Vy1W1yuapbMfqo1fMLUczsRo1yrmroHZqYUlZVGYfuOcj4B/L3EkI1EOPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by IA3PR11MB9400.namprd11.prod.outlook.com (2603:10b6:208:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 14:26:10 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 14:26:10 +0000
Date: Wed, 17 Jun 2026 22:26:03 +0800
From: kernel test robot <oliver.sang@intel.com>
To: fujunjie <fujunjie1@qq.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Vishal Moola
	<vishal.moola@gmail.com>, Matthew Wilcox <willy@infradead.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/filemap]  0b9c0aeba9:
 pts.graphics-magick.Swirl.iterations_per_minute 8.6% regression
Message-ID: <202606172137.52c5fa5e-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TPYP295CA0023.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::7)
 To PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|IA3PR11MB9400:EE_
X-MS-Office365-Filtering-Correlation-Id: 45295ff7-e196-495e-23c7-08decc7c60d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|56012099006|3023799007|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info: AxVgNNDMPXvnmaJzJ2ZSpbFwtWEEcLIFi4h8vKPJFE+DB7YSbLV1lm9Vhg+cxmFikAFbLZgMgC0YBWqY+TrQoFSNaTKl3P6koDxAQENEPTaZOx2mj0Ye+92dJG2dhbMufUmWZlXEoW6wU5mpJxumTvs39PMCgZI9xP59HUfmhluVGOKVXngNhgnoZIztXFhFdsKYzG2pFVU5SKCfWdnhl4KpSoQ3Pl83C+eWYAz4OUPJqP5sGEGdGN3eNRy8kABHKAiwnXOQ70Ksy+f+UCqvQLECm3sQWjKsEOaoBkTiI3AkbW/XcEwJQIHSDIX5sFWuFHU3WvCTLoSb9qhcK9sI9QRICg9eW+1U9UTbZgEpisvuQqHvj5/pU9Iz1fkO5uH/1PstSA8qy1p2n9KFPdNFyl5jD/EdP9w8ShvWDwsBHttuHm0XbqY0fs4GktCzDB9NJ3H7FFf6ly1Z6UknH+wu2uhQwyTEhXTNp9AqiuHiaQo96AMpaW6twK+/l8geMBPwbl81uvRpmyVi6rIOgjCLUzJOmmrO6hiid9TzTO9xr0M9Yv4r2n35bvnUglGnhg/NzG5+q+j05930pOgHTdIs7PmZHIuXezjqG4FA+jrO82OIAQmL5ysv8IGdYCrUr9Yw8dXT1s6UuCKQbUEeMwLhIngVbKqoLG9z7KzU5wEH0zo+0RnVC5huN6JHmFN/vsfHilENViTIybrT6tMJzuHtdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(56012099006)(3023799007)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?G8GyTMnz+HaHTF9/xJX4cOaTDNDyBwVhEl3y35v1Rk4YaI8JTyxhAnZcXQ?=
 =?iso-8859-1?Q?J8s8zj7pIA3zIDG2QDgTBqKt+w04on9sb4uxp8hv8ORAHoonDq0jyIpwNa?=
 =?iso-8859-1?Q?mytnitzG4ZisM1YyO0SQ4clTkblQaWdq8GgKK+n8zwV1GBMpboz8bbQ+Or?=
 =?iso-8859-1?Q?zQSr3eWU7P11H1XceuaL2fCP5a88zCSslpH9EqyeaS/1T6pcoZSkCw9Fbp?=
 =?iso-8859-1?Q?CHJ0ECOEiFSKI9rQSyrPr0Z3ly3tY3E3mjOSdnuSsMU0K6aLm+WTaBIgFv?=
 =?iso-8859-1?Q?Vsne7diBs4LF8LCXgac3AQHC1P8iJIAfXbIxWP3zx0vFI4WN5AlIHFN4dr?=
 =?iso-8859-1?Q?AP0Cx22ESlAJjH0Z0SLcpUE1mcXeHaHN0MrnyI6+w0F8zEWy8fl5+gu3AI?=
 =?iso-8859-1?Q?hI+3txwyN6eap/9R/mGsfQP2mDq6VGZtxJYHX/foSF9W52pJAsfnVDEB9p?=
 =?iso-8859-1?Q?aRZ0hHY9CumIWgR2/6T+UQ78yHGgZn8cALcfhfcf6hKpD8rCzBM2T7dpFR?=
 =?iso-8859-1?Q?PMii/KZ31P8G+Op5BtncpQkkpXWSoiUQFDc+PBCrg7UNAB8InNPeR7L07i?=
 =?iso-8859-1?Q?+P0CGzEWgnN5G85S9se5uIVvCyeWcRXDJJPFCfbKNiAnnF8hago2xOCmy8?=
 =?iso-8859-1?Q?5vLJYVzXBNaZiQg3PYFLCe0pnVz6Gf5tZCPB2gustorAMya2xIFE5e77kp?=
 =?iso-8859-1?Q?lOfOynCrzFMmsUVjXifyBzA2egBeGx/ZPFk+wTpAX0M0C8DJDtO7/c5UgT?=
 =?iso-8859-1?Q?on7qwuVy9LoAJjgdUxgr5CeDu684o4172VxjwgsOCROxMJegL6ilW1iivP?=
 =?iso-8859-1?Q?1gi4s7sAx6Jpc28zMpnETeWXz40Mru6U/grZ9RlBb0a8HGN23LMfJLlhix?=
 =?iso-8859-1?Q?81ovI/weseWLI51cmPN4mU1of8g+JeMAIErbZqUoJAo3EAJDXr00NA1ULL?=
 =?iso-8859-1?Q?HOjDgLihYrF5rgFI/xOZtm3ps2nb2kXFBteRXwZM4xFdgf5YNwkBokZliQ?=
 =?iso-8859-1?Q?roMUNJs1k0iPKV6AlErLN8IxSyULou18M0QYmg7eYkQ+l0RLZMf4W5qp+O?=
 =?iso-8859-1?Q?QKmQEXXmMiKZQhoIqVbtwlk6rgpZaHdcvgX/kzqonoiNC0rFuIboqJG6yZ?=
 =?iso-8859-1?Q?APVpu3Z2guRxAPoiH+AZuZscRu0NkKtScUPU4K8U1hKyv842rAAezYltA3?=
 =?iso-8859-1?Q?hLWbp5nakQxWIuA70RyBKbh9qyvsAH45wdyDeWG1azOX0PtWFXkSEnTLwd?=
 =?iso-8859-1?Q?1sjtJ6+bna4w66sDVujVXjtMgaAIWePFZyBr3aeEjch+FGXDdcqxkMa+MZ?=
 =?iso-8859-1?Q?CbVhqj+hwic4e1VCsjmJWyypHvyOYbda5nDt3f7ZHT0pl0eTpzaJsyQdR2?=
 =?iso-8859-1?Q?aLoQoVAPxL1qYjipgIYlQGXY8CRp6C5AaF2dsiAwyJwsqm3xd+qpnIKBk/?=
 =?iso-8859-1?Q?PMa2bcfOxJh+pXNoZ+1sLIzkJzrl4AjFB53MiWpbucD3SvUYjvNjF242/L?=
 =?iso-8859-1?Q?BUBhrfYqqJBEBP82aPNsLNpQRYyOQ0epK2snjpYMRdDY2bVZD9WZk5Epek?=
 =?iso-8859-1?Q?kbT3Yt/PkLOCLDV+/CLaAtDQuF/ETZBKmT6F24oEEdnlFbfLQEIJmx03ya?=
 =?iso-8859-1?Q?EflvzgDd869sM4yDC/FiFpGe2EvQnDjQUeHyJcm6cHeJkPTwYbXhV9uYls?=
 =?iso-8859-1?Q?sjuoqaPdnktcIVaALejTLoau5GwkVNMwTNkg7VaGKT1765yjttNhaEfvSe?=
 =?iso-8859-1?Q?WmqlaIPlQtyz3yiH2/IdLIlG4OH85aTg9ntVDuc8i2stf0UjOr5pg5TbMV?=
 =?iso-8859-1?Q?gJ8LB07C6Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: hPBnfs+fYSNPCCFxybo0A3YGguPXXH/3ZeGmzhpcXd4i2vCuK7vmAW0uRdGXVWy+/iWQN0jweYMHvBsU4q+a/MidH4txDHLpVijd0qjgKE597Ov5AXTnvSvdSzPVpcRaPyJrZj5RWp8PNRb+vMYQ31mjLkHVNYF4Vn9NhkV26dUwin/fcgCC3ung5BBUi3DGDjwqCEH6yLxbuWTBxiBe3Gq97YIezkSl/hzglpAhd2aKkUrDKo4SrQY2zdnKVmXZdBy95KKnfyT9NgEJRuqGJ5ty1g6iDtmGYFuh/5yaWHQjHR2K4ryJfT4K70n1BJiSYx4zu4DVGd7cyoh4/8ctYQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 45295ff7-e196-495e-23c7-08decc7c60d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 14:26:10.7361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49k9WwrafBy5C5lXYm09DdVeVnd+FJ1pygcSOh1VpyTK9wFJCoTxzI7PqX3VnAFoRGwEn1hhJKYb+6fPE2WVig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9400
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FBC5A0011
X-Stat-Signature: g3rszox1o6pfaucydkkf69tie89h6xib
X-HE-Tag: 1781706379-688006
X-HE-Meta: U2FsdGVkX18kUNZpEr9d3BQgnbItFvCzW2Nbc2Kviws/lAFUkH6qQ0MLba63gTgdmnI2ZpUq+Ign8ALOoalyGg/a1W7sYRXcTISZ7AaiLeQbdbgaNtNrQGA0bIf5IWtvMSQP5ScxTzTIWMumYFQAwT3pCmDAim2vIvKD11UPV2LRNh5NNwF1fpU0rfQS8+R0irWoD+t4peBvqHZX8+GxAx+4Y195IMdJnx8MDprayxs1uNxuBTSWb4CMXEjzBijG83+wYEu90PNoLizekoYPiO82nie9NWydy73J4G7Tv90co8FnmWsg7KADUmMfBGj5wCDh30BF75erQwbX7p/JJnWNkzKSEMd3TtRCGUCzWN47G3dqOBdOq/idt2O4NDIp006HnQAOx9gjDnlsm6pDdvuJlUNV+2XmIP8mZd70Ka/36r+RsrEJTxU+xmxlqJJiQl1IplLxircMl6z1+2KEI792C7UXEz5mMGpeypxjQePZjfHNDsgPflQaVmlbtZaxGSIN1hYsLJZrZ6f5LNK2do9zgMqGYNJC9FFtfazrrf80240OAdMXR5AnlahqUHL+qxLFA4qMTuisN273LGhPX1SLAcOYfWniE94KietoKGLxinik8zFOQrcoJLf64toob5Pe0RVyHDb12A9g8ODFhrWGmNX4AOCvknYZ0ICyyRfdSMEZACXNiqep+1LzItYm+k+mWnbwIor7PSTuf85bBSClLp+mfgvsv/8Uuu2ONluXvmsR8s3zzxsFHjqp4weyUksT7lXL58Ferj2aMXUu7RaeTjT5fCCvf+f0F2Eqpq6pR3W1GAehSkgQ8Pt8d4ZuwSN7IFPMUL6OcAVWBBQxxqpOwHVdqma1WrYq/fjwlopOWriE8cVoV00SsMEe2M5Bn4s/5gI/wVZ/M8r7xBHDtsjIIHc8U88923XqgD2oQmdQq4g+tBgG/L4266HAlWPDlw7Mzkp3vVF1uVfCkf2
 /YiDn4eR
 U8Jo19LDH/QW1zdzLeS+TGtC9H+xaTlN33PhXULdt/SAOct5vwtSbmpwPE96xxpFp06SmlT7I1J8LuWsOJD8/NUbiVbB4hrnaZAnCbE4XdX+lXzlwVD+vTEZ4ATwx0KVxZLOP1GPrsZMcHMEdHEyjsDLXAxl8dMMDYqCIxexCo03kxShneco3kWte50IzeN+lTXjlIyt9nf6GiRePco4o3ET+G5jJ0gairsBxvK6qClLqQF4Aw+vgy6UPT359HRKQzZEyyCAiHEId8pMl4aXlE9aURl1ekDnmSokZGWIVdCy4CrCdXyCW2DUWuMKsttx56QBcKMWyqq8jmZkqRB78oJjhXsC3UNEl43/nB2kzCnAzbaMDxFSvX4+DwEuLWj1R9MT+VodKAnOY2rMLK2hR3FvrqYzOY1XvErl2wEzwM9sYAB1EhHK8qfcpSlV3MvD+fM2lCu3DproRJix8r1fpObtxHbWvV4WSrdTjAQViaj+rckSewG8dwxxnlSICWijDIPaCL8P8no/NkAneU4z26KjexBvsq1ax8IGiyFSd7k0eZ0yIyhxCt+uQ3kdz9SVTkasNbhZvmAjdR8495i3I/UhNoJaS7LsMEclXqUgBcjV5T1CstiOkikJ4/5qcgegTSAeWQZIa/CsRGcHVGd7TAbCV6hLoVhu6sWtFiFyIzN+Y9jzMC9JQW0kCi0WZnvug4uHN6pLr28TTfvyWvwyDI7N1Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 8.6% regression of pts.graphics-magick.Swirl.iterations_per_minute on:


commit: 0b9c0aeba938aad9964f855df00bf929b83a484d ("mm/filemap: count only the faulting address as a mmap hit")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master ec039126b7fac4e3af35ebccaa7c6f9b6875ba81]

testcase: pts
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
parameters:

	test: graphics-magick-2.2.0
	option_a: Swirl
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202606172137.52c5fa5e-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260617/202606172137.52c5fa5e-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/option_a/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/Swirl/debian-12-x86_64-phoronix/lkp-gnr-2sp3/graphics-magick-2.2.0/pts

commit: 
  95b8e43226 ("mm: use zone lock guard in __offline_isolated_pages()")
  0b9c0aeba9 ("mm/filemap: count only the faulting address as a mmap hit")

95b8e432265f61bd 0b9c0aeba938aad9964f855df00 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    814.83            -8.6%     745.00        pts.graphics-magick.Swirl.iterations_per_minute
     55127 ±  5%     -10.3%      49460 ±  3%  pts.time.involuntary_context_switches
      2153 ±  5%   +5894.6%     129074 ±  6%  pts.time.major_page_faults
  12775652            -8.5%   11686096        pts.time.minor_page_faults
     15099            -8.1%      13876        pts.time.percent_of_cpu_this_job_got
      2124            -4.0%       2039        pts.time.system_time
      9036            -9.2%       8207        pts.time.user_time
   4500789            -4.4%    4301829        pts.time.voluntary_context_switches
     12315 ±  4%     +10.6%      13616 ±  4%  meminfo.PageTables
   1828588 ±  5%     -10.9%    1629373 ±  2%  numa-numastat.node1.numa_hit
   1828671 ±  5%     -10.9%    1629233 ±  2%  numa-vmstat.node1.numa_hit
      1.34 ±  3%      +0.2        1.55        mpstat.cpu.all.iowait%
      0.10 ±  3%      +0.0        0.12 ±  3%  mpstat.cpu.all.soft%
     78.37            -6.7%      73.12        mpstat.max_utilization_pct
      2.44 ± 66%      +4.8        7.24 ± 58%  perf-profile.calltrace.cycles-pp.sw_perf_event_destroy.__free_event.perf_event_release_kernel.perf_release.__fput
      2.98 ± 59%      +5.8        8.81 ± 33%  perf-profile.calltrace.cycles-pp.__free_event.perf_event_release_kernel.perf_release.__fput.task_work_run
      2.44 ± 66%      +4.8        7.24 ± 49%  perf-profile.children.cycles-pp.sw_perf_event_destroy
      2.98 ± 59%      +5.8        8.81 ± 33%  perf-profile.children.cycles-pp.__free_event
      3149 ±  2%      +7.2%       3376 ±  2%  proc-vmstat.nr_page_table_pages
    443579            -1.9%     435060        proc-vmstat.nr_shmem
   3584637 ±  3%      -7.2%    3324877        proc-vmstat.numa_hit
   3319585 ±  3%      -7.8%    3060170        proc-vmstat.numa_local
 3.533e+08           -13.0%  3.075e+08        proc-vmstat.pgalloc_normal
  13271607            -7.4%   12294786        proc-vmstat.pgfault
 3.527e+08           -13.0%  3.069e+08        proc-vmstat.pgfree
      2086 ±  5%   +6047.5%     128277 ±  6%  proc-vmstat.pgmajfault
    166303            -8.6%     152057        proc-vmstat.thp_fault_alloc
     28.46 ±  2%      +1.0       29.44        perf-stat.i.cache-miss-rate%
      3164 ±  6%     +24.3%       3933 ±  2%  perf-stat.i.cpu-migrations
     28.98 ±  7%   +5995.2%       1766 ±  6%  perf-stat.i.major-faults
      0.44            +2.6%       0.46        perf-stat.overall.MPKI
      0.01            +0.0        0.01        perf-stat.overall.branch-miss-rate%
      1719            -1.6%       1692        perf-stat.overall.cycles-between-cache-misses
     59.55            +1.9       61.43        perf-stat.overall.node-load-miss-rate%
      3138 ±  6%     +23.7%       3880 ±  2%  perf-stat.ps.cpu-migrations
     28.03 ±  7%   +5980.2%       1704 ±  6%  perf-stat.ps.major-faults
 5.496e+13            -8.5%  5.028e+13        perf-stat.total.instructions
      1.41 ± 36%     +83.3%       2.58 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.17 ± 34%     -82.8%       0.20 ±169%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      7.34           +11.2%       8.15        perf-sched.total_wait_and_delay.average.ms
    366839            -7.5%     339473        perf-sched.total_wait_and_delay.count.ms
      7.32           +11.2%       8.14        perf-sched.total_wait_time.average.ms
      3.58           +24.1%       4.45 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
      0.38 ±  2%     +48.1%       0.57 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
      4.64 ±101%    +192.3%      13.57 ± 23%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
      7.14 ± 45%     +73.8%      12.41 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
    339.44 ±  3%     +18.1%     400.91 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
     58862            -8.3%      53992        perf-sched.wait_and_delay.count.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
    294758            -7.6%     272232        perf-sched.wait_and_delay.count.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
    113.17 ±  4%     -12.1%      99.50 ±  2%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
      7.56 ±100%    +191.1%      22.02 ±  3%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
     15.87 ±  3%     +36.3%      21.64        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.migrate_task_to
     14.18 ± 45%     +67.2%      23.71 ±  6%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
      3.55           +24.2%       4.41 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
      0.37 ±  2%     +49.8%       0.56 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
      2.43 ± 14%     +91.5%       4.66 ± 16%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_exc_page_fault.[unknown].[unknown]
      6.68 ± 50%    +103.0%      13.55 ± 23%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
      8.24 ±  8%     +50.0%      12.36 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
    339.33 ±  3%     +18.1%     400.81 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
     15.55 ±  3%     +52.0%      23.65 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_exc_page_fault.[unknown].[unknown]
     14.33 ±  6%     +53.7%      22.03 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown]
     15.24 ±  5%     +44.4%      22.01 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_user_addr_fault
     12.27 ± 44%     +79.4%      22.01 ±  3%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
     15.86 ±  3%     +36.3%      21.63        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.migrate_task_to
     14.53 ±  3%     +45.3%      21.10 ±  3%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
     15.90 ±  5%     +41.6%      22.51 ±  2%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
     10.27 ± 61%    +100.7%      20.61 ±  2%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.stop_two_cpus.migrate_swap.task_numa_migrate
   4282234           -17.3%    3541405        sched_debug.cfs_rq:/.avg_vruntime.avg
   4735201 ±  2%     -13.9%    4076046 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.max
   4115256           -17.0%    3417248 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.min
    423.15 ±  2%      -9.6%     382.71        sched_debug.cfs_rq:/.runnable_avg.avg
    420.53 ±  2%      -9.6%     380.35        sched_debug.cfs_rq:/.util_avg.avg
      1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/.util_avg.max
    286.15 ±  7%     -14.4%     244.91 ±  7%  sched_debug.cfs_rq:/.util_est.avg
   4282232           -17.3%    3541404        sched_debug.cfs_rq:/.zero_vruntime.avg
   4735201 ±  2%     -13.9%    4076017 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.max
   4115256           -17.0%    3417248 ±  2%  sched_debug.cfs_rq:/.zero_vruntime.min
   4263217           -16.9%    3544690        sched_debug.cfs_rq:/init.scope.se->vruntime.avg
   4263686           -16.8%    3545475        sched_debug.cfs_rq:/init.scope.se->vruntime.max
   4262749           -16.9%    3543905        sched_debug.cfs_rq:/init.scope.se->vruntime.min
   3220012           -14.8%    2744219        sched_debug.cfs_rq:/system.slice.avg_vruntime.avg
   3545518           -10.9%    3160659 ±  3%  sched_debug.cfs_rq:/system.slice.avg_vruntime.max
   3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice.avg_vruntime.min
    448.40 ±  2%      -9.4%     406.19        sched_debug.cfs_rq:/system.slice.runnable_avg.avg
    448.42 ±  2%      -9.4%     406.17        sched_debug.cfs_rq:/system.slice.se->avg.runnable_avg.avg
    445.86 ±  2%      -9.3%     404.18        sched_debug.cfs_rq:/system.slice.se->avg.util_avg.avg
      1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/system.slice.se->avg.util_avg.max
     17612            -8.0%      16195        sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.avg
     17072            -8.4%      15640        sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.min
   4282329           -17.3%    3541763        sched_debug.cfs_rq:/system.slice.se->vruntime.avg
   4734174 ±  2%     -13.9%    4074191 ±  4%  sched_debug.cfs_rq:/system.slice.se->vruntime.max
   4115719           -17.0%    3417711 ±  2%  sched_debug.cfs_rq:/system.slice.se->vruntime.min
    445.87 ±  2%      -9.3%     404.21        sched_debug.cfs_rq:/system.slice.util_avg.avg
      1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/system.slice.util_avg.max
   3220012           -14.8%    2744218        sched_debug.cfs_rq:/system.slice.zero_vruntime.avg
   3545518           -10.9%    3160649 ±  3%  sched_debug.cfs_rq:/system.slice.zero_vruntime.max
   3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice.zero_vruntime.min
   3201153           -14.7%    2731311        sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.avg
   3249048           -13.6%    2808484 ±  3%  sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.max
   3153595           -14.8%    2685843        sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.min
     56.08 ± 17%     -29.3%      39.67 ±  9%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.avg
    128.83 ± 17%     -25.5%      96.00 ± 24%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.max
     25.42 ± 31%     -34.4%      16.67 ± 30%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.min
     27.90 ± 11%     -35.1%      18.10 ± 26%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.stddev
     17409            -8.0%      16022        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.avg_vruntime.avg
     16929            -8.3%      15524        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.avg_vruntime.min
    157.14 ± 19%     -60.4%      62.15 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.avg
     17300           -23.2%      13285 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.max
      1631 ±  9%     -45.1%     895.75 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.stddev
    157.13 ± 19%     -60.5%      62.14 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.avg
     17298           -23.2%      13283 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.max
      1631 ±  9%     -45.1%     895.61 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.stddev
    504.25 ±  3%      -8.3%     462.57        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.load_avg.avg
    157.13 ± 19%     -60.5%      62.14 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.avg
     17298           -23.2%      13283 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.max
      1631 ±  9%     -45.1%     895.61 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.stddev
    449.13 ±  2%      -9.2%     407.68        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.runnable_avg.avg
    448.89 ±  2%      -9.3%     407.10        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.runnable_avg.avg
    446.27 ±  2%      -9.2%     405.04        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.util_avg.avg
      1190 ±  4%      -9.5%       1078 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.util_avg.max
     17428            -8.0%      16038        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->sum_exec_runtime.avg
     16954            -8.3%      15542        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->sum_exec_runtime.min
   3220022           -14.8%    2744222        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.avg
   3545518           -10.9%    3160659 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.max
   3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.min
    117383            -8.5%     107420        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.avg
     93409 ±  4%     -12.8%      81492 ±  2%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.min
     11146 ± 12%     +23.7%      13782 ±  4%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.stddev
    504.19 ±  2%      -7.4%     467.07 ±  2%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg_contrib.avg
    446.38 ±  2%      -9.2%     405.51        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.util_avg.avg
      1191 ±  4%      -9.5%       1078 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.util_avg.max
     17409            -8.0%      16021        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.zero_vruntime.avg
     16929            -8.3%      15524        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.zero_vruntime.min
   3219034           -15.3%    2727012        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.avg
   3233948           -15.3%    2739777        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.max
   3203580           -15.4%    2711785        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.min




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



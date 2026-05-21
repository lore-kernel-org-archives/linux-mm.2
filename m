Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1584CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 05:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C056B0088; Thu, 21 May 2026 01:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E776B008A; Thu, 21 May 2026 01:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36F66B0093; Thu, 21 May 2026 01:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFF2B6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:17:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 990701C1399
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:17:06 +0000 (UTC)
X-FDA: 84790268052.17.EA41310
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id 463691C0003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:17:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c0dKc/oV";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779340623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEvOw2pzeG17fPxzTe0vQlWs6PrEL7xfDC10yEuoa+8=;
	b=JTXTuddYVEFWApYOvUCkzKwtYwCPknU4VnWfgb/0ooFuHThC+hzslhi1jFx/HTr8FbfoVq
	18+icK+QAFiWS/xRUCABxMsn6erAxBX/FkoaD//Q8QQtInZoiRddVk5K0dfeg5t136HTRB
	d1+oYOalWJPzCBbt1EmAwOmHU43Ezls=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779340623; a=rsa-sha256;
	cv=fail;
	b=VpXvRC4GNEV/tHU9X1VfU+VgUFDxq6jW8vGaThU9Y7Vc2hahYQ+YG5EhbzJe+hVrSZy/9n
	th4wRTd/QHpTR8WQz6O/kNCi09OXx+f42I44BEyoGBjl/77/hEs3GC5B+jHTnLIopCPtRY
	uJVKZ9LnboZFeSyb85zQI7ZhZT92m2c=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c0dKc/oV";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779340623; x=1810876623;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xEvOw2pzeG17fPxzTe0vQlWs6PrEL7xfDC10yEuoa+8=;
  b=c0dKc/oVzgC/sGVWptem6ZQuxON1FucAcUfKQeExj+SZsnWkVkUMCfBX
   fhRtDGjSQ/+dTXxr2l8yHaG15Cc4VqwFJJqNqWlG6jSjA6mcip0JEmjJR
   eY4Q/Tl31gFyZ+FDOtnwNB7Qjd5FVToUcSczd2q+k9gi8oSO5s7PQKEiJ
   Al/7DD0cTz8TznWfewc1GCD2ZBGCzvGZ0uB66rbrs2BEBZDX2JqT16w4K
   JryLA44l7HTBrQi5r3AqG2zy+1bEzMIiyiUG/XbnsXQcYCJeJBVZHZu1I
   lUZY5gm/v4nJBXGVsYZLlQhigkL2jls6Up8FO02KhS07LKI+7Wwrm/+cL
   A==;
X-CSE-ConnectionGUID: TwLhv5MRQbKgC49yhSs3Yw==
X-CSE-MsgGUID: Vo9RVLTxSXyj0RBs/DpNhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="80219156"
X-IronPort-AV: E=Sophos;i="6.23,245,1770624000"; 
   d="scan'208";a="80219156"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 22:17:01 -0700
X-CSE-ConnectionGUID: QHZr4mRqSV+PQ3yhnwn2AQ==
X-CSE-MsgGUID: d6aMUEibSx+7njN8QWqS2w==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 22:17:01 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 20 May 2026 22:17:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 20 May 2026 22:17:00 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.43) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 20 May 2026 22:17:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dltt4qOKGn1dj/4YzTMeJxvcaTZm38T/B+l6sf33y9uzeju0mihhl30dhY4PvQbtzLXvDzGffNq4oF6Gok5SKPt7bVohaJY6gVGMFZVohHi2vXHe6NX4ROwC3XOrP5P4EJ6qKmwK3I698O5hJrznlv2XXsCmh/9/BLwWdZrXaZEDGdEWxwY2YuZEbQb8KZ2etJpsRk0RTAoxJXWiKEH3O3nJDmxpVHMlFfpZELIetjxwdK/gtA5SqNtq2DxRkqdO06DVLQTiEiCtGwSF4gUXyA7OLId7qfcF0ZsdrDzxD0j8SpaEiVL0nixaUGkav4mBbL2Dxh4U827ns4IWf7ncxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEvOw2pzeG17fPxzTe0vQlWs6PrEL7xfDC10yEuoa+8=;
 b=YKQUrKT1tyYk/7oAzdQCBoVl8xoVa0iaTxlKEQaqmipzax6cWYWFDo+WFv+IKHVKwyeJkXq4mYI/vIv5ErDZHFqQHVUhyxB1/xuAN8UXUdJT/ughYvyUalOJjDbjccAvz5FtfxvTgVbDprtNYVSCX8XuoGNC8YAwiYQgLslcVPfF75JG7xF2TVqDAr5gF2u4pFhY2N2+i/TFsH3kjYoxHOntct737/qnfc9hUtuB0PKC7iJu4D5MN26nffe5YWHwxykxPWtaYSbRJaMFKS6tY32nhAebpBXsyMpR5nPdsyYgk72xsaeDrJCSbcWeFMeT+UxFsmkwmp6i4Tz7gUmGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by SJ5PPF8B3F23403.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::842) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Thu, 21 May
 2026 05:16:57 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 05:16:57 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng,
 Jason" <jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHc6DwLqeZYev05QEaXLGMqbKy1FbYXy1YAgAAjHwA=
Date: Thu, 21 May 2026 05:16:56 +0000
Message-ID: <MW4PR11MB69362D5B6F8B6BD83102A418A30E2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260521025956.f3zfyphlc5sv6clz@master>
In-Reply-To: <20260521025956.f3zfyphlc5sv6clz@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|SJ5PPF8B3F23403:EE_
x-ms-office365-filtering-correlation-id: 3451c264-b97d-4219-ce03-08deb6f82dcd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|4143699003|56012099003|22082099003|18002099003|11063799006;
x-microsoft-antispam-message-info: /RH+fHbc27FNpdIO/XBdzBvw+WR090m2wnWFWg26XnHO7ABsxyKOJ9lKx0KBZWtGVXaNrAieODLqjNN5iUWjpgroqv3cvWVNPERdCEcke9ySGRZpE6Ag0G24ypgIbEMtD0LYEs2BURgsrQ2Cli4HD8/AzKfBsD2pJXbmO5BGO+OaHEsLO0C1rsxaiappSSEQKW/GS4GHZbwnvnCpXTCk21TujUaZPReNqm+kWKaNN4SnqBPS/jBRbMqkc/k8XESrTvhZgi3FbvO/3sJljUluCgKjFzYfZJEvkT2n4N3jG79GLfJqn56GxmzBPmwEw38/Jt9GvDANnxFHxWppM7SrlhqlOy2+RFWt4XaTvgLBwx+sosuFxo5Qq+zVAmkVW4EOGL4YJwMuS4hi76HKRYRavr4F3PI61d3UW9bxNUdvU6NFh2wisDSg0DsWK3DNj304W7wPCAr2ARLK4Z36e0lsiPQBbu9MsdXkX1A16HD3+Ztt+39t96fsSkJd/8NYlumMjmbFrGZ56iv9KybdqO+CbnTVdM7Shx1FkcTRxLDC/MTpnAqHkR4d8NhaHMnIJ40RtOQWSKK48OId/5ObNhrToClmLyvWWnrij+SQ7dZJfxOGcIF/WMyA2Wo966aO4DYdD5SA+pDcijA4u3KH67p9J7xQaeo0TCkNkYR6KgtEWeuZc5cNObBZAUeaJrypNndl09iRSTMUyHX7o2Ps/QN9aSQbfxmQNSQ6XNWBmUk3jDbAAi4dioCp5t8r2lRqAgf7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(4143699003)(56012099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zPYAyvg5BQA2kHzPSHCJ0rXOB/mfjKVpMEThlu2j5Ik688qAxfTbjKL1pdnQ?=
 =?us-ascii?Q?VBf2XB9JFrW/im2Xhn+r4OTKqWDenPCy+M2C8BDp2/gaFVNemFbovDw05vWj?=
 =?us-ascii?Q?Kp/IkerdI+akSPwSl7l+f4Jf17oN5OLMvvSRJNUjVBLFiOKnMPCA/tFkcLWJ?=
 =?us-ascii?Q?bzqKoYkRIHuiAxCAKy5V89MaQV18wURVV2q3k14Fq/r8RF/16Sn60tDtQmX3?=
 =?us-ascii?Q?ZzZu3o03E7Towv2srqB60rB/OU8sAsE9OjEFZWzSnXjmU5o3Ie31rH6C29Sc?=
 =?us-ascii?Q?D+wUACwHMcEQnWa3Vbf5/ij6bXKeqq5z62OBjNK7DKHUjV6d+LWtg6wtg6Zn?=
 =?us-ascii?Q?sFOphFxtguC9JDr28cp0kPuxJaj2YrRkRnhuvCqSTyrLkrPq5odRhwF0mAGR?=
 =?us-ascii?Q?FKA6Gg8liwmgQKIc+0eNijgEJ3Wkdgu+FzTUxaVUjqDHVl/DxEpVPkG+8p2t?=
 =?us-ascii?Q?cBLvvVE1f7+aw6SKwmnnVHqMSjGkdi71IaFFirDiPcLPZGtV5Ol+jbM1r7ER?=
 =?us-ascii?Q?iW6tic+bWET9a+oP7a23k+BEsd4/dhbJkzcKcNN2jZpL7aWrG+4yn1Eg5jLy?=
 =?us-ascii?Q?GSKXS3dICkebJ/9VLFNKGQ3E2Kz3nJS2m1/WtLUndi0501OVUEU8wIb+uOt5?=
 =?us-ascii?Q?KzCg4vOJLheIljAS6j++iDE/HX6uxa8C963AQt08P980WhcFPeoNzt2UYoch?=
 =?us-ascii?Q?k6zrHtXOt6qRw1KoUW9MqgPISDuJMzZnkDwiLeZQ0mCoQ3U29awO+BRazss7?=
 =?us-ascii?Q?cWdIAI6Z7XzGxpJ3cl15dg4PCxhp/Di3c9KQZEAsnbZTMj7JDfNQbQ0x7nlr?=
 =?us-ascii?Q?dtHRWWtnCrtyKAgfw0KqRDKIVj5NS2T60lEJXS6w5ADwHiTAn7TDPCMN7tTX?=
 =?us-ascii?Q?1FjTDy2Im2ivhLn7FqsaQx701rCqwJy5nEYvNfeqjiwuXS4j0M1DA5HRzEVU?=
 =?us-ascii?Q?rb0H2RXb4lvOY1673UpkmUgEEs/kLbvfLCovpDSzccMUU29VrfaNIzVSRUs7?=
 =?us-ascii?Q?P74JwVoCz/ljhNJxitpH2bCbQQghOEQNCRhbHzZZakM7/bghTP7pBS2UG2nW?=
 =?us-ascii?Q?3C03zEERUCEV7AelpVP/QKPSFDwe6KP0nHgLIYP6O+qbEV6WhgwxKvuXqtD+?=
 =?us-ascii?Q?aC2hRl1DBR+BS+d41gaET9Oizte+O8jiiG0nnIe6ljgsh8MESsMBZ9KA0j9Z?=
 =?us-ascii?Q?slknf7VvUIfv+8tbnKNGvgtl4STNONndXBGs/xfY2vNIHvHBBX9A35BrPfX4?=
 =?us-ascii?Q?oEKMTln49apVGBvxLvG9UBLz8ZDkxuTriCXNicI10tKf/8beSF7xOyGCT1RH?=
 =?us-ascii?Q?hPollEYy0YqagQBm7ncdKnNOuip3A8ssoAkmLpOo0MI354JZUbOq6+umP/nE?=
 =?us-ascii?Q?cvKhDqw360p/ISu1v8UgS9eM+cw4rRz73KUn64hCT2STtCcx+ZSalmKRh9kv?=
 =?us-ascii?Q?KmLRG2IsRb7NxPihyvGXu427egiMq/mg7nFPK0DKVPXUO5FsWkCnYiC17OcE?=
 =?us-ascii?Q?Tmv2LADs/ZcZ1/ovbj2VXssECUIjuXXTg9S8Si5qAOqx5UUf59UcppBm2fsQ?=
 =?us-ascii?Q?vfrofRBPK8ralqH82KQr5TbpA0b3Ce5eG2CULQzauIIoQeKTYPfsXcXf6pNu?=
 =?us-ascii?Q?3M/Yd3xHpWiTwA75dw8I5liUqN7nF+ZpWOrF7rGdaWkd4SZMTB14YPcoESd3?=
 =?us-ascii?Q?6Yfjc4xFbz/1dg7AHmMzq+wn1EjH6G8wNOkUE57Za636Ne1A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: h4P4EffRHEVsYzm5gOWmPYnu9GhjpY3yjJG4Tej7JoCE9Cgjt4a6paN7vjkzR6A5Yigne8j976bihRC0NCxntCuAzUmUril5bXEHkgJYqLRnQBqg4tnYIiIROi0TJnf5WmdNCJx0OZwJPlRm5vAG2u3aWDAepDT5ozV3J4Bt4Rdln/thl1A0QaJS70a1OH6YZZ9XV1PKLDGYlL9bfsqmKDcRYZdzjvfcbnlBqA2QvQNHyEL0uhGIxaSR8wrrzrKDNI/s0GNhHOlV4/F7MMdtsT9xlgF5ETpGD0f7A/IEvmuRVL8Bea6dgjqysBB/ZOH09Tiq8mJFgHmkGAhqmBZPCA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3451c264-b97d-4219-ce03-08deb6f82dcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2026 05:16:56.9578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3rkUqRYtu2IhhskzlvOIMSN1fH6tVT6FzdkLfOFU9xK/jr04xwU0c1APXO+xT0Lfy+XkmRu7r1mWVjjFYvuz2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8B3F23403
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 463691C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: y54qqibpwao79w6wpygrzw1ysgstur8a
X-HE-Tag: 1779340622-208276
X-HE-Meta: U2FsdGVkX1+c7h/0vjL7cHcIwMYetIlLNxz+cY9/XnLZmxsZha40/CGcKwHK9PkXRccjfh89ImeNIP1wyPUKiuJqqg4ZvGtUCZwGVpDPCzaobIIXj+anHfsLxFAxBFMNUifY/b3tvLapfzXXZg99W1i7YTm7jV9APSLdnPN2F+Tr+pNkDR9G3wtcHlT3lRPgypYmKbH90AJmmlNgMXDYWoVEBYZ97uWdixKAUGhbwZrOcpPuOd7GEiU0H/TJ03MhNUk9upf3//G95E3Oym6vz/qcRtMevigJZVhH8EPD80Pe0Kf3JQ/ip6gttfOURC0UGMUvF4/WNMyJcKgXZKhBaOn0RMuVrKWrRVS92pp/vHQOrSusMxHkmn6nCc5Ic7X5iM/QwpLqsk/4TAbPhEnynjfp5HBSJGoZDyDAFltQhi8kACq/o0rsHGqwKIoPvJZliRHocuwC2mW7OFKBLY4vOriQ5rHRQNHoxGezcxayhLs7ryBMvmK7xH1cW/LekNOQplgfc07C9/P9Dsy4KgSUENiIQtTpuKG2MnEKy4YaOvdgJXKl8fZ7+uK4O0gs2HsX5T1vU8QG6qdLgE68jczo+DSG65c58i0hJwEx28exnaMfG5GN3xC6rVMmvw74J3tcG0fvv+x1mKcXu5Qkmu1S9gJUwdD+aCoVYXeTQHV8CLYZRMtfuCbwSr1GW2gr67iRRiDa8NKshpqXvjwcq1zDZ8jApPQsWdmKqU01n1KbxIbU5KurvVz++H5NBJR0/LRczz3DBnJlTnszzWUUisl0CuGo3OmuKwWXnTuqpmLtpGcR/WPXCi90MnS5nUBigNdSAjxxUxyJbyrDsb7YbVDnMwpNEwKi+7GTPTbtrm/EcnSnlH922926ufJAs60xoY+eWkPkCkz8fjM2Wl297/f0jlHTsnj6Z1p6sWYoQWvxxPAWJ2up4VdSUzR6X0sdj5sXznZ1zNvu9joYDYKJ6+V
 MhR1S2Pp
 YSXCZ/wvWmu29dmoSAj6Vx8i6QWt7MwQ4CvRzynhHC485xwJtmcFbUNmbJMDhijAkls4mQCFSVH/Qsq9JxIHuzN7sa1xfdcba/4MioNwvYN4jsWSRZ1ZYhU/q8arF4kkg/31aXDJ4dWhGxwbP4HENhJH4JbF327vSZLtfxRj/l0RPOHiCJ6QEbkA2WDLiFAZSVk04HHHpLJJGBED4GHx65tEpQGaMTAubLI8LjTMy84LXTCxRYhS4aA494D1/AA9E7IQNr4ceuORmBlPyjgDa83lG1VB2Hil+Xdor8x9oSsc8GkPQwVX9o383c98VILYiV1mPqXwU1rpWGKywh4OUUXTDQWTE3DB48Zo3m7HB+wY2Ac287F4Vjt0r7N4oRe/quLx42Rs87lKG9Wi/T3/W9mTG6AtlaIBV2MbbWz3Pa9et8Xid6/ONqodRP8ikzmSZuz5vYV3f3woJlNptDiCqHqRCGoMzRUQuEbQP4bSzD0a0qAfDk+5oCb81IYMcQvUEFqQgcJal968N8xukVn25SKMj/aGMdrIWP02yEUaHxdIzPWFltjN4Z5XZ3gwPCe6jFHsFNWynAYLdBPjr8n8C6ggppTClPHT9x54H+zn5a7qQtmGy+qDjQv6DDqsujAX5RG6Kono3guO/djP+vKTy0iBdpo7nkwzgNArvVK52G7H+oZ3VVy6CKSl/zAkn693ZG5W6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi, Yuan
>=20
> IIRC I haven't reviewed any one of the patch below. We have discussed
> it but not settle down. So it is not proper to add RB by yourself.

Hi Wei

I'm very sorry for adding those tags before receiving your RB.=20
I will remove them and make sure not to send this kind of issue again.

> --
> Wei Yang
> Help you, Help me


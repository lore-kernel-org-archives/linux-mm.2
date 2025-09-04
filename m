Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C327CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 05:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774AB8E0007; Thu,  4 Sep 2025 01:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7C08E0002; Thu,  4 Sep 2025 01:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571448E0007; Thu,  4 Sep 2025 01:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39ECD8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:20:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0DFF11AE33
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:20:50 +0000 (UTC)
X-FDA: 83850418260.27.543C397
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id B8AE940002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:20:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DKrCWTJP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756963247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Uf+17bEZHZMMnk6pBFwOxSU9FiHj/i3uqxxIu+deeOc=;
	b=jjFgdpLySHIqXwWy8h80+vISqYUx1KM8LbUNwkJwHHmxcUopAUB/6yuIJCOK+UdCYPQGPO
	c80tO49dBGyCQCX7xNzYE+mrQ/PnbLDTlQsQt1lXiVLWWN2nDiBUAhHthBVWhwODUpIB+I
	bAA6mZYqQ0/w5mKm/89zhnvb6d/B7Js=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DKrCWTJP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756963247; a=rsa-sha256;
	cv=fail;
	b=rwPk7RB6ksxa+r1X2gmlmXxN4Mxy/bMUoqX/dc4qptpEBSItJoasHu1IsUkMGODbkWUnut
	kTHRJcAb+wOTAnvLXhE0yfIOLPVH8S/LH/iycfr+PC2bMofF7b2vs0A7n7Fq7aDEF6Q08w
	bc45afPvCqRBNmHTS94itRXQof0NQoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756963246; x=1788499246;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RyFXP5NvuKX+wUNZHITKNL/pjGKuumCIz5jlsQ7RcU8=;
  b=DKrCWTJPAjZP2wAloCYc3zoFRBMeeCA2sKKIC2Zv0MgJzTLu8yGQifJ7
   8cAV5Zgldzx/hG4HCl0z/moMz4pniDhQTod05Mrqi2SJ5B2lnrDC6fxmn
   ug50IyZ+pzfvCut6cIs0Q0UV7Ntb7W0rTlexnmsAcOODRO/26sGa6mmvM
   UXo+2TenXkGNcqUTRmhuJ70+gan9YuR3YzKCmQVniUwwkk/MrRM99bgww
   YdQVguFqb2F/DwokapY7nN3gMUncbxFJqWGB8su91geePyy8Qf7nDNcJE
   o6gUlgJm1HDZWRid8CgpJ6NI13DEpLzS7Q7jeTMAq0AJchoiIEl96fZer
   w==;
X-CSE-ConnectionGUID: 631NkG1xR9CuqEdcifNY1Q==
X-CSE-MsgGUID: 9UfhDMqsQ2CrfjB78kEAmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="63116060"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="63116060"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 22:20:44 -0700
X-CSE-ConnectionGUID: 7F1lEJY/SZCrL1963bNwqg==
X-CSE-MsgGUID: LF9Nz5eVSWCbWtdqH8K8eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="172240343"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 22:20:44 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 22:20:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 22:20:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 22:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cs4UaCLsswbJod+hheGIsEEmNjId7qGFBItmuyA2m66J4oZi/yGcKKvgWXoUN0FOgVrgOSlzlBT/dzpBsPNwMfswXMpgZ+p9IJjNKgjJh7DNrUJqGSAaQarSbtBko1UCOqHxUJk45Z2P2uZO4mafXyKngYBs/+wWqqHmcdjpUzkXFZMisbKi73kXsx0/tbxzpH/QNYIsjO/5IGxT4+MrI5YdvWIhBQSFT5xC8aqoRQR5Jd6tVV9ZcL+lIpkJ6/pXQUCaTXBcUDBKGxxrMX9/8OEZmPR/gHwvhsJ7QOWfkwmygmw5WyRrb7O+ysk3bK/t2vNYmHkGVzj+u9W98j52ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uf+17bEZHZMMnk6pBFwOxSU9FiHj/i3uqxxIu+deeOc=;
 b=MuSbQZPRTQVFVuEEb1/VqHi1lTBE55YyyIhKwuP5LP+X+SSDfKH1xd8+b3jamWwOsPWbbmNNoaxf/qipTHP8pTV/i8yHCT6boZ58kMuR873os2TME8kJvLad2nES4kuFeNTBQNSEHP+eX7gkregcrbj25j2TgC9M6A+Bw0x2sPG9eyEEDgSRnrX333MAWUCHuhqm4wO/16Ghxedyu0L5xuPCo97k4KX9XxhL0gKjZTgJzE43Pal/volKZyC1D5KMGfqn8dNT09BiqSOsH+BZcFthIhygn5vZnCOSgvn9LaeSdn16OejT/FGQGfQxv3nSlTUD+CG6najLWFOejZLs8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CO1PR11MB4818.namprd11.prod.outlook.com (2603:10b6:303:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 05:20:41 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 05:20:39 +0000
Date: Thu, 4 Sep 2025 13:20:30 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@suse.cz>, <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [vbabka:slub-percpu-sheaves-v6r2] [maple_tree] 99848157f7:
 WARNING:possible_circular_locking_dependency_detected
Message-ID: <202509041248.b7ece14a-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0184.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::9) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CO1PR11MB4818:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a71a18e-987b-4a39-dda6-08ddeb72c8c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g64Spw7hwo+GSOCK/eCho8z/F8BGg8Ax2HobBmIltDiqyzcS6briCqF+TM0Y?=
 =?us-ascii?Q?k1gSOEe/azUk+Z+O0BPnlQRWd83FjAZMro1V9KvLVFOLr5qOoETrx4oWuAai?=
 =?us-ascii?Q?ZP/przUv/sudl3Z8GJBPwud0i/ryt0/jfDYfGJcFMDFfoLIg1eIJ+v9olRfo?=
 =?us-ascii?Q?mOvKmlX/hs14cSZwDDvQ6+B6S3lthS8SFJXNHMtYAgemxaGHbSKtgjWSUZTp?=
 =?us-ascii?Q?GeCV3fYiEYc0HK9FR8wxoTRV50F0Dsd7B8vXE0P5IyoVv7+0PfkZbLvH9+E3?=
 =?us-ascii?Q?+3j/zMv4kZ3oLIwB7Tlr8dEUbYaJGgmfo9WKlVnZ421NntnKN+A9SbQt5bz8?=
 =?us-ascii?Q?cD7FM3+T0oaS62UuQggKOu+ChPeV2TIdmeF8xGVnnYfgzyXn5pH1UHfCR500?=
 =?us-ascii?Q?TSy8P1epdaUzm7zIdEcYKB5Wvnjs+ZMETaNjuNWk1uNiCBmtzNYoev6Cx5i1?=
 =?us-ascii?Q?qrx/9q1VxJGJT1jYeiuyffJu7qWXjVUGbzYT4VkfT920iWlJw+IBcJNxi5SQ?=
 =?us-ascii?Q?+roYKwHR+qKoKXa75FbkpEup4mW2W++Ka2HJbYM6/LP9KOHJqRZ8w2I4SbG7?=
 =?us-ascii?Q?QW+BjjSMG0Sx6B0bnblMi2x0m2egZ0rYzaq9J1SGoUpfhGQRW5/0E7MJ7y0n?=
 =?us-ascii?Q?eVGpHZVHOTf+MhSdUOmZ9olE6JUaJNCLtvPhiknOR/zgh8CyJ6oaxGp6Cvz5?=
 =?us-ascii?Q?UXS8s1Tt/T7RL8a2SO5wGsokL3zx/T+0RxbUbbSCyxWQq7NmEbBWeDA2ShqK?=
 =?us-ascii?Q?qVLrvDO5xRNxvBdRLgW42QiajiMYArxxcMuHUBd8SN+iDqTxg7cA8h5NzIGo?=
 =?us-ascii?Q?S6gdxvTlxXeAEGuiQUNcp6NFW4UowIT9gjJAM6yAb74KdPUt9m6d2gY4kmNo?=
 =?us-ascii?Q?4m04wB1ruvqoaL5VQ8F9fmCoPGo3I5UTSZDvszSyWm70gBDzd90LT8bvsFLH?=
 =?us-ascii?Q?O5fb33NJsblm8U/AuLaR09ytXeAr1jcRCv0liEd/ISFDshva9PF/mBu8rOkZ?=
 =?us-ascii?Q?fb+4mkH6L7UufBU2EfUmHp2cGKKo/pBTz9MnKnY2y1oVBWIG17S2xzXTTMNF?=
 =?us-ascii?Q?Rpu1K5dh6JX21FmgEgRHVcCc42WCPrgXCZfyXt5CIfPipmMB4eXuEyJXNhxF?=
 =?us-ascii?Q?Fgoo0XDCtN7S5MQLMEQe+nUZdl7+Bkyr1qd/frNlDS5nFOqnfBlMq1xf4kiW?=
 =?us-ascii?Q?I1qmF5TaLqJ1q4PlYQR1YZl7tcYrzcqX8r+DT0HjyLj83b3aD2F7K4yVW1Ys?=
 =?us-ascii?Q?6ff3ziNsPguSNRKZOqNQh89TZpPVuZEWMr7dLHYvt88Gh6V/A8RNCXfNRwSf?=
 =?us-ascii?Q?VADhGt345Mlqj5CVHDmn8LEgwqxlN7nzFcbB4YF7/VXmW2VhBT71FXo+OjpH?=
 =?us-ascii?Q?IFzW+0zwUL16d51cHRikxs6RUMiC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ELx411ZdiSB9Zb30xusdmp/pX6ZO82Z6np6glFU/FJE+4E8i6zopokkztIXA?=
 =?us-ascii?Q?By5jOoNYMjfDzfHiPM2fpo/Ddo9Ev+U7t8p38j6djsizYM6Bb1IMX/KxNZeh?=
 =?us-ascii?Q?lXV6Io2cFm9Xvs0od3FCW0hQUxA7UjQ8ABD8RSqzn+cRqs4FCXAMdnQz3Rvz?=
 =?us-ascii?Q?n9XzVRs78ldmZdfcyl+0mISfas24vXMEO99bvx0iI+nXufjoQSf3tmwJIOtx?=
 =?us-ascii?Q?SHXFTIut260kyov06WrbgYckYA3Evd1eVPqpYQ56PQcahjMR8oERi2XdnjTl?=
 =?us-ascii?Q?OmYDa2SOGHTKMrieQJc73JhORBhkRBJ0r/0kjSxJyiMCY7InvHUJYGtnegL/?=
 =?us-ascii?Q?2jEPmYKebfcpqTDD5LCJt5vnCC93LovS4VQ9Sp2a+QFHafuKZMDGMeAonfjw?=
 =?us-ascii?Q?cV4Ac2u7bsQ0swx9gzSFjGQJPgScPWZbH7FmKgNwjLT6iAIgCpflp7CWjlA0?=
 =?us-ascii?Q?WiP9gC/qSKLLd9gN2F+DisrNWAzI0K249+tyEWjEFNX0dwu9VgfJH4QzrZMH?=
 =?us-ascii?Q?L0IeBH4MkfvMb5R6Fv9qBPxvKE3Q1V8eyYyJwIeNbmdFPPaAQCk80IRkx82V?=
 =?us-ascii?Q?UobjeRC+WXCBfu1H51x0R0R9CetI0xjoF+o/IPaFbGTnzk7xvRvF6BUNIEsc?=
 =?us-ascii?Q?BCtmDnpF6Z1hMb3OXM7qC6hIMKJxzokaQ9pTnQL1RSeFwjqKdePv4As89QVL?=
 =?us-ascii?Q?x15ST/zKZ0Xby7/i29Xnj1uP2cxvqEFVZXQdDczwGQB3NEOaeCq2xdZjw2iD?=
 =?us-ascii?Q?0MMhxCN9UrlgAvYDamuDZVTnyqK7yM5Y/kFd5BfU++Oqb0aiFFJRYDwr1CXG?=
 =?us-ascii?Q?3awLzhVjO/wNARAH46W58vVsn4iNNthfZO8w2IVpb3KOfcxZMfsAOxPdmQl6?=
 =?us-ascii?Q?HG2Tw6UEv9jMF2ogZ4zj9XqfuldS+hk2FR3hKCA99W/WTtndbgQy0BZ0sF28?=
 =?us-ascii?Q?QbugCS/dfO0XtrmCmfX+PxnUJIA5gvqwdMHWgZ4+7uVU23pt0UNC3cvPzRMH?=
 =?us-ascii?Q?Lk01KeieHuvNWtMiH+GnurD/qu64iQf0e/SGkNTfPZMqoXSCl2AsdV+RZLGz?=
 =?us-ascii?Q?McX527oYV2PM+3OgztWo6drf9a2afyeFM2Ne9HQABzfqXMLEPLHL7z1XIjWH?=
 =?us-ascii?Q?HXbvbJT/+cjMvCMdRFvbVlp/XLgKYV+rbyAxyunwrKEcNL/kBIjUQw9ZH7Nt?=
 =?us-ascii?Q?7y+KCx1rjmIjMQLW4pwku3GQb7TNQNLV6Og5rSpTAx5MiVQPGNzeikSTSxBT?=
 =?us-ascii?Q?oF+VLxkPa9iSTcYNjCgbHiSU80R9U3aGr62yY5H9TI8ee6XOUMC+ZeHzp4Vm?=
 =?us-ascii?Q?0PDaAaQqIgA8nTQInNxBz2uF+NbvHeSr1UfbHgZTn7gg1Zpoa1xYQ87vGciN?=
 =?us-ascii?Q?xd/ZeqEtyjGoIa4emGzxcfFalM5zKzuI41ZQlLukipKzUvbwl9C4CWpRKOPn?=
 =?us-ascii?Q?1fWSGxWfjVN/vml8VxibNI+lIJTQebPMAz4dlNXGEZQY5bLxMxBMSlY1S7os?=
 =?us-ascii?Q?zpgqC2IYCjO/Idl549kaDVqm+fGHxfLMH6ItP5hsnCV2ya+a+hVPOKi/Fv5n?=
 =?us-ascii?Q?J5hb8nUQlkPPvAMvNlVb4Eal/8VnrivWNly0WYrAwS+l66//oFgRkslO0EYq?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a71a18e-987b-4a39-dda6-08ddeb72c8c2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 05:20:39.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKD69uvrkm+bhsPw+Dad7tfi4RSC7ugVr6x7u2IV2q8Sp/5p9kWA+gInQ4PCorVx/yYrwglc8lMuPrEe8cWjPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4818
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8AE940002
X-Stat-Signature: mhjrwtap6wmu9u593hf65sszuhsnjunh
X-Rspam-User: 
X-HE-Tag: 1756963246-312090
X-HE-Meta: U2FsdGVkX18BgL9T/lON8/CxPayfOAC9FgLjgChoOQH47qz2Iuf+6A5DnWSM2ChvCLUBByUf/r/Ay8/yT0beM4mF0nZv6hjaaqdsHrMAmh5lKIJGlKgr2FScy06TRVaG2mQB4uh3rWf3JuBD+5VOLHosH2PtBVahvbAi952Jq09XEMBKovI/O9yf5brVjq0YCIMZc6/91ow+5VyFw3IQS57epg0zhPk8ArxhGyKmFceYoMUnS7G/YzsqU/IKXkuRNUhxN1xncBjR141cPOx2amHhGpK7JwRMnqKiyeKeaRE48qAFza8PRCoft6tbMDC+Ur+REfqOHhrHXNi8pBmB2kckI+FJXS9dkhOj2WTlKVz0lsb1SAE8BnVXRDqN9D2iU+8haED9Anu1nVg1KBUjRLl0fq+vTRk87IfEJtY9CFWQO3ToG/wIhuQfEVDBPvMcj3CEe8YWq0qO9Aj/T+OiOrdD0kN/MzYan2tX5IcyZ+1pLPJuCfdkMv62LiXucYVteTSfGDO0GGcInW8Ktux2jLnKHxWbDEVZtRn/idqxUDRBsqr/kpH1kkXrJD+gCs+eEOMxsLdVITNq3qdLuiKYqShgMLHyPoVfDnv6vsshqXDj2ZAEaWldPqu3V70W+ANB1yUBh0sCJffp07D2onxgze/kpw3nxs1wT3QnQZ3tBHodDCMlfEBdNJOoheUL/eIUzTxlHd5eWpDysq076uTdt/ipH+Z2Ppx/5NnYjmxQl8EUuGRGVMFK6ob7XBEz/lhM2WNByMBDTpM01uKSqERbkbo5uui/Vwyy7lqLtNuNy4fWj6m3Uqr8YEP/RooxNrjUnVwpCaFR3DdmrSlY9outctFUK3YWhOXH6DsqVqluBVDZmWS+PuMVRdiDzTtT7Ct3E338mh00upULkNFGZghk6V8w9+y102HRrpIHHMn05Ljoygw8yNJui8kV+ribMcP5YU2Ls26DHBP3DYfhGC7
 Yw0ON0/y
 maET2vEWtUoWSNruQsHB2WPWgrCR2K4SKOIcxpDciMvRf4JJ4ANmCYRNB5V+XgJw0k5jf87YVNGtraOXs66yY8hBTund+kqk4hapm+vF+lmetAvBEellnCGjyG1lNp1q8gQrMf2VJY4DVKei3h1Lv6DftB2n+izqgJLGA2dSlvqU2CaGlsOWGTrMRdEWMXHH3iJaS1kWsOMviYjo59e+AA8VjaVzMbtdkqLpx82MSWbn0qSzCL0Ao/HNICD1wL3WGXgPUT2KO07Ux+k4GZC/JUZkHI+yO5FCFBYiD5QlWcg/nOvBwAcAEVXi8epOOPpJBn7GJYMhQRv0dvnNthO8os5tSUCxOpbVWI39FsEAEhcd07aHj6Pc/+85X9QPFMvhMHvu6hbv6PRttypioNgfObdcmVKANYlUMeU4n9G5Vo0zqu5rvqbwiODf8+jCi7nodF4dcotXxYb+KCgdAgcEUM+ubC3BhOu1MuGpIe8B0XftkVCTBeIZjNzZdernyypNtJI+dEjdZarZrwCQrvgc2nhb3+e7uhFzur9JVUWYnRr1uZertZiJp8NnlfhCo8lAbyqK3Hy55cqfvPfAqMGB0dRNJjnQuiBuZhRjNH6ekFf72RtcRp06O0YnAQc/VEESnsEDcfRWZrabwjdsVEs2fS4k3p7Ah7FD9dF9ZmwwfnjsJOYGJ6e94WomVYol6DC9qHEIK8nnxbviNWX7ki0/NLg3regClIg4ixmgSPDTY1l3a+lk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:possible_circular_locking_dependency_detected" on:

commit: 99848157f71c03ca5e975b0e686def1d66e8b19f ("maple_tree: Sheaf conversion")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git slub-percpu-sheaves-v6r2

in testcase: rcuscale
version: 
with following parameters:

	runtime: 300s
	scale_type: rcu



config: x86_64-randconfig-075-20250831
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509041248.b7ece14a-lkp@intel.com


[   17.413963][   T74] WARNING: possible circular locking dependency detected
[   17.414491][   T74] 6.17.0-rc3-00017-g99848157f71c #1 Not tainted
[   17.414936][   T74] ------------------------------------------------------
[   17.415483][   T74] systemd-cryptse/74 is trying to acquire lock:
[ 17.415965][ T74] ffffffffb02789c0 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0xd5/0x23d 
[   17.416782][   T74]
[   17.416782][   T74] but task is already holding lock:
[ 17.417298][ T74] ffff88812925dbf8 (&mapping->i_mmap_rwsem){++++}-{4:4}, at: vma_prepare (mm/vma.c:296) 
[   17.418021][   T74]
[   17.418021][   T74] which lock already depends on the new lock.
[   17.418021][   T74]
[   17.418779][   T74]
[   17.418779][   T74] the existing dependency chain (in reverse order) is:
[   17.419530][   T74]
[   17.419530][   T74] -> #1 (&mapping->i_mmap_rwsem){++++}-{4:4}:
[ 17.420152][ T74] validate_chain (kernel/locking/lockdep.c:3285 kernel/locking/lockdep.c:3908) 
[ 17.420562][ T74] __lock_acquire (kernel/locking/lockdep.c:5237) 
[ 17.420968][ T74] lock_acquire (kernel/locking/lockdep.c:470 kernel/locking/lockdep.c:5870) 
[ 17.421364][ T74] down_write (kernel/locking/rwsem.c:1315 kernel/locking/rwsem.c:1326 kernel/locking/rwsem.c:1591) 
[ 17.421735][ T74] dma_resv_lockdep (include/linux/fs.h:557 drivers/dma-buf/dma-resv.c:798) 
[ 17.422159][ T74] do_one_initcall (init/main.c:1269) 
[ 17.422573][ T74] do_initcalls (init/main.c:1330 init/main.c:1347) 
[ 17.423031][ T74] kernel_init_freeable (init/main.c:1583) 
[ 17.423481][ T74] kernel_init (init/main.c:1471) 
[ 17.423840][ T74] ret_from_fork (arch/x86/kernel/process.c:154) 
[ 17.424211][ T74] ret_from_fork_asm (arch/x86/entry/entry_64.S:258) 
[   17.424612][   T74]
[   17.424612][   T74] -> #0 (fs_reclaim){+.+.}-{0:0}:
[ 17.425162][ T74] check_noncircular (kernel/locking/lockdep.c:2179) 
[ 17.425561][ T74] check_prev_add (kernel/locking/lockdep.c:3166) 
[ 17.425954][ T74] validate_chain (kernel/locking/lockdep.c:3285 kernel/locking/lockdep.c:3908) 
[ 17.426681][ T74] __lock_acquire (kernel/locking/lockdep.c:5237) 
[ 17.427085][ T74] lock_acquire (kernel/locking/lockdep.c:470 kernel/locking/lockdep.c:5870) 
[ 17.427458][ T74] __fs_reclaim_acquire (mm/page_alloc.c:4235) 
[ 17.427840][ T74] prepare_alloc_pages+0xd5/0x23d 
[ 17.428255][ T74] __alloc_frozen_pages_noprof (mm/page_alloc.c:5137) 
[ 17.428658][ T74] alloc_slab_page (mm/slub.c:2990) 
[ 17.428987][ T74] allocate_slab (mm/slub.c:3155) 
[ 17.429316][ T74] ___slab_alloc (mm/slub.c:4406 (discriminator 3)) 
[ 17.429757][ T74] __kmem_cache_alloc_bulk (mm/slub.c:6757) 
[ 17.430188][ T74] refill_sheaf (mm/slub.c:2571) 
[ 17.430554][ T74] kmem_cache_return_sheaf (mm/slub.c:5174 (discriminator 1)) 
[ 17.430998][ T74] mas_destroy (lib/maple_tree.c:5384) 
[ 17.431366][ T74] mas_store_prealloc (lib/maple_tree.c:5292 (discriminator 4)) 
[ 17.431789][ T74] commit_merge (mm/vma.c:767) 
[ 17.432172][ T74] vma_expand (mm/vma.c:1158) 
[ 17.432530][ T74] vma_merge_new_range (mm/vma.c:1095 (discriminator 1)) 
[ 17.433237][ T74] __mmap_region (mm/vma.c:2664) 
[ 17.433621][ T74] mmap_region (mm/vma.c:2739) 
[ 17.433987][ T74] do_mmap (mm/mmap.c:559) 
[ 17.434342][ T74] vm_mmap_pgoff (mm/util.c:582) 
[ 17.434736][ T74] ksys_mmap_pgoff (mm/mmap.c:606) 
[ 17.435128][ T74] do_int80_emulation (arch/x86/entry/syscall_32.c:83 arch/x86/entry/syscall_32.c:172) 
[ 17.435557][ T74] asm_int80_emulation (arch/x86/include/asm/idtentry.h:626) 
[   17.436031][   T74]
[   17.436031][   T74] other info that might help us debug this:
[   17.436031][   T74]
[   17.436803][   T74]  Possible unsafe locking scenario:
[   17.436803][   T74]
[   17.437381][   T74]        CPU0                    CPU1
[   17.437800][   T74]        ----                    ----
[   17.438213][   T74]   lock(&mapping->i_mmap_rwsem);
[   17.438614][   T74]                                lock(fs_reclaim);
[   17.439118][   T74]                                lock(&mapping->i_mmap_rwsem);
[   17.439737][   T74]   lock(fs_reclaim);
[   17.440045][   T74]
[   17.440045][   T74]  *** DEADLOCK ***
[   17.440045][   T74]
[   17.440668][   T74] 2 locks held by systemd-cryptse/74:
[ 17.441085][ T74] #0: ffff88813b6a9d48 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff (include/linux/mmap_lock.h:415 mm/util.c:578) 
[ 17.441777][ T74] #1: ffff88812925dbf8 (&mapping->i_mmap_rwsem){++++}-{4:4}, at: vma_prepare (mm/vma.c:296) 
[   17.442517][   T74]
[   17.442517][   T74] stack backtrace:
[   17.443019][   T74] CPU: 0 UID: 0 PID: 74 Comm: systemd-cryptse Not tainted 6.17.0-rc3-00017-g99848157f71c #1 PREEMPT(full)
[   17.443875][   T74] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   17.444619][   T74] Call Trace:
[   17.444877][   T74]  <TASK>
[ 17.445101][ T74] print_circular_bug (kernel/locking/lockdep.c:2046) 
[ 17.445469][ T74] check_noncircular (kernel/locking/lockdep.c:2179) 
[ 17.445823][ T74] ? add_chain_block (kernel/locking/lockdep.c:3442) 
[ 17.446245][ T74] check_prev_add (kernel/locking/lockdep.c:3166) 
[ 17.446608][ T74] validate_chain (kernel/locking/lockdep.c:3285 kernel/locking/lockdep.c:3908) 
[ 17.446960][ T74] __lock_acquire (kernel/locking/lockdep.c:5237) 
[ 17.447332][ T74] ? prepare_alloc_pages+0xd5/0x23d 
[ 17.447831][ T74] lock_acquire (kernel/locking/lockdep.c:470 kernel/locking/lockdep.c:5870) 
[ 17.448188][ T74] ? prepare_alloc_pages+0xd5/0x23d 
[ 17.448649][ T74] ? lookup_chain_cache (kernel/locking/lockdep.c:3801 (discriminator 1)) 
[ 17.449018][ T74] __fs_reclaim_acquire (mm/page_alloc.c:4235) 
[ 17.449456][ T74] ? prepare_alloc_pages+0xd5/0x23d 
[ 17.449923][ T74] prepare_alloc_pages+0xd5/0x23d 
[ 17.450400][ T74] __alloc_frozen_pages_noprof (mm/page_alloc.c:5137) 
[ 17.450855][ T74] ? __alloc_pages_slowpath+0xa4d/0xa4d 
[ 17.451376][ T74] ? lock_is_held_type (kernel/locking/lockdep.c:5601 kernel/locking/lockdep.c:5940) 
[ 17.451778][ T74] ? find_held_lock (kernel/locking/lockdep.c:5350) 
[ 17.452142][ T74] ? mark_lock (kernel/locking/lockdep.c:4731 (discriminator 3)) 
[ 17.452492][ T74] alloc_slab_page (mm/slub.c:2990) 
[ 17.452912][ T74] allocate_slab (mm/slub.c:3155) 
[ 17.453271][ T74] ___slab_alloc (mm/slub.c:4406 (discriminator 3)) 
[ 17.453601][ T74] ? lock_acquire (kernel/locking/lockdep.c:470 kernel/locking/lockdep.c:5870) 
[ 17.453949][ T74] ? refill_sheaf (mm/slub.c:2571) 
[ 17.454278][ T74] ? mark_lock (kernel/locking/lockdep.c:4731 (discriminator 3)) 
[ 17.454611][ T74] ? mark_held_locks (kernel/locking/lockdep.c:4325) 
[ 17.454987][ T74] __kmem_cache_alloc_bulk (mm/slub.c:6757) 
[ 17.455387][ T74] refill_sheaf (mm/slub.c:2571) 
[ 17.455731][ T74] kmem_cache_return_sheaf (mm/slub.c:5174 (discriminator 1)) 
[ 17.456221][ T74] mas_destroy (lib/maple_tree.c:5384) 
[ 17.456575][ T74] mas_store_prealloc (lib/maple_tree.c:5292 (discriminator 4)) 
[ 17.456968][ T74] ? mas_store (lib/maple_tree.c:5292) 
[ 17.457303][ T74] ? __mas_set_range (include/linux/maple_tree.h:755 (discriminator 20)) 
[ 17.457685][ T74] commit_merge (mm/vma.c:767) 
[ 17.458038][ T74] ? vma_complete (mm/vma.c:731) 
[ 17.458384][ T74] ? lock_is_held_type (kernel/locking/lockdep.c:5601 kernel/locking/lockdep.c:5940) 
[ 17.458757][ T74] vma_expand (mm/vma.c:1158) 
[ 17.459090][ T74] ? unmap_region (mm/vma.c:1121) 
[ 17.459519][ T74] ? can_vma_merge_right (mm/vma.c:197 mm/vma.c:440) 
[ 17.459890][ T74] vma_merge_new_range (mm/vma.c:1095 (discriminator 1)) 
[ 17.460253][ T74] __mmap_region (mm/vma.c:2664) 
[ 17.460604][ T74] ? __mmap_new_vma (mm/vma.c:2641) 
[ 17.460977][ T74] ? inc_stack_record_count (include/linux/refcount.h:290 include/linux/refcount.h:312 mm/page_owner.c:216) 
[ 17.461414][ T74] ? lock_is_held_type (kernel/locking/lockdep.c:5601 kernel/locking/lockdep.c:5940) 
[ 17.461808][ T74] ? mas_prev_slot (lib/maple_tree.c:4369) 
[ 17.462190][ T74] ? mas_prev_slot (lib/maple_tree.c:5664) 
[ 17.462586][ T74] ? lock_is_held_type (kernel/locking/lockdep.c:5601 kernel/locking/lockdep.c:5940) 
[ 17.463001][ T74] mmap_region (mm/vma.c:2739) 
[ 17.463353][ T74] ? generic_file_readonly_mmap (mm/filemap.c:3852) 
[ 17.463779][ T74] do_mmap (mm/mmap.c:559) 
[ 17.464082][ T74] ? __get_unmapped_area (mm/mmap.c:339) 
[ 17.464468][ T74] ? tracer_preempt_on (kernel/trace/trace_irqsoff.c:689) 
[ 17.464878][ T74] vm_mmap_pgoff (mm/util.c:582) 
[ 17.465244][ T74] ? randomize_page (mm/util.c:568) 
[ 17.465615][ T74] ksys_mmap_pgoff (mm/mmap.c:606) 
[ 17.466035][ T74] do_int80_emulation (arch/x86/entry/syscall_32.c:83 arch/x86/entry/syscall_32.c:172) 
[ 17.466429][ T74] asm_int80_emulation (arch/x86/include/asm/idtentry.h:626) 
[   17.466827][   T74] RIP: 0023:0xf7f95cb0
[ 17.467133][ T74] Code: 4c 24 34 89 44 24 0c 8b 44 24 44 8b 54 24 38 8b 74 24 3c 8b 7c 24 40 a9 ff 0f 00 00 75 1c c1 e8 0c 89 c5 b8 c0 00 00 00 cd 80 <3d> 00 f0 ff ff 77 21 83 c4 1c 5b 5e 5f 5d c3 90 83 c4 1c b8 ea ff
All code
========
   0:	4c 24 34             	rex.WR and $0x34,%al
   3:	89 44 24 0c          	mov    %eax,0xc(%rsp)
   7:	8b 44 24 44          	mov    0x44(%rsp),%eax
   b:	8b 54 24 38          	mov    0x38(%rsp),%edx
   f:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  13:	8b 7c 24 40          	mov    0x40(%rsp),%edi
  17:	a9 ff 0f 00 00       	test   $0xfff,%eax
  1c:	75 1c                	jne    0x3a
  1e:	c1 e8 0c             	shr    $0xc,%eax
  21:	89 c5                	mov    %eax,%ebp
  23:	b8 c0 00 00 00       	mov    $0xc0,%eax
  28:	cd 80                	int    $0x80
  2a:*	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax		<-- trapping instruction
  2f:	77 21                	ja     0x52


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250904/202509041248.b7ece14a-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



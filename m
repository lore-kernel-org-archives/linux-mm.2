Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E430BCD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3541F8E0009; Wed, 12 Nov 2025 20:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304F58E0002; Wed, 12 Nov 2025 20:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA348E0009; Wed, 12 Nov 2025 20:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5CF8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:37:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95C054CF3B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:37:27 +0000 (UTC)
X-FDA: 84103871334.21.D970534
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C10920007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:37:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fgZBJzN1;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of adam.c.preble@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762997844; a=rsa-sha256;
	cv=pass;
	b=sIAgeu+nC0vJhbyHSGFd8JyTeBiOulu0OviFSeojRmjRySuSscCBVoE4FMRqXei9Ib+Ai4
	lGwYJCRWS2uZgAuYUCiSVhusIwrQrI4N4sjHZGqiOk5Udzgv46m95vCuKpeEJpzb9/bNAn
	r7b75KBEi3DeamBeT/umbv0GQex9MDY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fgZBJzN1;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of adam.c.preble@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762997844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/m8RtPtPvC0eS5Xcp12M4mb+vuJCNDYG7aGaGZ/pcR0=;
	b=zE+arIikG7MAN84Gh7/wUpvMd163YMm2nLMxLH5UP8zYEHRuLqz83tc2A/gZ+0yS2U4VU3
	oWDfF1lPRFrWdX/nxj3IiG9M8KC3D9hTng/TMmjzzymjMveODmioPm7BAkrQ3xUSB2TM/O
	+QXYEi/TCPBLtuZdMwXowKG41Lq+hxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762997843; x=1794533843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zaico/NVexc0Yq7KY7q+4jIpFGkmC9QfZ2Z2k7r7vr4=;
  b=fgZBJzN1ICFBpXkN8IipEZ2r1GLcE94otrj7alBcwp0+4O2M1onRO5Sq
   9OIP6bOyLLSF5pkcW3qS24zDljjAPj3+0q7Uy21QZ81VIvrS3NgK1LVa8
   kG1wZUzAYsU1bp6megahdcTVQdiRK5f95r08Zv55wCUhWsxdN1NzaPcal
   H2yy2oYJFuXxPani+N50QUA04i4UnvQKNHsoHJ2z8sIlQyIlbUQoQZVEH
   VIXtyiT0PrMCvu/udeoa9gA8xmefKN8vZuUz5edx0ru6QFsfiPfBUMWpi
   8CAyDvhmKe8pkUwYdnQLaMY9WVp4/LTOoZWfPUmv5BVeSZG95TQ1HCJH2
   w==;
X-CSE-ConnectionGUID: LYGZjBbeSGW2XEkRwq/QbQ==
X-CSE-MsgGUID: /0ECGloHTOyPrG2dZUFupg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75684413"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="75684413"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:37:21 -0800
X-CSE-ConnectionGUID: Q6vOOHKvSmyUjyOiObkO7A==
X-CSE-MsgGUID: aqj5+qXmQVaLdwOhGkqmoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189378329"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:37:20 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:37:21 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 17:37:21 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:37:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ew33szi21K74u72tP/KIBaJvXZO/pzVUBB5GSPmwopZxAGp6GGgLvOQPxLws4wuQjW4mI8IWDCB2+h7ZAfbdqQTmeM8+zVHwWCm6/gFTe+hLbhKcdpRqWTgbXhCJEDhEFD+Zx7KfPJrBf7JRBcthHiCG+YH1Htk4RQC6W1aHvDiBuWgTz4KH1jlb0tZqp8M3KTNfs0y6avMO38DWR82OraCV+oW5HHj6SBHkQGkkTMQHjuTH7QDH7T0+iod7qXZ384RNXgMvgLdNDsp9/Zb9ryiYH4LRSVyqghNxkgv8V9EIKUF6/7q45aeBgs09jva/F+P85DxFeAvflXP461Objg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/m8RtPtPvC0eS5Xcp12M4mb+vuJCNDYG7aGaGZ/pcR0=;
 b=PdaiOgVxgdSseZAQYahwLWxOH+GJF2nAf8h2yc15vXDi5BSYg1vCN5AEutW3/19DvVk2oVixGXkvL+K5+5GeE5vRktfx+LuRyU70pQ9xJ5rdn4Bq7WQtGsjn1aNtpDvRlppVqGzMmzJ/pSv/e3kFDn/iSfnAPgJxWKX+lFcjs9k50Bd+gtOXdNMfdnE/ytxO/ABJg7/IwubH+TXoNGpoOPk2r/NScSiF7YXZKU5GcTT94H33EkpO4EvM4511FNidpy9790XhjOIBqZwPd+BTZeh8VF1QU+pq7GU6nXofCNptYKoYQchOsHfA2PyIWnLZJ2ApskuLROpalZimcL1oKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6523.namprd11.prod.outlook.com (2603:10b6:510:211::10)
 by CH3PR11MB7392.namprd11.prod.outlook.com (2603:10b6:610:145::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 01:37:11 +0000
Received: from PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547]) by PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:37:11 +0000
From: "Preble, Adam C" <adam.c.preble@intel.com>
To: Lance Yang <lance.yang@linux.dev>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Lance Yang
	<ioworker0@gmail.com>
Subject: RE: Accounting for vmap_area object growth when kmemleak doesn't
 notice any leaks
Thread-Topic: Accounting for vmap_area object growth when kmemleak doesn't
 notice any leaks
Thread-Index: AdxKDzYkrd+pscpNQYqNN7VNL5I8ngAM5uAAAn6bjmA=
Date: Thu, 13 Nov 2025 01:37:11 +0000
Message-ID: <PH7PR11MB65239FC7763E954D4AA828A5A9CDA@PH7PR11MB6523.namprd11.prod.outlook.com>
References: <PH7PR11MB6523C5200943207E879FB5CAA9F8A@PH7PR11MB6523.namprd11.prod.outlook.com>
 <20251031084616.64054-1-lance.yang@linux.dev>
In-Reply-To: <20251031084616.64054-1-lance.yang@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6523:EE_|CH3PR11MB7392:EE_
x-ms-office365-filtering-correlation-id: 55bfcc68-1022-4cf8-752a-08de22552a5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?I7Hla6fio0B64jUBvatAxpmKlMreWgSZ869xt88hbUIjOIgn1w3b73lvlEaK?=
 =?us-ascii?Q?1KXc80pO9e4IlB6L7FLubJIgF+q4XGAG4pFnH4omF74IvzvCGkLc+d/yeiwp?=
 =?us-ascii?Q?CdJnlXwEInOs+NLlekz3Dj2iBoieGbX5kQsNVY1j7HzCKl2zvXE+Z9ARkeHV?=
 =?us-ascii?Q?37I69jD4MFDrjz5b51HlsUoql2Bba+xp1GVXKUtRoEXi809r84HoOOPtWz4q?=
 =?us-ascii?Q?vKeOEwkmH0THACf1uOqrDCsckcLDAKDkNg9OcRF1O1nJPUkoBf5VJJPBXWOj?=
 =?us-ascii?Q?+BYD3tR7V0wVttncuYVBZpo0c7fdODMgl+PRGvUzEZUF6LtTugNtZlrTJHww?=
 =?us-ascii?Q?YpFltnBWnx1gAqvLFo5YDOmJzc25GiPQAQbUtdqt9687RMH2T1yan3B/OrVK?=
 =?us-ascii?Q?NX+jWjqVqiz0myQRcqdYJEdHdc9bYTJYLuIOlTMf32e1352Yeam3nHoYszWq?=
 =?us-ascii?Q?wZjITa7HlKp/5Em3iYHg3yHIQRY/eT6TBT3c/skp7lXdUt5txiFM35qbU4p5?=
 =?us-ascii?Q?HKGsUD6YLg5Y0ZVIK8HqcAuCX96TwlfLDizt0/rE8ml4H28mLuzsCz1o3676?=
 =?us-ascii?Q?2AP7cxd2CvwSweqf3Vwiqlktqh52ZCtF9GIo40EF9QFQGMTLnVPcWv3X5E4Z?=
 =?us-ascii?Q?vZHDeo2F7irmefe8GBT1t//KX9/qT9wOtguCTFAHQMW7cBODvIQrp9vqp6/O?=
 =?us-ascii?Q?hZByzQkzYAoQKSvikE/OG8LwGjxjb1QM9TYodKT2hgmnDTll9CmLsjeNOuFS?=
 =?us-ascii?Q?OiAS5lJPanrRNLtuzT8YDOK241CFhKzl0xJGUz2Lf+BrEP1vP4WWyPaIsdfA?=
 =?us-ascii?Q?1uhYTB6iOPar876pzJvKPSI2yem9UoR7h+IrO/jsdq+ZA1v6NTl4/WoFjzz+?=
 =?us-ascii?Q?Jyr+rAcCBkAoxDLfkbzz4nfY2QpXe2UJciV4SeCGtF1l1U3x4XRZCm08wrdc?=
 =?us-ascii?Q?AkRns6Qs6I8fW7wM638YgczaOaT+U3i1K2022PrvgNA1F7U2l2SQb04FldUo?=
 =?us-ascii?Q?hBj1teR3fIqkUIXNgVSuxyBQGRSA+5DAA36EmP7D0BWRic0C9I+akyr4sjJT?=
 =?us-ascii?Q?ErMIEI/lZNGRznFM4TSEnidYLXPLoccX7J9SdlwN67+DWFBxWhMEMZs0fuzx?=
 =?us-ascii?Q?hZXpaiG8ovS5kXO23WLR3GK2gyMH6u57vgyIvgrougbd+WWDzEsppNwO7Czn?=
 =?us-ascii?Q?ygexemkC3V+5gkj8gfMg0fDXRHwHbdQ+uRPffENkDmUQK3hSPcpbwrmWVipX?=
 =?us-ascii?Q?ysgo69v7nW2wAUzcIsHzw/SO0EVQWg89EF0XWthqf0A2WX+p9Bo3xz4D1c00?=
 =?us-ascii?Q?YhUS592x/RN7Yp6vEZQpmgrxzXs+ZaAAA08nH+noOf814u4TXTl34FcpvzyS?=
 =?us-ascii?Q?8XzZP1TXBLLOLiONjoJ9/IhpV0euxGzaHquka4qgSBB1LxpdostTxYZGXOdg?=
 =?us-ascii?Q?BuFWlXY6m5aBR5+fykIDi43CyC8xt7ZXeKcK7+gxojyze3kL4JXAOyHl6F9O?=
 =?us-ascii?Q?x4AJ5MECaQi7X0E6d20HbcFEuVgHn3vZYW7L?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+KKzyfzfdcsu5DXHToaEVZDJasXPBGZ6/2HPp4YSikE4129pY59EtwkRh453?=
 =?us-ascii?Q?KNor/vePudcjHZjCMS6tzetIaPzQiZAMtlwOhFxkwXZCCkqRBbbfN4/DEhGW?=
 =?us-ascii?Q?sDpfYRO5CyNKkKQWRAY1j5AFDk53iwfsHP+0pppY5JTlZMdRI8aUv6lDvnWT?=
 =?us-ascii?Q?+/E0tPpQySR/6/EtVmVqb98HxwHi9aI2i+ZseD1oaqTieijljhtC5yVR+jUj?=
 =?us-ascii?Q?MOOe0msQ74ZJB1XflzD34/NRFkDNO6NpgBV1rZzr9kQX4jhQ28eQYhnz8CZK?=
 =?us-ascii?Q?YhLan8OU+GRjsQinCqT6gu/wmOb2wRLfRU+2qLiWb/N5gnK/o0e+l+QPM8Am?=
 =?us-ascii?Q?Q0s0kPtztQc7Jz0Nyv4lnmbFnoKEq8IFdSiQCnZmIpcRHojMYo0jSMZHdy5p?=
 =?us-ascii?Q?yh1bfnzDNdXUtvty08Y7usPQupiIWEJthZG+acbOt7Qp+1K1BdlZ4vgrLV2p?=
 =?us-ascii?Q?20/jMql4GiCJ80CbLQC2D5CFA7vXJRlz0vH+tyq7Q5vaATRjetMnXSbLaJkU?=
 =?us-ascii?Q?DEyOC8mbV8oSZWaPHUXz2gv+ucouZk/DspUemLbe7RgHoTuCZOHicnVzZSQX?=
 =?us-ascii?Q?SD9nMzA17ymGA7FT9rIobFQJ6PJX9axott4iYUpvNSaw0Psf7q0dhMTBCN5E?=
 =?us-ascii?Q?SAB4W8aJpTtCJR9h91LCfphrpbGfFwSpCc+H+WjsfaKyPT6IypOjVCYOMIH2?=
 =?us-ascii?Q?9LLZAhVei8cTdmjeobl6H7dbIQYynwTTQVksKeJEUt4d9udSWoXLyPk9LZcR?=
 =?us-ascii?Q?GNOApn6zslqViqnWF10vNz0IaiIvIaMkx5xUgyJAlEUCnZuG5l+gffV0DvNx?=
 =?us-ascii?Q?YbwgInXFqQp6CDf8ekftok1nufazt419JnAQjBmBU4qB0ooh5CNVWDMoSCIs?=
 =?us-ascii?Q?l1R53zoZe7IBAkWuBlYeHTUpgr2qK6pFXBQEXPJEJKfug4bzzSjEJqNC+4QX?=
 =?us-ascii?Q?u1DiZ0E3AChWF4jYO6+wfmIs3qoGz3MgE1rcXZRi/+Qkxu/YnXA7kpQplZN4?=
 =?us-ascii?Q?Y9DUzeWW9oezj4C7DzsebBDWGBP26krb+3waDmtC/J6Zw3v9085i2IyQWZgf?=
 =?us-ascii?Q?J3YV76v5uk3rNkDT9RvwHX8iTM/07P6ZfNMDdTw+DauOTHEYE6VF1+r8QXoJ?=
 =?us-ascii?Q?0ak8pNSAdeY23fULivxlkIKUlZy8hRHRYqALy33Yo0BLpVjpU+lf1u6McOwr?=
 =?us-ascii?Q?qFF3e59VsygitF0KiqPi7m96C9A5enr/gAjml6bOo5uhB5y23QFtJRtwYsSC?=
 =?us-ascii?Q?GgVSQRHfF5bVqGgygRrGiDKDr3vghtVlHvvhyyaIeId/p5aEYs7OYKGQAjro?=
 =?us-ascii?Q?uopSMWcc32iHXHx7dHA5XWX6xhaEb9PsBdDfrFYJzGXPDKUTff5XejBuk+7R?=
 =?us-ascii?Q?Mi7yk430iDE1ISAGF6P39IqGDsSZ94TUICxWQwDwKLqK4jvQcaDHuCMvvVGq?=
 =?us-ascii?Q?t9ZFLtuafepjd/T3DYdyoFOW9Dapbhx4mojpq3u9Had7N27k3J/5L2WH5qJ8?=
 =?us-ascii?Q?1WWvmYoWNWh8LmWk5NtiWZe/kLCGhRvlUlB20Lnax9/Nssk9GGA2yuI1Xlc+?=
 =?us-ascii?Q?uqWsnN7CufVp5MQfMKedMVxrNHVbb3HD4E3Zao+q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bfcc68-1022-4cf8-752a-08de22552a5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 01:37:11.1225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xmo5t8UhVQClRCeixyvcZ0cq6x3BLhL3OGUc6dY/fLL+ahLv25p8kRZHWdIrM/2WpoesVNCGLmM0QjPtL4pjSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7392
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C10920007
X-Stat-Signature: auhzwhtbwnk1zozm6ps4krbek81i7hci
X-HE-Tag: 1762997843-82103
X-HE-Meta: U2FsdGVkX1/YKztEx4Jkr6pmRsqAxUsyYHiZTqcpakdLqvLu4eS0VU+NsBMW2c0SwVnYVLLbCOVkKvOfvszFb8uCJ/PfJfTrSVe7eqHUsiVHxDIT9j5EOiJLHqfdpPcZcZ2JIrS3aqqZ8PskTXqMiVFzFWpYdX7GMa5/5LE2aAsHdhe5sTaAXlBSgkwjkEhr7Fvvt37l+k8pGVRs+nU3hZknfNPpToxWGSIZ5IXzog1heJk+kEL4pFVWbSWxJjp6l5xA3nHW+1W2Jz34+E/tnKNFQyGWoi/wekn6nMnb7rgcasoLxREclS2x+FU67UC79PXTH/51CSdJo2DoEOe2wvj86U36QCvi6C/JCFMpJ+3yfbPGuAQrR6E6yt7iuS7/hvr6VuNGzH/jSM6sAFtIMFcTr7bAEgvmQ2/PJw9i7n2+lqVDKZTHtm9CevRDlFfqgJA5gTMbHGnOz2gh2+kZ3G7Pee83X8s5uHHHPgYsQWCWsSPbtQaTaU07Lc63a2n50tOk/Xopxb9JSEP+TN7dviYAkrtOSgPeHO8vFMGXsZU/QFycw58Eaug0xDow5OPOx2DsNdUnpNOBaOjkasUZFW+DOd1O+2iLwSX2f+jEKpYVzGvAAc6N5Q2KcTo8ZLmk2DdaFwRpLm8LYCcxOdMrvFTG5MFD6bk/0j0IweUTa+2WjQQIV1mZ6R+0QdicsXxTB7NQ+5SQBVpTMZ3RxNLQhCRQJtCAViwPrZmEzO7hxJAyZBehqjfXZ7Jj46Fylr5Ddlu5k8eoHxz9g81pFgffDKek1PbeGbdNLRYTZrB9LzbrkYul4VasiTLDZUngaLxBsV6sGL7Yn8SfDPJdiR+06FWVAAMK84lB5WarFRflILdZAJU+K4kmV3S+yjlooSdScpqA7k0hqSiT8pcLury027HBx400eEYWFtrMp4JBk0LWwVgSjXCrLBl0FXwYHvxuEmUSMxPqQNUwL06iFho
 rBSppLzG
 TMkWmPwnBBEKwe/NZBF08vQlHgfS9W3cWHqvoFdUxS5WBnW+SV8o4qSlDUAEysw8GLyn/Y75gDHj7PjKsX4dXN2yj+RtbED6d0auleVM5BD6BBuzhhLM3RyMg+zuM5qERtgRHckU3HZcPcSHyeeORj64OWEmatppTEIwksWfGdkWFlEriDdMsHTB/wK1FwiHShb0OI91epmb1FBWMNGpRQ0PgScoEayC7zoWhXWN3zpzpzBA74zH7vkl6tkRkj+O5kg5E6lFHCkWb+IxXeDch4C+Mbgj0uL42iamf66PtfvYVAha+UEtfMMWWPFkaXtBd4j5e4LgRjju+0yReYGNQzztLaGaIRbLb/XbrRc8IaUZrl0dwLl6BgZsLTJ1H7CH6F5vOfzuXp3cDho2zx4a4yTem+S8EtWGvf15r2DrHTmTpH85f5CLLgWjLDZ8YQIvd5/N2N3EVeqDTxY3+2kXJAxk8bRaAng86DzEHrOcOEK7ZdUJvrcmWUrs5IJOI55zWC38afZgG1JaWPmGgjX/Us88+EjBQmi1VU0wMH12mFiJLqKG+53NEgw77i1jp3u+8ea4t92SZTUvKOe1E/sLacYA9xpGAgSmwo2/GWInWobefUDhM8RyEdsxCx05DBdet6qEkkcwxB9BzW9xYXmhSpk8gPzuezkzXAa+hxfpyt3fYtJ+CqhI6feHbwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I meant to send a thanks for this, but I got mired in trying to understand =
the result. I saved /proc/allocinfo before and after a test interval and wr=
ote a script to correlate and compare the change in sizes between the two f=
iles. There is definitely growth across the test interval, but I cannot tra=
ce it back to my own kernel code with stuff like bpftrace dumping kstacks o=
n or near the given functions (as some of them can't be directly traced). S=
o I've had to reach out in different directions figure out what's going on.=
 It didn't help that this was my first introduction to folios and filemaps.

If anybody is curious, my biggest ones are:

    Growth    NewSize TagInfo
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  39407616  109314048 mm/readahead.c:186 func:ractl_alloc_folio
  35815424   36634624 mm/memory.c:464 func:__pte_alloc_kernel
  34979840  556675072 mm/slub.c:2492 func:alloc_slab_page
   9523200   12398592 mm/filemap.c:1981 func:__filemap_get_folio

Anyways, thanks!

-----Original Message-----
From: Lance Yang <lance.yang@linux.dev>=20
Sent: Friday, October 31, 2025 1:46 AM
To: Preble, Adam C <adam.c.preble@intel.com>
Cc: linux-mm@kvack.org; Lance Yang <ioworker0@gmail.com>
Subject: Re: Accounting for vmap_area object growth when kmemleak doesn't n=
otice any leaks

From: Lance Yang <ioworker0@gmail.com>

That's a tricky one. With kmemleak being clean, it seems like a logical lea=
k.

Might be worth enabling CONFIG_MEM_ALLOC_PROFILING[1], which is perfect for=
 tracking down the call sites of allocations that are still live.

[1] https://docs.kernel.org/mm/allocation-profiling.html

Cheers,
Lance


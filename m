Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61ECCFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5766B0096; Mon, 27 Apr 2026 10:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67016B0098; Mon, 27 Apr 2026 10:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B304C6B0099; Mon, 27 Apr 2026 10:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B22C6B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:52:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3C671C100E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:06 +0000 (UTC)
X-FDA: 84704610732.29.E727119
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44CEFA0019
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SOQ+CALJ;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HB5Tp0K+QSVsZ3I+ui6oE05ZiYvk/5ZTF3DAkTKZ9z4=;
	b=exCJa7AEundbLtwoOPO+liAy1Y4pybanI/hcj9evx5TdhlfR/ymk9iSaq4q28MVJh9Nmti
	pjk080/2TeoEyvLFNqkmXEEEiZ8wTnrJVgcClVCA/1IZsMSRf9rTaE+3gPsBEsLrw/b6h1
	Y7V+KLQrzlJ7P61QZCFkV7OoBK8zP/I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777301163; a=rsa-sha256;
	cv=fail;
	b=jE5yuFMAGTiF0wWINkrtZDm1MH0JZW0eE/sRyga+EcGzZ2HB7zpx37CgQOnCnf0hmijR7c
	MXsDELKrD4zkozst+hiMBESEOqNdlKljxESjbr8V7YH79RFTgznUBQoXyqOylCndyeSdFK
	nPTjGohP0vcsgFkzpbM4Ba5hjZfiEz4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SOQ+CALJ;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777301163; x=1808837163;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Q3WaLlYbOWU9aJEc/6sSmTng1wPXU81gMOzgoRVJd7E=;
  b=SOQ+CALJJB22/cfEcF9s/b9DnKJxIDu2/hx8KphNU+rL+InmX7igutqZ
   XuD/x/weO1HGl2pNhBXGjAjsEiximXbOywtyrk79l1rV40JmfQkmqcUON
   x9k3EQepZZKrIznhSB4/JTR+XWZjyebBb6fhF/dav87mtqNX7Fn3UBUf7
   NencCgxRDfpOqWUSYI+ErBj2Hei1qpCOOrevVFr7N1xF4VoNX+zN/y4+P
   Yl4JlOoOdEZQeU0VdnZMr11c8ymRe/1rmfMgbr2dx89l1HtQzP4sy9ofB
   yuNcOAX53FO9Fse5g2ra3+T8a3xUhtM1fDH27bUUHDEFzMY6hDYKxdOnt
   A==;
X-CSE-ConnectionGUID: rEGo1714TMG9vKd761UgDg==
X-CSE-MsgGUID: WCXjNeiZSTixPyIytPn+yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="78378310"
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="78378310"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:46:01 -0700
X-CSE-ConnectionGUID: 2xLPsojqQCmHEMC1oWGV0g==
X-CSE-MsgGUID: bwpdF3QJQUGuM4UfNjkh+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="230468080"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:46:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:45:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 07:45:59 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:45:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjmXqHMdGgCTuqf7U/UtUmE2wqhbwkYs1VJXWFEvZOVZHNIVIMeO49tFSrFcHZ6AyHh/rwYkHx8FICgqYuG2CR0ObOmorSxL+qg27joI4JjJiepaht0txxxxUEb+dyZa0HlqKYVq1bJwKO9qymF2KYEVxTvDXXOqviN081EoWHcWODODF5cYw3G1rH068s8bZ/G+/kAv2ic4OLezGDqH08VlzrsoDQZyThMkSjB7qg0n7IcJD/cwmtXJuRrloTqkAF3J6iGLEYAiRqFMzXLar+Owgl22JMqLvLj6cKBgXf8a+f6sLWI+NdYghMZfIGvFy8PHeKVszrjUsxXopfzmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HB5Tp0K+QSVsZ3I+ui6oE05ZiYvk/5ZTF3DAkTKZ9z4=;
 b=OO7gyuVJuqnbkhp4Kw3R32pKrfKXe09tzNohFNVC2Vczr7al5wzyNYgu1XdqKabbariQoX+DgNJeyojY+ZUT9SMChM9yH3RoWFQcEbgrbP6BtZnEC3O25rDDZ8pcrKFLBKeCYzORxHCdHNuIIUBaAT53rTZP7AgfXhnhkqe27vV04uVnFdrdwZ5NXuv95ZCFsUdaILGdqFcs9LRpdC8tq16Cuj8DrMaYYPUN5EldcDcCVPWonLKkoWP5fTJ/MF8HMA8y/iYmkAdSoUvZDJo8k8bPd4/RobUMP5CE0IITlUW9wce8gZYgb8LJdlU37lC9/QybP0GXMYiW3Xs6RC0cGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
 by CY8PR11MB6963.namprd11.prod.outlook.com (2603:10b6:930:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 14:45:52 +0000
Received: from CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da]) by CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 14:45:51 +0000
Date: Mon, 27 Apr 2026 22:45:39 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>, <mm-commits@vger.kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] ./include/asm-generic/fixmap.h:77:9: error:
 implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'?
Message-ID: <ae92kz3LeyaFBvKw@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0171.apcprd04.prod.outlook.com (2603:1096:4::33)
 To CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5428:EE_|CY8PR11MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc0a6c7-eb19-40c7-26a3-08dea46bac51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: HdljYQORb+R1iAHmpg2i00S3Vp+TWjqahvhKSN4JU6XicuK1W4Yqb5Nt+hQWL//TQvvP+SlZKqniNajlOeXLyL76fyBCNbM3Y43z17SGo1Z7oP06sagsig1cfn+mAC1eVR++YUH6ht77Ntd11mVZSVRFeBxBIDZpUy2+noxzmuVlHtNjg8A9F75iQedDd7lBsZ2xltD19n4jxRQPDcfCGOej35iPpIy/GHQ3UnKBd42fwhmju1kVl9JfJDscOROkEQNAYkaL74QWDSO8jWg5rZeBe6AlygP/9a5WtkRzLDCqwrbAflPLImMOYLXPgInx/hhiTfOmgd5Tw8vMbDk7bhXON8WhiWwYNE67nneeZpA9R7IJ5FbcwWLWqgSvSsaP/wFLYz6dec05LUJPWzsZfz7vXfbosCErbPxSPUCnHS32NVErhO3dOvE+j7YihUDWRWffTJps4z90XEmHdOtCtl3L3T0Ekh45MQYgmnk72SqBlIg4Gu+avONCBnekG6MqpoMat/IO0s6dn3DPbx3nNvIXMY41u9gBJOjpQZPSd3MDjebNk9kqg/iIzqxOM0V+gH2bskb/U+XNz7NUOZjA4XkaQEIMtfeVWm/WcexpjufK1/xRh3aX1vP0GNoU5IL1oP9vzL7CT7QPLFan8ZU+QMASMSLzOTiKbyYGWx/7h/Kc3WaPCva4MsHXa7oRtu3hBWiJOZ+A2KB/qODcKXQo/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5428.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D0kTz7tlUahEG2yq4dxIA3rwf0gI21Y4/Yny8MTY/JuaMLGk0u/wPEbT0D9O?=
 =?us-ascii?Q?SnK4xiQV8HJGkDdn/zQWXN2tgNU7YI9WxDEW0ZN925neE2TARlY0HLJ7k/Yp?=
 =?us-ascii?Q?DOSdZZVh0DR1t1zajMTQjY4csPPzvpzUACvJuMTWHqaDkHG5Ad4C23QhuLaC?=
 =?us-ascii?Q?K0xIfDLADvOGOJ9SibG0KzM0eHor5i1s7k5XPaTWr2f1rT4m6Ww9ozA62uAG?=
 =?us-ascii?Q?GmgHEr8Ho9bjQSXcHjt6H8TL5mJEGubOK/Shjq/j8xAE47hkmGI0np9FMMBO?=
 =?us-ascii?Q?tqBX15ksUZm5BxnGbEy0qRPbyLLekmGi11j3+tIAWh5JupuzpS86u3sQjJG+?=
 =?us-ascii?Q?VV7xE/SiJDGC29OHUm7emrrz8dXbcyo9llAgELTGsOUUI2B/EySYCOthbp/d?=
 =?us-ascii?Q?DRS9phkjNSarppr+RTYsAu++XJEMYQc3n80AcWp0lorahBYhFu2Ge45/ucwJ?=
 =?us-ascii?Q?p7hludUBeXqzucDjYukI1AQ2zSxgucZ14Fjhmzm3S5V5Z1vBPQ7H0hyqJTHE?=
 =?us-ascii?Q?chye6eqNB1y41rtCOTtVlzNJ0AoBXzweGo1zkDE/zZujZpT4rNekX9JujQ78?=
 =?us-ascii?Q?Z+zwPKcGM+tk7FixKs8drZc8pvAzvQSbWaI/PJ8GTjiniqj1916EjrlrcoCc?=
 =?us-ascii?Q?qjpboCQ43RAw3Y6uGz2E1cZ4J4KU4q67Sr8nkqBGcYpJaLQjM/ZkHxt1B2Qh?=
 =?us-ascii?Q?bpZ7onqCNcKmCh92MLdIcesGW0SmzJuE/cAaCLXSyRWywArrLlIsAynPa2kP?=
 =?us-ascii?Q?4O5oXWjLdII8CYcetjgUGreHOjx/yxSMqckhlF1fdQPTYxbViybojqV1gLxQ?=
 =?us-ascii?Q?XJJseUUk+NdftRTUxz4P3BbwN7a+0tQ6CKX4xT4sp3sBPZZkilboBmmRfGzH?=
 =?us-ascii?Q?kyiBVZ/jmHXxXNxTLl0ckjlMVdwFvkfgUV8fd5yGgz9pzlX8U+HS7G2dGaji?=
 =?us-ascii?Q?HlpN+uxMLci20n4tPl0wFhwvK8I0CgIDAlpIzsk22JXHjl0r/tHC/EOpOGmB?=
 =?us-ascii?Q?BxrQA45/U8GvfJy0xe5kbMiYdjimssPL8g5ViyQHg8p/iEG3HLz6PpdgoVZf?=
 =?us-ascii?Q?SfacKho0CGRdl6oKo58LImKQj8g8joc585kiWFxXVAsDFVtZTFub2vcQ+Y1j?=
 =?us-ascii?Q?KACOEawqcJqAxLf0+X9q0R8vT/hqPM+GDtyFqzIz00PBoobEQjgVMHGDhaP9?=
 =?us-ascii?Q?bOXhYPGqlF7yUFIli2UY999qQdckh4Web9tQn2BQ6shc5mQ/SJHejPPjUzmA?=
 =?us-ascii?Q?XbkpNnnb2q4ZQ08h5mVcPfPh2S0fwESVq4HXSOGhO7CweLjYkjUd6tLcScQU?=
 =?us-ascii?Q?0YPvPmW4S7sA4UWK7tR+fK8zXTNQ6NrHbt2XOwkguxiItsy9dozgJDyo4H4f?=
 =?us-ascii?Q?cc7F0xOYWbof08eYaAwGND2rLF6BmJvKEeT7GMTga7Hq/cUun0c5H7EWIOhU?=
 =?us-ascii?Q?nMi7v2QJG321zL6FF+0qCxlCWsM7swoUOtn8S4SjWih8WyQgc8sqwTyyVWGO?=
 =?us-ascii?Q?dob2arzu+uQyxlcA8392EJkzUJhNZroqm/bmWZjGVFiees4XfqH7lKAm74ol?=
 =?us-ascii?Q?HUVdH84OjDOrQF7XrhuNPf6JLQ/5WZcf3gdzJD4Wd/IWhzQNqrPssaBDv8+M?=
 =?us-ascii?Q?v1YsbNjiRVkmtlSp24Xb+Ij3a2S5WNhltUg8CXSmpBZDkqUixxSoHIGFRHGN?=
 =?us-ascii?Q?rEQRGEi3hCI9/mkZsOuUiWNQhlh64VZ+ssSXSAZUcA/IAXuxkw+MbSq0WpKK?=
 =?us-ascii?Q?lfULdoYc7A=3D=3D?=
X-Exchange-RoutingPolicyChecked: WUbrRIC1ij4ZzQdL+5rmQsW3zpeO+Vq7KIVLK0NtyYgg+29nB1JkRxWmJKe5KA2zKrH2RfOhQIz6HbW04m784n6u6By7G76jF9yuDn7tVta0N7MxXPouBtQld463mGx4zvQSbqyO6ernGB54lQ510xjo/3kNb4gmM51YyNyaIRFMVHjmsAqBpAbXlusBidBcVi40/JxEQ6axM0RJX8QR1K+NlWvgcc8gTxyl1SiLDOi5K3ngR06WSzTJ3cI73JQXUXPuygBFrfmSAHHVBtdnrzhGb302EizbxyDBgnRBfADb+MU/i3nj32N8HPlOo/+/oTWz5xbZ8mhmR2IULPRMqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc0a6c7-eb19-40c7-26a3-08dea46bac51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5428.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:45:51.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlMmXdMNY7hNffJedDOoJMXLyJ3ZSwHV0ZKOKydC2pTsrqPTAzubc9HUmCZVOW7EBZPcJLfSZD5MWqaJ++9C9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6963
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 44CEFA0019
X-Rspam-User: 
X-Stat-Signature: 4a6t39o8semqswrs1xfapzp7nd6n9y6r
X-HE-Tag: 1777301161-859303
X-HE-Meta: U2FsdGVkX19a1YpBAWnTfKfpm57iXhq7XgRd8zK4MLdq/CLaqzwnMsi732eV/PM9xPrdnzvSsGlsKu+hTqNMh/Vtacx17kaHGDFChIALMr9Pu2BbeYl0j3JHgjXdSpWsRrwP8rjxHnbvv2S6GqUXiw62F2B6XDNJIcZ4N3+DVqMF77e42J9cSPG30I/Dlz6VBTOzxf+CcYIeh/sc5Pyvp7kHkzy9zuDf7Y530e9rTYXdrt+d4F3IO2YNz8ePyGA4+MyaAF0KASXf/Aj7IOt6dEXquCYYVzmKtZBy0r/9txl9KJkjU8roIYMGEnjSCujvxNE8940Wt9K2Pm2Rh2Nu0y3zAB6JO4WNfbM497RwR0qR886XVsPyESM/oYUjUQUvRnSZ/5bAY6/3WWl2xyoHyAsUsY60Oc5j1+lwyjFv4vthUaMJwgQ+gFiTRDwD3TsJC8g3w1v65rS6A1Fk2FIQVZWTrj6fdWsThgbV7MbhDLbmquchHtGyscCj97fGGVnpGzsASsTuGr9OLrvgoVOddmiHbyxtvM4BRglj5ummvmtBrQWFLyAcAmx4N/ppd5Hoy2kqqbLpoHaZSulZV7yyzXi6nL1ORgX5LCzSvoHROp4n2myTf/PMC2SjstgfXAALO7ulSl4sqZ6uLGsZAF37M05o8cw5QlAe5QfDytHIoVA6aQVdhzvehBG3DoAM3+clgoJP5TbrOH0MA/Wz4Rx84ncHiz2xnP72rd203v0sfcFXkMVTPpywdj8dglImAHxU3ohdpe8PQqZM1Toivegb3mxWpDydpQyYr6GF9aQ4aQskO91dPol9ntxK5Pa5IxDPsuuLHsSLVoXTIgBkwIvUODPrsPv4cw0YS8L+vVEH8a9Cbw9+4B66m60tQ0P1v7dLtSAmFmnmgdsgyCcYNXbMlwJr4IlhuUq4kVgMBDmit4sEe8Rpjb4mSWsZBJiMty+ev/1mvumPRYeGFo/WenP
 5Ytiibd7
 pQziPY9as+tas6hEKAZlrxC0mqmfyPb43im33JwEJLtSCA8mKsUzXmH+MQcnUPM4tMd6mYCoTHaj4kJd4h10oFd/KnVW5mmucGWzbtXbq66uAeQwuQdg0hGXkrF0fsD5Z4CkjXkFEde5Hn656nONRoC9FRgkrjk9J2538JJUNs9P5DxYKBM7khBUytwVUp09q54NMxGowFfhw1m/hhCBCdEF1YpDhzEJLNVLo5D+iOSWmPBN4t0bnwQuuBDKU93vzy+ftJ3W8YUGaqIr3rVVT+Cdk7h9htLsjEpqb660QPjogEQ9Gcur/etcBy5dpW3UAP4/I9OexrUBnILo3UAz9RrZ7662XL61tEr6oJKKkLgV1Zp/l7FJmZxl7WLbi4nEktso+buTkEcbmgxCBpPzmSQyvizYYl7L4PhqyN3eSFRqY2AvD3lMEQfy3xSBvcIDN2l83vx63o27idn3ULAVjMNuZn1KiaqDzwCeySDY3sipPkpz+CiKGOgjB2SJRtaIBOXsyFqr6xjvldFwueC4mNMToAVItDUDmMBCKP1eqIqGpLVrVJ62c9jabnwF3BVc7iyq1HySvlmZqGagXSqPAe97Sm3Q8XKOMnEhvXrkVErWNw3Q4Dr9G8oHqZ3peSjJqT5q0wkf1lBRSU0327W089mLziS6yHTo+dwM3MqPUJ0NxlMfARhj8c2Q0YYUAWw0JRELk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260427/202604271114.ebmzs1LE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from ./arch/powerpc/include/asm/fixmap.h:91,
                    from mm/early_ioremap.c:18:
   ./include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
>> ./include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~
         |         set_fixmap
   ./arch/powerpc/include/asm/fixmap.h: At top level:
>> ./arch/powerpc/include/asm/fixmap.h:93:20: warning: conflicting types for '__set_fixmap'; have 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
      93 | static inline void __set_fixmap(enum fixed_addresses idx,
         |                    ^~~~~~~~~~~~
>> ./arch/powerpc/include/asm/fixmap.h:93:20: error: static declaration of '__set_fixmap' follows non-static declaration
   ./include/asm-generic/fixmap.h:77:9: note: previous implicit declaration of '__set_fixmap' with type 'void(enum fixed_addresses,  phys_addr_t,  pgprot_t)' {aka 'void(enum fixed_addresses,  long long unsigned int,  pgprot_t)'}
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~


vim +77 ./include/asm-generic/fixmap.h

d57c33c5daa4ef Mark Salter   2014-01-23  72  
d57c33c5daa4ef Mark Salter   2014-01-23  73  /* Return a pointer with offset calculated */
93580c23bb3da5 Andrew Morton 2026-04-25  74  static inline unsigned long
93580c23bb3da5 Andrew Morton 2026-04-25  75  __set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
93580c23bb3da5 Andrew Morton 2026-04-25  76  {
93580c23bb3da5 Andrew Morton 2026-04-25 @77  	__set_fixmap(idx, phys, flags);
93580c23bb3da5 Andrew Morton 2026-04-25  78  	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
93580c23bb3da5 Andrew Morton 2026-04-25  79  }
d57c33c5daa4ef Mark Salter   2014-01-23  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F213D79767
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 13:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FDA6B0092; Sat, 31 Jan 2026 08:01:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC296B0095; Sat, 31 Jan 2026 08:01:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E9E6B0099; Sat, 31 Jan 2026 08:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A21F6B0092
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 08:01:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3F5C1B1D1B
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:01:43 +0000 (UTC)
X-FDA: 84392270886.20.28EBB26
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E7CB2000E
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:01:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FU12OPQA;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+Doq82+M6GAs/i7Ii/H5r2wyueTNOTtUSdykU5fjD+o=;
	b=AEf2WmV99jDmEVBEVKnPBmA8xf60g4HSQwWQi/dZMa+nnm/u09GNoJpF5kSk2tV5cSNMVp
	tWWjYqJATr+IO9G9nglwhGZqiKLxbzTmARJ+Zjr6eosBk2V2+qq+VSNElPAqPCsnDJ/E4f
	AJBD4Ws6CxfCQ5X0SIUPHhVUs9IDtdI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FU12OPQA;
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769864500; a=rsa-sha256;
	cv=fail;
	b=fBBtWD7preLl7YpivzI69SReAgpgLe8N+r7Rq8u9+onIe8+OvF28JDVNETvCB7s77WQ6o/
	Bnt+R2hcV+/UGkXYwrUOsZcSSa4B5D05TK9CnhzS1J/b4bJr4f7lzgconIduaTPH8uprHL
	CWrJbGovGUD0umgYebqMVYyAS70feOc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769864501; x=1801400501;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=ZyP5+xbi8UY5ooIo9t4zQLbOQ6siOYpe9Mk+0t9IRys=;
  b=FU12OPQAP8xYozYdh1KckOV4pYNj4v2QkYOzT0mmUeCZbhmzAHHz+szG
   wt0VHO/akONc4g47tg6ani0Gt46Ff3H178+10pwa+lQAjhrm1WDf54Eb2
   RB0jedAUux8gnFDO4qLSSg0jvk9OuBYyl1lJgpwdSkbVes/A+6knb85Tc
   T5fD68ieMZlrLLd1so4xoeInsZyRdM+0OYpsfAAllbZ3ACcmr+GZ+ofyn
   RomkojcXIXK9O0APSwm4gqtiH25QlR1gtxWfDUwonAsm6ph1J4tDMPtSo
   /wU3giVs4Lm5+hmGFPEdYt2roHfmHvIuhDVsfL/5UTij/q4LCN0AVjsZU
   w==;
X-CSE-ConnectionGUID: NOHMSiEFRES5ZfvFbFJPJg==
X-CSE-MsgGUID: 4tPovqN5QBGssQgwfhzpwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="82204261"
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="82204261"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 05:01:39 -0800
X-CSE-ConnectionGUID: OsK2yV7/QK2V9pNDlqVK/A==
X-CSE-MsgGUID: Rjob4Y3TQiGwF9aIqg9TyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="232008468"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 05:01:38 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 05:01:38 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 31 Jan 2026 05:01:38 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 05:01:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIUYXL5cbT0qs8Je8nASYqibOn17HRcm4loo8rBEeH9Bw7cDxGAUDITyHCPecaiDoCFIhih0qKgf9eVinozgWJY4qnOzvIotFsLSSuFskbgUwztXZeafggFa7yWh69mi7rYrQZuyrMhuRzBmLU57BPE6nXpGWndwp4F6m8CbF/GP3Osv9VlZDX/JEQcTWWUoIsVtdjHZ+6duCrf4T9kinuXBhAQh4wPbIxznmAP2d0RDOrugoMLBotTeUAgkSCMD29RPxoRv16VJvBShLjBgOHkDnJsYnPWZaNVx41adMPdoCtBZnKh/O8uY2XuTsyMTG1zUnSw5D6Z0KRlCEPvqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zabWxVKhDtjVJKZxwnPlpThnuW/W2v6LKQkMWzlF/5Q=;
 b=SaaPxC9965hGDafVOEn/L9on5CNLKs3nUNSucA47eQTksKTLvTBlnKzuzpu4fN7hEUIIBI7AoliQuJCEE4EPn+CrTKM6mtv5Ovk7dMY/CFLNYIxRiC5+VFW/t/aD44ZXZPBNXuS3oGJ9+BWHP1TBJ1TtmEVb2yhPdKtLRAJ+9NEiEeWqJ7k115QUm1H0vqvb5PiTlTjPvH0+GrczRFfM8toNX6+EaZ7xBqyX8D1otFOf+Ko/eJ9dHao5da3jt6HKOBNQdZ4BhCD0C0RdtaNnwpNeuaBqjHA/2rYYc+8qctG2CFG9GtBkY39p78af9PxQCySJ+Tylm19HOYkLd8m56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB7902.namprd11.prod.outlook.com (2603:10b6:8:f6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.15; Sat, 31 Jan 2026 13:01:35 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9564.014; Sat, 31 Jan 2026
 13:01:34 +0000
Date: Sat, 31 Jan 2026 21:01:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Hao Li <haolee.swjtu@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	"Vlastimil Babka" <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, Zhao
 Liu <zhao1.liu@intel.com>, <oliver.sang@intel.com>
Subject: [vbabka-slab:slab/for-7.0/sheaves-base] [slub]  a66f9c0f1b:
 will-it-scale.per_process_ops 56.9% improvement
Message-ID: <202601312046.ced58091-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TPYP295CA0026.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 59104a1d-270e-4d5f-d7ef-08de60c8dc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?vV+CkaPbPgJCd/bCFyAFKSJ7yizkE45qhpQHCgJqO0Yh5v/CxCPMO+KIru?=
 =?iso-8859-1?Q?RjYpQBH4TImu/98iKo2wOEV/uXkC896qNhT6IXykyj7VwJs5WGrFSYKaRe?=
 =?iso-8859-1?Q?hcasF4n1G0nIhYU0O8POqEAxnST5uKegRAQaaD6wNwjnEHiiGOFqNnghTU?=
 =?iso-8859-1?Q?Cm4G3TZ8ZQWDmphWhMqO7l0+Pvdw83g4BmqNpNDZhnh2z45Dwgqdo1uHW+?=
 =?iso-8859-1?Q?DDuEkuW+s7XVMRCnqePeFkjrrttuhaMLVCMYIGv/gRn63FnzlMhrr3bBvo?=
 =?iso-8859-1?Q?ja7rNaCo7LKpZ4RI6VieWg3CeXREhfBxzHNozaL+XhpkM2eDSAjwViXpOA?=
 =?iso-8859-1?Q?pyG/gcs0jgGIHjIRo8hXZTHPspBUnmlRdnufk27nfali/kCf7hj7MvJ19Z?=
 =?iso-8859-1?Q?TYsZjPbkILkI936Kbr4HfI1WajLMqS6aHjrBWyqfGhENXNxA/dQ0QFMeBC?=
 =?iso-8859-1?Q?4q7gpDPa0GgMjkliLXFFoViv50fpR8jq+VJW3vt5wzYqyab/RSuEYhC0Fh?=
 =?iso-8859-1?Q?MpFiT6rPQnsBPNBdMlAG9R4wId1u91rClZ3BYKhdffr5mTF3hWna+tyK3l?=
 =?iso-8859-1?Q?s6HIPDdBOSP9wu4iI9o4lF+ApmNnsJTuJbH2SflfwUN66xdMGb6ecgo/Ku?=
 =?iso-8859-1?Q?zKX689vLWN++bDc+GKoID4aS67/SfvXE95Uf65Vji/DCVt8ljeYB9K9n48?=
 =?iso-8859-1?Q?WemaJcuwxrXuBlaIebLkIVNz/ixs1l9OWUgkYIq5nxxkL/NvaSDEdxVR0k?=
 =?iso-8859-1?Q?GZ9CXVDb7m/HZn0X2JdUg3Dg2uE9wVrn4AEyFkFX5bipvlyPzZfMRs2n6u?=
 =?iso-8859-1?Q?OFw4d6jPewpnm/OxN4NCPmf/dEor0flln9Z7poESnTnVAV+dtO+zbt6Joi?=
 =?iso-8859-1?Q?22Xz0xC5Nvm96USGtkClR1MgynkjdTqWmcHYEFzTemH8DWeu0iYAjm5h/7?=
 =?iso-8859-1?Q?kiJNtnBraqAxeUjn8uPjGfwbNOmgecDEA/H3FhhL/PVwsSAAgbuiepcOFG?=
 =?iso-8859-1?Q?HT2Y9+dWGcflw2m3px/yFTJhHvK35JrBsih1XpCuMsiiZ+g78GyV75RMN+?=
 =?iso-8859-1?Q?abNL1DkWKyTnTbFaXt8vLwIn8GhWy9boXdTLnbD+uhbwY1/FqifgKDQH+t?=
 =?iso-8859-1?Q?waF7eezQLSe1bcNJ34sfmiQNVC/VJ32HT88y9hAOVrU4J71ijb2GmW7LWc?=
 =?iso-8859-1?Q?mldHUQi3NJDl/8WRNTEJoFn8iOsvMpt3MnZGZjQtUTRvIHS+rvWtvfrbpO?=
 =?iso-8859-1?Q?GguuOwPbHvTWrONhgENyyq5c7P49BwaW+nA4d+uCk5UtLrseTi1lCNNLxP?=
 =?iso-8859-1?Q?Ty62wVoY/PMuXRl1X5bbL9CRU+QWh2B5jjuJYCDZA+L/jUqca7gg7zX/IP?=
 =?iso-8859-1?Q?9nH8+LD0AyWFgkhDQ5/rDjUGAZTlU5gE7I5WHdLl2wPsiqC1GcgeOTWsF/?=
 =?iso-8859-1?Q?58RY3UX8rdi31oIDsrVdG04i4sftpvsCPFsBs4/fKhph75aty7QVU9KzYJ?=
 =?iso-8859-1?Q?p4XokdgVrvFV8xkaErwztGOXOVy/zboj+ZUFUSLqLzRsGo2BRzLyamU+nr?=
 =?iso-8859-1?Q?yN6AWQPcHV59tHJQ4YxrQ73/mtottLnNcu7uvJdDm5sIQ1JKHTOuKxAUPd?=
 =?iso-8859-1?Q?HTxXZ11O55SQX42SEz80YhFZcRPwkFB7VX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?z30caK6zfr8qG8JTSH572eXL3zxCK3e1BiLFjHyrPwf1nM+plVQaYff1vr?=
 =?iso-8859-1?Q?TRwOM8PWrHpe0s3zL9zddPFp+2GwyRHWx/V7Fy/E0+l2I5ncBTqGwAnLuz?=
 =?iso-8859-1?Q?ZBZKqUVl/PiTTo+LzPyvKoIfSLao8Kerk7+eiprRGS9canTusn34NMcBio?=
 =?iso-8859-1?Q?ampc6qm7fpZ1dRPx8UDTzaf3ivAAlr6+jn/7RP3iFSBXSFkc4G/71Ndoiy?=
 =?iso-8859-1?Q?IWxDxlS64fFT54kbx1iNrhmZYM6g28WJOxFCBlI9ukY57l53epmYbKJnGK?=
 =?iso-8859-1?Q?RofOEltPfMoPIy3RX2/VZ27mkgOq+1BzryLOElRL/KrYTgzeUUqiyTKSr+?=
 =?iso-8859-1?Q?R18XjZb9VtPSUyvIb6EikFiJ6zrreKrRTln1slVDuCdNmgK7OsDDXEF0NN?=
 =?iso-8859-1?Q?0JQTGfKfoQXaGZwNDCvvUdchS8p5wZMkVqYmA76gk7Oi6SYJIs5JMWx+S5?=
 =?iso-8859-1?Q?a4dIiSfj3m73ssJQKBcptA9pkKCUk/L5RiDo3bqRJEK21Hfr4ts4bBWgSN?=
 =?iso-8859-1?Q?Pz3aWHivR/jtks0HYwgEpqqJEX/pVi3lDiHcQerzsfo5Tgrn92qs8dI015?=
 =?iso-8859-1?Q?44uZ0rO6yKLTZxN8OL3Fnn2k7mM8Zltkzdp6FRL6z1O50rw+XNzRuRqWjR?=
 =?iso-8859-1?Q?K1wbjUJdjTK1pnf3/Tkbbhq0o4oqEe5pvxC9NNpoGB67AdVQrwRQ2Ah7GE?=
 =?iso-8859-1?Q?uNg5olsRBTqpqLFm6ncQ+R3N+0zcAN8eOemSk+Uq/arAofUF2U/ctytADo?=
 =?iso-8859-1?Q?rlOlPix8ooUcBtVZy1m0UbCzT3Mp4Gfe34AdJjN5ckgDM0NvzcNhWvkJq7?=
 =?iso-8859-1?Q?1hKqYlwPdZ73Z4Y7tQSNFkxWtp0CKCZSPUQmu16wWqYpy/N64HLaZEitLy?=
 =?iso-8859-1?Q?VPC1KmTuosIdwStVBUOmgPXL3r4pVBBU8ZV7yJPWN7kGr2Yua6Qtbr/nKQ?=
 =?iso-8859-1?Q?TgE4/ACCwYDwXYC+2ALbsQOfJO8Wi7z6s4eF1F6Ht1HgUDP8CsBb7RdIJP?=
 =?iso-8859-1?Q?i+dQeF2bnvKwIjLq+1OIxr+SMWwwxKCRg5T/rL5OpKdYoBLEHXKe9keGzp?=
 =?iso-8859-1?Q?zYVM2vTCr7p5vXE0NbIucQpaqu2qgWnEr3jC+bS01XpNpi+Zx3FCniDy3c?=
 =?iso-8859-1?Q?5ULZhe2UidbVVlNLSLAI3CKY+fZ36fESKLjOvou6FNwDuvOUVbTOgp4Blj?=
 =?iso-8859-1?Q?j9XxBDnFZLK/WU61I0PhIMSCRHaAmghCdlfcfMJMiejvyZ3Xu3Qv3+rsWy?=
 =?iso-8859-1?Q?TgtaKtKk2p2i5X+mXmjKIy7+zBpxF1VOP4xr3sOpB0fivMi4GeguH8JNBR?=
 =?iso-8859-1?Q?Wo3ER7rHAfUNFCyc83ko30vNQSYmkgOHNdOPar/26nASeJOZV/+YkdmvsZ?=
 =?iso-8859-1?Q?Ygp0X1agzWtoi+s/XxIRdPJM8rngYGxfZ+4nrwSGqSvT0DC2kFzmE/pffu?=
 =?iso-8859-1?Q?Z/FevX8G+cqS2SFiu3orRLn6nbmdkRsDZ7vU38zBmlRIeqvI+eWaDfvr1C?=
 =?iso-8859-1?Q?6wbG+McT6DjmGVMFzOu1Ejw7IOSbK4D1PGvCLi0FB0994bn3sKASi32eJS?=
 =?iso-8859-1?Q?l21Vmf7ZhbfP8Bb15//dV+DfqNUp/Et6IpX8DQ0jagrMKgf0d2NFr3/p13?=
 =?iso-8859-1?Q?4Ruvjot6ZLhxCuNeH6aU22soQBV2G395kjuBmQm+QSXZr/faEeASU6fOE2?=
 =?iso-8859-1?Q?XuLXz4P+eSEmQgT9//K28geO64DqmDwj4wyjLEO8R8ADKd4ITOz/QQzfQR?=
 =?iso-8859-1?Q?xM/oT3vt3JucuJt4KhA4uza6p+4IkRfO5wf5jzsC5bX/d1bjmGBuydY/1d?=
 =?iso-8859-1?Q?MSkVUStufw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59104a1d-270e-4d5f-d7ef-08de60c8dc92
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 13:01:34.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExaNmU7hZfFxaPLQfiDA8nS/1LiBE7+JgvAefZU6xKHG5GVXz+ypuZfqFKykkAB4RVbSpuQPLNjWJXtSYxYr4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7902
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E7CB2000E
X-Stat-Signature: k68max7qqyhm51id1hqrurqxyoa5o17r
X-Rspam-User: 
X-HE-Tag: 1769864499-61487
X-HE-Meta: U2FsdGVkX1+3eEuQ2TmFsg16YLc3HNi4JAClUNMV+2NMeXkCgB/8cu2E3A6HHSSOo/QQMovH2IJkro9S6ok4Jah2vsNSRkTEjc5IYS1kfOPNfmKhb3tzNZgYKyIHE9+LGVaLBqXwMBi0v/CO1aLMWSr2+7/7saakhXsrzup+3tUy5ccspfzl0MjQMieVy4cMt3twxX/QICjnxBE11zrxYQ/B+2gnpbrAdrvgu6xXCp6L9qmbi/Bz13+3xxBvRps25v40qyWe/TYd4PjGlC8k86VTDwFWsYBztI4SHQT29cm8zuqq42PS/8IRxB3MAGIY2zEqluariCtRCcBqv8Rx50b+d+w0kMOuy/+W/H1vh2sR9lyspDxXwJxlviYp1jL6BwM8GhTvTTUP3GKLOL5Wb8Po5TYsgoZdp1Mw8ZW/tDc3/YkHSc81aZybijusA9+gL4xtRzDBl8aUheE/K8bO0IkUGRc+od45NgV3W0QPNsiOENzN1LC9Z6XTllk0cYARKlboybqMAGM97pydAAdaQ5JqevDXssygjXDSp2pQ2rEwJBZJ0AgFzZB+HIDppwC9sZbXPMMI5ry99ZA27zYkeXFL6/Ow0Vn3teuKNog0xeZvHkQCOmQq6zOOsDi7S54KNzpdLj+8WCcf0SDWTrqD/aQujvQZ3+CuhOwmEqdU1tULJHHCZOFheXqQvgLp6STCbmi5f9nNiSCUtJ5lZgMKCIyzjlWqZV0Sy0O+wuZM2AZ2bk1oSJCM8WQSlGejYLMGKEadiAgX+b+b5J/1+9IRWi0rhsVJ89Q6AyQmO0E+BqxTKr1KNDnt6AG34xvODV3tl0T0RRIEtWUeRrNAysKPkpl35PY3awGB4+mnEqIwWTaKVb6dFCxH3wOR5Iv8WoPYYBJIN4P9d0mQUksn4QaIidNpnp/stI6AJJluGAsffsK87b+1GE9iUPIn1FbLF60TPVtVGNqCAKwzAPF+ZtM
 s71E7mfN
 2kS3kg+iSi/5tRMFF0AXZ4Wgs02P6ulf2SiIetTfrSGG15Nl2Qn9GgCSUOp/dOntvS7wGXrl8irAZaOPp2p3XoswOg5/HTJq9qDNY3rB6e2QZH45scBCyOLKFJjmf+h6wgrSemLfOqyL3GeAq/NjhC+MQVOVJgs5OzPh8mCJscx/S6lQwUsk1hLcOlOjiLR6T2czPtXT3IYCNJFGbYl8Kb9fE67DAFKc6ZAGjEDbGFMXwKojt0ILO17M1TUfnBrXqcKAeqIj0RtZSkWy3ugureyAseFWkvUVaX0faqAOaiu2onpHJGiUxvpTtpl59YtWrplVB1p4d3p7C2D9JgDnYRfHXtg78hxGLf2Ma2Gnefjgf8xHmxd95cDjMKBRWYMF3vanknlts90C9aP+x3tniwuFyS+FDLRrPo9J77zKCHGLh3x3k2IdJ2+pGTeSId5xUMczKd6Yh8O2jbViviTs11tnIyi+guII4Rvqr20gL+hTOumxsJKNKxD3ANejZW6ShBZnV0Z1ydULF4R2Q+OFLmwM73+iio8QGCnfbEPW9+SJ3f3NFg1ZccdcY4L3Bejl9zpFvCasdM+8I4YAyUJKFAgM5jVv8XkDX/zYiIuUFIZ33VvcisM9Fo5+f08DNcnBFi6tIRwB6jqI8H9qe3vCvt15IyxoU+L3OjsDkJuKKdf3/2CS6jf3xLts5zZVuta8CBZhxVPQa2oR3XvT3OpSt3Xm/69tLwMWaQLi/p/mcSvwq/oY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 56.9% improvement of will-it-scale.per_process_ops on:


commit: a66f9c0f1ba2dd05fa994c800ebc63f265155f91 ("slub: keep empty main sheaf as spare in __pcs_replace_empty_main()")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/slab.git slab/for-7.0/sheaves-base

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap2
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260131/202601312046.ced58091-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  99a3e3a1cf ("slab: fix kmalloc_nolock() context check for PREEMPT_RT")
  a66f9c0f1b ("slub: keep empty main sheaf as spare in __pcs_replace_empty_main()")

99a3e3a1cfc93b8f a66f9c0f1ba2dd05fa994c800eb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  32495638           +56.9%   50991104        will-it-scale.192.processes
    169247           +56.9%     265578        will-it-scale.per_process_ops
  32495638           +56.9%   50991104        will-it-scale.workload
      0.15 ±  2%      +0.1        0.28        mpstat.cpu.all.irq%
     21.12           +15.8       36.93        mpstat.cpu.all.soft%
     76.09           -17.0       59.09        mpstat.cpu.all.sys%
      2.07            +1.1        3.13        mpstat.cpu.all.usr%
 1.241e+08           +75.6%  2.179e+08        numa-numastat.node0.local_node
 1.242e+08           +75.5%   2.18e+08        numa-numastat.node0.numa_hit
 1.213e+08           +80.8%  2.192e+08        numa-numastat.node1.local_node
 1.214e+08           +80.7%  2.193e+08        numa-numastat.node1.numa_hit
      2138 ± 13%     -34.6%       1398 ±  9%  perf-c2c.DRAM.local
      1647 ±  5%     -36.1%       1052 ± 21%  perf-c2c.DRAM.remote
     73619 ±  7%     -47.8%      38441 ± 12%  perf-c2c.HITM.local
     74449 ±  7%     -47.6%      39025 ± 12%  perf-c2c.HITM.total
   7554876            -7.9%    6957660 ±  3%  vmstat.memory.cache
    223.84 ±  2%     +14.1%     255.30        vmstat.procs.r
     10022 ±  3%     +23.4%      12366 ±  3%  vmstat.system.cs
    251691            +1.9%     256525        vmstat.system.in
      3201            -1.1%       3164        turbostat.Bzy_MHz
      0.82           +53.4%       1.25        turbostat.IPC
    451.45            +4.2%     470.32        turbostat.PkgWatt
     24.36           +15.9%      28.23        turbostat.RAMWatt
      0.03           +33.3%       0.04        turbostat.SysWatt
   4586949 ±  2%     -12.9%    3996375 ±  6%  meminfo.Active
   4586168 ±  2%     -12.9%    3995595 ±  6%  meminfo.Active(anon)
   7391767            -8.1%    6794134 ±  3%  meminfo.Cached
  37348139            -6.3%   35000217        meminfo.Committed_AS
   1470676 ±  6%     -16.2%    1232510 ± 10%  meminfo.Mapped
   3220641 ±  2%     +28.5%    4138978 ±  3%  meminfo.SUnreclaim
   3714684 ±  3%     -16.1%    3117052 ±  8%  meminfo.Shmem
   3380825 ±  2%     +27.1%    4297706 ±  3%  meminfo.Slab
  18244551 ± 18%     +69.0%   30828389 ± 18%  meminfo.max_used_kB
   1145896 ±  2%     -12.8%     999269 ±  6%  proc-vmstat.nr_active_anon
   1847317            -8.0%    1698872 ±  3%  proc-vmstat.nr_file_pages
  60539834            -1.5%   59614041        proc-vmstat.nr_free_pages_blocks
    367529 ±  6%     -16.0%     308677 ± 10%  proc-vmstat.nr_mapped
    928045 ±  3%     -16.0%     779600 ±  8%  proc-vmstat.nr_shmem
    794528 ±  4%     +29.5%    1028623 ±  3%  proc-vmstat.nr_slab_unreclaimable
   1145896 ±  2%     -12.8%     999269 ±  6%  proc-vmstat.nr_zone_active_anon
 2.456e+08           +78.1%  4.373e+08        proc-vmstat.numa_hit
 2.454e+08           +78.1%  4.371e+08        proc-vmstat.numa_local
 9.872e+08           +80.1%  1.778e+09        proc-vmstat.pgalloc_normal
 9.859e+08           +80.1%  1.776e+09        proc-vmstat.pgfree
   3671885 ±  4%     -64.1%    1316687 ±115%  numa-meminfo.node0.FilePages
    100812 ± 15%     -28.0%      72611 ± 17%  numa-meminfo.node0.KReclaimable
     89368 ± 14%     -61.4%      34482 ± 95%  numa-meminfo.node0.Mapped
    100812 ± 15%     -28.0%      72611 ± 17%  numa-meminfo.node0.SReclaimable
   1628880 ±  3%     +33.6%    2176930 ±  3%  numa-meminfo.node0.SUnreclaim
   1729693 ±  3%     +30.1%    2249541 ±  2%  numa-meminfo.node0.Slab
   3572337 ±  3%     -64.8%    1257472 ±123%  numa-meminfo.node0.Unevictable
   4179482 ±  6%     -16.3%    3498930 ± 10%  numa-meminfo.node1.Active
   4179094 ±  6%     -16.3%    3498542 ± 10%  numa-meminfo.node1.Active(anon)
   1512054 ±  3%     +30.0%    1965337 ±  5%  numa-meminfo.node1.SUnreclaim
   3609370 ±  2%     -15.4%    3054313 ±  7%  numa-meminfo.node1.Shmem
   1571421 ±  3%     +30.5%    2051446 ±  5%  numa-meminfo.node1.Slab
    107748 ±116%   +2148.4%    2422614 ± 63%  numa-meminfo.node1.Unevictable
    917974 ±  4%     -64.1%     329165 ±115%  numa-vmstat.node0.nr_file_pages
     22312 ± 13%     -61.3%       8628 ± 95%  numa-vmstat.node0.nr_mapped
     25203 ± 15%     -28.0%      18152 ± 17%  numa-vmstat.node0.nr_slab_reclaimable
    415850 ±  2%     +29.9%     540328 ±  2%  numa-vmstat.node0.nr_slab_unreclaimable
    893084 ±  3%     -64.8%     314367 ±123%  numa-vmstat.node0.nr_unevictable
    893084 ±  3%     -64.8%     314367 ±123%  numa-vmstat.node0.nr_zone_unevictable
 1.242e+08           +75.5%   2.18e+08        numa-vmstat.node0.numa_hit
 1.241e+08           +75.6%  2.179e+08        numa-vmstat.node0.numa_local
   1045072 ±  6%     -16.3%     874270 ± 10%  numa-vmstat.node1.nr_active_anon
    902662 ±  2%     -15.4%     763201 ±  7%  numa-vmstat.node1.nr_shmem
    383246 ±  2%     +28.3%     491592 ±  3%  numa-vmstat.node1.nr_slab_unreclaimable
     26937 ±116%   +2148.4%     605653 ± 63%  numa-vmstat.node1.nr_unevictable
   1045071 ±  6%     -16.3%     874269 ± 10%  numa-vmstat.node1.nr_zone_active_anon
     26937 ±116%   +2148.4%     605653 ± 63%  numa-vmstat.node1.nr_zone_unevictable
 1.214e+08           +80.7%  2.193e+08        numa-vmstat.node1.numa_hit
 1.213e+08           +80.8%  2.192e+08        numa-vmstat.node1.numa_local
  23686473           -20.8%   18756963        sched_debug.cfs_rq:/.avg_vruntime.avg
  24283741           -19.5%   19554694        sched_debug.cfs_rq:/.avg_vruntime.max
  18722985           -19.1%   15138007 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.88            +6.4%       0.93 ±  2%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.22 ± 11%     +46.7%       0.32 ± 13%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.87            +6.3%       0.93 ±  2%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.22 ± 12%     +47.4%       0.32 ± 13%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    246.01 ± 26%     +66.2%     408.85 ± 16%  sched_debug.cfs_rq:/.load_avg.avg
      0.86            +6.4%       0.92 ±  2%  sched_debug.cfs_rq:/.nr_queued.avg
      0.15 ± 18%     +82.2%       0.27 ± 22%  sched_debug.cfs_rq:/.nr_queued.stddev
      1027 ±  3%     +10.3%       1132 ±  2%  sched_debug.cfs_rq:/.runnable_avg.avg
    171.19 ± 21%     +48.0%     253.32 ±  3%  sched_debug.cfs_rq:/.runnable_avg.stddev
     51.28 ±  7%     +12.6%      57.76 ±  5%  sched_debug.cfs_rq:/.util_avg.stddev
      1235 ±  6%     +23.8%       1529 ±  9%  sched_debug.cfs_rq:/.util_est.max
  23676565           -20.8%   18747785        sched_debug.cfs_rq:/.zero_vruntime.avg
  24275321           -19.5%   19546281        sched_debug.cfs_rq:/.zero_vruntime.max
  18712159           -19.1%   15130454 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.min
     30.87 ± 19%     +42.2%      43.89 ± 12%  sched_debug.cpu.clock.stddev
    685.71 ± 17%     +85.3%       1270 ±  7%  sched_debug.cpu.clock_task.stddev
      1033 ± 12%     +52.6%       1577 ± 18%  sched_debug.cpu.curr->pid.stddev
      0.00 ±  5%     +13.0%       0.00 ±  4%  sched_debug.cpu.next_balance.stddev
      0.88            +6.3%       0.93 ±  2%  sched_debug.cpu.nr_running.avg
      0.23 ± 11%     +44.1%       0.33 ± 12%  sched_debug.cpu.nr_running.stddev
      9388 ±  4%     +15.7%      10858 ±  3%  sched_debug.cpu.nr_switches.avg
      4348 ±  3%     -13.8%       3750 ±  6%  sched_debug.cpu.nr_switches.min
      0.76            +1.9%       0.78        perf-stat.i.MPKI
 1.089e+11           +51.9%  1.655e+11        perf-stat.i.branch-instructions
      0.09            -0.0        0.08        perf-stat.i.branch-miss-rate%
  93987064           +36.2%   1.28e+08        perf-stat.i.branch-misses
     68.98           +15.2       84.15        perf-stat.i.cache-miss-rate%
 3.742e+08           +55.3%   5.81e+08        perf-stat.i.cache-misses
 5.426e+08           +27.2%  6.899e+08        perf-stat.i.cache-references
      9889 ±  3%     +20.9%      11957 ±  3%  perf-stat.i.context-switches
      1.23           -34.8%       0.80        perf-stat.i.cpi
    395.93 ±  2%     +26.2%     499.64 ±  2%  perf-stat.i.cpu-migrations
      1629           -36.1%       1041        perf-stat.i.cycles-between-cache-misses
 4.977e+11           +52.5%  7.589e+11        perf-stat.i.instructions
      0.82           +53.6%       1.25        perf-stat.i.ipc
      0.75            +1.9%       0.77        perf-stat.overall.MPKI
      0.09            -0.0        0.08        perf-stat.overall.branch-miss-rate%
     68.92           +15.2       84.14        perf-stat.overall.cache-miss-rate%
      1.23           -34.9%       0.80        perf-stat.overall.cpi
      1632           -36.1%       1042        perf-stat.overall.cycles-between-cache-misses
      0.81           +53.7%       1.25        perf-stat.overall.ipc
   4645771            -2.0%    4550663        perf-stat.overall.path-length
 1.085e+11           +51.4%  1.643e+11        perf-stat.ps.branch-instructions
  93581580           +35.7%   1.27e+08        perf-stat.ps.branch-misses
 3.728e+08           +54.8%  5.771e+08        perf-stat.ps.cache-misses
  5.41e+08           +26.8%  6.858e+08        perf-stat.ps.cache-references
      9876 ±  3%     +20.4%      11889 ±  3%  perf-stat.ps.context-switches
 6.088e+11            -1.1%  6.018e+11        perf-stat.ps.cpu-cycles
    389.14           +26.3%     491.47 ±  2%  perf-stat.ps.cpu-migrations
  4.96e+11           +51.9%  7.535e+11        perf-stat.ps.instructions
  1.51e+14           +53.7%   2.32e+14        perf-stat.total.instructions
     44.77           -28.9       15.89 ±  4%  perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     32.46           -25.1        7.32 ±  9%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     32.66           -25.1        7.58 ±  9%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
     32.68           -25.1        7.61 ±  9%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     51.20           -24.8       26.42 ±  2%  perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     33.20           -24.7        8.48 ±  8%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     53.15           -23.6       29.59        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     53.56           -23.3       30.26        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     53.93           -23.1       30.85        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     54.24           -22.9       31.36        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     54.30           -22.8       31.47        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     55.54           -21.6       33.97        perf-profile.calltrace.cycles-pp.__mmap
     16.75           -16.7        0.00        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     16.64           -16.6        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     16.49           -16.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     13.10           -13.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
     13.05           -13.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
     10.84           -10.2        0.64 ±  8%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     10.64           -10.2        0.48 ± 45%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     10.60           -10.1        0.48 ± 45%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      6.86            -6.9        0.00        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      6.77            -6.8        0.00        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      7.05            -6.5        0.58 ±  7%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      7.16            -6.4        0.74 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      6.96            -6.4        0.57 ±  6%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      7.08            -6.3        0.74 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      9.75            -5.1        4.69        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      9.60            -5.0        4.56        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     10.14            -4.8        5.31        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     10.36            -4.6        5.77        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.23 ±  6%      -1.2        1.04 ± 10%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      1.92 ±  6%      -1.1        0.84 ± 12%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.90 ±  6%      -1.1        0.83 ± 12%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.83 ±  8%      -0.5        0.29 ±100%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.82 ±  8%      -0.5        0.28 ±100%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.81 ±  7%      -0.5        0.28 ±100%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      0.66            +0.1        0.74        perf-profile.calltrace.cycles-pp.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.61            +0.1        0.70        perf-profile.calltrace.cycles-pp.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      0.52            +0.1        0.61        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
      0.52            +0.2        0.76        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      0.53            +0.3        0.84        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      0.52            +0.3        0.84        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.52            +0.3        0.84        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.58 ±  4%      +0.3        0.90 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.53            +0.4        0.90        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.82            +0.4        1.24        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.56            +0.4        0.99        perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.00            +0.6        0.57        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.00            +0.6        0.60        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.00            +0.6        0.62        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.53 ±  3%      +0.6        1.18 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.7        0.68        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.00            +0.7        0.69        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.7        0.71        perf-profile.calltrace.cycles-pp.rcu_all_qs.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas
      1.17            +0.7        1.89        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      1.19            +0.7        1.93        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      0.00            +0.8        0.76        perf-profile.calltrace.cycles-pp.prepend_path.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.00            +0.8        0.81        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.42 ± 71%      +0.8        1.27 ± 15%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread
      0.42 ± 71%      +0.8        1.27 ± 15%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread.kthread
      1.51 ±  2%      +0.9        2.37        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.42 ± 71%      +0.9        1.28 ± 15%  perf-profile.calltrace.cycles-pp.kfree_rcu_work.process_one_work.worker_thread.kthread.ret_from_fork
      1.51            +0.9        2.39        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      1.51 ±  2%      +0.9        2.40        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.9        0.89 ± 41%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread
      0.00            +0.9        0.89 ± 41%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      0.00            +0.9        0.90 ± 40%  perf-profile.calltrace.cycles-pp.kfree_rcu_monitor.process_one_work.worker_thread.kthread.ret_from_fork
      1.46            +0.9        2.37        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.00            +0.9        0.93 ± 27%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +0.9        0.94 ± 27%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      1.59            +0.9        2.53        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      1.64            +1.0        2.62        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.62            +1.0        2.61        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.67            +1.0        2.69        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      1.72            +1.1        2.78        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.10 ±223%      +1.1        1.21 ± 20%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.3        1.31 ± 22%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc
      0.00            +1.3        1.32 ± 22%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +1.4        1.36 ± 21%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.84 ± 29%      +1.4        2.21 ± 19%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.84 ± 29%      +1.4        2.22 ± 19%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +1.4        1.43 ±  4%  perf-profile.calltrace.cycles-pp.setup_object.shuffle_freelist.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk
      0.18 ±141%      +1.4        1.62 ± 17%  perf-profile.calltrace.cycles-pp.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.32            +1.4        3.77        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.29            +1.5        3.75        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      1.95            +1.6        3.60        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      2.61            +1.7        4.26        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     21.75            +2.2       23.97        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     22.06            +2.4       24.45        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.44            +2.5        6.97        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
     22.55            +2.7       25.24        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     22.55            +2.7       25.25        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     22.79            +2.8       25.64        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     22.86            +2.9       25.75        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      4.99            +2.9        7.90        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.52 ± 12%      +3.0        4.52 ± 10%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      5.16            +3.1        8.23        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.28 ± 11%      +3.1        5.37 ± 10%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     24.00            +4.1       28.12        perf-profile.calltrace.cycles-pp.__munmap
      7.86            +4.8       12.64        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      9.26            +5.5       14.77        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      6.08 ±  2%      +5.6       11.69        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf
      6.12 ±  2%      +5.6       11.75        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      6.23 ±  2%      +5.7       11.95        perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     10.17 ±  5%     +10.8       20.96 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     10.30 ±  5%     +10.9       21.21 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     11.14 ±  5%     +11.4       22.59 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     19.22 ±  3%     +17.1       36.29        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     19.22 ±  3%     +17.1       36.29        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     19.22 ±  3%     +17.1       36.30        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     19.22 ±  3%     +17.1       36.30        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     19.23 ±  3%     +17.1       36.30        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     18.15 ±  4%     +17.5       35.63        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     17.71 ±  4%     +17.6       35.29 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     20.07 ±  3%     +18.5       38.52        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     20.07 ±  3%     +18.5       38.52        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     20.07 ±  3%     +18.5       38.52        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     44.78           -28.9       15.91 ±  4%  perf-profile.children.cycles-pp.__mmap_new_vma
     32.47           -25.2        7.32 ±  9%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
     32.68           -25.1        7.61 ±  9%  perf-profile.children.cycles-pp.mas_alloc_nodes
     33.34           -24.8        8.57 ±  8%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     51.24           -24.7       26.50 ±  2%  perf-profile.children.cycles-pp.__mmap_region
     33.20           -24.7        8.49 ±  7%  perf-profile.children.cycles-pp.mas_preallocate
     53.16           -23.6       29.60        perf-profile.children.cycles-pp.do_mmap
     53.57           -23.3       30.27        perf-profile.children.cycles-pp.vm_mmap_pgoff
     24.48           -23.1        1.35 ± 10%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
     53.94           -23.1       30.86        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     55.80           -21.9       33.88        perf-profile.children.cycles-pp.__mmap
     62.11           -21.3       40.84        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     61.66           -21.2       40.48        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     77.09           -20.0       57.08        perf-profile.children.cycles-pp.do_syscall_64
     77.22           -19.9       57.30        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     16.93           -16.9        0.08 ± 16%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
     14.01           -12.9        1.15 ±  7%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
     14.32           -12.7        1.60 ±  7%  perf-profile.children.cycles-pp.kvfree_call_rcu
     19.38           -10.1        9.28        perf-profile.children.cycles-pp.mas_wr_node_store
     10.14            -4.8        5.31        perf-profile.children.cycles-pp.mas_store_prealloc
     10.82            -4.3        6.50        perf-profile.children.cycles-pp.mas_store_gfp
      2.23 ±  6%      -1.2        1.04 ± 10%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.97 ±  8%      -0.3        0.65 ± 13%  perf-profile.children.cycles-pp.barn_put_full_sheaf
      0.26            -0.1        0.20 ± 33%  perf-profile.children.cycles-pp.cmd_record
      0.35            -0.1        0.29 ±  2%  perf-profile.children.cycles-pp.current_time
      0.22 ±  2%      -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.perf_session__process_events
      0.22 ±  2%      -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.reader__read_event
      0.22 ±  2%      -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.record__finish_output
      0.16 ±  9%      -0.0        0.13 ± 12%  perf-profile.children.cycles-pp.ordered_events__queue
      0.22 ±  3%      -0.0        0.20 ±  2%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.sched_tick
      0.06            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.__account_obj_stock
      0.21            +0.0        0.23        perf-profile.children.cycles-pp.downgrade_write
      0.05            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.06 ±  6%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.refill_obj_stock
      0.06 ±  7%      +0.0        0.10        perf-profile.children.cycles-pp.mas_data_end
      0.05 ±  7%      +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.security_mmap_file
      0.15            +0.0        0.19 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.08            +0.0        0.12        perf-profile.children.cycles-pp.filemap_get_entry
      0.06            +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.mas_next_setup
      0.09 ±  7%      +0.0        0.14 ±  6%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.07 ±  6%      +0.0        0.12        perf-profile.children.cycles-pp.mas_prev_setup
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.___pte_offset_map
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.get_mmap_base
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.ima_file_mmap
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.mmap_region
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.vm_area_free
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.x64_sys_call
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.xas_load
      0.05            +0.1        0.10 ±  3%  perf-profile.children.cycles-pp.static_key_count
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.08            +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.memfd_check_seals_mmap
      0.02 ± 99%      +0.1        0.08        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.prepend
      0.08 ± 11%      +0.1        0.14 ±  6%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.07            +0.1        0.13        perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.unmap_single_vma
      0.11            +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.testcase
      0.40            +0.1        0.46 ±  2%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.__free_one_page
      0.09 ±  4%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.mas_prev_range
      0.56            +0.1        0.63        perf-profile.children.cycles-pp.atime_needs_update
      0.12 ±  3%      +0.1        0.19 ±  2%  perf-profile.children.cycles-pp.mas_wr_store_entry
      0.08 ±  6%      +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.update_process_times
      0.08 ±  5%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.uprobe_mmap
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.vma_wants_writenotify
      0.06            +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.mmap_action_complete
      0.09            +0.1        0.16 ±  2%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.12 ±  3%      +0.1        0.19 ±  3%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.00            +0.1        0.08 ±  6%  perf-profile.children.cycles-pp.cap_capable
      0.12 ±  4%      +0.1        0.19        perf-profile.children.cycles-pp.vma_mark_detached
      0.10 ± 11%      +0.1        0.18 ±  5%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.05            +0.1        0.13        perf-profile.children.cycles-pp.rmqueue_bulk
      0.00            +0.1        0.08        perf-profile.children.cycles-pp.make_vfsgid
      0.00            +0.1        0.08 ±  7%  perf-profile.children.cycles-pp.make_vfsuid
      0.05 ±  7%      +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.ktime_get
      0.06            +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.66            +0.1        0.75        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.00            +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.clockevents_program_event
      0.12            +0.1        0.21 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.12 ±  4%      +0.1        0.20 ±  3%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.18 ± 10%      +0.1        0.26 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock
      0.62            +0.1        0.70        perf-profile.children.cycles-pp.touch_atime
      0.17 ±  2%      +0.1        0.26        perf-profile.children.cycles-pp.may_expand_vm
      0.13            +0.1        0.22        perf-profile.children.cycles-pp.mas_prev
      0.15 ±  2%      +0.1        0.24        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.11 ± 20%      +0.1        0.20 ± 15%  perf-profile.children.cycles-pp.strlen
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.14 ±  8%      +0.1        0.23 ±  4%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.13 ±  3%      +0.1        0.22 ±  2%  perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      0.15            +0.1        0.25 ±  2%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.00            +0.1        0.10        perf-profile.children.cycles-pp.vm_stat_account
      0.24 ±  2%      +0.1        0.35        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.14            +0.1        0.24 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.17            +0.1        0.28        perf-profile.children.cycles-pp.freader_init_from_file
      0.33            +0.1        0.43        perf-profile.children.cycles-pp.down_write
      0.00            +0.1        0.11 ±  3%  perf-profile.children.cycles-pp.reclaim_pt_is_enabled
      0.79 ±  3%      +0.1        0.90 ±  4%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.17 ±  2%      +0.1        0.29 ±  2%  perf-profile.children.cycles-pp.prepend_copy
      0.14 ±  3%      +0.1        0.26        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.16            +0.1        0.28        perf-profile.children.cycles-pp.freader_get_folio
      0.23            +0.1        0.35        perf-profile.children.cycles-pp.up_read
      0.14 ±  3%      +0.1        0.26 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.37            +0.1        0.50 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.23 ±  4%      +0.1        0.36 ±  2%  perf-profile.children.cycles-pp.fget
      0.10 ±  4%      +0.1        0.24 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.10 ±  4%      +0.1        0.24        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.06            +0.1        0.20        perf-profile.children.cycles-pp.vma_set_page_prot
      0.84 ±  3%      +0.1        0.98 ±  3%  perf-profile.children.cycles-pp.mas_update_gap
      0.16            +0.1        0.30        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.23            +0.1        0.37        perf-profile.children.cycles-pp.fput
      0.16 ±  2%      +0.1        0.30        perf-profile.children.cycles-pp.remove_vma
      0.10 ±  4%      +0.1        0.25 ±  3%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.24 ±  3%      +0.1        0.39        perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.25            +0.2        0.40 ±  2%  perf-profile.children.cycles-pp.freader_fetch
      0.30 ±  7%      +0.2        0.46 ±  7%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.32            +0.2        0.50        perf-profile.children.cycles-pp.kfree
      0.17 ±  3%      +0.2        0.35        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.29            +0.2        0.47        perf-profile.children.cycles-pp.down_write_killable
      0.28            +0.2        0.46        perf-profile.children.cycles-pp.__vma_enter_locked
      0.33            +0.2        0.53        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.34            +0.2        0.56        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.36            +0.2        0.58 ±  2%  perf-profile.children.cycles-pp.mas_rev_awalk
      0.36            +0.2        0.58 ±  2%  perf-profile.children.cycles-pp.up_write
      0.38            +0.2        0.61        perf-profile.children.cycles-pp.perf_iterate_sb
      0.30 ±  2%      +0.2        0.55        perf-profile.children.cycles-pp.build_detached_freelist
      0.41            +0.3        0.67        perf-profile.children.cycles-pp.__vma_start_write
      0.46            +0.3        0.73        perf-profile.children.cycles-pp.mas_next_slot
      0.44 ±  2%      +0.3        0.70 ±  2%  perf-profile.children.cycles-pp.mas_wr_store_type
      0.53            +0.3        0.85        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.50            +0.3        0.82        perf-profile.children.cycles-pp.__build_id_parse
      0.58 ±  4%      +0.3        0.90 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free
      0.50            +0.3        0.84        perf-profile.children.cycles-pp.mas_prev_slot
      0.42            +0.3        0.76        perf-profile.children.cycles-pp.prepend_path
      0.58            +0.4        0.93        perf-profile.children.cycles-pp.mas_walk
      0.54 ±  2%      +0.4        0.91        perf-profile.children.cycles-pp.zap_pte_range
      0.83            +0.4        1.24        perf-profile.children.cycles-pp.vm_area_alloc
      0.71            +0.4        1.14        perf-profile.children.cycles-pp.rcu_all_qs
      0.56            +0.4        0.99        perf-profile.children.cycles-pp.d_path
      0.32 ±  3%      +0.4        0.76 ±  4%  perf-profile.children.cycles-pp.setup_object
      0.42 ±  3%      +0.5        0.93 ±  4%  perf-profile.children.cycles-pp.shuffle_freelist
      0.87            +0.5        1.40        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.26 ± 54%      +0.6        0.90 ± 40%  perf-profile.children.cycles-pp.kfree_rcu_monitor
      1.07            +0.7        1.73        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.54 ±  3%      +0.7        1.21 ±  4%  perf-profile.children.cycles-pp.allocate_slab
      0.56 ± 19%      +0.7        1.28 ± 15%  perf-profile.children.cycles-pp.kfree_rcu_work
      1.48 ±  8%      +0.7        2.20 ±  7%  perf-profile.children.cycles-pp.__irq_exit_rcu
      1.18            +0.7        1.90        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.20            +0.7        1.93        perf-profile.children.cycles-pp.vm_unmapped_area
      1.27            +0.8        2.04        perf-profile.children.cycles-pp.mas_find
      1.65 ±  7%      +0.8        2.48 ±  6%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.63 ±  7%      +0.8        2.46 ±  6%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.51            +0.9        2.40        perf-profile.children.cycles-pp.free_pud_range
      1.47            +0.9        2.39        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.59            +0.9        2.53        perf-profile.children.cycles-pp.free_p4d_range
      1.64            +1.0        2.63        perf-profile.children.cycles-pp.free_pgd_range
      1.62            +1.0        2.62        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      1.67            +1.0        2.69        perf-profile.children.cycles-pp.__get_unmapped_area
      1.73            +1.1        2.80        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.39 ± 27%      +1.2        1.63 ± 17%  perf-profile.children.cycles-pp.get_any_partial
      0.82 ± 29%      +1.3        2.16 ± 19%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.82 ± 29%      +1.3        2.16 ± 19%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.84 ± 29%      +1.4        2.21 ± 19%  perf-profile.children.cycles-pp.process_one_work
      2.34            +1.4        3.71        perf-profile.children.cycles-pp.__cond_resched
      0.84 ± 29%      +1.4        2.22 ± 19%  perf-profile.children.cycles-pp.worker_thread
      2.34            +1.5        3.80        perf-profile.children.cycles-pp.free_pgtables
      2.30            +1.5        3.77        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.62            +1.7        4.28        perf-profile.children.cycles-pp.perf_event_mmap
      3.04 ±  2%      +1.8        4.79        perf-profile.children.cycles-pp.__pi_memcpy
      0.75 ± 25%      +1.8        2.58 ± 20%  perf-profile.children.cycles-pp.get_partial_node
     21.76            +2.2       23.99        perf-profile.children.cycles-pp.do_vmi_align_munmap
     22.06            +2.4       24.46        perf-profile.children.cycles-pp.do_vmi_munmap
     22.55            +2.7       25.24        perf-profile.children.cycles-pp.__vm_munmap
     22.55            +2.7       25.25        perf-profile.children.cycles-pp.__x64_sys_munmap
      4.84            +2.7        7.58        perf-profile.children.cycles-pp.zap_pmd_range
      5.02            +3.0        7.97        perf-profile.children.cycles-pp.unmap_page_range
      1.53 ± 11%      +3.0        4.57 ± 10%  perf-profile.children.cycles-pp.___slab_alloc
      5.17            +3.1        8.24        perf-profile.children.cycles-pp.unmap_vmas
      2.28 ± 11%      +3.1        5.37 ± 10%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
     24.30            +3.8       28.06        perf-profile.children.cycles-pp.__munmap
      7.86            +4.8       12.65        perf-profile.children.cycles-pp.vms_clear_ptes
      9.29            +5.5       14.81        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      7.16            +6.5       13.71        perf-profile.children.cycles-pp.__put_partials
     12.04 ±  4%     +12.3       24.31 ±  2%  perf-profile.children.cycles-pp.__slab_free
     19.22 ±  3%     +17.1       36.30        perf-profile.children.cycles-pp.run_ksoftirqd
     19.23 ±  3%     +17.1       36.30        perf-profile.children.cycles-pp.smpboot_thread_fn
     20.70 ±  2%     +17.8       38.51        perf-profile.children.cycles-pp.rcu_do_batch
     20.70 ±  2%     +17.8       38.52        perf-profile.children.cycles-pp.rcu_core
     20.71 ±  2%     +17.8       38.54        perf-profile.children.cycles-pp.handle_softirqs
     19.00 ±  3%     +18.2       37.18        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     19.46 ±  3%     +18.2       37.69        perf-profile.children.cycles-pp.rcu_free_sheaf
     20.07 ±  3%     +18.5       38.52        perf-profile.children.cycles-pp.kthread
     20.07 ±  3%     +18.5       38.52        perf-profile.children.cycles-pp.ret_from_fork
     20.07 ±  3%     +18.5       38.52        perf-profile.children.cycles-pp.ret_from_fork_asm
     61.66           -21.2       40.48        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.46            -0.1        0.39        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.07 ±  6%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.rcu_free_sheaf
      0.22            -0.0        0.19        perf-profile.self.cycles-pp.atime_needs_update
      0.21 ±  2%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.10 ±  4%      -0.0        0.09        perf-profile.self.cycles-pp.current_time
      0.06 ±  6%      +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__account_obj_stock
      0.20 ±  2%      +0.0        0.22 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.05            +0.0        0.07        perf-profile.self.cycles-pp.touch_atime
      0.10 ±  3%      +0.0        0.12        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.09            +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.freader_fetch
      0.06 ±  6%      +0.0        0.08        perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.05            +0.0        0.08        perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.15 ±  3%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.06 ±  8%      +0.0        0.09        perf-profile.self.cycles-pp.mas_update_gap
      0.07 ±  5%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.mas_prev_setup
      0.05            +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.08 ±  6%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.d_path
      0.06            +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.mas_data_end
      0.06            +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.mas_next_range
      0.08 ±  4%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.09 ±  7%      +0.0        0.14 ±  6%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.05 ±  8%      +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.mas_next_setup
      0.08            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.07 ±  7%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.testcase
      0.05            +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.free_pgd_range
      0.08 ±  6%      +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.free_p4d_range
      0.06 ±  6%      +0.1        0.11 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mmap_region
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.prepend
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.setup_object
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.unmap_single_vma
      0.05            +0.1        0.10 ±  3%  perf-profile.self.cycles-pp.__filemap_get_folio_mpol
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.08            +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.02 ±141%      +0.1        0.07        perf-profile.self.cycles-pp.filemap_get_entry
      0.07            +0.1        0.12 ±  4%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.07 ±  5%      +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.mas_prev
      0.08            +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.__put_partials
      0.08 ±  6%      +0.1        0.13 ±  2%  perf-profile.self.cycles-pp.mas_prev_range
      0.08 ±  5%      +0.1        0.14        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.10 ±  3%      +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.mas_wr_store_entry
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.refill_obj_stock
      0.06            +0.1        0.12 ±  3%  perf-profile.self.cycles-pp.mmap_action_complete
      0.07 ±  5%      +0.1        0.13        perf-profile.self.cycles-pp.unmap_vmas
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.__free_one_page
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.do_vmi_munmap
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.freader_get_folio
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.uprobe_mmap
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.vma_wants_writenotify
      0.39            +0.1        0.46        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.08            +0.1        0.15 ±  3%  perf-profile.self.cycles-pp.__build_id_parse
      0.09            +0.1        0.16 ±  2%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.09 ±  4%      +0.1        0.16        perf-profile.self.cycles-pp.free_pgtables
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.make_vfsgid
      0.02 ±141%      +0.1        0.09 ±  5%  perf-profile.self.cycles-pp.static_key_count
      0.00            +0.1        0.07        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.cap_capable
      0.11 ±  3%      +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.11 ±  3%      +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.vma_mark_detached
      0.14            +0.1        0.22 ±  2%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.make_vfsuid
      0.11            +0.1        0.19        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.17 ±  9%      +0.1        0.25 ±  5%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.1        0.08 ±  8%  perf-profile.self.cycles-pp.ktime_get
      0.00            +0.1        0.08        perf-profile.self.cycles-pp.vm_get_page_prot
      0.00            +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.remove_vma
      0.12 ±  3%      +0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.29            +0.1        0.38        perf-profile.self.cycles-pp.down_write
      0.11 ± 18%      +0.1        0.20 ± 13%  perf-profile.self.cycles-pp.strlen
      0.16            +0.1        0.24 ±  2%  perf-profile.self.cycles-pp.may_expand_vm
      0.00            +0.1        0.08 ±  5%  perf-profile.self.cycles-pp.vma_set_page_prot
      0.28            +0.1        0.37        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.08 ±  6%      +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.16 ±  2%      +0.1        0.25        perf-profile.self.cycles-pp.do_syscall_64
      0.06            +0.1        0.15 ±  2%  perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.17 ±  2%      +0.1        0.26 ±  2%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.15            +0.1        0.24        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.16            +0.1        0.26        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.vm_stat_account
      0.15 ±  3%      +0.1        0.25 ±  2%  perf-profile.self.cycles-pp.do_mmap
      0.17 ±  2%      +0.1        0.27        perf-profile.self.cycles-pp.freader_init_from_file
      0.78 ±  3%      +0.1        0.88 ±  4%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.23 ±  2%      +0.1        0.34 ±  3%  perf-profile.self.cycles-pp.kvfree_call_rcu
      0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.reclaim_pt_is_enabled
      0.26            +0.1        0.37        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.25 ± 10%      +0.1        0.37 ±  7%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.23            +0.1        0.36        perf-profile.self.cycles-pp.fput
      0.22 ±  2%      +0.1        0.35        perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.24 ± 12%      +0.1        0.36 ±  9%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.22 ±  2%      +0.1        0.34        perf-profile.self.cycles-pp.up_read
      0.22 ±  3%      +0.1        0.35 ±  2%  perf-profile.self.cycles-pp.fget
      0.26            +0.1        0.40        perf-profile.self.cycles-pp.__mmap_new_vma
      0.16 ±  2%      +0.1        0.30        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.29            +0.1        0.43        perf-profile.self.cycles-pp.kfree
      0.25            +0.2        0.40        perf-profile.self.cycles-pp.down_write_killable
      0.25            +0.2        0.41        perf-profile.self.cycles-pp.zap_pte_range
      0.27 ±  2%      +0.2        0.43        perf-profile.self.cycles-pp.kmem_cache_free
      0.24            +0.2        0.40        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.26            +0.2        0.42        perf-profile.self.cycles-pp.__vma_enter_locked
      0.30 ±  2%      +0.2        0.47        perf-profile.self.cycles-pp.vm_area_alloc
      0.28            +0.2        0.46        perf-profile.self.cycles-pp.perf_iterate_sb
      0.08 ±  4%      +0.2        0.25 ±  3%  perf-profile.self.cycles-pp.get_partial_node
      0.29            +0.2        0.47 ±  2%  perf-profile.self.cycles-pp.mas_rev_awalk
      0.14 ±  2%      +0.2        0.32 ±  2%  perf-profile.self.cycles-pp.unmap_page_range
      0.32            +0.2        0.51        perf-profile.self.cycles-pp.perf_event_mmap
      0.32            +0.2        0.52        perf-profile.self.cycles-pp.__vm_munmap
      0.06 ±  7%      +0.2        0.26 ±  4%  perf-profile.self.cycles-pp.get_any_partial
      0.33            +0.2        0.52        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.36            +0.2        0.57        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.34            +0.2        0.54        perf-profile.self.cycles-pp.mas_store_prealloc
      0.32            +0.2        0.53        perf-profile.self.cycles-pp.mas_find
      0.37            +0.2        0.59        perf-profile.self.cycles-pp.__munmap
      0.29            +0.2        0.51        perf-profile.self.cycles-pp.build_detached_freelist
      0.32            +0.2        0.54        perf-profile.self.cycles-pp.mas_preallocate
      0.35            +0.2        0.57        perf-profile.self.cycles-pp.up_write
      0.39            +0.2        0.62        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.45            +0.2        0.68        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.41            +0.2        0.66        perf-profile.self.cycles-pp.__mmap
      0.28            +0.2        0.53        perf-profile.self.cycles-pp.prepend_path
      0.44            +0.3        0.70        perf-profile.self.cycles-pp.mas_next_slot
      0.42 ±  2%      +0.3        0.68 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.47            +0.3        0.78        perf-profile.self.cycles-pp.mas_prev_slot
      0.18 ±  2%      +0.3        0.51 ±  4%  perf-profile.self.cycles-pp.___slab_alloc
      0.55            +0.3        0.89        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.56            +0.3        0.90        perf-profile.self.cycles-pp.mas_walk
      0.60            +0.4        0.96        perf-profile.self.cycles-pp.rcu_all_qs
      0.74            +0.4        1.19        perf-profile.self.cycles-pp.mas_store_gfp
      0.38 ±  4%      +0.5        0.86 ±  4%  perf-profile.self.cycles-pp.shuffle_freelist
      0.87            +0.5        1.39        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.89 ±  2%      +0.5        1.42        perf-profile.self.cycles-pp.__slab_free
      1.16            +0.7        1.90        perf-profile.self.cycles-pp.mas_wr_node_store
      1.28            +0.8        2.05        perf-profile.self.cycles-pp.__cond_resched
      1.49            +0.9        2.36        perf-profile.self.cycles-pp.free_pud_range
      1.58            +1.1        2.67        perf-profile.self.cycles-pp.__mmap_region
      2.55            +1.3        3.88        perf-profile.self.cycles-pp.zap_pmd_range
      2.98 ±  2%      +1.7        4.68        perf-profile.self.cycles-pp.__pi_memcpy




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



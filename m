Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39139D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 07:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED4A6B0088; Mon, 29 Dec 2025 02:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5977D6B0089; Mon, 29 Dec 2025 02:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1B56B008A; Mon, 29 Dec 2025 02:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27E716B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 02:48:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE09E1A0D5E
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:48:44 +0000 (UTC)
X-FDA: 84271731768.17.A397CF8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B29D80003
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:48:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3g7j2TP;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766994521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kw+Oy1wEs+SPMKynHvjZ6GNsliUPCALnVqhxDpo/4Oc=;
	b=fha5liSugas4NvZbZdBciBBjlv3g++ajB0h7GDmszY8DgPaX6ZZbw44RFeJX5SNp1W2szq
	eJN/+r4BHwGuyuDXT0kb/gFzGl9si2HLq+UDrjOk4qmBJ7PFQN2dpB3F1+3hp8aOvzjM3a
	uLcpkgXIdhDKCYjtaq4OBTBNxCC16Z0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3g7j2TP;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766994521; a=rsa-sha256;
	cv=fail;
	b=WhDiNTBGM0xhKOHaWx6GiiH0zO+boIIZhqjKVvXaqsx5igaNJbQgZ2JRT6KllSYTt+Z7yk
	sG5q4JZGh7WY4oFf2sQq/9xc2D73kQUYvWiRNzp/b4TJz532EoodBMyeOZpd8czpW2UJMP
	MNObFdkrlUEGCasOs4DHMvSgrEp7Sw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766994521; x=1798530521;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=N0x/bBChvrzqVyWJsTi3ieWx+CbQ2P3OiSoCleG6nW4=;
  b=g3g7j2TPwL/bne0fx8wbBOaIF2wPdrreHpxil5NPoT2pl96jRPTMEKJK
   2e9dBk/gG7xZEPB5lv2+FkEPWJDXq5Foiz4sbwrn1VJPHw0V+iRdb0uGk
   WyctFwmVjAw9NxBN5vIGGxCbWdap4xm8XQ6SQjsHF8e4PbTKmuAaF1NLC
   6SFvCGJMHLS6MYkOrCe6t173q6n1RA3eO9wDT9U7N80XI8MjhCQYPkT8t
   Jyqxtb8WeWQT0jND+8H5r8AmcXtPBvxQw6UWauvT30Tlu/7ijoFFqYdqc
   hM7qaI02eVfrNrRIrn4h41JP9rXe2rGljF08ypVjTYXEzBA9pXMDu12ew
   g==;
X-CSE-ConnectionGUID: v1FCE4xIS8aeUuXblWkStw==
X-CSE-MsgGUID: i/Shqt+zRFK1mJJ170nSPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68542874"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68542874"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2025 23:48:39 -0800
X-CSE-ConnectionGUID: OVh7JJMaTRyhLt46GsuRsg==
X-CSE-MsgGUID: qoQwIL6eRmG4Bm8ksem0pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,185,1763452800"; 
   d="scan'208";a="200861764"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2025 23:48:39 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 28 Dec 2025 23:48:38 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 28 Dec 2025 23:48:38 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 28 Dec 2025 23:48:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6INkiKi/GXHT54uP4BZSSwjAmABoTDZn1T8KETJE9GcEJ5WFyuNn50zAwMIiK4DNMZ9BSqQ5EGie5KAAR5gdoFW9QGaSwbe7GopUPAOwJZfl7XmY9hM8YyLxICkPojfcT87y87tsEBAsYsXy4EMuZqtBZam4dtVb0lgbdYRIzIvtuVpy5ggoiMcXJBLmaqYnn0VJS/ZIR2B1S5ljRyJ8CrA/n/GOsSC55dTDUSsGmYMCYJchqAWTMKOaltnkChjsgX0zAcaJmCcm97fqpRgsduAPwxR9bQMkYlU7jyoCnHxI+PaoiZ6bOOXHW9kOQT+oZqgutEKIwk1lzvl2uvI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWQHSzdTgJUX94Qof36UZS0ipfT+B4nDykK9OYpImdo=;
 b=GozrIkMSOCHRyuEkFSObw2Nz/glUDpqQcLHNvK0jB3onZnE9jA6xGf4le8mK5JcsekyZpiXNBWGuzDmaCL1RJKQv1RVUunNV+xR+j1izJIg1yZ/9KkLrM8tnvoKukF50P+KX8ybuaKdl/WDVKX5/hy6x1pQa9abkbX90x1lXgpU94PNgEDX2WKzJ79VQ+OhUTQQrRn9djqUUqPLdyM8hu0AHPeCg4jxfSeKCPMy+OozRA3KQayVLg5rrpbhS7HEYbZktqolnN8O8yEAvyR8pPlPEVch4hlp36nrzVFil3cIMPGTlADs07dkLAuG3Euioyn2t01P31x+4S8m+MqQlQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CYYPR11MB8307.namprd11.prod.outlook.com (2603:10b6:930:ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Mon, 29 Dec
 2025 07:48:29 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 07:48:28 +0000
Date: Mon, 29 Dec 2025 15:48:20 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Hao Li <haolee.swjtu@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [slub]  58d6fcb6ee:
 will-it-scale.per_process_ops 57.3% improvement
Message-ID: <202512291555.56ce2e53-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CYYPR11MB8307:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bbb1687-3ff2-4172-2ebc-08de46aea7bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?XQHNVuIjGUgA4VSjpz5z0GTXImoJpPfxjWz4TbSvcC9OqnfqHSiK1laN/U?=
 =?iso-8859-1?Q?ThHKBH4Ui9DOD4l/qB+PBVtYTAPXnyHPRiuOTQUJZ3xSSKJ3uWxsOWBUc7?=
 =?iso-8859-1?Q?5yqjjXUXqdAi4oXI+3zBksu26ptsGnYnj5xh57mYNqD3T3msbDcSO3BQ1d?=
 =?iso-8859-1?Q?FGgcO0gXJ5eSZ1uJjFOH5eR7sO7mWV+e+4vNiaT91et3Tu+4enfCPBX3Sz?=
 =?iso-8859-1?Q?ydV1X7Rtwc9SU+fOh0h5IkseQxZ/BC5UTcTS8cP6xpR2deHqXDh5imQOWy?=
 =?iso-8859-1?Q?8IN8WiiiezvMX/vvNVCmUzSxE7qfpoyK2sW3A6JUgjarL3ux39ANMA/nNP?=
 =?iso-8859-1?Q?X+g3uXyOF1tvtVwdsPuuYNHFA0AsUEviKj3NUxyRDOcYV20MgF3nQG0vJV?=
 =?iso-8859-1?Q?cu/5kQb5UnrzqpekcZJ3OVuv5sUOd8xiOCu+dq+MKIsTDuOnKYZ6KvoyIL?=
 =?iso-8859-1?Q?OpQH+A4+orP1kNiHM5DfN6Qmw+4naP9/cGR5GmIlgWRl+ROc1sjJvy2jPj?=
 =?iso-8859-1?Q?lHcBdOP1swZDZOvwX6h+57UhjgskYC7rjpwi/CMrmQ25orqvOyvhnV6ZBf?=
 =?iso-8859-1?Q?loYZJrPSnfIofKEZDBVDUNIGSW5tEToTqqEO6/OB/4W/wTqxUMnwQwo79P?=
 =?iso-8859-1?Q?mVUP2+rBZYEAO18XQhJVb0h5wNVF3fNAqB3ZTpDBBxfwVVSvesHP1JlHyn?=
 =?iso-8859-1?Q?eo5+6ifdmPPDuKATIXiIWAt4i67pU8ahJOfjAJ5QhhGWRWsEPX5Wj5Cxlm?=
 =?iso-8859-1?Q?kqf/oldap1lvZyyz9cDFTcogRTaUW8frMtbTWn99uVPjZDxyihu5MPujAQ?=
 =?iso-8859-1?Q?m04nWqWYgNci9z6Oilar9EauM484MQ8E5Zz1bTobGj2TjcZ6tLfRtFOHzm?=
 =?iso-8859-1?Q?BIQsa8BhLoUwX3dYkKvunhdsptJmzXS/YuIlzaTbWvoVIOxKwqBD2uB/kD?=
 =?iso-8859-1?Q?OuYrm4TqZwAwxcfnSy8zrz01F5ccaphovNLJuijUSKYw3xHSRv+oo6+nHB?=
 =?iso-8859-1?Q?e/IXXDQgmREWE+v3Lt46zCNrBTNEvnAkl46SvJ36YjRXPmWiOtpgLr4NOu?=
 =?iso-8859-1?Q?ujje8j3X1/GvUGFVXH/lYTX3+SMJazc3bIAJ3VD1USJhutPmJw8D3RUhS+?=
 =?iso-8859-1?Q?ufyLKlRXgwU3TQkQh4PQzJFwdws+LK3pxWLj5f4Nyx5WvLxZEql/p/f+Ac?=
 =?iso-8859-1?Q?g+liXqZZP3UMyqWHhE/rm45ZqbfQ3S/vt1RKLUlISJaB+1CsFOPYufqOi8?=
 =?iso-8859-1?Q?8+hQ4elOG5WkFHPL3nyrbY1ArPp3nK+BEm/I2lG18BcOB0TRmuxO2uPjfm?=
 =?iso-8859-1?Q?XuFGXgUOnlSXbcgj8YCKYcG05S+jA+v01iVNf0inG43bLZwlr+BPWMPlJD?=
 =?iso-8859-1?Q?pOVdfQ2Y6ZtpkV7Nk6ybCziFAcxyKGBaaB4ROYpBGxDNXpmZSJx94URLnL?=
 =?iso-8859-1?Q?ILOTtnuaBjgOwkftsGkRSTCYUvYT8AmSWAGx1mC+aTLUyzGjbNqELElKY5?=
 =?iso-8859-1?Q?wUcNzE57oZwEe36HX7+O+7240MKUmEHAWzodaMzcdFGg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fTlaLR/WmKpCWpKqIhJiRP4MEu7IrQxQh1eS5XXAUKwcfdsOmcVdumHReL?=
 =?iso-8859-1?Q?IAEAXW9o0IhBEyckpjJgblERp9ov11xjg6HW55yOkk68sGScLo3eIkMMSK?=
 =?iso-8859-1?Q?s4+MLpWztJcqiBFCTNr5k3Ci6SipuEVz9iJLYYjEy1JOtv00rsE+RyqPUr?=
 =?iso-8859-1?Q?E6K3FW/08C6CM3tCpYMg6mg3FUalF/3hx0jLWPMCgVW9eflZCQRj1GrsKO?=
 =?iso-8859-1?Q?MOdDdT4ysJp/uDxnFtjTP63xrEic+oZKF/ZXDWJiQzhJHCFPxp91UC482z?=
 =?iso-8859-1?Q?XC/RU6cuyQvyiflmtEGLfm+leyEaCMB+4vMYPWUm38oISFtt0ANb08yJ+/?=
 =?iso-8859-1?Q?b20GwEYIYoZf72WXLSklnX4FceMEVicfaJr0DvzP+jeO2uLL7CnesFvcAX?=
 =?iso-8859-1?Q?QBd12bLdjv9TFAcsOPkP8yYUjCZY3nNFcbVbS1DzcHgLeA1ZPxBZ+gz5/F?=
 =?iso-8859-1?Q?1o9a2GLYUYMHQWPRUxXB3BVL9e4yoDRe44zNn7rLvLSl8ScGmniWjTL4CJ?=
 =?iso-8859-1?Q?1+lYCDkpXPY2WEz+s8UJ1xUV0e04SKyTsrK8vjsabSjTPHMlBKruPmlpQ3?=
 =?iso-8859-1?Q?dMvqgPcc4KCveZSjlvsSuqLwwNRtZ23Q2CTwcxT1BA4lMn3/SWWLJayE2u?=
 =?iso-8859-1?Q?XTaPTVC7Sfr8kIP6xjKYeFntqQsko6engdhoIafzAvIJUeePpEb3+fn4yS?=
 =?iso-8859-1?Q?cw1fn1NcbvuAQmLQ7MrjvbHOyk/yMdBbM56ZXkwzKuebaNGKprvTEodrva?=
 =?iso-8859-1?Q?jbOEm3ZTgPZ+ZlGVcbikRvKx1ZARMT8GWst/nX/jGIIbIyVbZHdKxgYBxG?=
 =?iso-8859-1?Q?vbAQbNDZ92oUdx9iPyyuV4SYbLI+H/udAOo7k5mIohJYM0lsuIZbrs1gia?=
 =?iso-8859-1?Q?wZurBi2ObsQoqm3MTOKfFMHqsBEzNpKDSNiODgdxuSamuSHRD7BZnA25pC?=
 =?iso-8859-1?Q?XXMJB9mqSI2XiM155cLfkLZXATAdJtNIqZVH/aqrZaxd+Me7+W7WV2HjJ5?=
 =?iso-8859-1?Q?5lhrgARKP9ItqzZxd6gisZU72batHV15dgmfQnbvPr7Z/sG0+91u9wVfE0?=
 =?iso-8859-1?Q?VUy0HjfF9hyKvutS7xs4icOWmpeA8kes6OjGZAFLejKCD3bl5pnhxP4p/D?=
 =?iso-8859-1?Q?HBQgtu1L6u99FdLuSSodtpL6/xbmnD+X9qeBz03STOnGcoYMNPNQA7ZfW5?=
 =?iso-8859-1?Q?pD3NnlWSKP4Z1SvqGNkyZzQ0ugow2T4b8Ty19IdFDsnyPOSKnNAV7EXXxf?=
 =?iso-8859-1?Q?zjCcXC4wRf2gAEEt4bPXaX9BKf/xqYTSNy/+jsUKwyv14WjS7oRHOC4lWC?=
 =?iso-8859-1?Q?n/5qSW4/ZefrWnjMiIwJERsN+7uxBtO4gbwFQG2iS8Lpv8wJQMnoPOo0TA?=
 =?iso-8859-1?Q?TzPqp9K3Lc31dEgyhdDUwPDalgcvD2Hm+3/MbVi+vZ/bmIIr5Ts4qvqU9J?=
 =?iso-8859-1?Q?FfdPtCEO4Lq0bwT9Jr6yN5dJDZQwCtTT2BlTRldKbJ5CoW/Vyf3Nu6pDbd?=
 =?iso-8859-1?Q?Tp+0UIo3G3NtAikkffJ3Chd6wznkanmmmagD4yWqNvLBzzxNUM1EZmfMzY?=
 =?iso-8859-1?Q?oXkcQJS3UvO5vta3msOCyfx2qq7ScBhKsCvEbKGm3xW2ruXvbfCi3+Cho9?=
 =?iso-8859-1?Q?qlxRhr3YN/k1NWB5bu8Rbm59NpNpPZ9g4qFCMRtwIORr2oUomHIB/JuTdb?=
 =?iso-8859-1?Q?xuvru12rj6zXKN1Ez1A0VgqYDqbvh+vFMC3ejqWYkM+R3/Tdlc3eYnJjsu?=
 =?iso-8859-1?Q?yi94kIuRAcxK+EeQSdvzpuFNOWot8AoDGQTquDT3oknM9Jfr158PJlJaYn?=
 =?iso-8859-1?Q?mB09Nro9XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbb1687-3ff2-4172-2ebc-08de46aea7bf
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 07:48:28.8973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1XksPBJIj3UG+Ifxnr/giZbjRMPX/xIMZsgKnk49tq+rRtjdQNpFM+aXn1xiijx1zeYQkkc8STZr0Q1BhfFtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8307
X-OriginatorOrg: intel.com
X-Stat-Signature: rnameyxsgzum6yk8ri4yzy3gm398zcz6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B29D80003
X-HE-Tag: 1766994520-38570
X-HE-Meta: U2FsdGVkX18Z8R5ZHbRjFMTlIYEKjXjYLI6Ay/VcjfnMekdm2PBdQ6wqV631E7KK4S4viNj+cXyvGk0ar2F0/lw2iohayOzn4UlphCm5ftbIPEAJ+gmLPmnvXeS2YPmfl6sPSZaZlHnQAlerqPburay+kq0LdUQbiCcRPWOhASUglC3vx7KIEHGKqzR7AYWk9i6QN+p7tefmFmCc1/eSGpe9yr6oHrqwaHzKxAHNpuKmh2kAdUK3NMKT3QU3PDrGM5k4ZeZsvFaynAYiYlQ0fTuSfLbjx2w+GO2V9RrKpQv2I8gZY4mposv3brNk3TGm27kKAL4jILaKhD2jfF6236KEhbsDtbbDr5SdGX+l2QPio5usyroUp9H2pRpK/Y51lLRQGBTwZg9O9EdakWDtb/KdYthVC/11PPOJN4JF7pxKGJg4oLvtuajQA5fw7Ms47aCviMQoBvSc27RWiMcA1cgnMsnR8mLwrxSPJQzStDXN25jQK32D7/+Z7iPUeMlUdyq3Z9AwKedKCWKoMwaNcc12Kv9BjqqZHNiTtPVIsK9JqOICDbOu6QqCVSzQLhu6GtKH5W9QnXtTk+PV31wJDHmFpV8kYSSMvymeBHK5pfYf3QymP3lri8tQNlze7Lf3U/DoBIKyPLxPpz1UGWUvizh5thmJsta+jylHg7O2WdbQPquE75GEqCXUPM34xZ+mWszOG+5W0Vdq9ntbOmX6styfEX57OTfZD26dTrWwS67lO6yyNxSXf5Otyt9ya3y3Vo0bbbcN21pj5lp8Ltyb305wVsarz45FKQ4lvDBzaM7Md1E4LmcGCnsxRB/EHhU9iFXTd5rMP75787yym9HYOERtET45m1hNE6Scf+eHIBBfI9kwnX/+TeGMrt1t01I+qmAtEsUNPIPiIMPkOnGyRxIIpJc/LyYQfIOtanaeubJFjaZVHtckYzcsVGbT1RUf76ox1l2lbr4aXOp/3nB
 jlfDY6lg
 LIl9lTGj1E1pRQkf/ZERH5fNkQ7UjsAbBx/1EieisEvloDlVIeT2REXtrJ1RvQyqQFuH9jdZZ3crI17a4P2MEMJFdfTnltoytlzMqwRqG6nUPc0zDviyvzB7mGeVa/zlp20ZMwUCodFGVCcS0iElHdF1/I8TLiFtNPcbHDJD3w9P7v3LdLjVo1IhqrNbglObRwI5eubWG4Ougru5wyYZVDN2ImNVYbyAUM7BQVy+VVoSFmcAQFMbO52SZZOGVW24O2fkWKvT082kRWrfe6zH3REnlVTmheUERSZFe7MpEhL0nSPgba/JFcol7EGXKMAE2fs51Cvlj0xZpYNy35OlvCdNvfInTdLUTAkSu+9eIh7NyQ2kt1SnTYK5NkQbCWsw7VtNb07wbWe9YI34mI7U43i3ufZG3tuebwr99ZHKqvSBrKbmNKOHktEax+Mx2yMxzachJOzV893MK1ZqMdoxV3JplSui3QiRV/PNeQbRMossoKHk+v5UgfH8tIV/8hhe+WuamArak0tTskMiSyiIkTnNYXU7BKmpyQfnBnUim3j/eXVhSFsjCpnRFEnlzwQefTcT2kkr1WMf0DUUE0wGoDDb42CtKAoRkOuMgur6krfXIlKOe/X5OmELErVjAy41x4ZEp5OuoJhbCFnpacheA1PixklCcnkw8XWRNJANhqiVA26rRV+pczYhBd1HaYDCg7nZXxfQdtKoBX2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 57.3% improvement of will-it-scale.per_process_ops on:


commit: 58d6fcb6ee9432e5584e8845be23a1e805c65711 ("slub: keep empty main sheaf as spare in __pcs_replace_empty_main()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


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
https://download.01.org/0day-ci/archive/20251229/202512291555.56ce2e53-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  v6.19-rc1
  58d6fcb6ee ("slub: keep empty main sheaf as spare in __pcs_replace_empty_main()")

       v6.19-rc1 58d6fcb6ee9432e5584e8845be2 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    185.10           +48.2%     274.36        boot-time.boot
     35096           +48.8%      52233        boot-time.idle
    111.19 ±  4%    +438.6%     598.81 ±148%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    111.19 ±  4%    +438.6%     598.81 ±148%  perf-sched.total_sch_delay.max.ms
    521.64           +18.0%     615.41        uptime.boot
     41548           +41.5%      58807        uptime.idle
      1975 ±  7%     -37.9%       1226 ± 10%  perf-c2c.DRAM.local
     71970 ± 10%     -48.8%      36878 ±  8%  perf-c2c.HITM.local
     72620 ± 10%     -48.3%      37563 ±  8%  perf-c2c.HITM.total
  32494352           +57.3%   51119964        will-it-scale.192.processes
    169240           +57.3%     266249        will-it-scale.per_process_ops
  32494352           +57.3%   51119964        will-it-scale.workload
      0.16 ±  2%      +0.1        0.28 ±  2%  mpstat.cpu.all.irq%
     21.36           +15.6       36.99        mpstat.cpu.all.soft%
     75.68           -17.0       58.67        mpstat.cpu.all.sys%
      2.25            +1.0        3.29        mpstat.cpu.all.usr%
 1.276e+08           +71.8%  2.192e+08        numa-numastat.node0.local_node
 1.277e+08           +71.8%  2.194e+08        numa-numastat.node0.numa_hit
 1.246e+08 ±  2%     +76.7%    2.2e+08        numa-numastat.node1.local_node
 1.247e+08 ±  2%     +76.5%  2.201e+08        numa-numastat.node1.numa_hit
      3201            -1.2%       3162        turbostat.Bzy_MHz
      0.81           +54.9%       1.26        turbostat.IPC
    454.86            +3.4%     470.14        turbostat.PkgWatt
     24.29           +15.9%      28.14        turbostat.RAMWatt
   7700420 ±  3%      -9.0%    7003587 ±  2%  vmstat.memory.cache
    217.06           +16.8%     253.46 ±  2%  vmstat.procs.r
      9010 ±  4%     +28.7%      11594 ±  4%  vmstat.system.cs
    251847            +1.5%     255551        vmstat.system.in
   1632312 ±  4%     +19.1%    1944509 ±  3%  numa-meminfo.node0.SUnreclaim
   1713659 ±  3%     +18.8%    2036158 ±  3%  numa-meminfo.node0.Slab
   4487462 ±  6%     -19.9%    3592384 ±  9%  numa-meminfo.node1.Active
   4487080 ±  6%     -19.9%    3591998 ±  9%  numa-meminfo.node1.Active(anon)
   1542455 ±  5%     +17.2%    1807566 ±  3%  numa-meminfo.node1.SUnreclaim
   3766051 ±  8%     -17.6%    3102969 ±  5%  numa-meminfo.node1.Shmem
   1620974 ±  5%     +15.6%    1874484 ±  3%  numa-meminfo.node1.Slab
   4733275 ±  5%     -14.4%    4051072 ±  4%  meminfo.Active
   4732505 ±  5%     -14.4%    4050294 ±  4%  meminfo.Active(anon)
    446865           +21.5%     542942        meminfo.AnonHugePages
   7537436 ±  3%      -9.2%    6840991 ±  2%  meminfo.Cached
      1413           +53.3%       2167 ±  8%  meminfo.Mlocked
   3179279 ±  5%     +20.1%    3817685 ±  2%  meminfo.SUnreclaim
   3870878 ±  6%     -18.1%    3170028 ±  5%  meminfo.Shmem
   3339150 ±  5%     +19.1%    3976257 ±  2%  meminfo.Slab
    402811 ±  4%     +20.8%     486536 ±  2%  numa-vmstat.node0.nr_slab_unreclaimable
 1.277e+08           +71.8%  2.194e+08        numa-vmstat.node0.numa_hit
 1.276e+08           +71.8%  2.192e+08        numa-vmstat.node0.numa_local
   1121644 ±  6%     -20.0%     897797 ±  9%  numa-vmstat.node1.nr_active_anon
    941402 ±  8%     -17.6%     775538 ±  5%  numa-vmstat.node1.nr_shmem
    379694 ±  4%     +17.5%     446057 ±  2%  numa-vmstat.node1.nr_slab_unreclaimable
   1121643 ±  6%     -20.0%     897797 ±  9%  numa-vmstat.node1.nr_zone_active_anon
 1.247e+08 ±  2%     +76.5%  2.201e+08        numa-vmstat.node1.numa_hit
 1.246e+08 ±  2%     +76.6%    2.2e+08        numa-vmstat.node1.numa_local
   1182803 ±  5%     -14.4%    1012265 ±  4%  proc-vmstat.nr_active_anon
    216626            +2.1%     221261        proc-vmstat.nr_anon_pages
   1884027 ±  3%      -9.2%    1709927 ±  2%  proc-vmstat.nr_file_pages
  60556917            -1.4%   59707612        proc-vmstat.nr_free_pages_blocks
    352.63           +53.6%     541.57 ±  8%  proc-vmstat.nr_mlock
    967386 ±  6%     -18.1%     792186 ±  5%  proc-vmstat.nr_shmem
    779336 ±  3%     +19.6%     931859 ±  2%  proc-vmstat.nr_slab_unreclaimable
   1182803 ±  5%     -14.4%    1012265 ±  4%  proc-vmstat.nr_zone_active_anon
 2.524e+08           +74.1%  4.395e+08        proc-vmstat.numa_hit
 2.522e+08           +74.2%  4.393e+08        proc-vmstat.numa_local
 1.016e+09           +75.9%  1.787e+09        proc-vmstat.pgalloc_normal
   1121157 ±  4%      -5.0%    1065403        proc-vmstat.pgfault
 1.015e+09           +76.0%  1.786e+09        proc-vmstat.pgfree
  23658761           -20.8%   18727653        sched_debug.cfs_rq:/.avg_vruntime.avg
  24149238           -19.4%   19454877        sched_debug.cfs_rq:/.avg_vruntime.max
  19420917 ±  4%     -22.8%   14998076 ±  7%  sched_debug.cfs_rq:/.avg_vruntime.min
    190.99 ± 17%    +133.4%     445.73 ± 20%  sched_debug.cfs_rq:/.load_avg.avg
      1934 ± 29%     +66.6%       3223 ± 20%  sched_debug.cfs_rq:/.load_avg.max
     22.08 ± 42%     +87.0%      41.31 ± 21%  sched_debug.cfs_rq:/.load_avg.min
    286.28 ± 27%     +94.0%     555.33 ± 22%  sched_debug.cfs_rq:/.load_avg.stddev
      1007 ±  3%     +14.4%       1152 ±  3%  sched_debug.cfs_rq:/.runnable_avg.avg
    171.69 ± 14%     +48.8%     255.52 ± 10%  sched_debug.cfs_rq:/.runnable_avg.stddev
  23645988           -20.8%   18718604        sched_debug.cfs_rq:/.zero_vruntime.avg
  24139005           -19.5%   19443224        sched_debug.cfs_rq:/.zero_vruntime.max
  19410038 ±  4%     -22.8%   14990124 ±  7%  sched_debug.cfs_rq:/.zero_vruntime.min
    367230           +24.4%     456661        sched_debug.cpu.clock.avg
    367285           +24.4%     456728        sched_debug.cpu.clock.max
    367181           +24.4%     456590        sched_debug.cpu.clock.min
    364970           +24.2%     453319        sched_debug.cpu.clock_task.avg
    365542           +24.4%     454629        sched_debug.cpu.clock_task.max
    358058           +24.9%     447298        sched_debug.cpu.clock_task.min
    645.55 ±  3%     +73.5%       1119 ±  7%  sched_debug.cpu.clock_task.stddev
      0.00 ±  5%     +14.3%       0.00 ±  5%  sched_debug.cpu.next_balance.stddev
      8527 ±  2%     +21.7%      10376 ±  3%  sched_debug.cpu.nr_switches.avg
      4228 ±  4%      -9.2%       3837 ±  2%  sched_debug.cpu.nr_switches.min
    367179           +24.4%     456589        sched_debug.cpu_clk
    366921           +24.4%     456332        sched_debug.ktime
    367455           +24.4%     457157        sched_debug.sched_clk
  1.09e+11           +52.4%  1.661e+11        perf-stat.i.branch-instructions
      0.09            -0.0        0.08 ±  2%  perf-stat.i.branch-miss-rate%
  93819558           +35.9%  1.275e+08        perf-stat.i.branch-misses
     68.44           +15.7       84.15        perf-stat.i.cache-miss-rate%
 3.748e+08           +54.2%   5.78e+08        perf-stat.i.cache-misses
 5.478e+08           +25.2%  6.856e+08        perf-stat.i.cache-references
      8905 ±  4%     +25.1%      11140 ±  4%  perf-stat.i.context-switches
      1.23           -34.9%       0.80        perf-stat.i.cpi
 6.112e+11            -1.2%  6.039e+11        perf-stat.i.cpu-cycles
    382.97 ±  2%     +29.8%     497.06 ±  2%  perf-stat.i.cpu-migrations
      1627           -35.8%       1045        perf-stat.i.cycles-between-cache-misses
 4.982e+11           +52.9%  7.619e+11        perf-stat.i.instructions
      0.82           +54.4%       1.26        perf-stat.i.ipc
      0.09            -0.0        0.08        perf-stat.overall.branch-miss-rate%
     68.38           +15.8       84.23        perf-stat.overall.cache-miss-rate%
      1.23           -35.3%       0.79        perf-stat.overall.cpi
      1630           -35.9%       1045        perf-stat.overall.cycles-between-cache-misses
      0.82           +54.6%       1.26        perf-stat.overall.ipc
   4646266            -1.6%    4572212        perf-stat.overall.path-length
 1.086e+11           +51.9%   1.65e+11        perf-stat.ps.branch-instructions
  93426873           +35.5%  1.266e+08        perf-stat.ps.branch-misses
 3.734e+08           +53.9%  5.745e+08        perf-stat.ps.cache-misses
 5.461e+08           +24.9%  6.821e+08        perf-stat.ps.cache-references
      8865 ±  4%     +26.1%      11177 ±  4%  perf-stat.ps.context-switches
 6.088e+11            -1.4%  6.006e+11        perf-stat.ps.cpu-cycles
    377.46 ±  2%     +30.0%     490.56 ±  2%  perf-stat.ps.cpu-migrations
 4.964e+11           +52.5%  7.569e+11        perf-stat.ps.instructions
      3275 ±  5%      -7.3%       3036        perf-stat.ps.minor-faults
      3276 ±  5%      -7.3%       3036        perf-stat.ps.page-faults
  1.51e+14           +54.8%  2.337e+14        perf-stat.total.instructions
     43.56           -27.5       16.10        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     31.52           -24.3        7.24 ±  3%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     31.72           -24.2        7.52 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
     31.74           -24.2        7.56 ±  3%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     49.74           -24.0       25.78        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     32.27           -23.8        8.43 ±  2%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     51.69           -22.6       29.09        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     52.08           -22.3       29.75        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     52.45           -22.1       30.34        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     52.76           -21.9       30.85        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     52.82           -21.8       30.98        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     54.11           -20.5       33.62        perf-profile.calltrace.cycles-pp.__mmap
     16.36 ±  2%     -16.4        0.00        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     16.25 ±  2%     -16.3        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     16.12 ±  2%     -16.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.88           -12.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
     12.84           -12.8        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
     10.90           -10.2        0.70 ±  8%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     10.70           -10.1        0.62 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     10.66           -10.0        0.62 ±  8%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      6.70            -6.7        0.00        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      6.69            -6.7        0.00        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      6.90            -6.3        0.62 ±  7%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      6.87            -6.3        0.62 ±  5%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      7.01            -6.2        0.79 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      7.00            -6.2        0.79 ±  4%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      9.49            -4.7        4.82        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      9.56            -4.6        4.95        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      9.94            -4.4        5.58        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     10.31            -4.3        6.05        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.97 ±  7%      -0.8        1.14 ±  9%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      1.69 ±  7%      -0.8        0.93 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.67 ±  7%      -0.8        0.92 ± 10%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.72 ±  8%      -0.2        0.49 ± 45%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      0.56            +0.1        0.70        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.71            +0.1        0.85        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.64            +0.3        0.90        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.58            +0.3        0.86        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.53            +0.3        0.81        perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.51            +0.3        0.86        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.52            +0.4        0.93        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      0.75            +0.5        1.21        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.00            +0.5        0.51        perf-profile.calltrace.cycles-pp.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.00            +0.5        0.54 ±  3%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.6        0.56 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.6        0.58 ±  2%  perf-profile.calltrace.cycles-pp.prepend_path.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.00            +0.6        0.60        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.54 ±  3%      +0.7        1.20        perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.7        0.66        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.00            +0.7        0.66        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.09 ±223%      +0.7        0.76 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.7        0.68        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.7        0.68 ± 10%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread
      0.00            +0.7        0.68 ± 10%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      0.00            +0.7        0.69 ± 10%  perf-profile.calltrace.cycles-pp.kfree_rcu_monitor.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.69        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.00            +0.7        0.72        perf-profile.calltrace.cycles-pp.rcu_all_qs.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas
      0.00            +0.7        0.72        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      2.18            +0.7        2.91        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.38 ± 71%      +0.8        1.16 ±  6%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread
      0.38 ± 71%      +0.8        1.16 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread.kthread
      0.38 ± 71%      +0.8        1.16 ±  6%  perf-profile.calltrace.cycles-pp.kfree_rcu_work.process_one_work.worker_thread.kthread.ret_from_fork
      1.14            +0.8        1.92        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      1.16            +0.8        1.96        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      0.00            +0.9        0.87 ± 11%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +0.9        0.87 ± 11%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      1.44            +1.0        2.39        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.62            +1.0        2.64        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      1.47            +1.0        2.52        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.46            +1.1        2.54        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.78            +1.1        2.87        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      1.59            +1.1        2.69        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.87            +1.1        2.98        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.00            +1.1        1.10 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc
      0.00            +1.1        1.11 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk
      1.64            +1.1        2.77        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.00            +1.1        1.15 ±  5%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +1.2        1.16 ±  7%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.70 ± 50%      +1.2        1.88 ±  5%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.71 ± 50%      +1.2        1.89 ±  5%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      2.52            +1.2        3.71        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      0.00            +1.4        1.41 ±  4%  perf-profile.calltrace.cycles-pp.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.84            +1.4        4.27        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.00            +1.4        1.45        perf-profile.calltrace.cycles-pp.setup_object.shuffle_freelist.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk
      2.82            +1.5        4.28        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.86            +1.7        3.61        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
     22.65            +1.9       24.52        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     22.96            +2.0       25.00        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     23.44            +2.3       25.80        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     23.45            +2.4       25.81        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     23.69            +2.5       26.20        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     23.76            +2.6       26.32        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      4.37            +2.7        7.02        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      4.88            +2.9        7.80        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      5.12            +2.9        8.05        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.30 ±  7%      +3.0        4.30 ±  3%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.96 ±  8%      +3.2        5.13 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     25.08            +3.6       28.72        perf-profile.calltrace.cycles-pp.__munmap
      8.43            +4.5       12.97        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      9.68            +5.2       14.89        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      6.08            +5.5       11.61        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf
      6.11            +5.6       11.67        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      6.22            +5.6       11.87        perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     10.60 ±  3%     +10.3       20.89        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     10.74 ±  3%     +10.4       21.15        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     11.65 ±  3%     +11.0       22.62        perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     19.63           +16.7       36.37        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     19.64           +16.7       36.37        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     19.64           +16.7       36.38        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     19.64           +16.7       36.38        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     19.64           +16.7       36.38        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     18.22 ±  2%     +16.9       35.11        perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     18.66 ±  2%     +17.0       35.62        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     20.42           +17.9       38.27        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     20.42           +17.9       38.27        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     20.42           +17.9       38.27        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     43.58           -27.5       16.12        perf-profile.children.cycles-pp.__mmap_new_vma
     31.52           -24.3        7.24 ±  3%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
     31.74           -24.2        7.56 ±  3%  perf-profile.children.cycles-pp.mas_alloc_nodes
     49.78           -23.9       25.83        perf-profile.children.cycles-pp.__mmap_region
     32.34           -23.9        8.48 ±  2%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     32.27           -23.8        8.44 ±  2%  perf-profile.children.cycles-pp.mas_preallocate
     24.30           -22.8        1.48 ±  8%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
     51.69           -22.6       29.10        perf-profile.children.cycles-pp.do_mmap
     52.09           -22.3       29.76        perf-profile.children.cycles-pp.vm_mmap_pgoff
     52.46           -22.1       30.34        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     54.37           -20.8       33.53        perf-profile.children.cycles-pp.__mmap
     61.27           -20.8       40.44        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     60.82           -20.8       40.07        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     76.50           -19.4       57.15        perf-profile.children.cycles-pp.do_syscall_64
     76.63           -19.3       57.37        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     16.52 ±  2%     -16.4        0.08 ±  8%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
     13.77           -12.5        1.24 ±  6%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
     14.09           -12.4        1.68 ±  4%  perf-profile.children.cycles-pp.kvfree_call_rcu
     19.06            -9.3        9.81        perf-profile.children.cycles-pp.mas_wr_node_store
      9.94            -4.4        5.58        perf-profile.children.cycles-pp.mas_store_prealloc
     10.91            -4.1        6.80        perf-profile.children.cycles-pp.mas_store_gfp
      1.97 ±  7%      -0.8        1.14 ±  9%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.32            -0.1        0.23        perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      0.20 ±  2%      -0.1        0.13        perf-profile.children.cycles-pp.filemap_get_entry
      0.36            -0.1        0.29        perf-profile.children.cycles-pp.freader_get_folio
      0.09            -0.0        0.05        perf-profile.children.cycles-pp.xas_load
      0.22 ±  2%      -0.0        0.18        perf-profile.children.cycles-pp.perf_session__process_events
      0.22 ±  2%      -0.0        0.18        perf-profile.children.cycles-pp.reader__read_event
      0.21 ±  5%      -0.0        0.18        perf-profile.children.cycles-pp.record__finish_output
      0.21 ±  2%      -0.0        0.18 ±  2%  perf-profile.children.cycles-pp.mas_wr_store_entry
      0.09            -0.0        0.08        perf-profile.children.cycles-pp.mas_prev_range
      0.05            +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.sched_tick
      0.06            +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.vma_set_page_prot
      0.10 ±  4%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.05            +0.0        0.08        perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.16 ±  2%      +0.0        0.19        perf-profile.children.cycles-pp.vma_mark_detached
      0.03 ± 70%      +0.0        0.07        perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.05            +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.security_mmap_file
      0.02 ±141%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.handle_internal_command
      0.02 ±141%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.main
      0.02 ±141%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.run_builtin
      0.22            +0.0        0.26        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.41            +0.0        0.45        perf-profile.children.cycles-pp.freader_fetch
      0.08 ±  6%      +0.0        0.12        perf-profile.children.cycles-pp.mas_prev_setup
      0.07 ±  5%      +0.0        0.11 ±  6%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.06            +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.refill_obj_stock
      0.20 ±  2%      +0.0        0.24        perf-profile.children.cycles-pp.downgrade_write
      0.06 ±  7%      +0.0        0.11        perf-profile.children.cycles-pp.mas_data_end
      0.06 ±  8%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.cap_capable
      0.09 ±  5%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.09 ±  7%      +0.0        0.14 ±  4%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.00            +0.1        0.05        perf-profile.children.cycles-pp._raw_spin_trylock
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.get_mmap_base
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.ima_file_mmap
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.vm_area_free
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.x64_sys_call
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.prepend
      0.09 ±  4%      +0.1        0.14 ±  4%  perf-profile.children.cycles-pp.may_expand_vm
      0.02 ± 99%      +0.1        0.08        perf-profile.children.cycles-pp.__account_obj_stock
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.build_id_parse_nofault
      0.09            +0.1        0.15 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.12 ±  3%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.testcase
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.unmap_single_vma
      0.08            +0.1        0.14 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.39 ±  2%      +0.1        0.45 ±  2%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.20 ±  2%      +0.1        0.26        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.__free_one_page
      0.08 ±  7%      +0.1        0.15 ±  5%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.09            +0.1        0.16 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.10 ±  4%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.mmap_region
      0.13 ±  7%      +0.1        0.20 ±  7%  perf-profile.children.cycles-pp.strlen
      0.12            +0.1        0.19 ±  2%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.13            +0.1        0.21 ±  2%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.00            +0.1        0.08 ±  6%  perf-profile.children.cycles-pp.memfd_check_seals_mmap
      0.05            +0.1        0.13        perf-profile.children.cycles-pp.rmqueue_bulk
      0.09 ±  7%      +0.1        0.17 ±  4%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.06 ±  9%      +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.10 ±  5%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.02 ±149%      +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.path_noexec
      0.06 ±  6%      +0.1        0.15 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.00            +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.ktime_get
      0.14 ±  2%      +0.1        0.22 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.18 ± 10%      +0.1        0.26        perf-profile.children.cycles-pp._raw_spin_lock
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.clockevents_program_event
      0.14 ±  3%      +0.1        0.23        perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.17 ±  2%      +0.1        0.26        perf-profile.children.cycles-pp.remove_vma
      0.05            +0.1        0.14 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.15            +0.1        0.24 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.13 ±  5%      +0.1        0.23 ±  2%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.17 ±  2%      +0.1        0.28        perf-profile.children.cycles-pp.freader_init_from_file
      0.17 ±  2%      +0.1        0.28        perf-profile.children.cycles-pp.prepend_copy
      0.14 ±  4%      +0.1        0.25        perf-profile.children.cycles-pp.current_time
      0.16 ±  3%      +0.1        0.27 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.15 ±  3%      +0.1        0.27 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.34            +0.1        0.46        perf-profile.children.cycles-pp.down_write
      0.23 ±  3%      +0.1        0.35        perf-profile.children.cycles-pp.fget
      0.11 ±  3%      +0.1        0.24 ±  2%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.72            +0.1        0.85        perf-profile.children.cycles-pp.__build_id_parse
      0.21            +0.1        0.35        perf-profile.children.cycles-pp.up_read
      0.11 ±  3%      +0.1        0.25 ±  2%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.23            +0.1        0.37        perf-profile.children.cycles-pp.fput
      0.11 ±  4%      +0.1        0.26        perf-profile.children.cycles-pp.alloc_pages_mpol
      0.24 ±  2%      +0.2        0.40        perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.25 ±  2%      +0.2        0.41        perf-profile.children.cycles-pp.atime_needs_update
      0.32            +0.2        0.48        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.28 ±  2%      +0.2        0.44        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.30 ±  2%      +0.2        0.48        perf-profile.children.cycles-pp.touch_atime
      0.30 ±  2%      +0.2        0.48        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.43 ±  3%      +0.2        0.61        perf-profile.children.cycles-pp.perf_iterate_sb
      0.33 ±  3%      +0.2        0.52        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.33 ±  3%      +0.2        0.52        perf-profile.children.cycles-pp.kfree
      0.39            +0.2        0.58 ±  2%  perf-profile.children.cycles-pp.prepend_path
      0.27            +0.2        0.46        perf-profile.children.cycles-pp.down_write_killable
      0.33            +0.2        0.54        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.30            +0.2        0.51        perf-profile.children.cycles-pp.__vma_enter_locked
      0.28 ±  7%      +0.2        0.51 ±  7%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.47            +0.2        0.71        perf-profile.children.cycles-pp.mas_next_slot
      0.32 ±  4%      +0.2        0.56 ±  2%  perf-profile.children.cycles-pp.build_detached_freelist
      0.76 ±  2%      +0.2        1.01 ±  3%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.36            +0.3        0.61        perf-profile.children.cycles-pp.up_write
      0.65            +0.3        0.91        perf-profile.children.cycles-pp.zap_pte_range
      0.84 ±  2%      +0.3        1.11 ±  2%  perf-profile.children.cycles-pp.mas_update_gap
      0.53 ±  2%      +0.3        0.81        perf-profile.children.cycles-pp.d_path
      0.44            +0.3        0.73        perf-profile.children.cycles-pp.__vma_start_write
      0.46            +0.3        0.75        perf-profile.children.cycles-pp.mas_wr_store_type
      0.69            +0.3        1.00        perf-profile.children.cycles-pp.mas_walk
      0.36            +0.3        0.67        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.47 ±  5%      +0.3        0.78 ±  5%  perf-profile.children.cycles-pp.kmem_cache_free
      0.36            +0.3        0.67        perf-profile.children.cycles-pp.mas_rev_awalk
      0.52            +0.3        0.86        perf-profile.children.cycles-pp.mas_prev_slot
      0.52            +0.4        0.96        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.33 ±  4%      +0.4        0.77 ±  2%  perf-profile.children.cycles-pp.setup_object
      0.24 ± 64%      +0.4        0.69 ± 10%  perf-profile.children.cycles-pp.kfree_rcu_monitor
      0.71            +0.5        1.16        perf-profile.children.cycles-pp.rcu_all_qs
      0.75            +0.5        1.21        perf-profile.children.cycles-pp.vm_area_alloc
      0.43 ±  4%      +0.5        0.95        perf-profile.children.cycles-pp.shuffle_freelist
      0.88            +0.6        1.43        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.49            +0.6        2.10        perf-profile.children.cycles-pp.mas_find
      1.13            +0.6        1.77        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.51 ± 19%      +0.7        1.16 ±  6%  perf-profile.children.cycles-pp.kfree_rcu_work
      0.55 ±  4%      +0.7        1.23        perf-profile.children.cycles-pp.allocate_slab
      1.35 ± 10%      +0.7        2.04 ±  5%  perf-profile.children.cycles-pp.__irq_exit_rcu
      2.24            +0.7        2.94        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      1.14            +0.8        1.93        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.16            +0.8        1.96        perf-profile.children.cycles-pp.vm_unmapped_area
      1.53 ±  9%      +0.8        2.34 ±  5%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.51 ±  9%      +0.8        2.32 ±  5%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.44            +1.0        2.41        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.63            +1.0        2.65        perf-profile.children.cycles-pp.free_pud_range
      0.76 ± 30%      +1.1        1.84 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.76 ± 30%      +1.1        1.84 ±  5%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      1.60            +1.1        2.69        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      1.79            +1.1        2.88        perf-profile.children.cycles-pp.free_p4d_range
      1.88            +1.1        2.99        perf-profile.children.cycles-pp.free_pgd_range
      0.77 ± 30%      +1.1        1.88 ±  5%  perf-profile.children.cycles-pp.process_one_work
      0.77 ± 30%      +1.1        1.89 ±  5%  perf-profile.children.cycles-pp.worker_thread
      1.64            +1.1        2.77        perf-profile.children.cycles-pp.__get_unmapped_area
      0.28 ± 22%      +1.1        1.42 ±  4%  perf-profile.children.cycles-pp.get_any_partial
      2.54            +1.2        3.77        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.85            +1.4        4.28        perf-profile.children.cycles-pp.perf_event_mmap
      2.21            +1.4        3.66        perf-profile.children.cycles-pp.__cond_resched
      2.85            +1.5        4.32        perf-profile.children.cycles-pp.free_pgtables
      0.51 ± 22%      +1.8        2.31 ±  6%  perf-profile.children.cycles-pp.get_partial_node
     22.66            +1.9       24.54        perf-profile.children.cycles-pp.do_vmi_align_munmap
     22.96            +2.0       25.00        perf-profile.children.cycles-pp.do_vmi_munmap
      2.94            +2.1        5.09        perf-profile.children.cycles-pp.__pi_memcpy
     23.45            +2.4       25.80        perf-profile.children.cycles-pp.__vm_munmap
     23.45            +2.4       25.81        perf-profile.children.cycles-pp.__x64_sys_munmap
      4.70            +2.9        7.58        perf-profile.children.cycles-pp.zap_pmd_range
      4.88            +2.9        7.81        perf-profile.children.cycles-pp.unmap_page_range
      5.12            +2.9        8.06        perf-profile.children.cycles-pp.unmap_vmas
      1.32 ±  7%      +3.0        4.34 ±  3%  perf-profile.children.cycles-pp.___slab_alloc
      1.96 ±  8%      +3.2        5.13 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
     25.42            +3.2       28.66        perf-profile.children.cycles-pp.__munmap
      8.44            +4.5       12.98        perf-profile.children.cycles-pp.vms_clear_ptes
      9.71            +5.2       14.92        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      7.04 ±  2%      +6.4       13.40        perf-profile.children.cycles-pp.__put_partials
     12.51 ±  2%     +11.7       24.21        perf-profile.children.cycles-pp.__slab_free
     19.64           +16.7       36.38        perf-profile.children.cycles-pp.run_ksoftirqd
     19.64           +16.7       36.38        perf-profile.children.cycles-pp.smpboot_thread_fn
     20.98           +17.5       38.44        perf-profile.children.cycles-pp.rcu_do_batch
     20.98           +17.5       38.45        perf-profile.children.cycles-pp.rcu_core
     20.99           +17.5       38.47        perf-profile.children.cycles-pp.handle_softirqs
     19.40 ±  2%     +17.6       37.02        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     19.85           +17.7       37.53        perf-profile.children.cycles-pp.rcu_free_sheaf
     20.42           +17.9       38.27        perf-profile.children.cycles-pp.kthread
     20.42           +17.9       38.27        perf-profile.children.cycles-pp.ret_from_fork
     20.42           +17.9       38.27        perf-profile.children.cycles-pp.ret_from_fork_asm
     60.82           -20.8       40.07        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.18 ±  2%      -0.2        0.02 ± 99%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.46            -0.1        0.40        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.12 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.filemap_get_entry
      0.19 ±  2%      -0.0        0.15        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.15 ±  2%      -0.0        0.12        perf-profile.self.cycles-pp.unmap_vmas
      0.11 ±  3%      -0.0        0.09        perf-profile.self.cycles-pp.__filemap_get_folio_mpol
      0.09            -0.0        0.07        perf-profile.self.cycles-pp.___pte_offset_map
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_prev_range
      0.05            +0.0        0.06        perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.07 ±  5%      +0.0        0.08 ±  4%  perf-profile.self.cycles-pp.static_key_count
      0.10 ±  3%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.mas_update_gap
      0.04 ± 44%      +0.0        0.07 ±  7%  perf-profile.self.cycles-pp.touch_atime
      0.06            +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.04 ± 44%      +0.0        0.07        perf-profile.self.cycles-pp.current_time
      0.17 ±  3%      +0.0        0.20 ±  2%  perf-profile.self.cycles-pp.unmap_page_range
      0.15 ±  2%      +0.0        0.18        perf-profile.self.cycles-pp.vma_mark_detached
      0.04 ± 44%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.22 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.09 ±  4%      +0.0        0.13        perf-profile.self.cycles-pp.atime_needs_update
      0.07            +0.0        0.11        perf-profile.self.cycles-pp.mas_prev_setup
      0.06            +0.0        0.10        perf-profile.self.cycles-pp.mas_data_end
      0.08 ±  5%      +0.0        0.13 ±  5%  perf-profile.self.cycles-pp.testcase
      0.09 ±  4%      +0.0        0.13        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.07            +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.d_path
      0.06 ±  8%      +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.cap_capable
      0.07            +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.08 ±  4%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.mas_prev
      0.08            +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.19            +0.0        0.24        perf-profile.self.cycles-pp.downgrade_write
      0.09 ±  7%      +0.0        0.14 ±  4%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.09            +0.1        0.14        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.prepend
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.setup_object
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.unmap_single_vma
      0.09 ±  5%      +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.may_expand_vm
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.08            +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.__put_partials
      0.08 ±  4%      +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.09 ±  4%      +0.1        0.15 ±  3%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.__free_one_page
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.do_vmi_munmap
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.refill_obj_stock
      0.39 ±  2%      +0.1        0.45 ±  2%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.19            +0.1        0.25        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.00            +0.1        0.07 ±  7%  perf-profile.self.cycles-pp.memfd_check_seals_mmap
      0.00            +0.1        0.07 ±  7%  perf-profile.self.cycles-pp.mmap_region
      0.12 ±  3%      +0.1        0.19 ±  3%  perf-profile.self.cycles-pp.free_pgtables
      0.12 ±  8%      +0.1        0.19 ±  9%  perf-profile.self.cycles-pp.strlen
      0.00            +0.1        0.07        perf-profile.self.cycles-pp.freader_get_folio
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.__account_obj_stock
      0.16            +0.1        0.24 ±  2%  perf-profile.self.cycles-pp.free_p4d_range
      0.11            +0.1        0.19        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.10 ±  5%      +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.13 ±  3%      +0.1        0.22 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.00            +0.1        0.08 ±  5%  perf-profile.self.cycles-pp.ktime_get
      0.11 ±  3%      +0.1        0.20 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.16 ±  9%      +0.1        0.25        perf-profile.self.cycles-pp._raw_spin_lock
      0.28            +0.1        0.37        perf-profile.self.cycles-pp.zap_pte_range
      0.23 ±  4%      +0.1        0.33        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.14 ±  3%      +0.1        0.23 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.05            +0.1        0.15 ±  2%  perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.06            +0.1        0.16        perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.00            +0.1        0.10        perf-profile.self.cycles-pp.mas_next_range
      0.16 ±  3%      +0.1        0.26        perf-profile.self.cycles-pp.do_syscall_64
      0.30 ±  2%      +0.1        0.40        perf-profile.self.cycles-pp.down_write
      0.17 ±  2%      +0.1        0.27 ±  2%  perf-profile.self.cycles-pp.freader_init_from_file
      0.18 ±  2%      +0.1        0.28        perf-profile.self.cycles-pp.kmem_cache_free
      0.10 ±  3%      +0.1        0.21        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.15 ±  3%      +0.1        0.26 ±  3%  perf-profile.self.cycles-pp.do_mmap
      0.25 ±  2%      +0.1        0.36 ±  3%  perf-profile.self.cycles-pp.prepend_path
      0.41            +0.1        0.52        perf-profile.self.cycles-pp.mas_find
      0.27 ±  2%      +0.1        0.39        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.22 ±  2%      +0.1        0.34 ±  2%  perf-profile.self.cycles-pp.fget
      0.14            +0.1        0.27        perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.33 ±  4%      +0.1        0.46        perf-profile.self.cycles-pp.perf_iterate_sb
      0.21            +0.1        0.34        perf-profile.self.cycles-pp.up_read
      0.25            +0.1        0.39        perf-profile.self.cycles-pp.__mmap_new_vma
      0.22            +0.1        0.36        perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.16            +0.1        0.30        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.22 ±  2%      +0.1        0.36        perf-profile.self.cycles-pp.fput
      0.23 ±  2%      +0.1        0.37        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.24            +0.1        0.38        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.00            +0.2        0.15 ±  2%  perf-profile.self.cycles-pp.freader_fetch
      0.22 ±  8%      +0.2        0.38 ±  9%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.23            +0.2        0.39        perf-profile.self.cycles-pp.down_write_killable
      0.29 ±  3%      +0.2        0.46        perf-profile.self.cycles-pp.kfree
      0.65 ± 12%      +0.2        0.82 ±  4%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      0.29 ±  2%      +0.2        0.48        perf-profile.self.cycles-pp.vm_area_alloc
      0.07 ±  5%      +0.2        0.26 ±  2%  perf-profile.self.cycles-pp.get_partial_node
      0.34 ±  2%      +0.2        0.53        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.27            +0.2        0.47        perf-profile.self.cycles-pp.__vma_enter_locked
      0.32 ±  2%      +0.2        0.52        perf-profile.self.cycles-pp.perf_event_mmap
      0.07            +0.2        0.27 ±  3%  perf-profile.self.cycles-pp.get_any_partial
      0.32            +0.2        0.53        perf-profile.self.cycles-pp.__vm_munmap
      0.33            +0.2        0.53        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.48            +0.2        0.68        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.32            +0.2        0.54        perf-profile.self.cycles-pp.mas_preallocate
      0.34            +0.2        0.56        perf-profile.self.cycles-pp.mas_store_prealloc
      0.30 ±  3%      +0.2        0.53 ±  2%  perf-profile.self.cycles-pp.build_detached_freelist
      0.24 ±  3%      +0.2        0.47 ±  4%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.40            +0.2        0.64        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.45            +0.2        0.69        perf-profile.self.cycles-pp.mas_next_slot
      0.75 ±  2%      +0.2        0.99 ±  3%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.35            +0.2        0.59        perf-profile.self.cycles-pp.up_write
      0.29            +0.3        0.55        perf-profile.self.cycles-pp.mas_rev_awalk
      0.45            +0.3        0.73 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.50            +0.3        0.82        perf-profile.self.cycles-pp.mas_prev_slot
      0.65            +0.3        0.96        perf-profile.self.cycles-pp.mas_walk
      0.18 ±  2%      +0.3        0.53 ±  3%  perf-profile.self.cycles-pp.___slab_alloc
      0.55            +0.4        0.90        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.40            +0.4        0.77        perf-profile.self.cycles-pp.__mmap
      0.81            +0.4        1.19        perf-profile.self.cycles-pp.mas_store_gfp
      0.61            +0.4        1.00        perf-profile.self.cycles-pp.rcu_all_qs
      0.39 ±  4%      +0.5        0.87 ±  2%  perf-profile.self.cycles-pp.shuffle_freelist
      0.96            +0.6        1.51        perf-profile.self.cycles-pp.__slab_free
      0.87            +0.6        1.42        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.19            +0.7        1.94        perf-profile.self.cycles-pp.mas_wr_node_store
      1.25            +0.8        2.06        perf-profile.self.cycles-pp.__cond_resched
      1.47            +1.0        2.43        perf-profile.self.cycles-pp.__mmap_region
      1.60            +1.0        2.60        perf-profile.self.cycles-pp.free_pud_range
      2.32            +1.5        3.80        perf-profile.self.cycles-pp.zap_pmd_range
      2.89            +2.1        4.96        perf-profile.self.cycles-pp.__pi_memcpy




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



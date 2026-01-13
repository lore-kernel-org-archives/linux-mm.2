Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F189D2D10D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36216B008C; Tue, 13 Jan 2026 09:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB81A6B0092; Tue, 13 Jan 2026 09:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38636B0093; Tue, 13 Jan 2026 09:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAC046B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:20:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E7D7C0110
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:20:45 +0000 (UTC)
X-FDA: 84327151650.06.C7AAEFA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id E21694001A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:20:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jc6gl/m4";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768314041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NbL2ZJYS4jIGgWplr48EYQk+ErJyEKyUu5+3R6XnFBI=;
	b=0+19VLo7MFIxlI9ua+n6gx9v72gaBYKCLHy3WLJSsTYTd9QSBFfUGaKLcheaGNcaaBF07H
	EdZ8DYvdeVvayy7xhmyWu0foYSz330NavjQy2HEjXUJXWqE1Rqmpkxa6n2//wl6Qr6V3qV
	UT7Q4SBqa8YHB20d2njiZiUzut1LhkQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jc6gl/m4";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768314041; a=rsa-sha256;
	cv=fail;
	b=tCTs8vleqZDHPKdaB4Ri0Kd/UNQ0tVdYqYRECQZMLA/AFGpXUjCkK8hy43r2tR3LOXGA4E
	02UW/J/C0dr8IUdiW1kJojH3dqjOErzLZsMeGbRQZWbPMVZQnmZcNyvFMwVDtu7IPAkihB
	vh1e/R3xdfFk6S8K7X4Y9R5cxztJ2uI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768314042; x=1799850042;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=Jt1pc33uGc0tLYTB0b/ADhzSYKhrOwrioTDcTlDP+g0=;
  b=jc6gl/m4K484iK9eZFrtRYUodrPkqAT0/GJif/tQlcEEAWv19QdygcyI
   o+S+mw0MtUHj8iw0WK7TbK3Mg2rp/ZsAceKbPi3bnGpfP1OYuTsAH6R02
   9SZuYmpc3yFI6UpKv7T8RiDR1aqApaiNcNGB8yTA/2hjT33AH+jiqKv51
   M/6wVTQOXWhzJxQfORujmc/ohPEgdVVsWfOPeUi6navC+BzY7E/ozKKvZ
   mIJR+lAZp+lRYWoD/k8qACCvpUsJksX+A2v/9ba5JoQdpSl5X8p5Gzuz4
   CFfSmFltLPgMpUUWZ4Y+DfNqJrdn+kvSJ1K9K1FG5S4YuXW0hJRebeBsX
   Q==;
X-CSE-ConnectionGUID: 1dAyujpQTRur+CFI5Ue4jQ==
X-CSE-MsgGUID: N1CQZSBdRres8HZ59MXbkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69654775"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69654775"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 06:20:40 -0800
X-CSE-ConnectionGUID: 0sprnG13SQammIPiJq9PVA==
X-CSE-MsgGUID: HuvRLnOkQfSL2KTIG5YxXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="203547075"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 06:20:39 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 06:20:38 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 06:20:38 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 06:20:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpUCiBEg403VcoQGMKkn/hiDg+6u7XASpGz5ypT1HoSglMQWCWRup32BnvQUvZVDC4SxrteWO4CFr1v6ltRvtnbwlcW3zdr8R/8DUYJZZTXPRhdYVI5/+muLuAUT/18jJvFkSH6TI6KTW48hYn5CDmjMFMe4Zb4xq9D+l+Tm+9Ub2z682UArPj1+sFcLaOJFeo2LggPGRtA8CJLim3NtdkjYUZdSpNCzKMEkSLJwfOHwdolll4Mslbr/ZF6Hj4QhDunGG5rV+IxDalu6I3bEFyQYLzeeRcIlQFfa21krzwG3uW2ZDJE6bkDNCIH3Z7assR5ZQcABScANqO2BKvtHjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Qi35A/mCey69Eh5XqlfZJ+H1CXvnJ9ngChh1CQ0psY=;
 b=e7aGYStfTDzLYtvY1hwZpBWnjP7y7VWB9vvL+y68uR2aGddmm6r4cKuV1WEHAjzqv5OtoAkPJQiYWaEWz2xZcGpAqXO/erDZvS7QbSYv/4sw0vW00kbca2zVW/LplxKFDkmnAVEHRUqiqAEOKGeLjyTGxOWJf5oWOKXivn+9nPQOcrYd1AOBMQ827NzvJ67eFMjeKbtlNseP9YH4yUgTYRhYXcG7WmmPdYOv7/ZlRu2I7lS4HEUX+WiCbUepQJhCzRDgUIO2W+WbXF6Wwstfi4Ts7YrVU8Oqb8U9T65h57buECB7HKUO9wX1VIS2rlaB9bOhUsMZGp7PS2X6P5oPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN0PR11MB6280.namprd11.prod.outlook.com (2603:10b6:208:3c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 14:20:35 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 14:20:35 +0000
Date: Tue, 13 Jan 2026 22:20:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all-rebased] [slab]  02b7b4409e:
 stress-ng.timerfd.ops_per_sec 12.8% regression
Message-ID: <202601132233.e3dcb51b-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2PR04CA0171.apcprd04.prod.outlook.com (2603:1096:4::33)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN0PR11MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: 205e8729-b260-4547-f85b-08de52aeea95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?iQQOtTT77ejOcmj4Gn/LTwVfOFbv5kmPCFNk6Kj0y/YZQHtDlETGpLWIEy?=
 =?iso-8859-1?Q?5WwGkpzb9A/PFrSc0Dtq3VhdXNNUxXygy6maDEXo/e83dg8s8rqTTldyur?=
 =?iso-8859-1?Q?z+O9Ey9Pg6MeOWwp0TI7/i1ULDVjqCfrPTCqs0nK1O2CnNZ6HEGtjQOLvq?=
 =?iso-8859-1?Q?8t+ZoLRWgmQu9k+ii5/Xly5LsAmA2HUboaPKr7S5yuBhqKeVgTcuOLvPuD?=
 =?iso-8859-1?Q?powPefP8GdxwpHPjdMn9STJhiGyS00PBqp4+rsVTbVH7lHjKfhFko4GvbR?=
 =?iso-8859-1?Q?m6rOVBrRV0NgkGyGt5x0XlnnrsSVlCMZN4LAH7QAjEksg+yKegXYJ9pKn3?=
 =?iso-8859-1?Q?rvgVrnvvTGfZslHrEzZAv8iU2rG8fgTCNMUXxXlBT6iNp0WE2nY3FTIJ2A?=
 =?iso-8859-1?Q?pZDrL2G73+yH5o9qflEQlBg3MeAlStP93w8wuVFrMAk0nIqoc5uREZWS1H?=
 =?iso-8859-1?Q?bTOQHkQAAigqhCQTHzXrZ+wQTKT976Yav37boW5e08puKxuY4w1Lzh9z6j?=
 =?iso-8859-1?Q?WuyaO5c/V7bCNviGicmJfzpQABHTW2zjZvt7FHn1Es9n9xBBCUcye3YXXg?=
 =?iso-8859-1?Q?MnR2LDUvMDqSPfIdnbZFA7ONPbeH6BwFIcFxebS5ywvsGUD9V/MqiM5XJT?=
 =?iso-8859-1?Q?zRgrfOjWqakWhPy9sPQFvWy4CDdfBOtA6hxPyPy7P81DaNd2qEZWn8ACQz?=
 =?iso-8859-1?Q?omYvUUbmBuXpY0Wyh6I2vJnlJ1x2LuRn6W+jsJxSICWPZdGxoKyiZ/57FG?=
 =?iso-8859-1?Q?mYzzrnBtsFHEHnI4Oynzdhufc1wjGLdHW6rNgf1T1T/7B+icT49xmXQbdG?=
 =?iso-8859-1?Q?/Q2vYxWlEP7kncXZ9BczEr/PmlSu6qhUS0qhakOjRhQpcYVhWtKg5k6eaL?=
 =?iso-8859-1?Q?sKlMCxjZVdlWc9/XBlv9LrRFtOqT8Gf/TlX3JxdjZHEO1hZNMRXmxnqDYm?=
 =?iso-8859-1?Q?n4BDrI4MHe2+onjtjW9CRjwoSmTnkmoQLoVC25mBOfJEPrEQTyB5INHH9R?=
 =?iso-8859-1?Q?W2wTnwgiN/HrRfqjZWjylb7ccLGsbu+BeBw4pa/L/55D+007pExAwM+c0G?=
 =?iso-8859-1?Q?zzJSHIopqApVNrE1Wf2gD7/N9d81OZIUDFQ/Mdb31D4idRXw1C6zWvfUOa?=
 =?iso-8859-1?Q?taEwsr5kbJ2uaFeYC4qianDPZ/7Yb6cleozBruwIItbc8dIfqv6dfEVSI1?=
 =?iso-8859-1?Q?CgsJcRkCS91fsuRucgcYwzQ+C3jXMey+Cw2DHBl0IN2WthHXGJJtpcedhR?=
 =?iso-8859-1?Q?MeDAQ3HQoAMwxeCXZ/ngu62uZsmr4PR12jUnBWAYGP8KHVJTNIAifJyvv/?=
 =?iso-8859-1?Q?GLgXNp+WOMisiha1t056oyJQnQGoE+IdMCWfx425ycjdsV0oCJ474bXZMK?=
 =?iso-8859-1?Q?3j8XJusfPceQOc0+TIR+PENAGlGHbZ4ni95WtbaBUz7mWXfVWDMi+C4Wyp?=
 =?iso-8859-1?Q?1NrTvk4gLoZemNFPFqg19da7GywbTw5ES/Kk8kxmGn0N7joKsn1z2v9zBS?=
 =?iso-8859-1?Q?TY5eoNZz0swaLtK51UrAzpPj2vhpMGfblxKNKxW1Mazw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6w8ODfBz5Lr/4Tc01OdZsiwyvj2vGlQv1AFVjoHTygdJq6Mly4A0RClMEd?=
 =?iso-8859-1?Q?LPTUPq4pGWyB9Aum0bl5GYmhe4zfELFexXFjkafaSpE6ELv2eY7u0DBinT?=
 =?iso-8859-1?Q?B1HIuRBgdYwvzXN3ioI98f4v/6AcVNL8ygc7WTyKQaC2zE+CIlkee+m7UH?=
 =?iso-8859-1?Q?jLaR22zLcFUXZQBhAb7JsHR2xJJmVViPnf/RxANF6nyE6KshuXSaB3zmyk?=
 =?iso-8859-1?Q?HZpUYdQQMjo9W64lriHipO+nOpREUr8e/G7SbJvHs+EqqhYWnac/0yKBr8?=
 =?iso-8859-1?Q?sUo69QiUI22B3tDCM+2Fa2g8YYqv44mdArBUAcShPC32e+CX1W91BC8jhC?=
 =?iso-8859-1?Q?L3zT0JM/i+fVcewUbgNLXYHeFMk3fEwWXVQGPjWq7FhYGUWxoovTKBs8hC?=
 =?iso-8859-1?Q?9Pl5rn4adA8qcwH0gvbWM/QP4L2QENmhVlKoA7GOruZE0s9bxwSaDZfEbl?=
 =?iso-8859-1?Q?Dt6WBaZg7+D4jsJZI4P8Bw0/u74g7z+/yAosvDBaGV3H+P+fktAs0HQ0gm?=
 =?iso-8859-1?Q?sobL5o1bIxK9gM+Nqrsk975LtFSMoFCsY7hqyNfWlZmf2odjsR5akfcj/n?=
 =?iso-8859-1?Q?mrbX6c1cLUARcgU8JimncUeOqW6ixEpfbs+uqfJTgkcSCuzyl7Wy1l27oJ?=
 =?iso-8859-1?Q?YShKUOUFlVL0+F9ijxBagJJ6bKZZ6r0fDZ5hF0nc1tKtHiPoxnzhpVMBMp?=
 =?iso-8859-1?Q?Vok5+qXsXzaKylb/6TECFG7+MEiEDOz7KBpESLExhhc5teRpu9/U4G4wTa?=
 =?iso-8859-1?Q?2DVuxcko9NcBnCPhjdDjjAZDYrAHPGIvX8X3iM/vkRPwDgw1qlkGQsj8t7?=
 =?iso-8859-1?Q?pXi6MTjPbuAxY1bJli61NDMvqfyCzVylbTSFTOapovuAc07rKo/JT+H7vR?=
 =?iso-8859-1?Q?XY7xIGNRoH3iLtZhLfNAHpTan9ZeD2SCSxe+kW6ALQd+dHIJzxpXjovax7?=
 =?iso-8859-1?Q?4HLIfd4pP8etfkj6Gf766VNXa3xEbI3OldSr50u7W0aiUgKlXGxi3/Brks?=
 =?iso-8859-1?Q?hlW2QVhNzYNjlIAVUcVL010WBYbSc1Sf5b2P2i8zfNaoO5nAgAIRokLSx/?=
 =?iso-8859-1?Q?2EbUD2YF9AZDBrQItcT5IsK0K7j7GX/4bQBkHpvzNSK+XYfal68yJSOFJy?=
 =?iso-8859-1?Q?yOb9fNpW/cXZIiXKNWwcjlnTLW8r06pE4LJ5Pfx2PxmdGZ6rtS0jTUm7U7?=
 =?iso-8859-1?Q?stboFzuq+v/WDxB2leaLho4Jx6OSU0L6tclkL0bw9MWEnopPG7aCSGXTWx?=
 =?iso-8859-1?Q?c6h18HMV2cDCQS4P8nQaXaVxKuburrZHhT8q6XWH0rQrMz8ATmSkp0Z1lF?=
 =?iso-8859-1?Q?mdV/pN+BLcpMRjgo1DlIOOS6dSdU+A3c3Ug6iNNPU7PyePyViFPzZXcCNA?=
 =?iso-8859-1?Q?+JNGATyg3CQFImHLaT1rtCFAeFnMh5GJ33LXuBzJJLVC56mjU23I4VQEGI?=
 =?iso-8859-1?Q?6z4SrMF9QzHb1HNXf2aMHHhhQj+mqZUu4pGSpSX+zF+Nt7kD1UvjTcy/94?=
 =?iso-8859-1?Q?hXeJrjIVDNjnZn52Io8raKY9/tbAyvifebWmNsAqw5PqcuO3n3UPYSMFQL?=
 =?iso-8859-1?Q?FpVQtbMazUg0SbZUwUxUYuJwfADNso2r8ZIwMgRC+j9qNw5kpNYN5i0NmI?=
 =?iso-8859-1?Q?jOzksK+fzN8ogP6LEJ7odSzR+xMz0vm8NzSeSrESHKeyWo+V3VopUFmGlJ?=
 =?iso-8859-1?Q?3hSti/866FkasSA2IkKkpbI3AHDsUHdoBXBxPxkoQLupBWod7nn7qKwd9Q?=
 =?iso-8859-1?Q?jyHokCLliED03IYP4maMPL2AXkGW1UlU8Qms8RdJleHzj6lgj/Jpng04Km?=
 =?iso-8859-1?Q?8Z5ufroanQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 205e8729-b260-4547-f85b-08de52aeea95
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 14:20:35.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3rF33Jf5F97YQhcS4zWFIhcUCxWUd7qNPA2bEOG24jE9cbBfMZCid0MiJPnrb92DlnCH8zEUBMQwTTBiEoZ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6280
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: f7ejjwsnx6fiu4q9e8xqr97493r7pn3b
X-Rspamd-Queue-Id: E21694001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768314040-175685
X-HE-Meta: U2FsdGVkX1/Ox4nPdveqsPZBmYDBMrjGewTBLHtBuKChhSJmu2Q4FO1rBWNV/XcLyxVanzzIVS56u6HAZiUT6KDruwOtqkIqT2kHs2by/nq85i26cnr+wC1jntY/kTBxSGlZ48e3HiIxrdTJjzCKvsCjA06Jjj+dlWU1v95g9zE/zokNSWb3oUadQTb9gfK8avCd5ekEq2MU4Z1ZJick3qTDxw856c51wYhPARZB58YdQoZPMkmdSOdhcuwwepUQDAxOfQ+nScjMQBnLbVKuYlUkFceMeJ4WcyZp4h81ddgGA7iAtpWUBU2rNfah0TEMPTJ0W86OCnub3TWof+0eWcA+cVUWMullhdNl2WPIq5/7eso0UwuDFh6conmq3hNze/vG71KwqaExBSZ4ZCwVgt4UWwPrpore5ohFOw7rGl/q7y1+bQkbNo31antcFQlBrMGaX0dJJCeWNDULzxteP62KmlDXv49u0tY3LDILKZjiuEc8HmGL92wiORlaiz7XI1ePY2+xjoxuyqZJ+bUCGxDOVxVjaWz+yvzPUajuf/B+QT/FDjuewgo1ju1Wy9ScriwYd5PWUcLy5oUBFV+r6O5Q9H7DfKPIvs1hv0wrIhUcdHTiLlUFYF4H5z8HJAVX5K0KvBkmDxJsxjm/mXmzajVBMzneqAzuqNs5eJGhF/0+odz9+PGyNe6yMLZtnX9x+dVPvLHnHz5eSRltoODGxaCMEpem7TY2I7Kas7B3DxcI7Ba3etfz8nBwaPhKJGlhMaZOw3825RXE8u65RuBF912sZzF5ZFkspB8oRnT98NxBhY4NTCKru+KJKy2FBAVsENeV4aM6KHjEv4HQF/vxyplsJAYXhYP7P2MD4V0o4KJuhfLSLrQFm+YvpgS8h8xT7leC3YZqEo71or71/HeIsxMS9ucDhZh32nhNsuKlmsHdTnedbjGkNRctwh/e1QxjbdE0t3c0YZaivng4q/h
 36tVzryI
 S8fOgXqG0ND/ygvIE+DHK1h6TR/julwuc0u+3oNn1Aa0sj5RNINRDFg1MKtlfVqxcVWau3bdNp9wsoYv+hVgHLPEgljnccGjCUHCnfwfT/SH/Algv99qR/Oh4az31rxfTy1WRZuUfqa349ljVu8D3Nba6OVT5zrGDOKFhAAxH2fxmqk++33Qmmk3luHU6a0aeLHj/AYXKoDZjbPVfLo6+rMDLKyrU5ScQ7FUkd2vu/5bqbL68TjkAMKG8AVDiTsDGDQp1sNh/GfBGftBOBeJ9AiB5tnogqdcBUs1n643lHRVkNF+kC05jEm0SZ2ia3ykNChB65/sBO5xHPO2m3qZBQ5TBhXZ3vVJznfAHtfh/GU61P84IrT1apkICK0i7cYZMJFtL4Ad9P3BxgBxaanuN9mlMy2+V5iCb8F3e7f0Jc5HOHgp0paSG4a0/Zuk7Wvl4U2MQzq6RnZ20u3yUY0Ic3fH4M/Bx0IL8hgfrStDrUEZKyP/QP5ECXqLvdSimTWxhTi5OXEAJGTopcwBSK9rjt7FL/Bmp0Gs49mHMAugakMEDUhPoDPeX4orgvXFKgaG8AZUSG216XBhn63BFH9mBc3R7YlEEyPU2GP7HIHfpN/RpOz3NPMkocDmI+Froaw+6JK64
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 12.8% regression of stress-ng.timerfd.ops_per_sec on:


commit: 02b7b4409e4450b06d3c93a651552d939a4685c7 ("slab: add optimized sheaf refill from partial list")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 512G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: timerfd
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601132233.e3dcb51b-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260113/202601132233.e3dcb51b-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-2sp4/timerfd/stress-ng/60s

commit: 
  94b4dbf98e ("slab: handle kmalloc sheaves bootstrap")
  02b7b4409e ("slab: add optimized sheaf refill from partial list")

94b4dbf98e906cf5 02b7b4409e4450b06d3c93a6515 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    155203           +26.5%     196278 ± 17%  numa-vmstat.node1.nr_shmem
     19549 ± 71%    +370.2%      91924 ± 86%  numa-meminfo.node1.AnonHugePages
    620646           +26.7%     786626 ± 17%  numa-meminfo.node1.Shmem
     23.47 ±  4%     -54.6%      10.65 ± 14%  vmstat.cpu.us
  88793547           -14.8%   75691766 ± 15%  vmstat.system.in
   1358038           +16.5%    1581709 ±  9%  meminfo.Active
   1358021           +16.5%    1581692 ±  9%  meminfo.Active(anon)
    629761           +25.7%     791750 ± 17%  meminfo.Shmem
     81033           +14.9%      93133 ± 10%  sched_debug.cpu.clock_task.avg
     84145           +14.0%      95957 ±  9%  sched_debug.cpu.clock_task.max
     66185 ±  2%     +17.7%      77887 ± 11%  sched_debug.cpu.clock_task.min
      2.95           +13.1       16.07 ± 83%  mpstat.cpu.all.idle%
     21.03            -4.5       16.53 ± 15%  mpstat.cpu.all.irq%
      0.01 ±  6%      -0.0        0.01 ± 16%  mpstat.cpu.all.soft%
     24.23 ±  4%     -13.2       10.99 ± 14%  mpstat.cpu.all.usr%
    109.83 ± 35%    +273.4%     410.17 ± 19%  perf-c2c.DRAM.local
    834.33 ± 38%   +1072.6%       9783 ± 24%  perf-c2c.DRAM.remote
      1954 ± 28%   +6623.4%     131419 ±  3%  perf-c2c.HITM.local
    521.83 ± 10%    +317.0%       2176 ± 15%  perf-c2c.HITM.remote
      2476 ± 21%   +5294.5%     133595 ±  3%  perf-c2c.HITM.total
     17272            +2.7%      17737        stress-ng.time.percent_of_cpu_this_job_got
      7169 ±  2%     +26.1%       9038        stress-ng.time.system_time
      3272 ±  4%     -48.6%       1681 ±  2%  stress-ng.time.user_time
 2.158e+10           -12.8%  1.883e+10        stress-ng.timerfd.ops
 3.589e+08           -12.8%  3.131e+08        stress-ng.timerfd.ops_per_sec
      2.28 ±  9%    +549.0%      14.78 ± 85%  turbostat.CPU%c6
      0.89           -11.9%       0.79        turbostat.IPC
    124.78 ± 22%     -36.7       88.12 ± 17%  turbostat.PKG_%
     64.83            -9.8%      58.50 ±  5%  turbostat.PkgTmp
     21.72           +11.5%      24.22        turbostat.RAMWatt
    339527           +16.5%     395563 ±  9%  proc-vmstat.nr_active_anon
   1083065            +3.7%    1123590 ±  3%  proc-vmstat.nr_file_pages
     43396            -3.2%      41987        proc-vmstat.nr_kernel_stack
    157497           +25.8%     198083 ± 17%  proc-vmstat.nr_shmem
    157752            -8.7%     143960        proc-vmstat.nr_slab_unreclaimable
    339527           +16.5%     395563 ±  9%  proc-vmstat.nr_zone_active_anon
   1276039            +2.8%    1312010        proc-vmstat.numa_hit
   1044667            +3.4%    1080685        proc-vmstat.numa_local
   1414047            +4.6%    1478701 ±  2%  proc-vmstat.pgalloc_normal
    608043            +5.3%     640138 ±  3%  proc-vmstat.pgfault
    816690 ±  2%     +13.1%     923454 ±  5%  proc-vmstat.pgfree
      0.03 ± 13%    +763.9%       0.22 ± 51%  perf-stat.i.MPKI
 1.122e+11           -24.0%   8.53e+10 ± 15%  perf-stat.i.branch-instructions
      0.17 ±  4%      +0.1        0.23 ± 13%  perf-stat.i.branch-miss-rate%
     12.67 ± 43%      -8.2        4.49 ± 24%  perf-stat.i.cache-miss-rate%
   4380117 ± 45%   +1017.9%   48964684 ± 33%  perf-stat.i.cache-misses
  30814202 ± 15%   +3647.0%  1.155e+09 ± 21%  perf-stat.i.cache-references
      1.10           +79.2%       1.97 ± 39%  perf-stat.i.cpi
    385300 ± 32%     -95.6%      16830 ± 23%  perf-stat.i.cycles-between-cache-misses
 5.882e+11           -23.8%  4.482e+11 ± 16%  perf-stat.i.instructions
      0.92           -15.6%       0.77 ±  4%  perf-stat.i.ipc
      0.01 ± 45%   +1372.4%       0.11 ± 28%  perf-stat.overall.MPKI
      0.13            +0.0        0.15 ±  9%  perf-stat.overall.branch-miss-rate%
     14.00 ± 35%      -9.7        4.29 ± 26%  perf-stat.overall.cache-miss-rate%
      1.08           +14.0%       1.23        perf-stat.overall.cpi
    163751 ± 25%     -92.6%      12108 ± 26%  perf-stat.overall.cycles-between-cache-misses
      0.93           -12.2%       0.81        perf-stat.overall.ipc
 1.104e+11           -23.8%  8.413e+10 ± 15%  perf-stat.ps.branch-instructions
   4318635 ± 46%   +1022.5%   48476620 ± 32%  perf-stat.ps.cache-misses
  30464543 ± 15%   +3637.7%  1.139e+09 ± 21%  perf-stat.ps.cache-references
 5.786e+11           -23.6%  4.421e+11 ± 15%  perf-stat.ps.instructions
 3.562e+13           -11.3%   3.16e+13        perf-stat.total.instructions
     21.54 ± 17%     -12.0        9.51 ±  5%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.08 ± 17%      -6.3        4.77 ±  5%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.98 ± 13%      -5.7        4.26 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt
      9.80 ± 17%      -5.6        4.19 ±  5%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.15 ± 17%      -4.7        3.46 ±  5%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.do_syscall_64
      7.26 ± 14%      -4.2        3.06 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      6.48 ± 14%      -3.8        2.72 ±  3%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      5.41 ± 14%      -3.1        2.26 ±  3%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      4.33            -1.0        3.34        perf-profile.calltrace.cycles-pp.clockevents_program_event.hrtimer_start_range_ns.timerfd_read_iter.vfs_read.ksys_read
      7.19 ±  3%      -1.0        6.21        perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      1.70 ± 15%      -0.9        0.76 ±  2%  perf-profile.calltrace.cycles-pp.sync_regs.asm_sysvec_apic_timer_interrupt
      3.34            -0.8        2.55        perf-profile.calltrace.cycles-pp.lapic_next_deadline.clockevents_program_event.hrtimer_start_range_ns.timerfd_read_iter.vfs_read
      1.84 ±  3%      -0.8        1.08 ±  2%  perf-profile.calltrace.cycles-pp.stress_timerfd
      1.19 ± 16%      -0.7        0.53 ±  4%  perf-profile.calltrace.cycles-pp.native_apic_msr_eoi.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.do_syscall_64
      4.96 ±  2%      -0.7        4.31        perf-profile.calltrace.cycles-pp.clockevents_program_event.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      2.36 ±  3%      -0.6        1.78        perf-profile.calltrace.cycles-pp.timerfd_tmrproc.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      2.32            -0.5        1.85 ±  2%  perf-profile.calltrace.cycles-pp.switch_hrtimer_base.hrtimer_start_range_ns.timerfd_read_iter.vfs_read.ksys_read
      2.31            -0.4        1.88        perf-profile.calltrace.cycles-pp.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.63            -0.3        1.36        perf-profile.calltrace.cycles-pp.timerqueue_add.hrtimer_start_range_ns.timerfd_read_iter.vfs_read.ksys_read
      0.79 ±  5%      -0.2        0.59 ±  2%  perf-profile.calltrace.cycles-pp.timerqueue_del.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.85 ±  7%      -0.2        0.65 ±  2%  perf-profile.calltrace.cycles-pp.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.98            -0.2        0.79        perf-profile.calltrace.cycles-pp.get_nohz_timer_target.switch_hrtimer_base.hrtimer_start_range_ns.timerfd_read_iter.vfs_read
      1.05            -0.2        0.88        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64
      1.45            -0.2        1.28        perf-profile.calltrace.cycles-pp.hrtimer_forward.timerfd_read_iter.vfs_read.ksys_read.do_syscall_64
      1.00            -0.2        0.84        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack
      1.67            -0.2        1.51        perf-profile.calltrace.cycles-pp.rw_verify_area.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.71 ±  6%      -0.1        0.57 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.66            -0.1        0.54        perf-profile.calltrace.cycles-pp.rb_insert_color.timerqueue_add.hrtimer_start_range_ns.timerfd_read_iter.vfs_read
      3.12 ±  2%      -0.1        3.00        perf-profile.calltrace.cycles-pp.lapic_next_deadline.clockevents_program_event.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.70            -0.1        0.60        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret
      0.70            -0.1        0.63 ±  2%  perf-profile.calltrace.cycles-pp.security_file_permission.rw_verify_area.vfs_read.ksys_read.do_syscall_64
      1.89            +0.0        1.94        perf-profile.calltrace.cycles-pp.read_tsc.ktime_get.timerfd_read_iter.vfs_read.ksys_read
      1.61 ±  2%      +0.5        2.06 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.hrtimer_start_range_ns.timerfd_read_iter.vfs_read.ksys_read
      0.00            +0.6        0.60        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.timerfd_read_iter.vfs_read
      0.00            +1.1        1.09 ±  2%  perf-profile.calltrace.cycles-pp.native_apic_msr_eoi.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.timerfd_read_iter
      0.00            +1.5        1.46 ±  3%  perf-profile.calltrace.cycles-pp.hrtimer_cb_get_time.timerfd_read_iter.vfs_read.ksys_read.do_syscall_64
      2.04 ±  5%      +2.9        4.89 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.timerfd_read_iter.vfs_read.ksys_read.do_syscall_64
      5.28            +3.4        8.71 ±  3%  perf-profile.calltrace.cycles-pp.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.29            +3.4        8.71 ±  3%  perf-profile.calltrace.cycles-pp.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.86            +3.5        8.36 ±  4%  perf-profile.calltrace.cycles-pp.do_poll.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.18            +3.7        6.90 ±  5%  perf-profile.calltrace.cycles-pp.timerfd_poll.do_poll.do_sys_poll.__x64_sys_poll.do_syscall_64
      2.04 ±  2%      +3.9        5.97 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.timerfd_poll.do_poll.do_sys_poll.__x64_sys_poll
      1.87 ±  7%      +5.5        7.40 ±  2%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.timerfd_read_iter
      2.22 ±  7%      +6.7        8.92 ±  2%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.timerfd_read_iter.vfs_read
      2.50 ±  7%      +7.6       10.12 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.timerfd_read_iter.vfs_read.ksys_read
     77.88 ±  2%      +9.7       87.54        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     74.44           +11.1       85.52        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.72 ±  8%     +15.2       19.95 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.timerfd_read_iter.vfs_read.ksys_read.do_syscall_64
     33.41 ±  5%     +17.7       51.08        perf-profile.calltrace.cycles-pp.timerfd_read_iter.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     45.53 ±  4%     +18.8       64.36        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     39.96 ±  5%     +18.9       58.84        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.47            -3.4       34.09        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     26.04            -3.1       22.93        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     23.07            -2.9       20.16        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
     19.37            -2.6       16.81        perf-profile.children.cycles-pp.hrtimer_interrupt
      9.23            -1.6        7.59        perf-profile.children.cycles-pp.__hrtimer_run_queues
     10.48            -1.5        8.94        perf-profile.children.cycles-pp.clockevents_program_event
      8.20            -1.3        6.90        perf-profile.children.cycles-pp.lapic_next_deadline
      1.97 ± 12%      -1.1        0.86 ±  2%  perf-profile.children.cycles-pp.sync_regs
      6.85 ±  3%      -1.0        5.82        perf-profile.children.cycles-pp.native_irq_return_iret
      2.31 ±  4%      -1.0        1.32 ±  2%  perf-profile.children.cycles-pp.stress_timerfd
      1.29 ±  4%      -0.6        0.66 ±  3%  perf-profile.children.cycles-pp.read
      3.61            -0.6        3.00        perf-profile.children.cycles-pp.timerfd_tmrproc
      3.09            -0.5        2.54        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      2.59            -0.5        2.06        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      2.51            -0.5        2.00        perf-profile.children.cycles-pp.switch_hrtimer_base
      2.09            -0.5        1.61        perf-profile.children.cycles-pp.timerqueue_del
      1.97            -0.4        1.57        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      3.38            -0.3        3.06        perf-profile.children.cycles-pp.native_apic_msr_eoi
      1.81            -0.3        1.51        perf-profile.children.cycles-pp.timerqueue_add
      1.17            -0.3        0.87        perf-profile.children.cycles-pp.rb_erase
      1.46            -0.2        1.21        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.53 ±  3%      -0.2        0.30 ±  3%  perf-profile.children.cycles-pp.read@plt
      1.05 ±  7%      -0.2        0.82        perf-profile.children.cycles-pp.x64_sys_call
      1.17            -0.2        0.94        perf-profile.children.cycles-pp.get_nohz_timer_target
      4.34            -0.2        4.13        perf-profile.children.cycles-pp.read_tsc
      4.72            -0.2        4.52        perf-profile.children.cycles-pp.ktime_get
      1.54            -0.2        1.36        perf-profile.children.cycles-pp.hrtimer_forward
      2.00            -0.2        1.82        perf-profile.children.cycles-pp.rw_verify_area
      1.03            -0.2        0.86        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.72            -0.1        0.57        perf-profile.children.cycles-pp.__wake_up_common
      1.98            -0.1        1.83        perf-profile.children.cycles-pp.irqtime_account_irq
      0.75            -0.1        0.62        perf-profile.children.cycles-pp.rb_insert_color
      1.59            -0.1        1.46        perf-profile.children.cycles-pp.__irq_exit_rcu
      0.65            -0.1        0.52        perf-profile.children.cycles-pp.enqueue_hrtimer
      1.46            -0.1        1.34        perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.78            -0.1        0.66 ±  2%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.99            -0.1        0.87        perf-profile.children.cycles-pp.hrtimer_update_next_event
      0.34 ±  5%      -0.1        0.23 ±  2%  perf-profile.children.cycles-pp.irqentry_exit
      1.46            -0.1        1.37        perf-profile.children.cycles-pp.sched_clock_cpu
      0.47            -0.1        0.38        perf-profile.children.cycles-pp.rb_next
      0.69            -0.1        0.60 ±  2%  perf-profile.children.cycles-pp.__hrtimer_next_event_base
      0.40 ±  3%      -0.1        0.32 ±  2%  perf-profile.children.cycles-pp.__x64_sys_read
      0.40            -0.1        0.32 ±  2%  perf-profile.children.cycles-pp.idle_cpu
      0.78            -0.1        0.70        perf-profile.children.cycles-pp.error_entry
      1.23            -0.1        1.17        perf-profile.children.cycles-pp.sched_clock
      0.84            -0.1        0.78        perf-profile.children.cycles-pp.security_file_permission
      1.08            -0.0        1.03        perf-profile.children.cycles-pp.native_sched_clock
      0.25            -0.0        0.20 ±  2%  perf-profile.children.cycles-pp.__wake_up_locked_key
      0.18 ±  2%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.timerfd_settime
      0.29            -0.0        0.26        perf-profile.children.cycles-pp.tick_program_event
      0.15 ±  2%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.hrtimer_reprogram
      0.11 ±  4%      -0.0        0.08        perf-profile.children.cycles-pp.timerfd_gettime
      0.07 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.__x64_sys_timerfd_settime
      0.08            -0.0        0.07 ±  7%  perf-profile.children.cycles-pp._copy_from_user
      0.13 ±  3%      -0.0        0.12        perf-profile.children.cycles-pp.sched_core_idle_cpu
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.error_return
      0.32 ±  2%      +1.2        1.53 ±  3%  perf-profile.children.cycles-pp.hrtimer_cb_get_time
      3.72 ±  2%      +2.6        6.30 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      5.29            +3.4        8.72 ±  3%  perf-profile.children.cycles-pp.__x64_sys_poll
      5.29            +3.4        8.72 ±  3%  perf-profile.children.cycles-pp.do_sys_poll
      5.05            +3.5        8.52 ±  4%  perf-profile.children.cycles-pp.do_poll
      3.43            +3.7        7.10 ±  5%  perf-profile.children.cycles-pp.timerfd_poll
      6.16            +4.1       10.27 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     78.28 ±  2%      +9.6       87.89        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     77.33 ±  2%      +9.8       87.13        perf-profile.children.cycles-pp.do_syscall_64
     46.08 ±  4%     +18.8       64.88        perf-profile.children.cycles-pp.ksys_read
     40.53 ±  5%     +18.9       59.46        perf-profile.children.cycles-pp.vfs_read
     34.46 ±  5%     +19.4       53.88        perf-profile.children.cycles-pp.timerfd_read_iter
      7.50 ± 11%      -3.4        4.14 ±  3%  perf-profile.self.cycles-pp.do_syscall_64
      8.16            -1.3        6.88        perf-profile.self.cycles-pp.lapic_next_deadline
      1.95 ± 12%      -1.1        0.85 ±  2%  perf-profile.self.cycles-pp.sync_regs
      6.85 ±  3%      -1.0        5.81        perf-profile.self.cycles-pp.native_irq_return_iret
      5.36 ±  8%      -0.6        4.74        perf-profile.self.cycles-pp._copy_to_iter
      3.01            -0.5        2.49        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      2.40            -0.5        1.92        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      3.34 ±  2%      -0.5        2.88 ±  2%  perf-profile.self.cycles-pp.vfs_read
      1.23 ±  2%      -0.4        0.86 ±  2%  perf-profile.self.cycles-pp.stress_timerfd
      3.33            -0.3        3.02        perf-profile.self.cycles-pp.native_apic_msr_eoi
      1.48            -0.3        1.19        perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      1.70            -0.3        1.42        perf-profile.self.cycles-pp.__hrtimer_run_queues
      0.99            -0.3        0.73 ±  2%  perf-profile.self.cycles-pp.rb_erase
      1.23            -0.3        0.98        perf-profile.self.cycles-pp.switch_hrtimer_base
      1.42            -0.2        1.18        perf-profile.self.cycles-pp.entry_SYSCALL_64
      2.44 ±  4%      -0.2        2.22 ±  4%  perf-profile.self.cycles-pp.fdget_pos
      1.05            -0.2        0.84 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.56 ±  2%      -0.2        0.36 ±  2%  perf-profile.self.cycles-pp.read
      4.08            -0.2        3.90        perf-profile.self.cycles-pp.read_tsc
      0.94            -0.2        0.75        perf-profile.self.cycles-pp.do_poll
      1.10            -0.2        0.92        perf-profile.self.cycles-pp.rw_verify_area
      1.40            -0.2        1.22        perf-profile.self.cycles-pp.hrtimer_forward
      0.84            -0.2        0.67 ±  2%  perf-profile.self.cycles-pp.timerfd_tmrproc
      1.07            -0.2        0.90        perf-profile.self.cycles-pp.timerqueue_add
      0.79            -0.2        0.63        perf-profile.self.cycles-pp.timerfd_poll
      0.78            -0.2        0.62        perf-profile.self.cycles-pp.get_nohz_timer_target
      0.65 ±  3%      -0.1        0.51 ±  2%  perf-profile.self.cycles-pp.x64_sys_call
      0.63            -0.1        0.50 ±  2%  perf-profile.self.cycles-pp.timerqueue_del
      0.78            -0.1        0.66 ±  2%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.60            -0.1        0.48        perf-profile.self.cycles-pp.__wake_up_common
      0.65            -0.1        0.53        perf-profile.self.cycles-pp.rb_insert_color
      0.68            -0.1        0.56        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.56            -0.1        0.45        perf-profile.self.cycles-pp.enqueue_hrtimer
      0.80            -0.1        0.72        perf-profile.self.cycles-pp.hrtimer_interrupt
      0.62            -0.1        0.55        perf-profile.self.cycles-pp.__hrtimer_next_event_base
      0.54            -0.1        0.46        perf-profile.self.cycles-pp.security_file_permission
      0.19 ±  3%      -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.read@plt
      0.74            -0.1        0.67        perf-profile.self.cycles-pp.error_entry
      0.38            -0.1        0.32        perf-profile.self.cycles-pp.rb_next
      0.64            -0.1        0.58        perf-profile.self.cycles-pp.clockevents_program_event
      0.25 ±  2%      -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__x64_sys_read
      0.30            -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.idle_cpu
      0.50            -0.1        0.44        perf-profile.self.cycles-pp.irqtime_account_irq
      0.56            -0.1        0.51        perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.33            -0.0        0.29        perf-profile.self.cycles-pp.hrtimer_update_next_event
      1.03            -0.0        0.99        perf-profile.self.cycles-pp.native_sched_clock
      0.50            -0.0        0.46        perf-profile.self.cycles-pp.ktime_get_update_offsets_now
      0.20            -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.irqentry_exit
      0.38            -0.0        0.34 ±  2%  perf-profile.self.cycles-pp.__sysvec_apic_timer_interrupt
      0.18 ±  2%      -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.__wake_up_locked_key
      0.17 ±  2%      -0.0        0.14 ±  2%  perf-profile.self.cycles-pp.do_sys_poll
      0.23            -0.0        0.20        perf-profile.self.cycles-pp.sched_clock_cpu
      0.24            -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.tick_program_event
      0.32 ±  2%      -0.0        0.30        perf-profile.self.cycles-pp.__irq_exit_rcu
      0.13 ±  2%      -0.0        0.11        perf-profile.self.cycles-pp.hrtimer_reprogram
      0.34            -0.0        0.32        perf-profile.self.cycles-pp.sysvec_apic_timer_interrupt
      0.11 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.sched_core_idle_cpu
      0.10            -0.0        0.09        perf-profile.self.cycles-pp.sched_clock
      2.25            +1.1        3.30 ±  2%  perf-profile.self.cycles-pp.hrtimer_start_range_ns
      0.24 ±  3%      +1.2        1.46 ±  3%  perf-profile.self.cycles-pp.hrtimer_cb_get_time
      3.42 ±  2%      +2.6        6.04 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      5.74            +4.2        9.93 ±  5%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      3.94 ±  3%      +6.1       10.07 ±  2%  perf-profile.self.cycles-pp.timerfd_read_iter




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



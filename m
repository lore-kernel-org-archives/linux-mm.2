Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650DCCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE69E8011D; Tue, 28 Oct 2025 01:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9796800E4; Tue, 28 Oct 2025 01:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938BB8011D; Tue, 28 Oct 2025 01:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE4D800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:58:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C20AC0346
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:58:24 +0000 (UTC)
X-FDA: 84046468128.25.09D6C73
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id 101FEA0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:58:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZNEV3DO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761631100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=20vGgDmlw9cjQSQiSTNCUCjCFdUZ/m04X67QCTQDdyc=;
	b=M/A6tuHnqXLK0LXPYF70+4sNVqttSM4lbxsWMOxLaV5t80v+YVc+0UBOnL7vVWfzD3Q/1n
	9Oh9tBQ3B/SZkm5ZUXJAaUy0kAPjxTK96qqaTnZ834vcqwcKKY1FO67kodaePUPX9Ysb4u
	TrMeIkF/bpzOfX8WyTZnCLy60fk0tzI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761631100; a=rsa-sha256;
	cv=fail;
	b=T+PT9nLliZ4Vu1VIkV9uPmAJPafuoOGHTb50pKzNSowVlGV4mJHe1A/G7R5T4ea5SPtfQz
	gVA1ZNF0D0GQDAokPw5xCrWVcHYCBnGEDiBbq/AmYBNX+Oeo6kM9WnnwOpR3M3tgQSAXOT
	4j8xwuSBWGAjFNPe6Z0t5CPZpKT44w8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZNEV3DO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761631100; x=1793167100;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=yCNhNRJlKPDyWInAbHOXh3ZDmkK3AxeaYfHy497csgY=;
  b=JZNEV3DOhrAK34rYfow0hmxppxzJ7wtriEHx4Tv/VQ5Nw1L6psdxgafC
   yQeMoTaVaE3oiwaVOZLck1tkoX8j/ckhX0XZJkWNOtj33b3awhOQ3875w
   YV3sxoj1wO3uzj7rlNxb0c1YsNAu22Nkh/RXASeSyRkpTXGKnOU1PaekB
   s0hMtmqbiIJQW32rS5nKdzfooRnkAovXPw6BPCh8lPrrAH7C9m+NiMZfw
   myDVm+K96LsCU6Em7LJeA/7NA6HNhDZuh6ki8jYyRavVkZ225TpuglyjD
   7GLuBOzaAKGlTg/gfxm0Bee/nwW3/oEqqBLF7yakqwTw03Viv1C+GsF+k
   g==;
X-CSE-ConnectionGUID: 40dAH16MTMmpDgkHQvKqhA==
X-CSE-MsgGUID: frXcmwsPSPaK5B8+pGCz3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="51297008"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="51297008"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 22:58:18 -0700
X-CSE-ConnectionGUID: LnckiIh8RVy768ALLXnF+g==
X-CSE-MsgGUID: nmnBOXyuQxu2XltQDgGZ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="185339396"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 22:58:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 22:58:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 22:58:17 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.23) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 22:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9REOqhoRFl8NtAWzeDMBNwX+N7IuwluU/fV4sgSfTcKoUbUPmwQXFDyxEmPtS9z8Aio82nYsUk6eP9OC+b045G8MW33WNHig5kDyn5Y25EiGIdZxvrS0GM41B1TOr5NPj3Mxi6zHh7Rw0gEWaDcX4hd7C94FhXnhJRtGPGH1kw/JGoDdV8EL3JH+t3VCblUDmDpxC6jFkXbRWN/emS8kj7AGalwvbnW43GNG3LKYXPlz5kzyKGxA6AmTSsk+RX7VQGSeqTCbfA1cGwhfyaIj1Mto/pzS2a3ie2b9AzEw93siv74D7v+umaH/AR0fjnCuhO5BWqZnFi6b+PpAtfDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0CqXZFkJmozBuKU1o+W67qzhxzCTZhXpsDr2wbHGWI=;
 b=mCeXshbPJZCdNZNxGuoF0xz8QUVqkZ9Bar77BtnRkrDWfO1W8gbdfD2nm0CCZ/hUxS6BG6iR5gXObtj91tzgAnNgtLhrvfSX5UTbowN90ZlgKdyQHgXtXWtdF20Ov08ae0eEMP/ZTd7vc9RL86MFIH81l82z8g9Q66dj/VPal0T5rvVQeBhZF9mI/CQgnsETlQ1oBbQBQ0J+i4ouU4M3Z0GgUSn7anfQ91La1KgeTN4SE29k99wGAChqml/uaRQgLbzv8y7ASPlggJVPcLV8zZ2EKLCQJFE1QjFUm7dH/4UoG5mkpa4VRT3X0AesDeQEZyAhpQ1qjO/g4aBEta6n5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 05:58:09 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%7]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 05:58:09 +0000
Date: Tue, 28 Oct 2025 13:58:00 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [mm/fault]  19773df031:  vm-scalability.throughput
 219.8% improvement
Message-ID: <202510281329.6cb88a0d-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PUZP153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:301:c2::21) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|BL1PR11MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: aaeca692-6eaf-486b-9782-08de15e6f88c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?eMXQYQFJkdaH3Dgfdouwj0mzskOJw4NJQDF5v2WuS10/VC4OVQ39EMrwsR?=
 =?iso-8859-1?Q?Z6g9adJdnv9x5W7ei4pPGMgZjV8fNTqAR8CIOfSakBlfcmsUt//K8vbKHJ?=
 =?iso-8859-1?Q?lvW5gHM3C1R2vV1Aqt7Xlv6cw9K7OlPK7za2mx70ZdcbjwY9PsZ0Zn+cTc?=
 =?iso-8859-1?Q?qdZeWED+PbOcdOlHeBdFMBifqVmnkLHSj+O8QXE30qPkckRQ+n2rfdZOQ2?=
 =?iso-8859-1?Q?25Aj/u66k6Def4UAN0VaIhke5gDNFmsWjW8awV7GCgbdY/8iFf7jcTHHAf?=
 =?iso-8859-1?Q?SPlpfNuZ5FZiEIqwIi7drtjF+IMyX6U/qVFr1gHdKpyeutWiCSF+cNq4eC?=
 =?iso-8859-1?Q?uBI3TpKoZuJmW3Kr7XpNX/Bzd1jzowgqAG20LtGNtNI1Vtc0fNzpeZmJsm?=
 =?iso-8859-1?Q?4+nYfJKuU5VBNjjqBfBx0i/nS1a4EViakDrQjPTG1GxLhFFY2tphdbDbUA?=
 =?iso-8859-1?Q?d+0TyruabTwLcqHqdrJMfL9HrPc6i6UNSJjYE2BNWIFFoECFTnK9lNvQmZ?=
 =?iso-8859-1?Q?RTihdi42j137/nEIPbqi+rsD4EftHkLNImaK7qaY1+WXIXhxhU2/c2lkb5?=
 =?iso-8859-1?Q?5kW/S/83FbMjoJnmhlrdu3nyywkMOE7rvoL2ZAQD+wXC+BEdzR88NUnDxT?=
 =?iso-8859-1?Q?LshmFWZT72kgdfTJ6pHwjyy1BVrU7FzLslunrrhoMEM3PZAyx43cW7wXY0?=
 =?iso-8859-1?Q?eqBN/81vAO6op6wblRLkNxHQQj4arfey/UiVPb7toKl+dWBR2rok9pkX2/?=
 =?iso-8859-1?Q?QU3odXl/sgEuHfX1t0gmFmMlv/8Ui//0jJcTA5bszA/RBUbzl0/XOxDb+G?=
 =?iso-8859-1?Q?hw1tgoMI0NP++LPwB5XlVVjy1CWndArhx9RBkPxdKDDWDQMYdKz7cIqdNA?=
 =?iso-8859-1?Q?9POOA2f8TXJ74KtCxDqkLw+J/zo8cMX8JJB6ybN2WzeK0CUzOtFlpe5Z2p?=
 =?iso-8859-1?Q?PAIQH4dTnKbm6BsT/IzeDL2vMIMXej/bNGyKq2OTjVHOPt0jOjhcZ4QuFp?=
 =?iso-8859-1?Q?qAxOrtibsvo0w1LaBbc3sPKrq+1wGDh4snFGuSuOWen8fXoGD0T6R+WoGs?=
 =?iso-8859-1?Q?Nxf+/DbshGWHs3wyDaTTbn1I9tDNzkVm8GZlSFK5D7HygWnNEJtZEJE0yK?=
 =?iso-8859-1?Q?YN5S1haBNzmba7gRsQT7nM8CyhdtS52BuYuR7x5sF/O0Ztuj1hkMzHD4Eh?=
 =?iso-8859-1?Q?kKZRAtzzEnCpbP3Co35D8F/TczHw/RSWyYqSDRYtwRW+LWJuZjlyh6ox4j?=
 =?iso-8859-1?Q?TsI9KIVvA2YBgs5bpIEUmgnh3J0B1Zc9FA6vlwF56LNWqOGAbV891FeYan?=
 =?iso-8859-1?Q?ZIbrY1hdS+d42ckXpLNYZCiFQr94zQhC6J+yLojr8W5vaesltWZKT86v04?=
 =?iso-8859-1?Q?ZsVhOLc4s1i+FDlQ0LfuxQa0ZbrQfNmI9C+znpRIF4m8VDB6XBwEnbBnj5?=
 =?iso-8859-1?Q?j2Rhqesgtny4fxj6avN7Mf0ojcnfxYRMAl4f/hVnPs8LDToCW8s6e0/xlW?=
 =?iso-8859-1?Q?50BknRLXxJxDeoIbKO1VnvmrXPPQ+Z7HC8FlXWNZiyBg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?vyJ90Jzl9Bumr6G8fTTCKsmqOOe9P2ps4eROTkyLEIzVJl3R6BdTN1aWam?=
 =?iso-8859-1?Q?pPLZyv9y1jGU/H5MmtLw58T1VbMdQXJ0Sn/a/jv+hu9pTi3LjXSdpm2Pus?=
 =?iso-8859-1?Q?xz86h77j+rC6X659Ykia45ybKfIINa6LrB3pn2d1ApjwqkTP8+yQZXSlgX?=
 =?iso-8859-1?Q?G3QxcNjDHE+anitkda+LuMC+zcQBohkiIdV4ZI0rZTkxEOOvkdplqruDiq?=
 =?iso-8859-1?Q?CjaMnS08hqRiGtn+LWZ7lfrvD0vpziKr4gGCr4HlQNYjeu291CzePQoSqZ?=
 =?iso-8859-1?Q?n9uAak2uRCs21i+zusC/9LbzWAjx/VNLPvLWDZYy6rsQ0g3B9q+rVKXpk9?=
 =?iso-8859-1?Q?blXmvrCQjM2Jmpz5rOk/tz3hKQ6Y5Cjb0bSzurlL7L6SHMZAbSNev8cESG?=
 =?iso-8859-1?Q?lwEiRxtmWd69gq0ANGdwAeu1je3POM8vtlkZPhNdhxj9zgL4l21CbZ0XCN?=
 =?iso-8859-1?Q?qf6h13gQ+i+ngTwpdulMA6fxvlK5KM7mdoF+HqJZ2c6Ur6BPAZtEn0W1ns?=
 =?iso-8859-1?Q?z3RFt1tjUhTDNLeCwiqnaU6Ph5uFxcY2mhpP3C0jY2G6QWlrKJa5yAm6D5?=
 =?iso-8859-1?Q?nKtcWl7XxIAglifBin/ikbS+bcKyzRmByxWGsQYDLgrr3Gu4AqgL9sPtkU?=
 =?iso-8859-1?Q?VhKYgigVf+exP8RkMizJTjlk7yHnccTFHk6fDYH5bXDlb/jZBEj2JdWR/2?=
 =?iso-8859-1?Q?gDkMlg3XHhh8kM+Wwy7Q7/pZn/3DGv6u7uHzTJ0TQoFB2GKoHa0waXj4G/?=
 =?iso-8859-1?Q?PAHlw3Lss8y8fSiheSmUrbtdb6LQHKlimO6HSqJgHYw67rJVwkfWGFQJSV?=
 =?iso-8859-1?Q?NSESElXpJvHvQmeMTt9R/bFVgGOFr1VgBS21GP0zrmYlQZbIDQEwHCaUnb?=
 =?iso-8859-1?Q?P/PmanKlidx55Yil+yvOtfL4smlN0iERUq/E3BVXzs3TwwLyAszvosj1Jt?=
 =?iso-8859-1?Q?ETnrcA8I2SJYYlxS2+sSl//9qSE2pKsmr726hugBgKsVEShcurTQgCZ/xR?=
 =?iso-8859-1?Q?hrlB/yGXhJnhr1wZAA2BzJgT4xid4kvLnRm/b/ymBpQrhezTOubBriLFOH?=
 =?iso-8859-1?Q?TnfeCQXctF4shVVNKrb0HMI8ur2j8X39LSSGVusFWMCEYXoKlJTVayAWso?=
 =?iso-8859-1?Q?YM+6OOblFaTRhWqq1mqN7AQbksH1uRUx+0GnjaezLE+Q3V1g8vXTHM6uGk?=
 =?iso-8859-1?Q?2nBw+CeFF7KsFBqUtzRdoPA497mNhQdLe57ZPsokC0OLu60F5yCE3yhg1d?=
 =?iso-8859-1?Q?yUDj4l3TbOlZoe2dzFKWwVJPprM/QbrfUpB7ctxjJ+hvsK3VaRX0QcDAgu?=
 =?iso-8859-1?Q?quYMXwo9Dk9HleKktDaDld+0DM8TOZ7iJgtbV9PxW/GY74SyMn+GfzE7R3?=
 =?iso-8859-1?Q?lohDq5q5Sl+v/aCtjaK44vR9c8mQ67QiHYizCHXFhvUnWIHtWeueIbs4Xa?=
 =?iso-8859-1?Q?0LBGLC4wwA1En8imjCPklY2A7zDJFFpxp52CBujSwt6I0azgXJC/OhgTLE?=
 =?iso-8859-1?Q?n0igfryQ2TBXLH5U0Ws0jR20v847jxa873igLonVyy8YKxagcjsj1K0OTW?=
 =?iso-8859-1?Q?PHnujLVLhflA9vN5PafCZj+QhgvS4Bo5yHG34pk9IZntzSTQx2KJoYuMJM?=
 =?iso-8859-1?Q?MFKaA1lnsBFYqA1HJX5lrELKlJrTtiS7w1NHQVTxB8XUiYLRJ2WzkzvQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aaeca692-6eaf-486b-9782-08de15e6f88c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 05:58:09.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHBQ5uwfERaAdmNeHRTsgL++D1A+fehb4CcPj7+khuEDjM8zbQVEi9ByiFg4lToJLyR4cx7kKR9+j0F5XkNeww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Stat-Signature: ssk54uh75hkb7a715587q8exff8dsb3m
X-Rspam-User: 
X-Rspamd-Queue-Id: 101FEA0008
X-HE-Tag: 1761631099-34618
X-HE-Meta: U2FsdGVkX19EfQA0uF+EZf/+ecNazorjyLFtfTsLbJZjt3GzzvuEeFZbb+TnMaY3jn8CLL+zJcOthrNVeZofi76GnBbBGF2UyzHjrspmfLV2QKhOXICP4DURSGM1OQHuqxMnDYMNHoHoOKfEH+auHEnKcCU+cQZ/agOtvel8Ns+kHeLmiVTnXzkVAJjOfd/X7XFUhE47sFzwV518ZRV0Lniajs99Q2o0U9ldwn1hZpiJ3pk0UTz03rpU58QtdbAd0kSVx0f1Y092v569mXMDccIzPrACboCz8S3rZUFK9vIHY/bfnMvCMH5uGyt8xgNj7Cz9odrPL6ZSaR4Q4Vm5GIxAuoJ5B6b8dro3dyrdlfho9Cwrh1uyNHJI4idv6lbEm61WwDsaI/DrcCBHSlma5YkySVj2sKQt9o2KLddA55VTNs4D9zprE5aR4STiMDQLQ7wfXKSvA6ZrEPIoXnTvuOshyn8paBhvhZUgyOgZnwINtxwYTKpWvaysMi5zpX9d0ulngMJJZH1yK4B/1Wb5OEhGcSu8NSZuWK3yDt7gJ2mxZsXM7esTuYgJm9DY5tK5Xx0bzd0T9HqC9mCWU8ogcvwXMJ7vP76wZ/r+xkOdzxPlIXWqAOUJNejN+z6JTAtCS8IsZc4mSxukTgHRduauujVP8/PFocURosgVMkljU4NrunCsfx3JzuJ9FULTYR1kfI2DwksXRhPkIQrfBKKI9+eXCtujOYbD5BepkrW5/Xdt6QTDzyb9jePRNYQsNDWomLuxcFUQVUif5AXSB14nKYUF4KK3eG2qLqVqP5yBNmmtX11CqBDuw1chU9lfZaxiPT1W3lq8xnIIzmMZ9OcVr9r8C7f4m0Y2tUAksnj3gJ08luadsnNSSyPn0agz2tyqTsRXKHONNmZCvGvRoXxiyh4w7URfQ/KO3lEGvmcI/tX63VSgWUwL4aM9zueabqQ4SWPXQvjsXBfOaCFST3l
 2NX5bz1y
 anZKMopwMPo0qYL0C7+LXebsm8K5GMmCSjvMLZnVarASmEQ1301sTdCDkNTTltJTs7vFIUj0f3KUixHVL9hkK/jSprRNqAtUFdiXLePlfq5KbMAH2o29dyopY/Of9bdEu5TQHpVqwB/GGmMAdQlUTVnsWNROFF8Sdeg3JoHcwqr7Agd8cR/bg/eTZzQdOu3E989uxLKd+szEssFFNyjFse4vKHjOeBGeX/440QS3uwlK9YE3xjBQ50iMOxsp3uFryqYYeDDQBAQBI75ePta9kKGjQMryXVRqWVH4pq6EXu0QWEWHObmtglqhGDfR7nuA/zKT1VnucB0lxM1PIEeWPMqijimSH0o23rdfnJOzDe72xEmS4srVvEUn+JDgZjXF5bB/mSjdWT2bcLPcNJ5qNMqTiYttWKhvFFIQCNdNVO/vEQ4mQc3edpwcCT6K66NOZd+MHcVevp1VMmikZzjx8mxtEUpwPYZtViFal6THH2bx/ajj75CmRNm5N6FIleFfIwuR/g8LrQg434Wja+LWOFRLosU7lSNVEAguHtMDrUxg7EiAVu2Dtfp7MJjl+mnHfsa9Os4PbUDnrR2czG8w3RT0ERLZMPq7bFZ8I7ItukqmuwzsbVwD4kmrrqWJOzC9wHWh0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 219.8% improvement of vm-scalability.throughput on:


commit: 19773df031bcc67d5caa06bf0ddbbff40174be7a ("mm/fault: try to map the entire file folio in finish_fault()")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: vm-scalability
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
parameters:

	runtime: 300s
	size: 256G
	test: msync-mt
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251028/202510281329.6cb88a0d-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/size/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/256G/lkp-cpl-4sp2/msync-mt/vm-scalability

commit: 
  8c49fbafed ("mm/rmap: mlock large folios in try_to_unmap_one()")
  19773df031 ("mm/fault: try to map the entire file folio in finish_fault()")

8c49fbafedf15149 19773df031bcc67d5caa06bf0dd 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     14932           +97.6%      29512 ±  3%  uptime.idle
 4.051e+10 ±  2%     +45.6%    5.9e+10        cpuidle..time
 1.542e+08           -44.1%   86171240        cpuidle..usage
  10212109 ± 77%    +110.9%   21535225 ± 44%  numa-meminfo.node0.Active
   8899644 ± 92%    +249.1%   31067068 ±  4%  numa-meminfo.node2.Active
     10164 ±152%    +334.6%      44173 ± 70%  numa-meminfo.node2.Writeback
   1371819 ±139%    +367.0%    6405839 ± 70%  numa-vmstat.node2.nr_dirtied
      2547 ±151%    +322.9%      10774 ± 70%  numa-vmstat.node2.nr_writeback
   1371819 ±139%    +367.0%    6405839 ± 70%  numa-vmstat.node2.nr_written
      1570 ±  6%     -88.7%     177.17 ± 13%  perf-c2c.DRAM.local
     52876 ±  4%     -92.8%       3799 ± 14%  perf-c2c.DRAM.remote
     23243 ±  3%     -90.0%       2327 ± 14%  perf-c2c.HITM.local
     29958 ±  6%     -90.2%       2946 ± 15%  perf-c2c.HITM.remote
     53202 ±  5%     -90.1%       5273 ± 13%  perf-c2c.HITM.total
      6.55 ±  5%     +19.7       26.23 ±  4%  mpstat.cpu.all.idle%
     45.99 ±  4%      +6.4       52.42 ±  2%  mpstat.cpu.all.iowait%
      0.81 ±  2%      +0.3        1.10 ±  3%  mpstat.cpu.all.irq%
     40.50 ±  4%     -39.5        1.04 ±  7%  mpstat.cpu.all.sys%
      6.09 ±  7%     +13.1       19.15 ±  4%  mpstat.cpu.all.usr%
     45.50 ± 34%     -54.9%      20.50 ±  6%  mpstat.max_utilization.seconds
     85.91           +16.4%     100.00        mpstat.max_utilization_pct
      2.31 ±  2%   +3430.3%      81.57 ±  6%  perf-sched.total_wait_and_delay.average.ms
   1034119           -96.5%      36311 ±  6%  perf-sched.total_wait_and_delay.count.ms
      3639 ± 19%     +29.2%       4703 ±  7%  perf-sched.total_wait_and_delay.max.ms
      2.30 ±  2%   +3445.1%      81.55 ±  6%  perf-sched.total_wait_time.average.ms
      3639 ± 19%     +29.2%       4703 ±  7%  perf-sched.total_wait_time.max.ms
      2.31 ±  2%   +3430.3%      81.57 ±  6%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   1034119           -96.5%      36311 ±  6%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      3639 ± 19%     +29.2%       4703 ±  7%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      2.30 ±  2%   +3445.1%      81.55 ±  6%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      3639 ± 19%     +29.2%       4703 ±  7%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1707 ±  4%     -51.8%     822.33 ±  4%  turbostat.Avg_MHz
     45.05 ±  4%     -22.8       22.23 ±  3%  turbostat.Busy%
      3800            -2.4%       3707        turbostat.Bzy_MHz
     55.72 ±  3%     +22.7       78.45        turbostat.C1%
     54.95 ±  3%     +41.5%      77.77        turbostat.CPU%c1
      0.09 ±  6%    +625.9%       0.65 ±  5%  turbostat.IPC
 6.569e+08           +60.4%  1.054e+09 ±  2%  turbostat.IRQ
   3422628 ± 16%     -65.8%    1169078 ±  5%  turbostat.NMI
      0.04 ± 80%     +37.7       37.75 ± 12%  turbostat.PKG_%
      0.02            -0.0        0.00        turbostat.POLL%
    632.06            -4.9%     601.31        turbostat.PkgWatt
     20.00            +9.1%      21.81        turbostat.RAMWatt
    105888          +219.8%     338651        vm-scalability.median
  23718991          +219.8%   75857914        vm-scalability.throughput
    322.82            +3.5%     334.19        vm-scalability.time.elapsed_time
    322.82            +3.5%     334.19        vm-scalability.time.elapsed_time.max
  43166464 ±  2%    +355.3%  1.966e+08        vm-scalability.time.file_system_outputs
    474115 ±  9%     -89.8%      48269 ±  9%  vm-scalability.time.major_page_faults
  92402718 ±  4%      +5.2%   97195175        vm-scalability.time.maximum_resident_set_size
 1.404e+08           -97.8%    3072180        vm-scalability.time.minor_page_faults
      9681 ±  4%     -52.8%       4572 ±  3%  vm-scalability.time.percent_of_cpu_this_job_got
     27262 ±  5%     -98.7%     359.09 ±  2%  vm-scalability.time.system_time
      3999 ±  8%    +273.3%      14931 ±  5%  vm-scalability.time.user_time
 1.018e+08           -79.9%   20438880        vm-scalability.time.voluntary_context_switches
 7.586e+09          +226.4%  2.477e+10        vm-scalability.workload
  34888848 ± 15%    +145.4%   85621792 ± 18%  meminfo.Active
   7310633 ±  6%    +445.1%   39853582 ±  3%  meminfo.Active(anon)
 1.022e+08           +32.5%  1.355e+08        meminfo.Cached
   9363283 ±  3%    +360.5%   43121914        meminfo.Committed_AS
   4282466 ± 11%    +401.1%   21459881        meminfo.Dirty
    370553           +19.1%     441328        meminfo.KReclaimable
 1.819e+08           -18.1%   1.49e+08        meminfo.MemAvailable
  91015231           -36.5%   57825528        meminfo.MemFree
 1.055e+08           +31.4%  1.387e+08        meminfo.Memused
    214809           +44.3%     309961        meminfo.PageTables
    370553           +19.1%     441328        meminfo.SReclaimable
   6818169 ±  4%    +483.6%   39790879        meminfo.Shmem
     44130 ±  9%    +280.4%     167890        meminfo.Writeback
 1.064e+08           +33.0%  1.415e+08        meminfo.max_used_kB
   1828808 ±  6%    +444.2%    9952792 ±  3%  proc-vmstat.nr_active_anon
    170689            -1.8%     167683        proc-vmstat.nr_anon_pages
   5395818 ±  2%    +355.3%   24568992        proc-vmstat.nr_dirtied
   1071381 ± 11%    +400.4%    5361250        proc-vmstat.nr_dirty
   4544315           -18.1%    3722750        proc-vmstat.nr_dirty_background_threshold
   9099741           -18.1%    7454603        proc-vmstat.nr_dirty_threshold
  25563358           +32.4%   33838021        proc-vmstat.nr_file_pages
  22746053           -36.3%   14482315        proc-vmstat.nr_free_pages
  22637748           -36.5%   14381767        proc-vmstat.nr_free_pages_blocks
     53694           +44.3%      77488        proc-vmstat.nr_page_table_pages
   1705595 ±  4%    +483.1%    9944551        proc-vmstat.nr_shmem
     92651           +19.0%     110261        proc-vmstat.nr_slab_reclaimable
     10943 ± 10%    +287.0%      42350 ±  4%  proc-vmstat.nr_writeback
   5395818 ±  2%    +355.3%   24568992        proc-vmstat.nr_written
   1828818 ±  6%    +444.2%    9952805 ±  3%  proc-vmstat.nr_zone_active_anon
   1082406 ± 11%    +399.2%    5403642        proc-vmstat.nr_zone_write_pending
   2590032 ± 14%    +605.9%   18284325 ± 29%  proc-vmstat.numa_foreign
     30195 ± 33%     -70.3%       8960 ± 60%  proc-vmstat.numa_hint_faults_local
   2595314 ± 14%    +604.8%   18292700 ± 29%  proc-vmstat.numa_miss
   2936800 ± 12%    +534.3%   18627037 ± 28%  proc-vmstat.numa_other
   2915400 ±  5%    +508.8%   17748564 ±  6%  proc-vmstat.numa_pte_updates
  33566794 ±  2%     +56.1%   52386897 ±  3%  proc-vmstat.pgalloc_normal
 1.422e+08           -96.9%    4400645        proc-vmstat.pgfault
  33054236 ±  3%     +58.7%   52453249 ±  3%  proc-vmstat.pgfree
  21585606 ±  2%    +355.3%   98278397        proc-vmstat.pgpgout
      4.73           -43.2%       2.69        perf-stat.i.MPKI
 2.057e+10          +272.1%  7.654e+10        perf-stat.i.branch-instructions
      0.59 ±  2%      -0.1        0.54 ±  6%  perf-stat.i.branch-miss-rate%
  41216023           -42.4%   23737381        perf-stat.i.branch-misses
     57.95           -28.6       29.31        perf-stat.i.cache-miss-rate%
 3.058e+08 ±  2%     +25.0%  3.823e+08        perf-stat.i.cache-misses
 5.295e+08 ±  2%    +271.8%  1.969e+09 ±  2%  perf-stat.i.cache-references
    634442           -80.0%     127197 ±  2%  perf-stat.i.context-switches
      5.81 ±  3%     -78.7%       1.23 ±  2%  perf-stat.i.cpi
 3.831e+11 ±  4%     -52.8%  1.808e+11 ±  4%  perf-stat.i.cpu-cycles
      5111 ±  2%     -90.1%     503.93        perf-stat.i.cpu-migrations
      1339 ±  3%     -54.3%     612.85 ±  4%  perf-stat.i.cycles-between-cache-misses
 6.832e+10          +251.4%  2.401e+11        perf-stat.i.instructions
      0.22 ±  4%    +583.6%       1.48 ±  2%  perf-stat.i.ipc
      1461 ±  9%     -90.1%     145.39 ± 10%  perf-stat.i.major-faults
      6.69           -92.1%       0.53 ±  2%  perf-stat.i.metric.K/sec
    433329           -98.1%       8113 ±  3%  perf-stat.i.minor-faults
    434791           -98.1%       8258 ±  3%  perf-stat.i.page-faults
      0.06 ±141%   +2143.5%       1.32 ±  5%  perf-stat.overall.ipc
    976.32 ±141%    +233.7%       3258        perf-stat.overall.path-length
 6.902e+09 ±141%   +1011.8%  7.674e+10        perf-stat.ps.branch-instructions
 1.017e+08 ±141%    +273.6%    3.8e+08        perf-stat.ps.cache-misses
 1.775e+08 ±141%   +1012.8%  1.975e+09 ±  2%  perf-stat.ps.cache-references
 7.444e+10 ±141%    +200.0%  2.233e+11        perf-stat.ps.cpu-clock
 2.292e+10 ±141%    +950.2%  2.407e+11        perf-stat.ps.instructions
 7.444e+10 ±141%    +200.0%  2.233e+11        perf-stat.ps.task-clock
 7.463e+12 ±141%    +981.3%   8.07e+13        perf-stat.total.instructions
   9100518 ±  7%     -38.9%    5557283 ± 13%  sched_debug.cfs_rq:/.avg_vruntime.min
     83078 ± 21%    +257.2%     296763 ± 11%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.42 ±  3%     -67.0%       0.14 ± 31%  sched_debug.cfs_rq:/.h_nr_queued.avg
      1.19 ±  5%     -16.3%       1.00        sched_debug.cfs_rq:/.h_nr_queued.max
      0.44 ±  2%     -31.0%       0.30 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.42 ±  3%     -67.0%       0.14 ± 31%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.44 ±  2%     -31.0%       0.30 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
      0.81 ± 32%    -100.0%       0.00        sched_debug.cfs_rq:/.load_avg.min
   9100518 ±  7%     -38.9%    5557283 ± 13%  sched_debug.cfs_rq:/.min_vruntime.min
     83078 ± 21%    +257.2%     296763 ± 11%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.42 ±  3%     -66.9%       0.14 ± 31%  sched_debug.cfs_rq:/.nr_queued.avg
      0.44 ±  2%     -30.8%       0.30 ±  4%  sched_debug.cfs_rq:/.nr_queued.stddev
    405.75 ±  5%     -62.0%     154.27 ± 37%  sched_debug.cfs_rq:/.runnable_avg.avg
      1121           -18.4%     915.18 ±  4%  sched_debug.cfs_rq:/.runnable_avg.max
     37.33 ± 89%    -100.0%       0.00        sched_debug.cfs_rq:/.runnable_avg.min
    120.71 ±  4%     +22.4%     147.71 ± 15%  sched_debug.cfs_rq:/.runnable_avg.stddev
    405.08 ±  5%     -61.9%     154.18 ± 37%  sched_debug.cfs_rq:/.util_avg.avg
      1099 ±  3%     -16.9%     913.14 ±  4%  sched_debug.cfs_rq:/.util_avg.max
     31.97 ± 79%    -100.0%       0.00        sched_debug.cfs_rq:/.util_avg.min
    119.90 ±  4%     +23.1%     147.62 ± 15%  sched_debug.cfs_rq:/.util_avg.stddev
    198.57 ± 12%     -69.3%      60.93 ± 89%  sched_debug.cfs_rq:/.util_est.avg
    201.05 ±  3%     -44.9%     110.81 ± 26%  sched_debug.cfs_rq:/.util_est.stddev
    494340 ±  3%    +234.6%    1654216 ±  5%  sched_debug.cpu.avg_idle.avg
   2105158 ±  9%     +41.0%    2968989        sched_debug.cpu.avg_idle.max
    216056 ±  6%    +195.3%     637916 ±  3%  sched_debug.cpu.avg_idle.stddev
      3949 ±  4%     -69.9%       1190 ± 35%  sched_debug.cpu.curr->pid.avg
      4090 ±  2%     -33.4%       2723 ±  4%  sched_debug.cpu.curr->pid.stddev
   1324733           -21.2%    1043522 ±  6%  sched_debug.cpu.max_idle_balance_cost.avg
    855967 ±  4%     -41.6%     500000        sched_debug.cpu.max_idle_balance_cost.min
    123728 ± 10%    +157.0%     318004 ±  4%  sched_debug.cpu.max_idle_balance_cost.stddev
      0.42 ±  4%     -69.5%       0.13 ± 35%  sched_debug.cpu.nr_running.avg
      0.44 ±  2%     -33.7%       0.29 ±  5%  sched_debug.cpu.nr_running.stddev
    386507           -96.2%      14856 ± 36%  sched_debug.cpu.nr_switches.avg
    401629           -93.1%      27626 ± 18%  sched_debug.cpu.nr_switches.max
    343303 ±  3%     -97.8%       7515 ± 53%  sched_debug.cpu.nr_switches.min
      5955 ± 13%     -43.3%       3378 ± 10%  sched_debug.cpu.nr_switches.stddev
      0.43 ±  4%     +67.4%       0.72 ±  7%  sched_debug.cpu.nr_uninterruptible.avg
     76.86 ± 23%     -27.6%      55.63 ± 26%  sched_debug.cpu.nr_uninterruptible.max
    -45.25           -67.9%     -14.51        sched_debug.cpu.nr_uninterruptible.min
     15.62 ± 10%     -55.0%       7.04 ±  8%  sched_debug.cpu.nr_uninterruptible.stddev
     62.87 ± 13%     -62.9        0.00        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.do_access
     62.74 ± 13%     -62.7        0.00        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.do_access
     62.73 ± 13%     -62.7        0.00        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     62.46 ± 13%     -62.5        0.00        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     62.42 ± 13%     -62.4        0.00        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     62.30 ± 13%     -62.3        0.00        perf-profile.calltrace.cycles-pp.do_pte_missing.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     62.30 ± 13%     -62.3        0.00        perf-profile.calltrace.cycles-pp.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     41.22 ± 17%     -41.2        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function_single.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
     34.41 ± 14%     -34.4        0.00        perf-profile.calltrace.cycles-pp.__do_fault.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault
     34.39 ± 14%     -34.4        0.00        perf-profile.calltrace.cycles-pp.filemap_fault.__do_fault.do_shared_fault.do_pte_missing.__handle_mm_fault
     20.51 ± 13%     -20.5        0.00        perf-profile.calltrace.cycles-pp.folio_wait_bit_common.filemap_fault.__do_fault.do_shared_fault.do_pte_missing
     19.98 ± 14%     -20.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.folio_wait_bit_common.filemap_fault.__do_fault.do_shared_fault
     19.91 ± 14%     -19.9        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.folio_wait_bit_common.filemap_fault.__do_fault
     18.81 ± 14%     -18.8        0.00        perf-profile.calltrace.cycles-pp.folio_wake_bit.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault
     18.50 ± 15%     -18.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_wake_bit.do_shared_fault.do_pte_missing.__handle_mm_fault
     18.44 ± 15%     -18.4        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_wake_bit.do_shared_fault.do_pte_missing
     13.18 ± 19%     -13.2        0.00        perf-profile.calltrace.cycles-pp.folio_wake_bit.filemap_fault.__do_fault.do_shared_fault.do_pte_missing
     12.94 ± 19%     -12.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_wake_bit.filemap_fault.__do_fault.do_shared_fault
     12.91 ± 19%     -12.9        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_wake_bit.filemap_fault.__do_fault
      8.38 ±  9%      -8.4        0.00        perf-profile.calltrace.cycles-pp.do_page_mkwrite.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault
      8.37 ±  9%      -8.4        0.00        perf-profile.calltrace.cycles-pp.__xfs_write_fault.do_page_mkwrite.do_shared_fault.do_pte_missing.__handle_mm_fault
      8.29 ±  9%      -8.3        0.00        perf-profile.calltrace.cycles-pp.iomap_page_mkwrite.__xfs_write_fault.do_page_mkwrite.do_shared_fault.do_pte_missing
      8.06 ± 10%      -8.1        0.00        perf-profile.calltrace.cycles-pp.folio_wait_bit_common.iomap_page_mkwrite.__xfs_write_fault.do_page_mkwrite.do_shared_fault
      7.86 ± 11%      -7.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.folio_wait_bit_common.iomap_page_mkwrite.__xfs_write_fault.do_page_mkwrite
      7.84 ± 11%      -7.8        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.folio_wait_bit_common.iomap_page_mkwrite.__xfs_write_fault
     70.28 ±  9%      -7.5       62.74 ±  8%  perf-profile.calltrace.cycles-pp.do_access
      0.00            +0.8        0.81 ± 12%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.49 ± 75%      +0.9        1.39 ± 11%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      0.00            +0.9        0.90 ± 12%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt
      0.00            +0.9        0.90 ± 12%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt
      0.00            +1.0        0.99 ± 37%  perf-profile.calltrace.cycles-pp.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush
      0.00            +1.2        1.16 ±  7%  perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_access
      0.00            +1.2        1.17 ±  7%  perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_access
      0.00            +1.2        1.23 ± 11%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry
      0.00            +1.3        1.27 ±  7%  perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.do_access
      0.00            +1.4        1.44 ± 13%  perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_rw_once
      0.00            +1.4        1.45 ± 13%  perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.do_rw_once
      0.00            +1.6        1.58 ± 12%  perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.do_rw_once
      0.42 ±100%      +1.8        2.19 ± 36%  perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush.page_vma_mkclean_one
      0.42 ±100%      +1.8        2.20 ± 36%  perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush.page_vma_mkclean_one.page_mkclean_one
      0.42 ±100%      +1.8        2.21 ± 36%  perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.ptep_clear_flush.page_vma_mkclean_one.page_mkclean_one.__rmap_walk_file
      0.42 ±100%      +1.8        2.24 ± 36%  perf-profile.calltrace.cycles-pp.ptep_clear_flush.page_vma_mkclean_one.page_mkclean_one.__rmap_walk_file.folio_mkclean
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.__rmap_walk_file.folio_mkclean.folio_clear_dirty_for_io.writeback_get_folio.writeback_iter
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.folio_clear_dirty_for_io.writeback_get_folio.writeback_iter.iomap_writepages.xfs_vm_writepages
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.folio_mkclean.folio_clear_dirty_for_io.writeback_get_folio.writeback_iter.iomap_writepages
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.page_mkclean_one.__rmap_walk_file.folio_mkclean.folio_clear_dirty_for_io.writeback_get_folio
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.page_vma_mkclean_one.page_mkclean_one.__rmap_walk_file.folio_mkclean.folio_clear_dirty_for_io
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.writeback_get_folio.writeback_iter.iomap_writepages.xfs_vm_writepages.do_writepages
      0.42 ±100%      +1.8        2.26 ± 36%  perf-profile.calltrace.cycles-pp.writeback_iter.iomap_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work.worker_thread
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.iomap_writepages.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.wb_workfn.process_one_work.worker_thread.kthread.ret_from_fork
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.wb_writeback.wb_workfn.process_one_work.worker_thread.kthread
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.writeback_sb_inodes.__writeback_inodes_wb.wb_writeback.wb_workfn.process_one_work
      0.42 ±100%      +1.8        2.27 ± 36%  perf-profile.calltrace.cycles-pp.xfs_vm_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.__writeback_inodes_wb
      0.00            +2.1        2.06 ±  5%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.do_access
      0.43 ±100%      +2.1        2.58 ± 32%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.43 ±100%      +2.2        2.59 ± 32%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.43 ±100%      +2.2        2.60 ± 32%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      0.43 ±100%      +2.2        2.60 ± 32%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      0.43 ±100%      +2.2        2.60 ± 32%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +2.5        2.46 ± 11%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.do_rw_once
     12.05 ± 44%     +26.5       38.51 ±  7%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      4.43 ± 19%     +39.9       44.35 ±  2%  perf-profile.calltrace.cycles-pp.do_rw_once
     62.88 ± 13%     -62.7        0.15 ±  4%  perf-profile.children.cycles-pp.asm_exc_page_fault
     62.74 ± 13%     -62.6        0.14 ±  6%  perf-profile.children.cycles-pp.exc_page_fault
     62.74 ± 13%     -62.6        0.14 ±  6%  perf-profile.children.cycles-pp.do_user_addr_fault
     62.46 ± 13%     -62.3        0.13 ±  7%  perf-profile.children.cycles-pp.handle_mm_fault
     62.43 ± 13%     -62.3        0.13 ±  7%  perf-profile.children.cycles-pp.__handle_mm_fault
     62.30 ± 13%     -62.2        0.12 ±  6%  perf-profile.children.cycles-pp.do_shared_fault
     62.31 ± 13%     -62.2        0.12 ±  7%  perf-profile.children.cycles-pp.do_pte_missing
     59.65 ± 15%     -59.6        0.00        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     34.41 ± 14%     -34.4        0.00        perf-profile.children.cycles-pp.__do_fault
     34.39 ± 14%     -34.4        0.00        perf-profile.children.cycles-pp.filemap_fault
     32.60 ± 16%     -32.6        0.00        perf-profile.children.cycles-pp.folio_wake_bit
     32.04 ± 16%     -32.0        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     28.63 ± 12%     -28.6        0.00        perf-profile.children.cycles-pp.folio_wait_bit_common
     27.84 ± 13%     -27.8        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irq
     67.43 ± 10%     -24.6       42.82 ±  5%  perf-profile.children.cycles-pp.do_access
     20.88 ± 17%     -20.9        0.00        perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      8.38 ±  9%      -8.3        0.05        perf-profile.children.cycles-pp.do_page_mkwrite
      8.37 ±  9%      -8.3        0.05        perf-profile.children.cycles-pp.__xfs_write_fault
      8.29 ±  9%      -8.3        0.00        perf-profile.children.cycles-pp.iomap_page_mkwrite
      0.42 ± 22%      -0.4        0.06 ±  7%  perf-profile.children.cycles-pp.__schedule
      0.25 ± 20%      -0.2        0.04 ± 45%  perf-profile.children.cycles-pp.schedule
      0.09 ± 10%      -0.0        0.06 ± 11%  perf-profile.children.cycles-pp._raw_spin_lock
      0.02 ±142%      +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.01 ±223%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.02 ±141%      +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.do_syscall_64
      0.02 ±141%      +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.01 ±223%      +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.perf_rotate_context
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.03 ±102%      +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.sched_balance_rq
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.clockevents_program_event
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.arch_scale_freq_tick
      0.06 ± 15%      +0.1        0.13 ± 10%  perf-profile.children.cycles-pp.sched_balance_domains
      0.01 ±223%      +0.1        0.08 ± 16%  perf-profile.children.cycles-pp.its_return_thunk
      0.00            +0.1        0.08 ± 16%  perf-profile.children.cycles-pp.__update_blocked_fair
      0.00            +0.1        0.08 ± 32%  perf-profile.children.cycles-pp._find_next_bit
      0.00            +0.1        0.08 ± 19%  perf-profile.children.cycles-pp.shmem_alloc_and_add_folio
      0.00            +0.1        0.09 ± 19%  perf-profile.children.cycles-pp.shmem_get_folio_gfp
      0.00            +0.1        0.09 ± 19%  perf-profile.children.cycles-pp.shmem_write_begin
      0.00            +0.1        0.09 ± 16%  perf-profile.children.cycles-pp.sched_balance_softirq
      0.00            +0.1        0.09 ± 16%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      0.00            +0.1        0.11 ±  8%  perf-profile.children.cycles-pp.native_sched_clock
      0.00            +0.1        0.11 ±  6%  perf-profile.children.cycles-pp.sched_clock
      0.01 ±223%      +0.1        0.12 ±  6%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.03 ± 70%      +0.1        0.16 ± 20%  perf-profile.children.cycles-pp.task_tick_fair
      0.02 ±142%      +0.2        0.20 ± 20%  perf-profile.children.cycles-pp.get_jiffies_update
      0.00            +0.2        0.18 ±  7%  perf-profile.children.cycles-pp.irqtime_account_irq
      0.08 ± 14%      +0.2        0.26 ± 10%  perf-profile.children.cycles-pp.handle_softirqs
      0.02 ±143%      +0.2        0.20 ± 21%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.00            +0.2        0.19 ± 28%  perf-profile.children.cycles-pp.memcpy_orig
      0.00            +0.2        0.19 ± 27%  perf-profile.children.cycles-pp.copy_folio_from_iter_atomic
      0.05 ± 73%      +0.2        0.28 ± 27%  perf-profile.children.cycles-pp.ktime_get
      0.03 ±101%      +0.3        0.29 ± 21%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.09 ±  4%      +0.3        0.36 ±  9%  perf-profile.children.cycles-pp.sched_tick
      0.03 ±100%      +0.3        0.31 ± 31%  perf-profile.children.cycles-pp.should_flush_tlb
      0.00            +0.3        0.30 ± 23%  perf-profile.children.cycles-pp.lo_rw_aio
      0.00            +0.3        0.30 ± 23%  perf-profile.children.cycles-pp.loop_process_work
      0.00            +0.3        0.30 ± 10%  perf-profile.children.cycles-pp.sync_regs
      0.00            +0.3        0.31 ± 23%  perf-profile.children.cycles-pp.generic_perform_write
      0.00            +0.3        0.31 ± 23%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.11 ± 17%      +0.3        0.42 ±  9%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.10 ± 25%      +0.4        0.47 ±  8%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.04 ±101%      +0.4        0.47 ±  8%  perf-profile.children.cycles-pp.native_flush_tlb_one_user
      0.17 ± 18%      +0.5        0.68 ±  3%  perf-profile.children.cycles-pp.update_process_times
      0.19 ± 20%      +0.6        0.82 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.10 ± 33%      +0.7        0.77 ± 11%  perf-profile.children.cycles-pp.llist_reverse_order
      0.10 ± 43%      +0.7        0.84 ±  9%  perf-profile.children.cycles-pp.flush_tlb_func
      0.14 ± 47%      +0.8        0.99 ± 37%  perf-profile.children.cycles-pp.default_send_IPI_mask_sequence_phys
      0.26 ± 20%      +0.9        1.18 ±  8%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.30 ± 20%      +1.0        1.30 ±  8%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.29 ± 20%      +1.0        1.29 ±  8%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.41 ± 18%      +1.2        1.64 ±  8%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.57 ± 47%      +1.6        2.20 ± 36%  perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      0.57 ± 47%      +1.6        2.20 ± 36%  perf-profile.children.cycles-pp.smp_call_function_many_cond
      0.57 ± 47%      +1.6        2.21 ± 36%  perf-profile.children.cycles-pp.flush_tlb_mm_range
      0.57 ± 47%      +1.7        2.24 ± 36%  perf-profile.children.cycles-pp.ptep_clear_flush
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.__rmap_walk_file
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.folio_clear_dirty_for_io
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.folio_mkclean
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.page_mkclean_one
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.page_vma_mkclean_one
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.writeback_get_folio
      0.58 ± 47%      +1.7        2.26 ± 36%  perf-profile.children.cycles-pp.writeback_iter
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.__writeback_inodes_wb
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.__writeback_single_inode
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.do_writepages
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.iomap_writepages
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.wb_workfn
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.wb_writeback
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.writeback_sb_inodes
      0.58 ± 47%      +1.7        2.27 ± 36%  perf-profile.children.cycles-pp.xfs_vm_writepages
      0.59 ± 47%      +2.0        2.58 ± 32%  perf-profile.children.cycles-pp.process_one_work
      0.59 ± 47%      +2.0        2.59 ± 32%  perf-profile.children.cycles-pp.worker_thread
      0.60 ± 46%      +2.0        2.60 ± 32%  perf-profile.children.cycles-pp.kthread
      0.60 ± 46%      +2.0        2.60 ± 32%  perf-profile.children.cycles-pp.ret_from_fork
      0.60 ± 46%      +2.0        2.60 ± 32%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.52 ± 29%      +2.1        2.63 ± 10%  perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.26 ± 43%      +2.4        2.64 ± 10%  perf-profile.children.cycles-pp.__sysvec_call_function
      0.29 ± 43%      +2.6        2.86 ± 10%  perf-profile.children.cycles-pp.sysvec_call_function
      0.64 ± 43%      +4.0        4.60 ±  8%  perf-profile.children.cycles-pp.asm_sysvec_call_function
      6.39 ± 42%     +14.1       20.51 ±  7%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      7.72 ± 23%     +57.9       65.59 ±  2%  perf-profile.children.cycles-pp.do_rw_once
     59.65 ± 15%     -59.6        0.00        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
     26.71 ± 23%      -7.8       18.95 ±  7%  perf-profile.self.cycles-pp.pv_native_safe_halt
      0.08 ± 12%      -0.0        0.06 ± 14%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.its_return_thunk
      0.00            +0.1        0.06 ± 13%  perf-profile.self.cycles-pp.arch_scale_freq_tick
      0.00            +0.1        0.06 ± 14%  perf-profile.self.cycles-pp.__update_blocked_fair
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.irqtime_account_irq
      0.01 ±223%      +0.1        0.08 ± 12%  perf-profile.self.cycles-pp.sched_balance_domains
      0.00            +0.1        0.09 ±  9%  perf-profile.self.cycles-pp.asm_sysvec_call_function
      0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.native_sched_clock
      0.00            +0.1        0.11 ± 26%  perf-profile.self.cycles-pp.tick_nohz_handler
      0.02 ±142%      +0.2        0.20 ± 20%  perf-profile.self.cycles-pp.get_jiffies_update
      0.00            +0.2        0.19 ± 27%  perf-profile.self.cycles-pp.memcpy_orig
      0.03 ±100%      +0.2        0.26 ± 30%  perf-profile.self.cycles-pp.ktime_get
      0.03 ±100%      +0.3        0.30 ± 31%  perf-profile.self.cycles-pp.should_flush_tlb
      0.00            +0.3        0.30 ± 10%  perf-profile.self.cycles-pp.sync_regs
      0.03 ±102%      +0.3        0.36 ± 11%  perf-profile.self.cycles-pp.flush_tlb_func
      0.10 ± 25%      +0.4        0.47 ±  8%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.40 ± 46%      +0.4        0.83 ± 37%  perf-profile.self.cycles-pp.smp_call_function_many_cond
      0.04 ±101%      +0.4        0.47 ±  8%  perf-profile.self.cycles-pp.native_flush_tlb_one_user
      0.10 ± 35%      +0.7        0.77 ± 11%  perf-profile.self.cycles-pp.llist_reverse_order
      0.14 ± 47%      +0.8        0.98 ± 37%  perf-profile.self.cycles-pp.default_send_IPI_mask_sequence_phys
      0.12 ± 35%      +0.9        1.01 ± 12%  perf-profile.self.cycles-pp.__flush_smp_call_function_queue
      1.25 ± 22%     +13.5       14.72 ±  3%  perf-profile.self.cycles-pp.do_access
      7.38 ± 23%     +50.4       57.76 ±  4%  perf-profile.self.cycles-pp.do_rw_once




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



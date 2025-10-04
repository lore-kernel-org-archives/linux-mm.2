Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F75CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 07:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968138E0009; Sat,  4 Oct 2025 03:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F6D8E0002; Sat,  4 Oct 2025 03:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0568E0009; Sat,  4 Oct 2025 03:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 656B68E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:18:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 023AF1A0A73
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:18:05 +0000 (UTC)
X-FDA: 83959577772.07.C133DC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4320616000D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:18:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IM35vui9;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759562282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dvk4ouTEOzFokl36HXdJAo8WP+4ldFhZtO7veP7mKKY=;
	b=CMmyFcdF0dbOtBPy40HPTgAHX8yA7Ry85jPrtLlGAaO7UG5yGNssPNWxfmOLGLNTh+snpU
	Ck0bVWlG4yzGn+sVhBgtTmp6x//K6ZVa75KgXkI+csI6MfQC5CoMjgtejGJptxMiF6Kv9w
	Uyp8ZR09RwUoyex2PaQ6bh0lfiih+EQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IM35vui9;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759562282; a=rsa-sha256;
	cv=fail;
	b=FV+Bda4oZ/R7uvNUWYu66pqCdsvANfr0b9iAJATcyXMjwZogmkvC5Gw3L2pnuyFYY9e2tr
	tbx/Oi7pBzp4SQG0a7Dq4y62oiVOA6VSiPoa7cHiMsbN63YjgzvXtG8PFi/+wBc4a35LaR
	eeSK6dOIVu9Sk7lmmcDuDfdWcEL8cg4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759562282; x=1791098282;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=A5ptXOK2iDzuiSAhxPAOGbXiFMgu889U1AhD/AbwfDw=;
  b=IM35vui9te12UC3+5ZP7fCnryKPM8gMWPjNaM68SdZlZFRhmm5aXlJfR
   Zxfun3XseMHnW0n2UHr50WOsWrGN3PXzTX+2MFN6BynCDHEaQFr2QGurQ
   7w/xlYtIDGmAkIkTalsDSIAMphb4eEuF3Iff4vcgUiHXlfBHXEKj6fbK2
   npQoasPE4U7BKudOT/a+c4JNOVX+seFnZbN+hMRatknPtPjbtFyJq4WxZ
   1h6hx6DFpPVgzqQQHVKdbCdmKViJGBdfdHsLejS6hJFczEKoA/dmqFMCr
   Hy6j/MmaprcfnS0MLs1bcGoWe6clx3k2Z4qTdzXtIjTZWAJabtbPQjZQ8
   g==;
X-CSE-ConnectionGUID: /RC+VwtYRKK7tOmdNMb4OQ==
X-CSE-MsgGUID: vbrsOViZTaaLbSUuU+0uUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61739669"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="61739669"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2025 00:18:00 -0700
X-CSE-ConnectionGUID: OAIK764cSgK+RoxqRZH5Cg==
X-CSE-MsgGUID: SKm60HflQmSeVFr6iHj/ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179108686"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2025 00:17:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 4 Oct 2025 00:17:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 4 Oct 2025 00:17:58 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.6) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 4 Oct 2025 00:17:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOfIVBMRqrpuO60e1LmE4wl6FJK+pUs22vLrtIq2pK4la37xBYEmYqy8verEl+BtPo3EKCA1fkO9S+6/HFhzldJxxfC6rvYUckCnRRQd+fn/ipaE81PRlD/iU2NdPBGQBoyOCkImIXvrcJ6A0GyWztmecSrNp+JPPz0ETmpBv0TvV5EJPxFlKZqNh+rSKrtzJNwPTJzA+yEhh/VMSgb2uhVne+85g8OCMpc+4fA5HbVSNw6yrfOvqThRO3ZYNlDjHawDFXCEh7EDffPQvKTFY/ZdF4FlOy5jOy67DHrzImpDwHHIxdX0owH6qb+73CvBOMamp14q41VsLunfcq4f/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fvOBi2pgI3vW1+q31fy2delq1lqe/Ee26hFVQq1imo=;
 b=fv1fPFae+G6ONdHd+NDdO60m2LWx/DTdL00kikw2N7Z9VlKwScxD0E0u2v9g9uOaA6SaMa/JJrFWAb84w6TFXNE/sYPKuziSc1vhKmQilMC1wnLIeMO5r/0M5q2Dwpn5e8EZfVGLa7s8nJJD/Y+XHPR+71Ihw8CmQKZNG/EovAZvszkuov2qjnMD36pYxgySVmQ9cexc6JU5cC7kgJ5Rdmn58+bRCI6rjsOfnugvQF266Jr3uw352ZnyKLBzM85z8MXKimQtcmyTwJyI8WCW+SU23Oo4/wYONXciOwFsHl0VhxAJP63vByyTLJJIzaALnaRgHrIoaU/zrsGDN29pkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BL4PR11MB8872.namprd11.prod.outlook.com (2603:10b6:208:5a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Sat, 4 Oct
 2025 07:17:55 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9182.017; Sat, 4 Oct 2025
 07:17:55 +0000
Date: Sat, 4 Oct 2025 15:17:44 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Pedro Falcato <pfalcato@suse.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, "Suren
 Baghdasaryan" <surenb@google.com>, <maple-tree@lists.infradead.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [maple_tree]  9b60811cb3:
 will-it-scale.per_process_ops 24.7% regression
Message-ID: <202510041432.a99774b1-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:802:18::34) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BL4PR11MB8872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bff43b4-4a7b-4ac0-fcc4-08de0316230f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?L9vOdTDsZ5Yz6OaqyxqJ162fXt2hocGG22AjUOs07uw31J76D7zvtXLnAe?=
 =?iso-8859-1?Q?kI6vLZbjzTfdVll1jD3fUgHPP7AgdX3QWsLKru9p3o4ksNs1PRdF1tYB5u?=
 =?iso-8859-1?Q?SgFpAAXp88D4pb3YkQ7Byn/GmaLMxv30uU4Pw5pW2X9OS/02OCeRblYv+7?=
 =?iso-8859-1?Q?fIaxSGuxbDbfXcIrx9fqqCthJxTJKUKaF0nSQSzGUnYmNZAIhrIr+G5mqg?=
 =?iso-8859-1?Q?+EBQLuMeTVEde6yjCKmIk0Zybd+cU//i5ToS9bVfJxUcH6A2/mofEtqYIx?=
 =?iso-8859-1?Q?/UitTA6lAB5dcfxj2cM9I9a9l8wy8XZ7p9ZLL531A25FkvO6B4m7frsqur?=
 =?iso-8859-1?Q?2RFmQAJgZKKeXRgRWPLn85Q1TFj/3jvuO/wzYoICEBIgBlMgxhwAk7rHmz?=
 =?iso-8859-1?Q?lH+u5IFMwgUI3VBCZpa9MoSsRusdt7aBtEz9P0bEkf7U1C18QjA8Vf35d/?=
 =?iso-8859-1?Q?mDAqlc7aMHe9PWlnkGmefgW4hxe+/TXAGdUl2SoI80EDJUKkbvTqua5kGr?=
 =?iso-8859-1?Q?zioZdykk7UUJ7dDop8wXU6NAXZ5DjSXw/+ykZxqHbG4WqCyWOA/Mi6VFTe?=
 =?iso-8859-1?Q?/3V/Kms37r5of+eV1Wiitb10Yzu1OfhZZ3d98wF0NPYcJIJ9yP3uy4CZbg?=
 =?iso-8859-1?Q?P0b7G7p9sK61D4UL/V3saGyfAQ9qa5fSDc8MWS+nZMki8v8ESat1rWBHpk?=
 =?iso-8859-1?Q?0LtkvkJveFZ7EApqEcdEQe7vcUp7ekHEUXEveAqxWFEFwLD0MNcnNL+QQn?=
 =?iso-8859-1?Q?AVe35lLFhSU3n9ILAqlVVbbgVsmwvm5snB3E7kDD2Y0TtyXEAmLKNikSDK?=
 =?iso-8859-1?Q?OJRaznwkxxOj+4z8yaHnwBK2RPlJFWrerNeW62TwGmbuL2QNqTie8o4t0Z?=
 =?iso-8859-1?Q?/FLCN6Z7OFLGRZafHIaO58IzstoqOyksM398h5FoRu6XyFhEcIhl1q3OPE?=
 =?iso-8859-1?Q?wGQdg6e7UhDfIqeemPbLdHOijjG+betD0TgdifjLg+QB4qwtGhgC12/GRw?=
 =?iso-8859-1?Q?iUbHsnL0Zc31XCHk0szYi1elRu4unHK3H+ey+5wuBsNfYblXkQjhbGKpVh?=
 =?iso-8859-1?Q?/NogTluPhTZXxBfXFbN1S1GtMeVdsBWShstjvadbr9orsD0jR9o1FoTpdK?=
 =?iso-8859-1?Q?QrgYzeL33ja78nhH6xoJZoyRvTfWIvXi7Mgu2IxjqEfrT5u+6F0eRTD943?=
 =?iso-8859-1?Q?Cx0ykO8ebh9AKR2/WhAhjEQSjKb5+9rjpIygd9KzTMNCWTw3cS1Ngo8+h+?=
 =?iso-8859-1?Q?nYZSmWER/G77YYo/efahSFiRz7wV7JFrwhPLNxR6GSWYa+jpKHbOA4kd5M?=
 =?iso-8859-1?Q?orjW0QCuOGw6bxsxQcSYlA8EoVejw30i6FQi/1WqNrchI+4vvR+tv2ft7z?=
 =?iso-8859-1?Q?o0JAPr7s4NhbE/pW43qUn8RZ/aF3de4ccoyLoS2DWiz4PYekMv8V39IjBz?=
 =?iso-8859-1?Q?WE1wOdCz6hYlJddxrr6eHeYCqn5ChaYG4mvYJoTzh5GdyRpxUZ/S/Edyd+?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?YHCyQ4voHETg35hCEUpwQt7Dbr0Y3kBUwwXwEorFz/X4++Gh8eJoiD1QWZ?=
 =?iso-8859-1?Q?06rx4ACDYOvCdWGVY/iGjRJHIY0xFSXLShFk+zHenHpLQFYOscp43iBtm0?=
 =?iso-8859-1?Q?HaHNFfYHAVl2JwXLEOt6Cm6WhVEg30P395pcY4ZgR6mvPlpr9cTGIHgnob?=
 =?iso-8859-1?Q?iZh29L2/KkoqWOYk621QBL/0+VpUvkh7QpmyDS2ftXJK3ixALcBFXLeMw7?=
 =?iso-8859-1?Q?meo4eCiYn5TVJBmGzVqD+Nm5yXL58VNPopMlGYIrm6OI1Kvvd5dcDYGE4F?=
 =?iso-8859-1?Q?6fIWodsK+3/kdWUFpyo+HWrcAWOBgK5YJZOqTAt29GZMQM4qiPeK3CgANI?=
 =?iso-8859-1?Q?KIpO6+Fftt5P6+sjdY+YBNkc/9Gu2z36wT+j1zaMS5n6SB/5fFGJGB58UX?=
 =?iso-8859-1?Q?p5MMDyZsakPfgq6sWnJ7jYkpCcuu2h4KpTGCU/USW9idedT4FmMoB2IFlf?=
 =?iso-8859-1?Q?csVPzABxRV6Wmxd3o24VngHzZbEwXXFSGFnPXmyHIsub7i6kkU5m9ZRop3?=
 =?iso-8859-1?Q?ep6T7APGDuMRToEjff5y7+bD8EQCXZjZbRdaPrUu63fy8zhYMMuPOsxbRR?=
 =?iso-8859-1?Q?NT/po2SX/L9brsXcGhpUHjrxU04svZyCOSy/iwAhOxz+od+f2K9KBiwur7?=
 =?iso-8859-1?Q?Gy1g8hCOM/t18wpR/uXE3AQo3jm70brQJqW9aeGLWphIRVG+w74RnHXTiu?=
 =?iso-8859-1?Q?Ce4Qtab9hM/UXfWolBX2ZlC46XlHn5NwIifUoVNih5jgVxSY/dulpuxciB?=
 =?iso-8859-1?Q?mAq+PyxVYI7kbZlf8bSv5RHljI1lSQzcWvbe6Yv2nNtQyzsjGok+lUUN1h?=
 =?iso-8859-1?Q?JIDwlw+DJPABrWG0GcFO3lt+z8zlC38Up8lXUtW5sd+ZwkZaglPnkmmnyg?=
 =?iso-8859-1?Q?XW4QpZ4a6rH68S7/FHQStLU1W8auWcwwjq2FCSGbOcKgK8McpiabgzMfdo?=
 =?iso-8859-1?Q?HdjdO4/XkO7WbP5WZ3rWtvj19St/evU8Ia9Z3qgQLf1kX2X9pZqyJBc9ht?=
 =?iso-8859-1?Q?hbHCdcN4d6hmDqR/YO7ieoZs9YRdlJoXfTTVVQrHQnU4c0assjoNbu4AGO?=
 =?iso-8859-1?Q?9DvTzc+katA/oBaRe6buBD+a5YQOUScN9bzEdoJ/uX6trztmEyensRTW3u?=
 =?iso-8859-1?Q?ALnxoBaaToDcE8r65J2RGFhO6kLVjrMxo1MpGtEPJkFSq+Wz+D0YLOl2Ub?=
 =?iso-8859-1?Q?5ZeN7joMG4gZwxn9DuPWFKuxY4PeuXwFyWGjB8ctSAduCrKJpvs3c9axfl?=
 =?iso-8859-1?Q?RH5KcUV/RnjmYVd7sw6lgFl5Iy8s72sS6PbOf4XOky+sAnPCL3lzg1jj61?=
 =?iso-8859-1?Q?6La1+gFVQbF9YvN2e8LeRPqrPlER17SAaj/vy2AxuU7ldCXtC71bTRh4ca?=
 =?iso-8859-1?Q?WAPXccGKIDXAA3AhPOaCw/479OsCPpWxbtNQmwVIyDyE+KRPeJwOFmHudP?=
 =?iso-8859-1?Q?I7t6yIDy+6zH2g88C2speJ8IdPKe1X4g9aTsv1jdSHkUYJyTqI734QGChx?=
 =?iso-8859-1?Q?NiWeDV9HJm9SkEpk9sNiWRC81umxjuGhViWhlsNuDgWj/Q4cKrH6cVRRLB?=
 =?iso-8859-1?Q?OYxDYoTHqzG97eEFe8RqCWjowiDxbi9HPk/P3ABo9vl2wwIwVpvaH+Ud2x?=
 =?iso-8859-1?Q?LAK9EXBBL+1o4PR3okLp/SUwJDu6kWlUESX1Ykq3EIsrWthoakGceJkQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bff43b4-4a7b-4ac0-fcc4-08de0316230f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 07:17:54.9651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hx/3yTQPC1vsUI1Geo2lJux2gBXJ5/KK969hHq8+PXq54ARKN+lUcDiMSqAtAGOpIdguaE3LnUdnxz0J1tSKEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8872
X-OriginatorOrg: intel.com
X-Stat-Signature: rk5idrii9fhok1gt9nox7bi1zr51uu6i
X-Rspam-User: 
X-Rspamd-Queue-Id: 4320616000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759562282-587136
X-HE-Meta: U2FsdGVkX1+dcx4IYKQ/VIWgi5k4pQHekSH+VAVhJ+w/bU4XnFA+Ec+LsAVt8ieL1Bop10zM0zcuqqjDBcraHIEAS+yi8Ly4J/Gq3AD3ERlqpV20zuzK2eP1dJueX0mYWhqpfDixEKf5h13IRf6XeHaTuR3kGBeso+CmJQ9J4AqB2jyALsvZfj2Aph8rebewRj6J/uFMiKOdECrSg4NX1BYZ8CzoDQMAxUmg0mcGzD25pc7E2TL/vqjczfhyE4vyQW28FBvFhJ8saReQVlPtdkP368P8eLR3TPBEbFUZIztSZOn0TLch4KJ0JCiQVBzN5Ix+R6bANW7ztomzjtFQ9p9xRND/dtHyEtpRR2+H3Uf0za09nBL6M1FhwLGJJrpIqaaGLCdggtrQNunmAb+l1Tc2TmmxCyKOAUhomMYGFYPBGMacObnbjTZIY+KxUeNIGNEHC3/si8cRtlcN5mOZynbQ3+yazB7UXFwFOZewPy11E10Fh0Ftxv9OMbw5dnNHpWN/LrtVF9N+mm4C8pRMn/8UVsI8YauOa5YjF4dD+tbiExApr1ZlUjGEWXu1KSnRveDicqJBdWKzCD+EtWMw+8Kh85XmfxHQVzL0sNuwF3BtOPDqWMRRO0ycwedyWsgstuUOjQrwNyRG93DT6wTK8Mnl3q2UGxJ9+YjrNsUtbQbRLVSMt76wolf4q2jnyswW9W1p20iZktBU8aZoAilpLg6kpt08DXh95EH+arVkss7rzGl2BMZ5SN6WL9st8Ce0uVYLjHuxjOCrXBE839KgPC0ld92NrxklaY3GF1Ko0VXN+j+nuokI+wYXiVq+omXqZaPVy7GMf3PmzYTVrx9BVzRDMxnQoGPwp/BfPk2+jBlQ0ZefkNx04/fWNTjGDlJT2CqYr/cRhfnwiVTarWU9MBF2ttjgPAX6egV7PxLvyBnQc6bc60DMLiifpMFzoIK7w/jChX4uAuB6lHukKYt
 kAyzRBEz
 myPrEujlQ75O8MJTZU0rWyTUA3js2MGfhSITOu2n0c4GXZXUdH4q5azAB1SEAXJazF507wIOD5KxpJkMvDY27Vuka+Oc/RBAen6siPXfhcmd7FCJWcaMDXB7/sGez4WH7EVI9ZgUqWXWcr+Fp4qtfcc59bcKsTlWql7sZStSqKbj+s3mnDKWekMfjNtyRqLiXW5GZfzM8JJs6/fQSArYQPXBhP5JruGwXpjEhKrqu7LsG0hTXAkOIVTHj+A+OEOzanskGg6eCkE0cIsMOBbo8Eo61lVhCCPjOLU6xXUWLsvWnpxJT9nOIX5qAEtY9dSqo/oPGi22+qn5oM7WrvOxahD80VC20JyTELfYd4/ZwgkaPV9POkvdrDOyFnPgNoiFs6gNleLMPPH8Y8j1E/nE7Ra9H9yRtU6lHiYbW1MScL1eIYzys0uIxKhtXw/tZbh2dvQMznAwBX4rvm2MiC6Y9XeDtgJrx4blSH2PrRWRIpFAWmVmRtsIUFZEx8uwDgzu7ECzboR35sn9bhz4dMHG9+bJlDNzRU5EDZMS5HDlokhIPTfzVmZu/KwvJAzX4fAPs3+ak2uySdzgVhTULRmgcTQXH6OQ4RhvpM9bSxDYPEl6I9v9/BkR6HjqL+X7aZcCBz2H0Nvhlet1MMC6VkdExW7aJHXwPtd2AX3HDrtuo+HH//dA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 24.7% regression of will-it-scale.per_process_ops on:


commit: 9b60811cb3b42fe9a8e3f0aa3e007cd9cc814a78 ("maple_tree: Use kfree_rcu in ma_free_rcu")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


[still regression on      linus/master e406d57be7bd2a4e73ea512c1ae36a40a44e499e]
[still regression on linux-next/master 7396732143a22b42bb97710173d598aaf50daa89]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap2
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510041432.a99774b1-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251004/202510041432.a99774b1-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  551a6e757a ("testing/radix-tree/maple: Hack around kfree_rcu not existing")
  9b60811cb3 ("maple_tree: Use kfree_rcu in ma_free_rcu")

551a6e757a95c23c 9b60811cb3b42fe9a8e3f0aa3e0 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.22            -0.0        0.17        mpstat.cpu.all.irq%
     15.11            +5.7       20.80        mpstat.cpu.all.soft%
      2.62            -0.5        2.07        mpstat.cpu.all.usr%
  42316808           -24.7%   31873618        will-it-scale.192.processes
    220399           -24.7%     166008        will-it-scale.per_process_ops
  42316808           -24.7%   31873618        will-it-scale.workload
  11286583           +15.5%   13039030        meminfo.Memused
   1209904          +149.9%    3024001 ±  2%  meminfo.SUnreclaim
   1370565          +132.4%    3185291 ±  2%  meminfo.Slab
  14370621 ± 22%     +43.5%   20623005 ± 18%  meminfo.max_used_kB
 1.051e+08           +17.6%  1.236e+08        numa-numastat.node0.local_node
 1.051e+08           +17.6%  1.236e+08        numa-numastat.node0.numa_hit
 1.064e+08           +17.8%  1.253e+08        numa-numastat.node1.local_node
 1.065e+08           +17.8%  1.254e+08        numa-numastat.node1.numa_hit
     21771 ± 10%     -93.5%       1423 ± 13%  perf-c2c.DRAM.local
      4255 ± 16%     -76.1%       1017 ± 10%  perf-c2c.DRAM.remote
     62740 ±  9%     +27.5%      80010 ± 10%  perf-c2c.HITM.local
     63381 ±  9%     +27.1%      80557 ± 10%  perf-c2c.HITM.total
    609632 ±  2%    +154.6%    1551865 ±  3%  numa-meminfo.node0.SUnreclaim
    146435 ± 77%     -77.9%      32384 ± 99%  numa-meminfo.node0.Shmem
    694608 ±  4%    +134.9%    1631355 ±  3%  numa-meminfo.node0.Slab
   6477317 ± 19%     +31.1%    8493474 ± 16%  numa-meminfo.node1.MemUsed
    598611 ±  3%    +148.6%    1488054 ±  3%  numa-meminfo.node1.SUnreclaim
    674290 ±  4%    +132.8%    1569852 ±  3%  numa-meminfo.node1.Slab
     36595 ± 77%     -77.9%       8092 ± 99%  numa-vmstat.node0.nr_shmem
    151635 ±  3%    +154.9%     386576 ±  2%  numa-vmstat.node0.nr_slab_unreclaimable
 1.051e+08           +17.6%  1.236e+08        numa-vmstat.node0.numa_hit
 1.051e+08           +17.6%  1.236e+08        numa-vmstat.node0.numa_local
    147957 ±  3%    +147.7%     366463 ±  2%  numa-vmstat.node1.nr_slab_unreclaimable
 1.065e+08           +17.8%  1.254e+08        numa-vmstat.node1.numa_hit
 1.064e+08           +17.8%  1.253e+08        numa-vmstat.node1.numa_local
  61514952            -1.5%   60592198        proc-vmstat.nr_free_pages_blocks
     35014            +3.4%      36214        proc-vmstat.nr_kernel_stack
    295581          +155.5%     755183 ±  2%  proc-vmstat.nr_slab_unreclaimable
 2.116e+08           +17.7%  2.491e+08        proc-vmstat.numa_hit
 2.114e+08           +17.7%  2.489e+08        proc-vmstat.numa_local
 8.394e+08           +19.4%  1.002e+09        proc-vmstat.pgalloc_normal
  8.38e+08           +19.4%  1.001e+09        proc-vmstat.pgfree
      1.67 ±  9%    +390.5%       8.18 ±  7%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     39.80 ±  9%    +775.6%     348.48 ±139%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1.67 ±  9%    +390.5%       8.18 ±  7%  perf-sched.total_sch_delay.average.ms
     39.80 ±  9%    +775.6%     348.48 ±139%  perf-sched.total_sch_delay.max.ms
     58.94          +102.4%     119.29 ±  5%  perf-sched.total_wait_and_delay.average.ms
     46484           -42.6%      26687 ±  4%  perf-sched.total_wait_and_delay.count.ms
      3075 ±  7%     +29.5%       3981 ±  8%  perf-sched.total_wait_and_delay.max.ms
     57.28           +94.0%     111.11 ±  5%  perf-sched.total_wait_time.average.ms
      3075 ±  7%     +29.5%       3981 ±  8%  perf-sched.total_wait_time.max.ms
     58.94          +102.4%     119.29 ±  5%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     46484           -42.6%      26687 ±  4%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      3075 ±  7%     +29.5%       3981 ±  8%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     57.28           +94.0%     111.11 ±  5%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      3075 ±  7%     +29.5%       3981 ±  8%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
 1.358e+11           -23.8%  1.035e+11        perf-stat.i.branch-instructions
      0.11            +0.0        0.13        perf-stat.i.branch-miss-rate%
 1.467e+08            -8.7%   1.34e+08        perf-stat.i.branch-misses
     55.34           +11.1       66.40        perf-stat.i.cache-miss-rate%
 4.805e+08           -23.3%  3.686e+08        perf-stat.i.cache-misses
  8.69e+08           -36.1%  5.552e+08        perf-stat.i.cache-references
      9602           -23.5%       7346 ±  3%  perf-stat.i.context-switches
      0.97           +31.6%       1.27        perf-stat.i.cpi
    224.90           +21.9%     274.26        perf-stat.i.cpu-migrations
      1269           +30.3%       1654        perf-stat.i.cycles-between-cache-misses
 6.341e+11           -24.1%  4.814e+11        perf-stat.i.instructions
      1.04           -24.0%       0.79        perf-stat.i.ipc
      0.11            +0.0        0.13        perf-stat.overall.branch-miss-rate%
     55.30           +11.1       66.35        perf-stat.overall.cache-miss-rate%
      0.96           +31.6%       1.27        perf-stat.overall.cpi
      1272           +30.3%       1657        perf-stat.overall.cycles-between-cache-misses
      1.04           -24.0%       0.79        perf-stat.overall.ipc
   4517404            +1.3%    4577647        perf-stat.overall.path-length
 1.352e+11           -23.8%  1.031e+11        perf-stat.ps.branch-instructions
  1.46e+08            -8.6%  1.334e+08        perf-stat.ps.branch-misses
 4.785e+08           -23.2%  3.672e+08        perf-stat.ps.cache-misses
 8.653e+08           -36.0%  5.535e+08        perf-stat.ps.cache-references
      9555           -23.7%       7294 ±  3%  perf-stat.ps.context-switches
    219.80           +22.1%     268.47        perf-stat.ps.cpu-migrations
 6.313e+11           -24.0%  4.797e+11        perf-stat.ps.instructions
 1.912e+14           -23.7%  1.459e+14        perf-stat.total.instructions
    513880 ±  6%     -27.2%     374212 ± 15%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.25 ±  2%     -16.1%       0.21 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.25 ±  2%     -16.5%       0.21 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    972158 ±  8%     -46.2%     522607 ± 48%  sched_debug.cfs_rq:/.left_deadline.avg
  25797971           -29.9%   18084652 ± 32%  sched_debug.cfs_rq:/.left_deadline.max
   4699752 ±  6%     -42.0%    2725292 ± 40%  sched_debug.cfs_rq:/.left_deadline.stddev
    972147 ±  8%     -46.2%     522601 ± 48%  sched_debug.cfs_rq:/.left_vruntime.avg
  25797677           -29.9%   18084444 ± 32%  sched_debug.cfs_rq:/.left_vruntime.max
   4699701 ±  6%     -42.0%    2725263 ± 40%  sched_debug.cfs_rq:/.left_vruntime.stddev
     44414 ± 12%     -42.6%      25515 ± 21%  sched_debug.cfs_rq:/.load.avg
    181121 ±  8%     -38.4%     111653 ± 22%  sched_debug.cfs_rq:/.load.stddev
     86.08 ± 23%    +104.5%     176.01 ± 32%  sched_debug.cfs_rq:/.load_avg.avg
    454.73 ± 15%     +97.2%     896.94 ± 18%  sched_debug.cfs_rq:/.load_avg.max
     75.23 ± 16%    +102.4%     152.23 ± 13%  sched_debug.cfs_rq:/.load_avg.stddev
    513880 ±  6%     -27.2%     374210 ± 15%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.21 ±  5%     -31.0%       0.14 ± 17%  sched_debug.cfs_rq:/.nr_queued.stddev
    972147 ±  8%     -46.2%     522602 ± 48%  sched_debug.cfs_rq:/.right_vruntime.avg
  25797677           -29.9%   18084467 ± 32%  sched_debug.cfs_rq:/.right_vruntime.max
   4699702 ±  6%     -42.0%    2725265 ± 40%  sched_debug.cfs_rq:/.right_vruntime.stddev
    117.40 ± 13%     +44.8%     170.01 ± 10%  sched_debug.cfs_rq:/.runnable_avg.stddev
     25.63 ±  4%     +13.5%      29.09 ±  9%  sched_debug.cpu.clock.stddev
    614.09 ±  6%     +50.4%     923.40        sched_debug.cpu.clock_task.stddev
    280.57 ± 18%    +771.1%       2444 ± 27%  sched_debug.cpu.curr->pid.min
      1528 ±  2%     -28.2%       1096 ± 11%  sched_debug.cpu.curr->pid.stddev
      0.26 ±  4%     -15.2%       0.22 ±  5%  sched_debug.cpu.nr_running.stddev
      9351           -19.6%       7521 ±  2%  sched_debug.cpu.nr_switches.avg
      6390           -36.1%       4085 ±  4%  sched_debug.cpu.nr_switches.min
      6487 ±  5%     -15.1%       5507 ±  4%  sched_debug.cpu.nr_switches.stddev
     48.01           -13.7       34.32        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     47.29           -13.5       33.84        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     47.14           -13.4       33.79        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
     46.78           -13.2       33.58        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     68.68           -12.3       56.42        perf-profile.calltrace.cycles-pp.__mmap
     66.96           -11.8       55.19        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     66.87           -11.7       55.12        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     66.40           -11.6       54.82        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     65.90           -11.4       54.47        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     65.34           -11.2       54.09        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     62.71           -10.6       52.11        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     55.28            -8.4       46.84        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     18.01            -6.9       11.08        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      6.03 ±  5%      -6.0        0.00        perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      5.88 ±  5%      -5.9        0.00        perf-profile.calltrace.cycles-pp.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     16.44            -5.5       10.92        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     16.38            -5.5       10.87        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      6.66 ±  2%      -4.4        2.23 ±  5%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     11.92            -3.5        8.38        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     10.19            -3.2        7.04        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      4.88 ±  2%      -2.9        1.95 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      4.84 ±  2%      -2.9        1.94 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      6.06            -1.8        4.23        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      5.83            -1.8        4.06        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      5.49            -1.7        3.79        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      3.20 ±  2%      -1.4        1.82 ±  7%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      3.59            -1.1        2.45        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.75            -1.1        2.63        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      3.31            -1.0        2.32        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      2.12 ±  2%      -0.9        1.25 ±  6%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      2.40            -0.8        1.64        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.32            -0.7        1.58        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      2.52            -0.7        1.79        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.16            -0.7        1.48        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      2.14            -0.6        1.55        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      2.17            -0.6        1.61        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      2.09            -0.5        1.56        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.88            -0.5        1.35 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.70            -0.5        1.24 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.85            -0.4        1.42        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.37            -0.4        0.98        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.75            -0.3        0.43 ± 44%  perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      1.44            -0.3        1.14        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      1.41            -0.3        1.12        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      0.87            -0.3        0.58        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.96            -0.3        0.68        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      0.75            -0.2        0.52        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.69            -0.2        0.51        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.69            -0.2        0.51        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.71            -0.1        0.57        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
     22.66            +0.4       23.06        perf-profile.calltrace.cycles-pp.__munmap
      0.00            +0.5        0.54 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     17.38            +0.7       18.12        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     17.09 ±  2%      +0.8       17.86        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     17.22            +0.8       18.01        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.8        0.80 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      0.00            +0.8        0.81 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.00            +0.8        0.82 ±  6%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     21.08            +0.8       21.92        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     20.99            +0.9       21.86        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     20.62            +1.0       21.63        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     20.61            +1.0       21.62        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     20.13            +1.2       21.29        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     19.73            +1.3       21.01        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      4.80            +5.7       10.46        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.00            +6.1       10.07        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      3.48            +6.2        9.63        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      3.42            +6.3        9.68        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      0.00            +6.3        6.28        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf
      0.00            +6.3        6.32        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      0.00            +6.4        6.43        perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      0.00            +7.0        6.96        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      0.00            +7.1        7.09        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      0.00            +7.1        7.15        perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      0.00            +7.3        7.28        perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      0.00            +7.3        7.29        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +7.4        7.41        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00           +10.9       10.89 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
      0.00           +11.0       11.02 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      8.19 ±  4%     +11.5       19.68 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      8.18 ±  4%     +11.5       19.67 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      8.18 ±  4%     +11.5       19.67 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      8.18 ±  4%     +11.5       19.67 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      8.18 ±  4%     +11.5       19.67 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.00           +11.6       11.59 ±  3%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00           +13.5       13.52        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      0.00           +13.6       13.56        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.00           +18.3       18.26 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.00           +18.6       18.63 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     48.49           -13.8       34.66        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     47.77           -13.7       34.06        perf-profile.children.cycles-pp.mas_alloc_nodes
     48.01           -13.7       34.32        perf-profile.children.cycles-pp.mas_preallocate
     46.91           -13.3       33.58        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     69.04           -12.4       56.69        perf-profile.children.cycles-pp.__mmap
     12.24           -11.7        0.50 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
     66.40           -11.6       54.82        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     65.91           -11.4       54.47        perf-profile.children.cycles-pp.vm_mmap_pgoff
     65.35           -11.2       54.10        perf-profile.children.cycles-pp.do_mmap
     88.10           -10.9       77.17        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     87.92           -10.9       77.04        perf-profile.children.cycles-pp.do_syscall_64
     62.76           -10.6       52.15        perf-profile.children.cycles-pp.__mmap_region
     55.30            -8.4       46.86        perf-profile.children.cycles-pp.__mmap_new_vma
      8.24 ±  3%      -8.2        0.00        perf-profile.children.cycles-pp.__pcs_replace_full_main
      8.20            -7.1        1.11 ±  9%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      8.22            -7.1        1.13 ±  9%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      8.00 ±  2%      -7.1        0.94 ± 11%  perf-profile.children.cycles-pp.__irq_exit_rcu
      6.78 ±  2%      -4.6        2.23 ±  5%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
     11.95            -3.6        8.40        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     10.22            -3.2        7.06        perf-profile.children.cycles-pp.vms_clear_ptes
      6.07            -1.8        4.24        perf-profile.children.cycles-pp.unmap_vmas
      5.84            -1.8        4.07        perf-profile.children.cycles-pp.unmap_page_range
      5.63            -1.7        3.90        perf-profile.children.cycles-pp.zap_pmd_range
      3.20 ±  2%      -1.4        1.83 ±  7%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      1.34 ±  2%      -1.3        0.07        perf-profile.children.cycles-pp.__call_rcu_common
      3.64            -1.2        2.47        perf-profile.children.cycles-pp.free_pgtables
      3.76            -1.1        2.64        perf-profile.children.cycles-pp.perf_event_mmap
      3.33            -1.0        2.33        perf-profile.children.cycles-pp.perf_event_mmap_event
      3.60            -1.0        2.61 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
      1.41 ±  3%      -1.0        0.44 ± 24%  perf-profile.children.cycles-pp.get_partial_node
      2.12 ±  2%      -0.9        1.27 ±  6%  perf-profile.children.cycles-pp.___slab_alloc
      2.41            -0.8        1.64        perf-profile.children.cycles-pp.free_pgd_range
      2.33            -0.7        1.59        perf-profile.children.cycles-pp.free_p4d_range
      2.54            -0.7        1.82        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.65            -0.7        1.95        perf-profile.children.cycles-pp.__cond_resched
      2.17            -0.7        1.49        perf-profile.children.cycles-pp.free_pud_range
      2.17            -0.6        1.62        perf-profile.children.cycles-pp.__get_unmapped_area
      2.10            -0.5        1.56        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      1.75            -0.5        1.27        perf-profile.children.cycles-pp.mas_find
      1.85            -0.4        1.43        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.63 ±  3%      -0.4        0.24 ± 18%  perf-profile.children.cycles-pp.get_any_partial
      1.38            -0.4        0.99        perf-profile.children.cycles-pp.vm_area_alloc
      1.43            -0.4        1.06        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.45            -0.3        1.15        perf-profile.children.cycles-pp.vm_unmapped_area
      1.14            -0.3        0.85        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.41            -0.3        1.12        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.88            -0.3        0.59        perf-profile.children.cycles-pp.zap_pte_range
      1.01            -0.3        0.75        perf-profile.children.cycles-pp.mas_pop_node
      0.75            -0.2        0.51        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.82            -0.2        0.58        perf-profile.children.cycles-pp.rcu_all_qs
      0.80            -0.2        0.56        perf-profile.children.cycles-pp.mas_walk
      0.75            -0.2        0.52        perf-profile.children.cycles-pp.__build_id_parse
      0.72            -0.2        0.50        perf-profile.children.cycles-pp.d_path
      0.41            -0.2        0.22        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.66            -0.2        0.48        perf-profile.children.cycles-pp.perf_iterate_sb
      0.52            -0.2        0.34        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.59            -0.2        0.42        perf-profile.children.cycles-pp.__vma_start_write
      0.52 ±  2%      -0.2        0.37 ±  2%  perf-profile.children.cycles-pp.prepend_path
      0.51            -0.2        0.36        perf-profile.children.cycles-pp.up_write
      0.36            -0.1        0.21        perf-profile.children.cycles-pp.freader_fetch
      0.57            -0.1        0.42        perf-profile.children.cycles-pp.mas_wr_store_type
      0.60            -0.1        0.46        perf-profile.children.cycles-pp.mas_next_slot
      0.71            -0.1        0.57        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.71            -0.1        0.57        perf-profile.children.cycles-pp.mas_prev_slot
      0.31            -0.1        0.17        perf-profile.children.cycles-pp.freader_get_folio
      0.39            -0.1        0.27        perf-profile.children.cycles-pp.down_write_killable
      0.33            -0.1        0.22        perf-profile.children.cycles-pp.fput
      0.42 ±  3%      -0.1        0.31 ±  4%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.23 ±  2%      -0.1        0.13        perf-profile.children.cycles-pp.__filemap_get_folio
      0.46            -0.1        0.35        perf-profile.children.cycles-pp.down_write
      0.32 ±  2%      -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.26 ±  2%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.shmem_mmap
      0.29 ±  2%      -0.1        0.20        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.30 ±  2%      -0.1        0.21        perf-profile.children.cycles-pp.up_read
      0.15 ±  3%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.static_key_count
      0.24 ±  2%      -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.touch_atime
      0.24 ±  2%      -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.vma_mark_detached
      0.25            -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.prepend_copy
      0.27            -0.1        0.19        perf-profile.children.cycles-pp.fget
      0.49            -0.1        0.41        perf-profile.children.cycles-pp.mas_rev_awalk
      0.22 ±  2%      -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
      0.21            -0.1        0.14        perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.23            -0.1        0.16        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.19 ± 16%      -0.1        0.12 ± 22%  perf-profile.children.cycles-pp.strlen
      0.21 ±  2%      -0.1        0.15        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.38            -0.1        0.32        perf-profile.children.cycles-pp.kfree
      0.19 ±  2%      -0.1        0.13        perf-profile.children.cycles-pp.__vm_enough_memory
      0.24 ±  2%      -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.remove_vma
      0.17 ±  2%      -0.1        0.12        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.17            -0.1        0.12 ±  4%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.14 ±  5%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.current_time
      0.17 ±  2%      -0.1        0.12        perf-profile.children.cycles-pp.mas_prev
      0.20 ±  2%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.21            -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.20            -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.13            -0.0        0.09        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.15 ±  7%      -0.0        0.11 ±  8%  perf-profile.children.cycles-pp.testcase
      0.08 ±  5%      -0.0        0.05 ±  7%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.12 ±  4%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.18 ±  2%      -0.0        0.15 ±  6%  perf-profile.children.cycles-pp._raw_spin_lock
      0.14 ±  3%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.mas_next_range
      0.24            -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.perf_session__process_events
      0.24            -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.reader__read_event
      0.24            -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.record__finish_output
      0.07            -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.__account_obj_stock
      0.14 ±  2%      -0.0        0.11        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.08 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.security_mmap_file
      0.11 ±  4%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.filemap_get_entry
      0.11 ±  4%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.13 ±  3%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.18 ±  2%      -0.0        0.15 ±  3%  perf-profile.children.cycles-pp.may_expand_vm
      0.29 ±  2%      -0.0        0.26        perf-profile.children.cycles-pp.cmd_record
      0.09 ±  4%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.mas_prev_setup
      0.12            -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.08 ±  4%      -0.0        0.06        perf-profile.children.cycles-pp.refill_obj_stock
      0.11 ±  3%      -0.0        0.09        perf-profile.children.cycles-pp.vma_set_page_prot
      0.07            -0.0        0.05        perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.15 ±  2%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.08 ±  5%      -0.0        0.07        perf-profile.children.cycles-pp.vm_area_free
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.sched_tick
      0.06 ±  6%      +0.0        0.07        perf-profile.children.cycles-pp.mas_prev_range
      0.05 ±  7%      +0.0        0.07 ± 11%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.06            +0.0        0.08 ±  9%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.07 ±  6%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.07 ±  6%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.07 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.rmqueue_pcplist
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.rmqueue
      0.26 ±  3%      +0.1        0.34 ±  4%  perf-profile.children.cycles-pp.setup_object
      0.00            +0.1        0.08        perf-profile.children.cycles-pp.__pi_memset
      0.33 ±  3%      +0.1        0.43 ±  3%  perf-profile.children.cycles-pp.shuffle_freelist
      0.00            +0.1        0.12 ±  3%  perf-profile.children.cycles-pp.__kmalloc_noprof
      0.00            +0.1        0.12 ±  4%  perf-profile.children.cycles-pp.alloc_empty_sheaf
      0.41 ±  3%      +0.1        0.54 ±  3%  perf-profile.children.cycles-pp.allocate_slab
     23.05            +0.3       23.35        perf-profile.children.cycles-pp.__munmap
      0.00            +0.3        0.32        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.00            +0.4        0.35 ± 11%  perf-profile.children.cycles-pp.kfree_rcu_work
      0.00            +0.4        0.44 ± 19%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.00            +0.4        0.44 ± 19%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.00            +0.5        0.45 ± 18%  perf-profile.children.cycles-pp.process_one_work
      0.00            +0.5        0.45 ± 18%  perf-profile.children.cycles-pp.worker_thread
      0.23            +0.5        0.70 ±  2%  perf-profile.children.cycles-pp.mas_update_gap
      0.16 ±  2%      +0.5        0.64 ±  2%  perf-profile.children.cycles-pp.mas_leaf_max_gap
     17.38            +0.9       18.29        perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00            +0.9        0.92 ±  6%  perf-profile.children.cycles-pp.barn_put_full_sheaf
     20.62            +1.0       21.63        perf-profile.children.cycles-pp.__x64_sys_munmap
     20.62            +1.0       21.63        perf-profile.children.cycles-pp.__vm_munmap
     20.14            +1.2       21.29        perf-profile.children.cycles-pp.do_vmi_munmap
     19.73            +1.3       21.01        perf-profile.children.cycles-pp.do_vmi_align_munmap
      3.64 ±  2%      +3.3        6.97        perf-profile.children.cycles-pp.__put_partials
     16.17            +4.4       20.61        perf-profile.children.cycles-pp.rcu_core
     16.18            +4.4       20.62        perf-profile.children.cycles-pp.handle_softirqs
     16.17            +4.4       20.60        perf-profile.children.cycles-pp.rcu_do_batch
      5.46            +5.5       10.92        perf-profile.children.cycles-pp.mas_store_gfp
      4.01            +6.1       10.07        perf-profile.children.cycles-pp.mas_store_prealloc
      5.11 ±  3%      +7.0       12.16 ±  2%  perf-profile.children.cycles-pp.__slab_free
     18.05            +7.1       25.13        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      8.19 ±  4%     +11.5       19.68 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
      8.18 ±  4%     +11.5       19.67 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.children.cycles-pp.kthread
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      8.20 ±  4%     +11.9       20.13 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      6.93           +12.4       19.33        perf-profile.children.cycles-pp.mas_wr_node_store
      5.89 ±  4%     +13.2       19.05 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00           +14.4       14.43        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
     49.18           +14.6       63.82        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     49.60           +14.7       64.26        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00           +14.7       14.74        perf-profile.children.cycles-pp.kvfree_call_rcu
      0.00           +19.4       19.44 ±  2%  perf-profile.children.cycles-pp.rcu_free_sheaf
      3.27            -0.7        2.56 ±  2%  perf-profile.self.cycles-pp.__pi_memcpy
      2.35            -0.6        1.70        perf-profile.self.cycles-pp.zap_pmd_range
      2.01            -0.5        1.47        perf-profile.self.cycles-pp.free_pud_range
      0.97 ±  3%      -0.4        0.57 ±  9%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      1.67            -0.4        1.30        perf-profile.self.cycles-pp.__cond_resched
      0.95            -0.4        0.60 ±  2%  perf-profile.self.cycles-pp.__slab_free
      0.52            -0.3        0.18        perf-profile.self.cycles-pp.kmem_cache_free
      1.40            -0.3        1.10        perf-profile.self.cycles-pp.__mmap_region
      1.13            -0.3        0.84        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.30            -0.2        0.05        perf-profile.self.cycles-pp.__call_rcu_common
      0.94            -0.2        0.70        perf-profile.self.cycles-pp.mas_store_gfp
      0.94            -0.2        0.74 ±  2%  perf-profile.self.cycles-pp.mas_pop_node
      0.71            -0.2        0.52        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.73            -0.2        0.55        perf-profile.self.cycles-pp.mas_walk
      0.72            -0.2        0.54        perf-profile.self.cycles-pp.entry_SYSCALL_64
      1.11            -0.2        0.94 ±  3%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.72            -0.2        0.55        perf-profile.self.cycles-pp.mas_wr_node_store
      0.65            -0.2        0.48        perf-profile.self.cycles-pp.rcu_all_qs
      0.59            -0.2        0.43        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.62            -0.2        0.46        perf-profile.self.cycles-pp.do_syscall_64
      0.57            -0.2        0.42        perf-profile.self.cycles-pp.__mmap
      0.51            -0.1        0.37        perf-profile.self.cycles-pp.zap_pte_range
      0.23 ±  2%      -0.1        0.10        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.50            -0.1        0.37        perf-profile.self.cycles-pp.__munmap
      0.53            -0.1        0.40        perf-profile.self.cycles-pp.__vma_start_write
      0.45            -0.1        0.33        perf-profile.self.cycles-pp.mas_store_prealloc
      0.49            -0.1        0.38        perf-profile.self.cycles-pp.perf_iterate_sb
      0.41            -0.1        0.30        perf-profile.self.cycles-pp.mas_preallocate
      0.64            -0.1        0.53        perf-profile.self.cycles-pp.mas_prev_slot
      0.55            -0.1        0.44        perf-profile.self.cycles-pp.mas_next_slot
      0.46            -0.1        0.35        perf-profile.self.cycles-pp.up_write
      0.42            -0.1        0.31        perf-profile.self.cycles-pp.perf_event_mmap
      0.51            -0.1        0.41        perf-profile.self.cycles-pp.mas_wr_store_type
      0.38            -0.1        0.28        perf-profile.self.cycles-pp.vm_area_alloc
      0.41            -0.1        0.31        perf-profile.self.cycles-pp.mas_find
      0.33            -0.1        0.24        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.22 ±  2%      -0.1        0.13 ±  2%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.30            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.fput
      0.28            -0.1        0.20        perf-profile.self.cycles-pp.free_pgtables
      0.31            -0.1        0.23 ±  2%  perf-profile.self.cycles-pp.down_write_killable
      0.32            -0.1        0.24        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.30 ±  3%      -0.1        0.23 ±  3%  perf-profile.self.cycles-pp.prepend_path
      0.28            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.up_read
      0.40            -0.1        0.33        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.13 ±  3%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.static_key_count
      0.28            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.22            -0.1        0.15        perf-profile.self.cycles-pp.vma_mark_detached
      0.25            -0.1        0.19        perf-profile.self.cycles-pp.fget
      0.17 ±  4%      -0.1        0.11        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.12            -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__filemap_get_folio
      0.24            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.__vm_munmap
      0.30 ± 10%      -0.1        0.24 ± 11%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.35 ±  2%      -0.1        0.29        perf-profile.self.cycles-pp.kfree
      0.30 ±  3%      -0.1        0.24 ±  6%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.24 ±  2%      -0.1        0.19        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.17 ± 17%      -0.1        0.12 ± 20%  perf-profile.self.cycles-pp.strlen
      0.36            -0.1        0.31        perf-profile.self.cycles-pp.__build_id_parse
      0.20            -0.1        0.15        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.15            -0.0        0.10        perf-profile.self.cycles-pp.free_p4d_range
      0.16            -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.barn_put_empty_sheaf
      0.20 ±  2%      -0.0        0.15        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.20            -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.45            -0.0        0.41        perf-profile.self.cycles-pp.mas_rev_awalk
      0.23 ±  2%      -0.0        0.18 ±  2%  perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.13 ±  3%      -0.0        0.09        perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.16            -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.15            -0.0        0.11        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.15            -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.mas_wr_store_entry
      0.34            -0.0        0.30        perf-profile.self.cycles-pp.down_write
      0.10 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.__vm_enough_memory
      0.08 ±  4%      -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.09            -0.0        0.06        perf-profile.self.cycles-pp.d_path
      0.11 ±  3%      -0.0        0.08        perf-profile.self.cycles-pp.vma_merge_new_range
      0.11 ±  3%      -0.0        0.08        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.10 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.mas_prev
      0.12 ±  4%      -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.10            -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.09 ±  5%      -0.0        0.06        perf-profile.self.cycles-pp.vms_clear_ptes
      0.17 ±  2%      -0.0        0.15 ±  6%  perf-profile.self.cycles-pp._raw_spin_lock
      0.10 ±  4%      -0.0        0.08        perf-profile.self.cycles-pp.perf_event_mmap_output
      0.07 ±  6%      -0.0        0.05        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.17 ±  4%      -0.0        0.14 ±  3%  perf-profile.self.cycles-pp.unmap_page_range
      0.10            -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.unmap_vmas
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.vma_set_page_prot
      0.07 ±  5%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.06            -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.07 ±  5%      -0.0        0.06        perf-profile.self.cycles-pp.mas_prev_setup
      0.09 ±  4%      -0.0        0.08        perf-profile.self.cycles-pp.mas_next_range
      0.07            -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.free_pgd_range
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_update_gap
      0.14            -0.0        0.13        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.19 ±  2%      +0.0        0.20 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.41            +0.0        0.45        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.20            +0.0        0.24 ±  2%  perf-profile.self.cycles-pp.do_mmap
      0.11 ±  4%      +0.0        0.16        perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.mas_prev_range
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.00            +0.1        0.07 ± 11%  perf-profile.self.cycles-pp.rcu_free_sheaf
      0.00            +0.1        0.08        perf-profile.self.cycles-pp.__pi_memset
      0.30 ±  3%      +0.1        0.40 ±  4%  perf-profile.self.cycles-pp.shuffle_freelist
      0.24            +0.1        0.36        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.00            +0.3        0.26 ±  3%  perf-profile.self.cycles-pp.kvfree_call_rcu
      0.00            +0.3        0.29 ±  2%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.00            +0.3        0.32        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.14 ±  3%      +0.5        0.63 ±  2%  perf-profile.self.cycles-pp.mas_leaf_max_gap
     49.18           +14.6       63.82        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



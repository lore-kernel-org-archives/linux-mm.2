Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3577D73EA9
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 01:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3446B0005; Thu, 29 Jan 2026 20:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180C86B0089; Thu, 29 Jan 2026 20:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D976B008A; Thu, 29 Jan 2026 20:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC3626B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:24:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B13EDB9888
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:24:28 +0000 (UTC)
X-FDA: 84386885016.27.DFA4530
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6137B4000B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:24:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nK8cfuth;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769736265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q8ghlUQNvBz4OXQYxAOBYtRVJdjI1iEpQMl1qnbt6A=;
	b=MobkjUVMkiQqTkGEtX3YQeiVD7l9C1Cr3JHWIu0rm5izYAjN6/g35hbNhAI/FtK5HGx2Q3
	/w0jhmzesLAe/7kGyQwtq83M+eCjJds+o8cMA6FcfJLeSz95okrbI1ZoyBfQQ8GpwyN2c3
	JfeZaRUF6Kg/5C0/oGeH4Kt3mr76MhQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nK8cfuth;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769736265; a=rsa-sha256;
	cv=fail;
	b=TZdfIwgqKueCXeDjI3sqZ88WyI7yJCxT+lj3dQgTszAiM2YIb/qtoB1s7o7/p9SsiJAJfU
	ZdPL8AeMVmizU6E/JMOKtgV581JpDFlNtOP7tpCeJrOojxFIT7P0spAjUr63qkTZEHjmfZ
	tL9KTCbFFlNsB5cgAJ5leBQCXx1U+LM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769736264; x=1801272264;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=8eAFxC0s/ss+trYP58k6OOliTp+Tw5e4gD32HO7U/9g=;
  b=nK8cfuthO7MqcrcwBe/Phasq6NLwUlAPAV3YDqkevfd8JK4wixjtMzeB
   k1Rc71tCtX4PR9+nJzbjIl3U/x6grO5hDQkTs3Jvl3rM3J6EzgoMwwkvt
   fhXeyfjhbGypSzeCJxH4y50DcjcRfi+UhLNnjJcKQFMTQnEP+O2027kg/
   Z2WPvhX/6ry93nAh3I9wYOuI+S8ztNlhPJIfROeBcmsXEPuK9HkZbrssV
   KB447uLqsrRMI37bQd12rHH3ZlWxLmV94BrICnZx9yWhpzqtBOKUAulwb
   y80NwV4qJcMChKJHB3NTa0rNNsYM6fr9XyWqvR3cgMjjMZMjwlvqSRe5q
   A==;
X-CSE-ConnectionGUID: tbzQH/PmQ5yYk7zxkhUFlA==
X-CSE-MsgGUID: owp7s9eeSWWLIvj9BAwKjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="81721238"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="81721238"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 17:24:21 -0800
X-CSE-ConnectionGUID: olnzYQguRnKlzCqVpXZBDQ==
X-CSE-MsgGUID: fNLKucUXRSGfcSeYxmoDnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208835331"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 17:24:22 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 17:24:20 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 17:24:20 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 17:24:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzulpXomNPGy93laQAsqaHIisdXDTFtz7JV23HblNA5UYPK/K4INOdlID/js+ARuWEAm00a9bKoqjr0Lh2RIskLewBSGQnWQRAKSEnrMV9bE6v8Uyqg5Ha1qQkT2MHhm6h/07DgMHaRwsNJ0azEPO9h2HAe9JH1Xm2xjaurNjw5n8+LZuWZGMzHo9V1F8k4Wxzu2F8FFk7XD9v/Kkh6e/2pXO90iej+bgLKKiHA4LTx4tGJkccnyyAvwZg1xvJnkTy3bg3Lcl6dLEmyeesivnW+EFa48LqsZ/c+OvXSyCguLeGTRyMLTHlTg7QgpmNj4eSaD3+8GNnewpExWGxZE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJLO5wzLIvlgMFPpYa1TCkGmRZMuJ1YlFnZSuchFokk=;
 b=tSDtUsz7riSlQg5rOM3Q+BX5+smQ0aZhbkoS37TIWlo2WcVo6UbFfG3DG0Xlv1TbeJWYm0E3+kOR2MDwI/7N6qKbytBZAszAu4mzRiY0Dubbp9WcW4Ntm6f2w9pCkaQXRLNrj72FPocxq9I3JIHv2T2C0K56k5A1thcxgrYTewQW8qI4Bhm0EQ8omTEjiij8OAGsEk42U2BqYIQ8lNv3n/6Je10wipKMh2BYN0ctRbmBy+2JYcWxBQD7fvnaAemvxt9uvBoNKJwWRU2dVy4H6oDDEjTQZ9CI1ZOftF4mtg3vMq3FJQsdd3F096tySbQSrAYTSTWDveojTZhBvuxA5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS7PR11MB7932.namprd11.prod.outlook.com (2603:10b6:8:e5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 01:24:18 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 01:24:18 +0000
Date: Fri, 30 Jan 2026 09:24:07 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>, Harry Yoo
	<harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, Mateusz Guzik
	<mjguzik@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] aa8fdb9e25:
 will-it-scale.per_process_ops 46.5% regression
Message-ID: <aXwIN1q59OmDy4L2@xsang-OptiPlex-9020>
References: <202601132136.77efd6d7-lkp@intel.com>
 <3dfb6857-3705-4042-9a30-da488434d9e3@suse.cz>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dfb6857-3705-4042-9a30-da488434d9e3@suse.cz>
X-ClientProxiedBy: KUZPR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:d10:24::7) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS7PR11MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 0968c8b5-41b8-4318-d816-08de5f9e4946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?LP19bOQrQtLBX/eW8ZsR2b18+DtOj2UFiy/V6enAKWl8socbGcfHW+EOC+?=
 =?iso-8859-1?Q?8wyVqPpZJsHdA1bjAevv1b8ciFHB314XoU4J+/U/g0e03XvVUItkCm7A9B?=
 =?iso-8859-1?Q?vwmb/dks0csjkBS3B10rfqf6z9958cRdSf0+oIljLpr4CWLta8x7z8t4r3?=
 =?iso-8859-1?Q?jNcgga1unVnujcvn5TlSsfG0vr4RIektm8JXikPW0SHdg9IRAkeE7umnlK?=
 =?iso-8859-1?Q?HBIqCkgQj6z7BijuSZnGLFU8cll/mpWf9Xj9KvnMKSvfwN22n0U3BLicH8?=
 =?iso-8859-1?Q?m4CKaDL161I3vX86CL6Zn1BmcIOgUTLfabCxQ41OKFPglyiqretNAXPfLP?=
 =?iso-8859-1?Q?T3flg/W3/0oxOO96MluiMTmDq/zUxozSuRbM0/a70aqXV83ZedYzZU/8LL?=
 =?iso-8859-1?Q?8bLoQZZj3ukMiHWZswlMo6XYGTj4McMf8s/MjyUX2UFA6QBeyrQ40sx3wQ?=
 =?iso-8859-1?Q?PjrL4pIXOuGjidYi/n7uWQS8IBMi7jGy7uOnjpKzYF/G0yzqBj3tIrRAzW?=
 =?iso-8859-1?Q?6bny/oDstcOaovLSJ7veKotM8mL+XJweryhKUsiozvH5QNYj2yxLUwjcuy?=
 =?iso-8859-1?Q?mfzQrTl98PMjX6LI+ObzeEOaQPNcIq4HB743RS26Ete4YjFfY2MDFf1VZ0?=
 =?iso-8859-1?Q?rY9zB2Acks7+bgGI/c9bRA5JWkcwsrW/oA4k+QLjym+a2z1NRadtbQNjBQ?=
 =?iso-8859-1?Q?dQ5dWGkW2zqYNorVd9zO/kfRE2HCT8h1Op3jPkyVNveMFLw57w7JlQUde1?=
 =?iso-8859-1?Q?IyotfgdeXyXb9Ulak/fR5uK57/NqYp2RYhc4kf9a+mn2J7Tt/6TxNZ9Ier?=
 =?iso-8859-1?Q?7ePVyyyATI4PhGtqRLRpv0FCinIVNOibJozvt17VA7ECjksKguTZMSxo+P?=
 =?iso-8859-1?Q?op4P8C5QGW/6AdaL8GiDkhjPzUYvqRZlIXWiFjY/HEiU+wRD2aiFOmN7CJ?=
 =?iso-8859-1?Q?IbK5VmDojwGtBBP2OLgnBs8iyMk3KEil7OqFTrA5/AtxT2lWj/2qFl35aV?=
 =?iso-8859-1?Q?r+Ecvny0km4AgeRDSv2EqXeJSXh8h3fugVd5WjrSVHbidMODT6xfsvdkxW?=
 =?iso-8859-1?Q?zW2M4wUBco5X6fp19rgZZr9q7UToKX9bq7/BpEVFhIznxAxJVZG5eGW+G4?=
 =?iso-8859-1?Q?vQ2zmSD45TA6PpRxrHaTGR6h+ZwV8BF7MuQnoW7cgf+YBKYjMLjwbJqDiv?=
 =?iso-8859-1?Q?SsmE5CIoLhH5Xla+lzA85DkGTQ3A9b9z8dJMzURkZX3S6iZ7b8Lh23GwKI?=
 =?iso-8859-1?Q?dgPsj8WkANfMBAESyLWY+YAkpYkC5wxozi9h+rj4K/6I/L5wxg9n7WFhEP?=
 =?iso-8859-1?Q?Ne/paDoAGj3HknNGVsTqu0rp5cBmEv4k54wuCESSpWHf137NGF+firLjmI?=
 =?iso-8859-1?Q?AQxoETGTnVcFwixqVllCzrIBR1QPALF7Ky068PKVhZI/860qMiOLNOJGwa?=
 =?iso-8859-1?Q?thaa6Y+ZATUdU7jM23Uv1M5mAZedjVxrQUFWLAbIN8ZITbbuw1KmQzlbpv?=
 =?iso-8859-1?Q?JZ/eQoyVN4NqDSHMRDCz3sYnWU+sc1zX2De112WsBYK2FzKrgWJtqgr1TS?=
 =?iso-8859-1?Q?BuK4HCLAAHm6WMxZ2QdWrgw+flRl+bG+4ssQcd2/6FC1lP8jtMRq69l3N6?=
 =?iso-8859-1?Q?3V0oOur7ELQoc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ISbmaEKxCmMtpp4Lm4ivQJh8KlWcBPPxoeyEDJR0vtU2/A/US3mPYacZLD?=
 =?iso-8859-1?Q?tRb50WXqhKz45CWdm2kgLNKnIAf/sxqMpI42CACMjnkkl6bJ8m3Z2fHw/t?=
 =?iso-8859-1?Q?+qUyi+BuenW3U9VDBRI34yZ8JHI+QLc72WRF2HUKIWvWsfuyvuLMjZpFte?=
 =?iso-8859-1?Q?F7XjtCg7iWUyXdgzUKvlb5xUCY5i7AxmhF/TPOAarmQWya0V5Tj/Jk4JBl?=
 =?iso-8859-1?Q?h9CihyZMlqzd0MD5J+SwrA3aIURUMUCicU+Tf05z4G1nSdJjUdawzX7p0z?=
 =?iso-8859-1?Q?gvhEAHIMFaoujPJ75nXrp8MDYREm1MNU/EPE0VQXFlzBdjRsrFFTeU/GvG?=
 =?iso-8859-1?Q?B1sLt95nG9a609eMJpeqLv1nDQEp8cdhkOKy6wiYdB4Ek/AHwXMM4BRmLb?=
 =?iso-8859-1?Q?SF1vtyqcgpUMijeSqaHrhWTjH2huLVgHyKmpEqtwxrnVcTzB0oDGgnMtMX?=
 =?iso-8859-1?Q?9Zfvf0K/NuV1SNKsXUchLXoRCVP2CiPBT6RQdY5HBrZ6WPhJZn+uKkjUJ6?=
 =?iso-8859-1?Q?3A66CvpYYVS0FWLk11G2SjMgLE48wTNj1468v/UNTsHw15/dbijo/o5edT?=
 =?iso-8859-1?Q?t8f4Zod7DzO73UQdtz65/tqI+ffWMTtkiJHKadmjjTXWwvmmnURt6C4aPw?=
 =?iso-8859-1?Q?xB34PR7pCwLbYvJw2paopCWDF1DOVMIsTBw86jnTd1N1BXBVEdQYWM6wid?=
 =?iso-8859-1?Q?fiL1fMdKbavjNkYB/LjiONZhjhRjyYOYO3hyF9G9dfx2ouAFN4f8wtRgRz?=
 =?iso-8859-1?Q?Iv1PjYmIJHgm4lXEXdyXYgJ7eRkON2lA33yeu48k7RrRVl7R3K8j7tnrIx?=
 =?iso-8859-1?Q?PWDHEGycEnzv26CTy9vwPiZvzzypvxZeXVBD3PoainJnmU13U2Q5Qp3OXS?=
 =?iso-8859-1?Q?f703UiYt+Fe0bW+LI/Um2U0EnOqQv95R0nCCl3ZKgelj/VxJk+dBnVk3Tw?=
 =?iso-8859-1?Q?sp2Qc92OWmRcKwcC1V81sEulKjbVDmasGdgnS8BQJ/727fgcwSK3i4DpZj?=
 =?iso-8859-1?Q?DoKQFk6lmAel5SMm2w/ChSjaKDcAm0RCyWRJjhRAN5fNXVRAUVV1s+Ee0n?=
 =?iso-8859-1?Q?Iqi9TtRCXvY54RxJrjycArRkDB0qY3N7JHibu/Jez2mfJo3V2DG4c7m/CU?=
 =?iso-8859-1?Q?oI8kBnJfZLd07eVDt/j5iLPKC6qlBCMEO+94yunFB+QqV+XpZWWjCk3OqZ?=
 =?iso-8859-1?Q?3wBPHZVg8mQpjPIpm+v1LrRjFG2XLSQpjZWlw5ho+U0qnpt2i9q4RH/XwT?=
 =?iso-8859-1?Q?Ajmizy9YK7yqmou5LsSNc405UcNEFvawLurZp9//VA8Z39tAXSZg3WA/Im?=
 =?iso-8859-1?Q?oGGeeqWm8A4IU95ts3aVKQB2tcZjH3jJiVjc2UPA3AKqEBaSxJrldvuYFl?=
 =?iso-8859-1?Q?cQDXSKsEbsC/OMQZQ4Z6yC4mDICaMCkKwuBIBmp1jNc6JnSPwdXKgFV53l?=
 =?iso-8859-1?Q?EAJdxC4/e474FV3SHNPHuWCuIjrhForHGGIp8yHFz8ZLq3PsO7OYOwiM0l?=
 =?iso-8859-1?Q?dvDSSkAkuYLLjv8xRlUQzOl8Oqkwl4j6K8TSEP29fBoQzDHCu+mIHcLfsp?=
 =?iso-8859-1?Q?DN5nvU0kZpbvYdk9qrnQyZf3zwdh4IUOr5XgFi+0uk+q1mft3iN4CpykYH?=
 =?iso-8859-1?Q?VCVlL7qrjNM+CrzLrMS2M5ST/Qe6EffdM8VBpKYNvBlKc0kuHpmGQHKra+?=
 =?iso-8859-1?Q?8AnDuyyhVShsf2w+92P8LJcmF5D/FGVuZ+IfjFJOC1PBQRdKSDWgsHHz+u?=
 =?iso-8859-1?Q?e5qTz5iWzfZNx4R0OjSWfHNj/IE+MB7e/PW1q8pinDArSDLwT/aWv7JZ65?=
 =?iso-8859-1?Q?FJFB3zPLnw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0968c8b5-41b8-4318-d816-08de5f9e4946
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 01:24:17.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8F/trTMif2BuRN4uoKtROsiuyy4gRorWeTFMjH07FFqWVV7JyL/OYgTLDm/wgwR/QrOH6fodK5g7GchsRnOJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7932
X-OriginatorOrg: intel.com
X-Stat-Signature: pewr1bsd6b8nq9fmmo34b5gshknzofhs
X-Rspamd-Queue-Id: 6137B4000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769736264-611315
X-HE-Meta: U2FsdGVkX1/Yhg4aRxPbktEG2HzcfrQjVnMr/vS+nxrqGyszNGqFZPZviPSJzQVvtDKlgdR8BYd9vLB0dmvngvHZa0tdONxu6nptvt/tMxC+p9/iKA62e0M2eX7pQpRtjfSeuCtNHexlML5ldssogn0Z64OpxnWLvqfA+92Otk1h0gDX8zTWUytpg/Q35Pxgzt2+j20/HYqyq1+DBitjA72eXTKMAsHroTptbOxlnR2WHTczO/DO7+pOWM9wR+e7Q3kQq5LisdApgyspCSZGeNQ28NTuT8xhi385dBgDnxMgQApnqSURYYv7drkRhhiMleyJGjzPuA4jRU/vy8lK/NEQaUN2sHwkrUHVZjcYQ4ZIwAuFhl+4L99nqif9UmOF5ZdcAoUaWTSBcVBITtaGvHB1gJfxrYMKyDD41WHOICbGPsN8Yc+ANO++eeMoCjfQzjrOpG2Pmf3bKb5gIUlCxgHizXAe/m9Yo9mQU7U+z4eSk/bhHi8fpmcGv8LHyOpEBCWWhBMlRgzkhK9ul4kKCaNqYjlh76iYN05x5mCeYjwTjdow1eE4rqoNsA9OkWSAqoXN1v7Y56kBOdG2/E4i6iFiMn/kpsDrvjXz3FYDvQtm225C1MBlzHMNhdrRdzTGr0EDyCPDU2J8Hc0n3GfRbC1Owa71tke3xKepWc9hKriJhR05xNvpoUceXCTt4zDKg4cveynq2FOiinRTpbhHQO0ix7EVbkgycGMgCyLDIQ1Va+4u03bKMcdQCu+7P7/51ypiq2Y/Y1BuLiiPSFmuDlwclnHvW71S6hS5sp3fQtDpwplh1rguSWEf+g9EI3Tbjawzdczu9ad8eYJwxpbVR+ovicytgA3L6kCvHyEAIgaO72VppmDRLT7F4UYKISdMqp9QtqUjQYywecCepzcQlTEWfE18cW2QRIE+7D52QvMj62bqkHblyxy6P7UJCRjRHoH12ODFaJDFv2/uAxV
 Jcuvrmhb
 0uM58nb+vd98UBCqur5wdh7AY/rWmkqKFRHEK/dX8inLaN+5QQdxa+FMdy7Mpwmu1JB0j+1PnmzOz3PNwQnnugeR6icP3vs1VLwU11DdHtLdvEp5tQahBNBHfIZZwZ+ulRupfG6Qrmz14HxOZE1Iz6KQRAYk2sofXLSCA/SEQwno/4FNhvSZFMpJWwWjXEF4ptSKGMvHy6ejW9N+Y6M49qtGaLK05uRHAiyxb8fBFLzXIARO7O+GOrA7o+v31CghtTNzOgqO9UAoDgqdfT9n5KJ36vqTQUFmlAp8EybHhDwk1ZlU+MzcD0EndVJahGclB9UCuRi7+yLh+mu2mwuverWbBOqGOgk1WK4ocFPQnn2cFwjlvRSdvahivb+EGHWGkkYTvHoLKMR8gdjtT73h8w982WAbRpN8g5LOIF3FGIiFZuxo7jt2VQU3PmftQD677wDp4YIE3oKF5P/1V/citoPjmqZXCcVVGx0eZDWWz14zdIJ8/N14bA34HLVm1fX436lpKBe7EQD7I55r4VAJIHKo5jCK22dsWi7/Piyqnz+hJ4kPXwIXRBim7VImnmicMEGVc4kIa68AaUHUa/z0xNFp0tb7bWZjve7szIAQoaf5koEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Vlastimil Babka,

On Wed, Jan 28, 2026 at 11:31:59AM +0100, Vlastimil Babka wrote:

[...]

> Hi,
> 
> as discussed at [1] this particular commit restores a behavior analogical to
> one that existed before sheaves, so while it may show a regression in
> isolation, there should hopefully be also corresponding improvement in an
> earlier commit, and those two more or less cancelled out.
> 
> What would be more useful is to know the whole series effect (excluding some
> preparatory patches). Could you please compare that if anything stands out?
> In next-20260127 that would be:
> 
> before: d86c9915f4b5 ("mm/slab: make caches with sheaves mergeable")
> 
> after: ca43eb67282a ("mm/slub: cleanup and repurpose some stat items")
> 
> Additionally, does the patch below improve anything? (on top of
> ca43eb67282a). Thanks!

we see a 60.3% regression if comparing ca43eb67282a with d86c9915f4b5 by same
tests in our original report. a8ce496508 is the commit by applying
"[PATCH] slub: avoid list_lock contention from __refill_objects_any()"
on top of ca43eb67282a. it really recovers performance, in a way of half,
if regards d86c9915f4b5 as base.
(still 31.7% regression comparing to d86c9915f4b5)

more details are attached as [1]


Tested-by: kernel test robot <oliver.sang@intel.com>

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit:
  d86c9915f4 ("mm/slab: make caches with sheaves mergeable")
  ca43eb6728 ("mm/slub: cleanup and repurpose some stat items")
  a8ce496508 ("slub: avoid list_lock contention from __refill_objects_any()")

d86c9915f4b57ff3 ca43eb67282a4a1b4be449b004a a8ce496508b9ac28b71ce797972
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
    264131           -60.3%     104932           -31.7%     180457        will-it-scale.per_process_ops



for easy comparison, also put summary results in our origil report here.

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  6a67958ab0 ("slab: remove unused PREEMPT_RT specific macros")
  aa8fdb9e25 ("slab: refill sheaves from all nodes")

6a67958ab000c3a7 aa8fdb9e2516055552de11cabaa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    194705           -46.5%     104184        will-it-scale.per_process_ops



[1]

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit:
  d86c9915f4 ("mm/slab: make caches with sheaves mergeable")
  ca43eb6728 ("mm/slub: cleanup and repurpose some stat items")
  a8ce496508 ("slub: avoid list_lock contention from __refill_objects_any()")

d86c9915f4b57ff3 ca43eb67282a4a1b4be449b004a a8ce496508b9ac28b71ce797972
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
    307.79            -1.5%     303.32            -0.4%     306.64        time.elapsed_time
    307.79            -1.5%     303.32            -0.4%     306.64        time.elapsed_time.max
  50713270           -60.3%   20147177           -31.7%   34647924        will-it-scale.192.processes
    264131           -60.3%     104932           -31.7%     180457        will-it-scale.per_process_ops
  50713270           -60.3%   20147177           -31.7%   34647924        will-it-scale.workload
      0.27 ±  3%      -0.1        0.13            -0.1        0.18 ±  2%  mpstat.cpu.all.irq%
     36.63           -17.2       19.47            -2.7       33.97        mpstat.cpu.all.soft%
     59.40           +19.0       78.40            +3.6       63.05        mpstat.cpu.all.sys%
      3.09            -1.7        1.40            -0.9        2.19        mpstat.cpu.all.usr%
 2.163e+08           -75.8%   52417003           -39.0%   1.32e+08        numa-numastat.node0.local_node
 2.164e+08           -75.7%   52529330           -39.0%   1.32e+08        numa-numastat.node0.numa_hit
 2.174e+08           -74.6%   55136459           -32.2%  1.475e+08        numa-numastat.node1.local_node
 2.175e+08           -74.6%   55223414           -32.1%  1.476e+08        numa-numastat.node1.numa_hit
   6993580 ±  2%      +8.4%    7579245 ±  2%      +4.1%    7281381 ±  2%  vmstat.memory.cache
    253.22 ±  2%      -3.9%     243.31 ±  2%      -5.3%     239.92 ±  2%  vmstat.procs.r
     12499 ±  3%     +44.3%      18039           -61.8%       4769        vmstat.system.cs
    256261            -2.3%     250282            -0.9%     253890        vmstat.system.in
      1441 ± 14%    +159.4%       3740 ± 19%    +293.1%       5668 ± 13%  perf-c2c.DRAM.local
      1060 ± 35%    +410.9%       5420 ±  6%     +40.3%       1488 ± 14%  perf-c2c.DRAM.remote
     39267 ± 13%     -16.3%      32871 ± 12%     +81.6%      71315 ± 10%  perf-c2c.HITM.local
    569.80 ± 48%    +519.1%       3527 ±  8%     -49.6%     287.00 ± 13%  perf-c2c.HITM.remote
     39837 ± 14%      -8.6%      36398 ± 11%     +79.7%      71602 ± 10%  perf-c2c.HITM.total
   2135346 ±  4%     -48.8%    1092768 ±  6%     -11.5%    1890717 ±  4%  numa-meminfo.node0.SUnreclaim
   2225620 ±  3%     -47.3%    1173754 ±  7%     -11.5%    1969261 ±  5%  numa-meminfo.node0.Slab
     18307            +1.4%      18567 ±  2%      -6.8%      17054 ±  3%  numa-meminfo.node1.KernelStack
   1959677 ±  4%     -47.0%    1037682 ±  4%      -8.1%    1801834 ±  3%  numa-meminfo.node1.SUnreclaim
   3090819 ±  6%     +19.0%    3677082 ±  6%      +3.3%    3191592 ±  6%  numa-meminfo.node1.Shmem
   2028184 ±  5%     -45.5%    1105393 ±  5%      -7.8%    1870220 ±  4%  numa-meminfo.node1.Slab
      3166            +1.1%       3201            +1.1%       3201        turbostat.Bzy_MHz
     65.50 ±  2%      -6.7%      61.10            -2.3%      64.00        turbostat.CoreTmp
      1.24           -57.8%       0.52           -31.0%       0.86        turbostat.IPC
   1798555 ±  3%  -1.8e+06        0.00        -1.7e+06      109073 ± 21%  turbostat.PKG_%
     65.30 ±  2%      -6.0%      61.40            -2.1%      63.90        turbostat.PkgTmp
    470.72           -12.5%     411.86            -2.6%     458.48        turbostat.PkgWatt
     28.14           -20.4%      22.40           -11.3%      24.95        turbostat.RAMWatt
    529155 ±  4%     -48.9%     270394 ±  6%     -10.1%     475663 ±  4%  numa-vmstat.node0.nr_slab_unreclaimable
 2.164e+08           -75.7%   52529459           -39.0%   1.32e+08        numa-vmstat.node0.numa_hit
 2.163e+08           -75.8%   52417132           -39.0%  1.319e+08        numa-vmstat.node0.numa_local
     18306            +1.4%      18566 ±  2%      -6.8%      17057 ±  3%  numa-vmstat.node1.nr_kernel_stack
    773230 ±  6%     +18.9%     919014 ±  6%      +3.2%     797828 ±  6%  numa-vmstat.node1.nr_shmem
    482496 ±  4%     -46.7%     257120 ±  4%      -6.3%     452095 ±  3%  numa-vmstat.node1.nr_slab_unreclaimable
 2.175e+08           -74.6%   55223352           -32.1%  1.476e+08        numa-vmstat.node1.numa_hit
 2.174e+08           -74.6%   55136398           -32.2%  1.475e+08        numa-vmstat.node1.numa_local
      9.61 ± 26%     -59.9%       3.85 ±  6%     +63.2%      15.69 ±  4%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      9.61 ± 26%     -59.9%       3.85 ±  6%     +63.2%      15.69 ±  4%  perf-sched.total_sch_delay.average.ms
     97.85 ± 24%     -42.5%      56.29           +44.5%     141.41 ±  3%  perf-sched.total_wait_and_delay.average.ms
     44235 ± 30%     +92.1%      84980 ±  2%     -51.2%      21596 ±  3%  perf-sched.total_wait_and_delay.count.ms
     88.23 ± 23%     -40.6%      52.44           +42.5%     125.73 ±  3%  perf-sched.total_wait_time.average.ms
     97.85 ± 24%     -42.5%      56.29           +44.5%     141.41 ±  3%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     44235 ± 30%     +92.1%      84980 ±  2%     -51.2%      21596 ±  3%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     88.23 ± 23%     -40.6%      52.44           +42.5%     125.73 ±  3%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   4034071 ±  4%     +14.8%    4629394 ±  3%      +7.4%    4334119 ±  4%  meminfo.Active
   4033292 ±  4%     +14.8%    4628614 ±  3%      +7.4%    4333340 ±  4%  meminfo.Active(anon)
   6831441 ±  2%      +8.7%    7426973 ±  2%      +4.4%    7130163 ±  2%  meminfo.Cached
  35007579            +8.6%   38009265            +4.2%   36465336        meminfo.Committed_AS
    158780            -6.4%     148696            -7.5%     146927        meminfo.KReclaimable
     37172            +2.3%      38025            -5.8%      35014        meminfo.KernelStack
  13747866           -10.4%   12317640            -0.8%   13631524 ±  2%  meminfo.Memused
    158780            -6.4%     148696            -7.5%     146927        meminfo.SReclaimable
   4099705 ±  4%     -48.4%    2115765            -9.5%    3711663 ±  4%  meminfo.SUnreclaim
   3154355 ±  5%     +18.9%    3749886 ±  4%      +9.5%    3453072 ±  5%  meminfo.Shmem
   4258485 ±  4%     -46.8%    2264461            -9.4%    3858590 ±  4%  meminfo.Slab
  24903807 ± 24%     -41.8%   14487867 ± 12%      +8.5%   27008355 ± 29%  meminfo.max_used_kB
   1008212 ±  4%     +14.8%    1157016 ±  3%      +7.5%    1083507 ±  4%  proc-vmstat.nr_active_anon
   1707723 ±  2%      +8.7%    1856620 ±  2%      +4.4%    1782730 ±  2%  proc-vmstat.nr_file_pages
  59650535            +2.6%   61174899            +0.6%   60036028        proc-vmstat.nr_free_pages_blocks
     37173            +2.3%      38023            -5.8%      35012        proc-vmstat.nr_kernel_stack
    788450 ±  5%     +18.9%     937347 ±  4%      +9.5%     863456 ±  5%  proc-vmstat.nr_shmem
     39695            -6.4%      37173            -7.5%      36731        proc-vmstat.nr_slab_reclaimable
   1013008 ±  4%     -47.6%     530940            -8.4%     928206 ±  3%  proc-vmstat.nr_slab_unreclaimable
   1008212 ±  4%     +14.8%    1157016 ±  3%      +7.5%    1083507 ±  4%  proc-vmstat.nr_zone_active_anon
 4.339e+08           -75.2%  1.078e+08           -35.6%  2.796e+08        proc-vmstat.numa_hit
 4.337e+08           -75.2%  1.076e+08           -35.6%  2.794e+08        proc-vmstat.numa_local
 1.764e+09           -76.2%  4.196e+08           -36.1%  1.127e+09        proc-vmstat.pgalloc_normal
 1.762e+09           -76.3%  4.182e+08           -36.1%  1.126e+09        proc-vmstat.pgfree
      0.77           +23.5%       0.96            +5.6%       0.82        perf-stat.i.MPKI
 1.644e+11           -57.1%  7.045e+10           -30.1%  1.149e+11        perf-stat.i.branch-instructions
      0.08            +0.0        0.09            +0.0        0.09        perf-stat.i.branch-miss-rate%
 1.264e+08           -50.8%   62178838           -23.6%   96551454        perf-stat.i.branch-misses
     84.23           -21.3       62.92           -32.7       51.48        perf-stat.i.cache-miss-rate%
 5.748e+08           -47.3%  3.032e+08           -26.3%  4.237e+08        perf-stat.i.cache-misses
  6.82e+08           -29.3%  4.823e+08           +20.9%  8.245e+08        perf-stat.i.cache-references
     12018 ±  3%     +49.4%      17960           -61.6%       4609        perf-stat.i.context-switches
      0.81          +137.3%       1.91           +44.9%       1.17        perf-stat.i.cpi
 6.054e+11            +1.0%  6.114e+11            +1.1%  6.122e+11        perf-stat.i.cpu-cycles
    496.60 ±  2%     -15.4%     420.01 ±  2%     -44.2%     277.21        perf-stat.i.cpu-migrations
      1051           +92.3%       2021           +37.2%       1442        perf-stat.i.cycles-between-cache-misses
 7.538e+11           -57.5%  3.204e+11           -30.3%  5.257e+11        perf-stat.i.instructions
      1.24           -57.8%       0.53           -30.9%       0.86        perf-stat.i.ipc
      0.76           +24.1%       0.95            +5.7%       0.81        perf-stat.overall.MPKI
      0.08            +0.0        0.09            +0.0        0.08        perf-stat.overall.branch-miss-rate%
     84.21           -21.4       62.81           -32.8       51.38        perf-stat.overall.cache-miss-rate%
      0.80          +137.4%       1.91           +44.8%       1.16        perf-stat.overall.cpi
      1053           +91.3%       2016           +37.1%       1444        perf-stat.overall.cycles-between-cache-misses
      1.24           -57.9%       0.52           -30.9%       0.86        perf-stat.overall.ipc
   4561894            +5.7%    4820717            +1.8%    4642538        perf-stat.overall.path-length
 1.633e+11           -57.1%  7.014e+10           -30.0%  1.143e+11        perf-stat.ps.branch-instructions
 1.256e+08           -50.8%   61848881           -23.6%   95977841        perf-stat.ps.branch-misses
 5.714e+08           -47.2%  3.019e+08           -26.2%  4.215e+08        perf-stat.ps.cache-misses
 6.786e+08           -29.1%  4.808e+08           +20.9%  8.204e+08        perf-stat.ps.cache-references
     12045 ±  3%     +48.2%      17857           -62.2%       4556        perf-stat.ps.context-switches
 6.021e+11            +1.1%  6.088e+11            +1.1%  6.088e+11        perf-stat.ps.cpu-cycles
    489.88 ±  2%     -15.5%     413.86 ±  2%     -44.8%     270.39        perf-stat.ps.cpu-migrations
  7.49e+11           -57.4%   3.19e+11           -30.2%   5.23e+11        perf-stat.ps.instructions
 2.313e+14           -58.0%  9.712e+13           -30.5%  1.609e+14        perf-stat.total.instructions
  18830824           +21.8%   22927609            +5.5%   19865940        sched_debug.cfs_rq:/.avg_vruntime.avg
  19651669           +22.3%   24034159            +3.2%   20278357        sched_debug.cfs_rq:/.avg_vruntime.max
  14795521 ±  4%     +26.1%   18656404 ±  5%      +1.9%   15075489 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.min
    519008 ±  5%     +87.5%     973121 ±  4%      -0.3%     517319 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.stddev
  13541640 ± 37%     +74.5%   23630973 ±  2%     -33.6%    8995423 ± 34%  sched_debug.cfs_rq:/.left_deadline.max
   2891535 ± 42%     +76.2%    5095880 ± 23%     -45.9%    1565184 ± 81%  sched_debug.cfs_rq:/.left_deadline.stddev
  13541466 ± 37%     +74.5%   23630825 ±  2%     -33.6%    8995322 ± 34%  sched_debug.cfs_rq:/.left_vruntime.max
   2891496 ± 42%     +76.2%    5095853 ± 23%     -45.9%    1565162 ± 81%  sched_debug.cfs_rq:/.left_vruntime.stddev
    163721 ± 89%    +480.9%     951119 ± 29%     -82.5%      28651 ±115%  sched_debug.cfs_rq:/.load.avg
  13002869 ±111%    +391.8%   63948635 ± 17%     -95.6%     572064 ± 26%  sched_debug.cfs_rq:/.load.max
   1228727 ±114%    +476.8%    7087338 ± 19%     -93.5%      79390 ± 64%  sched_debug.cfs_rq:/.load.stddev
    409.08 ± 25%    +173.7%       1119 ± 15%     +16.3%     475.77 ± 32%  sched_debug.cfs_rq:/.load_avg.avg
      3076 ± 37%    +460.2%      17235 ± 15%    +278.2%      11637 ± 24%  sched_debug.cfs_rq:/.load_avg.max
    527.03 ± 40%    +366.2%       2457 ± 16%    +183.8%       1495 ± 31%  sched_debug.cfs_rq:/.load_avg.stddev
  13541496 ± 37%     +74.5%   23630838 ±  2%     -33.6%    8995348 ± 34%  sched_debug.cfs_rq:/.right_vruntime.max
   2891500 ± 42%     +76.2%    5095868 ± 23%     -45.9%    1565165 ± 81%  sched_debug.cfs_rq:/.right_vruntime.stddev
    246.98 ± 10%     +13.1%     279.43 ± 15%     -21.4%     194.19 ± 15%  sched_debug.cfs_rq:/.runnable_avg.stddev
    684.02 ±  4%     -11.3%     607.05 ±  4%      -0.4%     681.35 ±  7%  sched_debug.cfs_rq:/.util_avg.min
     52.86 ±  7%     +17.6%      62.17 ±  5%      +2.0%      53.91 ±  9%  sched_debug.cfs_rq:/.util_avg.stddev
  18820626           +21.8%   22922813            +5.5%   19855131        sched_debug.cfs_rq:/.zero_vruntime.avg
  19640361           +22.3%   24029703            +3.2%   20270726        sched_debug.cfs_rq:/.zero_vruntime.max
  14788107 ±  4%     +26.1%   18652511 ±  5%      +1.9%   15064048 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.min
    518981 ±  5%     +87.4%     972714 ±  4%      -0.2%     518098 ±  8%  sched_debug.cfs_rq:/.zero_vruntime.stddev
     41.86 ± 17%     -22.9%      32.26 ± 12%     -30.6%      29.06 ± 24%  sched_debug.cpu.clock.stddev
      1305 ±  7%     +44.8%       1890 ±  4%     -60.1%     520.93 ±  2%  sched_debug.cpu.clock_task.stddev
      0.00 ±  4%      -9.0%       0.00 ±  4%     -12.3%       0.00 ±  6%  sched_debug.cpu.next_balance.stddev
     10990 ±  2%     +44.7%      15903           -51.1%       5372 ±  2%  sched_debug.cpu.nr_switches.avg
     57218 ± 19%     +33.7%      76496 ±  7%      -5.9%      53846 ± 20%  sched_debug.cpu.nr_switches.max
      3823 ±  5%     +91.7%       7331 ±  3%     -23.0%       2944        sched_debug.cpu.nr_switches.min
      7144 ±  8%     +17.1%       8366 ±  2%     -31.4%       4899 ± 18%  sched_debug.cpu.nr_switches.stddev
     36.02 ±  2%     -18.9       17.16 ±  4%      -2.5       33.54 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     36.01 ±  2%     -18.9       17.16 ±  4%      -2.5       33.53 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     36.01 ±  2%     -18.9       17.16 ±  4%      -2.5       33.53 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     36.01 ±  2%     -18.9       17.16 ±  4%      -2.5       33.53 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     36.00 ±  2%     -18.9       17.15 ±  4%      -2.5       33.53 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     35.33 ±  2%     -18.5       16.80 ±  4%      -2.4       32.92 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     34.83 ±  2%     -17.4       17.43 ±  5%      -2.3       32.52 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     28.98           -17.2       11.74 ±  2%     -10.3       18.65        perf-profile.calltrace.cycles-pp.__munmap
     26.57           -15.6       11.00 ±  2%      -9.2       17.41        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     26.46           -15.5       10.96 ±  2%      -9.1       17.34        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     26.06           -15.3       10.81 ±  2%      -9.0       17.08        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     26.05           -15.2       10.80 ±  2%      -9.0       17.07        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     25.26           -14.8       10.49 ±  2%      -8.7       16.54        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     24.74           -14.5       10.29 ±  2%      -8.5       16.22        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     11.67           -11.7        0.00           -11.7        0.00        perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     11.47           -11.5        0.00           -11.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     11.41           -11.4        0.00           -11.4        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf
     15.33            -9.5        5.79 ±  2%      -5.6        9.69        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     13.18            -8.2        4.99 ±  3%      -4.8        8.41        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     22.58 ±  2%      -5.4       17.20 ±  5%      +9.4       32.00 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      8.36            -5.2        3.19 ±  3%      -3.0        5.38        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      8.03            -4.9        3.09 ±  3%      -2.8        5.22        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
     21.18 ±  2%      -4.4       16.76 ±  5%      +9.9       31.10 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     20.93 ±  2%      -4.4       16.55 ±  5%      +9.7       30.68 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
      7.13            -4.4        2.77 ±  3%      -2.4        4.68        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      4.39            -2.8        1.55 ±  2%      -1.7        2.69        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      5.89            -2.8        3.12 ±  2%      -1.7        4.16 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.17            -2.6        1.56 ±  2%      -1.6        2.62        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      5.44            -2.6        2.89 ±  2%      -1.7        3.76 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      3.87            -2.5        1.34 ±  2%      -1.6        2.31        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      3.67            -2.5        1.22 ±  3%      -1.6        2.06        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      4.81            -2.2        2.62 ±  2%      -1.5        3.33 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      4.66            -2.1        2.60 ±  2%      -1.4        3.30 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.90            -1.8        1.09 ±  2%      -1.0        1.87        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.81            -1.8        1.06 ±  2%      -1.0        1.81        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      2.78            -1.7        1.05 ±  3%      -1.0        1.80        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      2.84            -1.7        1.12 ±  3%      -0.9        1.91        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.70            -1.7        1.02 ±  2%      -1.0        1.74        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      2.66            -1.7        1.00 ±  3%      -1.0        1.71        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      2.45            -1.5        0.93 ±  3%      -0.9        1.58        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.42            -1.4        0.05 ±300%      -0.6        0.80        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.97            -1.2        0.76 ±  2%      -0.7        1.27        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      1.93            -1.2        0.75 ±  3%      -0.7        1.25        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      2.48            -1.1        1.35 ±  2%      -0.9        1.60 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      2.45 ±  2%      -1.1        1.34 ±  2%      -0.9        1.59        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.99            -1.0        0.00            -0.4        0.57 ±  4%  perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.87            -0.9        0.00            -0.3        0.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.85            -0.9        0.00            -0.3        0.56        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.85            -0.8        0.00            -0.3        0.58        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      0.83 ±  8%      -0.8        0.00            -0.2        0.59 ± 11%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.82 ±  8%      -0.8        0.00            -0.2        0.58 ± 12%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      1.02 ±  7%      -0.8        0.21 ±122%      -0.3        0.70 ± 10%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.79            -0.8        0.00            -0.2        0.60        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.74 ±  4%      -0.7        0.05 ±300%      -0.1        0.63 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.0        0.00            +0.7        0.69        perf-profile.calltrace.cycles-pp.allocate_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.8        0.80 ± 12%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk
      0.00            +0.8        0.80 ± 12%      +0.0        0.00        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk
      0.00            +0.8        0.80 ± 11%      +0.0        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.00            +0.8        0.80 ± 11%      +0.0        0.00        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      1.02 ± 14%      +0.8        1.82 ± 11%      -1.0        0.00        perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread
      1.02 ± 14%      +0.8        1.83 ± 11%      -1.0        0.00        perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread.kthread
      1.02 ± 14%      +0.8        1.84 ± 11%      -1.0        0.00        perf-profile.calltrace.cycles-pp.kfree_rcu_work.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +0.8        0.85 ± 30%      +0.0        0.00        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.9        0.86 ± 30%      +0.0        0.00        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.9        0.86 ± 30%      +0.0        0.00        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +1.5        1.45 ± 14%      +0.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work
      0.00            +1.5        1.48 ± 14%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work
      0.00            +2.7        2.68 ± 15%      +0.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any
      0.00            +2.7        2.69 ± 15%      +0.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects
      0.00            +2.7        2.70 ± 15%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00            +2.8        2.80 ± 10%      +0.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      0.00            +2.9        2.87 ± 10%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.56 ± 76%      +3.7        4.24 ± 10%      -0.6        0.00        perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread
      0.56 ± 76%      +3.7        4.24 ± 10%      -0.6        0.00        perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      0.57 ± 76%      +3.7        4.27 ± 10%      -0.6        0.00        perf-profile.calltrace.cycles-pp.kfree_rcu_monitor.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +4.2        4.23 ±  9%      +0.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk
      1.75 ± 24%      +4.4        6.13 ±  7%      -1.7        0.00        perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1.74 ± 24%      +4.4        6.12 ±  7%      -1.7        0.00        perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +5.7        5.71 ±  7%      +2.3        2.32 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      0.00            +5.7        5.74 ±  7%      +2.3        2.34 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +5.8        5.77 ±  7%      +2.4        2.36 ±  9%  perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +6.0        6.04 ±  7%      +7.4        7.38 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main
      0.00            +6.1        6.12 ±  7%      +7.5        7.50 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +6.3        6.34 ±  7%      +7.9        7.86 ±  2%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +13.5       13.47 ±  3%      +0.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects
      0.00           +13.5       13.54 ±  3%      +0.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00           +17.2       17.21 ±  5%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +17.4       17.38 ±  5%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +21.2       21.21           +15.2       15.18        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +21.3       21.33           +15.3       15.35        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +29.1       29.07 ±  2%     +20.0       19.95 ±  2%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     33.88           +30.8       64.62           +13.5       47.33        perf-profile.calltrace.cycles-pp.__mmap
     31.33           +32.5       63.82           +14.7       45.98        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     31.21           +32.6       63.78           +14.7       45.90        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     30.70           +32.9       63.58           +14.9       45.55        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     30.10           +33.2       63.34           +15.0       45.14        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     29.42           +33.6       63.06           +15.3       44.68        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26.13           +35.7       61.80           +16.3       42.47        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     15.61 ±  3%     +42.5       58.07           +20.5       36.07        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      7.84 ±  6%     +46.5       54.35 ±  2%     +23.1       30.93        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      6.97 ±  7%     +47.0       54.02 ±  2%     +23.4       30.36        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      6.93 ±  7%     +47.1       54.00 ±  2%     +23.4       30.34        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
      6.66 ±  7%     +47.1       53.78 ±  2%     +23.3       29.93        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      0.00           +53.1       53.08 ±  2%     +28.7       28.73        perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     36.02 ±  2%     -18.9       17.16 ±  4%      -2.5       33.54 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
     36.01 ±  2%     -18.9       17.16 ±  4%      -2.5       33.53 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
     38.02           -18.0       20.05 ±  4%      -3.5       34.57 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
     38.00           -18.0       20.04 ±  4%      -3.4       34.56 ±  2%  perf-profile.children.cycles-pp.rcu_core
     38.00           -18.0       20.04 ±  4%      -3.4       34.56 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
     37.17           -17.6       19.57 ±  4%      -3.3       33.87 ±  2%  perf-profile.children.cycles-pp.rcu_free_sheaf
     36.67           -17.3       19.34 ±  4%      -3.2       33.47 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     28.93           -17.0       11.92 ±  2%     -10.0       18.97        perf-profile.children.cycles-pp.__munmap
     26.06           -15.3       10.81 ±  2%      -9.0       17.08        perf-profile.children.cycles-pp.__x64_sys_munmap
     26.06           -15.2       10.80 ±  2%      -9.0       17.07        perf-profile.children.cycles-pp.__vm_munmap
     25.26           -14.8       10.49 ±  2%      -8.7       16.54        perf-profile.children.cycles-pp.do_vmi_munmap
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.children.cycles-pp.kthread
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
     37.77           -14.5       23.29 ±  3%      -4.1       33.62 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
     24.76           -14.5       10.30 ±  2%      -8.5       16.23        perf-profile.children.cycles-pp.do_vmi_align_munmap
     13.10           -13.1        0.00           -13.1        0.00        perf-profile.children.cycles-pp.__put_partials
     15.38            -9.6        5.81 ±  2%      -5.7        9.71        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     13.20            -8.2        5.00 ±  2%      -4.8        8.42        perf-profile.children.cycles-pp.vms_clear_ptes
      8.37            -5.2        3.19 ±  3%      -3.0        5.38        perf-profile.children.cycles-pp.unmap_vmas
      8.11            -5.0        3.09 ±  3%      -2.9        5.23        perf-profile.children.cycles-pp.unmap_page_range
      7.74            -4.7        3.01 ±  3%      -2.7        5.08        perf-profile.children.cycles-pp.zap_pmd_range
      9.51            -4.3        5.24 ±  2%      -2.9        6.65 ±  2%  perf-profile.children.cycles-pp.mas_wr_node_store
      6.64            -3.2        3.43 ±  2%      -2.0        4.68        perf-profile.children.cycles-pp.mas_store_gfp
      4.41            -2.9        1.55 ±  2%      -1.7        2.70        perf-profile.children.cycles-pp.perf_event_mmap
      4.22            -2.6        1.57 ±  2%      -1.6        2.64        perf-profile.children.cycles-pp.free_pgtables
      5.44            -2.6        2.89 ±  2%      -1.7        3.76 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      3.90            -2.5        1.35 ±  2%      -1.5        2.36        perf-profile.children.cycles-pp.perf_event_mmap_event
      3.80            -2.4        1.44 ±  3%      -1.4        2.44        perf-profile.children.cycles-pp.__cond_resched
      4.96            -2.3        2.71 ±  2%      -1.8        3.21 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
      2.91            -1.8        1.10 ±  3%      -1.0        1.88        perf-profile.children.cycles-pp.free_pgd_range
      2.81            -1.8        1.06 ±  2%      -1.0        1.81        perf-profile.children.cycles-pp.free_p4d_range
      2.78            -1.7        1.05 ±  3%      -1.0        1.80        perf-profile.children.cycles-pp.__get_unmapped_area
      2.86            -1.7        1.13 ±  2%      -0.9        1.94        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.70            -1.7        1.02 ±  3%      -1.0        1.74        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      2.68            -1.7        1.01 ±  2%      -1.0        1.72        perf-profile.children.cycles-pp.free_pud_range
      2.46            -1.5        0.93 ±  2%      -0.9        1.59        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      2.23            -1.4        0.82 ±  3%      -0.8        1.41        perf-profile.children.cycles-pp.mas_find
      1.97            -1.2        0.76 ±  2%      -0.7        1.27        perf-profile.children.cycles-pp.vm_unmapped_area
      1.94            -1.2        0.75 ±  2%      -0.7        1.25        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.78            -1.1        0.69 ±  3%      -0.6        1.17        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.24 ±  2%      -1.0        0.28 ±  7%      -0.5        0.70        perf-profile.children.cycles-pp.allocate_slab
      1.43            -0.9        0.48 ±  3%      -0.6        0.80        perf-profile.children.cycles-pp.vm_area_alloc
      1.42            -0.9        0.56 ±  2%      -0.5        0.95        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.34 ±  7%      -0.8        0.54 ± 12%      -0.5        0.88 ± 10%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.96 ±  2%      -0.8        0.19 ±  6%      -0.4        0.52        perf-profile.children.cycles-pp.shuffle_freelist
      1.16            -0.7        0.46 ±  3%      -0.4        0.77        perf-profile.children.cycles-pp.rcu_all_qs
      1.06            -0.7        0.39 ±  2%      -0.4        0.64        perf-profile.children.cycles-pp.mas_walk
      1.00            -0.7        0.33 ±  3%      -0.4        0.58 ±  4%  perf-profile.children.cycles-pp.d_path
      0.78 ±  2%      -0.6        0.15 ±  7%      -0.4        0.41 ±  2%  perf-profile.children.cycles-pp.setup_object
      0.88            -0.6        0.27 ±  3%      -0.4        0.48        perf-profile.children.cycles-pp.__build_id_parse
      0.87 ±  4%      -0.6        0.32 ±  3%      -0.4        0.49 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      1.15 ±  5%      -0.5        0.60 ±  8%      -0.2        0.90 ±  7%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      1.02 ±  7%      -0.5        0.48 ± 11%      -0.3        0.70 ± 11%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.77            -0.5        0.24 ±  4%      -0.4        0.41 ±  5%  perf-profile.children.cycles-pp.prepend_path
      0.84            -0.5        0.32 ±  2%      -0.3        0.54        perf-profile.children.cycles-pp.mas_prev_slot
      1.06 ±  4%      -0.5        0.54 ±  3%      -0.2        0.81 ±  3%  perf-profile.children.cycles-pp.mas_update_gap
      0.86            -0.5        0.35 ±  2%      -0.3        0.59        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.67            -0.5        0.19 ±  3%      -0.4        0.31 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.76            -0.5        0.29 ±  3%      -0.3        0.50        perf-profile.children.cycles-pp.mas_next_slot
      0.68            -0.5        0.21 ±  3%      -0.3        0.38        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.96 ±  4%      -0.5        0.50 ±  3%      -0.2        0.74 ±  3%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.80            -0.4        0.36 ±  3%      -0.2        0.61        perf-profile.children.cycles-pp.zap_pte_range
      0.72 ±  2%      -0.4        0.28 ±  3%      -0.2        0.48        perf-profile.children.cycles-pp.mas_wr_store_type
      0.60            -0.4        0.18 ±  3%      -0.3        0.34        perf-profile.children.cycles-pp.touch_atime
      0.68            -0.4        0.27 ±  3%      -0.2        0.45        perf-profile.children.cycles-pp.__vma_start_write
      0.61            -0.4        0.23 ±  2%      -0.2        0.39        perf-profile.children.cycles-pp.up_write
      1.58 ±  5%      -0.4        1.20 ±  3%      -0.2        1.33 ±  5%  perf-profile.children.cycles-pp.kvfree_call_rcu
      0.51            -0.4        0.15 ±  4%      -0.2        0.28        perf-profile.children.cycles-pp.atime_needs_update
      0.62            -0.4        0.26 ±  4%      -0.2        0.44        perf-profile.children.cycles-pp.perf_iterate_sb
      0.58            -0.4        0.23 ±  3%      -0.2        0.40        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.59            -0.3        0.25 ±  3%      -0.2        0.41        perf-profile.children.cycles-pp.mas_rev_awalk
      0.54            -0.3        0.21 ±  2%      -0.2        0.36        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.43            -0.3        0.12 ±  4%      -0.2        0.23 ±  2%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.49            -0.3        0.18 ±  3%      -0.2        0.31        perf-profile.children.cycles-pp.down_write_killable
      0.51 ±  3%      -0.3        0.20 ±  3%      -0.2        0.31 ±  2%  perf-profile.children.cycles-pp.kfree
      0.41            -0.3        0.12 ±  3%      -0.2        0.19 ±  2%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.41            -0.3        0.12 ±  4%      -0.2        0.20 ±  2%  perf-profile.children.cycles-pp.freader_fetch
      0.46            -0.3        0.18 ±  4%      -0.1        0.31        perf-profile.children.cycles-pp.__vma_enter_locked
      0.45 ±  9%      -0.3        0.19 ±  5%      -0.2        0.28 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.44            -0.3        0.19 ±  3%      -0.1        0.31        perf-profile.children.cycles-pp.down_write
      0.65 ±  9%      -0.3        0.40 ± 11%      -0.1        0.55 ± 12%  perf-profile.children.cycles-pp.barn_put_full_sheaf
      0.54 ±  2%      -0.2        0.29 ±  5%      -0.2        0.31 ±  5%  perf-profile.children.cycles-pp.build_detached_freelist
      0.24 ±  2%      -0.2        0.00            -0.2        0.08 ±  6%  perf-profile.children.cycles-pp.mas_next_range
      0.45 ±  2%      -0.2        0.21 ±  3%      -0.1        0.38 ±  2%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.36            -0.2        0.14 ±  3%      -0.1        0.23        perf-profile.children.cycles-pp.up_read
      0.36            -0.2        0.15 ±  3%      -0.1        0.25        perf-profile.children.cycles-pp.fput
      0.31            -0.2        0.10 ±  4%      -0.1        0.17        perf-profile.children.cycles-pp.remove_vma
      0.30 ±  3%      -0.2        0.09 ±  3%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.current_time
      0.36 ±  2%      -0.2        0.15 ±  2%      -0.1        0.25 ±  2%  perf-profile.children.cycles-pp.fget
      0.33            -0.2        0.14 ±  3%      -0.1        0.25        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.29            -0.2        0.10 ±  2%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.freader_get_folio
      0.29            -0.2        0.12 ±  4%      -0.1        0.22        perf-profile.children.cycles-pp.prepend_copy
      0.28            -0.2        0.11 ±  3%      -0.1        0.18        perf-profile.children.cycles-pp.freader_init_from_file
      0.27 ±  2%      -0.2        0.10 ±  4%      -0.1        0.17        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.26 ±  2%      -0.2        0.10 ±  4%      -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.25            -0.2        0.09 ± 10%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.25            -0.2        0.09 ±  5%      -0.2        0.10 ±  3%  perf-profile.children.cycles-pp.may_expand_vm
      0.24            -0.2        0.08 ±  9%      -0.1        0.16        perf-profile.children.cycles-pp.get_page_from_freelist
      0.23            -0.2        0.08 ±  3%      -0.1        0.13        perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      0.25            -0.1        0.10 ±  4%      -0.1        0.19        perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.24            -0.1        0.10 ±  5%      -0.1        0.16        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.20 ±  3%      -0.1        0.06 ±  5%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.23            -0.1        0.09 ±  5%      -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.20 ±  3%      -0.1        0.06 ±  6%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.26 ±  3%      -0.1        0.12            -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.26 ±  3%      -0.1        0.13 ±  3%      -0.1        0.17 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.21 ±  2%      -0.1        0.07 ±  6%      -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.vma_mark_detached
      0.13 ±  2%      -0.1        0.00            -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.23 ±  2%      -0.1        0.11 ±  4%      -0.1        0.17        perf-profile.children.cycles-pp.downgrade_write
      0.20 ±  2%      -0.1        0.08 ±  5%      -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.13 ±  5%      -0.1        0.00            -0.0        0.09        perf-profile.children.cycles-pp.vma_set_page_prot
      0.17 ±  4%      -0.1        0.04 ± 51%      -0.1        0.07 ±  4%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.14 ±  5%      -0.1        0.02 ±152%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.12 ±  7%      -0.1        0.01 ±300%      -0.1        0.07 ±  7%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.19 ±  2%      -0.1        0.07 ±  4%      -0.1        0.12        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.19            -0.1        0.08 ±  3%      -0.1        0.13 ±  2%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.11 ±  4%      -0.1        0.00            -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.cap_capable
      0.18 ±  2%      -0.1        0.07 ±  4%      -0.1        0.12 ±  2%  perf-profile.children.cycles-pp.testcase
      0.14 ±  3%      -0.1        0.04 ± 50%      -0.0        0.10 ±  2%  perf-profile.children.cycles-pp.rmqueue
      0.13 ±  3%      -0.1        0.03 ± 81%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.10            -0.1        0.00            -0.0        0.05 ±  9%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.19 ± 17%      -0.1        0.09 ± 15%      -0.0        0.15 ± 13%  perf-profile.children.cycles-pp.strlen
      0.10 ±  4%      -0.1        0.00            -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.refill_obj_stock
      0.09            -0.1        0.00            -0.0        0.06        perf-profile.children.cycles-pp.security_mmap_file
      0.22 ±  3%      -0.1        0.13 ± 10%      -0.1        0.16 ±  4%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.08 ±  5%      -0.1        0.00            -0.0        0.05 ±  7%  perf-profile.children.cycles-pp.static_key_count
      0.14 ±  3%      -0.1        0.05 ±  7%      -0.0        0.09 ±  3%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.08 ±  3%      -0.1        0.00            -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.08            -0.1        0.00            -0.0        0.03 ± 81%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.14 ±  4%      -0.1        0.06 ±  8%      -0.0        0.09 ±  9%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.08 ±  5%      -0.1        0.00            -0.0        0.05        perf-profile.children.cycles-pp.__account_obj_stock
      0.15 ±  4%      -0.1        0.08            -0.1        0.10        perf-profile.children.cycles-pp.tick_nohz_handler
      0.12            -0.1        0.05            -0.0        0.08        perf-profile.children.cycles-pp.mas_prev_setup
      0.12            -0.1        0.05            -0.0        0.08 ±  3%  perf-profile.children.cycles-pp.filemap_get_entry
      0.14 ±  3%      -0.1        0.07            -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.16 ±  3%      -0.1        0.09            -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.06 ±  4%      -0.1        0.00            -0.0        0.04 ± 33%  perf-profile.children.cycles-pp.__free_one_page
      0.06 ±  8%      -0.1        0.00            +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.memfd_check_seals_mmap
      0.10            -0.0        0.06 ±  9%      -0.0        0.08 ±  3%  perf-profile.children.cycles-pp.mas_data_end
      0.10 ±  4%      -0.0        0.06 ±  7%      -0.0        0.10        perf-profile.children.cycles-pp.mas_prev_range
      0.06 ±  4%      -0.0        0.04 ± 50%      -0.0        0.05        perf-profile.children.cycles-pp.sched_tick
      0.26 ±  5%      -0.0        0.24 ±  3%      -0.1        0.14 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
      0.12            -0.0        0.10 ±  5%      +0.1        0.25        perf-profile.children.cycles-pp.__kmalloc_noprof
      0.18 ±  4%      +0.0        0.20 ±  5%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.perf_session__process_events
      0.18 ±  4%      +0.0        0.20 ±  5%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.reader__read_event
      0.18 ±  4%      +0.0        0.20 ±  5%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.record__finish_output
      0.05 ± 33%      +0.0        0.08 ± 10%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.00            +0.1        0.06 ±  5%      +0.0        0.00        perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
      0.00            +0.1        0.10 ±  6%      +0.3        0.26        perf-profile.children.cycles-pp.__alloc_empty_sheaf
      2.26 ±  9%      +0.8        3.04 ±  5%      -1.1        1.18 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      2.24 ±  9%      +0.8        3.02 ±  5%      -1.1        1.16 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.02 ± 14%      +0.8        1.84 ± 11%      -1.0        0.07 ± 10%  perf-profile.children.cycles-pp.kfree_rcu_work
      1.97 ± 11%      +0.9        2.90 ±  6%      -1.0        0.99 ±  3%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.69 ± 43%      +3.6        4.27 ± 10%      -0.7        0.00        perf-profile.children.cycles-pp.kfree_rcu_monitor
      1.70 ± 24%      +4.4        6.07 ±  7%      -1.6        0.07 ± 10%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      1.70 ± 24%      +4.4        6.07 ±  7%      -1.6        0.07 ± 10%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      1.75 ± 24%      +4.4        6.13 ±  7%      -1.7        0.08 ±  6%  perf-profile.children.cycles-pp.worker_thread
      1.74 ± 24%      +4.4        6.12 ±  7%      -1.7        0.08 ±  6%  perf-profile.children.cycles-pp.process_one_work
      0.00            +6.3        6.34 ±  7%      +7.9        7.87 ±  2%  perf-profile.children.cycles-pp.alloc_from_new_slab
     24.08 ±  2%      +7.8       31.92           +11.2       35.32        perf-profile.children.cycles-pp.__slab_free
     57.97           +16.9       74.89            +5.5       63.47        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     57.76           +17.1       74.81            +5.6       63.33        perf-profile.children.cycles-pp.do_syscall_64
      0.00           +17.4       17.38 ±  5%      +0.2        0.23 ±  3%  perf-profile.children.cycles-pp.__refill_objects_any
     33.78           +31.0       64.80           +13.8       47.62        perf-profile.children.cycles-pp.__mmap
     30.70           +32.9       63.58           +14.9       45.55        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     30.11           +33.2       63.34           +15.0       45.15        perf-profile.children.cycles-pp.vm_mmap_pgoff
     29.42           +33.6       63.07           +15.3       44.68        perf-profile.children.cycles-pp.do_mmap
     39.14           +33.8       72.98           +19.3       58.42        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     39.50           +34.0       73.54           +19.7       59.20        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     26.20           +35.6       61.82           +16.3       42.53        perf-profile.children.cycles-pp.__mmap_region
     15.64 ±  3%     +42.4       58.08           +20.5       36.09        perf-profile.children.cycles-pp.__mmap_new_vma
      8.11 ±  6%     +46.3       54.41 ±  2%     +22.9       31.01        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      0.00           +46.4       46.38 ±  3%     +20.2       20.17 ±  2%  perf-profile.children.cycles-pp.__refill_objects_node
      7.85 ±  6%     +46.5       54.35 ±  2%     +23.1       30.93        perf-profile.children.cycles-pp.mas_preallocate
      6.97 ±  7%     +47.0       54.02 ±  2%     +23.4       30.36        perf-profile.children.cycles-pp.mas_alloc_nodes
      6.66 ±  7%     +47.2       53.87 ±  2%     +23.5       30.14        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.00           +53.2       53.16 ±  2%     +28.9       28.94        perf-profile.children.cycles-pp.refill_objects
      4.11            -2.6        1.53 ±  3%      -1.5        2.59        perf-profile.self.cycles-pp.zap_pmd_range
      4.84            -2.2        2.64 ±  2%      -1.7        3.13 ±  2%  perf-profile.self.cycles-pp.__pi_memcpy
      2.71            -1.7        1.02 ±  3%      -1.0        1.74        perf-profile.self.cycles-pp.__mmap_region
      2.63            -1.6        0.98 ±  2%      -0.9        1.69        perf-profile.self.cycles-pp.free_pud_range
      2.09            -1.3        0.79 ±  3%      -0.7        1.35        perf-profile.self.cycles-pp.__cond_resched
      1.92            -1.1        0.78 ±  3%      -0.6        1.29        perf-profile.self.cycles-pp.mas_wr_node_store
      1.43 ±  2%      -0.9        0.56 ±  3%      -0.5        0.91        perf-profile.self.cycles-pp.__slab_free
      1.42            -0.9        0.55 ±  3%      -0.5        0.94        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.88 ±  2%      -0.7        0.18 ±  7%      -0.4        0.47        perf-profile.self.cycles-pp.shuffle_freelist
      1.20            -0.7        0.50 ±  3%      -0.4        0.82        perf-profile.self.cycles-pp.mas_store_gfp
      1.03            -0.7        0.37 ±  3%      -0.4        0.62        perf-profile.self.cycles-pp.mas_walk
      0.98            -0.6        0.39 ±  3%      -0.3        0.65        perf-profile.self.cycles-pp.rcu_all_qs
      0.90            -0.5        0.35 ±  3%      -0.3        0.60        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.78            -0.5        0.31 ±  2%      -0.3        0.52        perf-profile.self.cycles-pp.mas_prev_slot
      0.74            -0.5        0.28 ±  2%      -0.3        0.48        perf-profile.self.cycles-pp.mas_next_slot
      0.94 ±  5%      -0.4        0.49 ±  3%      -0.2        0.73 ±  3%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.69 ±  2%      -0.4        0.26 ±  2%      -0.2        0.46        perf-profile.self.cycles-pp.mas_wr_store_type
      0.64            -0.4        0.25 ±  3%      -0.2        0.42        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.54            -0.4        0.14 ±  3%      -0.3        0.24        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.66            -0.4        0.27 ±  3%      -0.2        0.45        perf-profile.self.cycles-pp.__mmap
      0.70            -0.4        0.32 ±  3%      -0.2        0.51        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.53            -0.4        0.15 ±  8%      -0.3        0.25 ± 10%  perf-profile.self.cycles-pp.prepend_path
      0.61            -0.4        0.23 ±  2%      -0.2        0.40        perf-profile.self.cycles-pp.__munmap
      0.59            -0.4        0.22 ±  2%      -0.2        0.36        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.59            -0.4        0.22 ±  3%      -0.2        0.38        perf-profile.self.cycles-pp.up_write
      0.54            -0.3        0.20 ±  2%      -0.2        0.34        perf-profile.self.cycles-pp.mas_find
      0.54            -0.3        0.20 ±  3%      -0.2        0.35        perf-profile.self.cycles-pp.mas_preallocate
      0.55            -0.3        0.22 ±  3%      -0.2        0.38        perf-profile.self.cycles-pp.mas_store_prealloc
      0.53            -0.3        0.21 ±  3%      -0.2        0.35        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.52            -0.3        0.21 ±  3%      -0.2        0.35        perf-profile.self.cycles-pp.__vm_munmap
      0.52            -0.3        0.20 ±  3%      -0.2        0.34        perf-profile.self.cycles-pp.perf_event_mmap
      0.49            -0.3        0.19 ±  4%      -0.2        0.32        perf-profile.self.cycles-pp.vm_area_alloc
      0.49            -0.3        0.19 ±  2%      -0.2        0.33        perf-profile.self.cycles-pp.mas_rev_awalk
      0.44 ±  2%      -0.3        0.15 ±  3%      -0.2        0.26        perf-profile.self.cycles-pp.__mmap_new_vma
      0.45 ±  4%      -0.3        0.16 ±  3%      -0.2        0.28 ±  2%  perf-profile.self.cycles-pp.kfree
      0.42 ±  3%      -0.3        0.13 ±  4%      -0.2        0.20        perf-profile.self.cycles-pp.kmem_cache_free
      0.43            -0.3        0.15 ±  2%      -0.2        0.28        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.37            -0.3        0.10 ±  4%      -0.2        0.17        perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.46            -0.3        0.20 ±  5%      -0.1        0.34        perf-profile.self.cycles-pp.perf_iterate_sb
      0.41            -0.3        0.15 ±  3%      -0.1        0.26        perf-profile.self.cycles-pp.down_write_killable
      0.43            -0.3        0.17 ±  2%      -0.1        0.29        perf-profile.self.cycles-pp.__vma_enter_locked
      0.40 ±  8%      -0.3        0.14 ± 12%      -0.1        0.29 ±  8%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.50            -0.2        0.25 ±  3%      -0.2        0.31 ±  4%  perf-profile.self.cycles-pp.build_detached_freelist
      0.45            -0.2        0.21 ±  3%      -0.1        0.38 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.37 ±  2%      -0.2        0.14 ±  3%      -0.1        0.27        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.30            -0.2        0.07 ±  4%      -0.2        0.12        perf-profile.self.cycles-pp.unmap_page_range
      0.38            -0.2        0.16 ±  3%      -0.1        0.27        perf-profile.self.cycles-pp.down_write
      0.35 ± 12%      -0.2        0.13 ±  6%      -0.1        0.21 ±  3%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.35            -0.2        0.13 ±  4%      -0.1        0.23        perf-profile.self.cycles-pp.up_read
      0.35            -0.2        0.14 ±  3%      -0.1        0.24        perf-profile.self.cycles-pp.fput
      0.35 ±  2%      -0.2        0.15 ±  2%      -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.fget
      0.19 ±  2%      -0.2        0.00            -0.1        0.09        perf-profile.self.cycles-pp.__build_id_parse
      0.38 ±  2%      -0.2        0.19 ±  3%      -0.1        0.32        perf-profile.self.cycles-pp.zap_pte_range
      0.28 ±  2%      -0.2        0.11 ±  6%      -0.1        0.17 ±  3%  perf-profile.self.cycles-pp.do_mmap
      0.27            -0.2        0.10 ±  4%      -0.1        0.18        perf-profile.self.cycles-pp.freader_init_from_file
      0.26            -0.2        0.10 ±  3%      -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.26            -0.2        0.10 ±  4%      -0.1        0.17        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.27            -0.2        0.11 ±  4%      -0.1        0.20        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.26            -0.2        0.10 ±  4%      -0.1        0.17        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.26            -0.2        0.10 ±  4%      -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.do_syscall_64
      0.24            -0.2        0.09 ±  6%      -0.1        0.09 ±  5%  perf-profile.self.cycles-pp.may_expand_vm
      0.22 ±  2%      -0.1        0.08 ±  7%      -0.1        0.14 ±  7%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.20 ±  4%      -0.1        0.06 ±  5%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.19 ±  3%      -0.1        0.05 ±  8%      -0.1        0.09        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.20            -0.1        0.07 ±  5%      -0.1        0.12        perf-profile.self.cycles-pp.vma_mark_detached
      0.23            -0.1        0.10 ±  4%      -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.21 ±  2%      -0.1        0.08 ±  3%      -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.__vma_start_write
      0.18 ±  2%      -0.1        0.06 ±  7%      -0.1        0.11 ±  3%  perf-profile.self.cycles-pp.free_pgtables
      0.19            -0.1        0.07            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.17            -0.1        0.05            -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.atime_needs_update
      0.19            -0.1        0.07            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.11 ±  3%      -0.1        0.00            -0.0        0.07 ±  7%  perf-profile.self.cycles-pp.d_path
      0.11            -0.1        0.00            -0.1        0.05        perf-profile.self.cycles-pp.__filemap_get_folio_mpol
      0.11            -0.1        0.00            -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.10 ±  4%      -0.1        0.00            -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.cap_capable
      0.11 ±  2%      -0.1        0.01 ±200%      -0.0        0.07        perf-profile.self.cycles-pp.mas_prev_setup
      0.15 ±  2%      -0.1        0.05            -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.10 ±  4%      -0.1        0.00            -0.0        0.06        perf-profile.self.cycles-pp.current_time
      0.16            -0.1        0.06 ±  7%      -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.16 ±  2%      -0.1        0.06 ±  6%      -0.0        0.11        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.18 ± 15%      -0.1        0.09 ± 15%      -0.0        0.15 ± 15%  perf-profile.self.cycles-pp.strlen
      0.14 ±  2%      -0.1        0.04 ± 33%      -0.1        0.08        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.09 ±  5%      -0.1        0.00            -0.0        0.06 ±  4%  perf-profile.self.cycles-pp.free_pgd_range
      0.13 ±  2%      -0.1        0.04 ± 50%      -0.1        0.08        perf-profile.self.cycles-pp.mas_prev
      0.09 ±  3%      -0.1        0.00            -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.mas_update_gap
      0.09 ±  3%      -0.1        0.00            -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.14            -0.1        0.05            -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.free_p4d_range
      0.09            -0.1        0.00            -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.touch_atime
      0.09 ±  3%      -0.1        0.00            -0.0        0.06        perf-profile.self.cycles-pp.vms_clear_ptes
      0.13            -0.1        0.04 ± 33%      -0.1        0.07        perf-profile.self.cycles-pp.unmap_vmas
      0.16            -0.1        0.08 ±  6%      -0.0        0.12        perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.13 ±  3%      -0.1        0.05 ±  8%      -0.0        0.09        perf-profile.self.cycles-pp.vma_merge_new_range
      0.08            -0.1        0.00            -0.0        0.05        perf-profile.self.cycles-pp.static_key_count
      0.08            -0.1        0.00            -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.13 ±  4%      -0.1        0.05            -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.14 ±  4%      -0.1        0.06 ±  8%      -0.0        0.09 ±  9%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.14 ±  2%      -0.1        0.06 ±  7%      -0.0        0.11        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.12 ±  3%      -0.1        0.05            -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.testcase
      0.07 ±  5%      -0.1        0.00            -0.0        0.04 ± 50%  perf-profile.self.cycles-pp.__account_obj_stock
      0.07 ±  4%      -0.1        0.00            -0.0        0.05        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.07            -0.1        0.00            -0.0        0.04 ± 65%  perf-profile.self.cycles-pp.filemap_get_entry
      0.10            -0.1        0.04 ± 65%      -0.0        0.09        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.06 ±  4%      -0.1        0.00            -0.0        0.05        perf-profile.self.cycles-pp.vma_set_page_prot
      0.06            -0.1        0.00            -0.0        0.03 ± 81%  perf-profile.self.cycles-pp.__free_one_page
      0.10 ±  4%      -0.0        0.05            -0.0        0.08        perf-profile.self.cycles-pp.mas_data_end
      0.04 ± 50%      -0.0        0.00            +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.memfd_check_seals_mmap
      0.08 ±  5%      -0.0        0.05 ±  9%      +0.0        0.09        perf-profile.self.cycles-pp.mas_prev_range
      0.24 ±  4%      -0.0        0.23 ±  3%      -0.1        0.13 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.0        0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.__call_rcu_common
      0.33 ±  2%      +0.0        0.38 ±  2%      +0.1        0.41        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.00            +0.1        0.05            +0.0        0.00        perf-profile.self.cycles-pp.kmem_cache_free_bulk
      0.00            +0.1        0.06 ±  5%      +0.0        0.00        perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
      0.00            +0.1        0.07 ±  8%      +0.1        0.09 ±  5%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.00            +0.1        0.10 ±  8%      +0.3        0.28        perf-profile.self.cycles-pp.alloc_from_new_slab
      0.00            +0.2        0.16 ±  7%      +0.2        0.20 ±  2%  perf-profile.self.cycles-pp.__refill_objects_any
      0.39            +0.2        0.58 ±  3%      +0.4        0.78        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +2.3        2.33            +2.3        2.26 ±  2%  perf-profile.self.cycles-pp.__refill_objects_node
     39.14           +33.8       72.98           +19.3       58.42        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath



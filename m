Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2D8D2D8E4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A9B6B0089; Tue, 27 Jan 2026 05:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C686B008A; Tue, 27 Jan 2026 05:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30B86B008C; Tue, 27 Jan 2026 05:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B298E6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:06:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80E441B10C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:17 +0000 (UTC)
X-FDA: 84377313594.16.48C9FB2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 223F9C000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TA21VWaJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kx0+q8Tz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCffnZeHGGM5e3A9Zr6Zz6K++L6mMFlxFysO7jUt218=;
	b=KdsqmuNLIsexKTupcZ/GkXdJxvhO5nbDc3PCno1h8QZDvR+rDmBgbt5lf1xjrZEMkuU1Gr
	OaYS7FRkrziQf7uFdLVW0rv2vr2UMeJWFBVN/fOO/fp0P9K6fY2eTQt6My0X8jV1SfIYBK
	wGJ0GV8uiZRaw0CfsBE+cc83qZeuA+A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769508374; a=rsa-sha256;
	cv=pass;
	b=Wa+eQQ9k6KPrgk4athI7Ez2YpNP7sGuITdODzW8jNyj5scz3zeXrQFnVKUvrNG8yBCSaAA
	6WceL9UlzSKfGERmoUgEfgzsOOj8ebeSiHuAbw1zRH9TMXlll0HMoaxyNeAESkuhHQ0305
	fD6tMi97owbQUbkAmX9x3bvFeP1aTVw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TA21VWaJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kx0+q8Tz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R2xaLx3025479;
	Tue, 27 Jan 2026 10:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DCffnZeHGGM5e3A9Zr
	6Zz6K++L6mMFlxFysO7jUt218=; b=TA21VWaJWNowRXcx4iON4m3TsUEs334uWO
	poW2B8+vSnofuWbxe8vl2cq1yBKhgiohpVgSHUCxis6nXjZBLdE0nubYLJF8vnNL
	HspdCwzETMABM3skz/o2Beq9wWwcDeXbzItu/NzpC36oqrebT1M/11MpUNUZGopO
	L5rG0IYFCifsZYTQRdFMkIarDxrE7GODHS1U9IP1gq6SZ6hK2hgyFjI008SqyDyI
	cBN94qEfceQHUecbcPVmf6FkYrg+orPB+P3tFjWukbspuXh0vhfsNEpk2YzryiRy
	8Y3ftldxDB6hmV46a0+mSnzlRpHEcIGTfbho/AGshyy0zwBiqNDA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2urrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:06:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R8mu1H012770;
	Tue, 27 Jan 2026 10:06:03 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh97d8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:06:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rdZfZ4VB+gGON15rhUUfnFAwsOx9a2RZ2Z2hC45DuGVhVh8SGoUVVlXB67HU3vvf568RVgQfJQgrUg7YQkshhRwrKepzgdV9WecVzx0nSeXU42MZTw6SZu68GTO8q2URJDjj6uDhHC5NeCGL6dGjnxl1GJ2Qsimyd3jX8kyNwDTMDJd6XPESrDx+kJu926uQxq1/zSVAVyGiMStIsqJHN0ufhafAKt6pBRjeiZBYpobtCxUiWSBF1ly0sRo4l3dDDBPPNa8YDq8LTZiLiLmCEtvoa+CwPyIq/f/mYuZgFBqy2JPP2JgDn65OTjKhJiKHTeqy0B+mVm8YJ0piI1tgwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCffnZeHGGM5e3A9Zr6Zz6K++L6mMFlxFysO7jUt218=;
 b=FDFA1RJ6bAYJkJFcKKO8+h30k17sPL/y2IGtBOLuTQ31AOWpGYqXh2+qIBAgulBinE9b3ozWWlepcdB70TQo6TYtoj1QHjeej5NUGyvJ3/qkF1R60E/q8+XcQBxAml2qkyLe+mTa7zD6xH9V1u0P/SQkIty17TxT2/6oGq37rVS6IHRt8tdZMGPV1m4B0Ixodgx6w74fNUYURBGI3oVeAU15Vz1g78AdqnHmaIKoAKmfCun5aXgAhay+Tbj2leZVzwAqXRtT9z9LpmG7tc5j+zkqmyx/0a+KjDthU3kKKnwcHY0Yg8ZHJ1vivvhgnInWI1dMV/SD1HLCaGoLAdQsLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCffnZeHGGM5e3A9Zr6Zz6K++L6mMFlxFysO7jUt218=;
 b=kx0+q8TzekKvqF0GRGR06qDscbHa+ue6HvRK8URoPe8CCIoUaYt8SkEb4gSCW/6wISmDVomDpSvO3FpMy98M2p2cRZ1FEVJB9z9GZ+s7f67wbQYaBv9dNw5fC/5URKIZWnQPUlb6ljBiSvtBaoPYhwr4MVBS0xgPGIVSJvYtk0s=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by LV2PR10MB997776.namprd10.prod.outlook.com (2603:10b6:408:378::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 10:06:00 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Tue, 27 Jan 2026
 10:06:00 +0000
Date: Tue, 27 Jan 2026 10:05:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [tools/testing/vma]  28d7ff9930:
 ktools.vma.make.fail
Message-ID: <a87f818d-7912-4d2d-9f96-11a57ada296c@lucifer.local>
References: <202601271308.b8d3fcb6-lkp@intel.com>
 <8b1135d4-387c-4c4c-94fd-22bc433a0e6c@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b1135d4-387c-4c4c-94fd-22bc433a0e6c@lucifer.local>
X-ClientProxiedBy: LO4P123CA0697.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::12) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|LV2PR10MB997776:EE_
X-MS-Office365-Filtering-Correlation-Id: adfe8638-7bfa-4ea2-d5ba-08de5d8bac23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q7L2Yipob9pAr2h72k4N57CHEDWXaWChTS/K6sjMv98gGdUn8visCGnobddb?=
 =?us-ascii?Q?ZAXpY409fnnmuRS5/+SPaZ42md5VDxWv3d4+ncA1xlfPeDpPR0SMFI6Wa7c5?=
 =?us-ascii?Q?ZnewJKkB2pYIZjJETmostppE4l8/tEB1/MEdolACuI8LxHfNIEz8/jcdCazl?=
 =?us-ascii?Q?GVLoDlQxS1mZUZQjEJyCfmsBTOU2Hd9OmXsydyCjKqwr5rgCPiWYOwk53WyS?=
 =?us-ascii?Q?xe6z8scLVVeesGWL0gu0Zj+2LAMoleIzJoimhYywsrzv2FLyPasCmkXOBnw7?=
 =?us-ascii?Q?gmjONY4Zh7La9ZBml0u9KwJp55mbR7soyCEKPuVDBROA+StuhmA5f+lQuu71?=
 =?us-ascii?Q?oVbsH9JlDKoQRQ5ZHdcTGDkP5MXQQy3Ob/C9bNHnjTPmETRk1TUOILT+jTeD?=
 =?us-ascii?Q?qaa9Y4YT3WcoAbagHSfWZvb0wdqQloMkF2H2pvSALFxe21r7157S9UvuB/rh?=
 =?us-ascii?Q?ndbJkhQrnGoQGzR++bxAt++tdgkIY28DdHUs7EBnkVQANg2WYBn1HGJhMdOH?=
 =?us-ascii?Q?13bv/zdmylvSVIZu5Ko0Fg4cAR1Ca5MdL5LsTgIuyBSUxm4fQ06ivq1BMQh6?=
 =?us-ascii?Q?TN/JVWRdNoVYl8Z2UDdO9KnWcFh02QNwdJq43J2vbebtjCUkVI1YceHgxqRI?=
 =?us-ascii?Q?zvU+PGfRaqPJvs/UxQinoGYKu9ExjbHeeqRydAQSSrDBPnYEh6ye1tsZ8Gmo?=
 =?us-ascii?Q?ehB/Iu+qwfNZY4RHUUBxmbGdrMlkZzV6Kq7A9lAnWpklZLtOKFwhvysAChEC?=
 =?us-ascii?Q?hBqgXF9f7cfVUkPWR3sOGhmjhdf5E40jk06L4XTF1qlMfDwhtWalbuUzMnPM?=
 =?us-ascii?Q?/1QUzIHVu994Ig6+6DQZrSXszSaMLW/zH+Y4cNhDRx3S7+zl1QK+E2sUWXli?=
 =?us-ascii?Q?vS9mluhv/9pmC02RarK8Ga3Y4GAoJZ6AwZDEz7BYzZk97+VA72n6DaUoj3f5?=
 =?us-ascii?Q?VhLY6x2I+15fj4HUaxw+6ObhsGLH7vGBSsWUzsWNlJCwyrZuKqpbFkXIpC1Y?=
 =?us-ascii?Q?dcaDim6+5vtfbwbUGmTWeNEL0elHjcgbD3UKV6PU/d/xRd9tVoyHFOYRYESq?=
 =?us-ascii?Q?xqbcrL2DDVRO1ktdM1ti25Mw8fxBojZOI9xjQZlJSzeFgfL2PUAuuahX0c5O?=
 =?us-ascii?Q?y3206SBrItSq4LGj0gycQqW2+q5oYRMlaA+tWCOwvM5KfZ2+t2pWHdmTRz/h?=
 =?us-ascii?Q?wCbWkguMTLWVmdEt7i+662dkAo/0Y1j/k2ZYrfjAjq7VuQzNySVof+NLASF1?=
 =?us-ascii?Q?Ey+2AC7lEQByUSR/ax1cOTOPE+Pmc4yS+O7/QNFnQymEbttrpZiifFBjsWtG?=
 =?us-ascii?Q?0PZmfijGeLVc7CwY1qlHq7HyCUAX2cYeuXgLwy4Lq5gEy4lBsHJI+zqlEeOz?=
 =?us-ascii?Q?WmbX5bn8Nns/wBXaZtqKXOOgT+GvOKwHSjgzdXO7qH/vt9n7S4f58sbnwRjv?=
 =?us-ascii?Q?Z6o2IwgXDFHW3J/tAVj0umHHCjr/2FBkPN69VebyLfklYs86o/dhxcH++ePE?=
 =?us-ascii?Q?aSy/QTMz0yeGouXYy0gnT7+q9smOrp1cNGH2czoG/d1oQJGn3yymxQdbh0zW?=
 =?us-ascii?Q?o553n+b82X+U2RAKMy/R6PZ63nB62Ux9CNw0250j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HG5akGmsWJ7JqrkqlnrrYCu8ydzYd57wz9t2uRRkKyTgT/vB9B+MUIVnLWCO?=
 =?us-ascii?Q?6kRoaDE4ngwSy1xzwCIeOtE/k4xycdBODQ9Foaix/PVRTyJ48WWmBwoF9wvp?=
 =?us-ascii?Q?XLwe9lU/pHzy+kk/0oLFBvQuMpb0yRTukyZhftWG5W4F191gCeaBUDIxqyQW?=
 =?us-ascii?Q?kMU4H26XJ34iHTdJ+mM6mO3oKuh/4LnkIGMrbLVH+9HSU6KmNqps5xwzyXea?=
 =?us-ascii?Q?71kTvLe2ZsYVE7AY/saXPW2G38n4SNxhCCf4Hm+aXYbgZPDW+UobZfE1ycz/?=
 =?us-ascii?Q?t5GiFUGG+wEyND4vMK2PqwPboXFwGY2Znh0eiBR7zm/LD5AyCz8CJ85jR2eN?=
 =?us-ascii?Q?8I77t0rQR9baQFNiCa/1aaJLTVQlH3hVIKAYQ5YJAQutIEQRBNQ/9x5nvdeK?=
 =?us-ascii?Q?gVpGVSaQSAljReopvDa5s09ZTHC13EaP+w8C2nOLEfiF3xxbH5R+fEzPe7fy?=
 =?us-ascii?Q?Fru5kA07kIflPk7ZREGkrtAkTI2FKuAvQ4Yoo9tugMYtii+bZG5s4qQ+O3lV?=
 =?us-ascii?Q?R9JW0XZEfsph4KK/A7aB7fvBPDbCkgz9yDxzRVZ7kzlMQgb/juZxIIxN039G?=
 =?us-ascii?Q?4IZS7UWdAfUAd/Z4QNWOc59jhjzdxXdZ8HVjSkXt/AMsNQOI+ziURYhwP6la?=
 =?us-ascii?Q?IC4m0z8EhqZt+tOf6rgyvrXnBSWdbfQuXpxJ3yNcJD0dfrO6s4MNslvZdkyb?=
 =?us-ascii?Q?+3GTxlwYCYSFPVXRpF/gxaZjjgaE1sItFdlZxppNRXywpDBkAlyAUmzlZec/?=
 =?us-ascii?Q?U5xyEYLkIkxG5yiOeOGTio4mGEi6Ju1C2gVxvocifPdX0p4+i+RTj4hiUwzL?=
 =?us-ascii?Q?RSP1UFMt6R60fmQUh6wXY0+45DNkN98HPVJaGtBOiyivklzAKcmyCSaRipy0?=
 =?us-ascii?Q?dYAxtWiLtGrzwskNlDSPL1cCv9R4zDWxRWOcJ++qnk4bJOxIHLonLIbG7NpJ?=
 =?us-ascii?Q?D+iIx8NBeUVZMkYG2VMrmRILMpAIyC7bNGG2xMY8NRbbCtKMsll1KDcsp6GR?=
 =?us-ascii?Q?1kMbuE2GzvByvQfK2bTjLMa98LalRIFrBkfq3l5nrTsgjjaTC4J5TvZpENUD?=
 =?us-ascii?Q?OyKkNW++S2W6NGZ4Tqo4mUZdaMGY8qsHYwdNkVgEu8GbfYWcJFdU7Kv9qXpi?=
 =?us-ascii?Q?mnNK1fuBwX9grma07YzXtt6ij2q9BDGzvDm4DSeiXvlgMmT7YzV/tLCNRQnY?=
 =?us-ascii?Q?xuyS+pLe3BY3hdwQnETDLOxz5p5fxGFKHdOd0a++VTkxB1pRLMIAWG0tBC05?=
 =?us-ascii?Q?Sr0XJMqq6qa1gxGxdYdSPOZJ0fBIzFZpzetmJ/cpboswmmX16saNCbFMGEYh?=
 =?us-ascii?Q?20tg+gIltJDF9Lg4HBPaUJrywCqeppbTdSHUaydsFo+85qvjIdR5/be6MhgU?=
 =?us-ascii?Q?GIY3xXPx7MoIzIyfGbHhVZIIOxQmLzk0yAAvEdaYuqJflrLHmzJ2nGQEeYrM?=
 =?us-ascii?Q?+4QjZ83/RPE1ma0jIuIYIcIp4vnwj7tj8luthHUQzkG3j/fzx1df7qKlFOrm?=
 =?us-ascii?Q?tVekS6lMWUqbNop5K8zGylNJ0qsdEaIR4pObN/6B3XKPLsx6PsHhRmGiijFY?=
 =?us-ascii?Q?kV4fuzEy7zHEXeLeKO3PJyttkobEYRUzlhlrQ9ps5g8M+6H9X+ntu6yzOep0?=
 =?us-ascii?Q?+JYhARAIctTf2TqrTanXlboy45fJ81IjG5QYwD/t0WPXFcZnN3Ql5KeUuwTY?=
 =?us-ascii?Q?CFYoTwPrRXz64vjlfoI+ro/vneyn4xNHvR71LQTkhQkj5KgkJ30gfSuUBFg0?=
 =?us-ascii?Q?3UQyD0QtYkdE1ppgTxsMHH1F77b9Bpk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PnQFjm0ZxPXfWb/ph2kcY8I/i0mxzK9hBXypo0dV2yi2ahb67DN/EMSoj1dribXQj78CRv0qnPynHrkAdRKjuuJg/bFtqxHQoHxE5VL3VjE7yoMy7Mki1eThEwALsJOPKsHmUtZ4sov2sV9uNNrQoFHI0Rv6RN17nWkaQZh2elPRhcFUvMLZ8fC0IDIYrx/ukLTnQRz4Wh0x4YyYpUqhgUOJnaWOuAgOT4MmyL5T0AC9pIVwanIadgutyc9mCk+TOJmaUOx08vI6dqxid/0OrnTXZCm+cLRdU8+z6XJJ3PGibw0CR17aXSBRIwyGOUk5+i5ciCvLUTWlBamWHxdiJXq28x7x7yF00Q5T21cQt0loelr6ud96tPE7oE2LZGXhoiWyvwpcJdnjl8DtPMTUbLiGHlJajrnKqu7vgh7dm3hfGRg0iAFUTb4dpDCONQh7XmspsN0aEPC7vnbZoStFlapBXYBolqqN8AGEqFr2Db50SvvwSs1lp33JnznH/Kzc8OVv1cQdrSwCCFKhAWKi1P0wL6S/qvMgDPatSVkx79Kw6tnTJgfop5+Yu7ODDKT9aKysIKdvz/FuS3tePXUBF5vuWvW7QSPJIDmT9mjJU9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfe8638-7bfa-4ea2-d5ba-08de5d8bac23
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:06:00.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnVdMJPAFSx3aJzczDqoSptsW1x7W+sRQP9kINx2Wa4Y7WzTir1Ua8W2IRNmkMwOgKcxUReHLI9aTVdfzKRyFnuczVa825l5OTaRIl1zdR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR10MB997776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=834 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270082
X-Proofpoint-ORIG-GUID: GuNspaJN56Tf8tngBplW53XmjwD0Hwnv
X-Proofpoint-GUID: GuNspaJN56Tf8tngBplW53XmjwD0Hwnv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4MiBTYWx0ZWRfX5Fzx/LcAJThC
 F2uOtavhFZGVjw2Ys7qzktAiEJDPgLoqtAkpefpmLOzZe8ssafLdWy9Md6+yfZ2glySvELHk7NC
 kqmn8IM+JELOF9tTS4h+RhTu53Qd8KXzccHFf8t68xrC73RIqJf1mbg7TGfBKXqAIpx57lch+Ta
 fRw2x4Yziyf61Wbc9vvle4LJUHY0i325WkRJOJRYfCKufKT/n0Kb6bRQQKHHEfY43X/6LlXiqJb
 Z43MalcPyzIAga/QXeMiG0LrtWJwizRLeV3U6QFnZmi2YQK1d/ZbckqRP5IpBgWa7xG9xmtQWyf
 OlSiGqpe+2TSkERJ+ERjBnmc4euSxGEtNlwpi/Im9Htm5xD9gYXP6JwiKNPSbYI+pZVqaLxj4ka
 kCFkFOF7QLpGpBNKUx/7VKInqE5IS8VXFoArH1MVN6V+wE2Kiz2x5TTGSNKvCWZ0/DfYCF3oJpb
 uv6FFuMyQLdeJwCT5zg==
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=69788e0b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=uJf-LWHaVIhMWVALWaYA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 223F9C000A
X-Stat-Signature: z3z7cimh6z1hqcfs4o6r8quji3hfj5w9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769508373-455354
X-HE-Meta: U2FsdGVkX19n5Tb7WUo+ZSgyg0VwsCRnATedfMAFUZDBsGsy4hCSICnOzlX0y2Hv27Rx3vmA56TUbwI01+Jlb2jAXNIRq41VwSu2qDTgStIxmMneFYGR/HMjIH0gp34rA7MkmN2e53s9Yp0NEeL11NaCv2bIeLSMyLeWL15/23rRFdGfC1gdJTXESkWS4gmdGYbIGvr3CFyFHzpjx6cRGvEg1UdVfEMKH5enl7a6TIXxREY2JkgVSFAxZDYq0emLNxi6dK4nDA1QUbfD/HbVproJv5hDoXSuY9TgBLhSZn9vzZQWgH98ajczCs5gmxetOIClUQrFgc829RE1V4G9GD8o9WqoA1LBRMad1oThhdfN87v2UOKj1IZpNOmXm1mh/1BxFScyYN25AJDjA9gViQB4Oq3ALtZwUIoIsBQ7B+M/XcCN3yo4BEp+qteCdGFGrTypodGx0KIjsXvBx8++tWwe8zJ+HD0o52gPtotYEJ7DPv14HMR76Bmq2UnWoiq4vKy0HfUrlIiauQNFuzMAzx0t1XIEMC7X2Q/401LgDANUl5S4pxE4v9SS9viNBqG9h2Mp6E8MSCPLJoaVOZpTQ6hLGeJ+DnfPVSn1k+bdWm0AczuEXzfCLodF3EW5rRcD5055nnCvxq3bVZeIXLwgS/uhkix5GQ57FDUuQ7mJZYKFAWBUBK9p/lkK/pvx7HiZHjuK+BWxaS6IueYE4J9amg00anRa7tucqu1AH/Di8OvC/S8mRrxDZfENSdjQQFmhIGaC/MZMdK4MbJ82N7ZgK4rRB8UBeDqYcFqv4Jx6l7Tq4m0QcbW2tmit1gRi2SIRh3uVGd2pTFAWTXmPR6VkQQfQwZFeqbHclSXB8AYNxAdDSWFeZsvfZD/1Sgz2MuZP2DqUdsHgCOFODlO7wmmeYgoyegw14Jwc4iueZ46Ijk78t4VkXY9nrghuLrFZeOqwROlcFKj9GfatnMC57Ru
 MIqfuFlv
 ldwCUxDo0Z1A0Vx//xaUTnos/ipXM9Pd+1xmwp3PylXbYb2ZUtk/p6s8w9btQCuLO4T352PuMx+dIY+/vW4JX8LNQogIRq95Bu2NZmYg9MslvuR7nEhBa2NeWZhzaKnqegS0ZfQGCaM9719Qn8g2ZVY1fL0X4aOsEs80uoDUYBD8IDZ3JjLAoXNTiNmW/vfWV7lTTodOOlETEFqZspKhdA1fFM3UJuP7hgMZql/jHf9D9BVd31CtDjH4A1zygOg1OVs1/QKl5ZAUldU3HpRTXJ4ZfDnpIQy541Cxl4KIIAJ4PX8xAlPxO7OaVuRvF2nisHofq5O46AXgahIwZdjLVVyviAqpKvWhk7Dt6RCqt0grZWF2aedBcashlHEfrhSCtdty0qinq5hXZ1YMELQ60vtUO5fIcy9P0HTgx39mGhBPQxi8dzxB6SA/npBUHIXhU7twMDV0WjF4EgLqSY6X2kFZ48VyAFjQP/pFbS03WX3T4RxjkACg/EhiBVs3b+QV51lBm0DABsyh0GoxPQtrSUjHzQypQ/wjBDMXIcU27nvJL+f9YcqNaLcXgOnNM8WGM4p23c/g4e+9Nh29BjHdxRFAQhKPUmZqJibpbIYDHbN/jKqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 08:18:12AM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 27, 2026 at 02:13:11PM +0800, kernel test robot wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed "ktools.vma.make.fail" on:
>
> Thanks to whoever set this up :) so far VMA userland tests have not been
> exercised very much and I've had to find issues manually :)
>
> >
> > commit: 28d7ff99300f3a897eb6419efafdbcf96978f637 ("tools/testing/vma: separate out vma_internal.h into logical headers")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>
> Hm this is strange, this works perfectly fine locally at this commit.
>
> But it does seem this is duplicated so will fix-patch at this point in the series.

Fixed at https://lore.kernel.org/linux-mm/1e032732-61c3-485c-9aa7-6a09016fefc1@lucifer.local/

>
> I notice the build is broken however at tip on next (will bisect), I guess the
> bot hasn't got there yet? Seems somebody added a compiler directive that is not
> stubbed out yet.
>
> I might simply fix by adding to this commit as a stub to avoid hassle with
> chasing down the offending patch...

OK so the other thing needs a fix in a tools header, so will report separately.

Cheers, Lorenzo


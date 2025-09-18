Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0564CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A2B8E00BB; Thu, 18 Sep 2025 02:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520F08E0093; Thu, 18 Sep 2025 02:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2118E00BB; Thu, 18 Sep 2025 02:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21B688E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:09:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD24B86BB1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:09:58 +0000 (UTC)
X-FDA: 83901345276.20.4669568
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 612F340007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:09:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fVFmYUwA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcXlG98J;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758175795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlY3hMC8uaY9rYXjftIMZwXuDPh20OnTaynmLKmt4+g=;
	b=dQlJA/17NtSf2qfEdttlLOoIFikctzVTW2KO80CWkypcpCxG5y9S1eVy0bONXTj8jaihER
	y8sW9BJpJ5GipFrMgyYh3OgDWKMcCHvM5Xl5zTSlZoW++Wd4jIY/TzLly6fCOD5on9acDZ
	rs/FgR2aWRVf0A0ta5GbK6eUTKIjgMc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758175795; a=rsa-sha256;
	cv=pass;
	b=JzKOXi/MWSFgxND/OA7RBx611Y5q2Vnkh5dqIWj4dEVP9Xo0jwXq6pbTjnMUFg9+gVmziU
	Ev2dw4i/LNauZV3O84euauqlOJnDtZTRY7yvQ3WiDgKZ1QstAMA27WCCquJrzEDXxyk7dj
	Ivvmv56itv2qIg7uGl8ESEMMuQvt82s=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fVFmYUwA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcXlG98J;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HMgenX010081;
	Thu, 18 Sep 2025 06:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JlY3hMC8uaY9rYXjft
	IMZwXuDPh20OnTaynmLKmt4+g=; b=fVFmYUwAeVdBoEJ4S6f0Yu/T/1WqK6jRGv
	uxNBCA8PkkJGq7wSm8kO7jDBzExwl31gy/m0w/x8mQBsF4+5uLz9eqval/uyM2b7
	ay2dvvcQEq5iiBrjHTlQ5r5BFnaKVf6+59FMr8jDmy0KbDCs6nygfiuHp1vmq0ig
	YEE1ptKYlh8J/OoOsoWI3dQ6saorE6m/dDDmSBPad0uSWwgjQJO8dkbRB63cmaUy
	JvdpzWQf6orXMc++JYhWmwvs2mSlai2gqj9e+NsoWcYtmiUDUYdJ+zi3/4P2esk4
	Gv6OF8NG18iHYo/wxaEEHAMR/8gHW4xGASix7JNSBqCfCUj0ku3g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6jrbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 06:09:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I5jCJD027359;
	Thu, 18 Sep 2025 06:09:34 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011035.outbound.protection.outlook.com [52.101.62.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2my32t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 06:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCF6RnAOCEpgcqcZNCDRSNd8ok59DuRUDtnDY6NK4KAJO7FENVybK/JYYWvMceAHajGxK5TjApgGgy+6TCOWaRdk4CQzvN/+G6XrVUwiJpm24ucGM1kFoq3x2iCLpOkZzqrnfdpccrIuMW2co6Ph0Ve8pAsnwPkqdhfPI4/7GHfnRoodDqfs+ODxJbfD2O13yEAxTiHGbcazVkeFhnDetkgl6y192j/Hyu54q2QaYV2eVyqFd1FlHLy7qB5WtugR6qMP/l/r/j7mqRrO9ujf8IPvn+2vqdh6DkjwG0Y31zP1WCNxAiFEqwaP8u/XmJPehKBWUQoKB0kbDcSHjNojYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlY3hMC8uaY9rYXjftIMZwXuDPh20OnTaynmLKmt4+g=;
 b=hHaeCoc8JqYtgDlQDw5mTL59gGonELKBU5Vd2dOjj7F4Fb4UGWA8RL1AfhMzkjYvJmyHgGrST/Gp94MPXyHoiFi1mOhG+/rZ+pTbsJcS+10yHLQ+XWKA1bbTleMMyw0JAnmZ/8QeHM2EHWvkNC4eRV/9tWEczH0454pOj7tpTRfQJkrXZf74S50qTlMUAZhmj9EyVx8gqR1fvLOwiGaGuMbQm/M0eTlE+JlPAC6W44JomPpsXTu/WgIdJlqUlAvfFFAXdogcU8ZPI9kDI4530edfxFOY96FAkW18wtK1Zje8ecbFur3kojC8uegNz3gTVkGVR8HaE8bEODMr8hB/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlY3hMC8uaY9rYXjftIMZwXuDPh20OnTaynmLKmt4+g=;
 b=KcXlG98JN01YuXw8J19OEVDiNotKN3EHjHG3zfSRajU30eXZ6++RCewBq8ezhhhDHuMQmfHYpskgeYIKO/AlKOyAFJRWNT+gal0KyhA707j4OmJXI2scBlnl5ZettlVZME0ayXd6UQXDhCGBkoGPsfdA1sEh4GJnDO6Yq3Xv04A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5199.namprd10.prod.outlook.com (2603:10b6:5:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 06:09:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 06:09:31 +0000
Date: Thu, 18 Sep 2025 07:09:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 09/14] mm: add ability to take further action in
 vm_area_desc
Message-ID: <df1c197d-ff38-40e9-8466-829bc5d4e642@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <777c55010d2c94cc90913eb5aaeb703e912f99e0.1758135681.git.lorenzo.stoakes@oracle.com>
 <20250917213737.GH1391379@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917213737.GH1391379@nvidia.com>
X-ClientProxiedBy: LO4P123CA0570.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: f97899bd-138c-49d6-ab09-08ddf679eeaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2uqRmNQEVxWfMyMKwvDWgi4dIBYdR83TftUXQgJFzNZadgZZvJRCycax0LQv?=
 =?us-ascii?Q?VAPevuawusFYvfwQEQzzvOFPM0HI2U75y4PWjFMSAbctbrpzBq+Ud56rsJhM?=
 =?us-ascii?Q?4SU2DD7WgIgTOa9/1QYAvHFDym8yF8lLrx68xsOOLhsCktKzeqGcW4QvGBF4?=
 =?us-ascii?Q?Tb9869cUBpzslfIdu1c44rX3U2qs0ZIVxrJ1V0U9KvmrND1Xo8+bwcdQYS5y?=
 =?us-ascii?Q?9v/sjWkKs+vQ4rQ5U1ZjtTChLqJsyefcxLkJwC93e1bSnvKF8CyLPBQdf9Ii?=
 =?us-ascii?Q?ovKM0AU6fqcod6wfy4AjGKwvfGiEPNHrfilFNplMQkR7b83vX0V4qGAvc8+C?=
 =?us-ascii?Q?JkjkH0Uv+89ozgY3+pfGq86W3HjnQBxe9kXXLLQpKCo5c/MU4iqHoHy5df5X?=
 =?us-ascii?Q?PlJLWRtMSXLZewcE9GzamrBP1h2N4eQ0dNElBQtUkIkXvQ3k83hJMWb1KkdN?=
 =?us-ascii?Q?4it9HDn8kDIBMKEa9BXUy1gBL8f/LT1e68AwWcocMtkEFjqNh9p0a71ppX8c?=
 =?us-ascii?Q?SZAY1fXwqRZR1AlYWsgwBX2GcBSBIkg2t7Uga/Sl1SF6tGNVCqxXHmRDl8hb?=
 =?us-ascii?Q?Ptr13i6Gh9YhgupFUZ4wg2H+z5UemOAStY+F0xyOIDC1f2ss/ZJ3v5yeNcOj?=
 =?us-ascii?Q?KVgG3+0hh9ipT+sBLyOjsR7RhZqBCpyma07SVNTxcnmxln2YTYlQnXIWeY5H?=
 =?us-ascii?Q?LBXR0cmLlhnZrfgEekN+C5xwYXeVxdd5Nl4e71Kp6IGJ6ajw2VANcTeIaHYZ?=
 =?us-ascii?Q?40p+/Gr0AHcMpzOMBC6IlX87VhP6Iq+Guygbhs+6xbyh4p+DHe2K0R5uYJlv?=
 =?us-ascii?Q?f8ilM/Au2pJN6awgxnBqHKzOqTReLGITRlMyexYoaebBY9jCKvxVjZqVlJln?=
 =?us-ascii?Q?K11UccqxxlMuzSlfS1FqaT9RS1ZtZ800njwb9GfWFeybU23KjLpsGxQrqWL7?=
 =?us-ascii?Q?B99aH1pnd7YeaJWygo0eB+ESFpHeP/g3w6uDJkYeIEvyqWbX7FKQCnrepuwV?=
 =?us-ascii?Q?qD1WXJNcrUc6gEqw2wTGV12PRa3hwIN1kzcGZEnSSBJK3z571HRwiVUPqDCH?=
 =?us-ascii?Q?EeYwoEt7rrUdgWfSPAtcfdJPf8Hw8wUr1IB3xFdaC92s0h4Zp6vEWTt/KxSX?=
 =?us-ascii?Q?OUpETb64apjxvvq+2bKtt53g7Vdh38LEAXm3ivQcSUCrDhtQ/PR9b0EH+XcE?=
 =?us-ascii?Q?gQuSs6uTgq72s3Ap2Kq6ThiA9iRSvCQ99lyhMlUiWOmt9MsSBLmK6YgzcorK?=
 =?us-ascii?Q?qXVeXo1u6SSPYePmXcKtJB9f7UMex+3ZNOZKzwXuFj+BV8NGujMUVPV51uq8?=
 =?us-ascii?Q?rEwOEyKCyAvE77Ni/yTcn8kAnFPVZIAFx0PvhG2BtI5I8w4xSzqhjrjvwIhS?=
 =?us-ascii?Q?xuocqfPNBBS+mEOsoLn1kDZ+pryhgXxqf3wtX9eedtiG+vLDnABTOn6OohJQ?=
 =?us-ascii?Q?0b/49AlpkBk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cJhQUVGzBdHb7XoaQVcFpKvjVu7ew4RYdJj/GekRnvuCKhyNW1n9wGOU3VV4?=
 =?us-ascii?Q?AMIJCeXyc3/09435c45g+AiSyt1lhVozE5ZjPWbANl3MJxQp4KJfOK740/Bs?=
 =?us-ascii?Q?oG3An5d4Y+GEI26J/XLmzzYJdTfEZabRiG0/iy7azg9u1N2/mAdYnNF9INaI?=
 =?us-ascii?Q?Yxg0hheOZiCQjeNcCtU7NAYfxiOTE3EZcQbqPlNxMfMzJ4AWE8hOCo/tZpFR?=
 =?us-ascii?Q?s8CUjvfZ4thYTLoMx0CGVLjz8fs9atLgJMPLa1VL/U4vJjSOhzhmuZnbmBjk?=
 =?us-ascii?Q?G2HAb9uEnPxRbtn60UbviHHPHcU3oQQbO34LYdiZbRCWerfJaNp2smrL3gBa?=
 =?us-ascii?Q?nd/vPL74Ef+GIYBt7pSdOBnE44HXmusiXFdYUQTXHkAjfeuWgC7Qmuw0H68S?=
 =?us-ascii?Q?6jp4zXyC4D3EWceRURO84SQRzomPoZCulRoRZhumImepFG8sLUfgRUtMBE+O?=
 =?us-ascii?Q?WyaldhCmbuHWOqfM1af3Z/7nzTogV4mCem7VxVC32TkVSjbUZsTHqAhXsGhy?=
 =?us-ascii?Q?Q4RVxuBB7YFp2a+oVrt53yzknE8E1ubUAiQWTQhZYvd50iqYsrAdA/UYnkaq?=
 =?us-ascii?Q?Ex2EvGTY3G1UcaQ0GXFSdGe6EmBxipPYyM9/HITOBqdZsq5dJED1wOpafiH6?=
 =?us-ascii?Q?YQavLn2uB4GYIAx2qS8nllC251gsc0TAykcn+Od31FpwBe55OZHnlX92uSE7?=
 =?us-ascii?Q?QNMTH7GBZOP30GfqxAr4uVlojce+6yZnVu2REY7LlZYreZaMXQAf2J3sSgO/?=
 =?us-ascii?Q?IzTR99MWo7LgCoTQYP0iVoadSQby/ggs0yc1bc4KOUFoBBFtg2iyNGRTzt5O?=
 =?us-ascii?Q?vxv5gDW9thpzxllc0tsm2M+tHrsSrHIv6Q5sBAxZdHbOe1cenDvmN2qS/1WU?=
 =?us-ascii?Q?wct6KasuICGJq31TZWAVM7FwgHpui4U2YMh0awLnmQ7D0BJ9XqP2Dwg1EzyA?=
 =?us-ascii?Q?Vuv8Foo+yIGd8m8CUoIfOmM776GBacnbBjuBCMggb+5sMQWu92RmP2Y4q+Fc?=
 =?us-ascii?Q?p3cTARIPr4D465+G/U68TlVnAASO2lBH0aBTCCop2gbqoV98ZRhOWA7sHwTu?=
 =?us-ascii?Q?sy2g5zDnjch/eNeBZNfHTYNwy4uJ8NJaVQdt3nJhINqYG8fFrajJBzPipiKI?=
 =?us-ascii?Q?Hl0jnRSWDx5hQO2E2f/4tiUIexn/UCoX5SMq/ceSbGiDLv37DzdXOCk8xUuz?=
 =?us-ascii?Q?VgIfrW6CJUgW0lqL/F1TCUVdHZPHeZH+Nf+x8EF9HRlYS35pNUU+X7v1MMIp?=
 =?us-ascii?Q?FJfy7U7vCewoBYMd+UAKCrvCL/FdCDvxJjo6/kz0M1zZwbem5Te8xGnovepQ?=
 =?us-ascii?Q?8hLaC0B+peTTNHk2+L1cYOJW4la/aQgbjV7Pp5lIm4TbipGO++pdZrmVNHPM?=
 =?us-ascii?Q?kvecN2zAX+/uuBjzyDONqUUvBjDspxHf8AvRP+J4grmCmEUGVqHS8nmF7kW9?=
 =?us-ascii?Q?xDqRwj23hA7pB2CYCfrXIQR/kLW2dhr7/NO4ETIQq6z0oMz7poIHsuemCvBf?=
 =?us-ascii?Q?9LfTitwoB2EgY47zER2+g9gEriUlac7PSaTEPLevyYjtshCtNrW3G+Jj/nKd?=
 =?us-ascii?Q?3KqtPQKe76FK4BUlL37RIfEaPl7OHl8uEtKi78zmS62+NOYGHH+BiZ+jY40y?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vqMwVYUYiOMEnQLXg+N6yiSJQNIhSOzmUicaG/NHZcm0Xkmis6SnFBURIPyMZDLNgmbRhWPXa86/1K0F4repbXlv//RKbJU13JFyXvI3UWbNiOnqU1Biw4/fq/FWEr6l48YtuA046sivTEYmVyfhPpQPSCtmEG7PMQEJAj/ehvBGfTGIrpnGT49B6J5yjAopvWXXVodN/zZiSWKVDNpp12xv0WIUAAqGZTnChcnk/+Utq5wbAcZqmYgU/YJaJe/CVhTPOGec0uyJNvCHLYbAonHAsdCKZVuJtu9SFMy2/nEE9o7SgjLWQUgncgZJt90619TZ7FdOpN2C7ldxlp+bsZQsOf3avKx6YEdERuPO0Puf0aAiS5ormxyaZdf+Z1rVaqWtudqSSYooONXyon1T86O4CRJSrYTkk0Lp/KN5IAZrNIJy+lrOaTNUMcRJpgj7IP9dag3YwEUecfr15g2hfa0gG64+zQnYuUlGZmg5hE2NO5TmMyaF+GELh0SXCZXz+L1kH9X3DPE6Iz2apl596a/f/C00i28KSbqOV32sVNw0/jxqAHGnvH0FcKYT/FX2ClnBgTr1+DqFscWvvoGrRw0Ex5gnotgxl3mSx7NU9c0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97899bd-138c-49d6-ab09-08ddf679eeaf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 06:09:31.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akpj89rkII4AtiRu6cO8U5TuCVYeoJoGA/O/0aiagBumemy+Ewp6Tx3dkpuSs9F+wkOJHK98wmRbIjdeN6zCtkD4c81z4qMXATybR8o0FuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180054
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cba21f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=vzm4EJpVXfjcab-RlD0A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-GUID: TzFxv-n83vuCHZwf24mSrGmfEvyrC2Qc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX0l2cVho+lVPN
 Jh12MKuPP+Qe4Qd3kWfRhgJx3by7ghd2oIecTpt0R/kS+J/sfROCdD/zWgx7v4WewowvWSEEhiC
 a4BqIBeGfLr76Y/baTHUbm0X/i9IbV8NDih/kjIwXdodQZS2lrUgNO5S2DoCePmYPdN51YrqG0f
 xYw4RieJKhcED4ngdO0s/rqt430TeX7puoJ+NCVCzK3CVF0Q64mkFxWdeng2qGv5qSCN41Vz00F
 VmBfDjbbj3KgmESkPNxkokmYhhPX6yRa13sNfYnFLrWNrO+tVKVGCi8w/nQ5CNvMnz/Rft8Np/S
 kxCYXD82vtAKmSNr26VKGsGD0llJUqonmwzTRIudrkFa0MNKseC9Q83p/cyr+6URYOPeAHF4QlJ
 6xPdf6O4PGC7RlymkybAoKYg6VOpCg==
X-Proofpoint-ORIG-GUID: TzFxv-n83vuCHZwf24mSrGmfEvyrC2Qc
X-Stat-Signature: cmtta5sn8jpdubnokjae9hutz6gxyurc
X-Rspam-User: 
X-Rspamd-Queue-Id: 612F340007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758175795-297903
X-HE-Meta: U2FsdGVkX19WSL3ZJaM2mqcMzM+HOlQ6iFrH2/KoOJl2QtKoplRNyY8igVfPYodSe6lIbWooFplJEmeAXfB1CwBbc2PuY1HDJNfMd1x2BFl3S0s/7PB//50nYhqc1JD/wVrDbCUzmrcOyyU65UutpAQkxIY4gi2qTI0jxrSJgMeFz7wdP0QTrVAW+p5h/bk52yk8XWadwfkwDb2CwnhX7sYm0EuPqSxpqI2ZHyNgbun1UyYDs/Z/zrNblifO1lcXv1/GfmNEWuJ6QEkanPMORKsPvcULS4rfBvXbwaBRVtQ+PMCwyS75u6QckhJmKdW3/4RWPoZF4cgAgxA80iuQ31Owdh+6M16qX3Cc6gFzU4p5lI2RMugbBfaO50kzcTQjHJbacr3GPlXUaUHlSZ1Ygx7+WF2SVTc9suNoQO9VhLYARB+6qaEgTQ+Iv2J8K3X6zyEhZk33zvP4EsOVH8TRgHMV1N7X+U9IGT5JmXwKKHAzsPiabI0kXDbtlTCEhP5sZ1zEP5e9FEQ4+QKipa0df7lE4ouCF0p72zhEGen2eRsT5PBQL4pJgrjsfMot4u88tRVZiaEKlS/3Kre0szz2JNHRdOZRZq55Q1cITmvhvMp8RkDHnBnddGHRtBRn0uwzNLmNZbKivwDTvNW7YkJQeVrv4gOF7VfmvhMkG6Hl3+Fq29JGaCA4CVUvpmST9qjK2QGVWmSljo0dLxzU7pju6A6IY8FVvQNJ+mMo/xCq7jRhj31S+VjwFlo5QAK27Y0MCTsHNVCD+rtYIUniSHAeLX3XOVRSsb0xiVeU/hLpvz9992NM4Qa5KEm9F1QQXgRCSInrcCBRVf27QbxVdOtrWElZXEEjW78U2nDK/puk3j39BoSLyxKGxxZw3k7lVdIkXK+jw6i3kei2b1sEh/ZS2Wov1uhCrIAJE6fdg37BZ3yjcVDxmZjjbLQ6y3H9ybLxuzcRn5/powvvFg6+q3j
 zYyf/XDQ
 hQnZvx7EPDRytOBQrC/x2JKDnKysi/7fMrde3zeDmYK84OHYrIaQ+uoZaX7EthfNwNtBzndF6Jwz6Jge7QDJNfQZpQyod4PeNC8cRCQoZCxgHOnIr8zmfu/GY82DcKKzde+eNba6IvM8PSepHEop8EmzbZ4VrWWn6dMMBcfK/cgKacFmnqyRBoSe9zZt+foUQUHV16QjUeLlzQF+tYNU4XNCxw1kd+9WyaIFskXOxl4Pj1fLqIATtEBX22ef2X7yVtLnzeucwKhlK0j/vQ1PXIete0beYp70RufOh2EsnJoZxG4FNhVR4+6Pak9Kbd14N9yVHo3Y0JyOHyeUGHhwx8q1W6SxPOdroCDyqKrw2DpdKCP2eIlbYYQ9xjl8K9Y8odAJsumYL96acq8sVjoteMk6B9NUh/pmETLqenwmKsLPpS60mN0dAt4u6h1copgthbn2j/jwuf9X4Eo0eruVCdPGUrG/VLubUNRuW0KEgyAYEYucY1CGdtyxvGHOosaUGHw3+NhLNHz13wQGWGYf/tmch/n8y1jiOxzsxjINgd4RF6f7OE4O60VJNtFiOVjklFO5l1R690tM2wIWbu1C6xccXMkAAyo/tI/W6UlSXV58wmmwij/4ly5c7Row9kSPxhpyCccT2mWsuF+N0TN2k6MLehsZ1BhflEnkvhQZ9UgzKYMu50rflzCAKu0ELpICkldPx4J19aMPXey2M8Wobo20H9aaqrbElbQKZ6zKI9O6BJXLtTuOdSGE+5eI+JTkk/fCMlGmVZtAit+5rZRnnZNhMWF6wfmuWcjdUpqzIyBjaIN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 06:37:37PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 17, 2025 at 08:11:11PM +0100, Lorenzo Stoakes wrote:
> > +static int mmap_action_finish(struct mmap_action *action,
> > +		const struct vm_area_struct *vma, int err)
> > +{
> > +	/*
> > +	 * If an error occurs, unmap the VMA altogether and return an error. We
> > +	 * only clear the newly allocated VMA, since this function is only
> > +	 * invoked if we do NOT merge, so we only clean up the VMA we created.
> > +	 */
> > +	if (err) {
> > +		const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > +
> > +		do_munmap(current->mm, vma->vm_start, len, NULL);
> > +
> > +		if (action->error_hook) {
> > +			/* We may want to filter the error. */
> > +			err = action->error_hook(err);
> > +
> > +			/* The caller should not clear the error. */
> > +			VM_WARN_ON_ONCE(!err);
> > +		}
> > +		return err;
> > +	}
> > +
> > +	if (action->success_hook)
> > +		return action->success_hook(vma);
>
> I thought you were going to use a single hook function as was
> suggested?
>
> return action->finish_hook(vma, err);

Err, no? I said no to this suggestion from Pedro? I don't like it.

In practice I've found callers need to EITHER do something on success or
filter errors. I think it's more expressive this way.

I also think you make it more likely that a driver will get things wrong if
they intend only to do something on success and you have an 'err'
parameter.

>
> > +int mmap_action_complete(struct mmap_action *action,
> > +			struct vm_area_struct *vma)
> > +{
> > +	switch (action->type) {
> > +	case MMAP_NOTHING:
> > +		break;
> > +	case MMAP_REMAP_PFN:
> > +	case MMAP_IO_REMAP_PFN:
> > +		WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
> This should be:
>
>      if (WARN_ON_ONCE(true))
>          err = -EINVAL
>
> To abort the thing and try to recover.

'Try to recover'... how exactly...

It'd be a serious programmatic kernel bug so I'm not sure going out of our way
to error out here is brilliantly valuable. You might even mask the bug this way,
because the mmap() will just fail instad of nuking the process on fault.

But fine, let me send a fix-patch...

>
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> > index 07167446dcf4..22ed38e8714e 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -274,6 +274,49 @@ struct mm_struct {
> >
> >  struct vm_area_struct;
> >
> > +
> > +/* What action should be taken after an .mmap_prepare call is complete? */
> > +enum mmap_action_type {
> > +	MMAP_NOTHING,		/* Mapping is complete, no further action. */
> > +	MMAP_REMAP_PFN,		/* Remap PFN range. */
> > +};
> > +
> > +/*
> > + * Describes an action an mmap_prepare hook can instruct to be taken to complete
> > + * the mapping of a VMA. Specified in vm_area_desc.
> > + */
> > +struct mmap_action {
> > +	union {
> > +		/* Remap range. */
> > +		struct {
> > +			unsigned long start;
> > +			unsigned long start_pfn;
> > +			unsigned long size;
> > +			pgprot_t pgprot;
> > +		} remap;
> > +	};
> > +	enum mmap_action_type type;
> > +
> > +	/*
> > +	 * If specified, this hook is invoked after the selected action has been
> > +	 * successfully completed. Note that the VMA write lock still held.
> > +	 *
> > +	 * The absolute minimum ought to be done here.
> > +	 *
> > +	 * Returns 0 on success, or an error code.
> > +	 */
> > +	int (*success_hook)(const struct vm_area_struct *vma);
> > +
> > +	/*
> > +	 * If specified, this hook is invoked when an error occurred when
> > +	 * attempting the selection action.
> > +	 *
> > +	 * The hook can return an error code in order to filter the error, but
> > +	 * it is not valid to clear the error here.
> > +	 */
> > +	int (*error_hook)(int err);
> > +};
>
> I didn't try to understand what vma_internal.h is for, but should this
> block be an exact copy of the normal one? ie MMAP_IO_REMAP_PFN is missing?

Right. Of course. I'll include that in the fix-patch...

>
> Jason


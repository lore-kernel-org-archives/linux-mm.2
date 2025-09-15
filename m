Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FD0CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32228E0014; Mon, 15 Sep 2025 06:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09198E0001; Mon, 15 Sep 2025 06:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD06A8E0014; Mon, 15 Sep 2025 06:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7B5B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:32:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DA6D11A650
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:32:51 +0000 (UTC)
X-FDA: 83891121342.16.3DB9CBE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC1E71C000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:32:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r3Vs9pRn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q6+TDU43;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gN8kd80giCBthjJGhIQTcTosRF/oOYZUAaPAsbcS+Q=;
	b=XtEScFKbOScoOvvCyite4ZBZR12pVlZu8kkx5iGhLRPkhRpWYSjmEXy3kFwt1MljvjwRcJ
	8G9Dy55gzf8W6gC4nEkL3LbxCOT477HSbg5Ba2CcBStab5EERDlBhat9p9lzXmjDCubmZu
	E7KGOK/QCtp9ZW0K3tnt/MKtGV7Cm5M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757932368; a=rsa-sha256;
	cv=pass;
	b=pkttdYELNJRb4BifTpeSlJSjAbkJ98nuJCU2Lacfv89/l2jj8j4EKaz3lHBpotNVA+oVfz
	iztg3fZ7C6pZMnRhVjGbEinIUaU3cFLAYmMsVGa4MZUahlFkbF3mvU00JolwDnglC1t5+d
	rc7Hp4YDxkukXbkTsm04N59mi8eL5oE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r3Vs9pRn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q6+TDU43;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fw3N014282;
	Mon, 15 Sep 2025 10:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8gN8kd80giCBthjJGh
	IQTcTosRF/oOYZUAaPAsbcS+Q=; b=r3Vs9pRn1N7VfdE5LqRGm8Gm7ne498sEyx
	fHGdyQShclF97yaYxVMidncy9aZsLbP2+R7UgyPI43FmuLtQ7saAd3Z/NaWgRUnJ
	yCn9KV8J4dOw5ND86cJQm9PuUIdgrZs6LJm3UFttb9ivaZMi/jHBSpC+k4FDkb3h
	A02OkK0XPBvlHqOgp2ZFe8HaEunQ+OdxhYp41ZX4uJWFheRUSuyKKGc9vkwZ3+f4
	8RUp9cGztY0ZM/5H6m+3BPV8vtl/gSmUNU6eznUEOv8fQj/nQ6eLePBrLww7I1cU
	HFl/7slo2JVhWLQ83FrM4p2vapekHTNPs81ve8GbzPjSmaPlBk3g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8j3ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:32:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8k8PG021501;
	Mon, 15 Sep 2025 10:32:25 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012017.outbound.protection.outlook.com [52.101.53.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2atyd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:32:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTVpX4IHItH9sRCmbdOfAMEQqfJrIbAKNtJ+eGDxXBWY7aFizzguAlOGhx/RNfp1dXixCPIWHHILQ5k0rC2qriGP8qYj6eDOdDkqg8ZyKB7JWHm+yPvreV13Ts9lp1MLVheK8mHIBKA5iMUhMujbxQRNeUs5bdkpFhVGyuniXf+6/NIlpc0qYIfALFUdjSMiJK8LWxRHA3USgGrZSK3yf2tHgRrtbVOUhLl3Y/mBrHTOgucX4zsOnpGiiLTYhz4xWH69y4Y2SigcnYVDeoFQnx9JXA4CLO82iz0+wgEC01XYb+TDI9yijhNI9sIzchLeYOPvlM72qoGJ3ihqhNyplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gN8kd80giCBthjJGhIQTcTosRF/oOYZUAaPAsbcS+Q=;
 b=TX/aikM6gxYTXTDQM0nbMEjbecS5k8iA5Xf7y8HsisQEyWNhgBcxG+m3ktQnNkvZXfh2Z4TGmR5prDCAIhv+chm+8429dlM+1JsEoeDmP0azIMQGGtid4P7Byrbc7ec0pQjNxcA0IXDVjLsXTnYdeaYJpN3Kp/O2JPXravHNR1HgikdR6+k6HBz0nUDPH+NzyKCFEXuNTiC5y9+16SHmqRz4b/iEtkFnThxdhZCNxE3HXYcb9X9b1J8YG95/tKVzJTCpZoVQYq8Fs824mzmMzGH36qg4YnHb4PrZmTYI9wqF3zPAaxWRdLL7Y7vR9s8qrq+CPNbS6FnhMUjJtc2byQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gN8kd80giCBthjJGhIQTcTosRF/oOYZUAaPAsbcS+Q=;
 b=q6+TDU43BRQXpScqdTzCNhSPK3e7B6y4Z0/m///SxhfxWSGlGsvB9rSgBAKhLYgL4zJVY0Obu8aRVLn4Y3+d7JYMTMuGbMtI67jyp3yoKJMmwO/ugnYlCTst87GulBCJnOYfAKIz8C+/hH8NdgS/vozGP5JdAsmUa6+HD4KOKnY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:32:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:32:21 +0000
Date: Mon, 15 Sep 2025 11:32:18 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <85aa2020-5b5e-4bfc-aade-581d20aeff87@lucifer.local>
References: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
 <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
 <78d75263-e0ab-4dcd-ae97-5c5c9bb10193@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78d75263-e0ab-4dcd-ae97-5c5c9bb10193@redhat.com>
X-ClientProxiedBy: LO6P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: b61ba950-7bda-4821-9195-08ddf44326d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VZb+jFoECGRJjRMOeTyN6tB1ndTRUHxt1ojeNo5Dv5YMm+qD/LIg8IP4b44/?=
 =?us-ascii?Q?BK5HtVP/CKqK3pSfwzsxjghufzWV3+BawKEPd4j7UXGUcOTICTEKYzVIRcb8?=
 =?us-ascii?Q?Lsff4R0k7Phcnyg/hzhnYFd/cprtfvix8icOFXT3hWRDEcnkbleuxepG7vOY?=
 =?us-ascii?Q?GfcW9+/OHSgTeNl9BEhN/Zn/R1PHreJhUhO4Z1Xf+vWFF7r9yrrRCPpIVD0v?=
 =?us-ascii?Q?lrJz6Iv4KFzfBpWa55PlA7d0PpyBFKKSCG7ta5EnnMLcMbLgnlXmi6xIVOYQ?=
 =?us-ascii?Q?FmbdimlYoDSoUZ2WFzHnawHuaRH/OxHh0PcPACBxbNgG5tT941+Uky8uqJfF?=
 =?us-ascii?Q?OtswgssxNuYG87B4vBbrofaONo5uXagg6DqEYaK6VlDeEfUU/3G1yQQr7Amx?=
 =?us-ascii?Q?UqiwX2413+YtAjEsURek3dhacGCHi4yuj2de5FwpHOHOvYgyELqdgVm6Rogi?=
 =?us-ascii?Q?cvAeWdH0j6cUxFescqFASexV1FreCulQuqXcQOXl2FGb41VKSGmSZUgB9DX+?=
 =?us-ascii?Q?FX69uvvm4pNi+bv1fFuuqLpdsDYr4Uj1ZyGtJDdWv+GZYYEJshP3j1ZuLF2D?=
 =?us-ascii?Q?GRPYwTyeMTZJdVHQ9PI6jE+tjmkmM6nQQDsfVicyKGql0oCZnCAtCt8ABohN?=
 =?us-ascii?Q?pzYchU9gTuOt+Ef1mDTsiCtyUMe3HFkin5YQnP3ekn32B9MZctehGGcUtUQK?=
 =?us-ascii?Q?Fum7OFX32JKQxxrPDvuSl9plC9eYCTRQ6ec/AUVXoaSHFeyWILxa5ov9T2oB?=
 =?us-ascii?Q?WZpjIdkePqGgR8i0uyoh7tDKqBdcuMJ9l6SaoKZGbflpLrDaYhnL72kq3Z71?=
 =?us-ascii?Q?JS6Aa8afC6x+HCPQf2ouQKCi04nn4I0hqkT9n4FQn8m1Us638w6PIgSwGFlQ?=
 =?us-ascii?Q?4fj+R0SgiqwFfVMKW0E9SxbXaRqkW4GKnYpo2IYUgM3w9EuY1N3gjfQGqdIC?=
 =?us-ascii?Q?qi3Aj7jx7oHHYxcF3PpTqFNh5Q5HrGCCfX3V+VuuyRMP13OQ+VwuaX61Kyv0?=
 =?us-ascii?Q?xtVPJrWJAsnOGLUsoNERn9a1DNFIsRTMw5AaIBmgIP6DEr21zS3m4OWB0j4b?=
 =?us-ascii?Q?k7Bq4AHqyHTSZLtfUJyIMxBDeWeVXlpTGnmC8cDrX6vbmRr/CngTYzYq5LYB?=
 =?us-ascii?Q?gPwDUGuyW3WLmzxaAfZsjzvCop4Hp566ahgbugZQA8ouDPVhT5PxlSevXKI2?=
 =?us-ascii?Q?hpntVCt386N/STgrHW3Xhj8/2W7p/MwVXCUbzMH402uSoZA13LQWWpZtzXct?=
 =?us-ascii?Q?6YcFr5XsNeQmaVk1Z/rsLBD6QpuMvICJpHq6pIhTk3uliJ3ToRv6Xm848EJu?=
 =?us-ascii?Q?LfBNZp21IUqa3Cz74efUkA+EsqfApOexxfp1w4TRbwy7NCls8eL35adpWKAq?=
 =?us-ascii?Q?U0lwZZH7az/sG2VT4LmaSRkLjC/jcLglnM+vOxxtzvMHCfXGhVBfEuFGPpcH?=
 =?us-ascii?Q?6uoWskcbiD0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2ef+51x8/3zim11Gv2G+mtynfNDP/KbKuzuQLtwQ8icg3KXMcQHFsW5xdKSc?=
 =?us-ascii?Q?ZXmGfZwT/5MDbHgvXD5dNGdwO1iIpj0AR05TbVHF/WNSJfl9FrZBkgwWwqDJ?=
 =?us-ascii?Q?if1pXbKChdNwHx2xu+IkBje1qXtJ9oPc9RytLnAU5ikBf70E0djQVTze1F9C?=
 =?us-ascii?Q?XwN6a1ujRGIP3mAuUnFRdpI5oXc3Dg/6UIoZK0uiJpn7AEui6CvUGjjQa5wF?=
 =?us-ascii?Q?QavO+Etx2uSRyQH09GuujdYE7nHN8XObji9xRVFTFzcl//ZFhsQvrYDurZb5?=
 =?us-ascii?Q?D5O8uUHl2cu5IrwBibOUQnhjMId4d0tnIsYTXd3DW1B95VartNHVjFDd2JQ4?=
 =?us-ascii?Q?oDWHXJhRr/JFJ7lagHh8BdeEAajSdwJRjseMf+PBlCSkL+dPkHHDK5rNSf3Q?=
 =?us-ascii?Q?Qmc2Ayexxa872yz+RMBTbdchORZ+J27jJLhtUUj1JUeZo4mB2rNV2FuPpd3E?=
 =?us-ascii?Q?ldHjvqEn43hpDc+5SFSvjz1nDZyrz5ZIW+42+E5D79vPB1VBxeihbMCkwudf?=
 =?us-ascii?Q?/GSQ7pheO8wt7C0ZqPjTXnHJSsVS9o5hvU8e4tiIzS7o9r/zdAWEmepKuTZE?=
 =?us-ascii?Q?bq/1qcV7bQ0qzgOspYSlLYDYJ0Rnq4o2EtJSFVJ818OKEYVq69eboI5crOl+?=
 =?us-ascii?Q?QMtnq7PgA2WTkpc7b15GFWzjgUYJud2fW7l/9tbzW7CIFXkLP6AhE1bOqoOP?=
 =?us-ascii?Q?WcnRylxDerFEe/l6jHWoxJupd4xjLTJryf9xbvNJv/3E95/Liv/ydbQAlCAQ?=
 =?us-ascii?Q?/+a3y6syoLZYcYig6cn4H8vSbrLBVFj6tJbFHHWpZsHdg2PPOe29mP91c2/x?=
 =?us-ascii?Q?Gb0465p7aHduU23c/7d8sDUyuTl12hR4UBhzRSthIZ/+zauyQRvCoHqwWW5n?=
 =?us-ascii?Q?uUqFcKQMNjsqBpAAgSzRDAys17KzUegI9Lz3h1yyi4IoO5Tj926qnJinV9r3?=
 =?us-ascii?Q?kj5YWjmDp6Z4neY5PeNmAWIf4sSPcBNR9MeR4g3gEjPaAQ0IRyjdTvwbSoeQ?=
 =?us-ascii?Q?hhrbaW6qcG/hYK/p4xAa/inTHjobsNhYJ++e/rKRJgPBD5uvSEWKukUopThz?=
 =?us-ascii?Q?6AdleO918/tG8DRetEJKBiLBFqL/uDiviqEN5NisA7S6q3889XAMwm5CuLqU?=
 =?us-ascii?Q?i000XRlFZreBBAv9rFRjzhhdTpDXo/D01jPSqxabzK0pzWX5U/nYbg7c1tYZ?=
 =?us-ascii?Q?jvOWT0OILibXu16eBv1t38VnNWiHEqAQ1Fq5j4oB04SoiDEtL45/1ElB20qD?=
 =?us-ascii?Q?9BSX+GT19AODxth4bxLTSu+PVYlDVQWtsZQL/6PZAgNCtZn8DJoiIU5iGRoF?=
 =?us-ascii?Q?NgHlEW6Okx308YBAo64GGEFxBBEaFuvbyS33mzxWmcIyUr/Q8PyIu991P+Ol?=
 =?us-ascii?Q?lDUsrB10KFg3Au5IFkxXY6uSEWv1bS2VIRQlzThZvk4oqcmV2Xnt2WQ+Yywy?=
 =?us-ascii?Q?0wYDoimhZ1JMJGqQphKE6M0A1lyw63qOU4Ydf8lv+Fx2ZMfCrhOMeksnFRuV?=
 =?us-ascii?Q?gWv9P0BlAV+yoXzebMBSgFUAZy1W+96vaNSsgEmiRDaP742K/xrnyV6oe5PL?=
 =?us-ascii?Q?aNvygyRn7s/ZmLOP0pItX7hFD+hzBhX5oEqC0GiuQ2OmgegtBbMv6IJai2fP?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S2fdwHu8+SsSS6ahiUAiZAG8U0wjMaMyBtsGbMpEg1IUau41N0V1P6P0MoGfcL4MbDj1wAGDCTFYPTVLOFqD3RX9vbxiUO+JIJ7i6TunNNIoUXXHyq9MWDAb2omKzwQe6u9KyuYBuKPrzcsLKTIUuCCQZy9BdBj2TqcPXAUWbZS1FXIzA64ZBVa55iMI/YfbOY+ZPrC9NFBdD4GfUxjZ4THTdtYdnZWQrQaWt8rAQCSdOMHAqs46E30RTfVQjDpu5vO6inYrWx5nrUFjbeG6ga2OAC2OGqZimY5HdeyoiVdpoAgvC7HFKU12jiNZj7KkIsizp8/aILnypEaA6gVVZD555sY+QTDYGo3rNr9e4Kzgg/Y4ZQNGm+RjEf/CwhPm2JMfVAvFcwprmPeYgNSR/Jjw/q3o68js0XB3C+0EcMBj4dSylAVV/WiRPAqZxrtvgYD+vfwlG+/Z4G1aA1DARDtM+qbWLWIqQSICtU3PaIkxZMX+JQBPcusBiLbZGR13fH6kaZD/el8SUxnz0TuthMhgyfx2Mk1HWA/apK2DhphDh34NPn/bnYfh5CUqdnaJ92NSrcU6QH199ce4oPFsj9V0176tds3z7VsdViOlpCU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61ba950-7bda-4821-9195-08ddf44326d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:32:20.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLm+s2Lr8Vw3IbeC0JAxv4gV5WuWHlx4syNUI1wSB0cpu+/SgN1cspXVhW7iMFUXls3C8fiAVxLpDOrL4gfD1dzHM1zRN+XY/S+dAw/UH0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150098
X-Proofpoint-GUID: kqcefG39x3DYl4eri6wGku7MO59GUt6n
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c7eb3a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=uWDL0G72xWmbNFc5_3wA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: kqcefG39x3DYl4eri6wGku7MO59GUt6n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfX4ajaZ6TKoBq+
 i7hDqEk41S/224BHK7xZehQBXL/7CsAkpyIbOBeu+T9kS9X4e57d72rwgcJIT/an96PgECBY+Wf
 X+KrZqM+lMcvwC/2mMamiufV7DaLu+oAHsjje4w5KnYEva7QeALKEsixxFWybLLrWLIt4gL4DRQ
 rT6AZxr/tJVzlz2w1b7OmDj4EGPoPOa1PnT4o2REiN5J8X9oSkf8JLs/o4+9jo2AKYg+IeZuQCn
 Mj6SYcroR82/U1SNarHXn31B3g8Cm1BGYfQVp1NatMWxcizMNS1zr16/bLgGQ3ZIbxwkwhMblhK
 ldoMaJaQJw4XtfgFv3OnlAoMQ/EWe0VbmdkpH4p+688hJEEsqWZ5RZqPtADcaLPjJvgbrgmauoz
 tMa/eOtq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC1E71C000F
X-Stat-Signature: 8syt9qn6o4kzg3g1itauy74aqip3hc1o
X-Rspam-User: 
X-HE-Tag: 1757932367-967103
X-HE-Meta: U2FsdGVkX191PVxBNgDieUHXW8z+CJmlFekDtCTbIU+mNzQxyeo/IHQy1HkF86HlTXIxGfU8gn0ZnKuuTPN9PGG0zqNJ87RtZ5EKzrYI1zkt193cfsgkGTLD8a0lVM/0LnTMdK/U9B20mBnNsVN/KVZCCb4zTztbz0EEF5Kl0Kq7orHVgsaU7mDebj+dcih7tkl6dgInQAX4D/1y9xjydvoqHEk//2X0RjjuX5VFGThACEiQa/XdH/Y1Az+cqP+g4Kke+Q7Sq3I0mD74lTAfXWtLZdZ7ecN+eWVr/m+5y7YVwVdiKjWpOiYM9XpHYf2kCYZmcQYEzfF7Fof/QQgqg6F3HyPl34CpC34DHO4sDq7Ocu9CjbhAy1IIuY73PJKDc1fGWK+4S5zcRsGeUZSTiy3VBThrU1dwhiOSv5dhCwq5UV3PHMEM3iMjpr4i+GTPBkLPOogP6sl3WYtl/Cg8hu2A3fu4mha2tZ3uznQTuKrqHk9mJgC3ecwPQp4Zx5C1FQVj4u78mfuEgS/Sjjp3K1PclA2nIaLJerkQ6GN/2adePCoW2hMuJFKzlQ7Aj7qaOxkwzAHqChqkcMTwPDsRTT3CIWo+NC/c04Rnt00WTsWpTOAGos3c3kibIRQ96cmFi7vSAXEn9Zs0595Jo12fkVrHPtiuG6dEcoR84rbC3dPN3cEWo3Yb1c7SpdtTkdOi0+GQMVtESOzjssLLnbER/r4uMfq9K0Rlrf3ioo1mYry5ON/P0Zyx1y9oobmWOBCgb71Dpup85QH09e3CtJV5Lj2d4UcyVB0J+AEnOF1Jb5pmHDJFCnSuDkUyPc6GMKIn2hCOyTE8lxBwhoKG1TDvlUIHBtzOmb5y+x5Cl36erAterQQ96HNKcBvIFj4c96SJsPkve3VxBoiHbAv6z/Ot8wdJXLG80TsDXNMg8a9F2jh2zCHYcpR2HcA7t0vC/u9vYbQS1NnZHr+Peec3Bw7
 wJlIUt9G
 4iegEDwtfJVPQiC1MAft4tw8HZM2XrT6EQh2psZt/n8DRXCd+pjuv8Q5VChc5MNXcOw0pUC5ER2ISwDGwHSCTOKGgKfnRIDavHXkRE+Z7Acw/TqYS6IdqUakoc8pBn4kvQizv0uBSIo0djYoFt08z7f20bvEUT1mHeLB0hyRg3FrjYQi83DLFPtXId/HHaeu5mZtKBRRTNy9xWMdnNDLqNcVsmsv5SzaCloozy1cuUr9B+ouc8fKbkiDU+pXXFjWbWrab4sVxaAp43TXM9SRnQ1jvdDEA5IR8Pzuqe4iDx+8S/4J6qLqLkP6m5f6oS7YsVGZkatDp9g1F6+yRskf5Q4s7ZlEw2fHWnKAnQGnlUsErJRINL4ZmXCP1V7tQlrSpSJykuGt3YIj/SdwX5AMkfhXQKJye0rrkI3+TOzdGE/a6yBHgKSk0DCDtk/AgK/rdXdF1vpseTh9zcK7KWVVws6spsgupsW0EeJ+fL9m8enpm10nAguYHhH6YMw45zDTCAYrKDJbtI695oetbQJPFUd8iHThjFy+oBfeDe/dEenPgDEmuEoG4fHTuZQ1xtqttgs7l98D6jPAswZ4mXZU30656MEFXTt57RcSd2s3T/Z55Wld8+RomEnW+ytmiydKRZ86dWdlx7M2Axoysdbbqi18S1rmjkOofoJNKmlRGDs+IpY+A3lVE/wBiVS4Ad4+VPiQxWHeDGQ0f6QDjQtL9ti9ZgSaryu+AKhjrmEuOGbmj1cRdx3RQCT937g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:25:54PM +0200, David Hildenbrand wrote:
> > >
> > > I would just say "The kernel might decide to use a more conservative approach
> > > when collapsing smaller THPs" etc.
> > >
> > >
> > > Thoughts?
> >
> > Well I've sort of reviewed oppositely there :) well at least that it needs to be
> > a hell of a lot clearer (I find that comment really compressed and I just don't
> > really understand it).
>
> Right. I think these are just details we should hide from the user. And in
> particular, not over-document it so we can more easily change semantics
> later.

And when we change semantics we can't change comments?

I mean maybe we're talking across purposes here, I'm talking about code
comments, not the documentation.

I agree the documentation should not mention any of this.

>
> >
> > I guess I didn't think about people reading that and relying on it, so maybe we
> > could alternatively make that succinct.
> >
> > But I think it'd be better to say something like "mTHP collapse cannot currently
> > correctly function with half or more of the PTE entries empty, so we cap at just
> > below this level" in this case.
>
> IMHO we should just say that the value might be reduced for internal
> purposes and that this behavior might change in the future would likely be
> good enough.

Again, I assume you mean documentation rather than comments?

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo


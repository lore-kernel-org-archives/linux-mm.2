Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D57C87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0448E0002; Thu,  7 Aug 2025 01:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1870A8E0001; Thu,  7 Aug 2025 01:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0209B8E0002; Thu,  7 Aug 2025 01:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E08DD8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:31:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DBCDC07FE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:31:44 +0000 (UTC)
X-FDA: 83748839328.10.94792DC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id C8B1740003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:31:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/5PByDg";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DotrpB5Q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754544701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG6XkOQeES5DfdzD463JajzJBDc7/QXjX4fF4COL2Xo=;
	b=rvhAnMTXu3gPn2FlUTGBDdynJM7uDXuY+EB1gClCGIWAaUvjrCnOX6dLOpCGUs7HNNVS9h
	fguL1AeL7xmBwJBCoZ9GiEujAD3UCs9r0pqZK53/2QkTAdUqsj6duChhmSgCBIT2KGfHj1
	Rmax+VbXTqRZ+l0FauSq7jjGSuyn3Vk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754544701; a=rsa-sha256;
	cv=pass;
	b=LItf4Mkk+vLjDpY8eS+DPNpvZOtX+QfJW0II7VvifQyEzLigabUNBENwZu0nAYe96KwD36
	vvgCiH443TK7qZYKIm3abkWUg0SUgdv4vWtWq+LxU1BROevF0CCNfOUcWzK3Cst7e0mvmY
	755TCVmXJO/qDF9VeRZRsnKonMHm0HQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="a/5PByDg";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DotrpB5Q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5774RmBX015098;
	Thu, 7 Aug 2025 05:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lG6XkOQeES5DfdzD46
	3JajzJBDc7/QXjX4fF4COL2Xo=; b=a/5PByDgQc2Wfwh4cyGbfGq1nsDgxzD9OE
	BSKYqKLibQ4hbayCxsMtESzIA6pX02Uq7W63+ADTWqAUm/vQr73dUsLqusTES5id
	eHpncX0FUspEtqXIgAqrFwqLyLiSNPlRRP9IoDmysZfgxwk+93dkmCPFLxRjwGzJ
	hljQS0Vt9s9bJf5l4/mVcnkny/kS52bWkCqVvs0+0mUkY1CtNizFc2q5NnDngRq9
	ZZK78GE/3WBPp+RBHNYhSttMHtIBG5UhxSSPfZDiQ1EkHbz09pFMa7yFBalN6SXF
	lN/Idm0mWIZYwDIzoYYcZoXYMYS6wBBEX28QS/RtIo/58XXMwZKA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvh35wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 05:31:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5773TUx3009695;
	Thu, 7 Aug 2025 05:31:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmxr2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 05:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uh32E+aSr3/U6rP5BFK+uK1+vhObXCQTz4nvQurW7u1sKF6yLANVAF+sN06JMvSDdoIbpsIUvCjooPJegMWfswadYK9sxywUp5ou6j6gLvQxhYKGz+AWwCbWC8aC3wm76kdzJAyzTP86Hi6JF90Jz6+m/O7mbSYd+66NMv09LtHOvka+wHZmN6R6HtldizH/wXvZPwdghgyd/PZO2elBwKs7DgpMfKjuwTz+OUo8ZGxgBShPlE6h/xoZ4roJdVsU5lo7Ezyg0GkeDZXMuHhVEWg++dL0iFvaKCxk3oc/2M4Upx1obBDmaakMEvdlYWKzNKSN0o25AVjHDKSgPjbJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lG6XkOQeES5DfdzD463JajzJBDc7/QXjX4fF4COL2Xo=;
 b=pw0ZRzcK/MWbjCjfDrmqzwyrt41njBsvaWykL9BuVhbV+5+ECT7luZmCt7IkcOt04md8opjBRKh5QqAXM4fILiUFtUTxs0L6E3koz4W4lffK3KON4C1IrgRw4KqG/jS6wsb4fJ9J3d1rF3+GI38IeiSHUnVrG4rJGnQfZS1w6h5fggcCSM+2JrGgycHTe+hArRqlrU11QxyufYJhF61f+KHrS4khQVLNa14NLVVsfMTCUhZ2I2sej0oIqDxUhr/EzboFh0wohSsVe35uUdC9FadRQ7JbluhUfkfUUAeczYxIPMVCRmtykuJo2f3v+OL3jo0I/8hnPZ1ZegY5O85Erg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG6XkOQeES5DfdzD463JajzJBDc7/QXjX4fF4COL2Xo=;
 b=DotrpB5QXPhyQltkwqmmLiTcrP6/vmQm5wEovFCd8a+NcW4zYEAcAeNuWzWVB5igAOIIKb3nbz7PfFHwgohshxlo2CWNy6CHX8DNvjhuQ8uwMSMqBUtefuqU3QpHlpfoRnknoy8hdaVfBMp6APN7qnzk2YMoRdz+WxxbKCKYocc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5734.namprd10.prod.outlook.com (2603:10b6:806:23f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 05:31:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 05:31:28 +0000
Date: Thu, 7 Aug 2025 06:31:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Vlastimil Babka <vbabka@suse.cz>, SeongJae Park <sj@kernel.org>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references
 non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Message-ID: <81fedf44-83dd-4f2b-9a2b-2f3d7ba4f922@lucifer.local>
References: <202508071131.KsUs9Est-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508071131.KsUs9Est-lkp@intel.com>
X-ClientProxiedBy: FR4P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: dfddac50-a893-47a1-8dba-08ddd573a8a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ep0Ec3060T9LNJXvMl8f0x59WJEvpvoWDC3/N2nfPFO0korboSu6GfEvQGiM?=
 =?us-ascii?Q?p/XJSLtrIwjFIbpkjRKdQb9Id69GpPtuiMAf0INAUzdDPgVhB2nWvCp7x4+q?=
 =?us-ascii?Q?xVd+74G9lImEf/iJAIxoZH/AksaVb+3AOzmwUU+Q3k7LjLjFYWmIMa8N0YuB?=
 =?us-ascii?Q?5TtgIftxFUNc2yDiYOVlff11/uFoi27u6YmnbY9ErUIz5AUDn5MZ3v8r88LU?=
 =?us-ascii?Q?pdVTAoJR1Ff45P0OHLcWAh2rlGsCwXHLhqFvUZnD8znVjA+i8mc4oK118F+d?=
 =?us-ascii?Q?/JM8zGqnIWYsuK4NTbSkhG78XoSSeBhv5MODmDpGoHzH81g9zJyA0OssKBYq?=
 =?us-ascii?Q?CqN/F2bq4lVbGx4QCYdt8KEIJxBFeBlEcL1/BU7k3Bv/A7+YfcppnPc9splX?=
 =?us-ascii?Q?o2YDghMBOC5vbKb6Etz/1z+lUL3uBy3W2dmFIj+M7j8sYEL+TkGNNyYoJnrC?=
 =?us-ascii?Q?3e3q7I/q9nkjcKTg6RmbwqX6jQc11joh686a5727a9hGQXkXtRycd9cyj5yw?=
 =?us-ascii?Q?eozE1MB3AaH59kk5HVAJC0VScXzUvSBq5fRNsyO0IvuO5KVEboDH84z1i1dQ?=
 =?us-ascii?Q?YQtFUjCKxhuoJ8dABtiUrtKoj+3B0mzGTDFwVB05+TSG4wTIqREiYB7Rw2XV?=
 =?us-ascii?Q?7ivOWcbySIK09+dZoQV95hMqbmdhWlM7PtFXzLGhaEdopITYE4kqvCqRNfkd?=
 =?us-ascii?Q?kTsTKpO7yKcV//dP3rXsDNtrJIP1yPVV0pVQHBg5vy9npAqoPENL9o2giTWG?=
 =?us-ascii?Q?QDOh086nSJ6NKg+UTxF+fD6l2osIxFAwWZU9DpSHHcqjdq5QV77PW9DNA0QS?=
 =?us-ascii?Q?vzBPdSwz5026SSpnR2z5bgi3deeR0cJHOj+U2YrwgwDGoixS8oTl2oZjpTNR?=
 =?us-ascii?Q?qgcHlieuhm08AncCQWmxmecdaLb19nEgi6f9Yj0jKcaY8g3vih2W5lRbnDpM?=
 =?us-ascii?Q?/uB+rYgMwckd+2dStB1oVqw4IpWKiuKS65bIn+YvX/Cdb5LKiv00p5h/CtQz?=
 =?us-ascii?Q?s7vuAjt+vwGWH9cESNgFlx+RshnEkoT2YtDw6ukd9Y1SlvW4CXWjUO+JYOgo?=
 =?us-ascii?Q?4hku36wsj/ZSSXwIubawVyN+p/xlkC8cxPzogH5nLVEfI5B+WgbPLdASdji5?=
 =?us-ascii?Q?XucvDYyOnrBhYCkiY7q3Ll6kIwfbe2ioBDw7UIVsPFwZWIfRGxrjosRXZ+US?=
 =?us-ascii?Q?/A9KTK9DLoni0MMDCacqUJp2gb7DLuPvZmpyyZCZAh71tPwWqaIIRUNtNqVu?=
 =?us-ascii?Q?EMHXF2qzZhO9vCWfUFzQpbQgzIT6VDuF1RSq5B+yWd3mso3ihK8e3NcZFI/w?=
 =?us-ascii?Q?fR66Xn85uKOo419Zu3DXioj8xxweRYBY2chvqNaGAE07IoqIQbKXdg94Mpgx?=
 =?us-ascii?Q?fWUxp1MV8cskpHQ2abmnDfCdvgP5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lXCxGbTBKc9hcBAtbsNo/AVcySn05sEq0datCtvLFHAeIewrfko5PZJXp79l?=
 =?us-ascii?Q?d6wSa/bS9fDe8Xuc7pGAiqkoHvfGuRTiNBx/WCWIRLcui6ymXq5WFYBIbJc+?=
 =?us-ascii?Q?o6rv70lSj/QnQn4/eM+d8vSWHSRssg4Nhm0rxNBTzGIco9xXLtq2NOmbhrit?=
 =?us-ascii?Q?2UhxNcrvfzN0Ples2XT/qbw7ujLCilkdXRqN1kMgLgN7kBaR+boVxvJyTAxg?=
 =?us-ascii?Q?uS0iSaAt/MwxoHT5jVrnvjW7m/IB1akumkZ4xTKKk234LmwUCTmRc5jGuaRj?=
 =?us-ascii?Q?OxL7w9pDYmmWkDRUmdsG2MzWXQOeTkXzLkvY0V/NCeL2WfhXjB6MceVWz6eq?=
 =?us-ascii?Q?987mNLvlrf6ngoReaWW+eXc26b9/XtnUev8JC9tYxqBI/fhUkqV2Imaeyn9U?=
 =?us-ascii?Q?t2LZ70yITCRkJMW7DWe/OvCzeq4/AYewdRtUYnhvxKlGvMQr3kgVbj7mICOO?=
 =?us-ascii?Q?VRM6aC1trJHI+5GC0ysRSlGHUoIp+cz6Ux/S/TSzLRFzrxSzWrZ0SEvBaLPR?=
 =?us-ascii?Q?vexF4pqScyi9guXlQpWey3eWWv+6auw8pGmDKK2klkFJ/HtvJTK4sq0S8uYE?=
 =?us-ascii?Q?BjuSuVMl+i3FQ/EwyC6OdBLD4JWGqOXd+NvorZt59BStbp8UlmQbbbodGSvK?=
 =?us-ascii?Q?4PlJwgja6T/dmINQirhHas6NGjt2snkOQwI1uU+EynzQu8CmLqHevhj/Pos0?=
 =?us-ascii?Q?wpI5P+hmApM7mxuouwuuJouik9AwNANL2APdAZTDkdZ/9S3cbaQvTYTVJjNT?=
 =?us-ascii?Q?WauQL0vync8J6/caiea0R2vJY7wZRwiv132QWVmX4R1xsFFISpPnTSNWsOt3?=
 =?us-ascii?Q?9ksSaBDS3Kuw0IvUiAcxtw1Jkn7t7O97IfInelu9qq0W43FCxO0pKNvdLKFw?=
 =?us-ascii?Q?nZ93PpV2sC29kCAvpe1Q7APbsbbRs30tbufRHEYx/ILgcKA14YJkwlfE8EEb?=
 =?us-ascii?Q?b/ZuW/v4lw4hKwUGNp+pUfCkTrVEhW/VwIr3SPD3/kN1xdyY5z4Sphk9sqeN?=
 =?us-ascii?Q?HmsUhSusuWTUW+P/Np39a6wmmp0b8sdnQOzgbVi6zKcdhNAaM8JIMWgCPFu0?=
 =?us-ascii?Q?Ebtkcle+ruADdAw2ZwVd3qyvb+yRY8BPSsDG2F0fsYsPoNryiU1YSdeiMTBK?=
 =?us-ascii?Q?E77o6I3PdPKKw/HsSAqFmLO33PIGgUyMqCA5Zk1++5NYO//7H6pihfXBiNPq?=
 =?us-ascii?Q?pUBah7f9qGkchP/JQMoYWhra+4s201lneJEvmwXkkBhDUs5fDvB4PgYl7Yl/?=
 =?us-ascii?Q?ylf2/ZvoNlDO6MtQKM9ccN12C3WM/3mEoZT/V9yV9n+2Dcmzm00EW7QHQTBK?=
 =?us-ascii?Q?wfE+pNqvLMD5GTXZCAjIGAQU5BPKf/2q/pFcon1eY6pZNPz9wR7L3Tl3r69a?=
 =?us-ascii?Q?qoH93hfSzHWCad5Wkn+gSsaKSQ5TAcg/Bk8CJgUl4SqdHxDuhJF9Oa5m8c60?=
 =?us-ascii?Q?G3pZ2eAP/aGLmx+4OCtJThdlgni+dPTzfQba3Ti5hF+VMXkD1rdwiaUiSpV1?=
 =?us-ascii?Q?+YH7fCvzbhsyTn/qMLoWNV5AWYjNcpajHI9EAWTlOnr3dI8VYe/+fZmrI83d?=
 =?us-ascii?Q?RUrta6LB0TJymC3UloyOrLy1/+2YrIlmHLea3ysQkOx4H7NZ5y+SoyezbkAW?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sWVSpuqccF9m69ELGRCEG2ylxifqnlBQ8EeMdJ3jseHILth6pbxUuLFa3K0/+OmZRtBeJ94Jo8GEudtgviHmhI4S2tmoGkkYxzf9FMrU9eYtLSvZ1HR6LRtLCXi6GvrX1TtROo69J70Dy2kxvqMYQGwUkZvYTIInnsnnDQKrmdkj2oIGKhvPaVwKxqoAy9nT9CYJzh0c8x84o47L2bpzpU0AZw3ZHa9vuqJLWx1D+7iJdtFK7Jkwu8n7ZMS5mLpPkL/yE5UmATvtnu92CsXnAZKsCskypIk82lNz0AeH01O6ScHjt7hdYscRf9QucSBk99jt2lZLPkra4LZRt0xscqsrgGD4zdgL4LHCmvl0STfV3QrGTGFvOpcZOdgISlXcpMaWjP4hRv3tmTEAQ7k+6CmCM76BCkypmRO/3efsf246aVeT5g6KTdJk9T44rPg9XW4KrKoTwWj0SYgpjfoe3lq9jw0Bp7iWDd0HsmnBERz9slaY0aL/alQNuQkoAa88TOhtojmnLUr4X2idSFpSKYFmx1unDugCOQZp6VkEKfCgr/D8mnxvpZWLIQbjP5y0DqpVj7ZjYsd3PMjp+jydVkDBefNParK+YZQ65goZLn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfddac50-a893-47a1-8dba-08ddd573a8a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 05:31:28.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/XG+HemeY9H3lmOmXvW9wdQYwNTbgsTjA8RMBJG+6yfmzJSv823SDpvr9kHfjm00EV6oTVdN3LiCkc1kMgR7/+ngModVQmEXMWLfp8/gAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5734
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDA0MCBTYWx0ZWRfX7VWplYZsgEP8
 xq1MGRL3QaBQezd823Ys+A2e+qmq+G2DVoe1H17JH8f2M10Hq9dVI3d+PWYVr8pAZFAXJWGc73m
 pKkDDw8jadWva2oqqyfVE6FvnfFfKJl8gkry3CzQ7npZHlBurlK09ECZG5XQAS1FAVBcWfnj77v
 1oPj4ZvXiZ02hZmJLLOE+f70++C7bwCh2trJgE/IvwR/VivGGbsvZ4Ml+hzNoEa5pxX+mOAdcND
 lsDmTbWphBaevvXWtxPjbJmEX3Q9dyASwto4ABWjX3756UR0j6+voVPTlqmUT06SODnqSZWsswC
 BQpdDtVJtuxqHSdxBTCfZeYcEH5yfzmIvJApPls64loO6oWEsBFZOzsqp1ZkrRr0y4kHUmaXDTF
 gnq9naJ5VG9YMa4ngEY7MoED7wyQz+6COARaDKn3uzOKydh7cq9F5GMDXEbuAOQF6Ost3r7k
X-Proofpoint-ORIG-GUID: uQAXxsJj64Q7YnS0shfQZerOViCrL0Ml
X-Proofpoint-GUID: uQAXxsJj64Q7YnS0shfQZerOViCrL0Ml
X-Authority-Analysis: v=2.4 cv=Hpl2G1TS c=1 sm=1 tr=0 ts=68943a35 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=ik9_UjBTgHGiPymc-9QA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Rspamd-Queue-Id: C8B1740003
X-Stat-Signature: iazz7rc8j9ee411t8e1w5rrc4mry16ga
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754544700-798192
X-HE-Meta: U2FsdGVkX1/5swV4oCQAuizE68DQLFpucC+71eIlpMycfso4nB1mCOpCX1nDajykQ7+CDopghi18sDOgdGU4XJLjUSDMc++lR8Ih0ll+f4tSPXpryc4qeLslPK4i8hpFd+JRmiVPEXE7eZ7OfftbVkaaiZYYWn9wTjaDWPCJUCPZFNsW9ghQkxW6KYNojSeojZ00H8+mYuvsxTeaP2Y7jsPg75ak+i+Ue0q5n+dJdgxAQQI72/9WMEmHYEqIu/Zc3E64vLmOsRDi2P1TdhaIpVNduHLKpcAa3qraVDAGj+XaIhtrZUoCE3qBZsQsNBuvSbm5iFcCPVJrCKCLRBTMgm4mDHl7ruHhT1AvLbEC+5GPrpL03AoSTCQGKzrtiGisJ8bzMdze1PG4eWy7uHCjmDVpJAXelHF6mMmjNlNa5WcVUqBfyfnsCJXgmZRd0qkO7WrOKkTjFL5uFNS2Auz3kThEJWT7XuHVpM8eWNbO0cFzeD+11jaeBJbU4+mTQ7/wZHDwh3LWK9pkcvsHKso59WRGCXQvjTIOkZcAXvgrYQB6A7pqomy3Cvx+5m8odwAaNhzB4HC1a7G9CMf1idTsFkeHE5snKjakiyW63CaGCyOd/PGEjz+072nuLaVeAwN+V2IYIyG211zSegI6WdLNJtdpdDdnzpOMX+0B8ME55gNd+V8p2BRaUzV9KnKCdG7iWayVRcmhG4eALxGBU5BeDp6vpoOvGBAFc8FmiX0nrTfBCcFlZR/O9eQ3b4UxGgKdRuUXg2fQAeqSpRlE1F7e5eEmzzRfVC94MvoVsLEZFMKR2rOYXm/QKa/ZXubuNlYiTPDsuhzVwAY/gizT5YyvOvLG6E7uCYZyNfVidiL1e1PNhAxkkLJcFGwn2IKZk5Ej6SSIBtnkTQnQ/LL3NnVR9aRO8Io6h58rvlnI+psun8u2DSVN9MSJvh4nfGqIo94kAq5+F+yPItibT0y+1p6
 AvUOIRxf
 7CQ4hlZIQJCvwapK+JZ6oPDsWpKaSbu3oJkUL9vGsrnia8iW+TFE6iWZ7g2jcmmTG2kUCdk8XfGFyJY6bfnvTB8hvH7V2xzCeZsX65Fx+W6X5LMO3ArD5nupE9GAtaXPxE01drplJKIQuazNJ2XOcbtSELSX0ggnKqUl5iKjNz2oIWciEGpW8plV8mBpcORZn85+djEcaTiZMmFMlpvISdoZN/Lv4OLSei8AqacTZd6vNFeNTsZLcC2wcfIWzD4W0WzJv/QfryG6KVuhpnTGGYaU4pe3nwef5nefXuSCNM+0K1fDn+HY5eYv7yqZpwqizZfzFoqSZqEsrean4Fw9O2V2PvgV+vlLhVrh340SB7U4TBIhgkcJwLf+EuGT1GteiiwclZfz3GhXL1ha85qSjgmpyuRVTp+SRjtz751Bn8UyOxw31zDrdhSicG6HdSqTWPn+Jkwt6XkdDvsNur7kFNJRGnkJMCgRQJoHY2hpI8QJiUHGkXz7ZtjbT3rEkapADc3OOfVYwGcW5ChZLZw24nKtRhkYOaCfenHMXirM3BckSeBue56Z9vlAfo/aL8s7oucFLRAhSzHiIXMJBmkuqcgRqNSvg/2NsSIosgaGdsSB9KUa1dp1xgiK7cSEB/CMmkBYnA0CTYqNqJpH697ekOcTt6vrqTE4iGiJwemWvyMoR2g7e0wsH4CfHRmPiGg+S68ZuWuP4dEJAHaN+bb44NA1gIKA4Q8wigVWlP6iXC/skJptRjFGxxVz90EpzG+UJCfjiN3dDQsBuDKlKMZcOjzHpBYfqVdOJop6/n9bkstFhbuD5fPJuI/dvEX574UmlhpAMS+k98L4/oUVYrAKx6CoPkFthoBx3Lyn5nZspaoya2K58W3/EBtjqFtr2e1TVKkaJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc SJ, as his tree :)

On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new

Not sure why SJ isn't cc'd when it's his tree?

Not sure how easy it would be for the scripts to figure this out.

> head:   b2a4beca30ba51331a16d7bb84387a70b692a66d
> commit: 607a455e2f3d528b71be200e1e18e578273a602e [42/45] mm: change vma_start_read() to drop RCU lock on failure
> config: riscv-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508071131.KsUs9Est-lkp@intel.com/config)
> compiler: riscv32-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508071131.KsUs9Est-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508071131.KsUs9Est-lkp@intel.com/
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):

Looks like a build error that's nothing to do with this commit.

>
> WARNING: modpost: vmlinux: section mismatch in reference: node_get+0x3a (section: .text.node_get) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x30 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x110 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: qrtr_ns_worker+0x312 (section: .text.qrtr_ns_worker) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: qrtr_tun_open+0xe (section: .text.qrtr_tun_open) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xdp_put_umem+0x54 (section: .text.xdp_put_umem) -> soc_bus_register (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xdp_put_umem+0x68 (section: .text.xdp_put_umem) -> register_cpufreq_notifier (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x1c (section: .text.xdp_umem_create) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x244 (section: .text.xdp_umem_create) -> register_cpufreq_notifier (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xdp_umem_create+0x25a (section: .text.xdp_umem_create) -> soc_bus_register (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xskq_create+0xe (section: .text.xskq_create) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xp_dma_map+0x5c (section: .text.xp_dma_map) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: ida_alloc_range+0x98 (section: .text.ida_alloc_range) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: ida_alloc_range+0x316 (section: .text.ida_alloc_range) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kset_create_and_add+0x10 (section: .text.kset_create_and_add) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_create_and_add+0xe (section: .text.kobject_create_and_add) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: uevent_net_init+0xe (section: .text.uevent_net_init) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x72 (section: .text.kobject_uevent_env) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x324 (section: .text.kobject_uevent_env) -> .LVL169 (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x32c (section: .text.kobject_uevent_env) -> .LVL171 (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_uevent_env+0x360 (section: .text.kobject_uevent_env) -> .LVL170 (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: kobject_synth_uevent+0x106 (section: .text.kobject_synth_uevent) -> wm8994_i2c_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x1a (section: .text.mas_get_slot) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x22 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x3a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x50 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x60 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x6a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x74 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x80 (section: .text.mas_get_slot) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0x9a (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xb8 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xc0 (section: .text.mas_get_slot) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_get_slot+0xd4 (section: .text.mas_get_slot) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_empty_area_rev+0xf2 (section: .text.mas_empty_area_rev) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x156 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x1a2 (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x230 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x238 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x240 (section: .text.mt_validate) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x30c (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x314 (section: .text.mt_validate) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x65e (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6bc (section: .text.mt_validate) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mt_validate+0x6d0 (section: .text.mt_validate) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x4ae (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x4c6 (section: .text.mas_spanning_rebalance) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x586 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x590 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x852 (section: .text.mas_spanning_rebalance) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x87c (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x916 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0x968 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xa3e (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xa46 (section: .text.mas_spanning_rebalance) -> bh1770_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xaa2 (section: .text.mas_spanning_rebalance) -> bh1770_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_spanning_rebalance+0xaa6 (section: .text.mas_spanning_rebalance) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_spanning_store.isra.63+0x15c (section: .text.mas_wr_spanning_store.isra.63) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_spanning_store.isra.63+0x2a2 (section: .text.mas_wr_spanning_store.isra.63) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x46 (section: .text.mas_wr_bnode) -> apds990x_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: mas_wr_bnode+0x60e (section: .text.mas_wr_bnode) -> apds990x_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: seq_buf_path+0x44 (section: .text.seq_buf_path) -> wcd934x_slim_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: number+0x76 (section: .text.number) -> tps6594_pfsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: number+0x98 (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: number+0x9c (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: number+0xa2 (section: .text.number) -> virtio_nsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: number+0xbc (section: .text.number) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0xd0 (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0xda (section: .text.resource_string.isra.12) -> virtio_nsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x158 (section: .text.resource_string.isra.12) -> virtio_nsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x1ce (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x252 (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x2bc (section: .text.resource_string.isra.12) -> tps6594_pfsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: resource_string.isra.12+0x2ec (section: .text.resource_string.isra.12) -> virtio_nsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: clock.isra.14+0x28 (section: .text.clock.isra.14) -> virtio_nsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x46 (section: .text.dentry_name) -> tps6594_pfsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x70 (section: .text.dentry_name) -> virtio_nsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x1d4 (section: .text.dentry_name) -> virtio_nsm_driver_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: dentry_name+0x21e (section: .text.dentry_name) -> virtio_nsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: pointer+0x8a (section: .text.pointer) -> virtio_nsm_driver_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xas_store+0xa4 (section: .text.xas_store) -> pm860x_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xas_store+0x5be (section: .text.xas_store) -> pm860x_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_alloc_cyclic+0x9e (section: .text.__xa_alloc_cyclic) -> pm860x_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x16 (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x3e (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x46 (section: .text.__xa_insert) -> pm860x_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x54 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x62 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x7a (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x84 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x90 (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __xa_insert+0x9a (section: .text.__xa_insert) -> pm800_i2c_init (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xa_extract+0x564 (section: .text.xa_extract) -> pm860x_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x38 (section: .text.xa_load) -> pm860x_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x3c (section: .text.xa_load) -> pm860x_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0x4e (section: .text.xa_load) -> pm800_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: xa_load+0xaa (section: .text.xa_load) -> pm800_i2c_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x0 (section: .init.text.efi_parse_options) -> stmpe_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: __efistub_.L0 +0x4 (section: .init.text.efi_parse_options) -> stmpe_exit (section: .exit.text)
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1584 (section: __ex_table) -> 0x0 (section: .rodata.spk_ttyio_synth_probe.str1.4)
> >> ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1588 (section: __ex_table) -> 0x0 (section: .rodata.spk_synth_is_alive_restart.str1.4)
> >> ERROR: modpost: __ex_table+0x1588 references non-executable section '.rodata.spk_synth_is_alive_restart.str1.4'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1590 (section: __ex_table) -> 0x0 (section: .rodata.spk_set_num_var)
> >> ERROR: modpost: __ex_table+0x1590 references non-executable section '.rodata.spk_set_num_var'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1594 (section: __ex_table) -> 0x0 (section: .rodata.spk_get_var.str1.4)
> >> ERROR: modpost: __ex_table+0x1594 references non-executable section '.rodata.spk_get_var.str1.4'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x159c (section: __ex_table) -> __func__ (section: .rodata.__func__.53540)
> ERROR: modpost: __ex_table+0x159c references non-executable section '.rodata.__func__.53540'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15a0 (section: __ex_table) -> 0x0 (section: .rodata.spk_get_var.str1.4)
> ERROR: modpost: __ex_table+0x15a0 references non-executable section '.rodata.spk_get_var.str1.4'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15a8 (section: __ex_table) -> .LASF4598 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15a8 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15ac (section: __ex_table) -> .LASF4600 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15ac references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15b4 (section: __ex_table) -> .LASF4602 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15b4 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15b8 (section: __ex_table) -> .LASF4604 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15b8 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15c0 (section: __ex_table) -> .LASF4606 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15c0 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15c4 (section: __ex_table) -> .LASF4608 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15c4 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15cc (section: __ex_table) -> .LASF4610 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15cc references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15d0 (section: __ex_table) -> .LASF4608 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15d0 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15d8 (section: __ex_table) -> .LASF4613 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15d8 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x15dc (section: __ex_table) -> .LASF4608 (section: .debug_str)
> ERROR: modpost: __ex_table+0x15dc references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1668 (section: __ex_table) -> .LASF762 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1668 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x166c (section: __ex_table) -> .LASF764 (section: .debug_str)
> ERROR: modpost: __ex_table+0x166c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1674 (section: __ex_table) -> .LASF766 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1674 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1678 (section: __ex_table) -> .LASF768 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1678 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1680 (section: __ex_table) -> .LASF770 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1680 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1684 (section: __ex_table) -> .LASF772 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1684 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x168c (section: __ex_table) -> .LASF774 (section: .debug_str)
> ERROR: modpost: __ex_table+0x168c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1690 (section: __ex_table) -> .LASF768 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1690 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1698 (section: __ex_table) -> .LASF777 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1698 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x169c (section: __ex_table) -> .LASF768 (section: .debug_str)
> ERROR: modpost: __ex_table+0x169c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16a4 (section: __ex_table) -> .LASF780 (section: .debug_str)
> ERROR: modpost: __ex_table+0x16a4 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16a8 (section: __ex_table) -> .LASF782 (section: .debug_str)
> ERROR: modpost: __ex_table+0x16a8 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16b0 (section: __ex_table) -> printk_trace (section: .data.rel.local.printk_trace)
> ERROR: modpost: __ex_table+0x16b0 references non-executable section '.data.rel.local.printk_trace'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16b4 (section: __ex_table) -> trace_die_notifier (section: .data.rel.local.trace_die_notifier)
> ERROR: modpost: __ex_table+0x16b4 references non-executable section '.data.rel.local.trace_die_notifier'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16bc (section: __ex_table) -> trace_panic_notifier (section: .data.rel.local.trace_panic_notifier)
> ERROR: modpost: __ex_table+0x16bc references non-executable section '.data.rel.local.trace_panic_notifier'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x16c0 (section: __ex_table) -> tracepoint_printk_mutex (section: .data.rel.local.tracepoint_printk_mutex)
> ERROR: modpost: __ex_table+0x16c0 references non-executable section '.data.rel.local.tracepoint_printk_mutex'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x180c (section: __ex_table) -> .LASF3916 (section: .debug_str)
> ERROR: modpost: __ex_table+0x180c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1818 (section: __ex_table) -> .LASF3917 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1818 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1824 (section: __ex_table) -> .LLST172 (section: .debug_loc)
> ERROR: modpost: __ex_table+0x1824 references non-executable section '.debug_loc'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1848 (section: __ex_table) -> .LASF3922 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1848 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1854 (section: __ex_table) -> .LLST161 (section: .debug_loc)
> ERROR: modpost: __ex_table+0x1854 references non-executable section '.debug_loc'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1858 (section: __ex_table) -> .LASF3923 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1858 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1860 (section: __ex_table) -> .LASF78 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1860 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1864 (section: __ex_table) -> .LASF80 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1864 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x186c (section: __ex_table) -> .LASF82 (section: .debug_str)
> ERROR: modpost: __ex_table+0x186c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1870 (section: __ex_table) -> .LASF84 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1870 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1878 (section: __ex_table) -> .LASF86 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1878 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x187c (section: __ex_table) -> .LASF88 (section: .debug_str)
> ERROR: modpost: __ex_table+0x187c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1884 (section: __ex_table) -> .LASF90 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1884 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1888 (section: __ex_table) -> .LASF92 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1888 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1890 (section: __ex_table) -> .LASF94 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1890 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x1894 (section: __ex_table) -> .LASF96 (section: .debug_str)
> ERROR: modpost: __ex_table+0x1894 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x189c (section: __ex_table) -> .LASF98 (section: .debug_str)
> ERROR: modpost: __ex_table+0x189c references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x18a0 (section: __ex_table) -> .LASF100 (section: .debug_str)
> ERROR: modpost: __ex_table+0x18a0 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x18a8 (section: __ex_table) -> .LASF102 (section: .debug_str)
> ERROR: modpost: __ex_table+0x18a8 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x18ac (section: __ex_table) -> .LASF104 (section: .debug_str)
> ERROR: modpost: __ex_table+0x18ac references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x18b4 (section: __ex_table) -> .LASF106 (section: .debug_str)
> ERROR: modpost: __ex_table+0x18b4 references non-executable section '.debug_str'
> WARNING: modpost: vmlinux: section mismatch in reference: 0x18b8 (section: __ex_table) -> .LASF104 (section: .debug_str)
> ERROR: modpost: __ex_table+0x18b8 references non-executable section '.debug_str'
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


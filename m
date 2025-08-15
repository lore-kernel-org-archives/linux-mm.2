Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACF5CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F1A8E01E6; Fri, 15 Aug 2025 06:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E90D8E0002; Fri, 15 Aug 2025 06:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889E28E01E6; Fri, 15 Aug 2025 06:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 740118E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:04:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 168A45BBD2
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:04:25 +0000 (UTC)
X-FDA: 83778556890.05.E9BDB19
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8B6DE16000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:04:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YD9N7YdI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BQcjplDD;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gzk/xAmQaxZbZ9HOuMo+QRtHRseRkJXyliS924QWtRY=;
	b=oJI332bO0LJvFCkhCvl8eoD07a/UTfkb5ZwU7zke7mBrcdhQtVBw8tX3gau2D2ZoK3iNe2
	MT5QJ8rsnpX8uKfEB1bSwbThPBwRCoKUMTm5bX1P6EZWM0nAftTVmeYOXEbiZbtWBU2k10
	vmoaoNfQ6Hhvg27dmfieJy1ZKpNV8Y4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YD9N7YdI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BQcjplDD;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755252261; a=rsa-sha256;
	cv=pass;
	b=aL0B/IHycrVjHBmeLluYGLB/zsJkyJsNDFVQncigSHUSWEnrkvyoCeKk4FJlYuHrr0x2fv
	1x3rC3PBZKMXjMurfzyZRMnQK4p1USzI/LKqaB6k82zhlRf7LELuknMdXt+0PbmYzwXzGa
	Jxqcsadx8eUxsg+6f1CztVz/+hMsw+4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8g6Yj028558;
	Fri, 15 Aug 2025 10:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gzk/xAmQaxZbZ9HOuM
	o+QRtHRseRkJXyliS924QWtRY=; b=YD9N7YdI/Cu967IjoXHVjtY0etqZ/Of6S2
	fobJXLFYhQrZ5VRzMeHASD8W3dlFzz6SAYWMgk1ztV037MNrLTU5xfgF1J8t0JOk
	8/40TenXYbYlRlVsttOenTsbCXLZYg6xPQPmBnfmPx9BO1bs5Tvq4KPx7CPA+4qs
	6o26JuByAwxTNjuC3WRtwHB4BaiKt7SFfaPPjTZps0bn5Ru8qvrpnCu14yPgAYTf
	R3HQl22fR21BNcJxqLCknJJ0i5XeeolN+HNb1U1uiBbMnRWJOAQsbj/ypRC46cbc
	oIPYggvIw2d5UJ4hHC34LS2Z0Om99GE3nlCje7vRM9YlWht3tFmg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4kqv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:04:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F9LFLI030087;
	Fri, 15 Aug 2025 10:04:18 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdu16d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thEDszkheqg7MAWU2RGquos8BYYJllFVWNZw7eH3d0cNEOpz9jNl3WO23njvlAxcW1DYigRM0SucDwTKXhvl6t1APOPRjFhCo6Wmm7XZHOIBkS9GKITc+SoV8QkT5Try/0ORHeBgUQNkWTn2TK51samsMknMlAW9fK0r2iwOtmCRH9BFdS81i3aVsJHuDyql9ehCg8a1PSFJqxN45ZcKQ/hsFrkqVZGZid673RDH1tHqWdmwaA1MWkgTkFf7FQ5sqkygdmrdPhkCG9Udy797bqLrRgMK0tg8FfZPYkHiVm18f7FdhSKff/fEMAOZGQtBiFCJhscQaE/bjTnusHvlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gzk/xAmQaxZbZ9HOuMo+QRtHRseRkJXyliS924QWtRY=;
 b=ZXUNnNyACeAULzmXzRO6/H9GsqYaVPhdIzfDfngf4G2J/dFXxcXczUsxGkdOfami1QP/Vgs1p0dhZiehxPiIa6wb9H2Uv+rxM/nD4LT/eHMLA2qe8bR0GhfxDTsK67W5MzRDt7DxRFObwFLyK4FVYDVtlJuxRFEHnvm1BNosM4xl2/ISXzr1QAODk5ze4Xf9OZE74+mx4sUtn8BTAj6tZngDX+m9m3aD/ohgYhGtenuYbO271fiyaYxyLwXJg96KxP37TfwFga2jE0uY1ZcOvN2kLt7ohhO9QrqNFxTIoOF4kYebAvbr5WiTcqnD6nt8JVym0b8jlC1mwAteCITrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gzk/xAmQaxZbZ9HOuMo+QRtHRseRkJXyliS924QWtRY=;
 b=BQcjplDDABiM6AigY6NxdIPYWyos33PMpaCBUiYDCIiVk07OJhtqlAkdjGsr6Gv1y5GgyuhQPEpsW545zB5tgZgyvDLoe5phKf1i6NlnZgcI++2tr8xfDhVpeAxh4oaoTLB1yepkohhI7OkbNTw1sYxmyEwVEX5IWFIvFwuQtmw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF424CCE606.namprd10.prod.outlook.com (2603:10b6:f:fc00::c23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 10:04:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 10:04:14 +0000
Date: Fri, 15 Aug 2025 11:04:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/rmap: use folio_large_nr_pages() when we are sure
 it is a large folio
Message-ID: <245ab6e8-7c63-48aa-b859-9f1fa2bae2f0@lucifer.local>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-4-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815084943.23063-4-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0030.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF424CCE606:EE_
X-MS-Office365-Filtering-Correlation-Id: 23110b49-c868-400e-6f26-08dddbe316c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LUoC+n9SBdp04bHXfGeZ4U5KRmoD5EHUmIfBjhO9jkMMrMJuarpXRuroegqq?=
 =?us-ascii?Q?gj9Q2XSfllk/Mjv3xOupRKLg/h3TpcnKil3bBnlepP1nyFqYnlYNXlaety5v?=
 =?us-ascii?Q?di3AlaEHaPMyZBzorpR3qJ7mkrZTolS+jqPq52AEPa8nZONx4KhlR+hm3VJh?=
 =?us-ascii?Q?XxqzUz9kVmRWdUXT5xPJqK5JYknARBdL/BUVablXdG3rhPvducm0M+OLUfQ4?=
 =?us-ascii?Q?Kd1KRgO7Ok1lA98vLuCzsewfgfQb3vh0mcsD/fkT7qAujOkZBRxIaLgqHXdo?=
 =?us-ascii?Q?P8ScWnc678/YDf0IzY+9UHAkaNekSJuzTvlIA/jcDS6CzGfA+9sR6OQ5hsrD?=
 =?us-ascii?Q?91vU2slIhu7aWIpjlgCi5mDDzJ3odajFtJ6NnX7wQPnjTDGbwEd1JybaA5ws?=
 =?us-ascii?Q?yzXTjd0rbf8KDtDszlSHT3VZiLRBWM29LCJHMtk7pT2TQn6QE0ace1GGBtI3?=
 =?us-ascii?Q?44XN2yJk9ingxS64YU9Q3ms9vmSPGbOnKq1aecZpn9YgkvjggdaJaiovGBRR?=
 =?us-ascii?Q?/Gy0/nVHzzOt1bhH1Y1hITmNowWeNuyAsbFo6HM7z5cHLDYUuXLfm3tISM3d?=
 =?us-ascii?Q?J4EDzcAJkBpUh/OlkOBJmHY64pKWFw5ogty4MKqnKfy6xgnJ4w6PV5+k/kPN?=
 =?us-ascii?Q?vem2TDGvXsSbf3K7Jiv7ld4ns0tYOh2mvQ3T2xr2PRUXXwMQYdq3dQYT6Gk3?=
 =?us-ascii?Q?VW6TehyoJNMe5+AQLZWpEX+B7QFYTyeIe52RAQBHsRkbvPGYDVImss76PV7r?=
 =?us-ascii?Q?DvGNyf/HnTqvwCUfXL4BIDy64TwN5I7O+AEOwrN/k3cc5Mk7Rsz4IXcFcsNO?=
 =?us-ascii?Q?kbwNVFuNoTWfiWCT/ghkgzEl2aoOzvQBdc71d3PzHkg2n2u7P4y3YaFvpt8h?=
 =?us-ascii?Q?9vfKIS09vn7zskoehUduwPOm/UQ490AENEtXWg5zp8EwxC7mqAZzeCtuNd2Q?=
 =?us-ascii?Q?JifYT5Wbn3OBuM3lWGNjUcFyLcp2RagC/DJHrVFWt8BVFIsHa02epUz3ZnxU?=
 =?us-ascii?Q?VeCCoKesAD3zuuBn7itimpgZ1wgEWeKhebClC6uNwYyRWo9/Jk0KVLwqNcRM?=
 =?us-ascii?Q?GteOGV1kTyDKo7VurU8JhTWpiDZOILyA6JUoCkRVbQ19jsrDVQMWzCyg7lO5?=
 =?us-ascii?Q?giB0TRgRfclO7M6Tv9qk+ykO3c9Gs2jLO6xRaPB3mHQkn+TY6Rj5dkxoYCGi?=
 =?us-ascii?Q?WanIlZL0wKN465orO28JFgYIlsPK9+Xl4QXF7j1mN68W1Phax52W6mOyhezm?=
 =?us-ascii?Q?VKRkECaTSnrrUWuPvHD6y1BOc7eKSmSnYbpgQOEu7X85iuyE6cDYRButcNK2?=
 =?us-ascii?Q?2ORMW53tjbCW6oMtupeaFJ2lGhK+zn7hQmJjwB4rfo3vJNGstRqPPOjBvNuL?=
 =?us-ascii?Q?QgXdWUNLLBfVNrJ9ohIY1DhRSPzj9AKd/yy/zdBB5g/D/sPbiRZQQg2XWRzl?=
 =?us-ascii?Q?aty2155Be98=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NkDS5YEliUf5/BxFbQkVSX/kTRWER6b3zlBvDdv23fPF8jpqyQySldaaARAy?=
 =?us-ascii?Q?CVWgSYVXNZAbPynYF/5Ar4hgOtjOAA31plRSadl7hlm2S9mTzJ15b3KwUsk3?=
 =?us-ascii?Q?i5GVbT6dmym1MewJCryuU5CpB6jsdMP4RHqtPQYALSGIRv5wfLRKVfWKxYfr?=
 =?us-ascii?Q?VpuI9nnK24bFt6XFLKb9GwHKZZ4Iz9lBqXeUm/kuL7wv07ICWdK3pddYetC6?=
 =?us-ascii?Q?RDrDhyD2Bf+kKqZKEB9DcUbwZczlvbWGh7mMSZ9FKdNGvJG0I1JEtDkQ1vYG?=
 =?us-ascii?Q?KJbFGJN+BsOZmsWEG5v11HnoHHNyvE8QLsCd/8DjRuZ5HNrVtuDSMWPqJd1B?=
 =?us-ascii?Q?CO9ekEgT4+1bsZ7PQRYbTNhsDyhYAE9hiFVD0rxPnI3CS9ij90DNCTlOhjhF?=
 =?us-ascii?Q?plXU3sakJi04N6H6VuixDQCDEnyrM4jAcE6utiQzH4xxGYMLUHHbL8+xkEm/?=
 =?us-ascii?Q?Qvc/fZgWOVXCy1dZgOmTDcEaLV/sVNNAGqgB0yz8Y+Ayzqv/gxr589PwHcSe?=
 =?us-ascii?Q?lR+3EpQ00sb17NSL4nWd9Xzm88zg8abShgjRr1ObivwMVUnp9PH7dIXX8cZ9?=
 =?us-ascii?Q?RlhyWtZomu/2KaIxiaNy/1d22UKdoae6j0/d7FrS11l2tJybHsFRg+wbT3aj?=
 =?us-ascii?Q?FaWsTgZ7m1D6x/JjxYNfrdC/1PBwSEl06C4Jrzw3Q9TRJbUzYBmGiPUz+SBW?=
 =?us-ascii?Q?0HHx0Svh2RY6RoTfOCpYcgQg6c3UWdeD3UMW4ODEPKxwKFlJWdbu7C9d9a+g?=
 =?us-ascii?Q?48pb3ccn6de2nfKSVsm0VBVhbV6WdFKnrMGfaUDg0rqqu7oIcI6WFUAXj8np?=
 =?us-ascii?Q?VFE0yPWJgjgdkf8tjgMP+Iz38AmL5DYQI8y5QJLKgI83tOQKDEzh9gT3IWQe?=
 =?us-ascii?Q?J7k/okaCCYKmbQIEOTIAOxBAleFNn9jGfbD/0wxEXM1VDPS27GMSukRE18PP?=
 =?us-ascii?Q?eeKpkfJlYn6pFdqh/M0xduDiaEtn/tMMe9hsCDmOYb0ccf/+K+nqWMveXBNc?=
 =?us-ascii?Q?e5V/P4EYhO5Bwq7YtvEfNZiCSH/FxRy0lkVk5z1KMjXGIdahrd6zt3R/SiQj?=
 =?us-ascii?Q?0+nJ6D3Ps1e/M1iYA763/T0v3P4X906Rl0v0sHG8lQ4TDb7vpTD3BkNVXHsn?=
 =?us-ascii?Q?Ey9ub0fABaS6P7aQWPSjXriLlnkVPvAZioVmKcF1SRmahG7ZJi98Sx1ukRgv?=
 =?us-ascii?Q?kkJZ4RE39uMPHOLpJa2z+hjpPZYbf2FTGK3dq/7cTyyF+CfZdx/BEV4UEeaU?=
 =?us-ascii?Q?mvbOFz753TiQi/OqGkCmzj+9ajtHPzl/EnyypBT7HeW5nRg+FgF6KTB/nE+6?=
 =?us-ascii?Q?eQ3a8rtpsFmqoKXqtfRIyyslnh80yj9NNIFjmnHG7iCjBI3ZvGl1xVAWJfCE?=
 =?us-ascii?Q?lUp/BljHwnru7XddP4K2lGlAVOmuZ7GeZJWl/dmkcgk5HNAby3sLge0wauq4?=
 =?us-ascii?Q?pb0pdrpLN2z6pIOGwiVia1uf0vuKJ3CTjZl2kJyEcCTvIlh2q1eDTUq+MFb1?=
 =?us-ascii?Q?n6XT1Ra4e2F25EGVcp2SU3lNMGxQcqE2I8er0U7F/mjlnnXH6TfzvMdoBxnW?=
 =?us-ascii?Q?fAmfuwxX1Tn15P37hxBNIW0rXW5EhuOG3nhw2Hf2dQ//Ky5+Tr5ZcRoDo5WY?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0utRMMk/CaLsPDm0J01dOv/IQY3juyRYd+8qEUk46TXcvIEoRLhL414f7WekFYhQdDzaVAu2b+NITP9LqJRFSTJuCNKsmrjw5bDwnVCWQmoMw8hOV9YcwHqTx+iUfEPB4kqlc1K9zk0jE75FMBv1DHlT0Rkh1G0s8Xz2PAsrvMS9AiQhSNw4CmVKcRL0vWpPs8PH3kLTUX3+B6Ivwd8Jgf0zDUGfzt+xChKiuSKRbg/vsavtZLLFaBdw1sUP0cQ6ffU4dmQJeqTspwdO2HNMA+g7Pu9W9RBlvWSk9i4GHfC1xebU82mY0mlfIqyPOTb2gKRSl3zrm+nt3DZL7gECBfpwOrhgKYVCiyeTNn+MX+6IZQVjf6DupJKGMQoRbZn6V1wSHpULnu1OF3Gs0A5rrigm7F8IHfCA+MFHehlgxv+0eMTN1B13xE+awJgt50FzNi2n0WWK/qQb7D5urCiaPIeXpF3o+mlI74407OIJfvP31soCK0TozZ+kO0kRUpYEkiaCQ2ImA0VEhfcO+j5PBsUeEvCu4ZDoQtu3ZQijODY3CEhhiLE8dyqd2jgUxxT4tlITK7aX6+iONNWdXvJo2h9/VD8BQ6MTvwfKfKbyMrY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23110b49-c868-400e-6f26-08dddbe316c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 10:04:14.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0W9rz47+Kgppf1RdGEjIIGs2q1XpHejFY4a7vwjugZrlQtpY1hQz+yNDmhYFSCB6wjpq0PxCa0vQSzFSsYtxqK3rUeEMUtbCUNZj4Y6GS9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF424CCE606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=991 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA4MCBTYWx0ZWRfX2Hw3xc/Gck+5
 YzEvfpmVosKX5NIgiLh/q2u+SMJ4q4f5f/1rbIbPhT3mudQUM7AO9d78VyqJ1RUCVtUf0OzpooM
 m+9Df0TsdfFTGIzycocPa67DkwKX1+v/lIrntgoolHuLuzCqkEq/FAOMRSimLMNOrhs0yP5oYg7
 4n6zAp/bMz6EHKc5vqUu5WILNJMbsjdMcZgsG8z7AiBkb+xqzKcuagCeBLh+ej68sAQ1jEDVzNv
 y+r6pPTX0syxh5NFN4FxtCVnZxFt5Z/Mz2yGw2upUX4AjoWWEwh3h/liQeLaFMpOPFUCQzXiQKD
 TfF1NW8+zz8xd3jHqNbU7KMiXow85CC0UCYpwJew73FeVvv4xaRrku8ny7JoSCKyyd497rZLOKO
 LCLO5CJYtUnyZ2PceXF2lIbudysoSk/pZfy5HJFSRdy87ir21F1TSa79/IDrH++t3cIoFRsl
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689f0623 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=LM_5FBCs_31n8H7A:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=fwyzoN0nAAAA:8 a=CpSPcX06-0HYhpow01UA:9
 a=CjuIK1q_8ugA:10 a=Sc3RvPAMVtkGz6dGeUiH:22
X-Proofpoint-GUID: aEZ5_ZS2V44Er4VU8pz2_2uRO5V-qqkI
X-Proofpoint-ORIG-GUID: aEZ5_ZS2V44Er4VU8pz2_2uRO5V-qqkI
X-Stat-Signature: idsecuzqmdk1wwazt1eehenzep1jpgcs
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B6DE16000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755252261-381697
X-HE-Meta: U2FsdGVkX19PHV9ouya9O39r9vWrCfFBoVq301x8TBsfsJ47ZLRsI8uH7F9D+GMGf757y4kB/qrBUhl8XNem06QkDu9N2igAx/QF92Rk4SDEMqSjzhbotELylCzBgGy9ea4nYH4Lr1uWFaFkum+aPqmTw5obolpmrDCgeLzJCF95PsyJMnwiFXwTM10dYkSUsUZiehErE8fsyfCDxZnzdaTHn5w4mj06ngbBYgf/NoibiQjKTvzxJ+Py66NlarY2Nk75z+/eC+MoWTNdsKK5KRnEpGeFAMKiwT6L9g4vFa2kHbpfONhF555N36PKg8m4e5Ks1hpyXHxuxuXyTrL40CTky6BQLyUgQp13cWJhJU/MDBdNqzEqGRrd33NvYYCYfi3nao/jT9qZENAsHTLgskgcGUIx1Zc+pflK70OJS0z4X0x2lEo3PcCNhUOhJzwOCKqxCt6epVfdDv8rV74hsozbKpo6En0kvb+AEc9+qs+ALP8YJPk4KkYRAttq/Mm34r9KYAT1syACZ9vFeUIIuaApOrnnuWuMqjjGQJ9qs4J2c9c99z3/ak2FVnwlKHyi5+DSl2e9E3+jYt8ukmAiRVv583eIc135uAsqrazQuD0/rHbAHs+y2Po4Nhlr6d9mvaBRabL5KgmgTNrZCZlhAIWcNpjvS6GAm6edsPoHNkR8mV38eqRLWE76kZ6Qi+OMlHZTjBeqBcDcZLPhrvRWQdPNrtk18CsSAkKX+E/BLJ250dYeo1aCnS06k+Uf/6goBjywH0pOXIameGFarUagvAkuVz+eVcQCy1kuQlZ91QkXf/v5DNrhmyHSjOumwjgzvRbdBSt/y+dBQYoQCf15QcIaHgliOXNfvnBDYa5pHEyn3KkMaznTdXv3HYNlxok4MDYPaenTL3bJAQ2XdxzcQFvZpD63TD1Q+Q8K27HHLA5fO9YN0djFvLVdH/nZj7c95Bx9zpavVYP5e4FS3rw
 1tXzU4G1
 XK/j6ReGe9Tl9ei9cse5hEKDCHAdVPqBm6QUt8OpowYzPOEt0rITyx6TPRT1EWBj5PC2nlF0td/PgcDwXm4UDh+DedgFrPGUubtfH6Hp86Bx3qETy0JrIUUL5vZJNvrMHXeWgB0c0rzW6efMMCc1mYbbj3EpV9K6p8DWihJM45Lt28RdQt+SM3CvFYjAmPVboepQB2ejQ7Opo6B4KE51wmoJ4qCV/SCLaOoYKmx/21Qs/TZAyI04WpXdIpjn+n+VeKnNKv4CfQDMofH+Pooiv1KnthcGnbab9UyU/+yZu26/nLtJTGZYhTT3tmPe58v65/RMHLrjWp0vDGPMbHgBYnSN9mBqIVEsT96x+40apWUggtI5jy4n7O79ilDU2R1NxeSE/MEJNw9kv1N3bOY3xMeUqaSarAE1MgeVyoqj6RYrkIrq3EM9L8oFzWS2sle4BmqND1xduzp9iN0S3ZmCZq0lX5tXyBVkUL2DTSVyes0DsbXOmO+9vkqH+/9JEYcqV+VfXeHAIF1qoH27q6/9Nv9DH5WvK1FwdD2n2P8rEmOP4O9CoNP8M/6bOGRYK4Poekp4MAU9bQ+V/SGq7bBBnGN6X1ArILDTW1QCwd5+tP/7whPZ8BO7Alda9POxFkp0h84jj9Mk0nB3hPLqS/ZcAaCJpwJLTEzmxWlFpgHHbBvj/Jep9SuOcDG+5usFvZ7ElR56i3zqgu3DoSHzdByctBo+RgU60oy8hRmDwmcuqY1iKVGPVxi8YgH7JutF59cbE1m4wmcQffiYexgsEvvjHQqIaLvtHUlFeDdJxocmzXUOCNUM0swMjArFlJiJkIjoDXl43YBzpO2VRikg7a9RVjivL7gbx9NykoG/YW/nChGzm2ooBi01tsW1jTJmr2iFw2VO/xGYTfNigSlD2xhbbxcfJVT31Bb2asIt8fMEPnd438EWlAuCC2g8aay1GrmzbXqaJcVU8CnfQ6X0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:49:43AM +0000, Wei Yang wrote:
> Non-large folio is handled at the beginning, so it is a large folio for
> sure.
>
> Use folio_large_nr_pages() here like elsewhere.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

This looks fine to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 645d924bfc7d..1b7011afc663 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1703,7 +1703,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>  			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
>  			if (!nr) {
>  				/* Now completely unmapped. */
> -				nr = folio_nr_pages(folio);
> +				nr = folio_large_nr_pages(folio);
>  			} else {
>  				partially_mapped = nr < folio_large_nr_pages(folio) &&
>  						   !folio_entire_mapcount(folio);
> --
> 2.34.1
>
>


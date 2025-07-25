Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B163C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06546B008C; Fri, 25 Jul 2025 03:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB72A6B0092; Fri, 25 Jul 2025 03:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EC86B0093; Fri, 25 Jul 2025 03:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A398F6B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:02:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CC38160648
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:02:11 +0000 (UTC)
X-FDA: 83701892862.21.20FB207
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1E1C100006
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:02:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n7zhhx1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s8DkiNq4;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753426928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUrhnShJIrtRrwJhHRBAei+HQ9DakhJ8qyoOeHKNjmc=;
	b=SNBUIcVZvLBnHpoJrfWu5E8R4kemCu8Bm82/71VVC5mmlMTQKWfbO02cU0ti4waw+Dthbk
	dC+z/cwn/GhI2SljzkQunu5qYOkDVk4XNDNQ38MBn9L1mVyE7uxBmPSD1RJWnk9zZ5cpS5
	CBi4fCvshxe746+dRu+BF7qhvxuiiok=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753426928; a=rsa-sha256;
	cv=pass;
	b=yBIorQAWF+p7PwIY1HGCnK9xZeTpd4cMi8BtgT672WW5zNjtFrStK5DVCL05S52EBivxiR
	3ikpkVGlyjxtkT4GnMFD2Dk5LX3Mx1se0gbMkig90NLukcRqwNchucsMYvZv2AxRmD9vey
	Bjz2g4kv5Lh++EMtReMKp19dtqNC6FE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n7zhhx1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s8DkiNq4;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLk8Oo024918;
	Fri, 25 Jul 2025 07:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IUrhnShJIrtRrwJhHR
	BAei+HQ9DakhJ8qyoOeHKNjmc=; b=n7zhhx1DTnOwPXtqAHtnMw0hV+aMWTdIMf
	OpZuH5Uwl0n78lKBtsQIqK8vNrSD0HSfF5bJuMVted7g400KhgrFMv5zIkgY3rpc
	TLoeYOyHwhgT9YLWskDXlndEEuZrZHZofvHYOfyQOXmF3HgUIay5x0j2xad0IvXP
	g9woyo39PviLGABciyofvJF3GYAhVrgLcOa+6ff4ubmbZedj3ky3Q/cDNVAr8cK3
	wiUPNH7nSPQSWjVY7ybaEd4YFuecv1WyjQGKB7kYhGIWhm1t30anP64Atzqh8bFI
	Q9VBd3EioOFLgCf0kRW8CSPhLV865/rZ4mxVNwluqzB/FBXa9Xcg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1n0euc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 07:02:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P6MOXg005895;
	Fri, 25 Jul 2025 07:02:04 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcr2n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 07:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WjWPdSwL2yytuvPr7LaN8ny3zMwsgeIBlHA9qGWryn3nnjSGZArOR9C1RuqJYw8+qMd2l3qAnnSPjcFxDlFRWKaTrmmYeF+ntqouqu2PdIFmJDUeh/BzSQGCHVVI+tPq9WEtIkeOjBB2q/Sez2j04w5ctz5fryPF7dy2AN8y97SRIaABgBz1A4O3aGe4BPv7PFG7ognivJ0uuAmAFyXd0lqRr1Mry2jSX9YSl+IUFNwMiDVfCqqZ1PL9pj6vWOKkusTKukST7iUkuxsk0NV73jURVU02N2yU4lnrdi/JrW/K2gSCpo/tnwlZfSnWfAy6u+phtE/3GWXEbnX280U74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUrhnShJIrtRrwJhHRBAei+HQ9DakhJ8qyoOeHKNjmc=;
 b=y4hOqp0SUah/c8X3NAc8nVV9CdAdWJh7ASnewgqt0qm2oNGX5F0nF/8XwljjpmpBj6ae+PbQfiVv0E3DTbwJa7hnGetOGKumrFzWd1EzBpe+Q1dxChNSClVPbgOH1HBwOlZ49eMJwBuE+LxzcHlJJvHS8WcYxUSqytwIfaIxr/cYtdA6fRVIE2Y8D7h6khvM/+w8jGiXX/fZ5yE9l0/aYdf+JWD5iI0LNlm7hYCxhvDpZTjanZbwqJ2pwhWyV51onsS0S2/ksG0wkpDMTwsrWLwkNQDlGwKSkSP0u5L4riLhc5d1k/cxnTDxetCmZqGII3oMDMC3zr1Ev+hn41iz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUrhnShJIrtRrwJhHRBAei+HQ9DakhJ8qyoOeHKNjmc=;
 b=s8DkiNq4p09tWceDcbH/t8dyaSNM7JNZ2CLdkZb1M9QfUeVDRcfrosqkkEuPwP7w8SxQJSwk67qgb2NBqmLCaUKWeuBfvQ3ngrx0hsqjN5npRqCtRxCuN13nBuU2COt/HGJtMVLHkarGuKKz8IqT1CvMY4ytZ6r5XOfXlyEqiUQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7810.namprd10.prod.outlook.com (2603:10b6:a03:578::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Fri, 25 Jul
 2025 07:02:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 07:02:01 +0000
Date: Fri, 25 Jul 2025 08:01:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
X-ClientProxiedBy: LO4P123CA0185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da967b1-6333-4fdd-653f-08ddcb492783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f0tYjeXPFOmlmAyvbFr9foWpk+OmK/e7QoKVs4Kwv1RJamWDFWrCtdbFtVFj?=
 =?us-ascii?Q?NDXgj/AK/WxE13mgPKlkjJpmcMvNXO0Em+D3/TO++kBC7QfJYulbv34RljaD?=
 =?us-ascii?Q?iJsPuoHFkgTpGpHSJBl4M8XInVe5I4LEs0qEXcMxu35+zf+PKLIxvSezWLna?=
 =?us-ascii?Q?VozelyXxERwrHoSB35+r1V4HXIK5jTjgOzr/yb9dxB4HTAzABAi37kln93+P?=
 =?us-ascii?Q?TyJIn6SyE79gDCrNE/2zpdTH/nZJSSOxIXYndzGIYVSn6KUhvV+j+yuufCYy?=
 =?us-ascii?Q?JmBUr7A72pATwEf1yMXE475q5jIa9wMCadF6p+6HTJsuvBYaI6IDbA4o8zSl?=
 =?us-ascii?Q?SoqEwfw4Q4o2XnBfGy2EtdILiOVur7/7oHHFRoxUP5RUc5hDEBarImSUxD3A?=
 =?us-ascii?Q?Ky2/YvA00LKEL8pr30EuQK5z6nfu5eTRVvlG01LUnfarYdCcsrXxEaNiCtCP?=
 =?us-ascii?Q?N0DbfgK5ztjGloVH8yl7elVn3Qttjk/5xsX11r7cWXz8t08b5P8MPdn89dYK?=
 =?us-ascii?Q?BsmTl4m/rnjRdg3Z34V/MnWhkU4/PHhP6tH+LsGI0LuFBIlrYoUdlrD1dhYC?=
 =?us-ascii?Q?AiXP1eTf70Qx3iYKnWWmEhvbVWBl3PMtZKy0bofIZZmMMDKU5yjn8CuXgk/H?=
 =?us-ascii?Q?bP+cOAn2FApn/v8i3TuffxYzLKqGtMC9E2gxq1dD0gVD7bFTYMNw9MQhfUWj?=
 =?us-ascii?Q?laGLdhj3mH9WuQepQUlvbkohqZR6NpCN5JkgC7X48x7PlMwVjbASWqPJg7aH?=
 =?us-ascii?Q?4zj2PCBmxWUl/3ZyoPNXEy1m6W7Kg8B92FIlQgv48zO4Rt0kzt1e8Kn1qrKg?=
 =?us-ascii?Q?Rf5wweI6HvfPzs9ef9PSTFTpvdA8ZbMGBs+Bg/ZExbZ1PtKA/KZMSsI9J2ZY?=
 =?us-ascii?Q?Dlt7BWUAZD+JKMDJ6SHI18/toV4OZUD1XiqWM5Pb25tqJ8+iuPBqOK4kVkpA?=
 =?us-ascii?Q?eUKHx6j9q+IHKIiQsgQMeNwbN6TR1QY+SBg0YaD9X6OORqKcokRa4xzw+Tvj?=
 =?us-ascii?Q?QK3ipBkiZYuBUft5VcZOUYxYco/eBaHOI0/X2eV/uwAlX04yMLic6U9sSFv4?=
 =?us-ascii?Q?ExgzVOwtZJY/WzWIMMATKHrIziXUX4MFs/3QojFyCOcKP8wo7kNfazUeBxzV?=
 =?us-ascii?Q?6vNihb4JKZrGKhMzMJRGBkNYvWpgjlPm9hNmppw0oSdpP9RTV6o0OoCbbfEW?=
 =?us-ascii?Q?Tgmfw6RmGKwWRSLq/PY0Wou4SZ8/MBn96PGhvH78HV9QrQJbSqr0nthlYllm?=
 =?us-ascii?Q?f5S56Oi2EEOd0B4uxJaC6DC6wnvNPQuYJkVoKoZ1U0+foSkf2yJQhFY/YnKs?=
 =?us-ascii?Q?v4CkDj4jFcmkE+947BTJqDc7emfmZXERV/Z/VSzK1DpVIEYFfP2WjS9hRngY?=
 =?us-ascii?Q?0LvsXVMu20egGhZjSmGYp51A6sb/xalA1PYJrJkwK7SR58v6ErFXDM3gG1EW?=
 =?us-ascii?Q?MXXxumcUHww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vzxXCvbGoiVURuGREkSylZf2h1vB1/x0e3KS/jEuzqEkZAxgsikJcZKDDNph?=
 =?us-ascii?Q?nc8qEuhoDMGYUl/OMkhQ/lpT5YWM582icExGhjEaJ9jltWn1qUxAWNPCdPlN?=
 =?us-ascii?Q?xx04R8LOdIjPiE/DoYl0eEdGcyVlKasHzQ+zSTaPgJVpQVqtzYeaeEH66o6Q?=
 =?us-ascii?Q?uqxhqjdqBmPsZqbK3nS2XRz8RzskpZ4FT17iGOCP2oSNskIDl3YdEUCvR5hD?=
 =?us-ascii?Q?lsLv7Bs54ZC69o2oAF6PkVRDYllSVT+b82kJAcN+aqTnHFiodiA1U4wK8oQf?=
 =?us-ascii?Q?0qu7hj2JCJbZQ3X8q9397vSxeW7NpTlhVg/E2jpbED3HSoD+ODdsqwTuKkyw?=
 =?us-ascii?Q?RaK6q1599HKYG4Civ1YEj0uuhy9eFr1YWOC/bi8HTPSxh33kJ3dTBuSxIpKy?=
 =?us-ascii?Q?ersUk/+4NULlsCH61D5vhM3SF+zo+wmBMoLCTtUADdMCLWAR+TOqy8zwl+2x?=
 =?us-ascii?Q?dgClElMKo3YocE/8IwnhW2rUFCDbA+r/6V8zAtQiKlnhDIlNHW5beMx/Unvk?=
 =?us-ascii?Q?jx/Av17AiXlDHDxF1GMvDAPeRBgZmotI8frU2G6AuYq63u86s3SCA+GWbzD7?=
 =?us-ascii?Q?fLjniFY8TzDMxpFn/L5uK/wcHPnWl4NIIKIZjj/Rtu4Ljs6ofCY6ZJAFC69X?=
 =?us-ascii?Q?KykiCvgbO2pJFtHMXtn9OU/VH684hmUFpOTXb4LJp9N3XhiaKJ7Q3t3pB7nA?=
 =?us-ascii?Q?uNAFvPI1HlEfJM3l+iosDs11+2ZdIC7dGRzaVO2lKGjWeIWHZIH9DsRfZNTl?=
 =?us-ascii?Q?rMEa6MLb0h+t7n5wEOHvJY6/JRVdzr40qfXo6KTLTzeAkvmcnztTy3Qvib3U?=
 =?us-ascii?Q?qSvXLBQUS6v7/KbikYasgioNmogPmOVjCJIxCX6Pr/f+ea+b5oMC0o3fKb01?=
 =?us-ascii?Q?JdcGz320EeSsHMu3vx+7g0DnfWsIoFj4PUf8PgFDmGQMFjQrXmZJGzY4oU6x?=
 =?us-ascii?Q?hsX+7moK7NApM2Iu+T0O1QN+iWsxkrr0HKi8YlpuhFYqrR7O6p4pGIEUX1Ca?=
 =?us-ascii?Q?mzWgD08cCtw3Uv0B3S106IyDvmoavBHG+ozv1WuJupUm3t0Ko58qiKt6SoOt?=
 =?us-ascii?Q?qiQUWj83TvvtBZilucvY5/oFD6x57kszaOHeBWSIBDlLePvRibzi8SbhEImr?=
 =?us-ascii?Q?gUGqpgFz2+1B5/9TF7q80rPN/lweqwzrEOw7LwVTURcfPtzLbyxwnOhVXbAq?=
 =?us-ascii?Q?4OuegKBOi7dcFRmD416c2iXhfp3HW2b6t5UabcimUMad/EWNkCAY2WOukgDN?=
 =?us-ascii?Q?2aME47FKCrgXOm2gbU16T081lexqG+vTAvvPdYvjr6Up4fX8L0yxOocxHvI+?=
 =?us-ascii?Q?Ri8zMNbj/L5LKz8D8L/2qylIwkxoAg8murgJM0XeDIsR8MSLQwiD4bWqR7bz?=
 =?us-ascii?Q?YGvin8/FZ1KWYrCS9M+awBcsKvp67/z67fUwN96lCRMVlWvf14vKqyTjEtga?=
 =?us-ascii?Q?kjmiTND1VPkjQ1i3EUTcD+xn9oErFmWaOA2+zM7JlKwT1C1XOjWF+c9j2n4f?=
 =?us-ascii?Q?v4SXD72J5UmxS22motgePxvxcOebkY7x/zu8xlRgNZiVYYtAGm0h/TQHzhwB?=
 =?us-ascii?Q?wsyHME9nd+0gKjlDCB2CO9aPYgeJS12bTC06G9K58dvv6WXTrSibFJ2janzU?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bkPSjMzbeLru158dBnJ8omg5U3e3vOmLIxJkyyz+2oHN2h3nKbNutK5oSSfXM1L4xO0yDN6CI5fsYP54HQ6lnODqqgqNIIsj8lz4GQEnvD405Ev2OFGfNi0ruvOw8CRPTgr8ZzfrEijO0OZpr6Sz24hOfB7khI9wkhnHWmfPYxSFGe0cYb8MjS46QisECiTg71ZlXVTei0WRe1NZC4cOr/20DAGutYwCVf1rD75n/Y103Yc4qlJ9Ei5sCFuFurEFzuNyrIM7Xb7PwiFxOgyLN7Ta+TimpClfOK2UsCwi5QriHvSwnJbCT7Kk2I72pXPFzrs77aKl9MQ17l9Z+MkDkusLpPBJMXsS2AzhDLKVCVc0WLNT/QwMzogFRO9MBVNEMQ4Xkn1b3q/eF0a/VA7D2BzykQ+bh08TQaWJUNte+6O9kARQe/w8v/+v3MKGoqfsroJmx9bfa2QcrnFzY7z6An6+C+PpmLbyBQznFDztiAn4ECgSqXnmrWiiF5Thm2PNumYwnsQ/jMSjt21mNn5TTBOz1CEfOqfsZAufQEq38DQB0yVB/VEbokxjrG05ngNYya15176pwKkPXz+m+FhOWw6tWtdtZQsXEp54brNYXjs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da967b1-6333-4fdd-653f-08ddcb492783
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 07:02:01.3233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhuOxzNfg+fg+dNXt0dUWtthOYfy0bjrjPgH0gLEGpF0lKtZYeu5dwoY2f0XP4oUyT/H1FIyWKR/2QfbpPcKA7+mhPwFABcUQRg989qHPvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250058
X-Authority-Analysis: v=2.4 cv=ObmYDgTY c=1 sm=1 tr=0 ts=68832bed cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=ToJ5T_3QOQPR4NucEjAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: o8XEgxjzxlmPdP2c9wYtl-PGWbMZb4mH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA1OCBTYWx0ZWRfXzEUqoxQXaTs5
 MOo3XWiggS5CkFUTIIm2pOnflyqMbjE3CbwO9R8mahdM0dnELHpsoMaS9vtBSpF4KcfEwbiv+6+
 yXIelp7LvfcobjvB+mNbH2PqOFBXFGJEAHoxVtkzRDaZvEJn5uakTxoYqFVMudvKbxDd2FquoKJ
 ojhr3H/5RkoFQvJ7K6wWQHWd0Xjr7oYUv+o+z12eTuVHRKwxvqxuO76ENKTrsegOjbk+x77w6Zh
 7EMtB/H8m0hZZPrCCYd9G5dO1MXnuo+PUPqcgZHTEP8wlA5HnmkUh6LDYVeJmNekvAscVgplDEj
 PHTgj9hA5fgDspuz+GgMy5WM07rZDV5eYE25MwXxqAKz/oz4Yg9sBxy9o+diCqrOCuwO9Jf0htL
 b8qavZCnmjOoK6e6mdrIRm8RPD47u4/DWfyGYW7fsB9NKpx1OCbCHJA0dXlSS2E2kCCKEw0W
X-Proofpoint-ORIG-GUID: o8XEgxjzxlmPdP2c9wYtl-PGWbMZb4mH
X-Rspamd-Queue-Id: F1E1C100006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: g54yfe5tbjixwz46bx8ynfu9qxo6q1ij
X-HE-Tag: 1753426927-268057
X-HE-Meta: U2FsdGVkX18o+zAdW4JFJcUmFaYC4fJ43ZOSJXc1HJEf8JsevoTtxxeN+6L7QQIsqxYasoEQBIQufSNwrSCDm+kUAjs2q+X+OHDQ9uQPGKcAbGizTYOcnP8XQs16eHWlY06Wq0fiS5G0cR7nSO8he/A6koX2ug4O3fNifKFUB/uMF/W1UlalIdb1y36eBpVutjTAmb9p4EtuXewOAk+o038a+60cL1Mq5gQLEz30qhp1/zBHdQLX9ulPgADCNSxptM8QuFRNxY/PhAV6Jh+vZP+7Ej9OEj+fl8CZpCpUNVwHkTri+EYtHw409GhuEjt7NbGqGEVaknao0MgXaA718nKmokpQV0RB28G3GWCOnGH3+YHUs8UCMIv9mBec70Uyp1jc+g/TpbkgYUzMGW9RlvQdBcJgwZFTWypZzLYZcqMd2aAs+wc/VeKeL/3MtmuC247SiMUyIwU3HQTpwHRuBwQt4HKTyvgB4MDOamzst0goKLcMVSyw2VmbuwSXptDWJSbTwuWVkjTxc0/qg/Q8ibcFKotFvxaCNvLVhVojmytHIkSWxYoIJn+1Om6maiSYzWdPj9W8UdBg+9tIshGm1LnKATCunjTB8Tdx0TSoMfBrbNRWUsYglw1ik/dk9vWU7fkg1jBEOaCff9VDf2mC4rDtzS9swE9xbtxIybzvIyPc/fqkeufQIce9qLznNTzbdwRqxLPAB5DYkHF8R4py8nBrhySRfmPWPr7Z1mP/Ltfidif+iA35hEu/9gb0hAXA6fkwGeZjfisLhgcBkqGOwVLL/E6q7fzoQpFQhOx9RhBn61tSPjicVzLTwjrPg990YILiFoSteGWAgYp8VLL/YN8+0ZB5wHSbgZm44FC2jSnOQlKBb6cfNYdZIryrQ23f+OPWfj6cC3FxBlielpJEQ2qv86ylW99cRl2qOoReQWAuMZ9s/t5ddzVfYqhCUdPs95aKgqPxsNfZOTocCuR
 wXduzRmX
 76/EQ06+jcUAhnrrAc8X4SzMy3Y01uokCuPIGjR8g44ceXBYpO6JY6YOj2TwxgWkt14Vbe3bF3MRvBcbGc8LuOG+1xwFq6OwCxwHGoMsT43awxeYV4L5GirwVigC24cRl9hfT0AcxE6BJ/KCffoFEZg2bHQvZOJCaXBcFQEFx1C+Hdu884FfXEZvQ+ecl/pgkrhUyPy5s17blsWiC2cOe4yf4MSBd6DqlNW4CHkJshZHD/GsxoLK90j1wqOlV1Xlnx/mg29btOsS/EEJIckeF+PjhYLfWA/mtJOFudW4bdsdTdCvOlRoOorPMimECK5nbyWlsQISYb/ah2L/VJQqaEp2eX/e93cpk0aIBvh4w53ub9fHp+gLi68DZfA0YJ1LlDWUEdlUjBoLQ2y1G+El4EpVCRSXqusUDcjsipKmZREztZl0u+IGwaTl1qmpRdkwnU/GGdoM0SnYW1etCREVAdcUneS4DWeXLRAICS87jCvqP8dVXhesTtV+BaQXv/Ok5bp735SSqW4rEHHMcAvdvm4H7djRVxo2TLk8WIPmg9KCBOE1OwVnFqZ8uX5it0LW48VI9otp4qBO7wpSfWs4n03yCkvaOPWqj1QF31ce319xdei8rvnDdlza2c4l2FJS3l4hc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 12:12:54AM +0200, David Hildenbrand wrote:
> On 16.07.25 19:38, Lorenzo Stoakes wrote:
> > The madvise() logic is inexplicably performed in mm/mseal.c - this ought
> > to be located in mm/madvise.c.
> >
> > Additionally can_modify_vma_madv() is inconsistently named and, in
> > combination with is_ro_anon(), is very confusing logic.
> >
> > Put a static function in mm/madvise.c instead - can_madvise_modify() -
> > that spells out exactly what's happening.  Also explicitly check for an
> > anon VMA.
> >
> > Also add commentary to explain what's going on.
> >
> > Essentially - we disallow discarding of data in mseal()'d mappings in
> > instances where the user couldn't otherwise write to that data.
> >
> > Shared mappings are always backed, so no discard will actually truly
> > discard the data.  Read-only anonymous and MAP_PRIVATE file-backed
> > mappings are the ones we are interested in.
> >
> > We make a change to the logic here to correct a mistake - we must disallow
> > discard of read-only MAP_PRIVATE file-backed mappings, which previously we
> > were not.
> >
> > The justification for this change is to account for the case where:
> >
> > 1. A MAP_PRIVATE R/W file-backed mapping is established.
> > 2. The mapping is written to, which backs it with anonymous memory.
> > 3. The mapping is mprotect()'d read-only.
> > 4. The mapping is mseal()'d.
>
> Thinking about this a bit (should have realized this implication earlier)

Well none of us did...

> ... assuming we have:
>
> 1. A MAP_PRIVATE R/O file-backed mapping.
> 2. The mapping is mseal()'d.
>
> We only really have anon folios in there with things like (a) uprobe (b)
> debugger access (c) similarly weird FOLL_FORCE stuff.
>
> Now, most executables/libraries are mapped that way. If someone would rely
> on MADV_DONTNEED to zap pages in there (to free up memory), that would get
> rejected.

Right, yes.

This is odd behaviour to me. But I guess this is what Jeff meant by 'detecting
this' in android.

The documentation is really not specific enough, we need to fix that. It's
effectively stating any anon mappings are sealed, which is just not true with
existing semantics.

However I see:

	Memory sealing can automatically be applied by the runtime loader to
	seal .text and .rodata pages and applications can additionally seal
	security critical data at runtime.

So yes, we're going to break MADV_DONTNEED of this mappings.

BUT.

Would you really want to MADV_DONTNEED away uprobes etc.?? That seems... very
strange and broken behaviour no?

Note that, also, mappings of read-only files have VM_SHARED stripped. So they
become read-only (With ~VM_MAYWRITE).

To be clear this is where the mode of the file is read-only, not that the
mapping is read-only alone.

So with this change, we'd disallow discard of this.

It'd be pretty odd to mseal() a read-only file-backed mapping and then try to
discard, but maybe somebody would weirdly rely upon this?

It's inconsistent, as a person MAP_SHARED mapping a file that is read/write but
mapped read-only (or r/w of course), can discard fine eve if sealed, but if the
file happens to be read-only can't.

But we could add a VM_MAYWRITE check also.

OK maybe I"m softening on the anon_vma thing see below.

So we could combine these checks to avoid these issues.


>
> Does something like that rely on MADV_DONTNEED working? Good question.

Kees/Jeff? Can you check if android relies on this?

>
> Checking for anon_vma in addition, ad mentioned in the other thread, would
> be a "cheap" check to rule out that there are currently anon vmas in there.
>
> Well, not 100% reliable, because MADV_DONTNEED can race with page faults ...

But hang on, it's read-only so we shouldn't get racing faults... right?

Hmm maybe I'll soften on this anon_vma idea then. Maybe it is a 'cheap fix' to
rule out the _usual_ cases.

We're not changing zapping logic for this though, sorry. That's just a crazy
length to go to.

>
> --
> Cheers,
>
> David / dhildenb
>

In any case, I'm going to send a version of this with the controversial bit
stripped so we (hopefully) land the refactorings for 6.17 and can change
semantics if necessary for 6.18.

Cheers, Lorenzo


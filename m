Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A4FCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913FE8E0043; Tue, 19 Aug 2025 14:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB6C6B00B7; Tue, 19 Aug 2025 14:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2E78E0043; Tue, 19 Aug 2025 14:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6542F6B00B5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:39:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E80E882775
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:39:07 +0000 (UTC)
X-FDA: 83794369134.19.9BD7F37
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78EAF180010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:39:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oRqkv4zd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fj29/PzP";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755628744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLCiEQ/+qqGhSp5+PAtR4M2HfW8awIlxVk2QaEMykfg=;
	b=0tMIFKPiKkTFuULCBwpVUrNGaV/CMmM061Y/f1QZhQaP+vlFjVPL3sVrZvPkWyV0fdmwRO
	I/kTaa5WVPuUSnX9lgRFmkpdkNCas47VM1EIIXELngqSYkCc0etSDy+cxIFkRL0el2yyru
	MYamdLEbqMc2/I3psl1i4h8ec8/cxSU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oRqkv4zd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fj29/PzP";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755628744; a=rsa-sha256;
	cv=pass;
	b=zlrF09OnIWCh1w4uJZzD4iITYp/zjIF79RvizXH0vEBVCVxot6HT2xOzlAgzYYibVC7ZQr
	2zBrUTMWbYfuCj8RC0Hzf69d69Z8V/I34XHFhdTfhcbIuvdsZXsGMrs8MOjurRfWGB8NHx
	bYdqoCj82vJeoSkklbnSHZnyWPrQCmw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JICtY4003028;
	Tue, 19 Aug 2025 18:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CLCiEQ/+qqGhSp5+PA
	tR4M2HfW8awIlxVk2QaEMykfg=; b=oRqkv4zdEmdvQdo/bs38wuU7FMcB7MiEIj
	oWxC1bJ1FlajmRqzQ3ylFP+TGJdby6tOmZon1hduWJQ5EtISHtojgne20aovbZA/
	G3c03i4IYLmk0XU63Lc2sEHRac112cs/OHxBba0La9XQwnsVXfOYLci8qChXpxfb
	04/x0R8fnN5c8oSjVlMFcIYquSwFIORIsoF+kL2kFdEnmuq3e4SwpGHWd19LnzpF
	KLA56bUSg2QeBv7JnDHg8cUuVhGGdByrac1LP/st9UPsQ6mrgaUr6PRd56/5Gw+Z
	RTazEXJWLUjpnnQ3KsBDM+C+YZj/ioqTwXpvZwLA7ENJ2sjRno0A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhvddyn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 18:38:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JHhBP4030949;
	Tue, 19 Aug 2025 18:38:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jgeakhp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 18:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnrISpXVvlB9LHkCnWxgj0rKRXWf3J8Mabvp+oIDjWnA2kuvWbNvVl2vvwXP0Qavf1ng+6l0PD/smRG51Y9nsHbzNA+Vpqy5xRqviioUTFn6nVpsD9O6dTFaBjD+PvdIaBSd8eSEbx7HXcmGkVoF+uiEXy2S1i/Hr9L6LhXyEe1NYNfOvW10wVZvjpCJKmkDZXZ4tF1zpp+r7/sqXwdU5ymrzkFglqxYbrNl1FqlYQU576YHVb1c5PUE9U1QBeu5Q4lFyukEYDgyf0FPwNIm8Aq/zUp/4tPJFOzGldCAkClZ4NfH4QU5Lcm2RWV6/J/PkXBHlFI9BMBNwXR+jTfxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLCiEQ/+qqGhSp5+PAtR4M2HfW8awIlxVk2QaEMykfg=;
 b=aQkOh7XRjllDZ46aFSumOU2rBgcqnqp4DWAigmuSRgce/iFkVkVnnP1O3/lUPblOpzP9qscEbaDqayj8gLf3JOmRUW4IRSGzkUoS3h/edIGevBJudBY0B5NUx3IBlNhSOCPlWIFahJUQRKGCjrhhXuEygC9LHbc2nye332ApWzFiqqVS9YEN+GaUqAJJww166O0roxv7hmoFXacpEbOCUH16VqiDLA5/RhtfBRCTfqJgNc9+a4GO25M5fM9qH7oUj0OV7Mk8q2B5RAHCrS67WpOmlaVlMmCT2ZWHZ/8hCRGd5KK1gfxTMpZKlfqtrHrA89SUP65rU6gezqqL7ecmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLCiEQ/+qqGhSp5+PAtR4M2HfW8awIlxVk2QaEMykfg=;
 b=fj29/PzPSKqHssczEjVri8FNdIyrZXvb4KYLHjnzV6tE6XxlPKTGJrvpBfegdFSlOS7iabmI+XLRDb93xF7GOKC6Tk7e+KCzc6uEh2QKtvVsSBSVRcJoLSEsSiNXw6KKBtGQfGxsI7AyeJkUHKcsX+aZfCIJLRbT0DT2zJWHU/s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7302.namprd10.prod.outlook.com (2603:10b6:208:407::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Tue, 19 Aug
 2025 18:38:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Tue, 19 Aug 2025
 18:38:47 +0000
Date: Tue, 19 Aug 2025 19:38:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 2/6] mm/mmap: Abstract vma clean up from exit_mmap()
Message-ID: <bdb27f25-d979-4dce-889e-a2fd17fc06a5@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-3-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815191031.3769540-3-Liam.Howlett@oracle.com>
X-ClientProxiedBy: GV2PEPF00004595.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::440) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e8c189-0746-4112-f4ea-08dddf4fa228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2yja9xqnQIsOFYVsxu55OhYToyOQhdrehTFWti3eTpL0J2mmFSDLAk++SlVo?=
 =?us-ascii?Q?JbmVoi+SL/oppzX7wHAG1QReU/lm9oWigDvh/+pvENZRUTfx6IOLAetyB5No?=
 =?us-ascii?Q?3BWwkliG1SOhmoWENcH0sWPsA3hQ1VUdaSFjWshd6vErTvnGLlQyJcqrSEZe?=
 =?us-ascii?Q?uYaMJLCFGVuvefD17sNf6QLMbxoxgl5/OaGfevk6yntLzYw4BovJy5oNLEb3?=
 =?us-ascii?Q?eTNbhOOWlAut+giOX8dPPjxr1VxkHntue1Mwx+WPF4tGNe09EHEIXCmqT8+/?=
 =?us-ascii?Q?X0m6qNkbitPT37lj+8HsiqZ/Bb8ksT2l53P843M3BFf39msz9cWW7kFjiUWA?=
 =?us-ascii?Q?jgyprkKYetRlfyReZ3eDxQTIpQQ2CkJXi+iVSF1Pjo+6QVx5twad4vZvd7oV?=
 =?us-ascii?Q?YGFLXk2o5FPtRmSkGOwj+CSbfE7dmEgYokDhHmgmEoJ9vtZ1/xJ3RpOag/Lu?=
 =?us-ascii?Q?x4Q0eXx8Q2tnnyfCGV20I2Yx5/OU6brAEkhHIo2gZ7sgLvkJMt3UMJjYph7s?=
 =?us-ascii?Q?BkFUCsR7kn1mU5Q/VPrHwOlHeOcFaFgxjbsKeZ/7CFt3Qa3WKEngQrTy0OOL?=
 =?us-ascii?Q?laGVmIs+KtfNmsI6/4Tjw1DAhG0x7C/Y4SuhUDg6U2luHIXJd4cUq0SjQaFy?=
 =?us-ascii?Q?Sor2T84d/UGLuPBvO3jYIttM7NP9t9gT0OQW4b6HMjxFIsdrMTKORaaerOlO?=
 =?us-ascii?Q?ixCc/6WzLQvBQDqLl7JhgHo/hwbllu9Td+hlXWnwhrKIoCn35QgzLSdzJmvS?=
 =?us-ascii?Q?FOb1QX2q7a01nGWDvznHdgAwYkGqEwGuXxsg+8lgdY4U4mkU2wN3nqbQ6588?=
 =?us-ascii?Q?tY/Ob9HjmWK+ui2bPWryzWPBDwWGsRe76XqE99VLQS+VP25EURF5D7Y4FGTj?=
 =?us-ascii?Q?Q4q6wcTBpCP200YJKRIzow3X7M/9XKduTeji2AEUN0Synl1UGtgMGNoZosQl?=
 =?us-ascii?Q?nWGm6qa942zYybZzgieTVdgKSA2JpbNxT1KSiYEhGptqzIldBTtDsZ6Rdl9C?=
 =?us-ascii?Q?bfrYWGj+RaznR4GHfTY3R4x6aZWouiLqI5lWECWem72afUWOfkfnzC/wQuE+?=
 =?us-ascii?Q?l2oUy2HDxH80JPGj/8QJT9SYWEuumyND3JY8NFD/xcmNVDBLuUxDOeNCRd9U?=
 =?us-ascii?Q?syXZcknped+eVNxY+o0xCnNJgwVrtByySXd/W0sfsMWZd9ZMqSWETYkbcLyO?=
 =?us-ascii?Q?cZsue0yNUHcEhmi/q8GXzdaRGQIYUdb4eYw4j9cYUNF0RnnNlTf9meUISpGP?=
 =?us-ascii?Q?TyAmbDVlyyIROuFKYUyt78JkW/qacH7Q+bV/Lx/GdRfjEcNFISbYsZ/yj4BL?=
 =?us-ascii?Q?kLeqMgENchTn5OHjVrEHE0VkRlua60gkohdFmKD245oL1qnAAqV+gKacDUBR?=
 =?us-ascii?Q?5KEDSbnmJv139JSC7rzwLra+Gu/6kdBy/lDEyooG6qAetztnLpXDE1WKdzRu?=
 =?us-ascii?Q?oN3Ox/9pr0I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9SAcRKKwJfIyYPoYB5s2/50zNYrSwabZt4XIhx6khgw9U+3wNKaYLjIKVD2v?=
 =?us-ascii?Q?Ewpd8rkctP/xcqtYSUpvzIM9UkpwJgcXaxB4U6UhQnIOUnbg30E3fdVwHM1x?=
 =?us-ascii?Q?5Vhf7WyPdvbY0pxRYRyCt1yOYMwcM2f4CCgQTGo4luduj4yR0RhONMK7ShK9?=
 =?us-ascii?Q?1Mie4siZJ9ufdW+kU8d3Deg8oX/Uvk930bGaHbOBhrdV4DGdvOLdRdhJlsmG?=
 =?us-ascii?Q?grT5oa0aS4S/orUlqZgYHWnfCLei/pUXfV9mJ21HrpUDDqqpYTtavlBO3NF+?=
 =?us-ascii?Q?/1ip7FCKhIMMTLmr09gq9gAeu9kbwhHJYBgUXphHkknGWUGPMYe27iObVwk9?=
 =?us-ascii?Q?bLmFjwI0o5dAKvrLEkpKnzhc5jRLRGHLoRhwXiYWTsRmhGPYbdivKm9BuJBV?=
 =?us-ascii?Q?rLdmteTOkimiGeR/Z6TUOI+m1a3HDgUqiJ5w8P/SIW7samsc9coj6+wxSUlL?=
 =?us-ascii?Q?rR/u5WZcBxcikpxHWr4szc3tezMC71OYmD2hfehHqublEPwmPdUg/+2ziI0g?=
 =?us-ascii?Q?fgu9IeexHilqi112uG/zI0JsIRr+o1atu9MwMeKtbqnZoMxjp6WMPnRXSEjd?=
 =?us-ascii?Q?DWPXhUlfLm16Xly6HN76d4EGOmvaf62Gr6N9OYE0motMei/9GzVK10fBJpmG?=
 =?us-ascii?Q?V9BIRss00Q4yb/MFnjESxzVvmoAIJIm53Ss7r9reeGwWP+7SjxJAzdiUvY62?=
 =?us-ascii?Q?UNnmovJRv1XrjpVALK/jTrPklUnXglZC1k/znwbDs3ITw+G/S11Hr57JH07M?=
 =?us-ascii?Q?ep9xkh54WsZnLKEqYiIxZS2X3xgz37Cc4UYhrU5Y5Hv0J5crNq6kazcADTw6?=
 =?us-ascii?Q?hbZ2jLXe1EsR/DNhPMdKNGqfXokHfTCuKSjUTzXGv+9Z0lxOZHfAuvHQixhh?=
 =?us-ascii?Q?X75PX4xzBfmkAlklYt0ytQux9ifeBDauoaFoubw78H8woSS0MQ5E1ejEmsC3?=
 =?us-ascii?Q?7IduiwpAaqOkaS4Edox2ZrqK/LUgOJfJO2TsUatia5sOSEHlj1grB3xTo7P4?=
 =?us-ascii?Q?m+QXObeEa6dtHeiKQ4BUV1OIzw+Liq8QjI+NeNzO3r2UkzgbhSI/PsU5l4FX?=
 =?us-ascii?Q?l1z7O/qigktzqdB1lSYoTLaiknt6v7y3JqsJvgm5OJx5fjRUyT5PNIgmNqdQ?=
 =?us-ascii?Q?3zBaNMY+uczBYi5Fh/LGMaokCCH6CitUvkDLYKUvXT+Fs8pZTQ/D0euUhVVf?=
 =?us-ascii?Q?5U2f3qO2Onays3EAaKESyR7MR2N24ICUmyWsQZr4xEEbdlPe/r5LM/n2l3Le?=
 =?us-ascii?Q?ORB24RLdsFbKm9Eoy0DcbshXYN4Y/4MArLV+1kVn7ljXFXKqFFyj/LYvqMxu?=
 =?us-ascii?Q?z4d9Evf421jartB/REceD/GTJelxD3zsnxYSxmh+REyJBFmMriISFM/ylSaV?=
 =?us-ascii?Q?OeJkSxFuvMPrAzygz7gwwNP0qrvQ/ZfgxYk16vzH7yjk9Jzg+D4HBPl0M92m?=
 =?us-ascii?Q?3hDFIlg6X9ZJKjsSz2PvrALga2ijCHowKqPs2xZjwAyUL7e2oz5ji8A/Z+yU?=
 =?us-ascii?Q?0yhSh/ddQlXr/NjdpdHNFAf/zodQqn0B01tJwj4jWxNl98QF9Aoraj0g4ijt?=
 =?us-ascii?Q?YUSBbCye4HdlSyMdpcX7mTmAfeBMgP18SDXvyNCkwit0E1BCGyDNoMETqInz?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ATKPyFO92diXcvf/zO0g06lSJWe0Ccvh+HVYmV3hSol1NVEhjhAoluMFL5SG/t74KzTaI55lfDu1PEo3eqr9rbSBEFo+akyjrSlqapBnYFHBeEYBzMkrOmrPpcfrSRp3WaIRUsagZBlYDrd27rv0pfyWavQo/fhP6IjcLJr8gSiBS5p4c6jc/h+69aWi0WWfNKN3N9Qyiq0XKo9Y/qb/mj06UwB8F5LFxLnlhE5qjK8xP4hLmlbO4y7EsdhVqqSkzAbCyvK1CAUaHfO3EHjl3Oe4c2upCLQdDTZLtf7tMzjuU55ug+f+I1dI4DMfK31vRI8hXAlVBap5Zab8/1VhIlZBaF+8goGTe6fSOYA7pTkQ6ngMRCSyrQALNMx5gCqcxyFzZTU2Bx85Z9V5WFEeCNFzlheCVbcWtI3xlSAWN3sNnICsujTW/oUuIJb7erLYZ0MVoIRaHOrHxcpcPCUlhcqjTUjKhrL4n0O+/Vaq1fY5CMXlGKmDLT70OJ3aC1ou8HVXXGvGDBKKeX5DMCtJuVY0C4bwk6NlH7IDd2smfkw4RImbDK+olDhLyuD3VF2+Ujmgt7ZUFGKSUGsKVAcav5WPMRfiShWuI8ckHyiZ4xA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e8c189-0746-4112-f4ea-08dddf4fa228
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 18:38:47.3464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3S/UemBE/NGbafk62SkVUdCO1yGcBAJMMPY17HbSOhUCPZK40mNFayv94EM56JiGkApp6w1jLJ5tMztShAEd9f0iJ/seutmkIJ1v4CvTfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190172
X-Authority-Analysis: v=2.4 cv=TNZFS0la c=1 sm=1 tr=0 ts=68a4c4bc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=EKZW0njy4faW57SyiQgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE3MiBTYWx0ZWRfX4SoLZYacVSpR
 GY1diwYAKYPtyCnaXFicQa6RrwW5wz9RKfwHtFOeX6B0npOQ1iN5LehGtLSuoip6oD00Rx1cUex
 sZojrW4/Qfy8EwOPUqslfaBynwyU25LQH7j7rY2QG1Ty4d2kTM89qiQcrOiI9jNKGDyFknljUn8
 DunzPPGYvJ2vLXC8NdksY5+7i/iIP4ja9hfkBfAajHYRWg2DHFNl36MLEOn/19pnolk14X1DhLh
 8nFCWaOWVs487U64WGA26WL5FsswbyWbKjBleXckg6QquoAM91lSVg7ouzeCzHtd/k0vqUPzk/w
 j/3dTnY8ETpgzNG70OOyRDUhPV12wB45YIupVdqgo9RKVe6hKd1WaZ2oiACk+m6s+OIpu+gqkGT
 +OE6q2pepXBYYD3LYAT8H867VNzW8DjwwOqaq27rnrCU5lkMzSC6/nA5wMB4LyQx/H2GMpt8
X-Proofpoint-GUID: m2PL-EkUPXDosW5TCFH1OhKhrnL5k6rS
X-Proofpoint-ORIG-GUID: m2PL-EkUPXDosW5TCFH1OhKhrnL5k6rS
X-Stat-Signature: uci8doo41a6tqfqp8t5krsi8i3jy6cj5
X-Rspam-User: 
X-Rspamd-Queue-Id: 78EAF180010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755628744-463182
X-HE-Meta: U2FsdGVkX1/3EsfYiORmNJjDD7MM7iXAyfc2PNZ0ZAzmVdWh9cHABERhL+qU4rTlqeNbfu2LXhcyzZjXKJ8OCiSJC5FWMyLY+L6l46uH2LVxdEH+Bv4ifX4w5NaowtDDCjZoBF0ZRHUmmlw3hnY3m3v5vUF8cTZlQoxiMF6/mL9Hap/jZOLha4tjbGdRJ0rsC89QfrNoN8aGH5oqz+5IqXy950bp5o0kuc653prNzvZOQwJ9I43Z01R7dWGvn4jtDIClwiqYhlH9OxZwJeDMLcKnUN4lu5xJALWEqJSVqb0fM3Tf+//5xVg/WZFv19M0bHlBASFHVjUzpYWfV2twZhvLAQvaDhI+8sQw5UWljzDVqWpsACDX6nEZR8CJD0adChPC/USNW19Zv3qHHB6QVl9vqTfbWCbtpKAeqYySM6KenVNyrtabQ8UjPwSCOCZbG+k+Igl37GE84qlzFJwsHuvTPFKQ+e8jSWNuuPbYQp4TU6Ml1FL1ViHHn8VBY5CkLQTb3iqpvaV/BO8ohCFuFg34CEGrFKeqLyXBmwG0xd2q1RDNKiSfVNgmXh9GNcCgMjKr9XS9Rloha/mhJkgPbYj0F9cQkbljHJ8KrSzCts3OcKHTVHu5K3AA2GI3gAQvCW8DgGnmzyPof3u0OnxxGvAnYoqHF2kfvJQNEHf8Q9Dzi3e7QPCHe5cemCM1ApmHnUJmEW65r9pewsHjM38jZH4VnEgGRntLSbUKavjGJF6Y1C9u993pYwg6IqvyfiNPRs/cWE8ThlwfbsCs74vMjuls0Cums/Zb/GJBPXKCeWCJnFv1w4X2cIvKacbH5lvKG/kIVGYU6vS9+ewrZuVZFupfqhTWbB6e9sXKIaPpjX0+PdiU2GATHcUlXQgW2VW46LPpMPZ9QzbDActfDjo88T9o/uIaHOBUs8ywG3GYiW7GDCpWqv333Oz2ULV42j99+hb15V96li4+V82mGnR
 6rwmSh+5
 x0mE3vOX4I6DDHW4h6jMkljcKNcCjTJeRiLvgTRfirjbHXreT4vYZvPWu4i2Twso6qC/HpF9w6NLRr+U4zmlTvHZYUZlZ9BxbWTOtYUPiCDAlPK9DKbs6bXJ5u5wk+nJAY2XhxaePdQeHNNnq+En/Eb3OoqZ3M2n2YfgxnlOow9xxo1HvkykZWt9myK623X/E7GcqrlXS8DUq8TLdx/KqyL/Jf6DpBAXBDKyk9hddprkAjmSaJ52VtIvNEXaBrwtYv1ey3h/t/dcXwph6W7NsIxqhBRvvRZ0/UmunxkFPW8DkDCSk/i3zRYNl7vxdItYllhbv2O9NOR+WJJoOZsyOTToBHR7fX7ZUlf9CtmmpfL/qNYZ444usPIuopOEXns0AYQsZlkEQP24ebXRYnx/s26Tr44sBbSvStsA0hiwKRDMc6J6td5fe/wuXR7fUp6ikhCUCGXdNBLRJ7m3Lu6sAlwx2FvvgGof6nTdmtGM4dq9AvcwxS7FwuraznoH5nHrAV9IS3LdTd2K4iWXrA8GlVH7H5GUmVXmJz1Tx6ROP8neZbVy0+y+XoiCHqb4SEae2/VhwiVGqH9UOECVvn+8Mpn1O238ZRJ6DdxN3/S92y1v68oBwquO41UfEkM2pVlp6fSw23+CRBwUsh86nfnXGqZoBwF1GUE1mzC0DUvCV37KjFflcyI9ZhHvY+iBuCaCxzsDcwsyr0iRUS8CZsjo6NHQPSgis/CKWSD1R+GwnxhB50LQpv8CncCRkgOveNlPC/mXjzLK8Ojf4sAG5JEIqK1BWoqUnJT1MLbOuZMmkLN7zfCwQrejaWtwde0PZNL1pO40Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:10:27PM -0400, Liam R. Howlett wrote:
> Create the new function tear_down_vmas() to remove a range of vmas.
> exit_mmap() will be removing all the vmas.
>
> This is necessary for future patches.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

This function is pure and complete insanity, but this change looks
good. Couple nits below.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mmap.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c4c315b480af7..0995a48b46d59 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
>  }
>  EXPORT_SYMBOL(vm_brk_flags);
>
> +static inline
> +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
> +		struct vm_area_struct *vma, unsigned long max)
> +{
> +	unsigned long nr_accounted = 0;
> +	int count = 0;
> +
> +	mmap_assert_write_locked(mm);
> +	vma_iter_set(vmi, vma->vm_end);
> +	do {
> +		if (vma->vm_flags & VM_ACCOUNT)
> +			nr_accounted += vma_pages(vma);
> +		vma_mark_detached(vma);
> +		remove_vma(vma);
> +		count++;
> +		cond_resched();
> +		vma = vma_next(vmi);
> +	} while (vma && vma->vm_end <= max);
> +
> +	BUG_ON(count != mm->map_count);

Can we make this a WARN_ON() or WARN_ON_ONCE() while we're at it?

> +	return nr_accounted;
> +}
> +
>  /* Release all mmaps. */
>  void exit_mmap(struct mm_struct *mm)
>  {
> @@ -1257,7 +1280,6 @@ void exit_mmap(struct mm_struct *mm)
>  	struct vm_area_struct *vma;
>  	unsigned long nr_accounted = 0;

No need to initialise this to 0 any more.

>  	VMA_ITERATOR(vmi, mm, 0);
> -	int count = 0;
>
>  	/* mm's last user has gone, and its about to be pulled down */
>  	mmu_notifier_release(mm);
> @@ -1297,18 +1319,7 @@ void exit_mmap(struct mm_struct *mm)
>  	 * enabled, without holding any MM locks besides the unreachable
>  	 * mmap_write_lock.
>  	 */
> -	vma_iter_set(&vmi, vma->vm_end);
> -	do {
> -		if (vma->vm_flags & VM_ACCOUNT)
> -			nr_accounted += vma_pages(vma);
> -		vma_mark_detached(vma);
> -		remove_vma(vma);
> -		count++;
> -		cond_resched();
> -		vma = vma_next(&vmi);
> -	} while (vma && likely(!xa_is_zero(vma)));
> -
> -	BUG_ON(count != mm->map_count);
> +	nr_accounted = tear_down_vmas(mm, &vmi, vma, ULONG_MAX);
>
>  destroy:
>  	__mt_destroy(&mm->mm_mt);
> --
> 2.47.2
>


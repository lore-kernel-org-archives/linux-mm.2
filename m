Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABD2C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2D88E0002; Mon,  4 Aug 2025 05:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953778E0001; Mon,  4 Aug 2025 05:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F40D8E0002; Mon,  4 Aug 2025 05:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCBE8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:02:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B95F05F125
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:02:06 +0000 (UTC)
X-FDA: 83738483052.10.0B05730
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E3DF180010
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:02:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j2C8G5l9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xm3GSUz+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754298123; a=rsa-sha256;
	cv=pass;
	b=KshZukt5oVI7q88tAMzmLeVyxUNobv/cjBEWd85COv8PEb7MSuNxz/VZJt7z4s9+UcjZnV
	T/SYsT1mlNpKVtah1jag5fgfM/16Hc2cTBHjqAyD8Ub6l97EtcR6IbRTjZiwEX8g7pcszS
	1wvQ5XnpSeunAxE3t1ID1HOZGLuuSp8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j2C8G5l9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xm3GSUz+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0V5rK1AF/xaAJYJhAMe08WVMCaLe6/g+296+ifuEQI=;
	b=KpgyeQGmGntcHVjTgG7UXqlsVX4cqLf8jBMP+8ZsbhJHWVktSZ6tCcpLYpfI/WetxZoLPz
	sAxbX02uYxc+U4n+hziNdOWs6uS/W3JocG7n7lDuO+BeeRWAVvnOhuDspKi9cnJHdif4u9
	pOQEzSjcqxnqD7iT1uSPSMtOd67hGLc=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747gBxw029420;
	Mon, 4 Aug 2025 09:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=d0V5rK1AF/xaAJYJhA
	Me08WVMCaLe6/g+296+ifuEQI=; b=j2C8G5l936RwxSeAfD1BwBjsdx5rQuyyYa
	BwE4zADnjTVsihLEgres9Jzf5vrHPxZYmWU8DM4chDoNjUcpaE12dQBSwOccSVxk
	NI62sdoJDVYNf8YK49hoDX7OL/WLbWQX5qUmHLxqwc1FpB0Pr9lwkx53uz+AAoZt
	XM8n2dZHluJFSht7YG63Kt94e9VCTBwOvlYdrkLlLLEWKyqkAdERjLhTj+0m7rWR
	Ohh4wfTemQF4wxJuzQta0TvHnynzsFcUqy+qjwB7HybRZoDxEO6AKjbvBbfwQ6Wb
	ZYn//SiH0p2JeCDR5fQWn0FGpaz455P1orZ6HebtLMjSPdNQdBeQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489ajdj6r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 09:01:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5746nLCm013574;
	Mon, 4 Aug 2025 09:01:58 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011063.outbound.protection.outlook.com [52.101.57.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7mr57pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 09:01:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4OTZdZbaYGsNOBMC1kdJGq5MZVBBJxIyKUp5I0mIS8syozTXA4Z7wqTMZRyu3M7JBQe2t2c5VXJPE4AM8y+S2xK0FVPFZzPU0ry3/WoIdl3J9PUnxu78KO7jJVkD9/IMtR5BIUlV03PG2CoyXeGQ2+rUqIOdeEdy9Gv5Kl5OcUCDe2rqm68DCa3ScdIHMbGjpcG2GW+YuarhOj+r3ZApY9JqgqaB/gti0ZJXod+/OsuSWl45vVE2zUIqOYGQYgPz3yI2GgjP+8KgVwhBXIsvMAjG/GpQWLJVGzxmjxt7tRMUxxaAPLAr3TRRpNfwxApx4FylY5nWeO4vvyqJyWPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0V5rK1AF/xaAJYJhAMe08WVMCaLe6/g+296+ifuEQI=;
 b=GZR66swn1M260jzMYRwFY4ZKWslgKrF3TqV8iEtCNSisY+eVTjpg7WSV2HJYl3OqIjCHyAJzcdLhl7AzbPY1x+eB8EB12Lo6fL9k/rU8+bq987gSQQuT5FphytgGuq0UTzWGs0J34WIc7KNzQu2PB6tIzKSFwi6fO768nhT42Z1WXkcqWEbTd3UmRBTlhiJP/T0rA3lIwX87028K5tB+AmKTmVIGuFiCTEvG/VaGYyKMXlpR1CVzbKrBSKtL1u9D6eNDc/k2SZ5LdX95M370Au1xCQrmsnDNK4Em6B6v8eoT0hq8W72dTsJFL7tHkBGZUmF+tQSrYEzpFRFhENs6pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0V5rK1AF/xaAJYJhAMe08WVMCaLe6/g+296+ifuEQI=;
 b=xm3GSUz+nL6pwTOgB0kG93e08D+VUEOy5qUn/vHFSmU9vt96bjaIQotd8Pjt4PD59LWcrkWtsKCzmSSf170Nai0Eub8uDucnaI7fFaXSoaJ8LI8GulhK2joDAIVJ3GzCum30OX+ihB11brkzOZ7Q49xKgAMk1J1uIrJlOf32yQM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW6PR10MB7638.namprd10.prod.outlook.com (2603:10b6:303:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 09:01:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 09:01:55 +0000
Date: Mon, 4 Aug 2025 18:01:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Li Qiong <liqiong@nfschina.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6] mm/slub: avoid accessing metadata when pointer is
 invalid in object_err()
Message-ID: <aJB2_p81GWhKIuGa@hyeyoo>
References: <20250804025759.382343-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804025759.382343-1-liqiong@nfschina.com>
X-ClientProxiedBy: SEWP216CA0020.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW6PR10MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: 2567ccb2-b388-408a-9c94-08ddd3358fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l0CooW5pc2/fGozC0LOSa08P2RBk3+mvc19baPzEVo0qRurCl90veyU9Ohye?=
 =?us-ascii?Q?j4fqOZ6YP+0bPX3TrNcVZCW2it+scnNDSlFLKSRKEm0p6KOTNcoYZYXbnuFw?=
 =?us-ascii?Q?lPh2F/lpspa3A0yNAV/BfO8O5E+f7LfjIVje/NDNs6ps4eYvfbEliByetlO8?=
 =?us-ascii?Q?cYV6ZdNxn2JTjrmBLpyKG8Ip/kFOWmh6Ej5gHDR+/B5Agit+KhnHAsuSXWF2?=
 =?us-ascii?Q?eCQ8+JleB3KbuCRQj6OKW5XM/C9g4qMAlyYMCgwn57hrdORXzx3mNI/akkyj?=
 =?us-ascii?Q?LQ1jCBy8oUyEowj3/rGSZCK2qOaP3kfvyUH/QEgb5/cQAha3DzrsCL4JnKiU?=
 =?us-ascii?Q?EDNOIuBGM4X7U/Q7KoVdAQ1taYhTJk+M9OJmAjntOHfvXS67w+q4aPKJ64NW?=
 =?us-ascii?Q?ugxXM/MbNFsAWk6PEaoKA1u1LWjX5BfyFuY6HGsd7JOCnhxYzb9mvCpHHGbg?=
 =?us-ascii?Q?JUEl6p5EBC6f75aq9FsBliUrSHEXPsuv40h5ad2hanPzEbFmlfl+v/Ziy1HI?=
 =?us-ascii?Q?Z5pvB19z+AU4rodOI+4M9Vl7c6psHslaD1TKY9CrnrqEr7onvBpauc4OpwNn?=
 =?us-ascii?Q?4Qd/OYCB1jhTwNUW2CNSSpgGUvgdzoO5OIIekUbL3NmJ/aoFG8DC0fqAkXrG?=
 =?us-ascii?Q?UdAjlfxVbvdryo21OTmXpVwN9yt/yhGftKnhezqFi79lSpJDYw86tBRiqSUm?=
 =?us-ascii?Q?JA4mOLjr9WnnHoavwVDIosH3moScMAEPgMwWqqMp7WKJC8hf+7QV48F9L/zK?=
 =?us-ascii?Q?4kgdBQqLaz+D7dDjoQqXllkrXMftpH1nqQ5TFh4IhsGPeSKJMYsbHUaoq3jA?=
 =?us-ascii?Q?2BP6mytGoYVekuNPdDcStdZ3iePDwtaJVhHgxoSLuenpzoMDQ5brMHD4CPIt?=
 =?us-ascii?Q?qOaXOFRVCxKY7BDDdAgf6v9KeH9mu//130bGTyoXaPoBQwGI3CZcJakXbB6n?=
 =?us-ascii?Q?8C9BpJY/FlPy+WivQ389SlBPKr5B1tdLyEioiyVYPnME2l3ANQJV53cU/D0e?=
 =?us-ascii?Q?Cmo82KqydkW1MCMRmpYxgmMqCCXSO//ZtzWDWSdMq2LlEDuUA+h0QRDNRQAQ?=
 =?us-ascii?Q?OelOE01IAWOOZiqv5QHjf3HuvGKBqlIU3ldxbeXarQgEeHEDukuwwg+32Mmt?=
 =?us-ascii?Q?RUSXo5N02u5Oduo8/GxRBvd6TSUXE1y21boE6XRlAN8fhn1natv1Rr9orgm+?=
 =?us-ascii?Q?0lO841Tge7fMoteqYNto6kNGE6XY3fdyCyzjdoj372gm424jP29qafrn/e4e?=
 =?us-ascii?Q?x926UA7hM9lc45bYvZRAgsYgf6SzllzwyUG7mQ1f61+K064CQUmKPm5FwUxE?=
 =?us-ascii?Q?x7vmqr12M2PDNwiotYdm0HwiSZ1YOZOLq/o2uZ621S0P0cJsCXLRqWC8PfCa?=
 =?us-ascii?Q?GGvQVO8o+2Nf81GCQDxmwSLwmQduvQ+hTaUtQ8nl7z9bv0odEYcWAy9iWSOI?=
 =?us-ascii?Q?BkqFZL2RfBM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lQ48BG+GA+jAu5HMDuverSyx4fIafeZfdvvbxNQSG1CbBNTkPgPr7E/NFGcj?=
 =?us-ascii?Q?W1kWTbbzXJY3wl2pCtXbZM+mR+7rTYVV/IhnSf3v/q4jXT76lovJ8L1BW8Te?=
 =?us-ascii?Q?zd9kgbVsS3pTV4N4NqoikY4zgzUg/K1gPGUvkgUxdeU3gKg2hE8mLPNa3lc7?=
 =?us-ascii?Q?uME+SYfC9Mj+TYOb1vPvfmwfODQePpF2GS6ZokSxgHJruwbRmniJeFYHiEo+?=
 =?us-ascii?Q?mf1Q2v9P4+W9idQHWJAOqABr7bHQIEBuxLJ4B+SwIZJtsi21ivBcsRDTFHMz?=
 =?us-ascii?Q?+EHLQZV8BU91kxrl9cD/8uS69myJTunz0FId9QAvwRUC7MJiEc3V6oOoSCNL?=
 =?us-ascii?Q?MHvz4V5FerTSC+GJPVup7fpE+HV4SmoXoLb24/OiQ60cMubWLqJveWV9w+4t?=
 =?us-ascii?Q?XLk8FYkUPlv95AZuBO2UfwJlkFpLGn/BoN/hixzegTX/amZwmsR+UPLas+Bj?=
 =?us-ascii?Q?9h9EN4pf2Io2UA4QGjpeevh2jiYrwKHS6w05krv+m1AhWLwDzpVq8uIwx4Kt?=
 =?us-ascii?Q?DKhEFqzkC8tSLKk0i8j3wd5G7OOHs4qXb9fDrqoLqA7v8+eNG/uPc299EdfX?=
 =?us-ascii?Q?sea1SsEkij+amhZGx0Pd9j9LPhFsR/BAlaRy7A8KQUIJGGzU0WG+AbgS4QP2?=
 =?us-ascii?Q?FSH1gA45jC5kRf5LFY3avLn2DtpS2GVVTMMLployz73GxDhED1v5RcqVK1df?=
 =?us-ascii?Q?VCF3zX0UIPSun+7tynhSAUpTGq/bUYvsHReDV2HTfMW90u2CsRf2WTNhrLIc?=
 =?us-ascii?Q?q6MdWnxf8bOk+rBUbT5rl0AWKSN4u7xLqC4rjwW/STdbAmsmOCv0enptGkEH?=
 =?us-ascii?Q?OVU5KPntpda9Kqs4TcdRvwWux5pSRseNCVhNIDirfxxGup+xKnrjHEWRsQ7v?=
 =?us-ascii?Q?RtJMZTU9dSvUIO/lIg6hS53prktp/gZ3nD/6EKzqTavGAd0eoRYcvzBpzHAb?=
 =?us-ascii?Q?G6L8hZGAy7PJGzSwoz8Ihm+34embE6vPs2NWAuirAyErp6OwA92eeU/ubFna?=
 =?us-ascii?Q?SiE1OpB23ejNnmowQNcLiN5KpqdXweHe65fA39S9ztGqP7JbS5X4N3PO6uAe?=
 =?us-ascii?Q?kHVLY6kpxlOZUH8+P09p7VAeFuE0FMemPVdkWSsX9iXtpqSvRl3/YSWPtyup?=
 =?us-ascii?Q?P2ySYpi8kBACOSVpMHyTzhbF5sUnRl4sJPKIOqgRh8CoPzs/hJv8TFlrfC5Q?=
 =?us-ascii?Q?3nfswx6uVaeNdA517yyrztUju0+LQPOXgK5lM9kJtls47BE81VPZ1evlEicv?=
 =?us-ascii?Q?e9I3NtMLNgBxAwlDAq+ZBbx/ba66RNhRzHoom2MHCLkTDc/YJ1gc3cDGJjmd?=
 =?us-ascii?Q?QGbMfvzHcFq+7K8gukn7inI7Sna8OIf741Zpmfp0K/nhrVTr5bunPIjz00xT?=
 =?us-ascii?Q?2oBlWXrQKdxCJlakfPq5UY2CRaZk1D1lkU2JrJDVsl9huqmgeGJZvTa/FeI/?=
 =?us-ascii?Q?x/fqK1uz2o/90D6eLB2zrHNBF85UaMnQ0hz1RihbsXcW758MlCO9GSfms0TA?=
 =?us-ascii?Q?3jcRlVIIH56wZYSrLtzAZUFxx9Mdcyp9USZcOHZCstDDFGxebt9QsfyH4APT?=
 =?us-ascii?Q?Gsow9e/kKNJZQ0fLHolbsTiwOx7RU+3PYXk9zlxE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PRtSfAzLDRQeg7o7lo7OEFKOw9VN5FKuuk9AykCuoo/hYznxq4SGsrJrewzynWvaL86ZVlsBNXjU/DyF4sjdMulWG6dbDcQ7NZq5Cj757JZYA8f1MosT1eyXnW9i38rlolH1Q3xI9VIWdc6WxvsvkOSfz/xDt9kGZ2tIap2CvBTXxEclyTr9yU20909ReoR04oDpRCknOJvFpXIHmj5Ntj1B+4FJrWmIHnp/XtQkYQPTwEhzB9sCZ+DrP6sgdHPIKjL1FAHlh8CCTBFLAiE8J39lIpFuqLmcpWbyzqSfQdHMUNKfnpL+2Y8gIXqWDR8Jfc55lkaqL/JQO/jigDR/Y4hn9gkUBNJd/UWgJixeU4NR0pwxa+Gdjol7Q0ItDi8jJNBK3Igd/16zzTax7qVB7qsD5PaiCa/vc9yN/0Gwx3RjgphwgXmRWx73PB3KbMPFzsHdCtB5KnyzdOvMZMgxZRoJTGzzAo2JzjCREbEoEVh01iSkXqO0GA1OP5Av4AW57+oTYVUN9HyGISQeqwZ0jztqp9F/LZWBPy17xgj46p5u3hWaXwWKCeY9/BWYLYfx7NtEuzFse8WSWWBQ9aBcqwTaEf4Vhy2hZG+l5oQfwsk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2567ccb2-b388-408a-9c94-08ddd3358fac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 09:01:55.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/QwdpV/xEtpEeaYjiQuX+7z52DaKH1Dkuc7PgCyjhnbv2/cOMdzodEdhkcCEaC43Is2KqHpdqetGRoZMYcNmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040048
X-Proofpoint-GUID: 0Xce52vPcakWu0Cz5DGd9QUI9W9T46mC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0OCBTYWx0ZWRfX4U3xxAVbQ8WY
 ReVY1mKiPSX5Ghkj18hkS9ckCK8wuWAsH+r6jPw9onGs5mxcx4QGQhnLESsSZYUIB/HRCzSEZGI
 x3FmPYYUiWpUkehBGVzSK8a1h+h1oazcSSambiS4z1m39oRTXE6srEbtOZuFkemxovevO8qdZFk
 HyiB6u+SiYEbOMX2j1Y9zkHsLbHjRcIU2ULR+WHCoImIB8YG8+SV5g3i0jfxHoyofKvQXetx5LC
 i3yuvNLr3qV4epDkMmrUU99BzYDXEkXA1e5LUZIlaX6hUB1+uQ36KviwmkeFyFlNj79kaaXqPrL
 sG4gPLGEF7Q+Ij69tI73TzLe2JnyHQUmWLMLv9qw2040LtWbRymO41xKXKd7RyaYomIeq2AMULA
 YT3UhvEk3XH+RSR6CzrQVvCnSEKCXFTmd4fmIE3rZBS/7kDSw3f9XfAspIi3yE5p3JvLjNPg
X-Proofpoint-ORIG-GUID: 0Xce52vPcakWu0Cz5DGd9QUI9W9T46mC
X-Authority-Analysis: v=2.4 cv=FIobx/os c=1 sm=1 tr=0 ts=68907707 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=SlVAvriTAAAA:8
 a=yPCof4ZbAAAA:8 a=95r7aR4FhjnzYnCyAq4A:9 a=CjuIK1q_8ugA:10
 a=qesGs21RGGeVIEdTuB6w:22 cc=ntf awl=host:13596
X-Rspamd-Queue-Id: 2E3DF180010
X-Stat-Signature: 3t4k37n7sknx111sq7zqxqtc7j8hkc4g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754298122-369612
X-HE-Meta: U2FsdGVkX1+NucygzjEbt3r8X5F4AZzSbU5ksQGUt9lvkviIyW/OM3GXTKp2RDkFSChY43ERrncMq9fco01ifBrNOfgKjMeF8T3yh2sKUIzfHbdVV4V22JYx1amAgosQGSLeFtKsWLke8B1Ns2ZrNkuOfe0/q+6H/8lHTjrHrPbAycpdb/zalwFFHv+t3D/fzQB0PyF2aoHPwFisP1KyF8DRrXWXmEDdDjlCu55F71e37n0jG7zeraIJr+a7m+ezVGulCe3H0I3cJm342aBgqTdiM3LoT8sCY6V1Xu1WyyGti8L82jdlaPaAa0nAE2+yIGGZz5c1VhqZ216WtpOdJt01rDJkRdEzLrQ7tT9kK+XxIcsXnrdM9ao5L714UunlTFaAfX0eKYacOiXpz++fnRjSzM9qZrf7q9QZcpq79DT0cjV+jd6Q9TWHb/EMN9O9Oz1ijKYOkTKBvg9r/g2jSEt4TaHJvmez5y6eN/j1opaKlGkvelQ2UEPEVeD2F+rv2OzVDhRgJ+9LQw1KcrANILcbEtxyDK3iirkQuu51urgOgOjW9nUr8c67ZkEBRCYG3z9cZQ40SSeLQ37XsaCzQiBJOZNnwkLe5UwtiMkclZ+ff85nv1hiVrUpYBf5WxO2mKTMDLy182NN8lNAMBsVPz6eQa0ACUvopLKZAqlkf11ORVDZIU8jFAV0qnz103MI3Qa1iOqNAz0IlZRjN3uRB89/CmHBd00qoVEAq9DYfCtsk2uOXZaE07fxZWOqzDaOJQRz9F1tGSvZngYw4Ho0mrn5Ts8jlv+eznIScBrKml3U0JXNCQRpGZlIkrvycyN/u/a0xGS3LuCFbiHIUlxpXZA0tS7I0D/KWM9TwaszML8k15vpnlssTIDemzr1NXu/yd4O9K1POllbnKmF6zdwcYMXgUrhQnh/PC5Hk0KNh/useg1Rx3ZPjiG7n1imkFCu3lm4FO9wPeZAsRQq/HL
 UQxJ2O5W
 v58GxHrHfLJDIRN+DHNAj1fXmXoDfvZ9/g9qdedlO++mK2pWR34vy8DJi8r1AHD/oRx1x0qDA3TiU/QOFJZ8QIGLsWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 10:57:59AM +0800, Li Qiong wrote:
> object_err() reports details of an object for further debugging, such as
> the freelist pointer, redzone, etc. However, if the pointer is invalid,
> attempting to access object metadata can lead to a crash since it does
> not point to a valid object.
> 
> In case the pointer is NULL or check_valid_pointer() returns false for
> the pointer, only print the pointer value and skip accessing metadata.
> 
> Fixes: 81819f0fc828 ("SLUB core")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
> v2:
> - rephrase the commit message, add comment for object_err().
> v3:
> - check object pointer in object_err().
> v4:
> - restore changes in alloc_consistency_checks().
> v5:
> - rephrase message, fix code style.
> v6:
> - add checking 'object' if NULL.
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 31e11ef256f9..972cf2bb2ee6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1104,7 +1104,12 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
>  		return;
>  
>  	slab_bug(s, reason);
> -	print_trailer(s, slab, object);
> +	if (!object || !check_valid_pointer(s, slab, object)) {
> +		print_slab_info(slab);
> +		pr_err("Invalid pointer 0x%p\n", object);
> +	} else {
> +		print_trailer(s, slab, object);
> +	}
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  
>  	WARN_ON(1);
> -- 
> 2.30.2
> 

-- 
Cheers,
Harry / Hyeonggon


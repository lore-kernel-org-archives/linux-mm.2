Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D23C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978BC900066; Wed, 13 Aug 2025 08:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9502A900044; Wed, 13 Aug 2025 08:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F11D900066; Wed, 13 Aug 2025 08:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6961A900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:21:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03511C035C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:21:07 +0000 (UTC)
X-FDA: 83771643816.23.5A18BC1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 94E3540008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:21:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="W//MyNnJ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ItidQVQg;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755087664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4F4mfFlRMk635TtknBlx65hw7R42ig2WT/BP4yVFw4=;
	b=4eQi/sD1OTLmClK6sGjPXwFo9nqtIzmGigwHPLsR1i/EyMvA9O/g551YrvlGPnhcJ5LfBh
	62UpfM0E0vck6ZCG7WZDIW4EB8ELj6do6csPZ0m6lz67D5CtexEZDw90DNn+73LQd47AWY
	81tc045zbY/BhvQ+SKIn+UZk7j4jacs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="W//MyNnJ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ItidQVQg;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755087664; a=rsa-sha256;
	cv=pass;
	b=GIZyH5vyUw12ztz8VigwpHRz5NMvXzIslcnKm3Ok090WbXgz1ZHvUvyAIXc8evWoMaAj8Y
	bnu0dpeW5VIh6vVpOSBla5jhu9iN47P/Nb4KKeMnOK/AZCgWrWDSWO0O6hDf62Xi+E9WF6
	punqMWcTBonFVvA0jfQ/secFJiCSoLY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DAMv0o011674;
	Wed, 13 Aug 2025 12:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t4F4mfFlRMk635TtknBlx65hw7R42ig2WT/BP4yVFw4=; b=
	W//MyNnJV4OZVdJSDepXwcdN2C9LNbd69H03yetX2bCtOvprsS1lFP+VgjmJ9oXF
	XUW+Ynfw4RVFDu/u84GKpVK/xOT7X0NLVbheliGZ44phnpj2xmSSmF9y2WMPS/MX
	zHiBFxdgGAfNnohiFqXVXmx0JqcSgcgMs9YZS5ob/mWU9ZxcpL20LfECn9rtjUAr
	v+pktyk+8RFLjuDkDXjz0nrSfXveYwrNJpFQ7Z5Zlq0i1JYOPD/YZIVrq3fEOotr
	kZVBLj3IDrrLkyHYBHgNs5k6vIcEM6lGCRiy3uvpzVjVTxomyBmPC5Z6T9ZOlLcH
	Gxp3Wv8EgWx2ODzkRAItSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44ydfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 12:20:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DBviCj029911;
	Wed, 13 Aug 2025 12:20:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbbahf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 12:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfWMLNNwPbprLeQ/zu8QDqNuk6Swo25X0kdUDOfihTfK8AfLk+bowONlOJXk00uVNoFuASm4VruoznRYDgYhn8qrAk6s3BLt/XdxxWO12r6LoUS6LdI1NniaWP1vJ7sXsIRxg7o67+dqns9XQkjayE0ytJ71gANhIdyXFfopXA6R7jVd+p9SyVsNfuPzLQnQS1Gqxp/F6v/lHx+nbPG4IwZvk27VFqKzB9aQeBB7gqEB4vzAW6e1Bk7ODYV93UlyI6gGPBFhuX9Mb3D5x6PGk94VqHPA3BRlMn9/FVq3orB/dghK7iY66OD4RJTItZDhGU7fg23HOZPpN+/lmRVROg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4F4mfFlRMk635TtknBlx65hw7R42ig2WT/BP4yVFw4=;
 b=ixfptYsil92zBQ4B9RYCJIJiH1OjgxL4dXla7v3UTb5YSUmMQ5iqhQbG8o/T4GCfzJ3K4uJOvoY9rJCfERGKyg+YQYZFKOGsWKSUXmrtYWB6cCFgWA1KVhmee6LmWVfgLph/oXrm5q0cGreZmza5zKlGQ9uE1nG1NHVEFKHtMdRQHKrSx784+57mbYw8SO/BOJN9Sywr2b299NOB0HDZZX9EskjbAoRAJTqAlq8k5rLtgwfrlx4VCgcCkJbe7eEq5uq3V/T6l5M7d1q09lFGW+JPVP7S30uW2u4AhR5VZw4JTyltoIiJRlzIGEkpzGLk7sHglsP2h7SJxybYJs9ByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4F4mfFlRMk635TtknBlx65hw7R42ig2WT/BP4yVFw4=;
 b=ItidQVQgOA3K3ovvG106uC1P/I+F6rQwUFxEmuc/cn3UbloRRrhQgOFbh545S8Q1VD3P5D3CANqbTnTO6yiIKHELHW8/XTK6BDwRU986LGeQ4LLaa4yDayZ+IJq+PK9I24T/WLlHM/9UT4djuo20a1WzIecIRF2nWUTcpxuh7ew=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 LV8PR10MB7991.namprd10.prod.outlook.com (2603:10b6:408:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 12:20:53 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%7]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 12:20:53 +0000
Date: Wed, 13 Aug 2025 21:20:17 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Ryan Roberts <ryan.roberts@arm.com>, Peter Xu <peterx@redhat.com>,
        =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
Message-ID: <aJyDAX8bHZCp93Dq@hyeyoo>
References: <689bb893.050a0220.7f033.013a.GAE@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <689bb893.050a0220.7f033.013a.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0087.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bf::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|LV8PR10MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: 355039d6-ac10-4c49-a586-08ddda63cbf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MURlUDI2a2dSa1ZvL2VpYkdhUW9SZ29WUmF6SlpGalVsQm9vTnMyNi90WWt1?=
 =?utf-8?B?VkZjL0ZMSlFLdzJ5azd1Q1JjVkZGR3NqL3JUbkJBa1ovaXlKVHBHeUtLeU1S?=
 =?utf-8?B?VWpIWldsamQrcU1rVVZORGFyM2NzWmZhbGlkdURtc0h1ZFFra1VwbjVCSWdo?=
 =?utf-8?B?c2ZqVEZockRTWXBjRWRQNnppS3hYYUVyUGV6RlVwbHBmZmZuZ0s0aWtFT3hk?=
 =?utf-8?B?aHQ4N3E4bHRvVGlaYTI1dnl1YXR5UDQ3eW9QMzJnWWRmRjVBR00xNmNpRHlv?=
 =?utf-8?B?UDRVTXNlcGYydTRyaDQzd2w0WkQrYW42U1h3ZGdBZS9YTllUWWtORjdydDZX?=
 =?utf-8?B?aVllMnZnS0w1T0RFN0UzeC8xRVg0UkVBeXFiZWJxd1Q4SGJNTFZiSjgreFFn?=
 =?utf-8?B?T25JcXlJek9UckQxR2d4SjBFc0s1Qjg5R3RvWFhlaHJTVDRpdm1VazVoWlMz?=
 =?utf-8?B?UzBrTjFadjd0UmhDdW9wQ1dXTnBRWDNRYmZqSXVQS01yQnJET1JiWGdxeHha?=
 =?utf-8?B?SENuTWd6L2gza2pSWnM3bDB3V0J5UTlOTzVPME1rSGZBblVJSzNCemxVVEk3?=
 =?utf-8?B?bVVkYUZIaFF1aVIyUGRXUUJ0NFlxQ1FJWmJQRmtPa1NvcGJZUGRaVGF1MmtE?=
 =?utf-8?B?K0pmUGJwc2lqNVJneTUwdmdIcmRUSVgzM01aZ2piOGxabkJ5N1hzK0F0YkRz?=
 =?utf-8?B?NlR4NE4yZ3RsQkt2akxFWFMzMU01OTlQc1VndUJJS1YwNGo1bnNUbGtLYmdB?=
 =?utf-8?B?a3dTbzBxWGVPSFhQZWRuemZtaCsxNGNVM21hZkJwWTRSMnBGUVdvRkhpUnlr?=
 =?utf-8?B?YVhLTnl4a24rOXNsMHRaQTdoUHdGZCtleWJPbGNhWXZmLzdtUUdwLzZYa3Jz?=
 =?utf-8?B?NmdEWXkxa3p2WUY1QUJGdmMrOExEeERsUlpSd3RMV3JpOGFQSkFOdkFrY0Zw?=
 =?utf-8?B?czJZS25GVnFQcnlRK2loeWF2RkczRCtMVGFzcS9ydENCVkdqVmJkQnZGTG5i?=
 =?utf-8?B?OThkTUNNSmh1TXJIc1lRTXVrWWNaOEZVSTZ2SHJEUCtSTnFnclZGaEFRUnV5?=
 =?utf-8?B?ODVZUUdxTHg5bHVsaVBMbWVRMnJUY2pPY3NDZlVGbzZiMGdqa2h0Y05YT3R0?=
 =?utf-8?B?RTFreHNZZGFZajRmSjFBaHV3TXlJSzBsRUlSWHZUYXEvR25iQU9sSVI3eHM4?=
 =?utf-8?B?bVlVZGsyTmFwaDkrQTFmaXdOd2dXQ3ZDL0dBT3Fkek1hL21zaG1pTzRjR05o?=
 =?utf-8?B?WU9NNHVHL1c3WmdUSWxMWXJKRThKSGhVT1oraTBKQjhYTmVvRit3ajdIbXdo?=
 =?utf-8?B?bWFRb2lQODBzeklUT0ltc1h3Z2tERDNqMEE2OHdFT0NpdFhsTFFQK3g3Rkcw?=
 =?utf-8?B?RDBFSzRLaW5UdDhZT1ltZGNkRVdzMktUK3ZlUU5kZm5LWWN6bzBmQ1lFQjIz?=
 =?utf-8?B?ZnlhS3lXaTVibGZ1bzNHSFJLRU5KQTJJTTJFbG5DZ0hCRDkxWjlRTjV2QkxY?=
 =?utf-8?B?ajJ4OVF4MGRiajZTeSttUTVsSk1TZ0FlS1FjNVV5MUVzOVArVGF0VWx0R0dl?=
 =?utf-8?B?ZHBhekdIVCt5a0hVbGZNZXVtdUVUOVphbW1Zc2VMeVRuTFdZdS83a0hjTmMz?=
 =?utf-8?B?cmdMVGtjd1BkanUvWWpUQXI0MlhSbEpRSkpYSy9rNXAra2lacVl6aUZ1NVFL?=
 =?utf-8?B?aTNITG1yM3NLdm1BU2wraEhrZ1FOeC8vRS9sWTBQL25wMkR5MllveE9jZklw?=
 =?utf-8?B?NDZobVJMUU9IbGJNQ2h1WnNYNXZadUtEVWVOeDRzTlZFSkpJak1hUjR3MFRS?=
 =?utf-8?B?R3ZQcFN6Y210bUxNWlhBK3I1Njhub1N0Rk13UVNkTFNseXhKQlp0TG5XYVNI?=
 =?utf-8?Q?u1gZf3opBcyVC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEdFMkJBVDZKTkd5NGJWeXh2ek9MdVJJNUZNTVlGS0xGTDF4M01vY05tejRS?=
 =?utf-8?B?aVcyY3NicXBGRkpRYmF0ZGZYNjF5L0o4Vlp4WkFFYkU0NTJUME5uS3ZuS05T?=
 =?utf-8?B?Y1kxTldzUDEwNzBaOEwrQUUxSjduYkZSTE5Eb056NHhQWC93RFAwanlKSG9h?=
 =?utf-8?B?SnFDbTBhWTBodmx5ZFh3SUMrdFdxTENMbERxaFhrOFhEOTR2TGVlSCsySjcw?=
 =?utf-8?B?MlQvcjhKZjlncHA3V3pnU0xRUC9TeVVheGdOQXZhS2NjMCtyTlVDQnUyNnN6?=
 =?utf-8?B?c3Brcm1IelgyYzRLY0pyVExReExxNCtKV09ra0FIdDBBMm9ZMzBLazZnNjhI?=
 =?utf-8?B?Tk9Qa3p5TklpTVhsUlErYjNjYUI3SllHc3cvaWFrVUJJUEd3ZmdzMTJ0YU9M?=
 =?utf-8?B?bXBsZFVkUTZxbCtDRU5SNGdZdVp2YWVxNE1TSUtxbkZCenI2SEI3Z0gzOXow?=
 =?utf-8?B?MktReFFBQnlzb3hHSUY5TGpydk5UMUE3VFowakFXSkZrV2lYNktpbG93TjQx?=
 =?utf-8?B?b3R4ZlREQ1RlUWZ6ME5POVZTTGVUR283Z3pxVWt1Zkk1M0ZiZnoyY2VyeTk4?=
 =?utf-8?B?Q0k5VkpUSjlMSkFoRnVrRFdFWVZNS2FXM1VEdTU4L2VoeG1vZXdadDY2QTl1?=
 =?utf-8?B?elJYRTlLUy9aWDV5YUJndWxxQXV3N2pMdVRZZFA3ZzFKNjZPZWdwNEgvOHlx?=
 =?utf-8?B?cUVzK0pnamI0VmJOMU9LeTZhRVliR0VxSERsZi85TUhkdVlWNlpCdGVvb0Ni?=
 =?utf-8?B?RkZBMExrUEM4UWZvK2YxNC96eXY5WUVIb3pPZGp6eGlGYk9OMEkyTFk3bVow?=
 =?utf-8?B?U1cwN1NKM1p2SDRPd05jRWgyTHJRSGdzcDBOYm5KVmJTRWNRYlpURnBEVVdV?=
 =?utf-8?B?dzhyTk1Xd1BJSVFrancyMGJINW5XRXVGNXg4NFFMdDdVMFllbHVIbm5mbjZU?=
 =?utf-8?B?L3RCNERMVnhNSU5nTWttTWY1WXFQN3lLcWxTdEtmNHd1dkRGaEoxZ3NiU1U1?=
 =?utf-8?B?WHJyN0pSRE1EbEtkNTV4eGk0ZG1USVZUcTRjOHBmUTdraXZvaGR1cXUvRVhz?=
 =?utf-8?B?aXBvVzhHcXJXRzBmTkJZS1V3ZG42STVwd0xjeE9pQzhYWmFYcEEwQzFzMUtZ?=
 =?utf-8?B?Qnp5c09QbzJLeDU5ZlJubUVFS0NKaW1pM2tGRU9uREdETTdCZW1qZm8yRjhE?=
 =?utf-8?B?OGJDd2tGMks3Nms0MS9kKzMyN0E3RklFRnlJWHJ5YVRjeEMwdnliSm13NVFz?=
 =?utf-8?B?ZmxMV1Ricnh2UmZMdUJtNEsvK3d4cG15cGV4UkZyRUU2Wmg2M1NYS1YrRmNI?=
 =?utf-8?B?bW5MQmVzOVI5MHlWRmZYTDU5ZlVjd0tQNStxM2IxU2VLM0paUzdmMzlWZnlp?=
 =?utf-8?B?QUErTmxBRTVEc285UXRIRFhBVndzeTBQMEZxdllxTzhmNjFrNUNkZkE3azhp?=
 =?utf-8?B?MlJkQThWVUtaRjM1UG1QWDdDeUFuOEpUWnNDcExtbGFCTzk1MHgwNWx5K3dk?=
 =?utf-8?B?SmltaklrNkZFZ3pSWW50Zitua1NJUkY4VGxrRDU2U3VxemFsbE55YzcxcmJG?=
 =?utf-8?B?WVUyeFVXc2ViOVRKdG5ZUlEzNFoyRytVdUNkMHZ0S2FSUjB3bnMrUTFxbTNv?=
 =?utf-8?B?dXpvYllvZ2tnNHBERnpUb2xBTlJCUDA5Ukp5ZXlpRG9QR1UxSmNib1l3bFN3?=
 =?utf-8?B?U0hBZndFRXJEcjRPT0dPK1V1aEJ5TFU5MFg2bkhYWW9nN3hiSyt6UlkvM0tx?=
 =?utf-8?B?WmxQM3NqUmowSlhuRmpIRlNtbDRndVdJbFhSSml5aWdvY3hsQ1RmVG1TMFJj?=
 =?utf-8?B?QUFBZmpkVkI5LzZCMDZwU1NpdytieHNPMVBzRjJmait1dE1xUHZQYzlsYklZ?=
 =?utf-8?B?dHFhTlQ5ZWFORmhZT3p0d1h4NGRURWFNaHdjTEZQS2pLUm9aNS9KdGUvMUdY?=
 =?utf-8?B?ZkliRGpobFhGd2g3MVgyaGhJNVlRQUtXNE5IdFgxOWZMaTRLcXRMUXhqMkNo?=
 =?utf-8?B?MDBKS1gra1JsUVBpQmVwS2F3a0Z4cTFWS05jaG4yTUxDNUVQR2g5QWJTeDhq?=
 =?utf-8?B?ekRZT1NaQnh2WEhYYkpacUtUcVBmWUtjLzh3dm9YeEdZbEFUU0oxaWs4YVBw?=
 =?utf-8?Q?SRC9Cx6H9bOr478O5IaBBc4tE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lcgJS1OC5p8pS3JN1AogPPDI1iKz4NaqkLOq59SJlZfZN39h5B7d0FCYt8bDkKwpJVqPucLvOdng2xdMD5kVaxB3ujQQBDlhlGnCntnngIZjCc85qiGoEWQYMCjXck1n7j6tUia6FzzbQjBR2ZNiizrVE/ZVDSLmdeWZDE+FEYVjrB3O4VG0qA3kjZIMk0U+JtrtgN0sudFWg3JORqvb6LPg3NRTpmcI8UXJlARv3CjAt4TwvrYvAGnu8ePjZI32RzvX6kAnWSCCGtnfuYy7+Ler4+qeZl3cMxBoU6KibEuxy2ZkB1ndtcER7FmO8k/N/018fvh5c7ISXnsFKoVVMTlqcDq5SHa/rnC8PhwNZ6De2oYzaDIhNi8ZNWaZOekGlW+4OiHjNAxdD3ZLccJNTIG2X2814eRI0V9IsMk+7EGpTYVtR1bTi09OJFQZyKb71/+dGbanZTXjFnzPDyCdj9Ft1KJu6fXK5HD3Kr1PB4ek9ku986KlqeN2NyCbdw2/5QW1BH9jkwBK0xrs/k47cGqGcZvqezeRsrBT4FkmaAHdusS7StAiiuExYkwapIBrsQxjnFp7FiPdjUVFaUTMNUYk5c31x4fzTB6PFVsbgD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355039d6-ac10-4c49-a586-08ddda63cbf4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 12:20:53.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Gmrwa+b9a0Knwy8NEvqaptUGjZVpz2ISYUiC3G43hXHdSbq1wjegTEqpd0rNqOi7R+PrN8ujvKl9yqNBaRuoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130116
X-Proofpoint-ORIG-GUID: Q6mudqjl75yHskG0OStSrSn-0maKsWLY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDExNiBTYWx0ZWRfXwX/srSA87Ea7
 ZGqDe5xhMg0oUV5kYMfDFaO71nGGjc8OYG9fmjpYvjlNghNUiiZ2EfodNF9uxfZ2LkD/89VzNus
 99Cb844E6n7nZgWBDf1vVlWzSG6a3c91vDmj32OhOCscVgGao2IEHrmuUtfWvROwUuG518i7Kea
 5W1jhdxx4AFk5N4m+WJmrDycsU6Jf8cynv2m17WPOGBUDOeyuYsYJKC8X2mWhOJkQsuaTM2OS19
 CzagGv3KXywNdgOBQYdHEiml2aXo1DQ++9osZHbOsCWsPVpu3GNC/DWVB3RasnKibRXwAbcISX+
 wAehjcEQAOg4FfDfBWIb+19ons2bAbIm6qSnAkod3828SeWlfwMQpKtVOemvfkets29y+7GSG/g
 YCFSyOvWkpkuXAi4joqqbrdz10BqEqtDOVPbLjQvtCc1ry9+GBoKMpfk6EnQPcflL3P3jBG3
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689c832a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=COk6AnOGAAAA:8 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=4RBUngkUAAAA:8 a=EAaoCxoW1-eqaAFV1qYA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22 a=TjNXssC_j7lpFel5tvFf:22 a=cvBusfyB2V15izCimMoJ:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-GUID: Q6mudqjl75yHskG0OStSrSn-0maKsWLY
X-Rspamd-Queue-Id: 94E3540008
X-Rspam-User: 
X-Stat-Signature: y7ffdrfhnr4brmzwyf5mxe11fprt59g9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755087664-761776
X-HE-Meta: U2FsdGVkX1/ChEslUSPOcnWInLJSLYSyUaptVfyioA/DGu87d5mtbN8yrD00e0f7CIqvZC3+5pnZAWnmiLLAuZNUwn9wgcQJ9GUa4QLhjpTDdGMJElJxLYR5ABewAUz8bUEp8d4fBnTqhLY6u6zJYftWMJyuTJJD4JJEc/sJ4ho1x8ebIG6SFaxHDQt6HBUqcnY5fnqEl+KpaMrQjpW9UnY6eXFOg/RHM0ESpz2LG3JvJyzUoFBq0GafTERMnDErzzEJM1gSTZESMLdEmXxrBopRBmKAB2AcNHlRF1TmqfJKanGMOQkyyAJa3L83O6zGzwn7bac0W80q1lwIDNTQMD4ynkI1wvbxl9IS7lNAPPtKfBxYsPnBJMhMTmk2eKdY4WNA+uymhNv4jS5mxLBA6hjKoabVC6tWRhqelZeK10jhd8j/dA68X+PHqaZkdeOeiOa15xqaNpDLKoeUCIlvUUbJNtTVvs6g7Al15X9kJQQwbKM3SCUmqg4dtCQMf/KfwlFlB8RTiRq34q1zoBtcKDwv/jkVfqXyi9znIhGIWPOTug0Myk/zeWLU5ScFQwe57GbjAeZDjlMf06+kQ/+Fuh3MF3plFSXfpTWMWBV3Msp8sssKTLPIm33Wc4y+7+qA4KdJObATY+GxLJ4XuImLS+obQ3vKiZnGQK4CH9lMA+TymW+nIIjo4gY8Phpm+NJIGCIzDQuD+aJ8U0LS9R1yqQjwaLk+JBT1bIn5taaHKv13QkfLGE8yPNHeVXlZeMGJj6DvEvXFAXbfOHT+qY7ZUSEhsTvSTkffBte+1p/nev7atQ2lw7JQlVeyv0lxGhcZXSbRfwkXMnXGs46T5uD06bgM2RNCnxo+fQaaOIT5mw4sS0QZHsIAF/GLOVFqVYH8L9JWaSAzL1zUXP1mOmjZ/9JQn9q3YKISsBsA2KCgvqF9bRZD8VXZ1cj5wZMbkWq7w69V7UnSCpHR95eJ5Z1
 uV8uPmMZ
 UPlI4AyqQ6GFIE0CsmCyFg1aWupfguw/TGY5G2Gp0jVOln5ROtTQIOXc9MwZqykcDTiH9PJqDN5St4pmxQUJxrIZEzwJnmnZCKLZfNuAEUhSaft3OjZP0sJh3MK0d0D0llLKTl0/JgpwQQOGkMNtjwDRAZS1sKLlPFZ3gc/m1DVGNmtd0/9F9+OH9oW+K98hefdBdRCaSBp7/reHGGCNDE2ltPUTfwWRPFgYMsi94sxVb5Lph74UF6CDkEobMtN/OR4ZVHuV3k+69muHLfAJY0qYVFSHjAlf8D+Fhlq9/W4LSE5h0RXO4rPLfpoIPOqZmjfuMn48RzI49FOTTA3hdz15hKxi9J9cch0pWncGfv9iplBSkFVjjir/BAL+yCtL7mSebMQUP9LAkb8ryr/gco139670PfPhplR1KUYi0Ss6MQQ7p2J91copVHlgg4oP9RHLTioLn0Fmj95xBYtBQdIOpN4ObY6tb4xo/u7hytnqMYRKHlgHVyfROqCIAV/QwlWixSSRzUtGppnZfu5ogHEXnKUnGJSf9av6o1bBZB18ynZgaEZZX082UEqSBhXVVcjlecMVgmjfyZ/DIxD27j4iHYF9R8mfgyc008FDw4LoKslZ6RGabzi2mwHE1Ld6L/6JCFpy27OQHE19v4pxCMLRzHcAsJp5NyA+ANl8D0nFij/yneGUnBLCM6FsBi205sA0MeP+fwhglz9EzYmKVI8Juz3adIyxxgsPLop+8lJTFVydOiJ8SjHC9ZI41P7wWY3CAJuDs/yVte/jTSuC9y8ktMnsHkJO31IOLCOxBgpe+lmLauQnK5crbFvnDmGN2a4zmxBgl7LN1IcJHQjhx0InVKVj1oVGa1Z1hbPZvERdS+6YsSNk+2TaAEtgmFbQLj4xxP7fLImMRtDIpYy+9+78OqLTToWNs3TH6dzQYgmvnSJCguicfL6VdU2O6/gIJ4UYEDW53WgSGiL5OheIumLRMDnm2
 9IiX1tkH
 9phC+ZvhNuScWP4FzGVSZwtMVW4zIkbbQDRQ9Zi7XOPRaKbAoHcZKxHCzFr1qtj1dKC1f6ABzOO2qQr6G+r40DJ/yrh3NJ4rxz9Cc55A+lJ/1E5DfO4idmwe6aoalbQ6LIxYRrN8mVa+rUYpdtjC8tIobFmra1y48UyxU9OOuJ6l5N11OdZ/SVZO6UtVFYP6iJ51ukADMFhkvJhFMvnuTxOOk+NpFvxpNrPkTRdGDLFkO9IMteJFC3/SHGKTYd7Lzku9RpOqQ6AvqRt96v92UItcHA+66uZq7vxi9u+0DUCmcmDab6OxAcNT2dcQuDxR8r7Br/3BQYnfGwCaZJDolyrofBHydmGx2deZArDaGoQzo1MhK4x4HA2wWCJAHjSpuFHof3W1ShfI+/rX53q0Labay7CfbD95AMNJK+5GTSDxaPntXXczTFILEnWRu2Sdk4jfKzVyC0yGjE8dxfFq79/zHcmOSetdqa0VgU2JFH1QGnVNIQ71tbhkXeQWqGIquphpkic1Aajn4l75/xZpHwuUQNOK8+jPTOLiFhM2MgwuKluoLasRy1eChBYw5doGteJ2kaeCyElmBRUoFa9E9u/rsdiPlTC5ETsBbEM8BdvG07fY2t7gDKevyh1ItIhVAa424SH2LkUu7prG873ZVtZT07mtJ2F5CExnBViQx6+XJCvA0RA6ogoilHQ41FuChTF3TlUY1NqSLeCTZXyfLUntpz+YnYP1zWa6ain3Im9SzLVmE5NIymoFyM6RuQM8LX7QmzR9RgA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 02:56:35PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    53e760d89498 Merge tag 'nfsd-6.17-1' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=165fe9a2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f9319a42cfb3bf57
> dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14172842580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b04c34580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-53e760d8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/584b4139c7e3/vmlinux-53e760d8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4d2474607300/bzImage-53e760d8.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com

[Cc'ing Ryan, Mikołaj, David and Peter]

I was able to reliably reproduce this (with the reproducer provided
by syzbot) and performed bisection.

The first bad commit is 0cef0bb836e mm: clear uffd-wp PTE/PMD state on
mremap(), which was introduced in v6.13.

Adding git bisect log.

# Git bisect log

$ git bisect start
# status: waiting for both good and bad commits
# bad: [19272b37aa4f83ca52bdf9c16d5d81bdd1354494] Linux 6.16-rc1
git bisect bad 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
# status: waiting for good commit(s), bad commit known
# bad: [0ff41df1cb268fc69e703a08a57ee14ae967d0ca] Linux 6.15
git bisect bad 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
# status: waiting for good commit(s), bad commit known
# bad: [38fec10eb60d687e30c8c6b5420d86e8149f7557] Linux 6.14
git bisect bad 38fec10eb60d687e30c8c6b5420d86e8149f7557
# status: waiting for good commit(s), bad commit known
# good: [0c3836482481200ead7b416ca80c68a29cfdaabd] Linux 6.10
git bisect good 0c3836482481200ead7b416ca80c68a29cfdaabd
# good: [77b679453d3364688ff3e5153c0be5b2b52672b7] Merge tag 'v6.12-rc3' into perf-tools-next
git bisect good 77b679453d3364688ff3e5153c0be5b2b52672b7
# good: [77b679453d3364688ff3e5153c0be5b2b52672b7] Merge tag 'v6.12-rc3' into perf-tools-next
git bisect good 77b679453d3364688ff3e5153c0be5b2b52672b7
# good: [05d5d3840b2d52619ffb79e60ab58e30a7f86037] Merge branches '20241204-sm8750_master_clks-v3-0-1a8f31a53a86@quicinc.com' and '20250106-sm8750-dispcc-v2-1-6f42beda6317@linaro.org' into arm64-for-6.14
git bisect good 05d5d3840b2d52619ffb79e60ab58e30a7f86037
# good: [05d5d3840b2d52619ffb79e60ab58e30a7f86037] Merge branches '20241204-sm8750_master_clks-v3-0-1a8f31a53a86@quicinc.com' and '20250106-sm8750-dispcc-v2-1-6f42beda6317@linaro.org' into arm64-for-6.14
git bisect good 05d5d3840b2d52619ffb79e60ab58e30a7f86037
# bad: [d0d106a2bd21499901299160744e5fe9f4c83ddb] Merge tag 'bpf-next-6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
git bisect bad d0d106a2bd21499901299160744e5fe9f4c83ddb
# bad: [d0d106a2bd21499901299160744e5fe9f4c83ddb] Merge tag 'bpf-next-6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
git bisect bad d0d106a2bd21499901299160744e5fe9f4c83ddb
# good: [4f1a62e2b3961946a924c093bc2bdd44a2a46c9d] dt-bindings: clock: qcom,sm8550-dispcc: Add SM8750 DISPCC
git bisect good 4f1a62e2b3961946a924c093bc2bdd44a2a46c9d
# good: [8817c21a45b62c17f18417efbd0b04a3805a1e23] dt-bindings: clock: qcom: Document the SM8750 TCSR Clock Controller
git bisect good 8817c21a45b62c17f18417efbd0b04a3805a1e23
# good: [f4d3d7340e719dd3d2c23ce8d6c360e2f93ba7e4] dt-bindings: clock: qcom: Add QCS615 GCC clocks
git bisect good f4d3d7340e719dd3d2c23ce8d6c360e2f93ba7e4
# good: [f4d3d7340e719dd3d2c23ce8d6c360e2f93ba7e4] dt-bindings: clock: qcom: Add QCS615 GCC clocks
git bisect good f4d3d7340e719dd3d2c23ce8d6c360e2f93ba7e4
# bad: [cf33d96f50903214226b379b3f10d1f262dae018] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect bad cf33d96f50903214226b379b3f10d1f262dae018
# good: [a603abe345d6301f04dc2ceb5fbdaa19e4c8f7da] Merge tag 'perf_urgent_for_v6.13_rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a603abe345d6301f04dc2ceb5fbdaa19e4c8f7da
# good: [79f4b6934dbd7dd6741726ba004a15e25380b8cc] wifi: iwlwifi: mvm: remove unneeded NULL pointer checks
git bisect good 79f4b6934dbd7dd6741726ba004a15e25380b8cc
# bad: [2ee738e90e80850582cbe10f34c6447965c1d87b] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect bad 2ee738e90e80850582cbe10f34c6447965c1d87b
# good: [bc1e64d5403d7926a3d79fdbbdf628b69f0939a2] Merge branch 'net-use-netdev-lock-to-protect-napi'
git bisect good bc1e64d5403d7926a3d79fdbbdf628b69f0939a2
# good: [3744b08449c27bfa085aa218c4830f3996a51626] Merge branch 'pm-cpufreq'
git bisect good 3744b08449c27bfa085aa218c4830f3996a51626
# good: [a50da36562cd62b41de9bef08edbb3e8af00f118] netdev: avoid CFI problems with sock priv helpers
git bisect good a50da36562cd62b41de9bef08edbb3e8af00f118
# bad: [79a1d390f879563119bf2848b621bc7eed228c7d] Merge tag 'sound-6.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect bad 79a1d390f879563119bf2848b621bc7eed228c7d
# bad: [cbc5dde0a461240046e8a41c43d7c3b76d5db952] fs/proc: fix softlockup in __read_vmcore (part 2)
git bisect bad cbc5dde0a461240046e8a41c43d7c3b76d5db952
# good: [4dff389c9f1dd787e8058930b3fbd3248a6238c5] Revert "mm: zswap: fix race between [de]compression and CPU hotunplug"
git bisect good 4dff389c9f1dd787e8058930b3fbd3248a6238c5
# bad: [a32bf5bb7933fde6f39747499f8ec232b5b5400f] selftests/mm: set allocated memory to non-zero content in cow test
git bisect bad a32bf5bb7933fde6f39747499f8ec232b5b5400f
# good: [4bcf29741145e73440323e3e9af8b1a6f4961183] module: fix writing of livepatch relocations in ROX text
git bisect good 4bcf29741145e73440323e3e9af8b1a6f4961183
# bad: [0cef0bb836e3cfe00f08f9606c72abd72fe78ca3] mm: clear uffd-wp PTE/PMD state on mremap()
git bisect bad 0cef0bb836e3cfe00f08f9606c72abd72fe78ca3
# first bad commit: [0cef0bb836e3cfe00f08f9606c72abd72fe78ca3] mm: clear uffd-wp PTE/PMD state on mremap()

-- 
Cheers,
Harry / Hyeonggon

> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
>  </TASK>
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Modules linked in:
> CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
> RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
> RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Code: 02 00 0f 85 b6 03 00 00 48 8b 2b 4c 89 f6 48 89 ef e8 e2 1b af ff 49 39 ee 0f 82 d5 cb ff ff e9 0c cc ff ff e8 1f 21 af ff 90 <0f> 0b 90 48 8b 44 24 40 48 8d 78 40 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
> RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
> RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
> FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
>  move_vma+0x548/0x1780 mm/mremap.c:1282
>  mremap_to+0x1b7/0x450 mm/mremap.c:1406
>  do_mremap+0xfad/0x1f80 mm/mremap.c:1921
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00d0b8ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
> RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 


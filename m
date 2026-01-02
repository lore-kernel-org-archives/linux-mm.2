Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AA5FA3750
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 21:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF1C6B0088; Fri,  2 Jan 2026 16:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D046B0089; Fri,  2 Jan 2026 16:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C486B008A; Fri,  2 Jan 2026 16:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D01926B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:01:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C0831AA8C8
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:01:07 +0000 (UTC)
X-FDA: 84288243774.15.10FF4E8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5AAEC140019
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:01:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UhPYQjHF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m3BkRVl2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767387663; a=rsa-sha256;
	cv=pass;
	b=tyEzKpZEp6E7COZmEHWs23HoplD3Nuq1hJilxnRA2ccC24YKCp8//q57waMq9q4Y4SkH3U
	X/6BIcT7oWQbD5XcIz7x005dj8/ipCU95hJfo/e0AWp0r4fIB3sHTaeMQWhUIkhxpEtt9y
	Rmc88au+tVp6v1+CU03kwOwYmRR3JO8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UhPYQjHF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m3BkRVl2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767387663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pddm+m4R99pgt79Mv1CyFhtnXVCwpwMBohnhGpA7n4E=;
	b=SbZfGR0EhNo9Sj1UjCk9gj3yqHaYPOfH2jf7bck0lpqPcGeJ2wBsZe9pInRFk3rlcxzyV/
	Hkan8zLG8lPS03r7q64umWGul30lgh/i7i3l7BKllCmQigfcnlOm5/SQUleu73YOGFjbOX
	dWGMGEVy1PeDYX5PVwQIXp9Uli7ryQ8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602Bv1uq2742270;
	Fri, 2 Jan 2026 21:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Pddm+m4R99pgt79Mv1
	CyFhtnXVCwpwMBohnhGpA7n4E=; b=UhPYQjHFOlxNVYtyybqxl8H87N1m+1v0yT
	ULCEl9De5xDSzDD5/riYGgdYbE7LgjuhsuxEZM7oRIHtT5rxMHQY1ax8UJxHmISR
	0wEdoSJfZIHexZYJMHKtB4wCaZ2TfFzoh8DShlRmheh4j/ziZOjbLwchRUqlRGjL
	nKA+UfZQZG96+PezvPptpE6CShdinlYAcodjdVtZBMhmlUeVbJqsBsHjOi/Yojo8
	QQMVa2t3LOJGqlj7ZTC6DBP34v4q67HSoJE8LtJMovE1iFcjnx2eCLBrz3JLahL1
	dBLhk78pCXnCDv6FuWM+42XR7RdDFEOqsQBSZqP9iWAQ4H8fI+4A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pweky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 21:00:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602Khuj6023129;
	Fri, 2 Jan 2026 21:00:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wa6heh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 21:00:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rr10eYB5g+X15Rct1KnB07QcBPQRKTEjl7ieKEkj0K7ZdMpXbjeL2BiIDhK8a3s5ALLb1FvLm4sw6fkYlD2oxVMUAqUfSLilYALIHzBXrGUsYUvnrq2JBOfDRQ1obQT2PjE7+/HhjuWEAjBMViMfzfgEa76NgW5In/i9CtCORqn501PoJuYvGecN8Za9ToH0lYZ0jsHHg9tb15/WvPrA/ccTMEEC1PGoWzZq5CoBFEX6ruDp/PrFR36McrisBhlKg/8Q1VnLcONv2DnOWwlZ3n/L1O/OB4b7Dt5YFKS42RJVm4zcbz2oNsmCvnLJeiBnqmLsb+6VJmvf4WM4My91ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pddm+m4R99pgt79Mv1CyFhtnXVCwpwMBohnhGpA7n4E=;
 b=tS4j5Ozgip+726O7nC4a1gE/LqXGMvdV9NOVcUr0q06iFwrPW3SjhIFZEiOD0WM3QPWitl1IuFfnw6ArZLol7iKS0TvKHWMaOKgAC8+Lc9FX21d4OGOMwIgwbaFknvq65h25nrIml0AJKBnqWI87CLOO7YTIboyOSh1A79CRL575OhgDQHf5cu33rtWgOg9YaUt+EuT3SsJ7VK0qP/km+Webm9bfJPu5tBB7HYv22sudP5N2EEOoc9jELvQMaQCjN92VpkUbKzMlEgZEX0+MNWxXRIWJyUg7aouBuMa0mbbvBSfdWSt3mmXEZP1HEumve/LOooxtJHwc2SbB9rK3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pddm+m4R99pgt79Mv1CyFhtnXVCwpwMBohnhGpA7n4E=;
 b=m3BkRVl2m/JJi9q+LoQdER/XuYg92ekxkh8oveR3IWWaWIN35MRnA3ueJPpoSdgIxyxCckD08lrgtSkujTGYF3mixjqY12Tnd0g8e+NerrRWHf473jrh+tjp4zWtY3vl9oIF7RlqDwU8lWRti0vcIhOHP3m5UcSS8RZtgT6Tfas=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5684.namprd10.prod.outlook.com (2603:10b6:510:149::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 21:00:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 21:00:50 +0000
Date: Fri, 2 Jan 2026 21:00:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <7ae14310-662b-4487-a9a4-5a6e828d3453@lucifer.local>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0442.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: ca5c0535-16b2-4996-2c06-08de4a420262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n/FMqahsN6ZT1exWuiyvTP68MigKeOj4Lgvn73yr7roCCJf/qGz7Pr5UU19U?=
 =?us-ascii?Q?z1IbuH05y0/Ge4D7SqiPPpGjdOx95cXvKTN/rOockNhy0FG//++JoGS7WE0N?=
 =?us-ascii?Q?mwv7biszNCcjnGZJON+ExVNffmGTiqTY9eRy7Jd6LHlm09moTzvT6jh4Hst3?=
 =?us-ascii?Q?2xYjX9hvkGrMtwy/KnL0cEBLsXINia1mMxDNTXfV6kLbJK6+sPJPz3T7h0fN?=
 =?us-ascii?Q?S8JkMTwZdbRedTwxsnoQ4UASnZAzHwtuIyjERKsQ3RLKQXvvDpfIOfQPm68/?=
 =?us-ascii?Q?FuU6+pPwIgZZMjl5le94MCPm0ycdiqApoETJLH6Zo1b9h/Am52XMo+G/Fj3D?=
 =?us-ascii?Q?IgFxjPFshdcsMjLP/ryWNAJftzL/TpLyPnbW+dbdgocRZki7V6NK3+xJKeO2?=
 =?us-ascii?Q?y0bQNQqBUGWCMMV96JagYMfwH0lSDuqH1HK1ddq+ikMMfWD8QC3ErP0yTd7I?=
 =?us-ascii?Q?rlinWVUV1g2WHF5JltXV53UL3rAUzzjlZOjhWvmHKIdJbK4l7tsPICAgkYG5?=
 =?us-ascii?Q?VNDl7/Hbi+8EhikpitgAOtSig44ahdJ1fcJK0Gy/+kWaSH1wHof4lpBG+SFo?=
 =?us-ascii?Q?CMC/M7Cl4ulrDTM6WCNilHVzHNkJWkaG6qC3KexLjSciowaoJ4CMtaO+zMOy?=
 =?us-ascii?Q?f6f4mj+ft/N3hSOXpByEWXTYhGZc8wCtvAG4gTXlbXSzHVPP6YgepnveL9K7?=
 =?us-ascii?Q?F0MQ6Trff3NIYBYs0O8lzIP13zFo6ZzvR5hdtecEivfO2k1pq+9nJWceTUIJ?=
 =?us-ascii?Q?roD96IEBc2Dc80N2OnEctAWWvF6clWKE1etFQVkKWMmAPEFjm4eevE/pzSh1?=
 =?us-ascii?Q?g+dHk/725Inb8mhjIBvUc0LKePnj2vGiE3SNDokV94l6CLCTD7oSnxk169bX?=
 =?us-ascii?Q?vHq4wUbNUg6iNIz7+58GWYWJyG+R4qoP5ymltDqEDZQEfhe6EeotsiP+7bs2?=
 =?us-ascii?Q?MP3N/jaiQ0nAXPjupIFxo7NKEaT6CiTMPvAF9KfzsLcyBRgF6vdfh+bqhW4P?=
 =?us-ascii?Q?hOezWYp45X3PmY4IwQtYYlbHzdgGN55caFMCRyNa4Iism3MD/QSrytaPIPBC?=
 =?us-ascii?Q?iLRyiM7NFjeQFyo7HIfR5ImuLlfQabcASuTJjNtCZVu73O8xQgr6GIF5jyle?=
 =?us-ascii?Q?qtTlfyyN9Xe58E+DI17HbJExWc/fp7zpinJIXYHweg0+lufeUEJF7BkWqq9N?=
 =?us-ascii?Q?fOqQdbnHXHgUrXDEX2YA1s2atWKEoFSrCcPWSyGwC3DoSFridkOCLPforK4y?=
 =?us-ascii?Q?ggNsu7bIAdX3i/zGv00JwyiTkP7Jei2pS9T8lKXaZ0Uxn4v5oopBAWag9+dQ?=
 =?us-ascii?Q?ZfaGhiW7Vsvq2vvSiEtdMI5pvRjxlizx1xawebk8OUR5aqSBTQe8/cAai965?=
 =?us-ascii?Q?s7FHl8bmwwIJAtd+OZMWwJ3gIFAnLNEAk3a3f5TTh+3af4Eqc3alLLwVAf4M?=
 =?us-ascii?Q?chOeigYf2tNel6TiklMwtfkZosisUnGohqMIesFTf171coK4ev3LiA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3n6Rgl6X79Dento215zFoGqliwy7AlGBnLHrtTZgxAvBv4aq/Co6KcHRtsvz?=
 =?us-ascii?Q?zI4S2eOFvSTRUYMGk+54SSmsS+6waYMJnZkVR0xe++BSZUeMsl84Srea0/YF?=
 =?us-ascii?Q?j2evfp/FeJQhzypxDoOKCihmaRUc0oscY2vmDsxAXAwNPLSwMj2yQ722l4nq?=
 =?us-ascii?Q?RULDF2GpK6jt0dOC2kVTEmVY9pEUTsuQarDg7RrR7ROQ7FMJTYfSihfSTmdn?=
 =?us-ascii?Q?b13OEbygso3ejHABwnGEUUqifujxTmb4U3DCwrXe98YWfLvCAOS9kMiuOVMG?=
 =?us-ascii?Q?ax8ZgEjg9X/MXyWnQLCjC7DeoHB+GoDQoJ7Lw6XSYc+7BQ4j01OY5G1fdhPx?=
 =?us-ascii?Q?A81amUYi65g3v/GOPehz/Xj/syo4FZ9kNBY/MNmFl8bDqm/xPfzzVI3+gJbe?=
 =?us-ascii?Q?GpqWiKdPSTFlt0TfymFjiNic+XYPIR4OkJPpx4W2opDLEsJGke0RoKk7fGqK?=
 =?us-ascii?Q?BbxFpvuOxkWwZgQFKi+l0ZA1kJKBkxaEhVka3FZGwQ+xkF6G+62GhgSUM8CG?=
 =?us-ascii?Q?ClnVJ7qi7GnLHEGHhwqrMNtjaHniot/UOBYydwvLmZI95ziXwZZUYQVzjftW?=
 =?us-ascii?Q?IqozUGjXsXzkTal3ez3xOPLhprioo9o+HDU3AmoOaD1l/9aXvLlX0RTmHOTu?=
 =?us-ascii?Q?W/s29ygi80+/7xofX3z8ZKioYGj0B56yfiZ5haMLfbo0aYuAlB+hqFXGXdTP?=
 =?us-ascii?Q?o22f9a5tLATrOP3nq2XppGXVQYJOleuZUYSG8MfHFprpbkbb8dBoqXQw1U2b?=
 =?us-ascii?Q?VT3S9DZW1vHjujjuAdBltJZ6aIlxVGMSaPAhd5L0CKCL1JKUgAo5C0BposBr?=
 =?us-ascii?Q?tvowVCT64PXln2tLgGFDZ+UjwJzw3N8FL0UnyHhPbviMscfj/ml7ktEifkuu?=
 =?us-ascii?Q?yAcEMOGtCfZzE1D4V5nQuhayHlXtbUH63QqBPjBFKwm2AfjFN5GfWt8qOwfa?=
 =?us-ascii?Q?ernw/o6uiZgGhkMEyovpWK70fpw20GpCdQde7S+GTbS5ZoWxb2YZ5BQuLHAz?=
 =?us-ascii?Q?w/bU55SuugOq+nFhIGFImRiEDz3wg0BhstqEJy/icw/iQJwOfgXDnkSy3Ary?=
 =?us-ascii?Q?EtJskWliCNeQcYkBXFvtwMH3GU23z1eqzF+BIVgsG2nofvRPSE15tinvcZAG?=
 =?us-ascii?Q?Yj+hQYc9zOeteadVhrStXXuXEyuruDLjbhKdXJjA0WF4klYCMFuyKTT3mI14?=
 =?us-ascii?Q?D+bU1erJoOUvYjzyw7TCFpTGI9CUXYJeflcdj97zCmYMcMEGnybs5XmHIPGP?=
 =?us-ascii?Q?dLci1tEWbyiiCBdkDvO9XdaufkLkQ9svfyZb7vyMSntsvav+4qUal8JcTiph?=
 =?us-ascii?Q?2yFjy1AM/whnmn9fj87fdXfvJ+BCUstQfiCrEXVYFiGRI89BfAYs6qUtU4z9?=
 =?us-ascii?Q?UXSclLI/aGfI25zai66ebt/sQI3kRivL+UTvu5UKVBLkY3yDiwiZANh5P89R?=
 =?us-ascii?Q?kYaAkuE3xtoKEDlOGdgZdhNeFfW9EzS+D5UNxlpIn1hx1Lqo5m0yASdr6xpa?=
 =?us-ascii?Q?pzVCTu9vNu16bxr6DIAqUkcXAcyVNTQs2z4e3amXIEjhb7/sFd5uuu0ufjRt?=
 =?us-ascii?Q?jS4oCEy1IKIv3XBtouJdqM0q55rZ8TNr55rBvdLGJsZz2I23aYW5QXxTqJHC?=
 =?us-ascii?Q?t1s6s+mjS/hUgfP6H5Xt+6xYeHq15of9qEXuE1tQSuAbyJ1mWuVSrBF76SY9?=
 =?us-ascii?Q?gUqvaHFOlV4KxK7w85czH8fTwpLvx9y2f1Ha/oTMRaIWmj8OHHakNYaGep17?=
 =?us-ascii?Q?jxh82nKUucfuYiUNyCTAgkNwrooYvAk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ol1idJ1vIbRHpZw2CmxQlQRxYaOkV6jedOSQfoUFHLKc+451LQgWgH/utxxGp/Ms0BxFCVEOXjkmb4mLzjuQoJ/L3jG4QrVVgApHpL0wl0kYt20Vx8O5Ba8jko9RNW4nHf8gE0vrWyHW8eDv4felE6PagrIdWqK7MUOqmZNmeHwgoQfo+2VhudwyW5Ai4A1mS9R43wTj+Mey1O5IwutNcg9w9mYHg8MdQe5zOEQL7g0I0AfjfZFchllSHEcpM6Um0DYJDiTHyhuRNUgeQIS6ndvuDzD5kP+SKBzheCuM5QFkpFcMOnCVyil83w35fWrLZHtsMOtRDU9hBUFftZ8WTaPwNbERW2XIBy2RyWGR76vXeMpvp2C7i6RomTZyEBLJc11Sq223utlB5LNKWpm5fhoqlgTqq7dAmaxeL+7SoyW0VqUxVgtZfqUQHNQQwJ/KhHRw2lL05qhrPOQqWSZFEvFJ1yeIPF7WFkk9UP63I+9eTFxt9t1CZmdj4mPWQG8J/2Dhu2ag3Wjz/1x83ccZTgrNkAZ7HJm87jHYbIJciTR7VYlC389T5ZPPsqcRO454eglnYothZA7iep93MfPshuSdEsJ1ge1aqzWet9be+Lg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5c0535-16b2-4996-2c06-08de4a420262
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 21:00:50.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UduzqFWvFeQtKbWsHVgghpaDYdich99nzKxdvWqGth1cG+eLqIYjtsWMOrNM4xrNwXKSVaih1R9Epk34qeQOzjsCILjcbq6i3Kedk022yF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5684
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=953 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020188
X-Proofpoint-ORIG-GUID: CJg7DEC_aGRbhJ5I2jX5e6TgxgoO83Ys
X-Proofpoint-GUID: CJg7DEC_aGRbhJ5I2jX5e6TgxgoO83Ys
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE4OCBTYWx0ZWRfX94ibfqiK4WTK
 0cCDC4PeFsnmjuW0Q5gZIrCVyYp1Bv6ja3ePlFSAcYV77d1dAl/bEFCRKM6HTmwf466Ve7IxkCo
 sGRaYeXEE3QY2bYvOnVPmLRgLpx6aiaptyw3Eyg/CWhC7fh2l90P9ct8wn1udtUgQjWoCboAgLT
 nSpEHfrDG65Ld6i/BxyXEe1aMiFARvCeTzv7j4K0EnluSZBf4aYhpeABzce3FtzxCIxrbz7HJdy
 qFIowkO394h/TGotqYNRrJWe/6qiJojRvEybsDlNY9zm/8SSGby1JJ3Wi24aN0bcZ1BNnTTbJHS
 dJWQDWJxUOJM3I+L/0ChCz82muwihDD/eOMXjwymo95F7OcGIIZ5JG5qStZa1SGaGLoqxNF0sy6
 nb2iU6hfTGT2ZjoGzWf4hsiodR9vB1yP7tMKrWfZvuv3/sNuDri1y/VYeNH9wJevHl+7GraLl/a
 B075nAIeDMazZzsCI1w==
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=69583205 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=eASngFGweCe0tIGf0QYA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
X-Rspamd-Queue-Id: 5AAEC140019
X-Rspamd-Server: rspam03
X-Stat-Signature: 5c98tqgnqgpnb1ubc1cttx4fzsuuo74i
X-Rspam-User: 
X-HE-Tag: 1767387663-534532
X-HE-Meta: U2FsdGVkX19ywypNHw6UKtSOGv1uk5RKsaj/R2/SNVQGGHWGGMrWD0m1oUVcUj8uQYv0IiyXHHhPdN/zEmLRh4RVTgD/gWYZdaDKmwMkx3X1Q+SvA+7h9bW7ZFxieRF9VFAAOTKrmVY2GEK/prZSpZYQl/A5WHSib3wMYPSCzhumYGOI2/iC3hpK2R/obG3hfCkDnc5ckk6BZH+slC/irHIob5xd0S7CwMuj/fmCay0V6G+MMcGdCelaQRi4ubOCF91NWQnAn3OQqB1Z+HHK2XFmAj5s2CQUBPCzIzhU21dUxWpMt9qmZ8c9W3rPyX9DUZaxTs63UNzkwdz53D2KYV2UcznqQlw5DuGUJ03Xi9K239iAhvWzGmikXR2S7GsWEMHP55bGqPLON/y8XzBbxCtncawi7rBZz7BZhtv0OQoZ+FtrQvXVd0Ym/03tkhd/sG1Sj6gfYgFF8vCCkewpvWe1xLUo/VlYuB+YWcJareefiqcKu+tlinvPKfiIklyivdnzb423yuo52ajtfKzg2jRv/lZB6XIY7raczDX5/cI6N0Z9mwFM0GJ6jhGMxdv3SgIt1gYutfYMtQWdHrZVYbhigxhm6MStadbNrF5stJSFNsvkd4FhOfuUEWlZ5tstjvrpz2isF5aNXRFm9XthAjsTx86xCoMGX5DDLfwudi3AJKrp2HrmprwtZDnMgM7yJ72qSB5ypm4swWhmqnGq0794710FxF1A87lHCWR1KlGNn3NR+9L7TlXvzh3riNLCRlnOMt3QGDemMpTIXqa6B1OZiQNPutaUvtLd5Jw+qGLfD6D2xBAKvf+bEk+x/+NsUv+x9S6Xb3WTf7EIIR8zj2M1X1ftw+qX63fu2JDvGOCZg82qBj315CMUVKfub9i/GwgMNwUI2ihtY2gEDtXHZT87A/t+FsleIJEN8uOGrzXLK/PP/NUl40yxBW8mfMTo5ItCXrzJaNNXr9ELewl
 6TezE8DI
 7zj2yxGtEJeGsulyqM0Cep8bLBqRaiThXBpNHwCbqAj0CyFNTR7vyKkiunH4pAMrYnv88I4azF6UAze2tAuZg2e2aAm6gAJEKVWP3nFQDAuioCgeJX9nxkKBWxtU/fj2v+3iZxzyrNKSmjXCpqfkQq5pvcLkF24UkcuLrMC3AVH3l8ROWCLhZ9z2qLF00q7Nr0fmG9uX4dqma1HZtkuKPvtYbobYTpO7x0uC4KZdWsUR/D1yaN5vbaN/9imD/b69NGAXr+vvJq+irpTeAdX2hW0oWqZfmmx9x5YTq4AlatKCNki6ygaYHQx3U5ZggFAec0tOwHVu27hTsOBsa02qqhEzSTkFQ/aXdSxixH2Uozafy/JsetgBmpv4pht3DEmEWVOYVm/fWLRy3UnEB2wwDBY0wN0Q5NkbzgL4Ms+NnZixm0bKsWoxYDBkNOMnorqOTRWlOc4VVcigqD2873kmB61gBF/v/ayLUJiSsKBUm8k/Ec64NlXPYtJLR1BNoOyJS2YiH8Tu8i4Z269UhN+c0TtoZHIdyolbntR6zStscYuKqaCI+t9gExiNcNhjUnpxfGpW0ZWHysWo6bVwnNbf+wztGwVpky788UH5/cqVJvvGxRuVnS/TFXo4GIaRtjH4LTb4QpSxs5d4qQQJzOWTFDxlwu8UeiLSCDTQC4h1ohMbXpm/wb+/6rhhkTVx48pavXANZo/HWFiEGYsTIlppd+Ex5us/5FvAJGAuk5foH8lMutm2qSz1NJj7w74IEA26W46rk4kCjQy3LZ4M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - obviously pending review scrutiny, could we get this into an rc-
relatively soon? As this is quite a serious bug.

Also many thanks due to Jeongjun for his work in analysing this bug and ensuring
it got attention, and Harry + David for their insightful contributions, much
appreciated!

Cheers, Lorenzo

On Fri, Jan 02, 2026 at 08:55:20PM +0000, Lorenzo Stoakes wrote:
> Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> merges") introduced the ability to merge previously unavailable VMA merge
> scenarios.
>
> The key piece of logic introduced was the ability to merge a faulted VMA
> immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> correctly handle anon_vma state.
>
> In the case of the merge of an existing VMA (that is changing properties of
> a VMA and then merging if those properties are shared by adjacent VMAs),
> dup_anon_vma() is invoked correctly.
>
> However in the case of the merge of a new VMA, a corner case peculiar to
> mremap() was missed.
>
> The issue is that vma_expand() only performs dup_anon_vma() if the target
> (the VMA that will ultimately become the merged VMA): is not the next VMA,
> i.e. the one that appears after the range in which the new VMA is to be
> established.
>
> A key insight here is that in all other cases other than mremap(), a new
> VMA merge either expands an existing VMA, meaning that the target VMA will
> be that VMA, or would have anon_vma be NULL.
>
> Specifically:
>
> * __mmap_region() - no anon_vma in place, initial mapping.
> * do_brk_flags() - expanding an existing VMA.
> * vma_merge_extend() - expanding an existing VMA.
> * relocate_vma_down() - no anon_vma in place, initial mapping.
>
> In addition, we are in the unique situation of needing to duplicate
> anon_vma state from a VMA that is neither the previous or next VMA being
> merged with.
>
> To account for this, introduce a new field in struct vma_merge_struct
> specifically for the mremap() case, and update vma_expand() to explicitly
> check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> correctly propagated.
>
> This issue can be observed most directly by invoked mremap() to move around
> a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> specified.
>
> This will result in unlink_anon_vmas() being called after failing to
> duplicate anon_vma state to the target VMA, which results in the anon_vma
> itself being freed with folios still possessing dangling pointers to the
> anon_vma and thus a use-after-free bug.
>
> This bug was discovered via a syzbot report, which this patch resolves.
>
> The following program reproduces the issue (and is fixed by this patch):
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
>
> #define RESERVED_PGS	(100)
> #define VMA_A_PGS	(10)
> #define VMA_B_PGS	(10)
> #define NUM_ITERS	(1000)
>
> static void trigger_bug(void)
> {
> 	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
> 	char *reserved, *ptr_a, *ptr_b;
>
> 	/*
> 	 * The goal here is to achieve:
> 	 *
> 	 * mremap() with MREMAP_DONTUNMAP such that A and B merge:
> 	 *
> 	 *      |-------------------------|
> 	 *      |                         |
> 	 *      |    |-----------|   |---------|
> 	 *      v    | unfaulted |   | faulted |
> 	 *           |-----------|   |---------|
> 	 *                 B              A
> 	 *
> 	 * Then unmap VMA A to trigger the bug.
> 	 */
>
> 	/* Reserve a region of memory to operate in. */
> 	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
> 			MAP_PRIVATE | MAP_ANON, -1, 0);
> 	if (reserved == MAP_FAILED) {
> 		perror("mmap reserved");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Map VMA A into place. */
> 	ptr_a = mmap(&reserved[page_size], VMA_A_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mmap VMA A");
> 		exit(EXIT_FAILURE);
> 	}
> 	/* Fault it in. */
> 	ptr_a[0] = 'x';
>
> 	/*
> 	 * Now move it out of the way so we can place VMA B in position,
> 	 * unfaulted.
> 	 */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A out of the way");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Map VMA B into place. */
> 	ptr_b = mmap(&reserved[page_size + VMA_A_PGS * page_size],
> 		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_b == MAP_FAILED) {
> 		perror("mmap VMA B");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> 		       &reserved[page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A with MREMAP_DONTUNMAP");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Finally, unmap VMA A which should trigger the bug. */
> 	munmap(ptr_a, VMA_A_PGS * page_size);
>
> 	/* Cleanup in case bug didn't trigger sufficiently visibly... */
> 	munmap(reserved, RESERVED_PGS * page_size);
> }
>
> int main(void)
> {
> 	int i;
>
> 	for (i = 0; i < NUM_ITERS; i++)
> 		trigger_bug();
>
> 	return EXIT_SUCCESS;
> }
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org
> ---
>  mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
>  mm/vma.h |  3 +++
>  2 files changed, 47 insertions(+), 14 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 6377aa290a27..2268f518a89b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	mmap_assert_write_locked(vmg->mm);
>
>  	vma_start_write(target);
> -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> +	if (next && vmg->end == next->vm_end) {
> +		struct vm_area_struct *copied_from = vmg->copied_from;
>  		int ret;
>
> -		sticky_flags |= next->vm_flags & VM_STICKY;
> -		remove_next = true;
> -		/* This should already have been checked by this point. */
> -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> -		vma_start_write(next);
> -		/*
> -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> -		 * safe.
> -		 */
> -		ret = dup_anon_vma(target, next, &anon_dup);
> -		if (ret)
> -			return ret;
> +		if (target != next) {
> +			sticky_flags |= next->vm_flags & VM_STICKY;
> +			remove_next = true;
> +			/* This should already have been checked by this point. */
> +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> +			vma_start_write(next);
> +			/*
> +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> +			 * safe.
> +			 */
> +			ret = dup_anon_vma(target, next, &anon_dup);
> +			if (ret)
> +				return ret;
> +		} else if (copied_from) {
> +			vma_start_write(next);
> +
> +			/*
> +			 * We are copying from a VMA (i.e. mremap()'ing) to
> +			 * next, and thus must ensure that either anon_vma's are
> +			 * already compatible (in which case this call is a nop)
> +			 * or all anon_vma state is propagated to next
> +			 */
> +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> +			if (ret)
> +				return ret;
> +		} else {
> +			/* In no other case may the anon_vma differ. */
> +			VM_WARN_ON_VMG(target->anon_vma != next->anon_vma, vmg);
> +		}
>  	}
>
>  	/* Not merging but overwriting any part of next is not handled. */
>  	VM_WARN_ON_VMG(next && !remove_next &&
>  		       next != target && vmg->end > next->vm_start, vmg);
> +	/*
> +	 * We should only see a copy with next as the target on a new merge
> +	 * which sets the end to the next of next.
> +	 */
> +	VM_WARN_ON_VMG(target == next && vmg->copied_from &&
> +		       vmg->end != next->vm_end, vmg);
>  	/* Only handles expanding */
>  	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
>  		       target->vm_end > vmg->end, vmg);
> @@ -1807,6 +1831,13 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  	VMA_ITERATOR(vmi, mm, addr);
>  	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
>
> +	/*
> +	 * VMG_VMA_STATE() installs vma in middle, but this is a new VMA, inform
> +	 * merging logic correctly.
> +	 */
> +	vmg.copied_from = vma;
> +	vmg.middle = NULL;
> +
>  	/*
>  	 * If anonymous vma has not yet been faulted, update new pgoff
>  	 * to match new location, to increase its chance of merging.
> @@ -1828,7 +1859,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  	if (new_vma && new_vma->vm_start < addr + len)
>  		return NULL;	/* should never get here */
>
> -	vmg.middle = NULL; /* New VMA range. */
>  	vmg.pgoff = pgoff;
>  	vmg.next = vma_iter_next_rewind(&vmi, NULL);
>  	new_vma = vma_merge_new_range(&vmg);
> diff --git a/mm/vma.h b/mm/vma.h
> index e4c7bd79de5f..50f0bdb0eb79 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -106,6 +106,9 @@ struct vma_merge_struct {
>  	struct anon_vma_name *anon_name;
>  	enum vma_merge_state state;
>
> +	/* If we are copying a VMA, which VMA are we copying from? */
> +	struct vm_area_struct *copied_from;
> +
>  	/* Flags which callers can use to modify merge behaviour: */
>
>  	/*
> --
> 2.52.0


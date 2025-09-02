Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D2DCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 04:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B576B0007; Tue,  2 Sep 2025 00:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B7A6B0008; Tue,  2 Sep 2025 00:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC7B6B000C; Tue,  2 Sep 2025 00:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A60596B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 00:57:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 386DE1609DC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:57:27 +0000 (UTC)
X-FDA: 83843101734.09.1934CBB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8D531C0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:57:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OOt/TuQt";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IDZAL+L1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756789044; a=rsa-sha256;
	cv=pass;
	b=oRX9xq1ENNIXJ0ywsn28gMpgda2VEp1Xj5IWffsi3R9luJXbzAo+sVRhFgKSMy3DCUIneU
	b1+rWS+l1+RO0ZXvfEkWaBnc0GDXr4KZs7Jqiu6rw8kWwmELtOKVtH7FfikLMAi+yXSUXB
	NRJD5BpoI38C2ibia+nTrODCJWJMIvc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OOt/TuQt";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IDZAL+L1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756789044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ0pkUQGnIoUf6nZseZ810Vq2msUyYz1SbYGa8SFp9k=;
	b=3XiFsyTMiNHu6da4g8zHeuo/3wAgPrKIrEY5evvamDPoGI+M4TVktGkzB2QfUMN3vegRDr
	4hKhQaP5hb2fV2648+xWVcXUh0Dyo2rNdV5ry1YQt1s95sZB1b/AeCryvgKLxneexBLoA5
	xw2yUDJnT6HoAxErs9x745RGGOl9evs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5824goHp023542;
	Tue, 2 Sep 2025 04:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OQ0pkUQGnIoUf6nZse
	Z810Vq2msUyYz1SbYGa8SFp9k=; b=OOt/TuQt0JPNezJ6etmfawbcIEZ5teGXYT
	HDCwWOAiQX23fp47HNA45k/zctJ8MOtD92s5WCAxe/xeHkx2fCRU+NJZxNMscxSh
	E/HSibJm8z8FXNxXQ4Srr6PIo1D8rTrmuqB9YVLyyeEGZH1XKZIysOkuP9g+fx9k
	htumGviOSDeentwY9B1GJB5JAxzgcaEpaSgGRCxvq0eiVKpw4V7FzGAXx8rdoyiU
	rgC8XCIHA3XPTz3iMWob4adPdTu8KDuQ4sUpgzT/Q6Rr03jApmXYSO5c61OAO36M
	zLctQMHk7q8AexdAduYw+rDZVwoyL5oc4dsppjoHqUs27dXOQi4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmnb6yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 04:57:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5820lKM1011751;
	Tue, 2 Sep 2025 04:57:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrepcfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 04:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVMhI1Dx1pZut8omyH6d0Zm7h7gfbmhifhwB6eVnFq9MHjhss/Juu2GuqZRN5WRiwX50ehXF+hGnzEPpKmTVlTJrtXdK7bVIUhdABMGxdxl2vnDM8I7CXg23gEwhvCNDAOpUUEaM8oYxqUdxDmwrwcOgpkX/5P4lC+lhX03sp9badUrxaakYtJX/A5mJCYAk2KxGjBj5X+f3zTCvWhoV1Ct9llUHGea34dJjIcb2yTJZTNFEpdzLSQTRaxfNPn5dazzH4952wuKSZx5wacIXNKkeQXjlO5qqcx/vzYUsH3q9l6ts4bTd2/mtZHF1suwcjd4j08JrOoBuWAlLcS/umg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ0pkUQGnIoUf6nZseZ810Vq2msUyYz1SbYGa8SFp9k=;
 b=eQ+yiRoFJOiYPxAyiG9E/nbqzAtp+n5b0yvRjTiytMhT9O6Ml583VNBI2iNwX0TRHbimI/N6xTd+XSfRqm47UQ62aZ2CEtju6KF65nXTV3P8FnDmaFuK7ttZDkm9yqh2L3e35neLVbyxmNFQCAV9Dk975z/CpTnIxvnhPm6kXPy8yJAIGU3GzXa8SzjpO3SB69Aa6JdGeWgr/1vaglgYVFL+wz8tEhxZN78FsZj/tKol9srOed/Dm3dIXk2huaOWBN1Csg3xUppGDhQKhVn3YBNsMXFhW/9iO1BnB3bUtq84VIFePKHGpwn4CPO6QN6Xj4xCcf/EdVt/dSEAnXTKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ0pkUQGnIoUf6nZseZ810Vq2msUyYz1SbYGa8SFp9k=;
 b=IDZAL+L1luDCtp+FwCfy2xh5x7IukHfk6zXt6fLRGkD88UZBVg/UVGPARITzhgfOdExS0PDAYk0muQfrOo7QQomcd4uw55OwqkCPinXw5VIl5EINROutuE5K9Fji7TgqySSOEMhi9uO7nZOymUqMoyOgq/mUE+/xmd5PTer0rbE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6313.namprd10.prod.outlook.com (2603:10b6:510:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Tue, 2 Sep
 2025 04:57:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 04:57:02 +0000
Date: Tue, 2 Sep 2025 05:56:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        kernel-dev@igalia.com
Subject: Re: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Message-ID: <c25f51ab-857e-4a29-953a-4358415dd36a@lucifer.local>
References: <20250901183729.3900578-1-cascardo@igalia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901183729.3900578-1-cascardo@igalia.com>
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 26034d06-f485-45dd-62ce-08dde9dd27dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iq6vyDnIh1xLSR6B/Q+Yl282BkkOkrxkE5ORrNa5/hEo0CbrUsxiXbuJN30h?=
 =?us-ascii?Q?7gbKVvdsqDGaoNPrydhPGgE77yQfIYy+rkEMKpIVPmir5mjr6/63o5XRaGrx?=
 =?us-ascii?Q?v+sVyZMbMZilUNT6kLW3P6ft+3thY/vVqN/SLucH7mqS1NE6f6iWxEDydvHn?=
 =?us-ascii?Q?XA/4U0edOpaaaDQwgUBuf4EKfdpo2zwr0/2EFxRyh3mwknHF/llfrDdy8CmL?=
 =?us-ascii?Q?BbpuVDAo8eOT43QoF09xKRUeEBDloYaiQ/ofYv7WkpXghzeFhnG1UJ9zHvqF?=
 =?us-ascii?Q?UtPvBtvL2N46vYST7UdPVFf/GubPJe7TaPCwfb5ij5tKMFxnIcOu3Z2dNUBM?=
 =?us-ascii?Q?K1mtSoxfeuqubJJjkN4RP/ZQ5qHA0H1oe3bts85fVsb4YAZpQ+j5w1sKC0KU?=
 =?us-ascii?Q?54DClVO8If2nZV9Y64Vr6CrSnFFUOE1rOa28/tHpTGaGDyFghXuGj1BuddxN?=
 =?us-ascii?Q?4kIxnKaNiWHhnrCCC8HBG0Add6qqWEdWRh7ang34WJZ+u8/Unp/xjtlnGDms?=
 =?us-ascii?Q?o7w8Z50OcCPRBdLjqcEjJVV8m3GtMX4xGOZM37h1Ze3GhFYFxgcjfqTB+MKN?=
 =?us-ascii?Q?FESBe49keSjtsBjgFjjELZUtXJwbvY3TCmNSdvm/buiVVPDfMOEar24AXEAF?=
 =?us-ascii?Q?k3FYtWD52190VKB/SWLhSZMMgbD9ruAWFJcn3UDX/Erqlp/G7xVdFs7PBxNu?=
 =?us-ascii?Q?hhT/iS6NHbCb9zvZ3MfZam2NttLULbGGGiCOQFDJMdvsHUybh8SJzZ0r4XWR?=
 =?us-ascii?Q?+mCP0bLMGJABTeNlwEEtHKvJiPAXM3w5Vt9NlL3Y3ddOKvuEUdbieEH6vh7y?=
 =?us-ascii?Q?QLYNNxFhYJkPfAzx8YVnL5h14kJ51uxwwhjduHBNAWMSTe8ZJVTlFSfI4Hqw?=
 =?us-ascii?Q?BEKX1i2ZEwJMmbj2+OEMLzWC+7KhyUFxBzC6ZC0lq/rHmFc+lz+aDjjhCORz?=
 =?us-ascii?Q?Idpu1yh5eVLJqGyEpAL0VPGP3CGY3e/kgZJ+ejnI1te/YXdh+W/b43mv73M+?=
 =?us-ascii?Q?T7Vj2jUsoyAiKiNZRnH4/4sLCkWvOOQqgZoKNkp6YdKgtmdN1rI1RG4z9eoQ?=
 =?us-ascii?Q?SEie/gIesmyGdGlJfhegQy5gkEr36/f3thb5lfaEMgshiq7rZF+Qssha2MAm?=
 =?us-ascii?Q?0U8MsrDAfvrWniMnAT04nsGv2Rf67CMjaeQk8nYXetRhQzBvVy1fwGZ7oGTX?=
 =?us-ascii?Q?+m4leVJl9Szf6vC3Rz2HsmzqSG+m/QiEYopf9u/5eezEUs+kqZyQhnQFTDbU?=
 =?us-ascii?Q?cJievO7rRa7AS1W29Ypp5A501xzjZ7rUzb/U7Oa8yy+bWewY5UOoxqUbC0Bo?=
 =?us-ascii?Q?5+R55HWpIkde+P4n+TPWaFVSX5z7YmH43gM0+le2IH/00jX3VTsniNAWehIr?=
 =?us-ascii?Q?ryVR0k0JNn0iWG+rMhixh8KhcqYBz56aA6x6x9GYFirstjYtAxzztFk6IuJL?=
 =?us-ascii?Q?Y7dNTkULHMA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uHIQaDWhk2JhWW2ApH7drFSgA7f3AOZzqwoCuOdIusj/+LT7jnN3Iy/OH8T+?=
 =?us-ascii?Q?8rl6TSPfWMo8icWmlCHCRT23/f0yKyDRz16zC+6FGmFHNEpgSgob6wDIsvLG?=
 =?us-ascii?Q?CvffIzXyhgHZz0pyp1FIY5nXf4KW9dZs/3pW5EWIRPnudonE6KsgXvTtUIk7?=
 =?us-ascii?Q?HRtgYPEMp0JE3uJ8tyaMSbbUe0VIkSiJucvxwQjXDyEG7DzsDbTnKYO7ATRY?=
 =?us-ascii?Q?B8CGhVydhWX49jPfVQj680P2iCp/yOg8OCiSzHuvmVTktu1eLCfUo8PS7H0j?=
 =?us-ascii?Q?riqfbbrC0oeVJGsz+7r1D/8WKjypvpCUVu2x8qf8ai7/iH0dsej4qONSlrFB?=
 =?us-ascii?Q?LT4+sH8OzgQzKIZ8gu4sZKDSfGUO8NzTvvVzqqRQh4I3KGNJzu/1BHCRjGo+?=
 =?us-ascii?Q?8QkG+SdUblASDipCXPP3ZtxFHDvH7Zwc+Qi6oY+UbmziAft6MKfXU261N90x?=
 =?us-ascii?Q?GOeU1ydJ1hcc28NBmy44zU9a7wd/sRuxuTY8eiEiCFhJiMN/cVASTLU7EyQO?=
 =?us-ascii?Q?H4r4FW9dsZ19Cofa12XI7gOM7WR7a2TGeVu3k0kRkzWZT0nzgTwhdNHBMalv?=
 =?us-ascii?Q?H6NgK6a3GIYsHlJJtjaDNal7MLrOSWSrZ4H1MWXGOssXaSNWilgwL3gk1Bvv?=
 =?us-ascii?Q?LruTPP2pcdWk9OQXxmb9GwbU04yW/s9nTT40Y4S/zxagsVPMQUAmBSDX5pWU?=
 =?us-ascii?Q?r7LsqecS3GfClwwXls3mlt5yaWCZbWp/1GvwW0kSExRiqDtGKO8L0UKJHDV6?=
 =?us-ascii?Q?vysND1whTu/Z82ReUC0W91ke10ECJR0HjW+Pvb0PD7utFjh30bpp5fGZOBIF?=
 =?us-ascii?Q?yzxJVgNnHlsJWC9VZcU6e1b/swBoefZO3aaX5wnzZXB1UdljeRbUVl2yb2Hg?=
 =?us-ascii?Q?PocPj1YmDQ6u0ZJTeGBiSCltJ6+/1pAynsaltPAvEWFSS+BnwtNaEPGsbMA+?=
 =?us-ascii?Q?B4dIJetAIWhKTOLRFiJa9rH9g3ESVWFpTO5zK6Kccd6yv9gbObxAol8XV4Ri?=
 =?us-ascii?Q?xiCDkTiB7jw/9yccL+5miUxlOzo/OC3CxfO+7C3z+Ov07Cmy2aoAL2N0MKfb?=
 =?us-ascii?Q?8uZs1rWWEg5cJMoRuNpbgjSr1TutxoVdm1iCjtfL+acqSeyH0WVZKeGRWPSX?=
 =?us-ascii?Q?j783bsOHH6JtUI42PQJW+AjT5HtgG191VJ5pVPEMBfxO8bhMOqJKwwBCHGwi?=
 =?us-ascii?Q?7pp43FfmBPA61p7/A7khp/KI7lBFzygVmUAsGPW/GnpGB0XDOb+sTgv0qqn/?=
 =?us-ascii?Q?DIzl/o63qZmV/ecVXomT101nFCGZN1bdYV/R1hvXBTkdBglaT2ho0ktGBmtK?=
 =?us-ascii?Q?nrQkJ0w8Iv4IM6ziDFmbHys15ECvejKo4sOttv/TLNcomfDXw6mDFMRxftKK?=
 =?us-ascii?Q?9rDAGZfhfOmkq3ZdwL84rIuF+qsH8Erz+8nmWWSauOQtKEBYZRoUX7i70RzI?=
 =?us-ascii?Q?bKuo+GgbUWThPZk7kX6hLX/lQAyO6VHwORrrlSgcKpXfy6MTRh2Jvtaow8I6?=
 =?us-ascii?Q?dHXOFL8AQwtv7UrmLUJHLRjk6MTiGV7qGHnqeBctnnDtqhs47pS1GrzlT3er?=
 =?us-ascii?Q?y4Vl3XL5A3JTGFV86VCrbC6z2DO5sCvyER+fvaruNCQHb7ia+N6DB8f0koNe?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	giZpiyx4c58sd9EfCMyhMXdbEfpA9z94aN3NSGAHxQQOjUG34/iAsfpfCELr6gHIifl0s8ncQlaO6KibPEKuBtvaSrs46HKSeUhTUMtT+dpH6klmJcSs9+c/R/RsxugYmw7+HBmgyoAebFA6Vi17m8RvuIgVoEpUF0NdNu9+gE1EM5/ht3T85vwlxT0Ze7J5551ya75Jdg49a8+gHOAGdDVJxPcdmGHc2LZ+CPMmfnRxOf909RZHoJ4qIsO6lEpe3MntSnt5ZSwV4ofjx6/F3Ct+Nq/6/2n4sWn6bXX0jnNa4avmfvq1TxfuxmGBKogGLjJBjKVbMDe0tyamC6mFjtrmZ3adimZySon2KrNfmrWZ8pz9zOK0OeO8lJROGA1IKLskavjDCouHX4rgPxY+XdLkiAx1DXjebQhBndRTFeq31BRgmVMMfxlZVWcwPO2PU1/W+p88P7AFufszyjazftS+UCxQFxkHRHLSZDjD7/XidlrdRSx1jn5VCJwNeGygy8HixS8nzIbkf+6zUGu8z7f1i6SF+0BfvZ5x3+2iEXRs/eDq2x19ZsrHNOEL5DhdN1q9osMrZvbJkmQorv+ysVUOQS0Ut10T4tVjZ0ZJorU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26034d06-f485-45dd-62ce-08dde9dd27dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 04:57:02.4471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFP8KEt6J3uQJEomtVd0L6dOfHQZxsxxYH3PoLQ7ZLhCizdqWWCAg7lEnsvXUHGGT8IuIvRuA/KBXSn2xOJ5Ics1p9s9frUbswFc3zP6Jdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020046
X-Authority-Analysis: v=2.4 cv=D8xHKuRj c=1 sm=1 tr=0 ts=68b67922 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=V2sgnzSHAAAA:8 a=SV1M4w031BOiZONITcEA:9
 a=CjuIK1q_8ugA:10 a=Z31ocT7rh6aUJxSkT1EX:22 cc=ntf awl=host:12068
X-Proofpoint-GUID: 0OHtI8o5Cny4omtD3QQHo2ImaAbTvb5k
X-Proofpoint-ORIG-GUID: 0OHtI8o5Cny4omtD3QQHo2ImaAbTvb5k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfXwtbwcv0XziHx
 DZbnqkw23oB4aOCLe41MUiO76fpakBk+gcmBhjonPhDu97l+p0heeToHvRxx8vPCgccrxFO+Lv2
 GaKeMk6LI9e2IbIS+aR60BtdUXibGmFPitxQaMEJT2yAY8SGi5WMRksGhbh8zMHSFNH4LZA0IIa
 n/cQ6RdAIFQCr8ZQe5GETQbJGjZyaGU8zvCAPnYLRCNSIcCgmztH/infK33PD/r7rmP5NphSJZX
 FPAmkROsE73EBdPygayFxO1V73q8Sl4KJviRT9t4hun4hAbDkaNGwlB8zdbtP07mL+PKDNnHb02
 L3QB3qpR19F9oE+TdCsYOs3zlB+KYw620yAGqNVZAYFzXpM6274iaOTlWFmlyT+1R/zyP7pcpZ/
 WYJY+Wp+GDP4jIpq7FMhVtxfY3qL+Q==
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B8D531C0007
X-Stat-Signature: hnw5pq6p948oc7nccmxopruyp15p46rd
X-HE-Tag: 1756789043-863354
X-HE-Meta: U2FsdGVkX18TbTSeOlbCS0Wod+8oeC4ZhrVeDK/IJLxbiSj0SFzuJdOi8sJ29Ma9LunH8KwjgDSqbFpxesWvzeWn9V0t9PSdLYM1H6rd9uL8fVspXk3tv+bGRGf7XcF0J/157R11w4gZbfymJWYZ+FjOIdf06zrM+PalC82yUiL9eIvK5g28ep2//7932aA3Vatqf9W9ezs8WLq0MsKxw9MpO5NLZRtL0YcmZeYEJq1/G5fGvlD2LTO+G+CeiP5OiRMULqXvgOXcTx58/M0pb1nVh81ZNJjqSb+dGPrSk1dx+DhzdqwCV+Mu7tYu4l0Qq7huYj0FFqXFFMNh0CkN9Jkof3p/umj6Ci8TLEv3BvkxE7ieIvnxdEmYrVv8XpQ0zs1aneoXC9CZge6RN1oFJYY6sCdd8V8gcwqphDxMeg5vXROyVzaB5cJOsPkZfiXZjY6rhjyeAk/al5Q7GBHXIizqmZaCJYI3MjBFrnSyjI4mkp8vowVzAXdF3GXuN/nIGxe3Vd39eU8voQvepWsPUfw9Z3p75ss9oBPkav97m7xkLc4y8iFOHXFDZkwaHlfv1et9N1oX7lYNttfy9cXa4GRADwoleUoIzfw5NqO0rjfpwX+5gN/4HmWgxM2nd6cMtHQYlMhMoR/5tg62YJcuE0Gp0TbbfpJHMk6QjZlst0ahsDygtpLNc6nKga7D8oBB8o89nW1CHjRYdH898GdiUC7M2SJZkrAaWkqLpjy3u390Eb0PJKgvIwSKdx9Ei88I/rIKIqGFJrzj1A4k7GafyUWoSmsw+fL4Fu/l7mn2b8MkYGuXL0ibVdCFN91evwTnoTgXNJeIUXM7TktpV1WPO4yg+AOsjZMD709+IFf01zHxhPfDpd5X47Qz/jR3d5xptrTCB+8Di/zqjf77xK2Hk5w5ZqNDvSCHZHLOMtNxxyq6/24GmkMvaulKfyM7jxyXCvlfkcYCh6QK7oZ3Gyv
 d6KDHW+C
 w2Sc+LyI1qd2a80pMt0DDmGa8M5mGYUUIa+x2NoukkCFHjd0rSDMJXEhYXpuwb5dnBm33pGrR3swTio34CviiNyzClNI+LRgZpuBz116vA4BLRzEOIadvehL48YerD1M5Z/jKd1KjhPjT8sMQtcZEOvDrsyHLl5sYjfICCpXx7K2Tn8W6CWGdLMabwbFloL/xYT9kNBBjZz7jBCQ3rXHHQYOrderRP1ct+OkfmI1lj3YQARexQLJOeK5CUbm1R1QgB3gDepVSZpMYOevXQgXTJRuXcVg24IjKtH3F+SQzAQL5LnVMGSO0yD9vZcpPefChNm97ImnBh2XF1g+nIGVb7dNFWbKtaJNAyEBrwwfkg198t1t+PO6ee8r+qTUP2wscd/or64k90vR3XIBka5oklM8cI+NSkwHlmcn7pspNqww/uKuWEf/hnOLJo2VMPJn1fO2z6+bHnzEiwmsyDFZTBdANgAlJrwIiyU5BguKY3tCv0H/yO414se4Q5mHWIteBL/1RVoFzXpr0Mb8aMVW/oBC06PMeAIA/JF7ltXwaROQqqvJw8Z809nGv/FHXV1PaQNksEYslSdfnI5EcN8ZiKNh/xk/iz/gZZI9UZ9ZaoyKrMGo/YgrqIN5pHi/b/xXKzBPu+eS2suUcAwHqg2sj2SwbeD10Zxb+D68jyfPdt5Su86bPT+oeet1pBKFPxM+UNODE1CitqODlFrp1Q8ScVDnp0UXW7PzV3t/QZ88EdJwkqjI53QvkeXCNZBGfA0Fd229ezCjWgVAToWurwcKSLWKss1zYVvqV1lZvpQ+GJjEwifgjo3kSOMwh5S6jBAYPowaB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - could we drop this, it's breaking mm-new.


On Mon, Sep 01, 2025 at 03:37:28PM -0300, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram, it might look like lots of pages are missing. After this
> patch, zspages are shown as below.
>
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
>  mm/show_mem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d..ecf20a93ea54 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" writepending:%lukB"
> +			" zspages:%lukB"
>  			" present:%lukB"
>  			" managed:%lukB"
>  			" mlocked:%lukB"
> @@ -332,6 +333,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),

#ifdef CONFIG_ZSMALLOC

> +			K(zone_page_state(zone, NR_ZSPAGES)),

#endif

:)

This is breaking the build, please fix cheers!

>  			K(zone->present_pages),
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),
> --
> 2.47.2
>
>


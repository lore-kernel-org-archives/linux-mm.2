Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E83DCF3185
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3986B002F; Wed, 19 Nov 2025 05:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B156B007B; Wed, 19 Nov 2025 05:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562E26B0088; Wed, 19 Nov 2025 05:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43CFD6B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:00:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4DC84E23E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:00:56 +0000 (UTC)
X-FDA: 84126912912.16.DC542E1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8FA5A100016
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:00:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GOHDsL1f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BZApsw7z;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763546453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGmu1Lo79lAkt5n6KB+IAaUltI06L5DWZesa6zmbmCE=;
	b=xx+SSyEH1cwuj/aiiwkdeTeT1HovcM83+teh1qhNi7NY1qdGqHZviLEZnq27jgGTcnQTAQ
	decwUNso4MqdmDs5FlogSVPJiJnvjtpIZH8OoK/vtiduAWNK/aK2cZ7AsNmeEfF9SRL7Mf
	cIp3HToxTIbVWU9JDO1ZL+NaMq2Mpcs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763546453; a=rsa-sha256;
	cv=pass;
	b=8P4NhjR0Q1GopW/xQLRxusg8OwtEFyZNFFjXjfq5AZIgFzGRQ46UIrymIVRzMhcU5phBk6
	UgV/X9Se4fVSMF3mmGtdQVot1DiTvCDXhnrj1wZA1UsiMMp/7Lx33Cq4Eyk+gmZRWNZjB+
	8NNWs1g0gDCu2AEjnUK6pmwUWx0KQz8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GOHDsL1f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BZApsw7z;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ9seH6002812;
	Wed, 19 Nov 2025 10:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WGmu1Lo79lAkt5n6KB
	+IAaUltI06L5DWZesa6zmbmCE=; b=GOHDsL1fLvmHJrtNxCN3SFSPUA3SAzZHLG
	rjcEmb6g7n2y0psxFl2+g7KKk+DuC90GKi/eYz3w9f5vW/oK/d4IkIC0XZsladC8
	oKjg44AvvRy28zwhtsVG1RBKrZDneLE/w9U73AcjbumkS7XdAWunKSWjDvPGj+l0
	cHNCES/0wuInaus91H32FyV4TN3pGC6Ca2Ny4pVg29lBekTZN0LxotSeUX0GRVYc
	yf8vJNG6j268gMoVD7qRK4JX/9ILXJ5bVKbYFZDpKjw1OnV/1vnIdrhTRXgLm+Mb
	eEEyEs6qe/SW8d/v8PcLaVtlLNHwcRpnvq31OW/viUOVFqdydkGg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbxmuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 10:00:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ9SQJJ007160;
	Wed, 19 Nov 2025 10:00:34 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyacmbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 10:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UKuZAhHtfOF+TbAQq5awElwFWkquTlOKA5R3p0pKwjDYjonjeqvPekxcTncXJXqyerqTdlkPMyA38dPCGAaSV4Ng6BywyH7lvc1Vep+W8EbPvYh5Xn8GYcZNVIGOCMhzEcyp0hy/5qpPluwlbEqVESujxRV+V+2dOgcDjBm8EkskUQwlX8lLxocHvStJwJksiCdE6AqaWc6+Gr/CaPEXrpiuqUjkLUaGrpdBRKKryFM9Fu6IzIHi3XhEyhNJUK5CeXwgAvX1uNv91QuaeqrxN+DkkTIq+H1DMQ2UXpZLGv6wuICyPs/fjHRIbhdF5+1XKRxm3CMTFDTPHZ8qRUhhNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGmu1Lo79lAkt5n6KB+IAaUltI06L5DWZesa6zmbmCE=;
 b=qAzUGu78Hi2YOxZmStO090mDwTkz6Zb/a+dTx/7YKfdxbWBbqPnHdTpn9W9UlWD1cPKWT0mXU5yDDmTuEFgXjzIqz/RkTBpIObQ6NLfVQJMslwmPRMP7ehmdFjQuURiLvqZ0/0esQqPbbivAkgHRdJ4fJn6Sf7sxzsdTGIZpyRToI/H5n2PaPMrD9SEAtR5Cu93SrJrr1z6+ixlJpCvMHGSSzgCn8N1itL/kpcoTUz9A0+dMFurBzYgfHFegvpOPgiwzRN5DH4+MrDsMamBqUrcfVS+tvgjRHQjTMC4Pg6Kao/UghnN+NiJS7PA5jpzzrqvKw5PAuYs/oR65Zu7RRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGmu1Lo79lAkt5n6KB+IAaUltI06L5DWZesa6zmbmCE=;
 b=BZApsw7zDkZQ5LJHNX+G4HLxK44UlRTdEv6/c3D0oc3jmzjcDhSL85059Z3PffL0ZLTPZM3mBrrzRV2olFxS/PgsuGoZypaYrcdWlzuF2tjFYMycf596XmX+ubPlgCfvLdlAxAX5kdrUJ9CakW3KxBPzjtHIvISIO15B4PUyPbw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8325.namprd10.prod.outlook.com (2603:10b6:208:55e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Wed, 19 Nov
 2025 10:00:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 10:00:27 +0000
Date: Wed, 19 Nov 2025 19:00:17 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
Message-ID: <aR2VMXGqE1cfteLQ@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <2ff7f2f1ac1d3884c549d9b5134322df21703018.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ff7f2f1ac1d3884c549d9b5134322df21703018.1761658310.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SL2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:100:2d::25) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 37e21b55-27dd-4110-e185-08de2752771a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N6+tVbHfsdibZgFruVakEUkg3oMi5zNNeEoFxdI6cL2VM+672/hiKuk7Tw8r?=
 =?us-ascii?Q?CrrkhZ4Ackwodi545MQHZqwnhXzBlCWjAXXhQIp0e7AVG7tCdpp7lUEVEpfN?=
 =?us-ascii?Q?9HgRMlwjFNYvoFZIz7hPyIJ9CosGtvkLpsygETY4TOd/NxWHJ8a6qNcjQ+5Y?=
 =?us-ascii?Q?QGfDSNbTLPn4KCzna8Z+6gYEXTDRYqGCSPOBwn0Je4b5ZpdAm/nHd9rRp+AB?=
 =?us-ascii?Q?nd3d/6kNsEOrSkxY+eo1ceHtRRYsAS8RcRCTZLTvlVBguSwlRl3XPtnondBI?=
 =?us-ascii?Q?uTh/49shLbbmvBx7SZdfbugG6lTFwXKwalyMolRYe9Epyzg3vpiN28Dw1izY?=
 =?us-ascii?Q?5Jge0TJIquUpkYgtyboMlmrgRfTNC8YtaNCfN56UCKMdCH6o4at8wGTLt3TR?=
 =?us-ascii?Q?ZMm1G+6C9gjdzKSNnU+a54ZsZWJD93ffds2mhx/I6hqlm735k07nKaA/TsKa?=
 =?us-ascii?Q?tKXr/dsmsPHTwm4XI/95cXS5pIgx9tsefeylg8jh/J54aivD4jjbXukr1QS2?=
 =?us-ascii?Q?R2Js0SM46TCfg3uU8av0soimusAj5B9ziYkYbGhFYi/bwFOktoA1krmXLKbl?=
 =?us-ascii?Q?VppgNf1K+cf4PZVCPGhFwKe3nOHsJIU1qrijXLEi8JIjoZRRSSvpH5LYPO7q?=
 =?us-ascii?Q?0C1/x+QSs8wm0nQ2MUBP/F/x0Jh7bZLwJN5U8+erEB2XlS/aICfBd6nKWlbu?=
 =?us-ascii?Q?1+5hk8zpotB8QxVYJiHSnimJVRE4C5QI9gtmDVVKhdspF12KuWQ5B78Bn+Og?=
 =?us-ascii?Q?foFA9sViaKQonBuT4mTgwf7tTXQ/NeYPNZS0oezLhEpdje+6j290KLaKWq8r?=
 =?us-ascii?Q?wssKgyAzpAZrIXYLiUcD+E+farBcIvJ1yHWxwye8SPK6NImNyF1WJFLFCr9v?=
 =?us-ascii?Q?MDOXFHazXBtU1TFiarsVL6oooS78Amq/L1p5KWFcxHiOW+oVQjuAE0bus6gi?=
 =?us-ascii?Q?Li43aGDB86BkS++uytecJ8eGO6C/yNrYKFd6Ft5fTqZZVFpxc9wrIEMGrfjc?=
 =?us-ascii?Q?9b5HdVRZYYfaIQAjSvUbRrpLxOmv8Erft4Q2tKWsiZz3XalRAkWGr17patwf?=
 =?us-ascii?Q?eQwe3Ma0B+cTD9wHWlq0ZdmNcgdBFX6YC5idHnnLjeGfnluGyXg/wjQLS1yb?=
 =?us-ascii?Q?toqS/E7kAhQ9Pn6S8ulAc4UBIiPSMSiLUriuTEAK9jBYY5ru9SQqnU50YEzd?=
 =?us-ascii?Q?a566ju4POVOFHesqd+8O1zcYCOnRZ2Tm5TxFEHrOjS9Hckgway/YYfGxwzuB?=
 =?us-ascii?Q?42CWXQWy4eKOxVUtphvD8umaeawRFmXlxEyvIRkPkjteVtJB7n1WQ+jKaAJ+?=
 =?us-ascii?Q?rpRq7u2al6UrEVa6A2hmC4o8mjAFFK7u5FfIgnPG7tV0BQ9lBQQ8UX5fZKGi?=
 =?us-ascii?Q?ElZ5f1Gl1wKAGEzhJnPim38yAc235PlrBzWrvATu/A6PS5Sf19c84/q5B92r?=
 =?us-ascii?Q?Pz9/h+he1Kg0KP3EQYyMud1Qs/S+MH2p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8lO3+FeLas9uOYRe/8zYmiRvuXfWbT5IPMYelP3l4n5fwOLqBb5KTWIDbfee?=
 =?us-ascii?Q?kh1cePjT2PUb0F5iPdIPaNJQ3rg4l1ZauxqrgnZivIkUy4iwwJnp4ECLMLxi?=
 =?us-ascii?Q?HX4E3YitW4utXmmroyxrcmEY195kguMCQ8GCqHTA+n7OrHUW1jZ8/b6UYH8X?=
 =?us-ascii?Q?6tEa/2sTQy/p8nOOojXEBz9WF8OoZFwu94e0UuXZhtkOXhpbdhh3EDKMsJ2S?=
 =?us-ascii?Q?qa9zk5azs7xuC0pVSZ840kMNjhSLcVN8Ofb3d7k2BEIyPphfl3Mf/+TBY5Pv?=
 =?us-ascii?Q?lKboQExHrS6YZYdrWJU2PJ5JaLVEf+f4zDcvmUa+9ljXGUX2huMq2IIgNDsR?=
 =?us-ascii?Q?rtLRICFwlrvfpFmIBsg9d/vNMC3wI6kEyyJc1viJDpxKXdWuV2zUh9Ms/l5l?=
 =?us-ascii?Q?K6Pi68cFdMNRYq3K7W/GAcSJu9IbVzGaIiYcubHB2qucTZpqaefOz0WYJIFa?=
 =?us-ascii?Q?vm9XDEkIbYTjzaJI4g4YoSdIMXzrRpYMFtodoUbxpxwJFFS1PF2hREBAeDjT?=
 =?us-ascii?Q?q3ZkgxhVnm99ZgzA+rqtCpJgizVijQAwhFXbE8EXoLeRibUbpF3JEDJbvg8y?=
 =?us-ascii?Q?8DsmGcE7cj7YtG87+yo659GazOsOso43qwpjo82XBj+I9z1gsvzV3UHvcbh3?=
 =?us-ascii?Q?jlrSbBP7x6Jus0w0rDUih4GpPcngTych5xMcYoWxlybqKxOPHzZ6qL+FwpAH?=
 =?us-ascii?Q?/lv25pqR7GoI3+85KuQ9kZ2emOl29il/Sgr/Gxe6fyq4YOZZ4BcZqTPtpozf?=
 =?us-ascii?Q?psz7CBlBItNrTodUdYgOgiYgaqJV4XAtCHVs40L9lFURdvawkb5nCGRuPStr?=
 =?us-ascii?Q?NjRtTrIGZfkSjpr2ndGcj6jImnGXoCH1h4X5r+uCRW2XR2xRNVsjjGbpHnYc?=
 =?us-ascii?Q?5LDBv9IfNt3El7RyKNA8as8LjNUs66Oy3Dbi/bPxOe038SNcfay66XyZxi4M?=
 =?us-ascii?Q?+fDh/f5gSmHBWskmQTg1MVKe2R3WXb+pMq92Kpy83eDCh64dIiTvpZ3w1SbW?=
 =?us-ascii?Q?4+r90j40FM0ds1UNo5eMVxSoUQNoaLuWf9FQRvHhL8x3SLaC6VuSlSaC8o9t?=
 =?us-ascii?Q?VwxL4YpU4ycVg6soAo12HBqXDLxElI9Nv0EXzFOqRNVLka7+l5KZyE6xOF1q?=
 =?us-ascii?Q?ulC93Gf8fFgyhIJYoBppLzDiG14zghJbIui5/SwvrOYgHlzwF06dYJiwiw1M?=
 =?us-ascii?Q?OqtHq3En5QhC8vRxghCM/ndPMG5N305ySx5dpw1eZqhd+/iy43D5cnmbkZIf?=
 =?us-ascii?Q?izQ8x8SqfIOfH+pAsK2Fc7ZIw0P4ToaGtUO3I8FVOqOUmq0Cz2+okRasF0DZ?=
 =?us-ascii?Q?/QhLWL0MBD0hg9AFRaURzRab6JYTauWFlV1Wp0xwuZcAn9iZizPsHfV/IaF0?=
 =?us-ascii?Q?AmTGwgXIzn66Hn37Trfzkpp5exxFRdlQKxBoxh8rX4We7WZhRT0WFrW0+7v/?=
 =?us-ascii?Q?wlZoQujHJ51/WSoEj3efB74HMd07J9YbxnQ9Bll+mXKYx2qbTL2If+RBmxXQ?=
 =?us-ascii?Q?Q3q2nvjMh6N2aehjXQ94OODlWiMKLgUoyZiVBT2AuGv7EnfuK4JPXaOghTfN?=
 =?us-ascii?Q?QqiOvcSBBffNbVjdT2y5fAWPZNDv/veuN5aBC2T+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4qmZEMGxTVezTeyFLVVOZXcqbDfnQRv1ek4s5ozdrd1Z5g4OT4L+w9NkYo3gPPazO8AR/t+0mR2zYBsTqZGp+NIvgOVkbhJebhuCfF2B6diFu2nm7Wb571Kl8hb1x2o6l/+mxanvfHUto1ssnttUy1HKksnPDofFnqPm8SuyHXsoideXyrL+odT/79USB+ocCBD8H4gLUjIeVqK0sohis7TxlLXoVGCTQO1xYLFm20LeD4zvEqslaYa5oav+14jlVP+YJd96QsgdeOl0IbWtTGwKCwOIIwF1xAg0/y1GS5XBoAV2JED/QUnq4ROy1GEs6q7Ryi9t8A10k8CGB91QEDmgJp+PU1Xff8Krs5PwcRPho5xJmYAjfdoAMQN0UAtDWbVTxToua9aBYjaDh3b3YqhlKpR8D+4MGdPwHZ6aodr2iHt2ED68bzIm5e0xbzMMb2jSL1s5/qpbs7QRHOi8ou4Zs6P4hJZd+fNSgQWNC1XfIwHd4UhTLIUIicHyQh3o40/D03225JZ8KWOwfrHxcAoiA50uiVQntaIRKgI85X71Oacip7QzQIf1JKWoU7BjU1FBhQs3DHBAXqOJh3aRVEWxSY8JCkk2HQ+22UIokFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e21b55-27dd-4110-e185-08de2752771a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 10:00:27.5031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCVJ+BylrgLFQ0H7ECLBuElkSU0vHa3nEAu+PG/uKR9qGr47V/DyBAglD5rEReoRN+uJER9VQteBNFwKFHDsIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=888 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190078
X-Proofpoint-GUID: _iw_HSDxRG0rU2SHR0VygkyABf0DCGYP
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691d9543 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=WKiVBPBMbvKHMXwaU68A:9 a=CjuIK1q_8ugA:10
 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: _iw_HSDxRG0rU2SHR0VygkyABf0DCGYP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX0EP09NA6nAwu
 5Ua+ICJjqE/lmvdudZ6BtebFtrPezNMM/iCQ+wC0U2dek3CB8+7HJV6QAp/qten21TPyXL+HE+H
 7Sb5b+f0zGpU4Egglmm4ZI0a7xaqZmYo48vK7NcKAWSSMscjXzL1ZngMYIBYYmnBLqRlSVOJJ2A
 xf7EFkxKTg7EUjcc3FuX8iSdkaQz6VlNLQJ4TnD1aVEefMzwlqCwhnFAL2YphM6iUjc842qNqou
 /08SDufdr8S3vVh5Vs85P0q+yTRJOAWKRxbJXMhy/q2tSJWi77L7s8D5Rx0x8ngTWN8QYdGM+sc
 vR6EGvgtdGGt28u1L/Y2RSeg0VFPHyDh0kPsi/r7W+rONaXnSUZH4thyMMbLGOGB8O2GGVuyuEF
 lSKliawhiZqqlbMGiA0mI0yFeipA8A==
X-Stat-Signature: c9h7utwrsrf6epygof59x8t144e8z9qq
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FA5A100016
X-Rspamd-Server: rspam10
X-HE-Tag: 1763546453-669528
X-HE-Meta: U2FsdGVkX18pojSI9XMLHCY5jkA7AIRtpXs4mIaoqBvysoDTn1JzsO0a15x3FKs7oSClcn2iPRZM8XNL4qNcu4PSR44AkEqABMv35jsm35EMtaArdItEqRM6+/IIoFifFeuMPLvaA2UH3rrEW5dEfeYame3+d0fABZrvw+BhVrMdUCn91XaPkrdgP+50ib3W8h2qH604bO6warwTwgdMZGG7LVw+yvrXPSR0a64Lrh7AuHDwbfx5sQWi+w/p7TLna9tHg3f8AQdmjdL5wAxrrwAUUlI4n4czHeFebPnkpi5pkPkv10SNl+TKScNa6DjjMlti+sdQhKpPvnThjobby+HGHCG7METg8tB4mOv8k3mNHoXPeqDNPHzC8IrHkdRlnzNOCtBJRlcGC/dpcGIRkq3sey3vERlwEraomv+swc2fuFGqh22/tZBGuG8oXhqyGV8BFoE5UEU4Po1+TsFs0/t36riYMiswMfhBUInae1HfSC4uEdBsz8UZXYpTI4C7evRDU8Hvh3HFPq4f0DOMysRCe+Bpz97HYgJadA94YjIV3YOAlmU+kOZoT1DykCUlOHFC+magDwHSjHs7c/1OcRNSzagy4roIyUS3Mfh5FctBMFOdVmQub+pHENza4RUx+/eP1WmTXEUt+RFSOgCT/+tvnxbUEGvYlR8Jri6x6/V1b6v49kvGpFcveX7zw9yJiWFN+3QUk017Lub8QcyA1hMHpD83mAcCW0ENHsgG/SrpVTEjqGIQY7c7JAsjGCVRw/XFX/LQ5hqIeuI6Awj2ig9VCEcrSBkAcfozcqDTg69MWCSSXM2v+pWl08tbYcJxytFs7MyuJ7AbP5hEKn1qtzPdzju+tH27dAhiWWXaKpLjJOoC/aShwiV2cM7LGNC/k7RIVDsibkhOHo7eSKiVljBgffa0IFmh5QKk+JGIkIvsAtr5iFPOMkhUAHRcslhhGplABwi+T5WV0/EEujh
 vGDZX4Jn
 BlWy+/D578ejfV+JUWjdKCS9U3zpG1mW0lV0ac/Btx1g3QzZGUa6WzV2zQPU0NjRllp6C4qvyohWvBpTHmYtZnkqbZH0S4ve+amPE4ZnjQ40MURmnG0VCaj90+VXjJZuVew91XcplPuhoIaPhPbQ6x/7isEcP1N7nAHqBp2GTb3mRGj5V+wp9E8xb8fAFxvje85ElYYoDRrncQQKA9yCon8wqAbS0tqlkLlcEaQveGeXsdSY04AmqyJOqR1aP/NOty+hF6FaAib/2t6w7Xtn/VtGfzZcfjFXgJ3Oj07veRvCvNRLMIW7z8KOpwR95fbjQ7ef9ce3eLRq09p4UgugPFQ01eWqI7j86W9G9MYQUefZCAGjC595j2QtS5emQAwbQjbJRjom3e16s8hK1lldxYIdKGqvQ2AuGeAorCheURVQMQaezlJAWzAyQ5s9te9kCjRDyrLjNlPz/uhUSNaQeiBdjuhzpeT2ma0ImxCyuJFpF3gIcfvZ6O8mz7AUcfsQ6F0lqnqnUJZU3eOy/hXmJjIg0tJj+CQRlIecvclhgdWxmUxkKEWaLcVKMFAeLAVutm4BOiVlKYddnbWJCeZ5jeXutTA9HURgJTpEdnJoB6HbJ6RRpJIs4wvJB3W5At4Uno6E+iy53qz07TCXoTMUrSPWTlNlbJvOaINYycD/mqngfguSv+79zRQOL+HG2rmPMQZGQGFsAB41PNTfCHXrZczrnemc3Lm45+m9rbsFJlXc+cjTsP8Z1ipxaRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:25PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in folio_migrate_mapping().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


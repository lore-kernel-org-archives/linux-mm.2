Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13312CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DD98E000B; Tue,  2 Sep 2025 09:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDF88E0005; Tue,  2 Sep 2025 09:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247CD8E000B; Tue,  2 Sep 2025 09:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2738E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:13:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C1B2160180
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:13:00 +0000 (UTC)
X-FDA: 83844350520.06.703089C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1DE9B40009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:12:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QWe6oRDo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dHWV7t8W;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xT92qa2wXkF0GeohmzqILnUrdMS0YPgitgbZonivTU=;
	b=HkDXpDB7OB0cYi07Ro6iqGZFc46WHAVEJH7w7WQOtXhaY2pC0z+tKxgAZLyp4pHeiyadD8
	/Hz953Eavj2EjgYe+iX0GZPmMkzpxrQM1JSjV7QeSfGlpgm08r1IpCJhfZJKOdlTLv4kzi
	5+zY2/tFW6PdRcabxCkK3OaTWZl9fO4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QWe6oRDo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dHWV7t8W;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756818777; a=rsa-sha256;
	cv=pass;
	b=TDKo65HmRGEr/AAkJQDg9zOgGg6H5EVGp/lfCdgLWtFrCTVh0+AljGYGZv4Lj7/v3sK4do
	OQhjT4nAiRcwrU+teduajD0wHOEGvV6lyzXzZ9K6fjLK0P7fcyhpy5YfQGFqijSNw/5zBz
	fC2MDxFo3rV6scq0e1bl2RuFbdmngHU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582CtspW010519;
	Tue, 2 Sep 2025 13:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2xT92qa2wXkF0Geohm
	zqILnUrdMS0YPgitgbZonivTU=; b=QWe6oRDomPZnNdYia9HrMmBHy8RfLmAk0W
	exiKXjTRKtacT/Yi8RhmUQnD5VEviDDdiQeNaTqxqWnpM4ACeveJdR70vJK+jjLI
	Bl2WHqX9Y8zjvbq93iEytCjsmapEk/tCaszeRvN+lVLYDsRC8R+5bnTaT1IW3gJP
	txe7PRApavGp/diHGZ5xSgHR4474vEwv4cRIt5IDa4Lyognoa2ZMTekY4G0wG9rs
	XB9nzRtrojrisOlfLHrtXDIBbVt9qCVUnEgjbZdQ1phmbzUjTSJ93kv8R/7Pyn4o
	aMHnJbxvB1X9Fwl08kPjXpkLMPMWrekEamgbtMnc+t0zM/O0UESA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushgv09r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 13:12:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 582Bnksl030962;
	Tue, 2 Sep 2025 13:12:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr95k03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 13:12:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtQdChmI4P0qsYVq1KR5u9uCJbLOux/Ds8GcbWkIO1uAQ0uVDxZ0HfH1nh1YPAv+eLQ3LV22RTiDUpYP/mFzxuM8ls6AJfHR4R590zBZFPMll3MnswHMzeIdJ2sYcSrYtEXnuV2ZIR+ySN6tastJRAF4q9RObvwOmgdp5fTLN7E9B4d38mKlXP95Ud7ELK9j5fnAapS51tikCIg4NHhlyZggmMlhvTSwJhh3HrDI9Cj0MQ/dEaaHbLaH8+Tic+JsIWyBYOlaNOWZBOxzBqwnCeZ5p/VfiLgAPp+wphnqmhwXNNKYpW9IZROTps33Vz6vs+oZ69UykPurhCRN6UGiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xT92qa2wXkF0GeohmzqILnUrdMS0YPgitgbZonivTU=;
 b=m8fP+hYb3+5lERuR8cZRkFjMn5hq2r2qAJs+zJhjuoVcPHHYs1VNwMDpQZm4vGl+jRU1zpYVF0RDYLWpKy9Nc0mLh3c/ZlC4NE25SCp2J2MQUnMiaw/yQB5NiKXEtf3r/wWn/sPmv6+JMqBYZX6nw1bWtZG88LrdF8vuqEqvUgmzu+x4b0v54g38XiR4dLh44pVgJucEzE2YjK7uhkp35AWZmAnuzvsz+dsGfdMg2uPn2Pwea7TKanc7MF9vOcvlwwG94LuKaCtm8VP7uySjKkSx4B0RIBnZDyccM7a+kXdlmq0XMkOsRgrNBiNskmqy/vKQIRkcC/stWxosm5yxgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xT92qa2wXkF0GeohmzqILnUrdMS0YPgitgbZonivTU=;
 b=dHWV7t8WDiYeC0X4IMqlzH7uJa7xDFoj+Mkq7e9bNaK4haH8BIXxx+ULyOefx0GFy/QVMHeIforEkN9Z/Dn7KwG0tG8YzNWVuAoVUVOrb9DOZBhFIEJKMGL71ceZXn+JOXI77JzAhJJZKUM0q7VReJzAKXA7wqlCokvy1nFb/eg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Tue, 2 Sep
 2025 13:12:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:12:35 +0000
Date: Tue, 2 Sep 2025 14:12:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in
 show_free_areas
Message-ID: <90d5dd6a-ee89-4074-b5cc-0cc3bc3d68d2@lucifer.local>
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
X-ClientProxiedBy: LO4P123CA0392.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5046:EE_
X-MS-Office365-Filtering-Correlation-Id: dffbeac0-96c9-4143-7633-08ddea22626e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dnZ97kWQDDQdN43GqeD7pWGvjUghf5jv1RDbWYGV3ParFlMkQrHpgO9iPA9h?=
 =?us-ascii?Q?DRSbNiIVrt0CTzTo4YyIIhlAvZwu95LHjgAE8A8Pqu5KsZfdG9t3BKP5onC9?=
 =?us-ascii?Q?zqmIScgGgdYwjUcsBzD8njZ5Fd+A0n+LZBXLG2HYJZxFlI0RNgv96RyRMs+W?=
 =?us-ascii?Q?oEWgBH107ncgW6pfd3XcOArNrtIPyYz+JI2qjIu4doJzduNWyCEqxGemMbzD?=
 =?us-ascii?Q?+RqYlX8cL1Ikb02z18VqjnrP/jq4UTaXVOk2C8r0g8g+bCcO0oPVYyVOGsre?=
 =?us-ascii?Q?G6/OHpaMcbAlkPjlcc5LSE9LFa4n247Q3wJb2nHs3kS96rcPeiMSdi6mOUhb?=
 =?us-ascii?Q?BZl9EqqShFscgx1ea/RsrxSpRUCqPCWe+jd/YzcBbSGDMIWJNp89h/F5o29Q?=
 =?us-ascii?Q?gIbMOxjeyof4suVVVmzCH+7zL+wE6tzaHdsSHIhYxbHw1l/7sgvUq5iHwBEg?=
 =?us-ascii?Q?bp5NGXR7ZKMyBEKEwBOAdbfqckMajU12fJZKOGyEW9tEI0dbU6pFb+L4Hn2b?=
 =?us-ascii?Q?Wfs5tA5035CHn5oT9Hz/QYhXAYnDQ2F80UlGJUmm5Ss1yUee5MSA1+66bNDY?=
 =?us-ascii?Q?O5xWjaba1WnRtukKcG2toWcQo/E80LlOsfRz/00nI++RSELuHMx4izE0uvSz?=
 =?us-ascii?Q?FQ1ogDePSE1ZgajQ9zo+XR61Vtsh7ZqSNgqNN8K/4pN776T6w0ReD6YE6vX8?=
 =?us-ascii?Q?mk31zajbJJsqPoqtNGa4l27JGfbdaD4G2UtuWkRKDTvexhMCFpv1n+6jFl1b?=
 =?us-ascii?Q?MqtCyGUNxHlhsiMD9JzWwingPVIBzGCrPvLuBr7mw4dRaf3aHh5t2g6SJ9kJ?=
 =?us-ascii?Q?HgjaemAEa/rMPta2iJQhEGJhUoQ1c8iB5vSzvNFj0SCJzJHm8tD0wLPEXRxj?=
 =?us-ascii?Q?SiMkfEI2ouMCUGcgSV+ZZR0h/ga0dI6/aUbf/VlBwWuR+o0GLDkKJcaT18+r?=
 =?us-ascii?Q?0/jfhYLGb92ABj21o4Fzqh6P1nnaPmsbs9pYmEcIsWhTgT5dZBiGCw45FCGZ?=
 =?us-ascii?Q?HYyaZ/JAtrKwAfe8hwah7Z+M8iWFvPzVCHh7LTobWjmwfFJCxjszCe1h9FXQ?=
 =?us-ascii?Q?S2M+/mc44sEYw64wdbhCVJjh92orwMXqf8qBmno+c07At5NEBAjRcIDoCpit?=
 =?us-ascii?Q?CDlQtbosOiPo7PhKu1Eob69TYOVz/1D9Bopn/cTASnsnhgyPFQPge/JrBmk5?=
 =?us-ascii?Q?T47nLXfI7vXqOgT3VDGqBz9IzkFA6YS/zgSqjJrK8KxscGFVwQLYPKnJEYOJ?=
 =?us-ascii?Q?A5iGym+16TxqS/Owqg0r7pYa2hgt8r2VZ2GTaHuvbMPGRM7W1U7c1wMVX7hG?=
 =?us-ascii?Q?CWCh7p+NKDCUJ8tLXk4sVb6jhnEGIfSNypCK9yjR1+2LRNsOUhgcvuW+zV6v?=
 =?us-ascii?Q?wlwQiYbLsVkcAIDufRidwdnp1vOpDxS2uUjgWNWUFntmzdIFRvOPfGp990gc?=
 =?us-ascii?Q?5vV46hy5tEQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?041NvnZ1G9xwuKfLVz9ytoAJixI+ykj2tYuflAE8ntAuY1CDTNhn7pSAbybQ?=
 =?us-ascii?Q?+4tyPFMEzz6+KLvZOIuLN3OQUyirJaJWgyjKH5+vOO3ytQpyJBXV0ts8yIvs?=
 =?us-ascii?Q?2pz7EyGdiMs+kLSZWxDbQpeG0p93XJMzS7mXnomypV0g5Z9gRKv4xWgf6pzw?=
 =?us-ascii?Q?50dkf4lxQIzUI+aLvvy5jE/8Ro3BgaI6sMWeD6zoGeOTdXqMmVdMm4TIRrle?=
 =?us-ascii?Q?9KVRgw8gImEIN2cPsAs2xvfxuI+ynfqd3osHtA4R2vZcX3cw6MDk1UgAd0kQ?=
 =?us-ascii?Q?hmZAvPnb9vlx8PuIV+w/XFzcGjDHo4PytLixh1yvTnp4xa9OTC2S7fQCJbKw?=
 =?us-ascii?Q?3vWVHcBdRWBAynZJmh+jQpLQcAfOZ/rl41V94MMVoEAKJ6BjjF3rDGz2J4NY?=
 =?us-ascii?Q?DI/URR0uhODZax7BgIYkdllH4Ag5qzpgyqEtXC5v57jOBAvmO4r8qwhm78LP?=
 =?us-ascii?Q?CvBioic1aIvID62aigeEa5p91tS+A/VxnQwToQFarXhYmAIKs2vKlLNAsbMA?=
 =?us-ascii?Q?oglG2xS8XGF42ZuIkz6mXO4SVLwOihVFRAbqcc2DNczXF2Krl95+2c3wPiLD?=
 =?us-ascii?Q?ZXFh3TbL3cjH7xrHB/BFQlbF+7BEwuHoILn5omRRk2NaPOD7CkOLrlHWu9QP?=
 =?us-ascii?Q?j7NyYWgYPP/WNAUCtmX5b0ra2m2CbIrl49pCbaygraVMFZvBLmpoihB4hU+q?=
 =?us-ascii?Q?3yeD3uzyCCwZqMhNrMTh3HsphE6/iFUDwNqbxxOpSGLvwQQlyIw0uIthjClA?=
 =?us-ascii?Q?a/TH42gSfW46O+TIDli6U83lJwbrvGLMe9Snnn6yb2RkZ6ztxKD0aYcdISZf?=
 =?us-ascii?Q?6+L3Cfap2Nhg9Wlj3N+cX5UyKUlzgbZoLR0D4YP0g0T/VrVIz+VBU1xuECtH?=
 =?us-ascii?Q?daNP4lN5pJRiYAnJQnwLhheTSyx/0pc41q5vn3uPm/IiM60td26KMyVxPDko?=
 =?us-ascii?Q?z4Glk5G6DYqyTAMilsPW/aoIb9lwxNRmDkZ1y226toGqBlsyEwGJQ4MRSc1w?=
 =?us-ascii?Q?UigNiZ3eaaLKOwIIEl/HbVn+reGcbh6O/ddiiGrJZgJQVyg+wdvXNtQ8oEkJ?=
 =?us-ascii?Q?gyQAr/MYLUFhj270w4lta5PQUl9FnQcI1Jfv17bHOQ7dMN/CgZryNTVBpYx3?=
 =?us-ascii?Q?LNtX89HynMOIGZ58YamMX6MdUJeJzI2D9a4BdwVJEQWvPrapDLr74DEMdGCG?=
 =?us-ascii?Q?qjgLvXjrRekRcIUEPnRGVfAdNYWK9ho7LwW4PuSu7o6GijKVhq1PMypz7I4+?=
 =?us-ascii?Q?Lkx8/SgoPj1DLgfK35CH6MSESMknj9wjuUJa2mtU5SXz8v4GiHuBNsx06kNK?=
 =?us-ascii?Q?DpoRdAnDZnHdDdkcegv+5EMPbPAzOSeiGQfYGvvyEPBmf1yQ537swjaHldeW?=
 =?us-ascii?Q?H2Oyw3s5Sb12ee16S7ioz6qtDi79z+7r5Qa1ujV6Jc/WyrQK1khOjjLmXZ33?=
 =?us-ascii?Q?8SA/LRq1MHaCGASNuHNLuUREvm/fN57rGwfZwiR5gMH3DZ5JtJpLKIrrJbCO?=
 =?us-ascii?Q?ZIgufPevMp0Ur994f7uDy9XeccU+XRUfA+I4LP1pI4Tb+9slldc+syjD4gbM?=
 =?us-ascii?Q?xJo5DzuZAbRiAFgmyywUJU210vebwukkknj4hbhz1yzI4UwCpqv7QZShyIEj?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jPSbw1D8YguHE4XzjeEOVrTRn94FtL8j8MdXzOqQySmuulFdlQ5FwB/4CxfEzxv/5A28F9mkf8x6W7QJn98cFIVPL/hI+5KnRd5fZTlj9hcrtihd/vjg4itHhq0RuCpd75pgQ6Dv4LE4bHbGww2LmA557SyJZ7xB0e8LAyfd0M8xMeKb4yNh+3F2kMj/xP0Nz2uYwjRCcXVymYuNwWSLVsE3p1yvVt1kyzwxtphZ/ysaNhoc7AqxL4Wcnz3eBQ+T4xeXl4pobEM8iH5bjvIxy7f9ULqA4TjDYpa2TMZVfGKV8fzCIJuaTWseycn94uOjJzZSOWSKDUPQ4D4XbDePOGZKb4HuO6HzgU2RHYDcYQtENH4r0S1fkQdBaT79RtCmcURn+c4QPwip35v3GdcnauG7uejB9r8fcEgvVLhmS+IxXO9b+a/KV/o1lpxnGJEmKI+XFZA4F3KkdKNTBAU5zteLaTTY1GPH56gqCNlKLtoEu4Qm+7Ac+veSU3iSB6Y8F8Si9s8WxAH9dIWyQHoLkZAJM1qHPSfYOCNXAnje/fX6Epb0c5L7hgNx4ezH7AmDPIgInz+EKpoKbGxrsUzWcHRs03XjZSx2oAz25YDCD6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffbeac0-96c9-4143-7633-08ddea22626e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:12:35.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWJ+7+R2rhW120vhHrHCbAWB5MGrBLvNlqBNz7oYE7aaEAyqiweE4XNaacuQWHsM8AdEYAm/FD2OaBIQ6fwHM2aQf3xJjjyk0PsM2LfC3r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020130
X-Proofpoint-ORIG-GUID: fYBfoe5B7rqx1OF9135r_mZu4OtMpXta
X-Authority-Analysis: v=2.4 cv=YKifyQGx c=1 sm=1 tr=0 ts=68b6ed47 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=V2sgnzSHAAAA:8 a=yPCof4ZbAAAA:8
 a=sr5FX54ME9O1nQFv3E0A:9 a=CjuIK1q_8ugA:10 a=Z31ocT7rh6aUJxSkT1EX:22 cc=ntf
 awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX12vkY5o0hOn6
 6WsDZN+/fOrcr9aLRnRfFDnTvrzXU7jxlTh7KAKkCht8R5pf8CEkoA6QoI8zPn2QPgtixlCKqHB
 3x84asAH1ME5Qythap7hPwbh/VPUofjxbajy4PZz3JImlaFJtqHP/Cij+APOodqWxSkJKqROUvo
 SoLoPDhy7rXM3+P8EyIuFDgvVBOtXR68U79s3lk5MtW8YZW6aeFUJgjtYt1Uqdmc6oFlsXSDSIz
 cCGSYW7f7lVv8Ixo2oY8eHlkkS4TwlJxRhApTdVlUI/OGMa8OwB2snm2GAZCuXGPV6D9gmuT1kI
 4ZQProB0656EqoUwumrA6X0B4xWlSDm+cTagGiMtm+Rme1KS27Oz1RzZPb/fIga0zZudFTE5CbT
 dZ5GNNSNW526BRO4laJqLFJ3NySzcQ==
X-Proofpoint-GUID: fYBfoe5B7rqx1OF9135r_mZu4OtMpXta
X-Stat-Signature: 3gg1cs1ntf5rzcb61t43j3bcyuj6i6c4
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DE9B40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756818776-115566
X-HE-Meta: U2FsdGVkX1/pZ94c+94IkH0X3K80+hzYW0IbyXXTdV9T2mYKuArPemZjUsMCoBSktQV3WPqWK0FZpwuW/u8d8U+Ub3eLWc4gnVGk5v52lpcArE7S6Y3u9oR8h1uEOvBUpJyYOGJGO0QE8dmYmRFGvNe6Qo0c3smeNJfhamFWAiclehyT3VmZjHpr88r5uX0XilDM96HppFec1rROm8Cd0ezltMEBqcjuETR0/ME9cD/jtZTT+xefA/TrEUFgGmEhw7Rt0qkKJg3KvIwp9KT14CLpFlZDQTIr9N0p+tdYM1yTk7Tb8c+akpvkrB2bZcRsTR8R/O9irMn/+paeBYPz8pWYOviamzZNM5R7hUideFv3Gc7jh/3UWgCemt9bJtEuDwXEfzwwKHpDmCFSX73awZ7kuneGdxq8V0w3AJD8zbekFMgDGsz9B8CdkLeePi7lgXo6qJApGo8NcZLqgCXsovm9DUwhCOSe6JqkJ4gBonhlYSOFJNJuB+05P6JXcGeNBqmb0HVJWUlCi9v3xvkfQ0SIu15u2q+D+nZbRjkxhXEFuz0KIdSF831vWnB0/pQTL7S0UL1qiFMZ5Eb7Lu1R36EXxkTosZ7o4gZqbJbtjfPsEgrUHfwq3j/u+0DrTM768Nyz0nwWhzTYbItLQt56prWf8vOS91R3mV0M/qThgNy9rMaOdb8u9lYN3f6YWcknm9tw4hvp5sxumkqvGoYoGXvIoC1uVyeMDc44J4spsxIBEaqZ2e2W6243vBdJpEqy/XK4dmYAiL+chNz9lJz1rvwXJToBdhqhIarIru3QGKB6MWGs2Nd5r5WcJg7C6Jj3WsbQ6qAz/Tx4sqfY4TtGwW61O51CaovFmOZH23jarQXAGFFaoceosCAwYLkI/fkz2ZFiEuoqCBEy4w60n/YoKuYexA90agRF8Bed30DRZyPw3PBdp/fnoEpJxSI4fRilhx93wiZ91X00nNhjFiM
 s5PGWEFK
 I9EGYBfIepYA9UsBI4eR2Nc19y+RkJf6efrk9H2MhKn7i+LIpdUCOkPsyU5DemZ5Q/EORwCpM/+/sCVNeIpCDd8w2lS4S4ijUJIWQXlFdY7FoFqmnVCEH6SkaBDZuvJXd52eB+lFzteMbfkIDJRHClRmI5JVHZmqkD9dQ76IckTaSo8xKh4mAMoOR75TngSzRCyK7FvPvFM4JmhhZAKikvxZySds5RbU3EyiaIdGszZnfR7iRQSCCE+DCrSyOZ8lCJ7BHAw2mAftNUveUkmB5joIQoJ97q5PATsPueJIpbWvn6pZDLy4MPQcK0hFcf22GBo5QyZ6ypcclBz8tekKSgdfExQh0uM1mvnlApsi7dLnsPb7NQs10gmUMzLa4zpaT8wbEz3VmNRAmXm7imK32oIOvJq6NnQZytOc2OXL98xB+KVkDa3d8/UI+wReuVEjwH728QoqXWHPYBNGHqJmPrIFOwt8Fp/fSzYT6f9MmyIgXUVzeUOsLPICeKiCxNQH6EK9rHw9AkZvrpfxZKwqAaO1o5ALkQk9ff16YxVy+TK1kF+SQ93hQX7hY/12FwNYcW8JJx4TAN/FOAZe7d7UsBulCWHWxcKT6ps1iX9cmqhzpB5ElPeeceNCkUDOzGJj+JUCb9HpdYcfmdQKi/HFroDQprLTWA++s3pzOX4eQTUWQz8XAbjb/OEKiJB+S80j55EjIAQ6Wyqr4AQ8tIWcHWXaKAocN/fHb7cefQeTp2pOm4JXz2fy9fNzmntgV9YeHbIs8/rNk7VaRQ7WZg1hXCDzEKV0w4RsaYXIno9W0VxqKAgviHLQf8p2RyaDfXNZrgzPdciV1HBOfJNbrXHoADd6lJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 09:49:21AM -0300, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
>
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Thanks!

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> v2:
> - fix build when CONFIG_ZSMALLOC is not enabled
> ---
>  mm/show_mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1f68d824b03eaea8 100644
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
> @@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +#if IS_ENABLED(CONFIG_ZSMALLOC)
> +			K(zone_page_state(zone, NR_ZSPAGES)),
> +#else
> +			0UL,
> +#endif
>  			K(zone->present_pages),
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),
>
> ---
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> change-id: 20250902-show_mem_zspages-d090ea0bd1d4
>
> Best regards,
> --
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>


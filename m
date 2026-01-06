Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E045CDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17B36B008A; Tue,  6 Jan 2026 08:39:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5A16B0093; Tue,  6 Jan 2026 08:39:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F8D6B0096; Tue,  6 Jan 2026 08:39:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3FA56B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:39:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 711E8C1CD5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:39:35 +0000 (UTC)
X-FDA: 84301646310.17.D56D19A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC12F40015
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:39:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VN+a85/F";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYNjOz0H;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767706772; a=rsa-sha256;
	cv=pass;
	b=jbXqPZEK+wSpv+P9TH4ALNEy9YGD+KXlnM4z3PZwV8uEhu/upXjk6G6jnXJYWRbhkeNJ2r
	lV24Y8siYpeB3XRg+OivhozCGEAKedj4KdnTPkW7zl2G4vpo+1MXk3VzlO2C03YmfyfpP5
	laqOL0mi/533gXg/2XSFiG1n0rG/e2Q=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VN+a85/F";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYNjOz0H;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767706772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qk9S1WIvoUC7cXZmd3XMgZ93150wa1cy0kJAHV3l8tM=;
	b=W5xOdobKC9UtyOJuCxsAgPHVb+/8d/Q0WHy8biyhRjw63KLhuJUYbsEy/4YaLIS3KPzRsa
	rpsgBCyjb67Yxl1Hph5PU04MHVHV2r54Qg4mN8lk1SicH4ZC1BsW+lDoUKTD3dc0KKM/9g
	Y+Ury7yQHMufKodbiIQuqmdgHmV6+V8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606Bnhxl3714513;
	Tue, 6 Jan 2026 13:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qk9S1WIvoUC7cXZmd3
	XMgZ93150wa1cy0kJAHV3l8tM=; b=VN+a85/FWMmirJ+QhzZqp29vKUtGu7wusZ
	pSEVuQUAbfNCm/Qw6ysMr3cVvoUBj+QCy6P4G8hI9hwOfgjqJ8uNqvF6pgboGxmQ
	1/NoC1Pf7l6ara+m4HRlp9AwDEgtqg/fXMMcodf2KglLZ1FqRQU8Rk3llS4hjgQu
	/6GvqjcnTINuQKrQBAx3abM/los6ya3NC0aonAZ/U6JTmk0XNZKOjp/R9vkUzmsc
	IHHWQ8RTe6zOERvuHnC6eOoRfNyuQpAbIySpRSque+QKIP38Vh37u/FXVOmxDugd
	+q+u82y1zK/uKDLoeuGv77zcu2NTeWFtjP51uzh1lhOgyPW9kaFA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1v0g3g6-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:39:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606D6O86027379;
	Tue, 6 Jan 2026 13:14:11 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8arhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:14:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lNkEbdnDx5qxCDPXZHljTMFxMEBBZEL8LEhL4Dm+VaxzZSwalfzKbaaDO1qnaKJqMDJFJddjWUOQ112jRz1uf1FCLmtnrZfH4DzQs7B7bZNO5cglS0uveXhK4II3bySCYuP/Yxmi7iHsyuyK0GmhnOD90ClLRpmTFe3zqR9vpUtvXGXf7FH/RWmfYWt879WeEbEBT2WHDu36wHmyEtEH4DMnJ12zwStM2J9aXP+qS1cTPjsdhTXCfdBQydZadtNnDVZAudhS1iu+RPZaBItLLoEgBm8nHEIrn+p+McVMimeizRyTeHZdgPXmr9KKz4Gsch7c4wk8Sd0G/4Q91s48sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qk9S1WIvoUC7cXZmd3XMgZ93150wa1cy0kJAHV3l8tM=;
 b=XA35rmkzcUpTdS/wAXmIVswAQN/NDbnB+0o3saHHR3JTyhoXmvBWynaRzHfAjQlSmSkwxCW85E7f8fWAJDpOk4BcpHxfbCELoE2q1XrsGP0L9FSfDwDTi9w9W42J+azuL2j76ti+Yf4PsQ8URrFlcYDtr18E4dMQZMlDkp/ey55XdR+oi3MxFk6r64x+kJlwdAmu1UvPgxjZK4YbyaJuwJOAz91DFtVb/vHe/xwx7fb1EIRUXPhbCgyKuy9JbCL+RXHo9AugW5DERRKtRmsvFHhHz9n/WoHBi48zeKrZvltFPle8z+1O9B4cnNJVsP3uy1eoQe3ma4AD1Xq9tZW0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qk9S1WIvoUC7cXZmd3XMgZ93150wa1cy0kJAHV3l8tM=;
 b=CYNjOz0HwgtXWLD7OiGVe8NjSxTn8jcppqHuDjdfHbF2OVkKySdAjh5nCivn9H5MdBwcBIMsCZ6/BDRXzLiGLfYnVbKoMZSuTFqlibozbld3yebA0auK0LqlllG+ER5kEr04Jmcr62varn+ECrQxi0Oo3yHFdbNvk3MPQIco4q4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 13:14:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:14:08 +0000
Date: Tue, 6 Jan 2026 13:14:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone,
 unlink
Message-ID: <945a812f-07e1-4d43-ab23-c1dc330a0a1e@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
 <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
X-ClientProxiedBy: LO4P123CA0209.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 42805e03-a341-4d29-784e-08de4d257976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o71bQ576j6S/YREknchSlL233MSnIE57aYWMBeHR2LKJ/u2fXmklEpuXn2zf?=
 =?us-ascii?Q?7Rr4iGJCJLAyj/7Ak/vCh1NO30XXhIXfNGp6B8G9LkMeGUaccIslUrNhLK01?=
 =?us-ascii?Q?ga3ZqVbjbJrRshi5924TtLH9bK2hGTjyJ9Vj4g/2CdrpswnikOjjM8iKco2u?=
 =?us-ascii?Q?OcAHN/hSTIE6/podqD7P3IBgQFRW+FGB+BbRejNPLzPaOxDR17C3l6+UIug8?=
 =?us-ascii?Q?iwN5SXg96zRajo49us8+XffeUVDP7kMySdFZ/+Y1vJXfyB8UJiIELXCaH6IA?=
 =?us-ascii?Q?udA0/p70kj7I3l5rh6qvKrCx+6iLOIk+YdJ417aWJQ4F/MkEhl8H4hvn8Fzv?=
 =?us-ascii?Q?Y2NmDyHqRuZmPxfMePOW/oLSQPMFSgeYSyI9vHzn/4YwOhcEMWae+9Hr4eAU?=
 =?us-ascii?Q?NYdq5tVXkcWmtpIDgdzP7XSr65VIVy+8Bj9Msg/ov2bTPhhbCABtaFIqkwdv?=
 =?us-ascii?Q?nIkNk8ElS6NwID81LAc1wjOccHfDXDC1aFPRmFCvB9MNahik8T7KQWnz5CGR?=
 =?us-ascii?Q?QHOL0uaT+b5AfBmVMI3pHdUcpEGsAj0golVLJaGzExWbUanRxK0BcgaZzwbM?=
 =?us-ascii?Q?E6HnpEcDERggqol9uPaiEpAshcPx1BP8URH4qTVtlVFdCclEsApl312qvebW?=
 =?us-ascii?Q?WDRd6sf/sTsO4BOMJCHQF7iOlJKeR8R/d4wxFHaWXgVwcojBBZk1tSwqZUQl?=
 =?us-ascii?Q?XoKTPMhMlX82k3F/xDEOFptJ7MKA/xCCP7jwbzW0Ds08CtfBcsJm2n0d0Gc1?=
 =?us-ascii?Q?6Fui/AaGjjp9BOVuQ6HKQEsgU+7qfNjTkw9xMPDTd5O5AaZEwFUb6hRczxZX?=
 =?us-ascii?Q?P2U6xLkDT5OjLk/P0+ZCPum9blQJQolUiLHEqOdCGQjJHqL7EwV2aemQCD7N?=
 =?us-ascii?Q?il/YzkXt/2WY8sHt3XW0tjmPgZfpmKUzHkQFwb1srkHfUpltaeZqd0pEbK8Q?=
 =?us-ascii?Q?hPZ94GLVDGXAcSXwJk+9hzk0pgh8KLR9GvoWQGIuDZACJrEa3vUgsZB+om8D?=
 =?us-ascii?Q?Fs5j3Lfip8m1hHHZhEkuJtRPpNOeYnGwjRIW+YLx9OYZj5zaoRkwXuahpS6W?=
 =?us-ascii?Q?D3D/JvN1ffV8XMP0SlHHT2qwCgGmGuoLsd7i8ZxSin1kfq47i+SQ4TEhAT+x?=
 =?us-ascii?Q?0Nl3ZdkNrs/jOkyEc/COyrAW2xgHWU/YK1da+CFkaf5bgL/MIzUucjAP0v6k?=
 =?us-ascii?Q?7CUnUZlKC/z/pbzQNotZsv4pbMYDX2l5w+gKlQ2T7SRncSIPf7itWRXSLbq/?=
 =?us-ascii?Q?tiUGX03nQbxTPjLGuWZ2YkrczPuY6dqZQmwFDXaL9K+DrJfiUTLXwxuzrONS?=
 =?us-ascii?Q?xMwnnsjvzdj+CaypVChqYADBG4jPk0KcMTSUgprRt6I3N35gMFEGzW/gDKzt?=
 =?us-ascii?Q?7ySkd9keVdpGodE5KhcXzNEbq0oyjrq2dakZecsPo9X87TGRraEX14B7bSvj?=
 =?us-ascii?Q?jVcBMM/PxDtyDSqICMH76dcIKzHN+V5R5/RbODaEWdX9eJnqmBxlTHNpH9ym?=
 =?us-ascii?Q?wf3M3mKVD+0kSMw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fgq2gE59L+avDqdIR6T+ugirumSq+2qOBXTGEq18F4kFJkTu1qXzph0st67H?=
 =?us-ascii?Q?mAxKjUIFq9CQysBqYped5NDgshvnsTPToID5e95wChOBhCZg6HTrjfBJnzwt?=
 =?us-ascii?Q?t/ShDIO/kml5svVmLiu0rufSoUmBc5bYmRrM6z1ltzM/FC+/REtAXFkuxZgs?=
 =?us-ascii?Q?jNRUBLnlWvxehEfe0Cjpjpl1l6pUKoGrqvJR/Dpge3ZW9qa+zw/3R0aFhPjH?=
 =?us-ascii?Q?7HlE+RrKrDyjhYdxVnJWBOLyD8x1hlwyPTkBPpFkp1gR0k3+Oku1TiJuT9sH?=
 =?us-ascii?Q?hCC5RoVdrDvpzgRcCrSD1bBhe0wZIyaSEdNKdlTJTZ++roJgXzW0sMQHUHrU?=
 =?us-ascii?Q?xDEAYMA6vEfRdTX7ZcST4qKMEyuE/lQErvwVYe+eaTokNeRlk1FgWCz2yccR?=
 =?us-ascii?Q?Q/QneFsS+H+HBunWi+eMUpgiveufdg85qCzr2/LnK1MUncBaqL1tJ2nnFMRy?=
 =?us-ascii?Q?txYh3lUVYu6ejxkb4F1uKUR7p4eHRz+vMLrGxd2/4O0m6xDLOY55LboFqg1S?=
 =?us-ascii?Q?BTShWHhjNa4pew2r0qHMaRmWvJacyRwM0xGM0NheCL8ssh68HmkXHEXfwSC1?=
 =?us-ascii?Q?xAZ9bxEOzwSyFG4cTqLGsT5r5yEyAb5H9B/7+66v2sWeba3royb2kaK5UZOo?=
 =?us-ascii?Q?5vHJ+9bHs4Pogsmeu5t/lojEAxU0IdQ3g71E445ImFss32PcBJm2Lwv72QAY?=
 =?us-ascii?Q?Q8TrmzcmmSREaGefoGCoGF9YRH78UCc0PmmKLSnbREVY2i0sycLvgiAd6+Zj?=
 =?us-ascii?Q?GNP5f6mCb8PTbIbQ1W1GIyMRx8QSxkqr+CQ3bZnZZHewFeiqQSawrSvKf3Yr?=
 =?us-ascii?Q?f0yP/WQOHTJHnq8vUqsNQDvWZTSwOeCN+qh80wga+6A01xADFvKDvQn69zSD?=
 =?us-ascii?Q?yfX3XtEmo9cXZJkIBSOs7bV0p1HGVvYm8kJ7joQPdOvRwqHwUjPmFDP+L4Ri?=
 =?us-ascii?Q?Hvd4T+7YaNmsuQDVI7zhOau5XYbwDvVQd2Wl9mLvYgTVViQWZ+rPHU+IFDda?=
 =?us-ascii?Q?UNBGGeN+TlC1Z1VcPm83T++1BI7wTewmGcT3j68AYP5PD15EnqtRjOUtpndX?=
 =?us-ascii?Q?zpIvxIAL5XbdOS+bDY0msRkYZD0hnVWvJz22DrvBdzKrOLYmb3vh1vvliAxR?=
 =?us-ascii?Q?0p8DTQMl3sqR/yhNL1y/4j947M3kmRVb2S+DD4XjeT89ZL1gLSvgJPoQgtgo?=
 =?us-ascii?Q?JzTex/14/hBSeAwc5LuDOHTz/SHAnufm/dnngbvzYMAgpAkSv2mqU5/kat7u?=
 =?us-ascii?Q?5aSNU7MOnG/QE//qAUMmzr1dSTkTX3NRl5yfgB3YkTuuYtP6qoIDcx0xsbNw?=
 =?us-ascii?Q?q6gs2nxedZGCb+uhE6FpOsaAoafzDSzwAe4gH4aAIUbAwWluFSh+mAFQ6O2p?=
 =?us-ascii?Q?4B/fgpL2xCc2K8li6LGct8q2Jru4w8oJpmg1r30RNuAw3htQti9qhb6sxxyG?=
 =?us-ascii?Q?bXJptbKSpwOjkWLxrzjvNrmq1ZWR0zM5tzoZ8M3wu0Z0zDZtOCLt+4O6aTxK?=
 =?us-ascii?Q?MLS1uMmILwWSOFQ5XGNpeUjbtFTFemOXr9VVEZunrnJKjBK/Um5LWFJ6Ul3r?=
 =?us-ascii?Q?SHa7uZXxG8XDVcikWvRfzEc5HkYaGOF63xkVNd+es4Di2RYTjGVHHyd6zSPE?=
 =?us-ascii?Q?3MKaaZlvgeLA0xOqOtqmDk8MELSfb00bRGvAbAbmU7Suy1hF+7XPaDDn0bao?=
 =?us-ascii?Q?F7mFE/0vMBBf61kTOZbsic3PlX8jGu1A65AatnE85sOnE/yH4Vt7p1X2wiX+?=
 =?us-ascii?Q?+a3U66U45xfTWam0vtIxWdyRLf4wcUk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5GejNoVsMNYbyiitrwEzluCrsKJbVl4D+Xlwn2Bw7fuR/ZPMKjzLtHsLIX7cjqCtkPXpz2fmeUb+jycV7ez5AEJi6i/GOQj/YfEDYNSwtIIOpp/TIaDbBL9dc0PFyoMF7UA1CmTNdeDVl+WUoiKSJF9aXUCsuoPeWwbpTgCAlt88iKj72l8CtlwgZUYW3UfeDCgsTqmy27zEBufFlim+0JbCBjq9YuIBbBiEFqAUbR+JBQ4IWBoke63akG+63odwVZHiAvM0HSFWd5vXkxW9mAEr7BtQDqtONrm8XbhuB1AmUjLpt/255qjGdL8e6mCXTxeR4/zZDEDRh3UEqD5i3iJR83ku2qykzeRRVQ7wBi0rTuL5/6A8BrysGz54mfdaWmfQQI/dD4+F9IRGpKIsHP5AtVZPFpsmienXZ4/LI9iNsCcxRI3XnsLKU6+GPTVol5YOkooFBdGcCBh5NCDuISWhfWE7Qirwh6Dlv2qG23bCvHBzxx90MMhJ3oB5PwqJ/jlE2Gi50LQuSG3jGi4deYGR4qnnGbjLDCaIoPGHI7g5VzkR3Iv2EjqBrUyK9qazHdNkgmLS+xmLIaD9W7AfE9XdGbKEprZYzZIQBVqptgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42805e03-a341-4d29-784e-08de4d257976
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:14:08.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWRtwzBMREGoHXPwgDta9Tui4ASDCZyiMezP45zpj/RKynN5BzhgW7FzSghaySFjIy7mV4wAoGj4jluM4fyc/OhS6cXr6KO05hdYOp2OQHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060115
X-Proofpoint-ORIG-GUID: LMyNd6C7HOY2zsSHXW_M4bbohhzJg8f2
X-Authority-Analysis: v=2.4 cv=JPA2csKb c=1 sm=1 tr=0 ts=695d108f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Dx13pgjXxrB5t5M1BKAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LMyNd6C7HOY2zsSHXW_M4bbohhzJg8f2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOCBTYWx0ZWRfXwc8GuBkYCYlN
 QsRObRbRd6oZLxo+4yOcKBWL8U7TBLABKNdvK+F/e3ziJR16KiUtLCbbE24IzCPF/LBllycdz92
 rnor30yN1JKzmEXv4+J3JNP+S6OAI4OIFX2WpaDKF+XM0fgrx1X+BPVY98GP5pCo7amaTQLrllS
 J5Z/KeavW87GSbjEqZbOBkVuOHs0FPa9tiIe+fUr5lQbctYW7fedhMLnC2wiXfVR+0+O2t7gU+u
 0FP/jaYCTpqOn19UMBdp76JDG5X7cFq19jnFukXyg9Z86d6UkorlDpkzQ2Lsdp5JQAVY7icD6zX
 wizQM/XosMRS2UaApvdy8RSrjd8AnAuklC6MRbjb5zFfy+vAiQKpUHtEqRmT+9pvdxt6IQZzr9l
 XKGdQbkNDyCXI7au83kfpqTnJ+bskKibIUU1ztXSxx3V79Ng+MTQ3d81Fc43BUKg6UYZpi3Brsh
 hnj1yVjlrp29icnrrsw==
X-Rspamd-Queue-Id: EC12F40015
X-Stat-Signature: piretpxmzk93rwgjy4d74rop7gsieqwz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767706771-120560
X-HE-Meta: U2FsdGVkX1+JPAU/l3xHGwpAIzDXUt9gCdhUdEK3/MC4rG6+j0CN8rq/Vdt9lyhGO96NkQ6qymcmk9heN5QsFvCMZDjfBTyOxDtTJWho1aQUDNCf3pZry6AUcucn49gYvlgsxo1SkIDe2zdxBloS6LFAVXtmvJ1eVOjyMwoaxb8wgFxPn0AwbQ4vZ7HQ6LdrfgowypihflYA1hv8bcH8lRU2nycyI2kXDO4odxUoW6JL/uYdjFufIuRLwm/RvlcHm97zZq61x70+Gl3wlO0shmzMrymNwJ/mTRomVH8HAQXXbQwZTnim6SRztibeqpT4Eafrj/MCs8L3Epv20kDgzWQxi/8QnZ6D+m9NfyAcziN7JVFqUTuZpcZ2k1sv8KsnPYz+QDtshnHvJnZrNq27av+wYw9gANCncfh/rQ24EDvFgg285JRpeCf5+RJA1P/sa2L0LV9MhWDzCBy2RmoKGnpTKMQmPitY08FMxYNs9GRNRDpn1QQfSfmwN2Pdu6PkUmpI8M1I3Nmqmz4eUhrfrcpCRfeL6RmLdBftlrKhPsc4OyNEBd+muK2KwuffYtOCXrrLxaYCbwyH5ve5kA7FmdAOpvxrgmXoSDzfywEQcXZmvIoHxZ/oZQsLkf2gSzfz+/jOyI18UdLolJuUWvzJl1lJ2kwG1zjApVqejYQuSPZLtFPyUgVVGJeCNm43u6VVE24J9skC7oumgF7LGiGFb6bfXvYm1+GabKQbTjQx0MAxHjtuxToyZchg5OeLuVspixwuY++40JuTGyQspFI+XPPJ68Ul15a5mhFj74L0ooWH0/k5AYPiX061dZORMvadsr18IgWL6/qEenc2bG+zAE674ve7GrYezGfOg2WQd3pehkccc2NM/xUO++P7tphuV7ABt8fSKscNjLrGfPTvTiNG5qFpDdKc+SBrKrHQgqXqXJGZHszFA4ftjq9opc1kjVuJYlyXwvyBWDjrYab
 YBjzSMOx
 lOFRSNAUFnQSSzic54b8Etwg+RJyOy7WvgU6F67/ctU7droztEmx7qxtYznjd3xipMtg3+X1tBtc50kBmoeIVleMJpfjVIm2MS8KYTE0FgU+d0QOLdHjJKsIzLjtPmFg1Z25nSBnYZA7P/ad08xhcQP2faA+wric2D7LVwuCdl91DOS2Uc0S2u46CAR6aaxSxq+9jASuwQH4aJQhLiItuNFWfYXC+yCU5Z6g9J+hlCzV6+Qp6yKm13FPX5QILn5EWc14jwsR5lDi4qfatTeMUMPe6vKFZDzFSGf6ZCWcfyJBWYnNqCY7R2NcxCPVEZIokpMikjEvsuj8tGqGoH4pKJJwh0DAZwiz3ItxlIBbfuZAoiKHt18hgYq0i6roxyyetoYblcFeSjMqTrv/ADpn9UP5ardKl2m93Ji0QieWSWUW31XXp/vNzGhiHFH/TJ4sSOkwO9Sb8E8EgzQfmQ7R5x4gfFSBSmpnrTC1x/IEOwHARvDjLPdKpmuUAN8NulYvLHMCqDghJDwHfrrdGBHaMewXeF3APKEnyWD72Bj3dhjAbVA0F9oNkZbig9DgVWKSO5DFkEkCZibTSLowsf2YlZUV51si7JubhzIlJPaPcXymzbrkU6O3CddeyMPCPLWki1WTe3lFJa76h/lDf9TyV9KM+Pig+aPimBuUt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 01:28:03PM -0500, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
> > VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
> > nothing. Simply exit early in these cases.
> >
> > In the unlink_anon_vmas() case we can also remove a conditional that checks
> > whether vma->anon_vma is set.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/rmap.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 0e34c0a69fbc..9332d1cbc643 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  	struct anon_vma_chain *avc, *pavc;
> >  	struct anon_vma *root = NULL;
> >
> > +	if (!src->anon_vma)
> > +		return 0;
> > +
> >  	check_anon_vma_clone(dst, src);
> >
> >  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > @@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >  	mmap_assert_locked(vma->vm_mm);
> >
> >  	/* Unfaulted is a no-op. */
> > -	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > +	if (!vma->anon_vma)
> > +		return;
>
> I guess it doesn't matter because you just added the !list_empty()
> check, but did you mean to drop that part?

I did mean to. Really this doesn't happen in reality, the assert was more of a
place holder I suppose.

I don't think we should be falling over ourselves to assert impossible things,
really the debug-only asserts are intended to essentially document what's going
on.

Anyway it's moot, as I've had to drop both the assert and the condition here
sadly, because of the fact we (of course) use unlink_anon_vmas() to clean up
incompletely set up anon_vma's on a destination VMA.

When has doing things on incompletely setup up VMAs ever gone wrong :)

As ever with anon_vma, there are always deeper depths of horror to find.

>
> >
> >  	/*
> >  	 * Unlink each anon_vma chained to the VMA.  This list is ordered
> > @@ -465,15 +469,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >  		list_del(&avc->same_vma);
> >  		anon_vma_chain_free(avc);
> >  	}
> > -	if (vma->anon_vma) {
> > -		vma->anon_vma->num_active_vmas--;
> >
> > -		/*
> > -		 * vma would still be needed after unlink, and anon_vma will be prepared
> > -		 * when handle fault.
> > -		 */
> > -		vma->anon_vma = NULL;
> > -	}
> > +	vma->anon_vma->num_active_vmas--;
> > +	/*
> > +	 * vma would still be needed after unlink, and anon_vma will be prepared
> > +	 * when handle fault.
> > +	 */
> > +	vma->anon_vma = NULL;
> >  	unlock_anon_vma_root(root);
> >
> >  	/*
> > --
> > 2.52.0
> >


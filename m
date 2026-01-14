Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A82ED3900B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7E66B0005; Wed, 14 Jan 2026 13:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5416B0089; Wed, 14 Jan 2026 13:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FCD6B008A; Wed, 14 Jan 2026 13:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE81A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:49:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E90D1605CD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:49:02 +0000 (UTC)
X-FDA: 84331456524.27.97AED1F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 389F1180002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:48:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jzvcahxY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iN3BuG9X;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768416539; a=rsa-sha256;
	cv=pass;
	b=W3fKA283UsgwUnS7ZoRVG/vTHoaIVmscUTD4FOnQZqHRb+rRE53kAbnrkfBtaVspFwnaWT
	x9NKnBLeMLo4YhjiLawxZ8uDJQP4TtMVjsGpHXcRaOD8IgdBHoEVKrAYVxw0e1a2enizQA
	VS03IMoIAes8Q3UfQl5kPj8sezy0boY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jzvcahxY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iN3BuG9X;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768416539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TZwo0bigzgUugVMDSyQFzG4Qsppe2UvEqenbhPPQKA=;
	b=k6igbP+Xczcwk26CJVeik8W7G9wlF12mn8OypeUUXzjcmbZB2ao7ZU0vTsSbpRLcqQ768L
	aEHzo78gUlMEZd10QjPbsP9ND1aaudpaP71UPCzKno7b9WFyku7rGEvNYaQWyvKFPdAY3G
	VqJRGAwgUckbD9qVFF1SMBsMOswEekE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EIFmWb2682611;
	Wed, 14 Jan 2026 18:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0TZwo0bigzgUugVMDS
	yQFzG4Qsppe2UvEqenbhPPQKA=; b=jzvcahxYUZDor65P+B41Kin3onvDy5M8CK
	8WW56T+fv6yVOvp1q5abONpk24KagH73+yNAvNt2TTepG9sERWs7Kd0U5oPDv2fR
	rjZIAa1ovqX+XKTo596DCApm+tp0dyLiMMxgPtuN6W83YtBXH3Sx+77XuvVwhZja
	c5j9qaewEQVj3m3u+Sbq1PmGCxDQPqYI8C6fE/R7LdkvELGd0BwSVMU0qMQzSwEZ
	GFyrZ5mwqSRsf34ttfVOOoHo2q0nUKiSrhUkN/MXVmLYEiNpEA5gXti1+rx+y3vr
	pzN03TBbr4VV+TlolBafSEH1I7idafRsp/Q3gFQ7i8fEjlUB/JVQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb5sn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:48:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EHAYFN029328;
	Wed, 14 Jan 2026 18:48:54 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010071.outbound.protection.outlook.com [52.101.85.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7m5w7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qtzr9zQAcI4LC0GU64r4BSn6g8fP423kYAgDGfTYKnjkHc+I7Lbxv12/jjLFsifFbaZ4JSPAI6nS3PlU3M2nrBLH3rjxg8yYZyoV5zOju1Bsz+Y32iIy4mu6/pPJrpXye3KDTot2/rergTA8aZi4xxMsuHX6XAt/0w2t6EuQFt+uWX1YApnQ8Exqo4F9msC9AgX9IRza0gvcmDIxmSKEGqxjoQzpPSjwpPn4SHJvthERmIeBnbCmU5O2VNmbFgG80DGG9qZB0z/ueJulPM43bxfk7OAR/iphvM25GWyaQeYK91KWo9Ro7JBevCbEdf8Hc+bniRlWVBF3s1FI7/97Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TZwo0bigzgUugVMDSyQFzG4Qsppe2UvEqenbhPPQKA=;
 b=Q4AMpeYIdvTZCo7jeMoaJWkZHTeEdvoStVRrijaeStYHCoKlrtNGW1iu1WxTrMCiU7WjcyP0z2NDXt+dHrvMs2aXgLh7MWily3d8cDZZ3PB6EgkUyMv4hjVBpP0NIIzHavqi8m8mJ2IjTnOiduzptXsZE+BRHK+ebCpCieUJfvStmFSdgrncauZEnJnguViq8sGuPDTuvWr0SqcwZ5w3xYCNbWmqb0IqFrSqDh7d8E7R4o3UXTaP9YJxzB837SbhquIwmt804fwen4Ng8iC4VT8Q7kjxOTX3DBn/EOlICD+V3Xia2HhCZRt7mR+K1rnQA6iCafAZuk7XiV4qXwtNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TZwo0bigzgUugVMDSyQFzG4Qsppe2UvEqenbhPPQKA=;
 b=iN3BuG9XZBKcgaLY1Hnymb4kUR2m49iY41KPscNHvqLpFWFkidzWft7k8aVwi15Bcb81G8E8ReXcboESpuhgYIvzXsggp+tVuSd8LrrWZ1/dCd7yuN88xaSCINBBWb/qPjUnag7BL//LlBZXDMalL+aL+JGwiNRvZv5inj0KkkQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB8214.namprd10.prod.outlook.com (2603:10b6:610:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 18:48:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 18:48:50 +0000
Date: Wed, 14 Jan 2026 18:48:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <3b56ecb1-377e-4b50-815a-19ebb850f108@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHoNdg4p__pmdsQepzxSpLe4j_7s17=Y5bicETacP4a+Q@mail.gmail.com>
 <3da4df0f-4205-4f69-bd3a-cebfce5b6f9c@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da4df0f-4205-4f69-bd3a-cebfce5b6f9c@lucifer.local>
X-ClientProxiedBy: LO4P123CA0325.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: fa45004c-70eb-4a7e-a3db-08de539d8eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sigs951oyiqE91+Icj/CF3X/X2d9/MpI7kHM6wtqeIEpoOwCQAC/zn7/L4MK?=
 =?us-ascii?Q?cEKV1mP7vswI3KslE42TXbWW6l6d6T+d7gnuQyieiL8u/r7rWkqGAmrQt1pi?=
 =?us-ascii?Q?Q+8IeWH05hgXS8MQDXroT+gToUtDzcdrRlpb3HTWg1P7pnQFbt56jTnaZBPv?=
 =?us-ascii?Q?5is1zhQeQ0DlEy4Sui6SuJDDRr8GC1AegopN0zqiO0Wa6dA57IcbMiOdnCcC?=
 =?us-ascii?Q?MFWkCDhdrvBVyZHSlgxndUjyVcjnh8mEX8YBZdmd1T9VVCTenmlQxMRP67Cm?=
 =?us-ascii?Q?zqmMIUTD5KiQhsijJaPfI2o0lwpJjUqXu51xMYAluvq1JsjXL2sODdFAtAC2?=
 =?us-ascii?Q?3KrRqz5B1z0L7fcT2U2omkyjxMayc5JqqN6tw9TBsNx/ngqROXuXYfPc+1i0?=
 =?us-ascii?Q?A/C7SUqRp3qVFS0Ou+GuT1KJOIcBL7Q92TVSdzxHvqGEXswA2hB3OxhVPUWe?=
 =?us-ascii?Q?YStdsFswEHATEBY1vcwAFN+469F2kry1l5y5Tyhng7m84/tkn8t0LEFfoERM?=
 =?us-ascii?Q?vFolpk/lZ2SOHQIYrITb4sHLkHngSrFViFKF49UiWm9eTM4uX+VswK5pE/HZ?=
 =?us-ascii?Q?VL7ITRdVqnz/g84efVzSpWwxY2Zq3p6Bi3bAmIKwsXJVkL/lDd7cFRzsaCDI?=
 =?us-ascii?Q?/xuIv/kW9l5+ujfxfAbw13oMk1yiUtZFB1uWLBKdSwdMf5rEr9gDL5q6apeK?=
 =?us-ascii?Q?xlHzsiVTwKXe9T9xxnpg7d0kHx55ay4OKqqVkynU377y99uEtTQktLhsuv96?=
 =?us-ascii?Q?CEGqPFBIa26P8bzF8+BAEige1TToivM61S9wK6UGropEnc66P8Wi3vwHvkhd?=
 =?us-ascii?Q?8RvpsjFhUg8BvH39gLmrltNqxawK/7wgEE5Ol8PlcdtdOvZlnP/N6b99VvN+?=
 =?us-ascii?Q?/DndVAeAKjtOLt94o13F+UJhP5WMgi6rvi3bCp9nIjVoido4UBG5T7EyFpdz?=
 =?us-ascii?Q?3v4squXRTdbXXjVokd0/uC/zu+FNR7a7rO66N2D4AnfKQYy4II7jkJMo7itr?=
 =?us-ascii?Q?bpljtVR07VW8r1NR+itoapci2bFRMe69nKepOb9C8cYZsCV/xJHkxqNHlROm?=
 =?us-ascii?Q?NAdF1+xvnyZqKKBHJ7EFgN4eWDTw1RuAyKeDY3KWkyusgKuNkr6tUf3hOf0M?=
 =?us-ascii?Q?2jMTvmQPx/CSpI8JS+FE23ZvneDabMk7tWrDIrW7UsU/to7Z/K5FElZ3WMfZ?=
 =?us-ascii?Q?jSFXyf9e7d7TWlG/upQ+q2orsncU7GDJTtR5GSzHtUWrBRK14y7afB4uYDlH?=
 =?us-ascii?Q?nDlCWqBO+bWnlmX4S1LDwnLHhkUma/DCSOrqrn9rFHpAUzjfII7WJbSlmcmU?=
 =?us-ascii?Q?EqsxJwCQbLRwYsgJHmAVanSPAYf8DG6FuB47O1F4ZWztievjz12kse+9Jjur?=
 =?us-ascii?Q?fBQj3+W+bZjvtBK8XlSRocf/+TscnHjbkd9Xc+m6gk5AL3io3OK3M07hPGzw?=
 =?us-ascii?Q?iQzLzutUnnBOlgunQr18U18Rlx1ncY6mk7mUC7xoXbuAfWjQV8j8Qnt5FZgW?=
 =?us-ascii?Q?50ZSPTbWNlocSC4zTdznAzmmUnJVTzRpyQlg1I/3w7ymh1asuFjAM2CP3+0m?=
 =?us-ascii?Q?dO02khHT7ZeYabs6msI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q9JAx6YDO334gAbA1UVy0HpqYf3FROyHAvWMa4OgNVd56YP5Hxd48ENRMgbf?=
 =?us-ascii?Q?yW36n2S+PSYPc2YSOuuR6YV2awQK9ikECy9YG5ylasmxvr8Vq0nHM+A1NWhk?=
 =?us-ascii?Q?o04/F8auCsCNsek4hYfI7sXVFmppyhdUhcVPpI3a4/I5RFwuaDrS3wjaOdZQ?=
 =?us-ascii?Q?Fxu3lOye1Mwjjn1XPmRV+IU5m4Ee4JVQTtxB3AT9L23uqiov13bbDmOAT3Oi?=
 =?us-ascii?Q?x1ZaXdWFIExeHslwl+ZUzx0T8mxfXcTBLcj/8v7ugS04s2TKwglZ8ITtmFB5?=
 =?us-ascii?Q?j0HPi2g3Ab8iHk7nf7cizRgACgvbPWicTtQ/FD4wANam7SiuinOb+tNAP0BY?=
 =?us-ascii?Q?mDgs8xXaf75gyVIAv0J4plONlI9mxqR32w2H64cuao487FkeoONfbOXIqNmz?=
 =?us-ascii?Q?G+8W4exShqfPSoPSO8uC7SArYowf2v0WII402eZm775SfytMdr3lRbUfUuOl?=
 =?us-ascii?Q?qxWZ0PoH/vs6tyW/fjM9PNZ4UHY81LQ02rzXAyxDtGiWtdXB+UlmfWEBrWJm?=
 =?us-ascii?Q?tqeMjHCTUej5qKvtEaHy5tyN0jWjFCAv0AjgMRgRaYRPuzLOV166BlUnKd38?=
 =?us-ascii?Q?E05CqSNI6yJnN5u78VPzjG+7rmWDzwFr4l0UOrTnxDD9+x3mORu09IMOP2A7?=
 =?us-ascii?Q?RJOSeEQHtJBiDiMIoaGXeSYqHxlAazWmIU7MDmLG5u7+q8lxlTpR0OA8lIK8?=
 =?us-ascii?Q?ElP/WVkzQWUotRMKK5TCv7DyRkudDGdBnRez7fFW0638CkkHDKvL+YOTSJF2?=
 =?us-ascii?Q?OYqE9AR/U2kudACGIcOl9SRMyHh+MHvOO4e9CaIwXC8WAOoGLgxt+xDlf2c6?=
 =?us-ascii?Q?Nbf7Hw3VSHCiAFO/GzQ1ay3lb9YoduFJQrfoFFq/ZrpQ4sc/QILQpm/EkNQS?=
 =?us-ascii?Q?OskTJZjGkmrjJtZbF7285M+MYcsqVMLfRZ0a86axVCqyLcCP92zpQySNC5P6?=
 =?us-ascii?Q?gGIFuVho/bOfmieStrgQs0qCloJij3mUL5bfv5IJRlkOAYWwIQEkvRhsJm1X?=
 =?us-ascii?Q?/Hm4+DV+2TGenlp6nqvl3DKMEZsPoQtNz6BGAfWCVGN0oeOwyLdSNW8K1/dd?=
 =?us-ascii?Q?fHDy5jmczdqXayDHRht4AupR+8+yGsw+dCQW2dKPjWd94ZK0PS8yKRg6G6Eg?=
 =?us-ascii?Q?bietzCxI5s13sVWYOtj1YqzQ5JVliVQlRcPax/GSjDxbXWasXFp3vw3f9LBd?=
 =?us-ascii?Q?6MYiE4+OkMKDkcNVnb7l6KqUHV/lCasY28UNmW0FaBpDJzXr7Wxn1cjRsfjd?=
 =?us-ascii?Q?cV+GXsLpL2Tgf4YXpSTJmFWutcj4VVgqGPC2td4njcEnoEyBtkfAC1ENJN5j?=
 =?us-ascii?Q?rEsg7NlCnXxhDLxgVwtXmyUpayvOW63wcuPydb/5WFr2ysneqptZ4KXagEvR?=
 =?us-ascii?Q?PDoJNmYpX8KcqZaaO6hYWhxvb2O2bFAqRZxiTP1/zMyJyXfN5Gp9YQntgaAd?=
 =?us-ascii?Q?0jFOBbp7a8wojwIo+Ig5sY7fKrBj8Xa41yUKayj6KjkyS9/ogDg752opUh0J?=
 =?us-ascii?Q?yqGqMmRe7DkYkXRrhBKFkJlUn5GiJUGtIA6EiHLA0wduESouFdJI/lpCp57y?=
 =?us-ascii?Q?ggxmVD5Fx9YGlybhzE+z3mfmwrtG11DAlaqAxw4D7MtXv841Z94xSrmCh3A2?=
 =?us-ascii?Q?nkRRH1EHDCM7Z5Fkoj2coxyliFPo93UZSRliEkNCprPy2sNhHiyAL1Glv1t+?=
 =?us-ascii?Q?ggXW5eQinniBg6mDr6jmB586mHF0UVyZPHzHQr5gFZ0SM6ThePSujMobdO/4?=
 =?us-ascii?Q?bU+UYdbExR2148UZvMEFNGNII3StBFA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PJtB9Aqnn5EJwGCu00GXAghgsXHmSoC813DiLPBpRtPV4LzyWJG2+2EVvyf/HJj1n/wl6OPMV/l1L+aaIiBJ39Idg8xnE/bM6zIFTkz0A16wex+vM0PleZrnj/EYGUeQH4M8CXC0jHu3Xrx8zxz2+eAQs+g6+XOhoeN8N3LpU32Lcl0p/7PbI0OGk8CBSlNtnIu9CFeW/DsLlQtam3LzbaIUr1qwn4Op/jcb4UNc9Yi2N5HH+f7SH/BNKDDy3MjdDlbEiyLi3aFMPcTXSgIpYalCr2+saTUDeA3azCWlmlXiCsZ9/AmnGjiosMSOMv+Q3YZGJ1lkbnjP1bh2NG+qPAr7OdHyC1tAKRakoZ1KKllWXx6xPSlTFru/SKg2Qux3QpQfcQYt4ltYdqZD9DpivAk1w9+IFWh5xiJwKjSSXehzWH2hUCr9Jq3Q8QxG+86jAH6FJz4UE2XDGHYxclmarYLo7npmtk9K/uOziewA9spySmjCt7j9zpQmO79uM6lj+Da+K87gtogzQVH31P5DGvww+D8eAFBIGPpW3AxEZmDH95uWgcupELYMWS+q9lHmlbz7UbEcwE2/sjGBdOUeXlDiZ1D2FlpaEYuoS7sHrK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa45004c-70eb-4a7e-a3db-08de539d8eea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 18:48:50.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mw+GWP083cU6nuKF5i6fxIHnC86xRnzNrJRHHpXe1xrUlWJvejWMHI/vUv3zMGi49IN1R2CZA5js0JvKrSY+PlfS6sCKejZ2qiykIIB+jms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB8214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140156
X-Proofpoint-GUID: aPqCNc1xRdwc6E6tza8ZRDtHi5R5lfTo
X-Proofpoint-ORIG-GUID: aPqCNc1xRdwc6E6tza8ZRDtHi5R5lfTo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE1NiBTYWx0ZWRfX1NaM2UUSV8TY
 1ORE3JEsT4wZtwR8U1/AN2DMpmGlNykY+HjBcOLHZwEwtyCp+SIYjUt8b7SHXcox8J6YX0ZSkIp
 bGm09ZGeMYTKosTcSskdIqk+iaf4p/jvin49cOue30H8BJol5jkHAoNjt+UqIUZYNkhfgl6sb/p
 v0vuVi9J16zPWKeZbh6nFeAWBgnjJzzJgQuRhWdZOgWZQr/4byZ4hEyfvHowkv0Msz0URlPNwzu
 ayfgAJRDvftoyimP/ANiG41ii7c62ocG0xx1h++tD1EUEwf6ecD60FHtT8BhDavoEqwHZmGIkdf
 ZyQf+rBtSOrpShT1Vh+/X6MHyXWCuKwrdqFbCw40Y8aCmbi3pH+u/W/2EPto6UYhaYKP5l2HPPd
 42LGWH1TT4VTOryiinqyWpbVqsGu0e6KGwM5ERwugC4oMx4uW2HQv+klNqOllpJDcOkmC+tJD01
 cMfTdVrd607+94ufb4dFLmBNDFHBNTzhel/VeBy4=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6967e516 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QCjxJC0j5dB7nSM_aowA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 389F1180002
X-Stat-Signature: dcsqcdzzky1cf4eig7yyfos3qmggb7af
X-Rspam-User: 
X-HE-Tag: 1768416539-647993
X-HE-Meta: U2FsdGVkX18zDUqw0rCdZmmmis+biOSMXp382zWgjJb2TH5jMz7t9KRXzFOabjJOH+ffclcNhwFHGURhWpu51crCqdOtVCW5Ts1T9GYSaXuKJ/Amn0vsdJ1XXE21MW1gvE7nsVldP+x+FU2BFMFePiYJIMlR4w+rBgJl1PcV+h9nXIu6JSFNeZlQqkod0OetqO/lPVIaYkkTagfscfwC16yHBZHlv3JMfEfqjcxxldnpDVK7Rd3PkdvgI/OLJCc5datIBl2NPrmIAvjWxwBlnSW1D4hfzcupwjVV5jizsYn+uvrIrxGyUYBZf2rsbFx9imJrQectRYceh1yPnSk7s9k2+DbltjTsWCY7Y6EK6PWXYrhrR+qm/xI1xRiggyN5ff536tBW7/cJkEgZVuTgiOhcGrBQOnQpQqX+y2w4bNMCbBmBXFr/LV3gdfMJ1SNR5E41+/2ovAlHl0oo+GzjUii/zwrWVS/QzKm3YLz9ZCLwBXWxC7CCpNfvnMtnV9C+OSae3g3tSsIpNAlNAQNTd1WQBgc/mDrk2k9EtWMiWG5FD8QBHkyQkpXMxbQ+h0CylDX+WReSZY18IXTQ15m7hDVnC7kqazx5ozVfeXzQBTMZuhnj9KAfcVNgsMQAgJHM2ZU5tLLuh32V9wCgH/4UOmC0o74wRjuf3+fvRWQMPKWEHStPKPzcMB5KM+AgOuO2lla/WppDmTtIVcX3nUcwgg2x/rACAjwldmYQ2UsWFxuYI0MI/Rx+m3fo3lBCjWD0hlQUokPDLaQJZGJGEocbSEJ5MYp4p5zyaC3HK1SGLv3rwRX+wFCGXnE/IcZBSVZa/OKrJKk2scrVEkxcYcJTnH0OzrR2JV+lPKVfpv1CseF6nHghf2lS0QolYcr3yY8GD7e1oE2OoyF1K/4CP3p26NYAt7v1YuBiQ7z46j3qrnbzKmq06LPqvvwacWcYwjDKvmrkz5QR491dZ8vAmVW
 Tx+MwNSV
 EeK+D7zmibATm/xn6SnzuFPVjkpwUBuhrS7FvRzD5qnJubpdg9cc4RRfRU1xp3r1l/GTGjrRdcYE0kt/3o3pRqLMVutE0832pkNMgXQMV0D7JHvVU7dFP7TlaidQoXySz/ZTbQE+mFKEQhT1GOD92VykFxX6+P3UDPM5eyoZI8mxvBJWMfht/tLal0HgMilUbcvI/oAFSo8PknVGgkZXgL3Ke+t4jvyKwKTwhPJnCerXXZ1e4EiQwSG+dDAzW7GAymAAosV8wIZ1ij4lnoqhcjCq4Cty9ljNPz+Ypiyf6iGHqY3ZosfhVpTYGtO9A9h2TCSqxv7o6NgAyPH0zT3DyF8QamGBv95v48Dt3tVDE4zkuzTelRRiMg6HTFRvNSZf6jn1SbYt68G2r08b63YdhTrh4Gs4p4sixc0LOFLAm9tBB7LeUUG+t8nS6+JhlujKQXnWaJElLULBzAqyzX/ElyMdCm4Sq2xCHDLiY0iQQvmnu0wO5lTPF+1Hvd/7tEn3RweM0mgbAFajY/rhYYHkrmIArX8CPXwuiakeNEP2KuMpXTAuoSgIynVIpiXEZNdcXr4S0lsCRwwS+cvLcGlgXwl8d0F25IFYgJiy96VRAwOEkQFLtiIguv6+OdcnluwqYY5/hOCN2Ajo34Aa/AaLdXDfsv3nKyavjNJTD3VRPsUPpoNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 06:33:39PM +0000, Lorenzo Stoakes wrote:
> On Wed, Jan 14, 2026 at 08:14:23AM -0800, Suren Baghdasaryan wrote:
> > > + *
> > > + * So this function needs only traverse the anon_vma_chain and free each
> > > + * allocated anon_vma_chain.
> > > + */
> > > +static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
> > > +{
> > > +       struct anon_vma_chain *avc, *next;
> > > +       bool locked = false;
> > > +
> > > +       /*
> > > +        * We exclude everybody else from being able to modify anon_vma's
> > > +        * underneath us.
> > > +        */
> > > +       mmap_assert_locked(vma->vm_mm);
> > > +
> > > +       list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> > > +               struct anon_vma *anon_vma = avc->anon_vma;
> > > +
> > > +               /* All anon_vma's share the same root. */
> > > +               if (!locked) {
> > > +                       anon_vma_lock_write(anon_vma);
> > > +                       locked = true;
> > > +               }
> > > +
> > > +               anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> > > +               list_del(&avc->same_vma);
> > > +               anon_vma_chain_free(avc);
> > > +       }
> >
> > Are you missing "if (locked) anon_vma_unlock_write()" here?
>
> Ugh god yes. This is an annoying irrelevance as we eliminate it anyway later but
> I'll do a fix-patch to avoid bisection hazard.
>
> > You could also avoid using "locked" variable by setting anon_vma =
> > NULL initially and using "if (anon_vma)" as an equivalent of "if
> > (locked)"
>
> I know, I did this on purpose to be explicit. The compiler will optimise this away.
>
> Anyway it's moot as this gets removed later so I say let's keep it as it is.

Ugh yeah it's just broken, as we obviously don't save anon_vma. I just hated
that way of doing this but I guess I have no choice.

And find solace in this being an intermediate patch that gets yoinked in a later
one :)


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4E6C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7784A6B00B6; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AC36B00B8; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DDD6B00B9; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7C76B00B6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C489BBA6B2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:26 +0000 (UTC)
X-FDA: 84356561772.08.9EC5E16
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4ED438000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HH3jxuZU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BI7h+juD;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
	b=ArqaQcehq/p/snXZnKdPL8w9DeVnVKPTkT62LM7N14FEKrAqzm6+3P371B8CnNm0jl4e1h
	Qd/8mkMJuI57XMDraNz9Uvg5U6QdeNi3PEI9y+AtyiNWUBjPpVHTdA1gpQ8tx7WvnwuxMb
	t3xUv54mdTILnfc1Rb+v6qanNqaVCCA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HH3jxuZU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BI7h+juD;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014283; a=rsa-sha256;
	cv=pass;
	b=k3Tng08xhcPNB/5r1NH7bQtGfEbrb0iQAKDWBYcIkjzvndugdlW2sNR2eOG0qc7a1j91nd
	sAkmEWa99RbDtcQUB01c6iIcR8fqtzuaFYZCkzwxhT9dzrlxEz1UtM1H/62qwx/iyDactn
	J75ozPP0H8tlgA9bkOVxzM0n8HEzsp0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDuguT3029196;
	Wed, 21 Jan 2026 16:51:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=; b=
	HH3jxuZUHyldYzZdJdUL2WcLRtwyGGhPQHVGcsPOp9U8MOD5EMHDvEXuehva3NBN
	sjNbwrH//okzAut/anW0pln661Xkl/Q3fTZn7fApFXHE2XE0pwK2UHCsiNVGUzdr
	VvMLiWON7nbDvztx94CJapFUOCaTX85KuFeAfjm+uXl/SosRf1Nv6MSzFiRUoyom
	fRQBnuKB+DunRNMW+e7du3RFBOQfNIOPKEBEB3GdHsbDfnVjrKZWGjKaHVeOSrb0
	9SFekgk8ajAAhnHI+FyG4mpugYgjBu38+t2AlLCx/yCV8KRuZjMcNtbmOpai9+GZ
	Hy5AvYIMwF2j2PBal3tZBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx874-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFQGpK018321;
	Wed, 21 Jan 2026 16:51:05 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbh8ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJ1qmTjMkuCIIlcrNIwQVRzOxHLnAZNJHdtQNWnDGEHgXuvXzOFpd95EqLcqSem6NmKmXyJ5D1QuOEBL6pERUjNGYx6GK1p3kaRvZM7MRlra0fyZq9ltjOCzRmweR/6FT94SLSYXb6b3RRkTlVOlTLbHSzhD+JTSWmGwNcRTPno8kUXZk+EGMXEnbwvkbMXujAzwVTy6OBmJuzhGyURfRCiwqdJnp/1YdN+qk0Z1vYwrNuUvrsLrcMPYzGHJ5axCAnTIvBfAImKtf+O9Ca9bKheO5MzWukQzo6x/Yi9Oxc25w1ScIGin6Fik9IEI+AkgbXPHpNH5yWoXAQKCB0hiCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
 b=xn5dTSPMIL7EyD+7LgI5cZWlR10Kbbftkc1RiVeC4MpeoIeAJiIlTCi+rWcDxD31mq6c8I17TY/jo30V/Aytrdmym8Egc/5YQ2VangWlyYuDVJ18wOPQsKqBOOi9lgX24Q0iCekYdT+ZRJ3eDz6GykanNEbM83XKGzB/+r9yKcoby6E31XyLc07xbOXhV+EzDOcoRoG7ShKkVQAbBCgOSLtH2bZfh80SkPutlseSbF9Xs8AB4lQ1EBMDPEAzQ/e6SumQPUVpYa+ENYJ76zpodKNHOsim3jpk4Pl87ZpAbKFlN1HCkkknx8Fh8t+45sG0gYBYG5F9uNHX+kxFNgJ4DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by0KY1CnldwXqWUVlaFcGXe9rhmk5DjazvuCYy6FcWA=;
 b=BI7h+juDS4I6oKkO+snuP4pl/7NT75SlM//HafD0gJ4vneN+G7/sXJ6OFNjmP2GsfolVnFdfbW2BwmS3+att9+NWtX8SD10w0CGZXEt+FYb+n6X5i+NFLnna0LoXKE2GsVgLDHgnkw99Gf7PgsJW2SlXiaI1a8NRD7/MqEYFumo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:51:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:51:01 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 08/11] mm: Introduce unmap_desc struct to reduce function arguments
Date: Wed, 21 Jan 2026 11:49:43 -0500
Message-ID: <20260121164946.2093480-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 6957c6c7-1f13-4d44-fecb-08de590d426c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cyGOXQ7o4DCvp11VxUy2WgRydPBiJeGk3F+4ez1L+UafJtfvLWcRdPSjdbw2?=
 =?us-ascii?Q?s3eMKjMx1H1MD0uXr+Uk0JcSHHRVWHEzd3KMOhSrEA1RIHAMsZUlelOlWM6I?=
 =?us-ascii?Q?6FKEtdM/nlope0DWVmKd+VUnaBUg4bGxKGNNbuYqr3FJNGpC7RHSY1+kg694?=
 =?us-ascii?Q?e1B8VBPv8o13XKa642W/nvPDIavRQA+P/qtu3vU5Lc2Aiz7UkzKqnglnvFoQ?=
 =?us-ascii?Q?latLcECf4XUvSBL4JDqVDpO9tU4at+wDgB5Wp2z8L/78qSgrMB8s96U6XCiw?=
 =?us-ascii?Q?Y2tYAxMxlBSg4tkI+Bt3ewTXUv14VOgz162pCTblSqwFi6/U2PAmeucccGr2?=
 =?us-ascii?Q?ZDejR7yV00EzN4bSXTKMdkIzGDh9Rc0ZtoSEmMaU470L6RBdZxLAUqzGlwrJ?=
 =?us-ascii?Q?91atfdl9RO6rg/IyQ2pOsB4F13UJ4y8lBQVt8RcwLfvoFizUMgosM+RtaK6w?=
 =?us-ascii?Q?MSjY8hI0JK0DmZFx9tNldRHcRTcSFNEDNcuYle0M33bif26PVFyUTyN8yPgb?=
 =?us-ascii?Q?V4ylP2p+02w7on6BsF4MeTHhaHkZ8XSIld/RPS68Px6+v/Mgh192mglMf7UM?=
 =?us-ascii?Q?vtnelvCIQLsKURislIYvGw8ezh/zhxQaERKuHOqk75t9WsTtfeyx4pmyKNCn?=
 =?us-ascii?Q?t2/SaH0uCkDfHHQJ9Nn0HH869FrA5ki9IBGmioPUJFrSTwddauGKctn90W+m?=
 =?us-ascii?Q?rrIBdJHlCwivOf/3vlV72gB8DA3wQFDStWLgg8uRzjsiFNxip0ZPWpefW2V7?=
 =?us-ascii?Q?HYiB/knbPWxA1LpqTNUNAGaF+HbLYPg0jnJZl6NkRHXjHuvFQt0v7Amb5LOV?=
 =?us-ascii?Q?sizUu1HxbVTu0M6KJV5H+pNnXFc0c9DoOuDMYm+fcYZlLRkhldbt2O1/PS4w?=
 =?us-ascii?Q?LO9xhctKW3RHq/5ZzFZLMmi1XLnh+FGp5lEVMsX3KtxKIXTmU0j1TLfKM9He?=
 =?us-ascii?Q?uYhkFKtH+aJbuKt2iqXdisEFPsyOuUOwIp5Thh2olrZyyFdqREwcdqR42Bpr?=
 =?us-ascii?Q?XjgzKaVH8NgHukAP8KLB5hMMVNsqO/advjpK93KvWZoGRhlxLmaNIUap+KvJ?=
 =?us-ascii?Q?LCeN7L/0PE7WLo1X6eQV92cz+GbS/oZsRJEf8yQZzYu+n5lzyV7o2UWO/TfG?=
 =?us-ascii?Q?xvSwg2xqUTZedr7q86CN7/nOK+/rmAw+PoP3OYO4eQg0OxA6wZEhUhIDdfpV?=
 =?us-ascii?Q?0rfB07m/0LRQzTGHJ/hsAqBkJg6FpAsYhdbH/1sZkz9pdNQvnxfOhfuG6Lbz?=
 =?us-ascii?Q?x8tlMb7W8mtR57OZpjVVozac0t5c8XYCYOJHpMQrQS/jAOeqTVsZCln59WLP?=
 =?us-ascii?Q?l4Ac4P8AKb514EAKVdTShtosmZ7KZIz1RS90ZZWQvn7BHtdbVMBeWyKVJhPD?=
 =?us-ascii?Q?qEU5ZOUfs/SHc2g0uXmIJy7rCfINBVJVy7tnk8NXsUrHOOWTexdJGucfqqiU?=
 =?us-ascii?Q?CVYP73ecAOAmNdIo8VLo2Hd9f+2++/VuULxdQ18CylqVwc1Rb5yXoa9TUYu+?=
 =?us-ascii?Q?cRDaYOKOt6yYgjZ5PHvB0lrEirLHXlOdVjxRecg68XAa2Ns9j101Rndcw9wu?=
 =?us-ascii?Q?LgQyH0ZWy7d4iPh7ltg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j/E3La2GnAIOPN284xUNClrIWaLhSzWtO3qcyVS/cIHPZz3GtCDV7iejwJMi?=
 =?us-ascii?Q?IQXihTPqaMpMAvJ1kI8gIPGlJn7YckEa0drM1jqt4jaqlYDWXlgLmTvY05y3?=
 =?us-ascii?Q?JXK1HN/sVw9XSli1s6J3Njyjn0xbNfnMBAOFfDcDn3yKaoBVlMhedxnAvIa5?=
 =?us-ascii?Q?0Lfd15Ywi+9B0pD8iLSnEzUeFdmkfAJuyqUj6wCk+0E857H9+jnaNCdUDeHy?=
 =?us-ascii?Q?n5C0pHjQM0liEnhOCz1zRij5EnxUNIFmDzr+YB3dtbSJVDYmmX7gSN0cwpS1?=
 =?us-ascii?Q?RZeSJsLYVh6VFYjSWz/GbHWUOURL4fmfwShEO1f1VE9Pjz9DS7SvUzK9jA7d?=
 =?us-ascii?Q?BgtoC4B+EvLjTh2HQCM/eyXaNV2JF1ItlajQVsnE/M5868j9LfviE/5iPOzb?=
 =?us-ascii?Q?9chPnPUWVXWmVVuoC+oZOXfB0ilNgwEd/FOj67WrgDm4hoCGU2NryHSOK4Zk?=
 =?us-ascii?Q?XfGY7kLIg9SyPazrRgtk0idekeQxQ/3KO0Z5RsKTG7f0Nro6pCtqe+Gf08/R?=
 =?us-ascii?Q?1GgOMCP+XK3XnWD1Uwt1pqz7XYOZLN+W2MvKhrjN1jXkez/lNodAO5u2x/FU?=
 =?us-ascii?Q?djBa8A0482PNdg3nJYkBsiX31o8EPVFDN3kbE47IAetdkkPmPFyk2riAAZTd?=
 =?us-ascii?Q?CMMf8Cf07GFOqeEoWlXDdSS2gOlFfEQHBKaRCzJo9sADLF2ZWTAfmjcQTGaz?=
 =?us-ascii?Q?y+61Lu3fGTvX/2LJKiUrb2egPl+zHZXDxpybGrAeOTS/312PNchj6ma2gm2i?=
 =?us-ascii?Q?wN1yMmEeL2li5V/N4Zys7bt6V907wH3992LEy8f6dWfp+9O1RO4JHCXmMw2t?=
 =?us-ascii?Q?JoLivzZXYRRFnsNoLcxaXsVoEbkDPYm1Mo02kVsLGdKU8EXwDwzFD+IJFE45?=
 =?us-ascii?Q?A9uV/FH6WfmxetJSkQVJ4xFvzpa/EWdOOoqDQL3x3I6EVvHMEAAawJniCNbB?=
 =?us-ascii?Q?BweHE8PmRuC4xAh3WE3K+dkZqDxupO3i5lrDbUeritT7kosnquqX34TJmVnK?=
 =?us-ascii?Q?spE6rNGbpUQ8shtSB79ebLJOWNW+1kZd8Qbc+U2PrcOJhdNLJ+RD5vWphq4J?=
 =?us-ascii?Q?IxvRMHwCN4lGBATvfd9Sm/g9hIVWQgW6yZGuzUxraa96ilK7GIruYBw9eYjZ?=
 =?us-ascii?Q?9lRJPabD0GbaFa5B/IhObyr09hyyRgpGLL9KfDh+y6lwf+xeA5CVk+xK0n6c?=
 =?us-ascii?Q?v1JSyJ4EseCwTlY7PR5B4DNxcr0Vjn9xxJEHcFBGK2Moyb6n7vIlExJG0q5n?=
 =?us-ascii?Q?YpBnwVbJ/1cP0lQ96SZ/FcvGN4Ne8KBJ0yKpIuofDrOphDrsuL9DtY3k2nZl?=
 =?us-ascii?Q?Uqt/j0JQqRsRPcrJ0nZVKFVv2i1SaX5O4KETOj747XPPpdolOQRWnPm6opfg?=
 =?us-ascii?Q?XyEkg+O9e6tenkY3ba0JjY0nrpqEFfUYi7Gw61UI+908h5wTreAM64iwt35d?=
 =?us-ascii?Q?pZRbfD/qi1CVc0EsYz3r1nm1bpFZf2F809vvrVoLctpwwp2GHdzBqQeLE+R1?=
 =?us-ascii?Q?UhaJ9J5XJs6KHRGmJkiJJQTK5qNVpoPjm4LdU8JmBuxfTFafrphqyy34oHc8?=
 =?us-ascii?Q?ncMrxW9irWSAoBGybhGI5joVquuNjLc7IIH4QF3aUQH1w2wBSB4FSEBHD00n?=
 =?us-ascii?Q?NUAarO4pSgN0MUUjmAmkemTnLvFva4KPgFK3mTuYVWvvGUhXCga6SquqnuAy?=
 =?us-ascii?Q?5DHk5EfUyYSAStCJf7ctQ0tmDXTaq47s+51Ny356wlf969RL4Kkf45+mXz7f?=
 =?us-ascii?Q?BGB+7ihs2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UjT4/IpaRpEIOZKtSjOYnBYbCvtQA/1vrZ4E91kFm0lIWAX7JNq88lqNAucwHiuNONILfpSNpXCJUlIpYpOeS+IqhtXdmuNnaUyx1HDKKw1B638BRCOW9C478Is8Oq2UiIyi60UzLqUq+jwv2ChbiFexv96QswP7UYfjhk597f/11arL4exwBatsmgSjLajK4DrsiNwbOGBea8+maTI1ND11i6vNYMbMZlOIfU2Cl+ycLcLgIfG/zwcg94pvWE7iy5SAT8gRbkU7h/UOVldJZqtgUcrRoWEEsj6/plt0MCKvndL5vKAJN96dyRVjYyw6/xLWAfLYkq1DOA98ggAmWc4geAjTs0CxCkrodardSmVUZHiWSTrk1C2x5HaXB+BbZJq1zc6/Tcc86fdnS2hV9T/UZrPw0pIFvJTjQsfPvz8rNUXTzdLgXRRWPScV4AZ2fDVtAPN/4rgrRDvwQCVsFJ1sO/tPX11Gxw8X5CMubutteFmcVAtZ5v/M7hmbpjpHEj6tk6loB9ik6V093qxvcBMZhyyVhU9UfU8J0PbNXPmJEqiA3p+PyryRM8697sDSssGzqX4Cc15idF4obDr5hjMTpSz/AmjgxhN1a5XzZos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6957c6c7-1f13-4d44-fecb-08de590d426c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:51:01.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNsa+zAbGE5lODTf4aeZwMzUnJPnFs1xn4qrFHBN+1OpXEWvSb/RkgueZoX2AaNeiwDCBoLK2UqOBowMnt9tQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=697103f9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ba_3bG9lUs-xoXSSiEUA:9
X-Proofpoint-GUID: 1mIFyso2utDcBmH5JDQCWDJoJSpCViA0
X-Proofpoint-ORIG-GUID: 1mIFyso2utDcBmH5JDQCWDJoJSpCViA0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfXysZOcfqbDzyO
 NBLJXP6i4ao7T7Dr/EwH9Y1MHhVd//d/4wgeDznIk4LajQ1T3xef4QYmZzDQhlBpawr2QVPLTps
 woyfCWMdwFeqx3+/WhP/ImZF5bxXOLMzyY79bkEJ5At4zXcbUROmnApO7q2u5SaljyuqLteTal3
 iIMAnq1E22W+wPkRpyG2i+Yr77+WYHkM6KH7RnU9MgidjYw4jmk3hhsxRYQIvEWqOficGBN36Xy
 blCa54amatqSkPIxTZBWJD5BrQTbjlED3irDwSQHwn7Egg4+juN993Pe7KrUbQ8I9iPW3B1j522
 nVTN41xm82gGnwWx4rmByI46sGaZTB0u3xoXi6QVCc9bnzcrK0iwilG6jJqGKEAr7Yd1VyT/zFt
 knfRrUvV6vG28AQ7jCF2VH9E7tguQx8eAVa5mDj0kCuYpJdBVPNCOIK0YRItVsxrDw5S2roPVUW
 lR9VuYiMO+NOn9gsxtg==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ED438000D
X-Stat-Signature: c86zf3u86wq8jxtmfc53qescnuw6feq6
X-Rspam-User: 
X-HE-Tag: 1769014283-303766
X-HE-Meta: U2FsdGVkX1+E+B4uBj4dhMP/2vDcY/rCWNsmz8OqMn9geN7PCEv/NAz/gBZ0uymZg4vR6O9Kma5UUjwWJic8+pbNSaMArKSz45cRIc9n1C2GEJ7K2sb2kD9BjkwjFAAy3vJuesnCSFn609ZNgNgMHJeX/t4TB+xUChhSaYEGVQOsOu7VAFts2/a5Y2Fk4UQ0i8HyQao3Kb1/B5BLcCjl0bLE8sDoCNSeo4wynDZoyaimtxaAgaj4xSMmWaI55kVe6NbaRkGj3Uffuubxyt5FKWPJcU4T7o6PhPf+Uep4+c8Q5rruEnngyE8/Ksut6LY/gRxN+0lyrB60t5UzRJQv9hIF6pxFW8Y5EJKS26dAeseaklpd8EwYAMhIUtis+HL6uZMwbpi5AFY2U/C0ecyTMZl0fzUrVZLWBtn359O3qCDA824d8f4f+Hq1gUpSw9er/AUDOSEK0EjFIC0OB/xqNMwzCUXflJ9Pvf8GH3EG0lDi1s2eZdp/XShIp6c36bxBzXNOWikf706JFW4dVo2zKveKDug61c5Ncpt94oy15vni3qiTKQz6vdlf+Z1PZibsyQKNrkQuuuRZ0KuQWH8ZUWvc9ELlgenv5+PYksvQttozP1QSCO6EvFykswYiyrgUlGjgrvAr4+QizE7fAPf540xPnqYJNRHjz3zioL8nvsuQMXFS0qKKSPYTzULQFZF1svt990cl1rVQE6zAxdo8WeZI+q+GSVW82cUtZFtXBdSA0W2mTM9oIoWiicDvA7NcBHK43mU9XxnegmXqJT8o/B9CFM4UsVxac0ZRTVWK1Xv7uOIr0DEWD2Tdsj5vMkozobEFu7wpEm860VwefAIBx/fqjmfcPYjje6ENgKEbn1Udhiyv4p3d1lbY8VN33e9a8bwOMfndJsrSzOAPCk3HbtNxCIKhuOUqaUbwN+rVBbExzAMyREpO2c0UY8XuR8lc4vwPMgEzvT/wLUg7vDe
 cYWzipSr
 ZWyy1QZz6UJsM2niPmhJajSpgYRX4OLjeHOCbmCRCmnxSJzlLQ6V7sinVPHX1NhLISXqwErwZm+nyBfq1C3UzmXcAggIxlUSaMdM+mYEXi5de5ni+ACJ/SI94zATgAyHTDHprjZcmKUU9VshdWcVSyKD1tejQ556vk1Gg/pBskHwxsG/J1HwDsze3UfwNu/S+AtQS8SdVNAOC/quWO5Jtr5Kk/tYCNwy5ZvZM82sVAbR+n6dYxPRjEhuleHqqi0Wgmj5MoPuA8LgXhC7lpeR8sWHe0nK5KVdLic7YTZIR6oKda2twPluD6h/VDyx/A5fxPD/gRiNoUHwddx7xSj0t5pxGfUnujiKadtzX17GtLaRIrtZk7o98z9VBgBnL/x94Hz6AAsRrNa5055lt9LmOY71nmKhFga+fFemHffmgEyqymXiA20V/dRAjjGqS5kE1CiFr3168JIVZaT1YU7fMBrl/5wxtmi74iJ2pzJY/l0kTRZ2Ps4npDOy0BhCa7dHzJteNsCByPalq+WT06qvaTb7/SUaNMqXoAIx+aRsX+5xny0KpNMMZZZJcnYoyWzfDOnXOfP+8AQxmRUrZZj3JqRxUr1dOCFpLG6v9RDlZ4UgyFajtAOpsLvZzAYv2tQQreu/V+QfGE0oAXEU083b9FBPPyWhIqGfvAfgZ7/gXtXTUM+DItbbWe/b3/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region code uses a number of arguments that could use better
documentation.  With the addition of a descriptor for unmap (called
unmap_desc), the arguments can be more self-documenting and increase the
descriptions within the declaration.

No functional change intended

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 14 ++++++++++----
 mm/vma.c  | 25 +++++++++++--------------
 mm/vma.h  | 35 ++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 48dae3d48e46f..4500e61a0d5e4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1876,11 +1876,17 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (end) {
 			vma_iter_set(&vmi, 0);
 			tmp = vma_next(&vmi);
+			UNMAP_STATE(unmap, &vmi, /* first = */ tmp,
+				    /* vma_start = */ 0, /* vma_end = */ end,
+				    /* prev = */ NULL, /* next = */ NULL);
+
+			/*
+			 * Don't iterate over vmas beyond the failure point for
+			 * both unmap_vma() and free_pgtables().
+			 */
+			unmap.tree_end = end;
 			flush_cache_mm(mm);
-			unmap_region(&vmi.mas, /* vma = */ tmp,
-				     /* vma_start = */ 0, /* vma_end = */ end,
-				     /* pg_end = */ end, /* prev = */ NULL,
-				     /* next = */ NULL);
+			unmap_region(&unmap);
 			charge = tear_down_vmas(mm, &vmi, tmp, end);
 			vm_unacct_memory(charge);
 		}
diff --git a/mm/vma.c b/mm/vma.c
index b92383e5eebd1..75c68c74c062e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -472,21 +472,19 @@ void remove_vma(struct vm_area_struct *vma)
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next)
+void unmap_region(struct unmap_desc *unmap)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm = unmap->first->vm_mm;
+	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
-	mas_set(mas, vma->vm_end);
-	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
-		      /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, unmap->first, unmap->vma_start, unmap->vma_end,
+		   unmap->vma_end);
+	mas_set(mas, unmap->tree_reset);
+	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
+		      unmap->tree_end, unmap->mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2463,15 +2461,14 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 	error = mmap_file(vma->vm_file, vma);
 	if (error) {
+		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
+			    map->prev, map->next);
 		fput(vma->vm_file);
 		vma->vm_file = NULL;
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
-			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
-			     map->prev, map->next);
-
+		unmap_region(&unmap);
 		return error;
 	}
 
diff --git a/mm/vma.h b/mm/vma.h
index 7c2c95fef240b..cca7553c7d641 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -155,6 +155,35 @@ struct vma_merge_struct {
 
 };
 
+struct unmap_desc {
+	struct  ma_state *mas;        /* the maple state point to the first vma */
+	struct vm_area_struct *first; /* The first vma */
+	unsigned long pg_start;       /* The first pagetable address to free (floor) */
+	unsigned long pg_end;         /* The last pagetable address to free (ceiling) */
+	unsigned long vma_start;      /* The min vma address */
+	unsigned long vma_end;        /* The max vma address */
+	unsigned long tree_end;       /* Maximum for the vma tree search */
+	unsigned long tree_reset;     /* Where to reset the vma tree walk */
+	bool mm_wr_locked;            /* If the mmap write lock is held */
+};
+
+#define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
+	struct unmap_desc name = {                                             \
+		.mas = &(_vmi)->mas,                                           \
+		.first = _vma,                                                 \
+		.pg_start = _prev ? ((struct vm_area_struct *)_prev)->vm_end : \
+			FIRST_USER_ADDRESS,                                    \
+		.pg_end = _next ? ((struct vm_area_struct *)_next)->vm_start : \
+			USER_PGTABLES_CEILING,                                 \
+		.vma_start = _vma_start,                                       \
+		.vma_end = _vma_end,                                           \
+		.tree_end = _next ?                                            \
+			((struct vm_area_struct *)_next)->vm_start :           \
+			USER_PGTABLES_CEILING,                                 \
+		.tree_reset = _vma->vm_end,                                    \
+		.mm_wr_locked = true,                                          \
+	}
+
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 {
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
@@ -262,11 +291,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 		  bool unlock);
 
 void remove_vma(struct vm_area_struct *vma);
-
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next);
+void unmap_region(struct unmap_desc *unmap);
 
 /**
  * vma_modify_flags() - Perform any necessary split/merge in preparation for
-- 
2.47.3



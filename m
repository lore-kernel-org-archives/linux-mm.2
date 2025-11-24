Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936C8CFD31C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A078B6B0026; Mon, 24 Nov 2025 01:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990876B0027; Mon, 24 Nov 2025 01:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A396B0029; Mon, 24 Nov 2025 01:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 663836B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:44:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B30413A08D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:44:42 +0000 (UTC)
X-FDA: 84144562404.08.46B2566
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A437B180008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:44:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pMrCnbEy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t+BYsA3O;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763966679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQuXIMbxp64qpBfxO3a+vz/k48O8GurG6nwvKJJo5+0=;
	b=YprEvUEQxUYjB5gO3GQ7KhVjv+sOfnkdZ4oUjuIe5ZXc8wX+zEzcYvaIJFRUR1HUfXSbSu
	yPz2N6o35gC+GEh1BttdZkmV6gdoighAuouZSAHTEiSo88nFZDbqBRZXbuvBEGG5COi4C5
	E+nj3kS8xPQPCC6IzqyG9TnHhkuk4IQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763966679; a=rsa-sha256;
	cv=pass;
	b=KBDtSv5nmzyLfZiHfAq5vJUsIHvbEWi/4+p9Ikmk3V+T1Y8dVSrfOmL3/Bi3526fb2QRQE
	wtv9pFd9lkc1s/y+zA96FNEH4aNEMxVjsyCn7s3CgVGIDVL7jwsjlaxj7H8Obu5smSrkqe
	TeaUIkKjOM7c7dWi7K/NAec46wiVGjs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pMrCnbEy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t+BYsA3O;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO0SP494058203;
	Mon, 24 Nov 2025 06:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PQuXIMbxp64qpBfxO3
	a+vz/k48O8GurG6nwvKJJo5+0=; b=pMrCnbEygi4KVAsxDt/xS7uK0Ajh5Dfmgw
	besNFm94UXd1YBr1/NZLrZ3r3OV3LdGCTIq5FIm6TUMQ8K95AN3UsoU+/0D3TfqP
	dw/HxLoGR8Zn9LjHkmsgjYN5Om/2SFp5VLVdu2Cd0Ia4RX6yjYb4TMkGzxSEwQyj
	xQ4amz3MZNGdu/kxDRgSFtG5tz09MYZZxjFZF2Ot8PnNje0MgzoQViBou/fLpKCT
	9eC4B8RkFKVFnlR3g5HGqa52A/mCKdalYYNWNuHNOfIlTQCwssaaJnkcMX7nbP2F
	QAOGrnINrTlwagz8HbQmL9Eq8bT0A0Y8eTESMo0J8ilA6K4pCkKQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8d2serr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 06:44:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO60YhV022439;
	Mon, 24 Nov 2025 06:44:26 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mhrw4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 06:44:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x7Tjzriknx131NGaahDzerbKQBU8zFp3rkRr5u2klgdz2iWBU7H8b97DeNzcPD4lHuWe6XzhuVdRs39UGjNdWrC7yhjomnq83leXHzkpKHeSqKKT90UBKgFH1Hmiaq1VAORI+R/seTiXPX7MsL++KMFMIcbx9WZSEEBtqxMMWx5y8DemYNcXanS32ipqqmSc6vwT2mJwkgTLY4iOjiM2roKYvMjx2P7sUcuwSGpXzEsyy3SGHzIz56WHUFrP3xyqjFosmUJj2a2rLN3FyiHir9WvA56d7ZhcUBAZh6bnZAhm13qsjgFOGAblMjfSwsa6P6EQQoiAptxX4ctX9C8SCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQuXIMbxp64qpBfxO3a+vz/k48O8GurG6nwvKJJo5+0=;
 b=hi2ngOkEAfLm6DUReFpEsCxX7hufV9GewLhYw7KqFFqC84Pc7OwHNZpeqmHQtZbmCozVQJ11LhsmJubR/lrV94yCT5s/WYr9o2DehgkGto/4HEyXy9Ln0ftYcP0fDdgPOCv9yP+a2vktsn9Ox3ouq61A4+IfP3oc3dQlM3+mkhbIsIEMOexdiEu3Hq9+Ao62EZmZR9MFjz4hq+mQeAhVhJcfPVaO8MykqzdIuQGv/KmhUXK0gV420RTtFS9n4NhbyjxTsZczI3c3rI6c2AJ6jHD+EhpgbuoKfnGOlqtXU4qH4KwWpWZviy3mjnalJDb7tMMBG/AwyAaHOmunNdBRBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQuXIMbxp64qpBfxO3a+vz/k48O8GurG6nwvKJJo5+0=;
 b=t+BYsA3Ok62i1qk5BnG/PubKA9YSAB7QOjsASUPfM31PlHhTNYzSj9g8/FDwniR/LGpltixPJZM8SU7h9fnZ4yelbcEW6djDmTJIZO/pP0YBFMS7H84XX7VeIm4S6MITQjAZXTNXhKFL3bGypZE3WESCewQUjGXZbxayxXUQH10=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB8203.namprd10.prod.outlook.com (2603:10b6:408:284::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 06:44:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 06:44:22 +0000
Date: Mon, 24 Nov 2025 15:44:12 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Message-ID: <aSP-vNXOhsmMrWNk@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-15-willy@infradead.org>
 <20251113161424.GB3465062@cmpxchg.org>
 <aRYJzbZpd-UP3jh9@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYJzbZpd-UP3jh9@casper.infradead.org>
X-ClientProxiedBy: SL2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6d42b3-3145-4ae3-644e-08de2b24e657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UZitNb2X4+Kb/7mEvWqI4Y+EKrSO+BsUwYFA3LlS20W0TF+yH9kPFQfbWMTx?=
 =?us-ascii?Q?mXGoxTRW40sqmA1vRBZimmKXkhUxku7+Bmr2oa1QulvguCHoqs6n4bLAkz/B?=
 =?us-ascii?Q?nA8nQBfzJ0UCvttSiuVMTgZPqY9Ok+StewUXUPs/jaLBIslwEepsreLfAp6R?=
 =?us-ascii?Q?1UovOuKjxat6JUf1bzueMGmiwZRopwYJtyy84pCG6NPMK3F59oTJEfkI69gZ?=
 =?us-ascii?Q?errET4rCO4WoXFwjg6eLGMGVyE2x6P+dIA3AgonERRlq8utWJ2ouAII8ug4+?=
 =?us-ascii?Q?gubR66GwnrQ7e0xOEuKLUJCWQGyIZMqPNvA8VPhP9Gqx+8pjE8ZSub0+4zVq?=
 =?us-ascii?Q?XGs+iTj9L8prmnXZAkutiGiJI/hoPS4g938+twtpkKj/ggDJn/JW1ky5wdWg?=
 =?us-ascii?Q?BKzIKE7Erzzkb4ST0tuhT/Rtezf/o0+aQboDqnSqgnsAcyj8GHJuyYJH7PyP?=
 =?us-ascii?Q?Iryd9iPK5hMs3h8SaE+SZoVqjus96xNv8g5pxnAPhaicKi9CWKhAXxBbrxMQ?=
 =?us-ascii?Q?Ijsd4SR/Z4xFYsak3fZBvu16auOr7LNHpK6zhTvazEPr/WSCqZSZJsb1Yh6d?=
 =?us-ascii?Q?ssdIhHJFUTRnPMW1HzhTQer9K+r7ySrKwsUNo6YzojgmnlJbR/Oao4DsMflG?=
 =?us-ascii?Q?lTiy9g/B+vkJiTZ7VA6QAOCmX3VkjVl7UDBALSGYfuikKrDgz0O5QWSeTaju?=
 =?us-ascii?Q?QsZQqSNnMMrgb2X6AiWzgLOZxrEayPlmZOb2h0tNzOGqSU3SRrDAT3R6VWcF?=
 =?us-ascii?Q?qytiYoYMWYO520ih2BW19a+DeM1sWD3MGz0llSCg9n7uV7rM3VCry5bEfgG5?=
 =?us-ascii?Q?FZxZt2+ySzaSfJRC59oETAZi7F4V5ZhwB0eqwsFypXJRSPvvM/2m25TUsRck?=
 =?us-ascii?Q?iwKHUksx0ZCk59M1cEePfZOvDI6wc8EkSFUa+XJ9i4dzWK2O+f+nFnVB8LDw?=
 =?us-ascii?Q?tolzrjkRlsBt122NM+J4hIE1/n1B36MmAK5gRLSGElBVuEt62u7tyUtGujML?=
 =?us-ascii?Q?Bm4II7RopF32AIb/wC1inflvTywTGPLFlF3fTujhTOSv84T3qn+32q8l5fv+?=
 =?us-ascii?Q?oLv1w4InN+bX10UImUclfccVaFc9JWvD/x7ABSYlqV9hBilBeF4k8hSPq9jP?=
 =?us-ascii?Q?HcUGOKeap4V1EvrHAUptNn4JBej8v0xz/r2aggHYYXRjTgdh6ogjHtAtmHqo?=
 =?us-ascii?Q?OlHN7ALNe7vBWwoLLt8IGKm6vnGIAff06MNxJ8R8M6R0ZMnnv9BOYzgyeuFg?=
 =?us-ascii?Q?+PlXvREeVm+/fjaKYxHfmrzVIMJDTqAkO7tXKnzt8gOFeQ6BoM55Xu44NTPX?=
 =?us-ascii?Q?3F+OgLmSJS/1WUswsBAbsS1AG5oXpAPmP6WRemW1xsFr5yvtKHqqzNgab1J4?=
 =?us-ascii?Q?pIj4v4DqGglRyPkoXKA4yS6oKCT7ob+bgc6+ztbQ02DQgI+RxJwAds0SYtul?=
 =?us-ascii?Q?fpEum0BDivfwG43w2XXYxra1iXmo1ydS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A5BpAII7ZlhBjSwvzVYN/vhJoiOdeFbLj68qqdU532vVRdR1dC+9HcLR0RQS?=
 =?us-ascii?Q?G0QsFCW5+JisFqUg55Ba6/t3rz1MgqQI7V1YbAPzExvn6ZcOUyCXMeNOmccy?=
 =?us-ascii?Q?CDltLl8ZwPzJkSQapFBdG7SNHbgQLEuf3VWmYe3QO+hVbWf3Ga+mOuBRbgFM?=
 =?us-ascii?Q?GKhVl8aN7U/VLGVnkZU0H3aayxZ0LK8np+H1tIlVsy4e7SBFT/4vv0K30YMS?=
 =?us-ascii?Q?OOhaSk526m229UB5U+RpfRiLwb0dHaS3/GQajDzD0tp9M3TGPFJmkpkEZi+N?=
 =?us-ascii?Q?sD8aT6Op6Dff0sfH5qkfqBfCx+ThRw2yvTNLzaS4rqKNMaBfCTvCf+17s7C4?=
 =?us-ascii?Q?X3amuHr0abj6GvRtyEba4+/0whqqUg0GFnM4EuHeiZiToJKmJ2k1ypXScSLo?=
 =?us-ascii?Q?Fud3Ib16LtSN3r7Ty6T7xpLX9AagtB9vskEj1UP/ab368yo5UWm3htLoXzWI?=
 =?us-ascii?Q?uWg5kaQPd3Eq9qHsUGVlGl79/picL4syPotZC6a4F5tUL90nLomtH8f2yRDs?=
 =?us-ascii?Q?0hRuywzhdJiCRz0LfuX3tjIpTP63iZYdc5kJfwBTD6t63hzXAr8aDwZ68x9p?=
 =?us-ascii?Q?/v/hmjNCFUjzeOy3uePFhIAJZbd+duY1nTLYPR+nDGyhB9raYyE/C0iQIvzL?=
 =?us-ascii?Q?25sc0hkCVAj3ArHmody3cBs8604xmTQ4iPDEj9kn8HN/4lrVyK8iW0IMxedU?=
 =?us-ascii?Q?wWqdeoLJfZ6t88FX7yIkcHkPepS85AfRQ+K49uJSrcsH3d88CXbgHdSvKYWP?=
 =?us-ascii?Q?jUy4DSwN9HwCzj1wktL70c33SkfP8acOgsVRrTapSG2amWBJXyN8+7fmar2d?=
 =?us-ascii?Q?MGHLrKFvJBzztyMBEWuGmC/xAsC9DZtYzYA5vMaeOLZzRG4C+lOP4Dw2Kk1+?=
 =?us-ascii?Q?9WZBiEo4Ef2yfu6pnWyaEKletsEVRVKAwAJ9jfuZda4GjtkAqhtpO1PSHer4?=
 =?us-ascii?Q?igPdrCZgf2PAr/VbNAi3n7655204gElC8IBszJtP1jEz37z1VfBh6iXo0+V3?=
 =?us-ascii?Q?1Mbgq0Iv/Enros2WFAiS6cZFruYvqOa6K/0Mb50dEvTQ2dekJqTQWqDmVlca?=
 =?us-ascii?Q?jE9tqYpkoxx3FJDHSyBmrsy1J/WQZKOwRZKpwPOBJtXvvEx5aSO6317dHlT4?=
 =?us-ascii?Q?SEWTcOw5GlYthkrQs55GgrLS56yyYjhIYXJFDqBxLfzROS6RPjvFkZaVM6R7?=
 =?us-ascii?Q?lB2roHtvS8znQ4s2RNI/CrzcTSIT2YVJKjKYayiJyZvl2qwMkdBNPqLwp66l?=
 =?us-ascii?Q?5gsXbbDo0eExw71P2+a5ri7XJszCbzVNnQYMRrJsoWuPwYY2k6+SuqbRLv+i?=
 =?us-ascii?Q?Cj9hlinhUrjCrjOuvXwI7PAO3vOmgKX7+aRzNd1vnLJ3FusAZA8FgpE/704Z?=
 =?us-ascii?Q?iPq07Zx9c0cFMbZ+YGz7s0vtchH4s1Jn0wpfiTKdN57qiCFpoY0YEFKJln6N?=
 =?us-ascii?Q?wAjdQfJjX5WOvPA5U+L/0qYGwAPaD8KKyJjVBstSpbS0qFRZQ15jZo0R8lzN?=
 =?us-ascii?Q?z94zj3qJHG+nYokdA9n7YC8i74WK06bXxHEtvPbWZXO4eneAgrsWQYdBEngo?=
 =?us-ascii?Q?XSTsvV88bHCYuaocDZriLgpNf4O00di9eZBGAFAa?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cI54PIuji/hKUzmLmJlD5Fw+JcriUbVwehA1sd+JneXF3jjYKNiQNgU6ALt+gK1m5TMVUwFIrr0anPlmEB+U0eYBsJl0zzpv44T6G59xJBcMBmip8tBW4RlbceSpYa0MVWsBpowjIqjUdlyUygLvmRHM19vdB9QH3mtTfnrThkGeXeWC7vKJU3VRBS2hxoaKVWCs9nwMlS8JK0trsKUYxQpyTDQk6t2yRNnEPP9HISzNJrWfGZg4SWfgnFIvzqejONn1k2Yi7WB8z81BZv5IdrWpo6bwlL0spsOf3d96/wbNdu5VqV63NJomYJY7KF4VBwBopJRLLyUHhDCWL0U+JUD4+F1wqnVmQJvV972lUcrSprceXTlLG5UkANTWGwTTccp4c/NSE81vvE/46tn9cCFGHL8nomk1HZAVRpMT9jDagPt15LsduhiZmuuTrx6xAokdxfXfKACrnitaspgNJ86uunKVFe9kLW05X1EqLZX4JsM2nCOCNF4WzaU0YSX9M2BtEQUewkG9p2rq8lPH4DJfW2C+U7F+R7AsLI0MOvZ03LcnkpI1jqQctpAGjq4+sq6/DRQBf/ZfGK3s57hGYy6wdngLtJXtD8PDrCqMygo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6d42b3-3145-4ae3-644e-08de2b24e657
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 06:44:21.9720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHcg9iw2OYngZo+ce4pmEPfnU93rfrmPyRK7XpT9PyeQPB1NP4c8uG47xy0VDy5S4mbnU1EpkUI8wht2M1zuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240058
X-Authority-Analysis: v=2.4 cv=QPJlhwLL c=1 sm=1 tr=0 ts=6923fecb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=8aUy81mhPsvl07J71JIA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:13642
X-Proofpoint-GUID: 08C0SZykrE3TMxtJp1h-fYyvUiVtZgRo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1OCBTYWx0ZWRfXzK5KFAL7fSLj
 16Eap1ALYltjrL0pNAa6WYVEvKIls2HCan6Qg8ZdWQ5+OieR9NN06kiS0q56uny3gy0QrfswCOt
 uFSTCpZvSW3c8tBmp+rD+QQ9LO0op3C/g2aEnJFDSusbttjZ/s8mV+TodKqmO+gmObR6lj3pHn8
 z2ZYz+uDkWsQfnwj2ga2S7HY7r5qDjGmSk0MMOxYqqr4FI/AaBmq/7CTlxvPCYVvMm4uxk+0IbN
 RmKdS7dQ9BXxKWX37ztQm5tuJNm4dnKByXLfecK0MPTc67mJGKxg1W13apAOysTWnpObNoBKT/u
 w6HnDGmFFdqWP/IbdQfZhkNdfc1wHZmESLzdC+sWp5fwpnNErlTx8vACLDiGR+5PbLs79NFrMrr
 k2ZJQiv4trFTAzOxCJRS0tucMDhKfJNsVIxtwhpPr5en7iBycdc=
X-Proofpoint-ORIG-GUID: 08C0SZykrE3TMxtJp1h-fYyvUiVtZgRo
X-Stat-Signature: o5x6ug864xd174atoc4pk9jwnst6iqqk
X-Rspam-User: 
X-Rspamd-Queue-Id: A437B180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1763966678-588779
X-HE-Meta: U2FsdGVkX1/hL0OEqa5/Y+zWlMa9+iqHMJqD9tAEyLxpN99xq9FO9knXoTNQr2VDMWkW9Vf0BiCS6DRO3wZH+VnvbBXGvcyNOCOEbkJs1e78GxjCHInBQA/WWmcs6UIwUptuaBzgrdVrC21mdwtyiczlb6n/uKtME1y2TywaUyjCcnrJcz+r7DnKzqac0njoQ/FnoAy3tRTzebIxTCOW0BTKF4hEFLVTAnxDZOwJWU7lnmpC6cClHWeBT6oqANlAoT8X1TeEJa7O7HFbcxr7SeYolzcugmsMfGa2AgE4IITZ1PXX/7qtlpUpNTheM2zLsSjgGLSUD1RiXBoBRGZudgJiY0RXWYRa73wp99It+uc6DFcLxee7mVUie/qaBU0Z8YtjwLby3dKb3yOP0TL9+wxYGLv1aBDmORjRLqOLYRnMn7EP2E8/aJhwov92L5t4H04KsJFahe3Cr/ZF6xe+aqw44HZYnZ6+G77sYDkuFBaqnF2Ducvgnhtsh2DIj4SCEou3MK1P6WJ5stgEUpng1LK7sK5B1W+YRwMaBIoQoK3Uli+qbmjPdBFVJb4MTUW+s/VYIJORlCklFakLHXLB35z+OmZMw86t5l/VvRC/fwTRS56cjMz5VHcTuCVcZrQ9rctKNgyVaQV4SQQQ57hREUONAOCJReypmikLTTnmuKWwexDj/sViYFdCZLvN+8wU7ikqqXeed8XNjTvvX2e5LHVb+WlsycD9dAMwfqeLjMJ5koeShUND7LuWV/E61+EjsVdXdpwnGH4cBAHgOv0SuRVBOkG8/cGo7y79q7HcGb8ZDqHUxqImAbzpm+gDmsStvHQTQwNhdmZ4s1kqZBnqfbuUBGIZ2cIdG6ZKAndqWuDejwWK5HyHvtV8+TGKTyYCJ0T0NBI6dI4JbgS7r02t7KiyJ4MZ1jP9V5jwzfdDzGelHtoS7yGzg9yx1g+JkLQ8v1wXnY0LJ/DS5HTttAx
 MqkGS485
 1irG/w5dimBB7Yo2QmKYAz0qUr0kmttVJvyzBJCGNroCVe7+HjHEvBuYu4TpbgLuoztuEx14de6GkNJ6NrBeqg+XJMA5qXke298WPgrcrSj+tDsysp6YhutnqGBRxImQon1Wc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:39:41PM +0000, Matthew Wilcox wrote:
> On Thu, Nov 13, 2025 at 11:14:24AM -0500, Johannes Weiner wrote:
> > On Thu, Nov 13, 2025 at 12:09:28AM +0000, Matthew Wilcox (Oracle) wrote:
> > > -	/*
> > > -	 * folio_memcg_check() is used here, because in theory we can encounter
> > > -	 * a folio where the slab flag has been cleared already, but
> > > -	 * slab->obj_exts has not been freed yet
> > > -	 * folio_memcg_check() will guarantee that a proper memory
> > > -	 * cgroup pointer or NULL will be returned.
> > > -	 */
> > > -	return folio_memcg_check(folio);
> > > +	off = obj_to_index(slab->slab_cache, slab, p);
> > > +	if (obj_exts[off].objcg)
> > > +		return obj_cgroup_memcg(obj_exts[off].objcg);
> > > +
> > > +	return NULL;
> > >  }
> > >  
> > >  /*
> > > @@ -2637,7 +2627,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
> > >  	if (mem_cgroup_disabled())
> > >  		return NULL;
> > >  
> > > -	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
> > > +	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
> > 
> > The name undoubtedly sucks, but there is a comment above this function
> > that this can be used on non-slab kernel pages as well.
> 
> Oh, I see.  Usercopy calls this kind of thing 'heap object', so
> perhaps eventually rename this function to mem_cgroup_from_heap_obj()?
> 
> > E.g. !vmap kernel stack pages -> mod_lruvec_kmem_state -> mem_cgroup_from_obj_slab
> 
> That actually seems to be the only user ... and I wasn't testing on a
> !VMAP_STACK build, so I wouldn't've caught it.
> 
> > How about:
> > 
> > 	if ((slab = virt_to_slap(p)))
> > 		return mem_cgroup_from_obj_slab(slab, p);
> > 	return folio_memcg_check(virt_to_folio(p), p);
> 
> Mild updates, here's my counteroffer:
> 
> commit 6ca8243530e4
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Thu Nov 13 11:30:59 2025 -0500
> 
>     fix-memcg-slab

With this folded,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 597673e272a9..a2e6f409c5e8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2599,9 +2599,6 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>  	struct slabobj_ext *obj_exts;
>  	unsigned int off;
>  
> -	if (!slab)
> -		return NULL;
> -
>  	obj_exts = slab_obj_exts(slab);
>  	if (!obj_exts)
>  		return NULL;
> @@ -2624,10 +2621,15 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>   */
>  struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>  {
> +	struct slab *slab;
> +
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
> +	slab = virt_to_slab(p);
> +	if (slab)
> +		return mem_cgroup_from_obj_slab(slab, p);
> +	return folio_memcg_check(virt_to_folio(p));
>  }
>  
>  static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)


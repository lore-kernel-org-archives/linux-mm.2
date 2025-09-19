Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3A9CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CD494000C; Fri, 19 Sep 2025 02:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D08940009; Fri, 19 Sep 2025 02:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADE794000C; Fri, 19 Sep 2025 02:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A732F940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:48:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A129BA2CC
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:48:25 +0000 (UTC)
X-FDA: 83905070970.15.DB3E050
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C142610000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:48:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H21qLmGn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rGD8HbT+;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758264502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymKZNhEinJEaX4Th2xN/1gjCho+RRZqwilnCPu+sdAk=;
	b=zP1Qao61AcWm6ZfIafrs9KZPVsF1rYsejmKKD/LfBhDtdd5Bhecp7KIEI4F8penL23MY4Z
	fXUpugES5pD8QYzSYNlL8PGfD/8H3CyT9C+OorjAJ0T2yZKr9OSn+NjtEHLJzNbrCzjgnS
	twHvGBzoawrrqHyBfd4jo8Z2A/XkE/w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H21qLmGn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rGD8HbT+;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758264502; a=rsa-sha256;
	cv=pass;
	b=1w4X49eChLLA+54gfn7IjQ0eRs+7P0Jb6o1yn/79B+cCBeFVWka1gUGlGJdRdkAJYvyojf
	wd22nb7kYU0UomaVxZQ//bZu2Ee46t3xehpKd23mc2EGfRPB1Ne2J0cpg7POg0H4ioVUTS
	i7HbYzQodhV1L3yX4Vu7dRd6lSprXl8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ILGH7Z018773;
	Fri, 19 Sep 2025 06:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ymKZNhEinJEaX4Th2x
	N/1gjCho+RRZqwilnCPu+sdAk=; b=H21qLmGnneDIR7gt85xOIuc6I0pIEGIuZ3
	N8P3tcO6fLadotGGd9Ot/r2+Hnlmd5u9qWw2gD3oN7Eq8IY0kkH3IYDpyDk1ncUd
	Ie+zBJmHZmF9nJRwGmeTrnU7ZlsnJ5qaztJVRgc1qFYfNL5WsX2esL0DuI/KrQhH
	dRg9h2jTijvBsjD9l+qbH0qcKlCZ8XQHMnxcjCk+lZjjYt9XjOryMlBC1jnZa3r1
	B5ZgfhI2gvLb3q6Du8Gz8f5+y8Wh1S4NZMiE2GsQU/P96YJ8JsFa25uOfPuWTI3f
	Qih+NxuSQ9eGTav557FVf+fM6gJ8ZflMbv7qgYTj6AMcJDOVuixA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0kd1ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 06:48:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58J5OQnb027290;
	Fri, 19 Sep 2025 06:48:14 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2pdcuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 06:48:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dr/x8mA++qtmmEkiYsLfgrMXW/uDQTiFsJD/TRVZQc1rssFG0rFQWC2BUf7mRqra4o9QJUSAt/j6fD7tSkIuTVM03TTWcwSvOtFYa4JrRA18NZfgsMzLBZCDstessUHxPBsi2sUQP5nM3KqZcQqs7mvaFrXZA+HZydTC1UfFjw8keHDy20WOk1AmXwW/LnbMYGlX/Y73eD28WgJtUzKr0S4wo1VchHd+7/k3u4RBsZEgyeISf7VS/JKKJLR+FzJuFihvdXX+/kR28yUvPtS60K2FD9UIU8u1dktoW10oX0B03vGAwOccof5ocDyyM2oaDCkElMuVwHrq648BHD4UiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymKZNhEinJEaX4Th2xN/1gjCho+RRZqwilnCPu+sdAk=;
 b=MknoCQg9NufwniZKljq5ANyO9WFaXkTnAQNa4Wl4FBzP8nu8DamLoiklBEfNwr8bQdsZbfR7pAFrIgOpoczBeanWncWHjFMvN7D7yolB1WWV1qrD5jIHvqGsr9/wQKmNi7r9nSNQS5tRyxe+GcFD2Rdiw1s+oanxvjOQ+O1eWa0lbevFOJgX7TsLjbbfTU3hBp97Nu0ho0tyZ4tcDlP8Jkc8v728Sn0WNWfvBNjqxHX570sUAtKL4qenEaY85X/xRFbo6twBnWDHqBCheiT4kDuu96VL9lJZbcou/qctcIM2Y9KJvQZi86qXRNB5tryHdR2Gy4af+6fRyBDuKLPrVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymKZNhEinJEaX4Th2xN/1gjCho+RRZqwilnCPu+sdAk=;
 b=rGD8HbT+npPNibthbCbAsRSAQGq1kvSJ1ll1ROW9dlhVbeUn4Ij2kfDyRK4pqKVAPpp7st0vaCS5TCgY9dtlwVoSCBYib7iEWfabzoXHKqPqzgGkWzp0BdeV+UNTIfmRv/ScRk0htiAN0cTSuv7vHm41yhQuLR8FozM9QMEVvy4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB6342.namprd10.prod.outlook.com (2603:10b6:806:255::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Fri, 19 Sep
 2025 06:47:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 06:47:45 +0000
Date: Fri, 19 Sep 2025 15:47:34 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aMz8hk3lrWiPQYnw@harry>
References: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo>
 <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo>
 <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo>
 <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
 <aMq40h5iOjj8K7cc@hyeyoo>
 <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
 <40461105-a344-444f-834b-9559b6644710@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40461105-a344-444f-834b-9559b6644710@suse.cz>
X-ClientProxiedBy: SE2P216CA0164.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2cb::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: e294e95d-ead0-45dc-abb0-08ddf748707d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ewxK9HHgcQKqt/+FhRIm/YTUzjUo0lnFFAmA+84u6Px2HJIjPPv4tgbsupUM?=
 =?us-ascii?Q?RxUNTyw6qKEkudsoSaoJwxPhEPrLavlU7+boZmTS8SCu+ntkDHjKb2bLV2If?=
 =?us-ascii?Q?4ENWrqY69nVKuy5Tum39QmBq71nK+QxGswctjJ6goXgGoVHZ5TNm1/9Qq66f?=
 =?us-ascii?Q?599uFuURfcDzQkLkPCS/B0Ly8NPh7GzWFc67FOs0lbctXYPgRcw68OgHfsB3?=
 =?us-ascii?Q?jktvtj2dMfKDvBb8bMPH/51hGcTTMvRPtRWvFu9zuKjZTMAlpgZVh+Rl3eEh?=
 =?us-ascii?Q?GW0TOPPEvBIFkjoJpM8Fo0e+NEVM/L9Shkqk4FrlxDCHYH47Vmtj8HbUZFmR?=
 =?us-ascii?Q?p2V/XkR9G/TrqHLBM8g5NOwQJDWTyaTqNx2ebQwP2x2+Tx/HU4UIxl/wqyKY?=
 =?us-ascii?Q?dWThbls4Qm8ayw0UVt9J7mXice4vkz/1SKPbaJ+kDr2IHSOys3A6KH4FwRX8?=
 =?us-ascii?Q?Vsnm9bef98zwoJRMhGP+rtefptv61xwUHNYfmu3G1v6YiJv/GuwjpbhqMzZV?=
 =?us-ascii?Q?rhvvJbQMiRQ8eEgIq2vnf9QmyGzRsnz1SrbgNSND0NmK8ejwsPCr6L4icX0J?=
 =?us-ascii?Q?iGo3fWLiYpfZiCRAndt1VsJ/Mrk9EwBnk6KLRtV5/qcNME8a9kRcKYCWRn4x?=
 =?us-ascii?Q?eXGQms+2YEKu3TjXVbUpz8vU6/5kmqMEpAFVKZt7oipP7wMgPEz9JqS4aqFz?=
 =?us-ascii?Q?fZEvE4SdcsSVH+o6XTDNFhuHsiH4IceDBcS+wVq5wZJ6gqFrzbh2OzJuTYsr?=
 =?us-ascii?Q?BIsSkPBTkvggPMBb+hc8e+7v9T7plS/j67SqpCB4TyWMW3vQqLWhPx8kNbUm?=
 =?us-ascii?Q?TmhGkHug6DE1jjkuyw/FjNmuQ3EgrWoB9dm8I3YqrNuJZNGZhFzjdoi/gsRb?=
 =?us-ascii?Q?lJwTuHbKcnLTCO5otmd4nQCqyOjUgbIPJUM80WJtJTz8bHguCL2oLGWF5mzN?=
 =?us-ascii?Q?1O5ixrOJuolgxTox/81AdA48x7762xiEsGIpEeMTzeEQkftafJ9Ng2h+ktD+?=
 =?us-ascii?Q?PoRvTwh6O9KjAirsZYmHa55AVviApzftNqsIJQneGFkp8rrTl5OcKFltV7XW?=
 =?us-ascii?Q?W1Yk+vdN7ULImL48k2/3liuYSSFrF5SJcxlHADybdi+phQZBklbxV85oJhSw?=
 =?us-ascii?Q?qKuw48zByjtZ7Db8xQNYTWKbRyhujyeey5czAnZMUO9+HtjFVK8IL0g1BjGQ?=
 =?us-ascii?Q?/alqls6JsabM7uivHGgU20UnHmyM4kh4gCSH7qAUt9MiQEh8Ihz18yjiq/Ph?=
 =?us-ascii?Q?hZo1HJ1dnQdXKLNGJ+Y6yUDfAFe0etcn5rudpPwp1jR1dMRXMYIyjuw5sA2F?=
 =?us-ascii?Q?652mu1yeuVkUydw5qM+28a7PyfxyZ/IC7z7VpoHQTzI0SJvqpZTM+5ZlS+wO?=
 =?us-ascii?Q?L48LjCvlhFV8GCHuMfebra2UNm+3/6u9REEb/3uwiOG7S5g4KUYkbAZSsNqm?=
 =?us-ascii?Q?tEWN1EF0Sa4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yuTvh8GSeIK2BaNxTN+73UTo4ZOh6UATWiDP0hVWeXcqF6KKnMy7a9oiwQ8k?=
 =?us-ascii?Q?U+OnMQNgZhP+35iBMIWj8iHNGyeAGrjXcS/g0bGFiL9rkycwQ42YREJKAWeo?=
 =?us-ascii?Q?4mwcI0RQJk7vmsRS0SRnsRRKBzgAQx+sw6maTrXkQlF6ADUpNkQcNh4ztppJ?=
 =?us-ascii?Q?xBKy5oeO9I9AL5JlHRpWqC5VR1KBU+LnVma3xHr4an8uB+SB6ir9KlnsboNa?=
 =?us-ascii?Q?RWOvKkKtPgrYESam83Wl+4PI/PXWiDh2eIJZj70RtxECLHu4P0TaZGYpPp6z?=
 =?us-ascii?Q?RzRTHSU7gidG2KJpJvU4IQd4MeEjqrhwe/8De+BfLDChaaAaZuvJlCwJCqrf?=
 =?us-ascii?Q?EklX8M39idz2IAnqWSmL6foZjiESRMe8TQvAiSBOR9jBVXvhJiHfFtBvFyeb?=
 =?us-ascii?Q?DfAaJlpFarTNLg5k7aZD0UziMFJ4oVr+BIbsJtwbGElDNK4ezdU7dIkYbrYr?=
 =?us-ascii?Q?0xdMc0DZt0UyJnX0f5wsOfMAWKfj//cTSaCwro2P59ur1kzFgle4t+ttOE3K?=
 =?us-ascii?Q?OFzkAMwiWq4g3uviq7ulpBUOu3FBTg3F2t7mjEKh+8728D9aq8uRmynuVwAZ?=
 =?us-ascii?Q?PW8Dxk7OwyLZpkmdYBeMuIFSA4YawR9WBt6RMWnQeej9a7wfO9W0LjM0s2hJ?=
 =?us-ascii?Q?QJM6y8a+SJ4E9TG5eLEiggLkalAknFBE4XWH41Ew8Ls6LieQN/qZFLT8WSN9?=
 =?us-ascii?Q?3trhMMm2F1DwzoLWUh3bhlArKRvkTE/YI2c7Sbav8l1FJzLosrSNlcmSBp4A?=
 =?us-ascii?Q?267Dp9OSWC8CQcEstdd90II7hDwj2pHHwx8ouR7cRHaIJE4HW5vrS0/2gKis?=
 =?us-ascii?Q?ApV3wz5zh2oJ+TiBg54TwlsCTPMBSC6pSFDlhNfBkMWruzhnm4S3bVSlxTaU?=
 =?us-ascii?Q?jdd4n4TpT2GQOtt/EojzNSYfPVhir8+2bt6xa880Nm9mCACht4rRCYENBdf/?=
 =?us-ascii?Q?9PJrkEA8JqpfHu+Q7h/TOoV8CdQHn+GTa+WDfzj0igOrW4gJQN/CR/FXKBdU?=
 =?us-ascii?Q?POwDDRYuOvL8ux+EQNC0SB/TPaLHQ7bm7XD+f+SoeizOI8WoaBte/0t6SlpD?=
 =?us-ascii?Q?Y8Zgtj1FK+08uyCxKkZjK1vrCBEjlLe7/mpZ9tYTI7HaXBrLESuSngLP5t0e?=
 =?us-ascii?Q?rrxYv4cDHWyn3tCOQd/7jjxqCy3E0bsg8BrOkear7YLzg/Omhj/lG+rtTu40?=
 =?us-ascii?Q?V568Yz8LAoYWKRLou6BHEOsDWrZ5TMcPFYgIJHVA9syY6P1r+1sHuC6dOA9F?=
 =?us-ascii?Q?ATR9EDbHJnPJYKGCTPNK72LfmuAEhlY3OXgETMdcdYHJPsBt3x1Dt4CK5Jk2?=
 =?us-ascii?Q?VfZksGyhI6Cnx2Spo8Zd7QnzRDgRckrlqLAYdLZb47amHlBVZoUGKYWzRkYy?=
 =?us-ascii?Q?naIZUGNlp1IYgVIC2H/hRZkBMBG5kO0SP7KwES4t4ZIjlumnurmotyCGoT1Z?=
 =?us-ascii?Q?81AssVEqkCsfCJ+9J54WOTtAJmDE7QsgXQlc05HrNnKAUOAiFoSmw9N9YCdy?=
 =?us-ascii?Q?qYugq9iOemhEc6ZkAQG9hU9hax8ggW0KbtFbKsXD+H34vjbv0BQyUoLlE64F?=
 =?us-ascii?Q?5jyynm7F7g4dgz1bAnEYgFoEgkKxlvT8Bnw2Vz+G?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rY4kEsigKB15Zv3FptbUYtyiMETa2t5Akvf7lTc45wgJIiOAEMj+Z5ze0NCcmQlDckZqoAcXuAMN4pZqRqpPQf1bmLtaUqML+qGY5Pkjs8OLI8f15IIasBS/HDncv5PmPz41DVdkV2eaLZasf5ou7bLd3uD+RqeI8YzlcaIHbSDqqwqFVQlPsukhCat4SYeS394JdIe0ZasKdqXcPEvINn0jcvS2r9HBlT0V4DUryPxYoKdNXliFI6lLMxRHWEJv56B41qHLzICsZ1fWQnvsSWKIrl+E31W87wWH7g9AM2oLMtRvCKaX8M+nyHeuWsqLTfBS/w9QOw8uIZXJBfmGqK45MN5l1IWBw15BxoLPCEM2+ql5pb3b80XFpPa7FOpuX/8+m+OurNPh1edzQ+yj/i1AoTJIZS632acYcAVi6cw/qcme5zL4t4x73RH43lIMEUe5urURUjnvzX07S3s9Jr+iXw6Sl5NEEe3gWIdCh3+taU1x5EJZbJf0dApByx/maSDvpiBIY7LUDkYqK11P/RcldYvPHtqCMuit5PfV8Ehkhdq2/0pcoG8iJN/GeLUoYRJuKbDpJIyTrEiRp0zNRJZJYifVyF2FuUFDunKlbXM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e294e95d-ead0-45dc-abb0-08ddf748707d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 06:47:45.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ez6+7ly6DQjcZiI+48hUwWpBOYGRQUeuidFQxTA2Dyz+K4c2OiyC+QmuqRANpoFxDqBslVWQvX1/bwqvZZorng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509190060
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68ccfcaf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ZkBYrEZaL4WzJX-zIJ4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-GUID: S-xrKgo8NQpeCyrYRcmaFQ6srkMY3XiM
X-Proofpoint-ORIG-GUID: S-xrKgo8NQpeCyrYRcmaFQ6srkMY3XiM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfXzIiZHact+kFe
 J2AI7NPaV5rM4qHaN3o2hZ8do2I5jieN2iIxDd+RayJLHaM+QCKTYiE8wHxB/Q5JUmf/2SmbFIT
 WJoAFV4l0L2zr73j8hy/LFNNo5sxDX07t5eFhL9ADRpZfG45Hvm36jG9ehmvUO8n6Ma7AE62HyH
 tA/Bc28awOYA6TKQ2kcx4r83FHukjB6efCzZvDtsJAEWU1dYjwSBJuNeMvnL4N04DIlkY9jM3kS
 9ckKf2rMueUL0tXmRDMj9bSBEG1bKJCSq3y/pTbF5Czc48uMN0HX7Ez1RwIhfFMVD92DK0zDrIq
 6XgBEzQdeBt+Cmdm0s/nTqanM84Gmnuc0SXkCcslhOB/vkj47gvE/UCS5CUVhXcG2nNsNpt8GpX
 PZ5/CVjxF+7goeNTDRw2kDuRWPHCJg==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C142610000E
X-Stat-Signature: px1am713udir6gm6e1ja1z9bk71jqnj9
X-HE-Tag: 1758264501-253753
X-HE-Meta: U2FsdGVkX183K4uFWpAMSJ3Qwisa0nMQ+BTqPYG4N483oynmcbewiwckovNrz7uiqp7sq4TGExKVOTO4Qk9RmqUf/aPh1xzS7DJb8bynAFszpbHs/BsPnEg8GiaD0nTqkSepeXNnJzWG3oqmaXjdz/uLtPLghYiBpLolIfjVcOxy9n5EsL/MiP7dXc7SFpfI2zATM+xDSMcLgCXaud15ukc8zkfLIciegeCWH8PnEsEdw6javM339zi/dQrdaf+i+57jxe/CkXIlc+Rt4Vaj7ed5SjlkP/53y7uGv64M0sGJ8MNURZ/dCCj8tg7Dxp1E8PybmlUKyijJn8ChAMFKpqz11MTGcencv3353k97gz5Kqlx4wGYMZ9zyxnrW9h7QkqNsxnOwa/9K2SBkhMDjX2hHsiWBIsCdve8Dw9rANQCT0VcQPcxXkeaUsBsTpmvXscb/7KDKOwOq6voHROaOhd5Haqtk22FEQKu3q6A8I9ISWdi/ALyPleKJLqr3V6hXNSoiW/k0J0cDkT4PCXtR0rB323FvaTYMeSU3GoEdWrzC3Pmrgwag7N4HP38R7NBXFBzFvsff4qpfLwy7tJkrV3wy3dXI6YfXJTWgmlhsFeWZ7ttw1WdeZ7oOY0qasBy7VU+4q2ffonV8H0+vb0dutEpkhXJ62gtN8J48p5FyJpicSFMVfHRKcDfB0+vivmeuS2+FruFubOEhXm3Y4Hj6hhBRUsyUBucbgv7i+yS/D0Ye622dW1hDgXzibk5JR/Cw1cbKY/mPQVKyLRogkdzsKJ9OW56wO/wwTNanudCUQyBJ2AmNMPsJaf0I1RLuFkQlfOmHvUwqk/L+ExgYQMqVIru+DfmsPapJbMSpedQZR60+CrNmTUU/MEfuT01H6VZJ7wNTnXnD8FUXC0+glZWzAmJYYExGvY8ojAV2jm76eUQrzTcrB6P1QKQ2re7LlqN0SgrbKSZqOoph6QfUjrB
 QWk54bSF
 c+NSBSrysu+0uVgiwcYlGST/J/dt9KOUbOfDRmWXaEBWxXIEa39LL/fCx/LwsMtWniPcKiFQLyTHFTg1SsPIycwGmgYZoNEqTC2fvSipSERD+26EW2YoY0WBz23lx0XUXEnk9wYBqOURkblbn49F62R5QRFXeM3HW2fNRhfoMVWbxv7pywYjGWdD9ZL7WppSsNIKmf/akTQj1LJxA7qRnHu1GvfnzoFUp5RCAAACKsaxXnNCfY7vo7lI1qez8yMOz07MbJ158SwQYPzrDGKPrp+oA6HLLHWH4EJCIYUUf9tu1Mvlm5pB+8qVE4cSUerOR9M/7JqqqddluOX2wuNeptTCT5rUwQxG8AfoCtJ5KvRdpZOG/ujblJRs0a6frUEf15w/rO3ImA6adqkfF35xnMS+ZgPx33PNuASGcjBVK3TZxWjlM7xTlNlarTC8FNr7wAsydABo0TI+ZOgmLuCffUzS57x4K04vXZ1wvmyGRZpfSOVlzSAE1V0tpe32PtprCqpM75jeG8QkhpsBDwruUFtonJ0e+tsFN5PBF8PzjGS+wP71jl0vcphfnMEAioAgMdPiYLV0RwtVqig7EMlB2Xstve4mMzl+oHvIXSju2AtoX0AXzlao70eZbAE9QlgXww4EiiHWKovogxSIMD1oJY+3jbg3XvfKy9ZCGrb4KLK5gh4EO96EL2/7inLqdP9kAdRgmtKgVx0/87j0tzWYnoPadYgJbeUdMWT3UC/GiNMwKJgp42nUbqaomU63EpWr4nLPHwXKLHEnUGqbMQ1RrHU/tNzIAzGx3uVj4adthSSb1uuE4ALEmQPQP+M7VYtPIAG/q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:09:34AM +0200, Vlastimil Babka wrote:
> On 9/17/25 16:14, Vlastimil Babka wrote:
> > On 9/17/25 15:34, Harry Yoo wrote:
> >> On Wed, Sep 17, 2025 at 03:21:31PM +0200, Vlastimil Babka wrote:
> >>> On 9/17/25 15:07, Harry Yoo wrote:
> >>> > On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
> >>> >> On 9/17/25 13:32, Harry Yoo wrote:
> >>> >> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
> >>> >> >> On 9/17/25 10:30, Harry Yoo wrote:
> >>> >> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
> >>> >> >> >> +				sfw->skip = true;
> >>> >> >> >> +				continue;
> >>> >> >> >> +			}
> >>> >> >> >>
> >>> >> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
> >>> >> >> >> +			sfw->skip = false;
> >>> >> >> >> +			sfw->s = s;
> >>> >> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
> >>> >> >> >> +			flushed = true;
> >>> >> >> >> +		}
> >>> >> >> >> +
> >>> >> >> >> +		for_each_online_cpu(cpu) {
> >>> >> >> >> +			sfw = &per_cpu(slub_flush, cpu);
> >>> >> >> >> +			if (sfw->skip)
> >>> >> >> >> +				continue;
> >>> >> >> >> +			flush_work(&sfw->work);
> >>> >> >> >> +		}
> >>> >> >> >> +
> >>> >> >> >> +		mutex_unlock(&flush_lock);
> >>> >> >> >> +	}
> >>> >> >> >> +
> >>> >> >> >> +	mutex_unlock(&slab_mutex);
> >>> >> >> >> +	cpus_read_unlock();
> >>> >> >> >> +
> >>> >> >> >> +	if (flushed)
> >>> >> >> >> +		rcu_barrier();
> >>> >> >> > 
> >>> >> >> > I think we need to call rcu_barrier() even if flushed == false?
> >>> >> >> > 
> >>> >> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
> >>> >> >> > be processed before flush_all_rcu_sheaves() is called, and
> >>> >> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
> >>> >> >> > so flushed == false but the rcu callback isn't processed yet
> >>> >> >> > by the end of the function?
> >>> >> >> > 
> >>> >> >> > That sounds like a very unlikely to happen in a realistic scenario,
> >>> >> >> > but still possible...
> >>> >> >> 
> >>> >> >> Yes also good point, will flush unconditionally.
> >>> >> >> 
> >>> >> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
> >>> >> >> local_unlock().
> >>> >> >>
> >>> >> >> So we don't end up seeing a NULL pcs->rcu_free in
> >>> >> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
> >>> >> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
> >>> >> > 
> >>> >> > Makes sense to me.
> >>> > 
> >>> > Wait, I'm confused.
> >>> > 
> >>> > I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
> >>> > only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
> >>> > the object X to be freed before kvfree_rcu_barrier() returns?
> >>> 
> >>> Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
> >>> the rcu_sheaf fully and thus without submitting it to call_rcu(), then
> >>> migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
> >>> unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
> >>> kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
> >>> up the rcu_sheaf fully and is about to call_rcu() on it. And since that
> >>> sheaf also contains the object X, we should make sure that is flushed.
> >> 
> >> I was going to say "but we queue and wait for the flushing work to
> >> complete, so the sheaf containing object X should be flushed?"
> >> 
> >> But nah, that's true only if we see pcs->rcu_free != NULL in
> >> flush_all_rcu_sheaves().
> >> 
> >> You are right...
> >> 
> >> Hmm, maybe it's simpler to fix this by never skipping queueing the work
> >> even when pcs->rcu_sheaf == NULL?
> > 
> > I guess it's simpler, yeah.
> 
> So what about this? The unconditional queueing should cover all races with
> __kfree_rcu_sheaf() so there's just unconditional rcu_barrier() in the end.
> 
> From 0722b29fa1625b31c05d659d1d988ec882247b38 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 3 Sep 2025 14:59:46 +0200
> Subject: [PATCH] slab: add sheaf support for batching kfree_rcu() operations
> 
> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> addition to main and spare sheaves.
> 
> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> the sheaf is detached and submitted to call_rcu() with a handler that
> will try to put it in the barn, or flush to slab pages using bulk free,
> when the barn is full. Then a new empty sheaf must be obtained to put
> more objects there.
> 
> It's possible that no free sheaves are available to use for a new
> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> kfree_rcu() implementation.
> 
> Expected advantages:
> - batching the kfree_rcu() operations, that could eventually replace the
>   existing batching
> - sheaves can be reused for allocations via barn instead of being
>   flushed to slabs, which is more efficient
>   - this includes cases where only some cpus are allowed to process rcu
>     callbacks (Android)
> 
> Possible disadvantage:
> - objects might be waiting for more than their grace period (it is
>   determined by the last object freed into the sheaf), increasing memory
>   usage - but the existing batching does that too.
> 
> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> implementation favors smaller memory footprint over performance.
> 
> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> contexts where kfree_rcu() is called might not be compatible with taking
> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> spinlock - the current kfree_rcu() implementation avoids doing that.
> 
> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> that have them. This is not a cheap operation, but the barrier usage is
> rare - currently kmem_cache_destroy() or on module unload.
> 
> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> many had to fall back to the existing implementation.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

with a nit:

> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> +{
> +	struct slub_percpu_sheaves *pcs;
> +	struct slab_sheaf *rcu_sheaf;
> +
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		goto fail;
> +
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	if (unlikely(!pcs->rcu_free)) {
> +
> +		struct slab_sheaf *empty;
> +		struct node_barn *barn;
> +
> +		if (pcs->spare && pcs->spare->size == 0) {
> +			pcs->rcu_free = pcs->spare;
> +			pcs->spare = NULL;
> +			goto do_free;
> +		}
> +
> +		barn = get_barn(s);
> +
> +		empty = barn_get_empty_sheaf(barn);
> +
> +		if (empty) {
> +			pcs->rcu_free = empty;
> +			goto do_free;
> +		}
> +
> +		local_unlock(&s->cpu_sheaves->lock);
> +
> +		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
> +
> +		if (!empty)
> +			goto fail;
> +
> +		if (!local_trylock(&s->cpu_sheaves->lock)) {
> +			barn_put_empty_sheaf(barn, empty);
> +			goto fail;
> +		}
> +
> +		pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +		if (unlikely(pcs->rcu_free))
> +			barn_put_empty_sheaf(barn, empty);
> +		else
> +			pcs->rcu_free = empty;
> +	}
> +
> +do_free:
> +
> +	rcu_sheaf = pcs->rcu_free;
> +
> +	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
> +
> +	if (likely(rcu_sheaf->size < s->sheaf_capacity))
> +		rcu_sheaf = NULL;
> +	else
> +		pcs->rcu_free = NULL;
> +
> +	/*
> +	 * we flush before local_unlock to make sure a racing
> +	 * flush_all_rcu_sheaves() doesn't miss this sheaf
> +	 */
> +	if (rcu_sheaf)
> +		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);

nit: now we don't have to put this inside local_lock()~local_unlock()?

-- 
Cheers,
Harry / Hyeonggon

> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	stat(s, FREE_RCU_SHEAF);
> +	return true;
> +
> +fail:
> +	stat(s, FREE_RCU_SHEAF_FAIL);
> +	return false;
> +}


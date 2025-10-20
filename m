Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C80DCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 07:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE3F8E000D; Mon, 20 Oct 2025 03:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77188E0007; Mon, 20 Oct 2025 03:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F628E000D; Mon, 20 Oct 2025 03:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B10BA8E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:43:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D2391384C5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:43:52 +0000 (UTC)
X-FDA: 84017703504.05.E36C348
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5439180002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:43:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O+bBZdL/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RxJCsbKk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760946229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67KQR6HcS8r6GR9c5YspXsP20eI1G3avgh0as8YYwWE=;
	b=pmPaRSw2kIg0lGJR7AQ7BLoz3LbFPuAEoaioXysIsOoDpzA7LhSiSd5+izGylThFsTyOmL
	JKpqtEeKAR4y+PVuOqT6DvoGdOiZhvbtFWABscrdq7shQEr/99iDa3W53F5aVq0mWg/40x
	tkPFlCAnkM3hYqOoOyaXBxFeNvjhsts=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760946229; a=rsa-sha256;
	cv=pass;
	b=APCfUhTIgWFZ4Q8Vc+0Ig8z4Bw8EqYyEXykDv3+FzUobM1lf/vKtMyqys3TnvO0ax/X2w1
	gpWgYpTRZVngO4P2D+Tt8GwndN8PQQMxmcf/li2xTAVljAY9TmmcZKmJL9+L1mRbN6qHIV
	oPNO30IaBLifms3qFMH6tcXwKUW0rPA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O+bBZdL/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RxJCsbKk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59JMeLed031526;
	Mon, 20 Oct 2025 07:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=67KQR6HcS8r6GR9c5Y
	spXsP20eI1G3avgh0as8YYwWE=; b=O+bBZdL/WzbbxaYWo7+feauhqGuci3hKKM
	xtKw5K6+4d5XKw5WYCfyE0hlV/Il0dwJoXUSP0brv4oxIwEuoYtnK0bSMt40l1IJ
	okWF5JO0+0/WrMjoiO1FMe2AhHrZtZ+JIPdtsYrT+s4C/lZbvwq/Ge6zDwfEb0sj
	IdV0fzFKeYc6DqQ1v6VvTyCXtlk1WTTUy5jQkdLgeemmdn2Gpc1Jj8b8Y8CCs7SR
	MTWvLrk9Y2bK75EIHAsFCi0u401u74/uILyn1pRavnRW6pVkDvTg7dm1HbgwzSyd
	2eRpERo76aEQizsKaVsVOw1JJ7FYI4TBoMk+b8QEfJ5G7zpli3mg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3071r4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 07:43:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59K7P2me007498;
	Mon, 20 Oct 2025 07:43:43 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011017.outbound.protection.outlook.com [52.101.57.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bap4xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 07:43:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5LED/eq7lcwXJBdmI0vxouCFlpdZSPDvP+0oGIAGSKxPqAL17a1+WGygA2XQx8rG93A0h8WwSTy8GioeP3bgFmr4dKUxFGtTrAFspZtUhhmlPW7SXRvHL7Ps+9AE02s12NGtjQO9KeArcIQSQu02V99BH+EuLjYtWVLTwraAOZFNI0GGyMcfUBZQbWt+p72oRuXAyQHKMp1AhFuzitSOgLIqrx9ZgRyOEIpekXGPcWQAr/rpXJNwc3u/TOKzTTc86nUCpXRYArkQ5uhqre/pqoQPRduP0bube/DSV8SuGMcqpQ9aUu1hmul57iJe9cwoPxgPQxz2jX4ZJ6ez04Y6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67KQR6HcS8r6GR9c5YspXsP20eI1G3avgh0as8YYwWE=;
 b=zB/0CfbwIh1IROR0XTztL0ldRurdu3Rmfw+QXyOQt/TjYWEKrfT6FHHyR8DcoasW34mM+T9Ys3gzEpeRDL9i2H7v5F4fE7koXS9LESXlENDUt5onlYoTaWVniG8mG3ixHubZIisqYLQK7Q4NXNptjK8tnE23kDgY1mGpvanvCoUBxkQuIKUW2KtNcAVUa8Yk/gWp5evlqGjImtss79Lch4PJCQUMryTaJmmpag9m25kf3lKD4e99Ur6z9JNEdDG6ofL7zAzHkEpj8fpFXZuTSeqrIkNrKf6v5NzEHhrE/w6JUGBM/gdI6h0yfooDJAZZ6v5Itj7CFl7KlQaFTVYG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67KQR6HcS8r6GR9c5YspXsP20eI1G3avgh0as8YYwWE=;
 b=RxJCsbKkF000RSUfi/1iBtZvl41GuNET+1bmdlyE2MUL95fHOElarlDmQ146NMP7AWbRkgBwyfGAPkUMECyP1GCLPi7BzAT/ssRbJQtwgT65Ek7jAIwJEo23QxLU0vQd5h8/HbkFdiwxe0pOJ1/wAFKoYfwz/npk4mSic24dIbQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7834.namprd10.prod.outlook.com (2603:10b6:610:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 07:43:40 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 07:43:40 +0000
Date: Mon, 20 Oct 2025 16:43:33 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
Message-ID: <aPXoJWM8oC-P1a0q@hyeyoo>
References: <20251019072509.9488-2-harry.yoo@oracle.com>
 <20251019220737.1431-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019220737.1431-1-sj@kernel.org>
X-ClientProxiedBy: SL2P216CA0119.KORP216.PROD.OUTLOOK.COM (2603:1096:101::16)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eca69c2-7cf1-47d5-20bd-08de0fac6286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f924MwJiIHXYguT7hyo/owYuegoLx9Rxg9c2b0qTdLiVOPqXPuOntYMIPocy?=
 =?us-ascii?Q?dtM1KUA4flc/gNt/CVfskYL+w3NMKrfeJvuicvoo2x0QwJxYgk1rkLTC6KIj?=
 =?us-ascii?Q?L8BcsWQ57AFj0GJaIzMNwDTmSaLOkJs3nLJ3vYj4nSEndbmw/qz/OlMyT2L3?=
 =?us-ascii?Q?RWx/MNw2U42JgqOSte+YLm6+/QLduwI+ufK/Scn3z8iszjT2fgAHpSt2yJDV?=
 =?us-ascii?Q?ORZ3fS2n9FM6KVqAlRRVBzaU+ayO5mJV65rZ6OkP61BDbL+//NoVjFApRitV?=
 =?us-ascii?Q?HCVTWAkpmJc43FAZ9G4Nb9KGrHceLjU+g6squNovvRKn6roxP0DOnWoJBlf3?=
 =?us-ascii?Q?HE21mLyeIqR3qqTnkHpEcN6iHcSbUtyCBpOIjwYYaucuCvYiIkrbiF6gvuUo?=
 =?us-ascii?Q?T33MLJGMCfTtT9hoiCpGtKoUU4qHQl24kU+L8amjV5MXin0QD7F8rayBU1Pu?=
 =?us-ascii?Q?FSMHhv3sBIrnOs1olmabkdW+jJkinzEShBEEng8vF5Amu3x9oTaEC8kuXTRK?=
 =?us-ascii?Q?BDmEVzMdSm617BSO1o1a9ZeJrL0cR0gHovwgKbMQ7STbi3YpuoQxsNYVQ7ih?=
 =?us-ascii?Q?3PLOHZZwr7kOsLL0baBSHArcAf+7xZxf+fvsrsfaRwXRcdRipCYcIuGZXU3y?=
 =?us-ascii?Q?h6oKieSYs66A0enkKZRbXBmrOyzZiqIdoZo/KDzpSEteKIw2ezMFtAMGU/L+?=
 =?us-ascii?Q?tfW8pmHRBkyjySDes50SEivxLSxkdHmKOYFVp5ZlBmDWYj9sAbJSNIiCgNzV?=
 =?us-ascii?Q?w7b7FouCOrSJ66SuAbpyo+aPK8T80ETSfUCGcDpsbmZQQqq4U545XNe4IJE2?=
 =?us-ascii?Q?kvlJaVoQMrdEMG0XV4EC0Kn44nMRQ29FvPUBX8TW0hSnlhPxq/t9ZcoyrGRq?=
 =?us-ascii?Q?8Z/RjRVQLVp9zJJKt0MDpxxipuMFScQRkx6vnxwcXbWd7ESSSURdkwI1fHAi?=
 =?us-ascii?Q?CT86SMkD76/4+pCM6bFZhtbKO9zNogLIon3abAtc3mOC7K06TyOzhzBUHBJp?=
 =?us-ascii?Q?flXuiPueGn764z2EZQ/FpQdKtAJXK3PzsuEUuK+GzhE9O2xyPnFPisxU3ekr?=
 =?us-ascii?Q?tDPPI4Kvh+ne+55U/eQm4yK3mBuhyCm2cCXTF/LNu33l84sayC4DgZIWogt6?=
 =?us-ascii?Q?kncNqAL4X2UlmpQr2UTluPP6twqrEGH+dVNLTBVWpNGa9z1oMT04l1WEpxWd?=
 =?us-ascii?Q?FkLZd4AvRCeFF/jfSTzlkDWf4z+Y4cX3YeN16jUxXNqNr/n5/WkCk0gGGgDH?=
 =?us-ascii?Q?tqyUwcvEZx8LaBhaMa/dyFTZ0YTsLz+GQCpgmRCaT1P/o4pcWO/Rt516wIpo?=
 =?us-ascii?Q?0O/vshlZqgC0/oPXE9b733sb5AVhB18aKIbCAQkgYjJBLNkHoEhE1P0330Iu?=
 =?us-ascii?Q?DL94RHSKAdaUMxFa6m0/NW6IdO9bwcgUvTWGiiOgQBmZpSDoSH5qut08436h?=
 =?us-ascii?Q?N0qxzNVrj5s+zvDPmV4KtgteMg5s+cc+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H8/lrku1AjLYh1p+ecRO10v3VrbRazgX2aJYI8iVDBV/fbirOEg5/E2gvcbf?=
 =?us-ascii?Q?7+CDzKX0g2HK/0wPAK8JTIP5XJ8OOzD7CwSbRPvEgYpj0nI0wBFhRoGm3anX?=
 =?us-ascii?Q?EV3Ans+yr3l0OMphXdZIB5arjtpwy7EcxaMvEJwjc1G7uSXUQDsj3ng8FTIy?=
 =?us-ascii?Q?cX9az8T88CtSEGAyUR/iOkdOSI4G5lSqsElAhRyFWpGWByFoIA37B40gT1V0?=
 =?us-ascii?Q?wl+946VzD+r283cRmYXIlJYunltyC5Di2PvN3YheUuAa7pWpxC8xe5Ps3zYH?=
 =?us-ascii?Q?MhyjHOZ7h4bItrJKW6vUXys/hDK8u3Pv4a0sdtWj/sAtU4DPlO/scPnz3KUR?=
 =?us-ascii?Q?bg+/twkCZQKt0uZD7jQo3C/6efshCRfG1XXWfsCCZoVc6ird5rdRitIsAmFb?=
 =?us-ascii?Q?+ZT0FsSyYa3lxhFerZnQsunYm++SnLDYlwGmnSA3mt5EGgdLenb/9i2bdb2a?=
 =?us-ascii?Q?KVMIfpAupWpynEiRYPADcpQ0NyyCzunJzHwsfDdhl+QLqts2PH0BhgP4PPhR?=
 =?us-ascii?Q?pARrZuRzK5OB6MGklD1rO3fZO1QxCjir/oebHQq6g2rD456CLTImm3hofKQe?=
 =?us-ascii?Q?UoqAAj6UXepMakabndMz4cUgp3DzCh3/4ltW3ffUc1Cmk3uM6oGdDypZqlX+?=
 =?us-ascii?Q?sJDcAyf1qAw51AXYD11unrhEmNEh2UE93gKaw8XdWtE/RDvdK0mbXunmzs5W?=
 =?us-ascii?Q?glNROFP3R3o3Y3wlRwK+hosOIpVVkE6Rmv+f8YIMFjkZ5KKm8cJgjYRChwJl?=
 =?us-ascii?Q?05Sz2e47ybiqd/HO6Do8esrsWHP+dkNTMdFkrZvgLOysAfxVPHn8lFtvHh/y?=
 =?us-ascii?Q?B46iNjDc7+6OELymPvdmSlFDr8rH8u1ezZSqbXTNvXjmkbPOz8e2ck9XkmPl?=
 =?us-ascii?Q?mMaoUMZKPqlCH7tTNIktozIYSfYl9xFMeudtSUUhEcpQU+5gn9SEibIA365g?=
 =?us-ascii?Q?DSTqCpm9HqTZH73dDJpbnkLmmm6O+Tf/Vh84iUn8WjTvWq85CZ5TfeIzACVt?=
 =?us-ascii?Q?y5QgpyMU5C6F5ev7VsD4Dj3WKq9g9JX83oMBThaG7i5Yd0vYBYpAAc3a80mU?=
 =?us-ascii?Q?oFJuyGTz7lcP7joLm9BB6fEYmxMDWmc974qUMxUxawJ8RU7qr7eHXjOSnyTY?=
 =?us-ascii?Q?F6nmvX75esPqLltvnRak13ySRLf+ZPO19uXQqaJj9JxRUbf7+LnTESkH2/J+?=
 =?us-ascii?Q?cWmCq32tnoHoPxigfVSeos4OLluBNPOqnJXjKel7hVvMYMWCH4xPtXgX24C4?=
 =?us-ascii?Q?OWAoKEKOhPtGRp9E+1dL9ZyzMczC5ga4pwuKg6wxti01tpwqgDHQ1r7YOBkG?=
 =?us-ascii?Q?et+UE68UVywEQ4LcLIa9OHB62oMtoPSM368E8TGaKiMFyYZGCnNhE/dDkEr2?=
 =?us-ascii?Q?j04MogjhK1e+NcQLfXwnUMz+rYrF7+uBTvm9ZlO7gulh69qs9kjylF1sf5Y0?=
 =?us-ascii?Q?3jfdJqPwL7sdFKdIL5mk6hObbtuHcFu0KdPqKUgaaG7Vq0QrXqee3P1yyzwf?=
 =?us-ascii?Q?HGfcaGEENJ9lQ+HGpsHli4PL1oQdpF5DaHXfp3LzZ+jc85g+n1dJRpPUP6tZ?=
 =?us-ascii?Q?hZ+cbPLogWUnLkOdCZ1+nbQfnQcDaPxYqcIomxda?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dfek/Nsx+DLJr5j30QBmU7eHM41Cgyya0zlwMiEMPg9JAfq0sw0jmsJdaDpIfzKv99iMck72K2G8OoFjeZDSh+aNZAVHBKCNI4VSmGs4hRi85A7HVDHn/UwUCijED/SLQX0AY23fWkI5CkrAv6bMFgo9cs6FuJepqvpPohRjHKm4ioInxnixoscGElU42S44FNCDjw+0TgE5wIrHnKTgMBd0GKAKwX8GO+L3r8eUOECnBF54TBDtdqo/BzbrvSAPwGoLTl/oAab0nkkhiBvdXeVZf1oqt3Ant3AIAxh7q33t/EzqY26+qX5DE92KgBEk3kiMclaP/LALFjDih3PANQXyu974FQgupAfMTTLO//K318+5izRurH/IfQvf6TNHX9MKN9YZP/RnJvJcOppzpoG8SAbT1LUv5rruUshik7Frb27puGQpofcqQsqN6I3kXXIAhK+LPwG3MDikMr/t8dytXY6Qf4iOEtb6PZbujOpRyxzGhz0/OYWdYDDbomNNhGopFYWbJA2KJOCcxs7K6l6KMit0rgAjgSE8D2Ph2WOjB7cdTOeKMIwsX98ZeSTXQsgoRBB/irqtcJ2fkoJaXzAI5UOKtdTPwKSvYoB9Bqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eca69c2-7cf1-47d5-20bd-08de0fac6286
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 07:43:39.8483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5znHvQgWpgYuNLr6KExBRchztlSkZJr3qkam9O83PcxxgnnE/P3FRcx18Hiv7nL8wmSCkDmqQsi4YIgZD2O/Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200061
X-Proofpoint-ORIG-GUID: I2NTlL2t_hW6GW1-CXpib9tiOX8zmg6o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX96KOkCwvb6Jb
 XNjr1EY5aLW0QAPCKQWSwVhKvEIhZ8q4U4xzqW0sVNvWklS8RtERVJKswgsbwlVWW92spmbw/1i
 Mtja5bJ/ClezzYwFtmkgtpJxxNH+pGWwlgpuljdko5+RQhVYqBqMJ2oAqqR2/aJp86MbHQ4/spi
 rm6PqFNGhJZHtLI/0bU9ZQ5G8VVB9RPxkXAsNNwz7PODiJ8YZhEooPzwiBlTJ2VJmnAPkngRHz8
 ryprMe4dhRxMJRYgP1Pn2tCvw+ep0ZNIhYc8WBivp/WVMuZluNQByiIeo+C4GzUutvWPPE60/6j
 9t1GX5NZpya2WMdMTDUebQfZ8eqfE4QEX37QyqCuc47F7ApYa2C+jyG2n3Pk/wXcJDBQvMe+zMg
 etsrfvksKB+MiXZCHIOoYncAjLE+xg==
X-Proofpoint-GUID: I2NTlL2t_hW6GW1-CXpib9tiOX8zmg6o
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f5e82f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=BJ4KLsfvjJ38_jsFxG8A:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Queue-Id: E5439180002
X-Rspamd-Server: rspam02
X-Stat-Signature: szj7sytej41wydtj88tejshd7y9w54w1
X-HE-Tag: 1760946228-797050
X-HE-Meta: U2FsdGVkX1/Vfb6dOkgXxIiYtmeMLhIOGnTi3VvgLXnzNZmYbWKoPGhXcgj17Q/TZKEuc6kewXnU2B0cc/KIcMze1StBZRHNPpIWU8h3Iliid/4QXdWepYIgZjS24DTBJpS+sN0iZXRmE2jqdw+K4ecXMnGy2ESxyrb4RCHj+Kja1NsORZYteYz17pJOXa61wr0oyTkGreITOTloRM8V0Xk2QxxGlljvbIErdWUz3A7UHgbl91U2J7rt9t2Vl0frGIifiCt895zYo+FBomT+HEmorInxAJEiYJjToJnVUilEOsN9QcL+54w/cKZJPCs7ihymMUjJPRmh+UHw7ZSvTJzduDuKtrUovsdm2higgNb49aiGQLqOm/vEm9TkTNHlrEQOW7sHgOFWgmjw3BvmEvVIpOhDilOSNTHH5C+ifJgMNHtThcFN9Op4SHfmFpYKO74xWec3LgQBCWs2sbFzd4KIotWtz1bGc4XJBYGwpDkw/MuOKG++Xv5ek/rJeaqjYzycgTPLsii5BhzVSnocRdWM5WiHvJH2XTwxUbq4W4+hRLk+l/KAndBcuHJk4iR+HOh+w2BhbzISi6CFx3J9C2y8b9lNBq6oPo4zHMglrUc/vX55UBM6JDu1okhA3K43I0u6AFWiWl8YTcRNGEP/Is3Crp2zKlPIq1sGq+GDpB2MNf+dmndYjZ1+Jbo+DmyygO7qc1wag0u0H3U5XVT+5ijhlFhruXHIlClyegMTbH5xZ6XOSO87oi4ib1qZNzsdU73LdFvSxCAlYw5/oHgzSCR6aPe4O9ZkEeekn/1n1vgUxf/2gnEpy1fBJIZBzZ3p3aFZSa372/Dx3L5cVTqodKj8p7FC04us83ZdbltvnXlU+vu3ao13oKoNDEA79haADLLReIW29MQGJh5V8c1vJqb0jcD6SZfDa2Q8CziZTtqSzTCaDdHSGdqUK/L109l/ccPynV/XAcI8AUCIQxu
 I22fCegs
 W7/s6XdEcggsxzLNgRMYJucBZmSGnYyUDTUMgsf4u+vBgoE4XkeeSPfnNQ0lThmICOM3+tcXd9T+ZjKxPTezgStj7hP2jpFpequJRIXrRkID1ZqHWL/QOXVY5f1dzCCm6oSw3mX/HuXb0ySlmWpB/ltTSJQRl2rRVgS1/MbcmvhQDbQZpc/vDQne76skjFlX6dFwwbQSeeQHG4cDCGOjcriS5XRMxBmnG6FUv2SxByIp3/XGcwltfhKAhSJmPGFaEnk9fi+lb2TsfzziM5dIPKWYbLWjCW/ej5OPvVplERzVNsDgB1UBC7FMo9WwkkhEwWdpujmA++rJEN7tPENLLyD82elVdbDzCpwc8etk7gxDb02ae89Ai88wkUhB22gUWLWMUP+sMaSFZDvk7AcfW1d2ZwWyouyLcqnR+vhZa1jUv8lqZF/KK2z/w5KWnc1YAHnOcRtNPXSd5yQyMGWwaWK57euLMKOl1mtyG0JzNbmghZBIfSiFVJYqOzaIAtaWqAgXDesBGRGGk7I6NwQAvnhRVL77wO5rtJMZBXGkUaFNTXqZmFtBYzrkNHyxNoejEYagLA/0/Jjp5pGIFmqbrc0gt7Lnl8l4mnW48tXHMtuNfWFn56Rr+DiEnOOA8fKX+LMYbeRQI9OHu4dYB8D+XqyICI53B9bKQNWAZQ0yU0Rp7GpA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 03:07:36PM -0700, SeongJae Park wrote:
> On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
> 
> > Since include/linux/pgtable.h is already listed in the MM CORE section,
> > add it to the section as well to keep it maintained by the appropriate
> > maintainers.
> > 
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Acked-by: SeongJae Park <sj@kernel.org>

Thanks!

> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 46126ce2f968..dedb9525c2bc 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
> >  F:	include/linux/mmu_notifier.h
> >  F:	include/linux/pagewalk.h
> >  F:	include/linux/pgtable.h
> > +F:	include/linux/pgalloc.h
> 
> Nit.  Should we alphabetically sort?

TBH I have no idea.

I thought only subsystem names should be alphabetically sorted?

> Thanks,
> SJ
> 
> [...]

-- 
Cheers,
Harry / Hyeonggon


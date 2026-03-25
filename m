Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53B2109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135566B0093; Wed, 25 Mar 2026 11:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E59C6B0096; Wed, 25 Mar 2026 11:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0666B00A4; Wed, 25 Mar 2026 11:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D79226B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:00:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C5B01409C2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:00:52 +0000 (UTC)
X-FDA: 84584897544.08.87E6135
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011043.outbound.protection.outlook.com [52.101.62.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D4064001F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:00:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mKLQk/EU";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Nk+j9Eb4mfwAzUfHvkygAASwTR1QqsXcMtRHUHo/8o=;
	b=AO1j3n2aV2bULEkwdRBh2pF5hARfoCKwceCSNpUXUkXvZ6Zuo9asEmhDN/XEjFW+HihK4T
	/t/JU11uIWvtMn+1FmJyHJCn6R39kkAIApmzBlY9GtO+Jq7e/xTbSegjXM7Nges9xs7B/t
	4lHuoEWTtz26CZyCJ5y3NHlTFafielk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774450849; a=rsa-sha256;
	cv=pass;
	b=ULDH4h5aslVlFnpvb4KZ14FXCJtSFdLHOuCRLc1kbycZcdTVoCrJApmZAivtDIie4CeTA9
	lO7PiAw+SJVtG2yjespG7l62jIUmKJmK73nEtEwwFVaQfUnfmC31MkfBripmzXV6TYb/HK
	SgR86beC0Tcvh5m6tJuv7/SbyEWOXUg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mKLQk/EU";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwOZNdp4OTxwXYeQiiSNpnU/DlpStk6/EM+xGKjkDt3t61IRKeqiL7M+FqWvXfbSI+Sb1Aih24bXmfWTTpaUZvZC0Ac5BKV1BHFgXAasDCHDgfjlxi79PRuc5jCBkgMc788D1PmihEAfcol4gblh9BQaW97Fv8McYAgkgDFnI5uXOE8xKSwkTlR10vQYIsjFRjNJ1WcZ4KrqAE1CH7UE8tV7HNEw1Us9/Dzw04Bm82uZFldx3PMeBAkSnK2JShdmxAF4Fb8jar8SSB8j5mXfMFAw1oouu1exQcGQkxHrlHUDv9+h6o+pecofON1GOrW2URqtZZ5dn0vSKhH+lh7muQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Nk+j9Eb4mfwAzUfHvkygAASwTR1QqsXcMtRHUHo/8o=;
 b=NLZQu5Zdenwz+Prpb2Itp1Y7nTKi/45ISN596lLh91W5EMpaHPVU1UghJFWJLmztVSDAP+eo87pK+m9J9KT5ME+3k5ZPhq3q4kQ/hRzbL5HR39cnU5/yPSxP7LSrbc0O0R7ePmrC1fxw257/wQ6iB6sSiSoEdxuAyLnd5DitouaNNdg3l1iaJhB7pZc1Bk4teFe8e7QKOOKOtrUUxwU2BEZkWZWGFlQCyyAC75osK2M+/MIg9GJNEhcVvLzFGUGT4ZX+G8CPnkrlqquFKW2MhxVq1fa9Y3AGUW4guZaBCyjRHkjLjJ1JzcwlaTG9p57JbMY/Q0phNSdaAnSZW/DpXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nk+j9Eb4mfwAzUfHvkygAASwTR1QqsXcMtRHUHo/8o=;
 b=mKLQk/EUYAL1v+hVP5KMgQTcSzmCpryEhfCNZRxPycBhAtPzNpfif6C7vAwWTpx3JVpPBHOEcupqmQtrgyj1A/0DwYB5PKjV79+8Q3/LJr98atQ+NlNoupmf7rxuDgbEf+rAeBPu6k5glTmTduag6eH7xP5000Jxpc0PSXkVhP3ZYiL0qU3/yT3cEBrwkRZjeCJqcP+rK0ZF17spGjTow9ccVOD5S12iZ5UhhGmXWLCEVLQyBELYSqlnRibNowWpnMIHmHcaYOLlKD+Rmbw4CSESU0UOkUoZOnoHkDk0w7MeK++6qwtilkdFd0c+MWVlZXn4j+cH6+26Uj5luLcvmg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Wed, 25 Mar 2026 15:00:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Wed, 25 Mar 2026
 15:00:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Wed, 25 Mar 2026 11:00:31 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <539EA481-9CA0-4B2A-B0B4-C254E34BA7EC@nvidia.com>
In-Reply-To: <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
 <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
 <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: a1692656-53a9-4c4d-43fa-08de8a7f4572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	G2+LnwlhciwJs2A4iGwuR24H0LWiNovbOUa2TSXH0xtyN3BVz5L4VrlTFCWUewhP4vsi3YvW06vsPCFMTl0GiobAQ8BS8MIAvxVXHli2bapkCJWyGJLRut8YQMZmMI9Tb85PV50t4NHCqGOX7g5lXsaCyH4KqhtV1f7E8kVLYnzwoSMAbJdtN9AYAEpsUW/oEr/MHR6hiCoLW7tf/fyzt8tt0RNE1gCKQe2n0eCrpI4YDyStdYLvqddCyr1I3j5P8vBZ2CCrsOJokDNJ49A4O65ghGCke76NJ6wkrc0mzUbYSfsdDGFoyjJfP5Dg4JEJj0Lobclh85jdlmIdFN6begWjkyIhydU2XY5eCRcQTrE01Izfm5HFY3/mTVLkMSr7AQ+mXCcroKe1AzuHUaT4BhgRstDytE8DwxppYVIp4y5pXEJADGiv0Z419xDbg2YWpNbgUT9JbqdMuOKBpE4cdtjtC8uRFUXjiVRbimECw4ISb97GECaEn19RjdWTw99RWxMmIFFpT4poi1ck8NObKTUX97A0N3lYIb3ELZvE3LbmJO95RD0l8WVb6vUXM34NucbNJ5orRtPUStKxMxgqbsOGpSoFMwLbnVTlG891uuHJI/W/+q7MmddK9XtX0xP3egFVsvymcO80XW/bc2Kc7NsrUuBNN6GbN/mB/YcpVA+0vmz6qNX/nLpmShJDUvD/mJpfMiN0Skhx7g07LTpsEs+BmEDB6bIjEl4mWp/B7gw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EoyfXI2ajdTwMxTQ2kvlJ7ljxKW5x7Pua6I4nh1yqrgpILBjEIylwk8qcrDS?=
 =?us-ascii?Q?lqCAjbQMktSG6BQ2PjXYmlWZ8BSoz5Uz8KI0sHKSvap6yhn9jLrucxrnJDEd?=
 =?us-ascii?Q?0ToUBYDXXf4yrSFKmfF4tvHTTAVBTJOmKl+El0K+e1xrmJ8VzaF4G8swwk7V?=
 =?us-ascii?Q?Lmisy0P/aN04we4kyAqfL2xh+zmOuAG8Pog0eEWfToyoMmswKsmFw5ud3T0w?=
 =?us-ascii?Q?wTkmbIaUoU/szM3BZfPkCgmidB1JP69ZDGeDrA9yboaHOyhPGZBKSgCYhjPy?=
 =?us-ascii?Q?zlmaLn3RXky8aKBfh/FCg55vF/iS1jXmeZJ4I4A1mu9RCKhtZzh92UXDlfaC?=
 =?us-ascii?Q?giTB/qiXnma4DfOL+LL0fKoEEByvs99lDhCUVGeksMrq0vuq0Y8Wubq1rQEY?=
 =?us-ascii?Q?JmdjkNxU0nP78L5r1BTLojKeek1SBhkBCagpAPdKuhb9dFIS4jkXi6dBPBNS?=
 =?us-ascii?Q?0HGRcOOxRks0VvCF9XWZvKsqBofzsUO8QGKsXRJqXNGpf1JEEijRIREokI28?=
 =?us-ascii?Q?Uv98QTsF56cggEMJdxHWWRAmvzwes+mg1NjKJUYwgvFn9f3zUxc4rt7j0Y22?=
 =?us-ascii?Q?lRYJxgeA5mp4vJIyxSDpxv28sPhYnO8AqRFXSLGyn5sizy/kbDqlu5b1OFOV?=
 =?us-ascii?Q?81P8M/1g35cNAfZ3fwNXCiIOotU8SVaJtLv3z6/8R+D9FbJQF6Q7GEgIgp/P?=
 =?us-ascii?Q?2bafP98p9W7uLJVcg0EUEFDZrRKQdRttX6BjhVCIaekvT7cwBmF4/YBrTcCO?=
 =?us-ascii?Q?m1gGHKw5U8EfoCKFIuMqQp+eEU64RR8dSyu0iAvbBqiHR/l/V8bFG9C9jvT+?=
 =?us-ascii?Q?/QkT3Lgy72RRdFqp1SrpTAmo0J8Go+Ic58eMXKkAvChRyV+drTcO7VTn0KjN?=
 =?us-ascii?Q?99qQVOvzMLO/LWnMj1jclstBrC9jYqPoZue9F3z3HWR5M/YEzhu9NH5fbBKU?=
 =?us-ascii?Q?WsxnK4irQF1vTq6/X6raEN624f4VBbLCivz4hA/EAlWvW9dRwMe0eQ7lwoL3?=
 =?us-ascii?Q?c5HJuxQWVrKkTpzIAo12EKkalRnROYOJUuGzVc+0vkFkNgmM3d6Q+saGde44?=
 =?us-ascii?Q?EeejPQme088pwpOAkj+WTgv5lcPbutbYhGTRdvf5qk5OGrFOSpMDPSBAPlfP?=
 =?us-ascii?Q?4oNrXaMo2pAojUstSJeXwAqtA0LFxHpnRNw5b5m7ZuUFNcpeCd3BHVghRrDK?=
 =?us-ascii?Q?PhN+7AE27uKPnDs4ueRFTHpH+IP8CSAn6rqbI/i68TjUVrvFx1C5TFL4epn/?=
 =?us-ascii?Q?nYUReSu8CRpXAGdaOecRscIjSp0jx8tp2MQi4XblnlB/qc8SeGjvhbgtUMWa?=
 =?us-ascii?Q?SZhZg6NXJK56Mkp664UMYzzg8esSSIy66bcBykBnlWcpT8sssrfAxfq32iBd?=
 =?us-ascii?Q?I1BGhnoDOgYCzQw58D4EIL9p5ktw8Q594NxIwEpu1JAZXlaTIaWneiq/f0+e?=
 =?us-ascii?Q?GBA8WUbqwPtDk4zMUTRzRdBP1gvjBq8lcJqZ6ACuQsgIwYrr2SrbVEtA/gOR?=
 =?us-ascii?Q?fn39J2KCEbt+F0Y9tS5tBtLq3oJcnNhMKRmuT8wHFZ8cerjnsIg3zok/Owg3?=
 =?us-ascii?Q?1tlaX1hqbnJ6QLRGAd76pVJ5/tKd9P0PejFkyFIW2yudO3Tw4VOIH11pNrrE?=
 =?us-ascii?Q?oLxN/QXLBDNwA/6D68tqyLQQbRXi5Mx7btmyFq3zq0g/fTqEtg0i33arJh3C?=
 =?us-ascii?Q?9gMSVaQaHJJKXSrSNFpHMT4g67De1LSmt+zQOuUStGoRsKsqT6MVqKpAHsp3?=
 =?us-ascii?Q?Q9YBuT3mxw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1692656-53a9-4c4d-43fa-08de8a7f4572
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 15:00:36.5208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZG5UqCsdo2TaTZ+1YqV2kKBkDJGUpa1xx01LQnRSvj0S4qOd8g+/D/CnA0Rkxr8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901
X-Rspamd-Queue-Id: 7D4064001F
X-Stat-Signature: ejrdxfq81a5ii8gf44un1mygac9ry8g5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774450849-139932
X-HE-Meta: U2FsdGVkX19XquiRXGY2rxodz42wwMCSGeDfMxoY1ehR++u0vMmIkRTzuY7n9V1g1SR6zC+ikcZVn+W38m6NSh6rVgPFDGrcE1kMPNOpPdwxBSw00v841fIk76xYgv/jyPPhlt1RUX61I0+3NjFNjRX/gSBP7bkeAXeivzxBAzztInk312UZ24+aESOCk8Ky8wox6S3S3SRARrRnfh1uF9wl7FxGLcD9/aV8XQAArVZXqxfksPA2Khf8cJTVnCy9SnOmPDqOgVmNN+j6Fx+rzbKs68fz5Ov+8Mb04MXhDhOAhupOTPywgptWL7m/Sp6uHLrbE9n+vafXx7op3uQqqRh6DnYDY9G4v6bkkPMS8I5I7wKrbJOB2PQNDZxnRqxLu7GD+OlRO2bpV4U9uPZC3AXpumGU45LS+pLe1nf3PhpJTEuHLMMX2rUV7HSnJb3i/RCQwb+M4tKjjafGGykefoD7AbyyuTtnbPqYmTfLHRoYRF4D4LA8Bh+6uGa4pZR+BKkq1i3Dlbbz69K0bO5zG3YVMgwk0nZm2jNfgwxqZKXAeiy3yO/EAyyl33DD2b/H+FzMaiPeFaYnC7tGBSeODD0LF4bTAr8XobojuOeE9+UpoGejsBd0G1rBXCg27ioRLFe1nYStHcJAFzCwRbjdcbD39KK9vthpKX15+8/AoGl9SAt7CpzMYqnBsKgrNAHvAjbza09VyYm0II50bAMgrjfIjl2Fk9xOCeUHY72c+/FHDjpc51GkWeaoKHnO5Pgwhn4JbiWTT7K1+eQkRCa2OMQJ6y7rtcejmr3fUgfVGMuvuuUjBV5kj6EWlKkUYjxE/7audoUJph+UiO38HtnJNm3ZqEEY2UvJ1fIMhSv0w4RwHvyhLKwTuEg0wvwacwp/1t0LDhCdBeRrVt9zOKB7hTVYZqWYdataNLa/8tvRKjmGRky619L/2nNwwDti0fZNdlfNqacjdlQvHijkfKj
 Yy5sTsmS
 J+1EJIsWIbR+HtCdWoa4i3sjDvcFyVP4DwTW9hORV1Ld6Bsa3vBAS+TYuWy5OHPEcNKXvIB5AcGVWhxgtxYPy4pl/GU+BqJQeol1lCS9Or+ByxyCotAFMBznBWG2273Y/S/NTe1b5jKzsaslFswZfXRPVsf0pyAC/bxv+z8v0ArTiqSs3S3v9Hue+M7o9jScQAoagdwnM5LSWgWN1+02ZqgymppUhbkpNZ7Ddps/sNqCLkFLwkEX7Og/X36l/6oTI+5xbL1Egl3efScc2Udc+g3H5TEfGnT9bwCJZT6BMMDj/WTzV5UHiYF5m2ow8g+AtXG3jAt4YcL81I4yIL0I9EDykL7BeYw8CnjAYH7mLXCQ2Ld8bf+p1b0wc2jmaRGMUmdz09tA03xV5ZsSIZvluQ0EQ6vnHwN1qdfaBe90mr7i4/BYAeo+RVEePZGWD37Bxtadi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Mar 2026, at 10:53, David Hildenbrand (Arm) wrote:

> On 3/25/26 15:21, Zi Yan wrote:
>> On 25 Mar 2026, at 7:04, Garg, Shivank wrote:
>>
>>> On 3/25/2026 2:55 PM, David Hildenbrand (Arm) wrote:
>>>>
>>>>
>>>> Isn't folio_change_private() part of the
>>>> folio_attach_private()/folio_detach_private() interface that has
>>>> completely different semantics?
>>>>
>>>> "The page must previously have had data attached and the data must be
>>>> detached before the folio will be freed."
>>>>
>>>> (btw, that comment should refer to pages)
>>>>
>>>> So I would not use folio_change_private(). An accidental
>>>> folio_attach_private() / folio_detach_private() would be rather undesired.
>>
>> Hi David,
>
> Hi,
>
>>
>> In terms of folio_change_private(), I did not think it is related to
>> folio_{attach,detach}_private(), since the latter change folio refcount during
>> the operation. If folio_change_private() is related to attach/detach,
>> I imagine it would check folio refcount before touches ->private. But
>> that is my interpretation.
>
> I mean, given that
>
> a) It's located in pagemap.h in between folio_attach_private() and
> folio_detach_private()
>
> b) It clearly states that "The page must previously have had data
> attached and the data must be detached before the folio will be freed."
>
> This is the wrong API to use?
>
> Sure, it sets folio->private but in different context.
>
> I can spot one user in mm/hugetlb.c, that likely also should not be
> using this API, because there likely was no previous attach/detach.
>
>>
>> BTW, do you know why we have set_page_private() but no folio_set_private()?
>> I would suggest folio_set_private() if it exists.
>
> folio_set_private() sets ... PG_private. :)
>
> folio_test_private() checks PG_private and folio_get_private() returns
> page->private.
>
> A cursed interface.

Oh man. folio_get_private() should be renamed to folio_get_private_data(),
so that we can have folio_set_private_data().

>
> What we should likely do is:
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3944b51ebac6..702cb2c0bc0e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -426,6 +426,7 @@ struct folio {
>                         union {
>                                 void *private;
>                                 swp_entry_t swap;
> +                               unsigned long migrate_info;
>                         };
>                         atomic_t _mapcount;
>                         atomic_t _refcount;
>
> And not using folio->private in the first place. Just like we did for swap.

Yes, this sounds like a much better approach.


Best Regards,
Yan, Zi


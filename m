Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4360D116F6
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11C76B0026; Mon,  1 Dec 2025 12:02:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9A06B002F; Mon,  1 Dec 2025 12:02:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8976B0030; Mon,  1 Dec 2025 12:02:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DAF86B0026
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:02:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CE19B8525
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:02:05 +0000 (UTC)
X-FDA: 84171519810.13.F762730
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011064.outbound.protection.outlook.com [52.101.52.64])
	by imf18.hostedemail.com (Postfix) with ESMTP id 192FA1C0036
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:02:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R2TPptVm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764608522; a=rsa-sha256;
	cv=pass;
	b=u2LPPDejPy2WkP6rqMSeQwvqqdpvsDgVmuc0/djCx1S4cBleC67KyubGhDi0niH2EQELBP
	x83etOZ0K0Yh6ZcmeSNgI7jjMpkdq7j6+YffCijfUfE97fNuIB1CtOLWaydoW+hPTVHXQa
	6CZK4m1Aa9j3/4YtGdg/afeUSVbpgOE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R2TPptVm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764608522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLG95P/PmD/nrZDf8Mktho/pcl6JE3Pt5YcqHK14B4k=;
	b=xmlvxQ8hoG1KUZHqMwXyCD2XNl/aKhlxR4TQc9dXd7EQC8KO+Jn3N5lzX6DPwLiib+7v2a
	PBkfKXATWh3S+6b7h2t0vA23hrDWUnc1n79AGBsyEoihftKMIWCePfpCKpbgZRKB7pZRSy
	PRxzO4hsgA+WNZuJw/3cTd2rmM8PgxM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VibeTGEjXZDeIHohzjaF6hx7D9t9X8AtUkh3e1fyWz0wknKYAvUc8u9GaMxkcUYTHH1ygksaKPI913f7ReiQkVOJZwB6eJTtORuhvSkW0SZDdn/X/2At9HIcgKFv4Hnm0Q/GQydtcq3vPF85QKKFsa5w6b9JsEK9qugQJNfgW8phj+jbV6l+FI9pAZ9Ft5L3fNwv1vib50VkaQoPfRxwSPzHl8PLVuCCVs/3v3u8upkqfOIBlatH4trPt61EiMQORtibRBwxUOc9oc1UYcj/sol/TB5DqnBTr5Uf8XoFw+y7rXqb6CJXkAavJynbEYfdNeG4wvJLrlHGA/JXIwRACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLG95P/PmD/nrZDf8Mktho/pcl6JE3Pt5YcqHK14B4k=;
 b=r3IC5qOnpu1F97+A2e0ZKnu901xKk5k0baWm5xLjZ7mFMkxUMguaJJKEV0pFY/gpPD7iaACL/+n8dXuyI0kUqJ93tNZMhr05vpsvLhX+2qB6po4oU4jSif5l0rE3CIqhuc3MdzoCLXT6SaCHPVv58bdI5wo19QyhO90496L3l4Sz6Rr/jpPlrIN3qxQ+bax6quZpOx1W3ClsZzg/ObJ+aaW7nypUX84YeFgXF/bxH7NDrJkSXM50MEycGlZtc5RdSh2kSdvgrp1Ib4alWZVj0ykSN9UtMXIjbdQZXl0mYx4BLoG3jwJ3dz5rMKzJE1xWMQatvc/qoFZb6pzf6DLSaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLG95P/PmD/nrZDf8Mktho/pcl6JE3Pt5YcqHK14B4k=;
 b=R2TPptVmIUfwJ4hwyhfHmLFl9mW4xnyQRcg+nnZaUcx+U69zFjXBYvw4HV5Y9xNDluttnbCdPOWphL8b8iTesNGQQLufFYlIMFeczX5wue297GFQQ4AUIYY3BQMG8w4EbYPzYRo7qAuI6BVAtP7fVZRK3aaRt0M2+7NBA7fr+hzwy+ZlyDjnO7XfTynQJ9Py34jLQZtrHxMW56mPuRzO3HZLByf4lsS9w6RNYRRmLomBS2BepF74nz9DUv33pdVzDmhWPSU3samMw50NsD2uH/xM7W39H9Vcsauy7M61tjuTWICTGIdVFVAzSVL5sWgMhtLdszDIgKsC7YYlrMiN4g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Mon, 1 Dec 2025 17:01:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:01:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: vbabka@suse.cz, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org,
 jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org,
 surenb@google.com, weixugc@google.com, yuanchu@google.com,
 zhanghongru@xiaomi.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and
 optimize pagetypeinfo access
Date: Mon, 01 Dec 2025 12:01:54 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <760FBDE3-2724-44A6-A874-BD87F0191C57@nvidia.com>
In-Reply-To: <20251201023647.2538502-1-zhanghongru@xiaomi.com>
References: <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
 <20251201023647.2538502-1-zhanghongru@xiaomi.com>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:530::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 181c38ed-8df1-4be6-3ab8-08de30fb5633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g3StGGfpqVqd23wAg1VUH3wy217iJam4+rsuXTtdCzgL8tvEm5o0lKlN2pcT?=
 =?us-ascii?Q?uSRkRtiIkZC5X4HkeY/oUg6QcrVmdf3qJ5b5xOx/Dgn9L4egqMfSo5M/PyZ6?=
 =?us-ascii?Q?tES9r66clX8D6SqfqtrU87Q1ZApai6k1wa/y/xN8pASDWfL0cslvML4J8yhQ?=
 =?us-ascii?Q?NRfEft/dUolXtS0w+Rs6KiLiXLUXu0DKmlpZRjbVO6P2nfPRmveb32fDt+dc?=
 =?us-ascii?Q?8JjGRgBQ1wLoJzSdMUZ/y+clJZgLW/O4Tp5rtsfnihRi9G/+nz9GHhOznFCw?=
 =?us-ascii?Q?SLW5ImyAbGhI85nldeJ7ueoCcUkGm2hB3fou1rBZznRqcI6QqqoIDlpBRJ5K?=
 =?us-ascii?Q?zsP0zM76es98Ey506JeAksJJP6HvjJL7xu5n/xDghwZcMdqBHQCO4n/Paq9v?=
 =?us-ascii?Q?rhPfTQ9wzidfTXxkgGob8NH5i/dR7BO0Kipd6kbNlG4uTFCfX0wnYblg42rL?=
 =?us-ascii?Q?jvLaCsNgv1wMXFgo7DiJYI73BGTjuYJJtcQBNiiESUnt3cLvYKzb61XQ1C/+?=
 =?us-ascii?Q?oaOB+iB08o1FjfsaxR24OaffKVzAlGLhPCX84qSWsH6JwSQETIzM3rzT3VLA?=
 =?us-ascii?Q?silXnjiz/UyNWtFNM1oK5E2ZN8CYH3XAYs3GshLzBF2ilvJsP27mfdmSz1hJ?=
 =?us-ascii?Q?ukb+wZbIDHnFLhVRMOSKMQ9g07yLtSXCD0/tR1JKxVQIrmihDAqPlpAfL+q1?=
 =?us-ascii?Q?NLBg+WACSL+q+KTFKXla2KA8NSROsWAbnQj74LtY5l8rOQ4mBxeMyOsdxvDG?=
 =?us-ascii?Q?3DCBOZ3k6dP61jGDgMktWrkdMKJCiFhpGNNZ0tq+30tC96MDUpjSb1TSQVTP?=
 =?us-ascii?Q?JZr5Ray/luImWFUH8QPczixzvQXD5Ehdap2sDT3sekAJOTmL32Q7I0pyLF26?=
 =?us-ascii?Q?3lDjN03efQ4NWQJ5YvEDZvF0xe5ID/P6H08POfiTmPEkEuQq9B5ARedTn7F9?=
 =?us-ascii?Q?ZjJpdvdGB1RdxXmZIMWhw3TEzkC0sTTWFw/Hc3+ay8AQoobeFexoTmZjNw24?=
 =?us-ascii?Q?QxLUpF2yywti2tuFAeRMBn1UkMTKZrskU0fWSLA77whf7nj3R6DT1j2VmLQE?=
 =?us-ascii?Q?wH/UuswPZAzZ5JRpyB7YsDofCt8c3ZkL5XNyvXTquIqou0DxDSESXfiIh6us?=
 =?us-ascii?Q?RcYPaUL+IpMPfoblqTCwCFU6OlyQlwfP/1ualh8x3JiS31sITZj7+vQJ1s5J?=
 =?us-ascii?Q?jFyzP3BUnalFElUpyCJyfFAjMcPkmLwAQz0Qv0meFEGCBdWhKhwRdzp2Ezdq?=
 =?us-ascii?Q?3/HGK0m5B3g1sTSzeHAxvpW6ctfw+0k3a/GN6HnMC3O1a922ns7nfdeAcPEd?=
 =?us-ascii?Q?NQRKvgVPdSg8Nz4wnGPOwwzLJqWzuMW43rHAD03BsKmeu1J9X54KCm5Uxwl0?=
 =?us-ascii?Q?cm/CwwfpF7YKXQ1bJJ4YaYcVxqkwJ66oVR3OXf7qoIhIqjWZO+CoyOe5HKsu?=
 =?us-ascii?Q?TWJMnFa3onLeAigBUQfXhfeK5icvgAWP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rTc9Lgy6Z5LRwbT/GXNyeU73wKAwXOKcc7Q2lc935teJ9PwGAGFw0O271780?=
 =?us-ascii?Q?Mx6PpwXqljKsdpRMkuNjhDo5GYhjM7TLXrExgFuRuhbexqqBbltaBJqbPhqX?=
 =?us-ascii?Q?+cvDM6Ri+TXEU745L4JfCBO5vjDEOG5wPGaVBTVe7SH5SJRRZHY4KcEHcNOe?=
 =?us-ascii?Q?dmztuBIhIYfFJ2abj74aTBqOKG663E4dqr0shuQcXor1CpXTH3mMK3Cv2SSv?=
 =?us-ascii?Q?rUgdDf59/P4bkEAQLNOvhOZ83UzS8wMORBXlzTq93wFOMiNT2BRqkOaGgO1h?=
 =?us-ascii?Q?TycfivKuFCbxPwxd2G6iJDie220HoXkxCpjzGNoV+jzWF7j9J8kADPe1UY/q?=
 =?us-ascii?Q?GJc0AbTokw3VYVOtsg6fGHscNCFQZscaZ8vaRnap5IfnbFEQMVyQ0ottYv45?=
 =?us-ascii?Q?tjBVWBItQj04TY13tnOnFKcIK/KpF+4U/RHNEMSXjGq0YgHGNPfrGOTMd/0l?=
 =?us-ascii?Q?nw1cnsFENQz9hxmQOo3UlrMKw7tGLeGBikFsd++x6pflUM2z19slMdmSsmc9?=
 =?us-ascii?Q?fHpLYFZg/m62z6XIKfE40xbHehjX8yYls5lbeSlaJagWOrtoFBye3XR3pf2F?=
 =?us-ascii?Q?KfsLd0eQsWuG5w3KwV91rBmJ6LGhGjjbMGOFv2b3T0OfUYF/TtjPPqIonAD+?=
 =?us-ascii?Q?LXItXsax/UOSO1G7FdE6vH2qkAhU0kf5jFac0jI/vNIP3kntvxkVXjGR19PG?=
 =?us-ascii?Q?d3i5eRNudqaH9+imnB56WU8faaBGz9JaqIRaQ/FhUa0ZYHkLDLasU4UgxUi9?=
 =?us-ascii?Q?URG/cUzeKzel2wLtT+goCOMMgUsfdQcUtOf23BZKOy2phj7kD45y/PSMH+I5?=
 =?us-ascii?Q?Y6b6I03LHJvx25CSXAe5SP10xf1HVMHzF9na9H2kNbmvVjA5Epbw+4WRvs7h?=
 =?us-ascii?Q?qvvI3iE07n4y27ynRZ62A6guD0L3tPKmdmH/FfiztXC8YX8+UeAp910y2QTD?=
 =?us-ascii?Q?gZ5sam8yq3ClqoVEXz/0ZdRxMQ8Rjn4t7tkcE9339lrXAsdoVjn/rtBaetz+?=
 =?us-ascii?Q?rV3buf788mMcCtbLh9bVvYzLbQaECbpKLxKELw3VnsNURSM1zqJySz6gtSDJ?=
 =?us-ascii?Q?9L3d05UbncB6E1xpAIwGHoc4glqzBbnBheJcduayZz9oA60VktEeWSHcv6U9?=
 =?us-ascii?Q?TseDZCXoE25EIRq/ZhPU8Ht73L8H7bescKEwlvkdQdXFdys4gnqIOyoO1DsT?=
 =?us-ascii?Q?+61a9+vKg/V0pN+ESBZq4in5OEzXo2cpyQygESXGPYAPXDj+mjos0BBIoPgp?=
 =?us-ascii?Q?d5Cgq0IyIt3wgeCzY3vF9xQOmc+hSFbyfXY5PqhYnZtmxuQ4y9mYxVqaaRqq?=
 =?us-ascii?Q?TLMazbr9FO6hP7tbrEdxIF4XjRn/QTo/fY3aNVtmPcJY8ii2NLKHOJaspw8+?=
 =?us-ascii?Q?p+0HA9RzEnNwUtuU7nz18DEKsRHAaokc1u1I6P9bpGKogzUzbTDibB3Nj7GM?=
 =?us-ascii?Q?H9KaAm3bal/zm78rLeNIcWVZB9Jb5kwDSoRwNII3Vh6X+z6JAFn5hh1vXwQ0?=
 =?us-ascii?Q?NgGVHNJ5sa4+RCKIPTYx0XD6WSlaSjCnPmNc00vu16LAqbIn6LPRd53O+HK2?=
 =?us-ascii?Q?v/+7TdmBNig1AO+CPjcYAzZYX2xcCzYm0WxVETcG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181c38ed-8df1-4be6-3ab8-08de30fb5633
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 17:01:57.6371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqY5X7IV5SgDn9v3dpr3u0x6+0ejiM8aqZmuP9NPeDIa4GB5cecyz5UwgNgin4Qh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 192FA1C0036
X-Stat-Signature: u1iqzks5ypftt9qmqi9pgqx6kz3iyymo
X-Rspam-User: 
X-HE-Tag: 1764608521-247798
X-HE-Meta: U2FsdGVkX1/lNf0GBOy0W/sepnNu7erM6+7XYZz8nyfreU9EmGd52gaSfkai/2ez/POoPEeNk3VjoxwnWyKshSqVwHi4OsjcJ4D3eKgIBDbjvPSbOQX6BCfRWOKXWq9uCfjRzGPNSCzkcSwTf8d375Exaelpod2hiUeuWta/VXhpdnnV2nTY7SdHlpE+9xeb9fM3yP5HvzeSCNParLglTv33uApdd7PivbMaYr6VMju2aiiD6BbW3RksdYwBh7UO+LHrOPAXQOCQr2q+t93FOIlHkHM6TVBx/qSF3SwWwcAruhYA2ZVJirYsSfirjUG+UuTzYsaXnWcmi1zZtxNAHRosmoy2K5wEintmDp5WJ9FCBHETE8Pe9LngHg7k2tgEChvVXXby23kRtbud9+q+vM18o3eqJHJK8HzUwUdsUg4bhvxUja/OvBvAqx39XlkHfH5qW1d2lHFwbO1XWOJlQD6+PUtMqc4hNp4nmubvSTZ+DEOWgmlGFFCmy6WeEfC9jEI8kkmqY8aHbiyP00j32pL+Inu/G5N0pzSegCGXb6W0/39bgB7tDWMt1n+MN9ndKwofhG3bRnkcawqbMuLHk2lsDDcVRy09rd5VU9emyerrcS8t5u4vzVAiXiroC6nu7qAyznHmCt/d8h2oVIrqoAa59hx8QAKaWvt/I1r7AlU7TZP/5BwXxHKEKMNPsuJ9tepcL07krZG5dOra60Xu6IsA5mbTW6ifSclYqE9V3wbzaqwpf5Hr0lKfVaSs8j6DqHmFI6Wek0OZaDUgqdDG1dxp+c8KURLr8ChbRlDw396cCdkp6qhJC2zy6VaUxNFgQd//ohDgFLnyGkWugq/r9Y6dYsQu3jaBVNeBOBdeyXirsLBPmIzso49/d1JK80HVGWvBuJuBEdqynvrrbVb3bfvice6IjUoo3fZSK6WD4r/pehDgmk3NpfebTPeG9p8V6R9s3ChkDhvSHcrtYrB
 6DnChvAh
 3qL0G+KLhcvMW9lXavFHGWdD2d2RH8TEYZGRK2WWGMohL5TEDPo4wxa96FTUwr+PqpKb00a4Dk+DNgn7seX9ua1xaX5odWFZxl1gJcMphg2hNm9U3nkaZMkJntE0p5pWfiNFlx67Q0O8ITHLEAsozSQDaGSygpbQliXQOHnUObl3dRZXFuRUTzChqqETlVsvhhNzid5tgCjB9vm8WwI5mYjn87yioyRjR4KYyEULCLzC21D+SNerciS2MLFzoh27YkGxKfXlHoCI6kDtTIJgxGsDAdF8vtJ7j8b0AxQsMBgXhlaVK3Lnb3EYhcEAY64HCRg9lW/XS0Au0F0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Nov 2025, at 21:36, Hongru Zhang wrote:

>>> On mobile devices, some user-space memory management components check
>>> memory pressure and fragmentation status periodically or via PSI, and
>>> take actions such as killing processes or performing memory compaction
>>> based on this information.
>>
>> Hm /proc/buddyinfo could be enough to determine fragmentation? Also we have
>> in-kernel proactive compaction these days.
>
> In fact, besides /proc/pagetypeinfo, other system resource information is
> also collected at appropriate times, and resource usage throughout the
> process lifecycle is appropriately tracked as well. User-space management
> components integrate this information together to make decisions and
> perform proper actions.
>
>>> Under high load scenarios, reading /proc/pagetypeinfo causes memory
>>> management components or memory allocation/free paths to be blocked
>>> for extended periods waiting for the zone lock, leading to the following
>>> issues:
>>> 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
>>>    8750 platforms, reducing system real-time performance
>>> 2. Memory management components being blocked for extended periods,
>>>    preventing rapid acquisition of memory fragmentation information for
>>>    critical memory management decisions and actions
>>> 3. Increased latency in memory allocation and free paths due to prolonged
>>>    zone lock contention
>>
>> It could be argued that not capturing /proc/pagetypeinfo (often) would help.
>> I wonder if we can find also other benefits from the counters in the kernel
>> itself.
>
> Collecting system and app resource statistics and making decisions based
> on this information is a common practice among Android device manufacturers.
>
> Currently, there should be over a billion Android phones being used daily
> worldwide. The diversity of hardware configurations across Android devices
> makes it difficult for kernel mechanisms alone to maintain good
> performance across all usage scenarios.
>
> First, hardware capabilities vary greatly - flagship phones may have up to
> 24GB of memory, while low-end devices may have as little as 4GB. CPU,
> storage, battery, and passive cooling capabilities vary significantly due
> to market positioning and cost factors. Hardware resources seem always
> inadequate.
>
> Second, usage scenarios also differ - some people use devices in hot
> environments while others in cold environments; some enjoy high-definition
> gaming while others simply browse the web.
>
> Third, user habits vary as well. Some people rarely restart their phones
> except when the battery dies or the system crashes; others restart daily,
> like me. Some users never actively close apps, only switching them to
> the background, resulting in dozens of apps running in the background and
> keeping system resources consumed (especially memory). Yet others just use
> a few apps, closing unused apps rather than leaving them in the
> background.
>
> Despite the above challenges, Android device manufacturers hope to ensure
> a good user experience (no UI jank) across all situations.
>
> Even at 60 Hz frame refresh rate (90 Hz, 120 Hz also supported now), all
> work from user input to render and display should be done within 16.7 ms.
> To achieve this goal, the management components perform tasks such as:
> - Track system resource status: what system has
>   (system resource awareness)
> - Learn and predict app resource demands: what app needs
>   (resource demand awareness)
> - Monitor app launch, exit, and foreground-background switches: least
>   important app gives back resource to system to serve most important
>   one, usually the foreground app
>   (user intent awareness)
>
> Tracking system resources seems necessary for Android devices, not
> optional. So the related paths are not that cold on Android devices.

These are all good background information. But how does userspace monitor
utilize pageblock migratetype information? Can you give a concrete example?

Something like when free_movable is low, background apps is killed to
provide more free pages? Or is userspace monitor even trying to attribute
different pageblock usage to each app by monitoring /proc/pagetypeinfo
before and after an app launch?

Thanks.

>
> All the above are from workload perspective. From the kernel perspective,
> regardless of when or how frequently user-space tools read statistical
> information, they should not affect the kernel's own efficiency
> significantly. That's why I submit this patch series to make the read side
> of /proc/pagetypeinfo lock-free. But this does introduce overhead in hot
> path, I would greatly appreciate if we can discuss how to improve it here.
>
>> Adding these migratetype counters is something that wouldn't be even
>> possible in the past, until the freelist migratetype hygiene was merged.
>> So now it should be AFAIK possible, but it's still some overhead in
>> relatively hot paths. I wonder if we even considered this before in the
>> context of migratetype hygiene? Couldn't find anything quickly.
>
> Yes, I wrote the code on old kernel initially, at that time, I reused
> set_pcppage_migratetype (also renamed) to cache the exact migratetype
> list that the page block is on. After the freelist migratetype hygiene
> patches were merged, I removed that logic.


Best Regards,
Yan, Zi


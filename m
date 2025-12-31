Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB61EE49BD
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3E06B0095; Tue, 30 Dec 2025 23:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C536B0096; Tue, 30 Dec 2025 23:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A746B0098; Tue, 30 Dec 2025 23:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAEA6B0095
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:32:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13C35139810
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:56 +0000 (UTC)
X-FDA: 84278495952.26.26098E1
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011057.outbound.protection.outlook.com [52.101.62.57])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E13F4000B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UCfg/Ft+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.57 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767155573; a=rsa-sha256;
	cv=pass;
	b=N95VGnLeCOWBadr6aH73njv833r5aFhr6A5Kexz3JrZqy16y2C615mFCEvPked5czES7BZ
	/rUJ6AVaIKrdWziycVKTBInTWuoLoUQjHjVLZqFHu9chHf8Z8Cl+mgHqlRE1SWGxFI+lsB
	J6f9ElncGAAEiVwa0fSoSOvGiBsAvzc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UCfg/Ft+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.57 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fm1Ln0bpACqMAMin2f/lqj+YmUUw3anv+NmXfmp+G+U=;
	b=3rVEc/lwy4gWBrhumEdvcJVjeJkjmSqKfhIzAvXZ3H+6ITBkAA/Nu34jbHhfR7N5AaIpQN
	8sC20UUvnzt8Qard4RXkyRAYxFQWrhDsNqj+bODMIrS8+UpnTJyPlo2ucDjc5ZuY9YrrN8
	Vjg9+2hcGOciJSTq2RPgr0hUtlZyQ2o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpuc06Kfhbbzmud0O7prDdIXpR9AZcGbNqoMQDd62FCeEngT26pGLjlra6s+WLGkKrzXmMwuub1eiwF00EPQDCcdl6Ex1TTE2Hqe+BMuOWhjXq449T19iCZ1TUpgBdyhM4/yn9waX1rp53rgYE6e/jN6cTQ1/cYQw3zmTTNo4yKoqdVgYkunn85lPTP2pydbXq+1RWfy6Ym/uG1gLB5/4MWO2TYGJTRDvVLZ9E96+OTICazPiFFj8yxTccAkhCearVpnvN0eyBKQC4uIekUHLTzxyvwtE7fkHbK6iR0MOaz64GQp0N97vxHkZ/iaNmrAxtO9sLl1aZLWRlUJ85de8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fm1Ln0bpACqMAMin2f/lqj+YmUUw3anv+NmXfmp+G+U=;
 b=SqyfXx+LzIReGPvLOemvNiA4xyXIEJSccRqnibROW5pFLLTplMC0ZHrraXhKlgpAFGg/QKIsSnHbFvpDMW2j41e+BNy6bTgGzhPfRd18904nRdAjPUrPN+vZuqqhOQQpxCvhyIWLI3HhyAby5sV2vw+tYYF7fECQkvH9G6QkXQUo3TRHs4UHpfKnFCsNvCGu2fUn+9g15RY2uw5D/m35S0CjULz90QYMwgEcTrGRkXI+HKxn6mcea2VITeIbsblAmIrY39SPI6npJl/nPJG6KiNr3PnnGo70b8cGD1O4Txu1m1g/y4BJB6Pn82uVnQSQYa/IS4tOUsSkGjaqkTQRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fm1Ln0bpACqMAMin2f/lqj+YmUUw3anv+NmXfmp+G+U=;
 b=UCfg/Ft+liIn/b6ij7H4/swGQEv+A2j36PfRnSzhIXStJmxevCq2RwC4Hbe/ZQftqVpc/ITLQAXrigulKv3e3PvT7pzPjh8ww+Vdgy/S+BAbmm118/s/japbHzGNHJn0qJNUBXnEEu4QbuAxxH4uiWikBcW7tMrg14wyzvSgnVJitaSYd6UkySKdgNPUBEU3vUvBmC0LML7RWigQool4Ik4nMVAnXmjqeZ+YlKgIPcSITgaauIDB1JQRBvFoBNo6mD9pD8/0nkjKWjohaYfAc8lXLxgUMStVdqqjED8b4KZ4tT7aWVPkVM9IToAi4QwaguoU2QV5qU8vP53VCaShyw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Wed, 31 Dec 2025 04:32:44 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 04:32:44 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com
Subject: [PATCH v1 6/8] mm/util: Add flag to track device private pages in page snapshots
Date: Wed, 31 Dec 2025 15:31:52 +1100
Message-Id: <20251231043154.42931-7-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231043154.42931-1-jniethe@nvidia.com>
References: <20251231043154.42931-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::13) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: ace1d125-e9f0-486f-5049-08de4825a43f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JiwlRjLRKAx+5pIrN6tDRtoULTjOJvD8xkF8mhS8FAI1DIQXYv2koyN9uKMJ?=
 =?us-ascii?Q?VOssuZLRdk3iyY7ULMkJC0iL0kGDO9qEtpaayscdNpuVSB3PfyVDUiwl9OgM?=
 =?us-ascii?Q?ck7sEJbGAFn6kBWMvq+Ks6TePpnJNIJ5uTJbmAr6Ee50XkusyqesK4D00gom?=
 =?us-ascii?Q?T+T7qFicki7NFSxpYCoJCxLIgbcop3ysIgb91ASvw0woDryuYuH1xdO6l0Bx?=
 =?us-ascii?Q?ks1e3SFaS4QnatiMfNvPSNskka3YLXFr97MoRoSDJzEuB4rCkWiHa4OIGOzq?=
 =?us-ascii?Q?OkDiIv+FH4+NNzpl8GONzuKagYrRAFSF3eoYebj1o4fzgFm6T7cRy+bXD0Py?=
 =?us-ascii?Q?V3YkiRZGj4c5wcw0YWvuIUSLVtG48kVnOcyEEZahjXqGiMg8+IiexOJMOC9l?=
 =?us-ascii?Q?n4qd4W/7HtDX0V4zHZ9ZGHylxyLSWx+lT5gZ6Ev6HgZ7B/wFKMgq6VVzGdDB?=
 =?us-ascii?Q?GRaBhUkQIQrvvmKAowxfKJaHmSAXv+XqV6EZAqKJ6aekRyznhgfgpTgnb53i?=
 =?us-ascii?Q?/MtrKv+Im4zgE4lp3/PQW8VcmvAFbglmZaFXAUxIOnr+fB+iacZu3T0n5Y9k?=
 =?us-ascii?Q?RuekpD6x5kFZbr/hTjy0U3/Gwx4+f0E4Zq01DOF1x/6s/LdNxojyqmzVfT8t?=
 =?us-ascii?Q?7+8WN3hmYv2m+0OZ1Ij/UhvCb6Nj4m7tL7WfZIdwcKzf1HDi9YsEi3Qmfgub?=
 =?us-ascii?Q?czChnz/5MV8G/TzQh5sPOoI9lcsGovqMZF+lq/uw/+/K6NDFtuGwZm+LtVKv?=
 =?us-ascii?Q?8KlhqhS156omPyT+WdlwpS5S042MVJnPG9h6tezFOhZLC52SaJfEThs2G1VX?=
 =?us-ascii?Q?ZtfOhF7byM7JqdmO6QuAYhFj1srMtTclwKrPeUkJU8nXhkAxCQVvCBxUjDDQ?=
 =?us-ascii?Q?bgr+6VYu9IMArn6CWm2clNjp6uzHgCO9Jp3wL/yfonANvoJmyVvX6XJ8Z/b9?=
 =?us-ascii?Q?mQ/adqfRE01jOEe8SKoev78xrnYuBNs52rxFj9qH8GMZ/9VaPouZicUfqhRw?=
 =?us-ascii?Q?RJW4ZinuzwQqml79Er/n9RscW/mYTfyqERpAHHmNtwuqoGl3paewXSmnXxPh?=
 =?us-ascii?Q?lKrA/u0FXcZNJaN0dj/FlQfw1clri1tQhFNOjhoKharc7XsRcfH8Gk0LqmXl?=
 =?us-ascii?Q?/nyqyHC8CLMsGxdEXxb3+fL+CTEX7llzInCBL9NH3gVTfV5iGJlOjPzO9u62?=
 =?us-ascii?Q?fg7GFd8JgYXi9fKDIdDZ/7I8kxGf6kP6LBJUhKenSn/0LLYohD7Dp1dgi4VH?=
 =?us-ascii?Q?2g4g3tFB/Gmp28AEwTutpvsTmax65kxJOZpdo7iVFV+VdOItlZMuT5+8Hs7S?=
 =?us-ascii?Q?7PVrJwazJdubacQEZWDP9KYSExyIBfArVxyzQ/tPMQQaW/gzI1A0ujBeQnZk?=
 =?us-ascii?Q?vaWVCPWWmRlfXiPOFAL52XXPhCurri7wYsZvAufvN7BcaL/e3Rs/DAYf89HZ?=
 =?us-ascii?Q?gC5VqJt6upb2kfgZ+Ip1EZuY5tBxyDkG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yiJ+EGEU1skXiZRcSmKa/iVz/x+6FVODP5GrDfrZCtC3DxL86kFW5ISBcdFh?=
 =?us-ascii?Q?MQYK0mDCXVskGv0ZaLIOSrbilfIEE48Y++9KtsxRWUd3gPNNnF49SQwt3PEQ?=
 =?us-ascii?Q?fLb3wJBGHI083TZmiazLqv9A4yCGq3aEPJLsMDOzLm3GW0fCIA4dRwT/9Svr?=
 =?us-ascii?Q?kThMTPOcq4OhY190qqJOKoA29LV5qx9A4Z8lofX5pcGo02L652xrgzePtlQU?=
 =?us-ascii?Q?VNu7g0TpzvKW7u1Gp6ZsxDD7RIpVlwNM5bHFjNzOzYq575xOIFvGy4D3EZXD?=
 =?us-ascii?Q?1WZ8HldlAwpoYIs1tFGiio2LnttKwR9KE7bn17TcWAbUGZuc23wiwF248gr4?=
 =?us-ascii?Q?Tq86GR/n01q7ns4nKuN+Ioykbn9CJ+vV1R3Gx62JabJBdUTCvF38BHzVOoKJ?=
 =?us-ascii?Q?Bx3onC2MBrpwqyRBxhStdmyoxoM8j12+KgTVZtYdBaR/0vDEj6UUZzffk8lD?=
 =?us-ascii?Q?vtrw82Z4bSKPFm071admvQNydVmZ8hPzI0arz+tOrXxvdT6mkIlARtjq0uXv?=
 =?us-ascii?Q?rmQvU+k6IBMgN2/qPvrD4Uq1ak7jQDXeRN6yYIPJiASABSzExVs9kLofnka0?=
 =?us-ascii?Q?lO3tfcIt/njFZ5k8JI6o7UnKMqZBLuPqpZ6S2x3e+AgMeNxYZOABchib189y?=
 =?us-ascii?Q?LUhnc5x58JnyKmRcqJJA21wnmwNZ8JOa8ocHqwvVvZtEugNU/3t3PsUyWhdk?=
 =?us-ascii?Q?N10o5+4NzLHlmKqJQZy6dTavPz3vE/OL/gwy89AQijDPDbD60mQSRSIHhhV+?=
 =?us-ascii?Q?jm9yJBAl+vKpqhryaq3SSc9kLMaanbXRlgFnXWPNzFY7lMAGhp5VRmDTY2Bu?=
 =?us-ascii?Q?M8xA0R3d3ywZddrEDtvLseMDodyhnnSMyNRhqR/bJGLiyUQBPXsnTZ/ZHE4q?=
 =?us-ascii?Q?wXX8+rYF4vux3sKSAe7HUOM2tMfxvTdhUKnEOhDvCGARCxFv+jAq/cy8s8kl?=
 =?us-ascii?Q?x/KL0I653yQ+i5keLYh2b0+kj1dycksWJ4vJ0DbI2sQyuSsPUo+GndWUFilk?=
 =?us-ascii?Q?h6uhmtfMqICsMLIBRzOq623A5zsuiH4iWacNVKapVeWIQ7yYeYLNpSE/qBLq?=
 =?us-ascii?Q?0gLEfmmecQk7zTuhVhNDaLK9h5o5a0wGgzfgY4R9Yze0ARImZ0FX1HfBnYVW?=
 =?us-ascii?Q?eC7BhirgVUq5cEgIaAkIeeIkDu7qDv2ekFvDyDqX4cSSEfykTK1qMDaqORt3?=
 =?us-ascii?Q?1CGu/qv5qsGXjBBd+9UaxEh+jzarITZG7/2vUlYjAF79Q601giSy7NIjEdEq?=
 =?us-ascii?Q?eAxG1sgCsRDkBPyrHd9YX6OGnhhDBrpj4OPNrT92CM4slNdhdofxCpkYw6pY?=
 =?us-ascii?Q?BzvOP8x3bBByFMEAtXEDieWQ5f1+9535yjQzUrqDqzCcY64Si2S1SUicvwsY?=
 =?us-ascii?Q?HgFid5CLmp0lw0IkED7kewogpmzUQlJU0uukw+03Em9wN9PxyezT06Y0Gllu?=
 =?us-ascii?Q?qp2NvD21KqUBox8Wz05ieXYuoDUfcQytUT3q1+UesAvkXVZaNQ4jHv3Bc5Fh?=
 =?us-ascii?Q?t6qrYo+zs0dPCvJupJ8YLRR5is+/eHED4jVK+nyuzEgBIuGiEC8SlNqx7Jun?=
 =?us-ascii?Q?xLXfYyYHGcFz+ONw7307NsjfY6xgGRtDL/CWtJSUv+7cZ0hcd61doy6lyXNV?=
 =?us-ascii?Q?VwCT4cRNyys4UebEUT86BDTOeDlL6CKBZyG2X8I89wA4X8Tb64xNzTHiWjU9?=
 =?us-ascii?Q?XqICiFLS92SJ5/Dr8x/EayHiTHrMAaNJwzYX41InjKzCOqHlIw6IQRS/Gqb0?=
 =?us-ascii?Q?25OqyMBcsg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace1d125-e9f0-486f-5049-08de4825a43f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 04:32:44.4548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuD8sR/mTv3D2FqgQy4dj27OSTPMIlnmqRO9pCsEwp9gQijaz/flGZTcRl0lXSobhv3oxTzmgIoE4G3cSx+xOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E13F4000B
X-Stat-Signature: h98g7remcngabm1nxkd3h3p17qnqbier
X-Rspam-User: 
X-HE-Tag: 1767155573-946241
X-HE-Meta: U2FsdGVkX1+ya+qYtdfUbo4u11f8mTMwJrs88VSKZ1tBLzahZBm4XWWUxIAdH1GfVkLyiMe1VL871aQIB0YI944ub889+qt3BnINRgnwOOA7vak4rX3Qey5W1VdUn8W6wFGKSjUQImsSRqmDAdLDKjjHFNItW1vip/21zdRc6e8VgyQxLryd/2ubTlZbV7NTwUhWXCJcK84528L2pdc/tAi443+Q1Arf+XpYkuo6gR9+3c9C7r0Og/sOudX2a5+YWPBAfXxtPiiN2+V4rkLjM74TLdn6el8WUIjYbxKb494bVBMdDJKVCuZTzfA+xikCIQKPtI5rtzoGk/ht2M71LkWOUO/oVzQBcierDFDv0Q+rSi9Grs19KR3/3UKblAMfbSD7bgQ89AMucIDTdpNamVCa2jIzxSsZ/fMduAsZkEl/LW1gPj64rGcjKPKCoEfT4Wao8n/namZV5hYGRYdlX1KP7zzNrn5C7rh4DNaf+FzpWPb4LsQJIyK9yl45Jc7zo32Roo+whIawAbSqtXPiyBB1ZmEoteXbHxCC4wm5ihpT4uwAL3J/lcuGVs44LdL6CntCQbfgOEXiIURdpCKnAnYLAONzwojv9234oE459bgR38kp53TiD3SIhBzZPveU4pppRPw4DTaGkvCo2JW9mTUvnCXZMnDfTzFEc7go1uOxTBM6YoO6GmT9e15nLUNul4EeyiLX6KIXJc1vcwQ4sBKB1fvkPo9HwBx1CO9eU2Af+isdVxbWVfUSt79LwrxXfXOzlwHogZDtMYI39D+UuwM6GF00qO9EjnBw5DZgEK9qmX0GjQxDtpW/TWO1stPty+fX8HyQlc17ig363E2P8sZHSX7Yv4O2VOEhcEuFInN/3EyJQstA7oTDn5/WOcVJpbhnURorJVpXthkjlaTBHxEPKh1Fzed5MybDcFCzMBzVtPdramOq4uy+teVSY6bMXb5c6sjeM55BbYtXQY8
 MbiCKogO
 elo7aQmXA3XF7bEDlbqlstR1NPmH/1m9pTQcN2m7v97KsAMPitu+T9Q3kN1jYob00Ss24Acjl75SsfIEaLu4tEHKHhpwXtS/9dDOQjeGTNo5swdf29Tf+6BUIr3dhN8RKCxLN9mveDWv8JTKuLwBuUJUyTcggf7IDhvIFb2JvaoVhY+hqSOZCoO6m0ZpRd0EaOoSD+UGKAzynjJa5g1O0VWWyyzNqbtL9I5FPdnZD5/g+s1bK8A/1kzN/DTaO1dkQ/6KaQ1ymQc4eUIhrvZJdjBQ70WKaPGmbJOuzHTgvfMOHH7XM5EgqcbyUBMN69IeEPyzRSo3hMXBDHXwHtftd6/amOFhkyhoAK0ANMOVz3vKtSE0AvvRePytfV1yHWxWNgOLuxAIzk8L8pSnq5AYjBbeRowA9pC0f73Ao
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
page snapshot is a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - No change
---
 fs/proc/page.c     | 6 ++++--
 include/linux/mm.h | 7 ++++---
 mm/util.c          | 3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..adca0e681442 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE)
+		   && is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..e65329e1969f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,9 +4623,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 }
 #endif
 
-#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
-#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
-#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
+#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
 
 struct page_snapshot {
 	struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..65e3f1a97d76 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 
 	if (folio_test_idle(folio))
 		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+
+	if (is_device_private_page(page))
+		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
 }
 
 /**
-- 
2.34.1



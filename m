Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2650DCAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 00:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8161E8E0016; Wed, 24 Sep 2025 20:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE238E0001; Wed, 24 Sep 2025 20:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC4D8E0016; Wed, 24 Sep 2025 20:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3158E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:25:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14516B79D4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:25:35 +0000 (UTC)
X-FDA: 83925879030.28.9B656F0
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012057.outbound.protection.outlook.com [52.101.43.57])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3497740005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:25:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=prkBMmWK;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.43.57 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758759932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpJHfpm5FWjKdHm6bJ1D65HK/Z+vZ+KSuhjUGkB86yM=;
	b=zMB/EFbb0SPr811R7OyUy5NgTgVRQX5kZDEuwo5TW/0ZatGIrty34QaHyom2kcJFbJBdmB
	X9lyXMv7Yd0BVeuE3zhAkItF4rT2fO1drmzK+XiISql7uayDRBtLr67zTbBphKW3CL0rKW
	0o1dpjN44e2+OeG5fONWn10rnf1T6ts=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=prkBMmWK;
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 52.101.43.57 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758759932; a=rsa-sha256;
	cv=fail;
	b=OiIsWr4XAIQOmlTTfYO06SXvXC9vdCVFB32TaJ2RyWm9a1DdjMkLtm8tN8qDaRUoiTVlXN
	7bGkXVc753d/Z0xyVPFGjYCDQXp1Z3ZyVZcf/bsBj8g9hB7EA0J4DtVPbBfsJ/TKhG7WoD
	MfBHgmel2ryXuPpNavMju72QWtIy8WE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqUmEe486EBMi8Q5O2H4ms1Qc+ydjQa4lSxs02yL41u++FbmuinT81Y2F5Lwy3p484Qdu+zxyhR4oRHfN8v8nQlyVfvhDjjEB5QsDKtfJOjAkW5fZndvvmEK/FR1t89LHrusl11CdGZaqRUEji+qvQR+ZQJd7+Gc5m9q1VNo2EOXdijyHWwJIeHdef16y0UaqXbcZiKSsyQVkMY7gmfgYAk3JL3ZXU+p00NcuJF2L9aaSlFZkS4lJJTSfZOPNsVvWqRhQtKa+/fCiP6pKJjz4k8h/58rPLLrz4OTIXcUpLLTmpbkUYXbHoVKOkHJ73PaqR+jWL0kOOe2EQza5PEyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9StTZSJK4oDlNOV3wTE5SiAh1d0ricONdQondAtVD8=;
 b=YvGHgSqVHTQqR0B/9M0t0nfHjKe3y48aCXk8r/gAPx3vIsnj4yBVM3cLGcB8GzqdGqZM9H1xFE4sMBd5qAusXqpe44FAX+Rwxl4vuRDqcEH/9kTmdtBUCHDzUJqK+DlUcSc4UvfW3Dl5NyXij3pZVumREZSHE1BhksEHKVg92UdWdB9BKh7/devn+lSn/tPFRpbM6z15mhE4mFOhGUO1bis0uyU9qzsy1N5MSFJbv3L0fseWvgYN9cS7swmYy2oc3P17qvCn8omR4aZkNM/rayHFvKFixCWLCcTCJhSQKrLX7mR/IwHEiaPSW5Ce8LXJOsNRDl4nPhMswBQfAEvmcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9StTZSJK4oDlNOV3wTE5SiAh1d0ricONdQondAtVD8=;
 b=prkBMmWKoVkNqDmhVZmmS6DoegjHCwP3scu+lkNawXQUpyFmEQFA4oACcuoai4Xkbre+m1Gj6gWv0ySdk29bSSg7Z8/MCYBBUC3OtRU8MHIQeXL/1H/8sorDJhHC5/PUiMdSrRjWf96Pvx564U1mOd/eGE/BH3b1Zk76iDegwuLmrlJDueqSVkmLl67t4GZddkkHeTOQciIdyVtHdNeFbEvAvJZ+RZ9TFwT7EeygqfeV7UhWGdfpCqWuUEq+iHK9hrAqIY1ea0A8ISsgqxGIavkOFHBo5DfZvDGUuMmdQMhQZnV8vjjAaoxuEZwwzpQJJw9VQ9ec1MuuHRyPSwMMaw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SJ2PR12MB8953.namprd12.prod.outlook.com (2603:10b6:a03:544::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 00:25:27 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 00:25:26 +0000
Date: Thu, 25 Sep 2025 10:25:18 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	damon@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	Matthew Brost <matthew.brost@intel.com>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, 
	Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v6 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
Message-ID: <azcaqmqwdslvoei7ma4obtpxcdv7jdqfdc3ny4sylgwelwhfvo@okwd6y2oq5q4>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-3-balbirs@nvidia.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250916122128.2098535-3-balbirs@nvidia.com>
X-ClientProxiedBy: SY5P300CA0042.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fd::13) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SJ2PR12MB8953:EE_
X-MS-Office365-Filtering-Correlation-Id: e393b294-cddc-4515-0016-08ddfbca0620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?bg8ZKhEwOUjlg6bvQpqru93BuMtOx5DH1QpscwuCP251l66fZWWOVscV4K?=
 =?iso-8859-1?Q?l3Matha3UXYREixr2PugCWcPI3gf8ZUOOoJ/D48TDkCN4YWFvRA56S9q2p?=
 =?iso-8859-1?Q?Q2YzuPCGz4E1KPs8He2hn3sAI0dKnR5EeISF3J+NDkeu0l7EL9I054CmcP?=
 =?iso-8859-1?Q?lx6vx8gELs4QjaVT1O8mwa7O7IdMv8KiEK7mhz//8o5CtCEFCz7ctZnyUC?=
 =?iso-8859-1?Q?CGTjau4GHM31Cpqfd6MYshN2bHDp2HWKz/z2vHUPLBMYDTQzaxIebjYGdQ?=
 =?iso-8859-1?Q?fw/bmc6WTzBCChbMXPunolGGL0Zlv9R6dxChC/Zvi86AGXwdDyTcwkvAIH?=
 =?iso-8859-1?Q?N+6EldD0NPeIvHL22wgVdvOUfc+nmSt+XE1lSIWqb9cA1s4VxdkaKeoObR?=
 =?iso-8859-1?Q?t9RgklDSa9kxC1phrHSzKEivx84bSIFEMaVfy63wDYG+65rRO7RtJFVGzP?=
 =?iso-8859-1?Q?e0wM0FCE/kDIwIs9WqoyR0UmuOJ8gZrWsu/N2Wm5QlUlwuCVSphNMOJU1M?=
 =?iso-8859-1?Q?xM1BDBriPXSxHE2k4fexr8fBxfFzMy6HI0azDwk+J/mmu7bSxVgDnHmFjp?=
 =?iso-8859-1?Q?WkTnpOKCQV0DaLgSiPngWVTJNU5rfN5Z6f0F7Ai0MVFP3kSTZwbu40HFHU?=
 =?iso-8859-1?Q?rebTQeXZW4JkV0kNzIx/1dOKQwaMaXDYbz07eG6FeupD5x90zDh9ITCwLf?=
 =?iso-8859-1?Q?HObvPx9MVxkLS829tUXXomjC5xXM+gphrrYtNh9cmEijGMX7c7mkTeHdFc?=
 =?iso-8859-1?Q?naPt5gor1XvCccneUuByMKuf2h5NUx3O3n6jCq7rvBRheluZX1nvJ1r2V8?=
 =?iso-8859-1?Q?ofYzwuYMHlcPHU2fadF0Q/MmV7nn/a2w0KDPk9MnxGcspFFAI+4PGflrGr?=
 =?iso-8859-1?Q?JRjEZLlWvf7F6BGb24NSwbL2uSH9rAUIWVz3tDAJh4PTlmvoSf6NthCqQL?=
 =?iso-8859-1?Q?VkxRD94A9HdQ9puzAUbJs01L/9TOWJjbt22ow4xgLvhDiSHF82xhTpPj0T?=
 =?iso-8859-1?Q?a69660i7SYORllIHRECcGQG5iv2HsP/OrhBUK5g8s0K/gWlzKr146TT2wA?=
 =?iso-8859-1?Q?gTFlcgLhS05Hxes4HSmBj3o4MIWyuIIS2MD9x8R9iugD8hUGE5fPa0rART?=
 =?iso-8859-1?Q?9T/Fvnb/o88i5wkGlk1LChEZgznHMH5RSxdgmKhhWWTe2RmgDxcQpD28vP?=
 =?iso-8859-1?Q?0BOakW2L7MnlemPCv9yoDuBjLYeKHoc6GXAkMUg7j0rIm+LkT+W/gObBib?=
 =?iso-8859-1?Q?Z5fIJTmjDrx1wmthU5JeXjRFsxG8vVc6Dmu9CcDqBjCVyOKpa/D3T+rgMD?=
 =?iso-8859-1?Q?oHPODnyiAnt+RQNIqsEFMchO9rbR503S3qELO7b+qbByb3N+/UyVOAyZuH?=
 =?iso-8859-1?Q?PJPBDMx8gBqbli/b7UU2pFMRc/CkZ18ggHjbHeeVB5ZXmShOxp7aiw/W5A?=
 =?iso-8859-1?Q?HbyOXeiqV+m61PlCXkAtYG23AgRhBFAEbdXs9JUkR1vwPiXHuKYXXmNzmQ?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?uyz4WhkLKwvIaeOt57TM+pCAWsVsRMKAaytReh1B65bgyHtgXYOLang5f6?=
 =?iso-8859-1?Q?gsJd3LWoPCo+TYcZFXcUtfmC0i3S1y4iVkB8vMxj+sE4HJtvldEHvhmCnI?=
 =?iso-8859-1?Q?4nbGkyL/Q5sRl7dXH8aIvhmF2oUEK1OB7TmvE+EeP4KLMT5+mbQVY6V2pv?=
 =?iso-8859-1?Q?5cgXLxE3rSmI787VfVnL0BBdisHI5akVh0T+oXkwnK8sW/aDcm1n0eVpD5?=
 =?iso-8859-1?Q?QEq+495xc5aROJO5Obw2uxL0RE1rqbOu8Exa/mGHGWQUBgyq7Uvz1JoWyl?=
 =?iso-8859-1?Q?PK/+RtYP4UFYZw72j0jmdZZ7FMDAQq0YlLYISSOjj0TxeChra/WnLpeUTk?=
 =?iso-8859-1?Q?Lv5z76AO80MKWW7FyNAUfoMtF87qwKJIf7gJwnB6snsEmQDmOhznPfIjBd?=
 =?iso-8859-1?Q?STZjMVZABXQis+hOgGhREFejxp0Cvzq3Qa6qpalZhtDXdzoxb30dRMxfbr?=
 =?iso-8859-1?Q?q7Y9rCBasG3h6s6brJQbDcY0d/JwmckaWUqLtal21V5GUCUXaFT+tCJU+N?=
 =?iso-8859-1?Q?Q6GT7qBv6jiCrZcBeRrO40I2nNyCBG81mMA7pQyt/4iAMHFyUkWcGrx+MT?=
 =?iso-8859-1?Q?74l6bTkI0XXrw2KImLpFNpBWl5ZdhPKk/guGnQ64kXYxFyVFg0h87eqD8r?=
 =?iso-8859-1?Q?pM5WGg0sum+GXf+G0JrIc4kDEMj7tCCotkdEg1lkD19w+W/m54KfPuIpBh?=
 =?iso-8859-1?Q?hr2EYOqek4cKgPbktpBg1O8Thf5hXmPniJQiXaYRLpTtRMrH2roCdJxSxF?=
 =?iso-8859-1?Q?+i3XhQMnE1OtUBSxWMZEAAbjZI4sHkKi13FVAFYMqNP6iHt2vTN47gcoq8?=
 =?iso-8859-1?Q?Y0YsXXfK5ZdkEwbg1Wm2VsNJQps1TScUljufp68473ndJjR7BwH+m9B655?=
 =?iso-8859-1?Q?0NTsPdRgbCZiKl6GKxKk9IUB8rftq+Dm0NawYoAtXVGJvxoB0kka7wMH/z?=
 =?iso-8859-1?Q?bR3U/q4TF/OS3GFS5oxZQyBizwE0G861ug+FLr5BGA1X/YIiRMJscsHgKq?=
 =?iso-8859-1?Q?v8UrvZodEIfYPKeZe3VCvKle0a7mOO672ACkxFfr3kJvgh86pStOgINnrt?=
 =?iso-8859-1?Q?w1w+Wl1gzyjoSySzT9f8h52xOecu9adPpFwEtv1RpSNK3LM5PI6Dov3Ljd?=
 =?iso-8859-1?Q?riB/0tY5YlYBUwROK2pVI5hsySoIl22dJTBNPVRGPI6a4jEQ0m5FKlbelA?=
 =?iso-8859-1?Q?WO6X9GT0WHHptDhKFObSFildp4lD+sG9jZmv8l6AjuIlP+ujKahF4tRXjr?=
 =?iso-8859-1?Q?hE902xA9L9PtchdZWXBfEcTbRuAx2XolzVLgxdqgaXl6xM7HWmPQOnjiN2?=
 =?iso-8859-1?Q?Iq6hWyX34tMArk1BcKUh1uPEnLevy7VqLJw5TinbdBHvfX1xOB1tbGPNu6?=
 =?iso-8859-1?Q?1d/QLE23oAn2n/7mme9NSRUOGHFPs2t5wpUzNsflYcVy6eLg4/XDWKrZoq?=
 =?iso-8859-1?Q?Ud5j4SrDnDm74ezX6xkDLKL9Jr0WazoJUN6DYbKJA1M4TBnBv1yJyaeQ3i?=
 =?iso-8859-1?Q?5MFRDjhilBh0oMcS0swCl9UU8WDvNp8HiVsQtzOzg/kX93Z1ahJdCVLvhW?=
 =?iso-8859-1?Q?lmnTB2PkzJRbgjWO9O5I+NrvAm1H08smVFnjUKwippEOpzQIYLWZZ9CIKV?=
 =?iso-8859-1?Q?8i731xtO1od8eX2wEwGLAGPe3xaxj0a8rG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e393b294-cddc-4515-0016-08ddfbca0620
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 00:25:26.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 386mVVWNTp7TEn5iEiDQW9ilXNFjjlNHRGHS+nz3yjPxvfwI4lNX7Y97KhGCXHp5LuYkYl+5YYJUPUud469HKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8953
X-Stat-Signature: 7zng66uz8fkbe836apc38jqy8p34z6cw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3497740005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758759931-184990
X-HE-Meta: U2FsdGVkX1+xEiIYwXVhGOZq9pyB2XGZ+mzK512WCmCUYn4exphjV+EkUDR6Nvs0usF6ogY+GlLgWicgQ3PuDAr9gFNnVa5yhQd1gBf6BsWuoYCMWdkWU6mN3U1JQ7aJCdcHXovrKcHR8P0dLB9rpp+1+bWcX7rYArwgzq4IdwKnfQYp9SZkg7kAeF5cfuCz3NTSVBQI0yZwXwELeFLHgQsHvXnBoWcbOMwRHpu195X6lV4mzjycioqj/8IKOVE5gUwS9rEyVd0gcsOzvXTMKSWdpzIT8ROPyDbCVSJMUUg93y8CCVY+xWozONODQ+gOlGlgNALiQrBavnJ5CTtLcuntbxq3FtyTBSHDql667wxIwTNLv2GjyD57XtFmxdcZJPKWYD5dWmGFdfkky6bixmWwC7jU/NpH61sAHfUMx00tHAOqH70fw9fvGBqWCbJ335QjX9s2S6Eed/RdzVwt7IvUotg51SYMf4nL8ieVxYR9Ld/6NFcJPfjnb93hcuiz/To5cXSRLxiJLjM4JiMHsd9mwwdQT0aFoiNDOpIOCPbM/+0GzWwExJu5PCK9y8PqxNhhhP3G66DTlC6JMhn7hN3ByngLSqcqrZd9wM4asW7TrPfn6S0s7CYVYyp3XKrmGTXimBg9qnStTAxgwsii28JOEJlnynlE42ncpmwNBFLb520IPLV9Y9xbwbgThaLJVZRAomH4O/AcrAWfPXhLoHlqq+glL5X6dpFupwpqX44Lje++UO+YNMK3kBTOFwj/hUG6XcwlXjYfqQeQCV/4fV+thSUtSOXxCJI5NNwgoEVcRaz/6yrDfHZ49t5MG7VXovOPdZIGkFMCMLPxqsG8lBRxJPsdXFBnb5p8S5VPYn+rHeOyQiJl50zaEFu5in+z3htJSzK+6qtvtHYwM+59qrQSgGDZzQlINGGuXgQQXQbvRWLysHsugBztu2ZjnTCDJNuVuBvwmE+PHELEmU1
 i24VnAyn
 6s2XF155R5Xy1n9hGf1r8ufZSSSxup91ovo7KAuH6BK6Slc4hpWk4N12mEzFXhyC2WD3FzNp3TwxJDxsA63JUq1XVSN640Y2rx8Xn5W02K1QMA0jXqVBhDT06amyUEiJcV45uaUpda2+UyiBxFSOe8nijSGJ9iwd6rnCcvfnqFIUEKW/Z1W+ijkSSCHA6qS2urfaOb0qOYzNyA7i2oISKu5A7O4TMOQMwm/HEzl3Jg316lxCK5ccCcRgrbRKVocpdCoc7AhaOMyEynyWP2qm34rETJbf2JLD2YbOgVq/QaHLcrrJ5H8LCbJyDysUj8zTI9R1wqycPtUYgISY904RHDJZaxBo3wL+C53Dm57p9iANeS+lp4Pn4XiMlrQoQuCOLriTEn2R+e/XQGrgUU25tHe1ytFWpwGc+E2WbSFuErFvWgTAYtyIoQFXVsvpq62PbnygDAFIubwDG7sYrRn1qlKZw1vUu8QiYDJpB1r2ifvCujR/IDv9OOQww58ctsmJX6aj90km44ZIQWZXHuCDwdSe+sjI2/+E3WhlUw8qU+J5bN+GA1fkbWRFzhNK6uJcSoeWvErZh1N68Z9QPJqy40fA7ZQUIIj9kwD/vsgvZjoQOZHIO4y1y1zXg2Rp1ROreRlJZ3TDTtYIqibM8VOeku8aJfiLX2OHOEx5r8v2Do5/T3KXIN4+ZgTULhCa+pWOqjIFD0NFTRxqjZb+AiOp92p+72Zclvzlq6XUcH8KznXJHH7mCUcRlyb6idzZrQWNFMhUM2rEymVDZNHffr4bAJR0whgNBJumhCLTTjRvgqYj0CU05zU/3/kbEr0089MZcNLK9igrmMDCRQ0nEORclUMPnVdGRZknFU5+y8qkxtj6+0Ik0Jggw0/uPKi7do7d59TnMO76dm0sOo5Y5IcoLellHJq1z6lE3eFPsXbCKY7efxbjdCf+50GSqUoG6AdR4SRF9iFbTzO0d4IT7o5H7nUWR+P2s
 sUIG5bql
 LXCY+qGls9b+EKdNfUF5AyZEkMFM52SMrh85KLgDTuc3StDUJ0MvKNWO1ylW0nBOKZz3upePalUictoBb06t+Gel/BEH+rakTvkY0nPISqOG7n6d6N+sFED6dDT6ZdhU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-16 at 22:21 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> Extend core huge page management functions to handle device-private THP
> entries.  This enables proper handling of large device-private folios in
> fundamental MM operations.
> 
> The following functions have been updated:
> 
> - copy_huge_pmd(): Handle device-private entries during fork/clone
> - zap_huge_pmd(): Properly free device-private THP during munmap
> - change_huge_pmd(): Support protection changes on device-private THP
> - __pte_offset_map(): Add device-private entry awareness
> 
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> ---
>  include/linux/swapops.h | 32 +++++++++++++++++++++++
>  mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
>  mm/pgtable-generic.c    |  2 +-
>  3 files changed, 80 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 64ea151a7ae3..2687928a8146 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  
> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> +
> +/**
> + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
> + * @pmd: The PMD to check
> + *
> + * Returns true if the PMD contains a swap entry that represents a device private
> + * page mapping. This is used for zone device private pages that have been
> + * swapped out but still need special handling during various memory management
> + * operations.
> + *
> + * Return: 1 if PMD contains device private entry, 0 otherwise
> + */
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
> +}
> +
> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
>  static inline int non_swap_entry(swp_entry_t entry)
>  {
>  	return swp_type(entry) >= MAX_SWAPFILES;
>  }
>  
> +static inline int is_pmd_non_present_folio_entry(pmd_t pmd)

I can't think of a better name either although I am curious why open-coding it
was so nasty given we don't have the equivalent for pte entries. Will go read
the previous discussion.

> +{
> +	return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry(pmd);
> +}
> +
>  #endif /* CONFIG_MMU */
>  #endif /* _LINUX_SWAPOPS_H */
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5acca24bbabb..a5e4c2aef191 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1703,17 +1703,45 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	if (unlikely(is_swap_pmd(pmd))) {
>  		swp_entry_t entry = pmd_to_swp_entry(pmd);
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
> -		if (!is_readable_migration_entry(entry)) {
> -			entry = make_readable_migration_entry(
> -							swp_offset(entry));
> +		VM_WARN_ON(!is_pmd_non_present_folio_entry(pmd));
> +
> +		if (is_writable_migration_entry(entry) ||
> +		    is_readable_exclusive_migration_entry(entry)) {
> +			entry = make_readable_migration_entry(swp_offset(entry));
>  			pmd = swp_entry_to_pmd(entry);
>  			if (pmd_swp_soft_dirty(*src_pmd))
>  				pmd = pmd_swp_mksoft_dirty(pmd);
>  			if (pmd_swp_uffd_wp(*src_pmd))
>  				pmd = pmd_swp_mkuffd_wp(pmd);
>  			set_pmd_at(src_mm, addr, src_pmd, pmd);
> +		} else if (is_device_private_entry(entry)) {
> +			/*
> +			 * For device private entries, since there are no
> +			 * read exclusive entries, writable = !readable
> +			 */
> +			if (is_writable_device_private_entry(entry)) {
> +				entry = make_readable_device_private_entry(swp_offset(entry));
> +				pmd = swp_entry_to_pmd(entry);
> +
> +				if (pmd_swp_soft_dirty(*src_pmd))
> +					pmd = pmd_swp_mksoft_dirty(pmd);
> +				if (pmd_swp_uffd_wp(*src_pmd))
> +					pmd = pmd_swp_mkuffd_wp(pmd);
> +				set_pmd_at(src_mm, addr, src_pmd, pmd);
> +			}
> +
> +			src_folio = pfn_swap_entry_folio(entry);
> +			VM_WARN_ON(!folio_test_large(src_folio));
> +
> +			folio_get(src_folio);
> +			/*
> +			 * folio_try_dup_anon_rmap_pmd does not fail for
> +			 * device private entries.

Not today. But maybe wrapping this in WARN_ON_ONCE() might be nice in case that
ever changes.

> +			 */
> +			folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
> +							dst_vma, src_vma);
>  		}
> +
>  		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>  		mm_inc_nr_ptes(dst_mm);
>  		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> @@ -2211,15 +2239,16 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			folio_remove_rmap_pmd(folio, page, vma);
>  			WARN_ON_ONCE(folio_mapcount(folio) < 0);
>  			VM_BUG_ON_PAGE(!PageHead(page), page);
> -		} else if (thp_migration_supported()) {
> +		} else if (is_pmd_non_present_folio_entry(orig_pmd)) {
>  			swp_entry_t entry;
>  
> -			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>  			entry = pmd_to_swp_entry(orig_pmd);
>  			folio = pfn_swap_entry_folio(entry);
>  			flush_needed = 0;
> -		} else
> -			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +
> +			if (!thp_migration_supported())
> +				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +		}
>  
>  		if (folio_test_anon(folio)) {
>  			zap_deposited_table(tlb->mm, pmd);
> @@ -2239,6 +2268,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  				folio_mark_accessed(folio);
>  		}
>  
> +		if (folio_is_device_private(folio)) {
> +			folio_remove_rmap_pmd(folio, &folio->page, vma);
> +			WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +			folio_put(folio);
> +		}
> +
>  		spin_unlock(ptl);
>  		if (flush_needed)
>  			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> @@ -2367,7 +2402,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		struct folio *folio = pfn_swap_entry_folio(entry);
>  		pmd_t newpmd;
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> +		VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
>  		if (is_writable_migration_entry(entry)) {
>  			/*
>  			 * A protection check is difficult so
> @@ -2380,6 +2415,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			newpmd = swp_entry_to_pmd(entry);
>  			if (pmd_swp_soft_dirty(*pmd))
>  				newpmd = pmd_swp_mksoft_dirty(newpmd);
> +		} else if (is_writable_device_private_entry(entry)) {
> +			entry = make_readable_device_private_entry(swp_offset(entry));
> +			newpmd = swp_entry_to_pmd(entry);
>  		} else {
>  			newpmd = *pmd;
>  		}
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..0c847cdf4fd3 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>  
>  	if (pmdvalp)
>  		*pmdvalp = pmdval;
> -	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
> +	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))

Why isn't is_pmd_non_present_folio_entry() used here?

>  		goto nomap;
>  	if (unlikely(pmd_trans_huge(pmdval)))
>  		goto nomap;
> -- 
> 2.50.1
> 


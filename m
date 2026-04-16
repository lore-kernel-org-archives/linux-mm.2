Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3D4F8E49B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031966B0088; Thu, 16 Apr 2026 19:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F241D6B0089; Thu, 16 Apr 2026 19:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12B76B008A; Thu, 16 Apr 2026 19:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFEC96B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:40:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E6BA1B8EE2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:19 +0000 (UTC)
X-FDA: 84666040158.10.95E9E3F
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013006.outbound.protection.outlook.com [40.93.201.6])
	by imf13.hostedemail.com (Postfix) with ESMTP id B17FE20008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nTesowU0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.6 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776382816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhmYoC4ODHDeyby25JBWiCrCvINHvQrEv1PMPYSB5pk=;
	b=izSk3Gx5FPQ3NQF9hmCnG+CwrzJRRx2Nf/CSu75B+fdFQHoGMj00dsrzawtDM5V7uwrPoc
	lUsfrVXwUaf4Mrx10NX571Jt7BPFtoS9+D+UqTShMFeSTYvdJDD3fdvKlN7TR4Ihp3Vncr
	52D7+L8pz2Ie6BzBpKBBwD3iK2zcK10=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nTesowU0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.6 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776382816; a=rsa-sha256;
	cv=pass;
	b=0JtsrahuTpZIsFAveOxQcwa3OQcKlL/AY88kDToc3mdcQiDl5cvgpPhDPMuKPdSjfCDNdf
	iQM6sw/wXUBm3of6MFLqNzqfRZqagJN56S+6UFsqxU2GYpkwcqr031ppvBqBsIoS6gPlgU
	UurkEQGZHfM5ZVAXq9K4TjFszAJXnDQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qz+K39BEpl8/GUFimN465wuaDSLPPd1kv1G3EkwCEMY0fRVjEamlNrq5I7C6G9Mc3eUHCyK5758Yd5ZQSgSDw7KbICU4gf432UHpCyePwfEq1v1+k59Dab91qCY/01QCCfrpBEcEd6/wLbjn7D8WujnLVEbeBStVkZ5wRIFGsnRKEexk/pVNKxsGDwdeAZeNltRAiR4TF8RyrQlsZiaBCx7mShATajPA6p7cPSABF5QMuyz1apP14q8cdxCCcQJB6qeKHY7qMdO6k9ThiTucFkPH55/7e63yk5OYBMDQdhOhTAsHE7g4DIlx71SzpdeFfnSauPSC6c9fceVOv/CLYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhmYoC4ODHDeyby25JBWiCrCvINHvQrEv1PMPYSB5pk=;
 b=xaW7Eif80Ww5nzx1dbC2L2v5uRzBGMcrMVUJydkb+F23+XIEdvNQ04CG7zyv7/mA845oLeyjGKeDWahLM9XQgFDV8k82gJsZPkKPYBwAgnw/N9yG783S7/K/FGlNAZnvhgDiiEl0zcDxTW56NUKI0IP2ccTADo45oWojiYMvWmv1XcOupAc+z2BOe+ua9toQ29JfG+z1u3Z+1dldYBR5ab4OoKuaeI10Eaxn4rFlfMh2kJoSyAEzCo0CHizWxLyOEwvyou5yY3wCkYY100zSiBCVBgJB/lNeydZv0fts188EHqL1OeS95a9A1b/Jd4DsmVL+bIwSkMeIulFQXhD2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhmYoC4ODHDeyby25JBWiCrCvINHvQrEv1PMPYSB5pk=;
 b=nTesowU0O4WkHqjKBgFph+z9OeEZE/YQRHFrSwylzcQ2zdlK5y58Uf8rNhIO5nLx3FMSFBXhM2My0khwIaejohRprffg54kzHRI6FH91k4sD77484b37kIZc70MHrWBNaHByZ7A3oUrngpM/LT1eiqVJ/39Ok3jF78Qf8AW0rvJQkK7KAd/8gBqnr+XflQkTPrc7r4JRBzShfjGWTdNRL5EPmHvQVhrcDwy6Dy+AM6yyySvmyNG+V1MRuiVsZonzPscqs63ZSENJUuT6uvj/Z5aVMdTStJfntKkHb/fOy736tFgPI8Fa4o0giYkwprYvO3TSqc/HEG8Ohc8LPHzgBw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.25; Thu, 16 Apr 2026 23:40:11 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9818.023; Thu, 16 Apr 2026
 23:40:11 +0000
Date: Fri, 17 Apr 2026 09:40:05 +1000
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>, 
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
Message-ID: <aeFva5qU7gSmlQpE@nvdebian.thelocal>
References: <20260410230346.4009855-1-matthew.brost@intel.com>
 <adxnwZMn-BHD5bAA@nvdebian.thelocal>
 <7c5cffc5-f4db-490f-b8aa-6604c32b34f2@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5cffc5-f4db-490f-b8aa-6604c32b34f2@kernel.org>
X-ClientProxiedBy: SYBPR01CA0155.ausprd01.prod.outlook.com
 (2603:10c6:10:d::23) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 29df0309-a45b-4933-fd3c-08de9c118013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4fs45Iv2esk6B9tH2c1MZ/CM+WGfR5F4rESMFVL03lbCAXfUFb7uUk2nFmO79UTsMtXByP/IJhpvf/ScZsiUMxMSZhctU4Il1zog2aP65Lh+XV75Oaxq8Q8pma7OcQMdt0KQVUEwmw1+nTrr9d3tr+YiLhgeXtEBt7fbhEddIDoukvahqAaWUs1CBBYSC7b1+e8kx/D8MD/SXhMCICKhuAt1a11dKT2vDiMggAQDQ+MBeAutRqwyH4WaiuvqJUihgV4rxqUu6WCq9be4uIoGDTYcBhhVOtIbnc+THiRQKlDQO/p/cU3QEC29vbITA4MtQUv74wkPHhwk3o20vLjTGV6fe2arEDdIwPNwV8NTO3yAILX35Rz8HS1WsxnxCb576rxjpFGWqjYlygm9Ma7+8ReMYbGAi3wU0lz/xMAjSVsiFcbtUIMc/Y2v2j+gRi7npHA0HqMj6cwo/beFxL9CiqU547khT62S2vcEduh9iO7H9l7qR2BOEirU8h4sdFGbYm/nNMclcE9IMlA0vK/7KfjEUYn13ryNIQyZ5mQxhVIywbWxuoudU7gLG/i4LExciAPtmUoTj9O813WyCVOBBDPL0iAZfe7HtEXuGcWdPUHadTl2mm+/UupBweIXzlerM1IY0qUkyPZ509eQk1aNhhwk0lBiKqm9zYtvg91W64/hw3V0FkCql8l1lTbameC2TWH2X2ivewZWPwpFnilUuaasTZJe8ZStDpfjG1zNcxE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fKZLQyYgG9laWF+KDS5YpOz02PpxbLNn3yM5U7fSDkWP70EpyHAH4bQw0Afw?=
 =?us-ascii?Q?mKDYQjUX+jLZdC9/7ya6fGbXEiORWMNeIaUBMhlNeUpBnLuWIhsCyHnvsrCl?=
 =?us-ascii?Q?M8pgMYxe7xCrk+5G76A0EGOWIEmEThPi9D30CDr3M3tbo7DlVfZuiXedAvLv?=
 =?us-ascii?Q?lHYGraEFvSIR8k48I1mt3V1uIUk/SpAnLvCBKeN391ifjzKQt/bZeoygiVSa?=
 =?us-ascii?Q?Q5FqUhlgGcGWYp8ZpKgFXGh0956AGoYTSOs0zg5YS0rdhVx6KwKhgEg8uuBX?=
 =?us-ascii?Q?47D38+JK0Gy72GijqOBaO+5aeRum9f1u9aQ/9KbCuwBfgktPeWwGRGI7Iwp4?=
 =?us-ascii?Q?ykv7IOoLs4qivJHE6d1tEwgE85qx2LKxpYHixPADYiNxNxzaD71nFtcSLyMG?=
 =?us-ascii?Q?Bh6RDfUl3/iR2m774AjEIKZPwVSe30Cl8UjZ+OLXhDe8cS5CAHQCguKF6HQv?=
 =?us-ascii?Q?OIPAKRyJEL/GpH6v5OLmeCBRZ4ZfQLVVqBYKVq2d+S0dbfWftGrVrlsYwXhu?=
 =?us-ascii?Q?d9NwYBzp3UrTv+sJfq1M1aJlvXdT/nu0zEj6cC9H/xUvn+dN0Lt6/6jtAfWG?=
 =?us-ascii?Q?ldugxumuG4NH9h642iINztB90xgNqTT6TZumlMJ8Jnh764piaRVI+UI7D4jW?=
 =?us-ascii?Q?N+xnmApaSLd2m6V6EdcyA+Y9Uuwbuy87s9oZuY1Clw8coBNBYDIiOnOpVXH8?=
 =?us-ascii?Q?k5KGyRp0g6XL9vRUG4zQJoZRZKqSHxT5sbFFXiRc2O3Gyq8tBCA8mPgRhqrx?=
 =?us-ascii?Q?uqn+S6n0kMn03MYp5eFakhyTYJipqoDc9XpxpK6loGZhJ7/b3Id1yAflGkaw?=
 =?us-ascii?Q?0X9b7q70O1iVYOZrrIpkYhyTMVTrfWmiV03bRjgauyv2oSyIxXmLmDAWo+bv?=
 =?us-ascii?Q?X820xZ9hmRvC5pfltyZzXyoq2mrWWs9P5UYVs6ja5//nNFVEy7xA/IZ5FSpn?=
 =?us-ascii?Q?idy4VS7IEDVvBa27k+QhHOzuiQksaRHa4bwds3DuwYRO92LDgDfgZ+XMbKkN?=
 =?us-ascii?Q?pHW26xTvWd/88o5bOnDj7RT1ahRULaQVDI/d/RVxAPyXKD0l4M3kBmvQaWrj?=
 =?us-ascii?Q?tagf6RUAThWjiySKF2wNT5jK7DwGoRGFbbvAJB7QyQ+c7ZWGl7pB8JQ9gDie?=
 =?us-ascii?Q?FHM8C4Myaxh9d/znDLLlUAucPn8rLM2I2AgK69dXBeKwIcMvsGmLD+NwcxJd?=
 =?us-ascii?Q?mxE8IrA+HlaEqegnnxbzVd8QHr9z5+YMB9UAoTdDi8nFO7HHwA1D0xnKhLOD?=
 =?us-ascii?Q?fx7OG/GNDbMCEkjl8G7d7zG3j2eLIAggbWmJcuzKjIv/nqeGy0L83viOz2Wy?=
 =?us-ascii?Q?XWu6VoGOj9Q3Pi6aEomkH5gZZmSCcLeNFAY5avlBTNM1gmtLWtiFgqBqO3B1?=
 =?us-ascii?Q?c+x/P4GCdDkiOsfHEx0JlBdaD7/nETLrC7WKVe6AWwyDQ6mZfyZgLj7nqJ8q?=
 =?us-ascii?Q?6yyERy9pXJwd3xKMydaov+Hdi/BetsKqVATz5FXD+ADCinm7vNvZQoCAZnYu?=
 =?us-ascii?Q?E571pKnNIV3gR4mF92v6yhLcedaH+Q6LNC73xNv0iEysdDWRN6XdzcwQdIXE?=
 =?us-ascii?Q?fwEcvsjWmC4v2gr23A3NtPf8HX2W3YxzaBIYfGnrhQo59TFkooCSLR7S19fe?=
 =?us-ascii?Q?/TRIo76HJtlVZWGqdyzcupgdaCxCzJ8mDdI3DTOSPGmSQ6vzx3CtXtBph3py?=
 =?us-ascii?Q?Tjqr1y7dBRZCMWX85E8tj2d7Pep3pKQSWcZsLFC8YRP9+bAUIakiIMmtbGwl?=
 =?us-ascii?Q?heOjMWCxCg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29df0309-a45b-4933-fd3c-08de9c118013
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 23:40:11.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLkQdWXEuibGbzIkQkebha798vtLVs63/9EKhj/4VetAThzBSjaBIngL598p7r7m+hn70rohhfHdaYw3c/ATrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B17FE20008
X-Stat-Signature: nkndr1dpiu8j1q95o9nd5wb6q7p3p3bw
X-Rspam-User: 
X-HE-Tag: 1776382816-325749
X-HE-Meta: U2FsdGVkX1+2nIQ1Ga9CVj0oNXYOqFJH+P4MJiMYqXizMunwT/TyoLCUBaxhGewcGbpIaVX5By/LsSmEbtFRoD7BqfUQWAZIDB1+I4uvblhSzSN0AXWfq+6Ps6Ixe+6vBdJ2qjv0De2wkhtznMp8gFE5Qi70UfCyKsrYNgbgpYrD9sV4xdSJ3+lUvHVb0A4KU9GcWG48gYiamt+STHsSEaQ9jNQWiNkLA2nQ3HesUrFHJlU80aFD+J+zVqTFH/EDw5fQlQlDw/3uh2RtL/fYsiB78+vJZhsmM/dwptJsYKEm00qBxvprW3Lr3oAcL8w3Memo4Y1W9DNXrwGPyyJK9Pl/4rhRxkSXxya8uU6jE15sFL1r9EF6H1Koridvw1szc0Xy4J+Xw52+RBOJt+fJKLMtitoz9luJdDhCJpy5n/zdIt2SDmFeO3brtXDA3Wx97v8OLb/DxcsH0tyVmkPci5I6ehgcBmZp7hGuRJFx1ynPMprgf9aCnisls2GxOmxLMK7ENFOHaSNAkq4fZ7hAnC/hbOM3bZ12bTMRce95dUIEHFAmEIVCuNQhbGRN1wYWh7swYQCOW9NgjX2C5yTJ678/0s5q7TfwGMR1VC6TVQUXoT3qApDNJmikMpH/3E/EgmzmQKSemy19FIib+qCpa9IE22VcWrR7it1hNP3x8jFgSXjrv0lk18K1cCzoLAi33FJmlgfCSvriNb2855P/DjoCWM7rYni11FIyn0XhzFjJ2dUP6nkbUDGsUzkkvVU/uk1ncpG8jg3jnef/yjAAp9AjbXGX1ATzi4j1v7u+fgKbYgnlgReYy40wWWV4SBZxjmKdjgK0/Q7EJaRYaQ8Rb4XAln7UTanS4Rwj1BKZVD288OF3ReH06dpx/5FwJpmIjesGyi3qipivEtoGcFqEvulefJCdysj8r5fFWE6m+IfHgleuv1aksxOu6yN3TIcZn8OPoTt9V6V10VmCvFv
 4TtcJpw3
 FTiebzNR1gF6VFNXzTbJnVCoICN1CSd2x92ENqdRx5rBB/h9oHqHmns3s02fo3p+d2GZ31MCuCDTKdbITXzMOS5LrWPh78kFedNBbJbf6ZlEpqnqS5tR6Kof7gbTaeX91wD4uZsqYLTNIOKVAxAy2GqnGiO9wjYUusUbuNjA6lP3/k9x76X47ST+5FjSE6uWfLc6rnqmsc6On3adINugrQHjOD97L1Gvvq5u5QOGlE/PPISZsNxW9r55pwF4vUzZyvDaXVJUKZcQfTHwvwbAPNN3gau/u3MHQ8559tYSAjfBB/TqQCxamHmKVMe0kM0NYT6qmIKOQqePgQln1eunqKRgkePAudUI51//tEXG5URMgKphywpQf1WKh5xNTywkfea4z81TkK32Z+lOxPsNjNvrM/XIZc5Dpck7+0tVv09A1qfiFZi/EKrZJrBxDy269IRYLqR/xCEO7sxnNEkagCuJohZ8Wk8O3sd/FvOhRLQ4KbQaX5zl8c3FFvYfZ46uskHTLlnbJGv9wRdR8rOx7ISWVS/kxP9atSJTnzTjlBE5Nul7IFYXY7tlmOABLgOcKcMMtGbItZPElf0BLRxvaOee4IpiOI/x8OOXP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-16 at 18:52 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 4/13/26 06:06, Alistair Popple wrote:
> > On 2026-04-11 at 09:03 +1000, Matthew Brost <matthew.brost@intel.com> wrote...
> >> The contents of a device folio can immediately change after calling
> >> ->folio_free(), as the folio may be reallocated by a driver with a
> >> different order. Instead of touching the folio again to extract the
> >> pgmap, use the local stack variable when calling percpu_ref_put_many().
> >>
> >> Cc: David Hildenbrand <david@kernel.org>
> >> Cc: Oscar Salvador <osalvador@suse.de>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Balbir Singh <balbirs@nvidia.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-cxl@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> >> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> >>
> >> ---
> >> Stack trace:
> >>
> >> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
> >> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
> >> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
> >> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
> >> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
> >> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
> >> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
> >> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
> >> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
> >> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
> >> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
> >> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
> >> [  632.400919] PKRU: 55555554
> >> [  632.403605] Call Trace:
> >> [  632.406039]  <TASK>
> >> [  632.408131]  do_swap_page+0x146d/0x18c0
> >> [  632.411938]  ? __pte_offset_map+0x3e/0x190
> >> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
> >> [  632.420053]  handle_mm_fault+0xbf/0x250
> >> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
> >> [  632.428256]  do_user_addr_fault+0x168/0x690
> >> [  632.432399]  exc_page_fault+0x74/0x200
> >> [  632.436117]  asm_exc_page_fault+0x26/0x30
> >> [  632.440092] RIP: 0033:0x5587554ff70d
> >> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
> >> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
> >> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
> >> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
> >> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> >> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
> >> [  632.502547]  </TASK>
> > 
> > I'm not sure, but I think Andrew likes the stack traces included in the actual
> > commit messages. I've certainly found it helpful when debugging traces reported
> > from the field so would prefer it there.
> 
> Agreed.
> 
> > 
> >> ---
> >>  mm/memremap.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/memremap.c b/mm/memremap.c
> >> index ac7be07e3361..053842d45cb1 100644
> >> --- a/mm/memremap.c
> >> +++ b/mm/memremap.c
> >> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
> >>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> >>  			break;
> >>  		pgmap->ops->folio_free(folio);
> >> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
> >> +		percpu_ref_put_many(&pgmap->ref, nr);
> > 
> 
> I assume the ref keeps pgmap alive, such that that cannot go away after
> the folio_free().

Drivers keep the pgmap alive by holding the initial pgmap->ref from the
percpu_ref_init() initialisation in memremap_pages(). They release it when done
with the range as part of memunmap_pages() which the driver should only call
when all pages have been freed (at least for PRIVATE/COHERENT pages).

In practice we could drop the whole pgmap->ref counting for ZONE_DEVICE pages
(certainly for PRIVATE and COHERENT variants anyway). Now they are refcounted
normally we could just scan the page range as a BUG/WARN_ON check to see if any
are in use. I haven't really felt the need to do that though because the check
already exists and scanning the whole pgmap range for pages with a non-zero
refcount would be slow just for a debug check.

 - Alistair

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David


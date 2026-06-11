Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69883CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2C46B0005; Thu, 11 Jun 2026 14:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73B96B0088; Thu, 11 Jun 2026 14:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989B16B008C; Thu, 11 Jun 2026 14:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85D1A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:44:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49E91A0774
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:44:44 +0000 (UTC)
X-FDA: 84868508088.04.BAF4777
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C5A01C0002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:44:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nP3JuLd3;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781203481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50pmpMkiyb8VL87ydQG/hNCE0l8OGczBOWVY5zMAy/M=;
	b=45lRRYtipV9PviLVxW8033rXIzbWpX1huGpbRZ/IQ/HOlCFcszB12o+SiTbo82UNk/bNLV
	DExewSffQrny+IZ7Qc/mnj4xuA4ca+nWH9NSgjxsvCzJHCLomM07kj3tLLDtFk/+vmyTe6
	r43P+ZTME0QBDFZWyYpGh1zYm4mQHZ4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781203481;
	b=VBVOt0AkeonEwPaWQX1JXZryYZ/TU6+fhf97zJelcpYxd2G+n5pQngMkcYsSb1mDBtcOI2
	luhIi7UAZfVbZ0P7j4IGuEtYMLduK0DjANqllxVm9dp8EfXGurGFZgbqwK0z2wmfhXnfur
	G8sHhWy24y5hJRQ9thniH7bQpocTvHg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nP3JuLd3;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lIWW9JehwTB61Tp63sSKl9gTiTZ1gPM3E8F5yA5tPXssVuIWVFjsgB92e8LxgEHzXa7U5UFjI4LcuCVfq4LKvIlxB5jdZ3dkO8t4IL0m65Z2ET6s/fEAHOpDnckhjM+m6j0j1C1E8M/9J4spMam4LCMpbP9toa0KSKFLL7EgJ55OR8yya9ypZgUamIAVOp+nevJhrOjJ/ggRMvDH0BCHImoiHSmcjHg8jPegjU2Wc0QNzm7UVbnohcf/n5kLVBi3NO1xrk/Zq72Xmr3VeBMnoMTTTYS9jPyHeASCPJXX5AVNibRzq6v7NlxCWENz0hudedBtohqqMvEDTIwImFCPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50pmpMkiyb8VL87ydQG/hNCE0l8OGczBOWVY5zMAy/M=;
 b=MW/P5li6TIAz4ug+jDDlfrh+gK5AMzVHaFfdB1bZh22NgYTJA4sKrHuPrEpEVXL5DMT1DGpfV0AtFvXuDaOC04uRuRArmvtEvlaOp6/RK6LtlBacV09KQiL7ghlow9msJCpAMWh+brgywYaKuF7zyJndgZYkCPVVuO1qmf4S339eXWZlzXzrEgtb04umPFzN60VH01r+vYXELuZ72kBh/PV9yFTQJXCqD7HQzbGCwOWE3IuTs/k6hK9pA9mHW5Ag6ncov+7aVMCrvLL6HXY4JR+Bs/p/Q+eZqLoNcwTpbCOMG1b4oDXs3+3RrTnofmd/6Noenxm0BvnmbNJGZRaNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50pmpMkiyb8VL87ydQG/hNCE0l8OGczBOWVY5zMAy/M=;
 b=nP3JuLd3RKB6WixiDgOXhlOHJ3iRCWUasKcowkAl+/Z10GtibfUoz0sjOaqUslcQjgX+jZGTvt81lAqyEEpIwfYg+z+18ulY49UsoEw9KIt6yycQidEDSGjTXPPS8j9cZnsz94YLxL5oRkqgDTX6JtmDUqyD+uQTLP7oQHbPUbHHPWYDLvp/nrH499sGwNk9vzMAYFrsqk4rBV6XRDgZZUDYgKbf1oX1gSZ+62ZBej0C1ipqbr/Ynv13rp/Vbf4NIbZLTQ+iu1eYnaQm3HFm6bRlJpq5MWC+T7uVuvM4Yy/sVY756Yl2h8pHUX4SSCDbLfSBYdxXkZ9cfmJuaidH3A==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by PH0PR12MB7981.namprd12.prod.outlook.com (2603:10b6:510:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Thu, 11 Jun
 2026 18:44:32 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 18:44:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Karim Manaouil <kmanaouil.dev@gmail.com>
Cc: David Rientjes <rientjes@google.com>, "Garg, Shivank" <shivankg@amd.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
Date: Thu, 11 Jun 2026 14:44:27 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DF2E1331-C20C-41E4-8D43-136665E0EDBD@nvidia.com>
In-Reply-To: <20260611095537.cyljpqekjbjc5jqw@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-12-shivankg@amd.com>
 <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org>
 <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com>
 <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
 <20260611095537.cyljpqekjbjc5jqw@wrangler>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0012.namprd14.prod.outlook.com
 (2603:10b6:208:23e::17) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|PH0PR12MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 9111f055-4750-460a-269b-08dec7e9799e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GxKdF50VlYJEoBHV3UBxXAzc7VMGUE0l+any/ikx84G+P3ClJzayPu+2sCITz4sILk0pcE3zVWwTZW7a8nXn0ZksUkKx38sw1n12h/UQHsMQs6J+ylJYZxsSJa48pPNXafuAuLgQkyAiLAZqvjCqOWKaVc1KV3mNcQyzcQQUxy2NKGEjYtnzdo2w+E5+NSbZH/fDdhXD5bGqB0fGegqAS0+nztpC4lcgYgNylLz/9KrmvoV2iYH7WD7Cu0wCcuJvp5ABCsy6/9ApoFQOahe+Fs97EfvkKvJq5WzQQoEgM0o2o2UetE2tchtrHvUv1omKN1bc1vYLkFU9BO8RG93i2FkvOlavW7CGFKLyniyj7tV1UJ3D+OMAxpSfjkAOVWAIclJ18ziUmcSbzfjiuwJ5kyPIBV+XwWAXdrTplHXpiRoF59zoLa3ZaywgvA6K0aLkXVR2B0pxrwJ2ONoDqlWeaceR1hZkqGMwFGB+cF56NJNjnenf+ZjJG+CeHvAQtoeM8FNn5Waos3BMyZF+K86jRKT1vS5chgjBvurE6Ltf8F1S5o+UK0aJiURCwNJXrAjC71qriZoFwzSu6+cpjhZMHf3CVavp1a+5g0IKYA1h4Skw7lCDeatiYs9Z7Eu9r5qWaJSHucPoh0Rm//POcK9G+nKE8oCsMs2kH63K8EgBrpwRtRhGdB/NemDh1udfXqxd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iLI99fiT5aD2QZlcGok6Q9vtq7KICJ8dZftyXnN5R9JQ1ONoCHCJKQdAdIgJ?=
 =?us-ascii?Q?zEMbtuhfSLf6klrKtuTmmygrsRKdIDkfhizcRZnfQMmvfQIu4QoJDWotYo21?=
 =?us-ascii?Q?sFO7arGXXTXTqn2SaCsrbfGYgHlKZdif8LbcIYcpsfaPgsjiQ/U+JemhAKoz?=
 =?us-ascii?Q?Ajh7VQgR66KPV+KyKFRlkKzHTIdpujkVegmnW1RuR7XpsbecSrMcz3dRKmh7?=
 =?us-ascii?Q?XmTBzZZwaho7jMxMo9TaxQnM8bEmPkcKVAoCGpfJc8YC5YHu9lEI+QQUx08w?=
 =?us-ascii?Q?C89HGbUu/H94zJNRVb6X5Fj8W4OL+uUOEGlVGqD+9fdfAZ2rk0hFWFndXT76?=
 =?us-ascii?Q?d4u+zrq0yEW0DjnAgRhm+0t7Ptxe9ZaBnAlaCWuSlddF8xjvSAJbaH/mhnzd?=
 =?us-ascii?Q?Q/1JMBZNsLHmq+9lYQrfN6evylPUag+b1bPE91WMIvo4EuJqcNnmJ724t0XD?=
 =?us-ascii?Q?Cgjyk6rIXqxuHLzYu4t/0+pxFOG3M5LzzgcX3W+iCLMMra5dTTgHrDKINQFi?=
 =?us-ascii?Q?PzjGA/x5JWzGLxQl+Tk10pXX9FL0ec5YemEesLze6EZc1g6cx6nlr4OdeO5G?=
 =?us-ascii?Q?9wJHhSOhVR9SWeFb5VFFtEwX7EKZCzzf1DGkyEt4SoshNxpQQU+ErmNKpNx3?=
 =?us-ascii?Q?4ysiGQ6/FtN3cLKFISwBHV32eKPx1z7VBPcvOLNqWGUnAUbgngM50UAVI2Zx?=
 =?us-ascii?Q?NDirr8g7qy6+Sj2o3JyHpwNd89pt6H10CD0syzCrlzRDQnjWJu5tUMelHrx9?=
 =?us-ascii?Q?mWKHNvbwN3QDvNRfbnMEtExcVW8/RibIJ5CgsnVuKX4cXuya3rtAwgtHtZsU?=
 =?us-ascii?Q?szi0Uzf8w17XBiv23FjN4qR9+HnrOiJQntyUOi8Yy83TN3QC/pZxAjTsCVPS?=
 =?us-ascii?Q?kRLqP9B8y5C5dPuMXrtYw+50i/n4cdKPw5kzhPwhg7OIfBFYQQwX5T3mUAP4?=
 =?us-ascii?Q?aLSeqRF6AdCgoHBjq3ErZyWr3WwpG/p1LO9a73kVQJICWz8fN7vU55mwXEqZ?=
 =?us-ascii?Q?U31TYDDMIucBXvmc6G7TPgbiBLczZtpJ1My7MYePcyXxVDYFRLLXnEA8SF1P?=
 =?us-ascii?Q?ed9PFUtk23K3+VRZ1iwzpPjZCzx86YOlLJYH3YR9LUUmeylS4eEhbKm7qr1K?=
 =?us-ascii?Q?1Fb15xyAeIdp4Bi8LtR/jyHgPbtDVTcPwwTpsaoO1fjACcvHdXmPXh3kweLd?=
 =?us-ascii?Q?FAdjV79sZbAIuZQiKwvRQCS1smZv+2/OTgqWWRNLPQ2XOgnaUF1voLZKcWee?=
 =?us-ascii?Q?3NYCYfqSdKpsdvAAYJU6ingregojSaQqT7oWpx+1u31O5K9fd4jCWJQkI6tR?=
 =?us-ascii?Q?+f5R7o1DK5kLwVxqAJeHO9AWUwqB528wRZ44XPHnYhmQ9dph94T+OZ4kCF0u?=
 =?us-ascii?Q?hmmantvFxQ8bNbNR7VKuGZG2Qnh9LntoWtohm+QRXyFV1fq4kM5TvO0PT6oI?=
 =?us-ascii?Q?xfIlpcsJSzfsEKV4EiMmDaDpab62ZoxMLMIU9MNVVofMNjQ+9Ree3l2qGYhK?=
 =?us-ascii?Q?ucKJksxu/AqAyV60O+Dbcpbnv7T54alIHe0z7PAhrO3Xn6ohRjxH74dCN3Dv?=
 =?us-ascii?Q?sujUCi3ItxzkPjKeb0eqnqCg4aw/nlJMrLi788EqoifLpo/oe6H1AxG9k84C?=
 =?us-ascii?Q?OhOxRfbvVKCHkvjCKT29Y/OwC1eIKm9I7KKrbWPu+6GPVCrzB6g01/hJ26R7?=
 =?us-ascii?Q?qdgcArNmVmbT7d7EV1NjyLlrve6F5wWXktoCkgsFemmGyvK1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9111f055-4750-460a-269b-08dec7e9799e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 18:44:31.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aw2rp/rL/7lZv/VMOVHBJeD8iZvIs8Dp2lj0mRVD7jIFri4C8+QQGjqpBauQtL0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7981
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C5A01C0002
X-Stat-Signature: nast3guer5dg4kfthjcwkwkssz5gge6s
X-HE-Tag: 1781203481-606564
X-HE-Meta: U2FsdGVkX1+H/rcfFpn9ozuYrQtaY57B68WI10D7nRFiXExZZ0hQNW2abRo9kzqouYxjONVVrwcOkfte/nY8gCM/6ZlGb/HJUREct+3dD8dji7XDkqtUrwEEN+bVQw6ShXKDOmXmVycd7DlsCENXVC/ojT2DcavRCgXpX3o4r/5DOH3vx+62wGPCC/djhubgeXdixJp9/L3NgXcwoKNBfQPwrnBOAguCs8GOWsJZDyoTMpdO4d9ImPOAJ6pWF0n98N64mMiCHx8fJBcX2kuoaGoszm5teP50kuTSeC0uOSRJ/SJ63cETVmwhCR/7AXZmGru/HBmLf847rsLIGww8WIsTJw77EU/XLhZryDH/jNqAtffnblUxXvm9GbXk5AqRFoBcFKS9fVDXgAhevTZ7UeQVt36o22IIDKAt8fSQbOdNk4ekxUMR+BYcP9hfsJnqNHYbOhydK9soH9iFKiXswMj26ivx+JZ0TSfFa0vdVdAm3nT7FVmrt28jqmgigSKg2htMWOg5gHUNytaCv5DwnYL2L6W2wf45X7IrUeZqYlqjfURkxWIQ8dPH5qCXiQ1zFFeLkg7c9tQzchzISza6OPugm9KLaPN2qtXGFzpk3+Q9h2Kyxme/dEKduDY8UHMRHUZutD0DJkpzknKWoTvQ5FHb9UlztkxRyl+/ItAN99oJU8lk/B0WtKoIv4OA+U+JhYTk+bZlHtf52oQZkus+7ks+wGoBq4mPwfmk/og/QWd39hFHEz23w8IARAq+fDC2xIEuRbGYypdWWphFX7EcBgXU9iUEGMuB5xWn3RZ6qzFnVWV24clx08L6zcHFvhbF3j8A5RYTe1QrA9HU+j9QLzhg4l++1qIvDDiH3CAxiDbULXbL6qWSfX5HiYvfAYm5TCfFikwuVtiby7J75WgtLvY1B2d9YBrBlRrgKGE/Rd074E7cFdY3TuUUzEqVEFMKWddI7+F7QH+SJttclaD
 8oi81KJX
 5iz70gAlUQ5NLilv8bdVJbls2FizGdFeVk//OJMSKB/A52B7HzpA7lVbdkOVe03hfk/rSW3RsqtYFEgLBGw3bqKMrt/KTYH5NYdKxaTAZeFDVfG3/rmsvQbrKQjwf1LlFjsnyoN2biUNYBbPG+V3ICHJZEv5UnlxTAqQlIm+FHcs3QufZphXYIKHHuUjbt6mjaeHHV9zICyVFRZa8Zvb6Jqf3ntO7eR4vagNAaqq4w123UlK8+qZU0si6lQkZWXfdF9lRBXOrldjpie1MK3+9Uw5NSfkzRETYOmcQNXaJbgQqj5L/8E5PXRopnsmc4P98AnWDnaJ5pFFVgyZFceELKCWMnUyUURVmc8jwjTGunHSCoO/deKXAn2p5tV9931RD/hkZG3lyG8tdaZxVjwRQ8EuOUlQcnImTZv67nfZv4Zno0tthU2QpvAuOC7G92H0WRyB/brUlcTIUCO2Shwl/KjT5lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jun 2026, at 5:55, Karim Manaouil wrote:

> On Sun, May 24, 2026 at 07:16:55PM -0700, David Rientjes wrote:
>> On Wed, 20 May 2026, Garg, Shivank wrote:
>>
>>>>> +static bool migrate_offload_do_batch(int reason)
>>>>> +{
>>>>> +	if (!static_branch_unlikely(&migrate_offload_enabled))
>>>>> +		return false;
>>>>> +
>>>>> +	switch (reason) {
>>>>> +	case MR_COMPACTION:
>>>>> +	case MR_SYSCALL:
>>>>> +	case MR_DEMOTION:
>>>>> +	case MR_NUMA_MISPLACED:
>>>>> +		return true;
>>>>> +	default:
>>>>> +		return false;
>>>>
>>>>
>>>> What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
>>>> this depend on a reason?
>>>
>>> Reason-based filtering could be a requirement for some users who want only specific
>>> use cases to go through DMA offload.
>>>
>>
>> +1, I think this makes a lot of sense; not all DMA offloads are created
>> equally and we may prefer to unburden them from being contended by
>> migrations that they are not intending to accelerate.
>>
>>> For the RFC, I introduced a placeholder to enable further discussion on which use cases
>>> should allow migration offload and whether offload users actually need this control?
>>>
>>> Your other point also makes sense: "If someone migrates a handful of folios, latency is
>>> likely more important (and batching less beneficial)."
>>> Based on this, we could either fully rely on batch size. I'll think more about this.
>>>
>>
>> There are, or will be, some offloads that must be used for certain types
>> of page migrations, like Confidential Computing.  That's for functional
>> reasons, not a heuristic.
>>
>> We want to use certain hardware assists solely for promotion and demotion
>> of memory for tiering.  We certainly wouldn't want those hardware assists
>> to be inundated by users doing tons of move_pages(2) on their own or by
>> best effort memory compaction in the kernel.
>
> One of the biggest arguments against using memory-offload accelerators for
> generic page migration is that user-mapped memory migration is dominated
> by rmap (unmapping before migration) and remove_migration_ptes() after
> memory copy. In my experiments with Intel DSA on Sapphire Rapid,
> assuming you're copying 4KiB pages at a deep queue depth (64/128 pages).
>
> 	1. A single instance can achieve up to 30GB/s when counting
> 	   only descriptor submission and polling for completion.
>
> 	2. With DMA mapping overhead, which you usually have to do when you
> 	   are behind an IOMMU, it's about 23GB/s in IOMMU passthrough mode,
> 	   and 17GB/s in translated mode. That's still more than double the
> 	   throughput achieved by a single CPU core at around 9GB/s.
>
> 	3. The throughput drops significantly when measuring the
> 	    completetion of the entire migrate_pages() at barely 1GB/s.
>
> Unmapping is about 50% of the total time and remove_migration_ptes() is
> about 40/45% in my experiments, which leaves only 5/10% on the table for

Do you have a breakdown of unmapping and remove_migration_ptes()?
Are these 4KB pages shared or private? I can see that a shared page can
cost more during rmap. BTW, I assume your measurements are done
with migrate_pages_batch(), which performs TLB shootdown once for all
these pages, otherwise TLB shootdown cost would dominate.


> the actual page data copy. You're not bottlenecked by memory bandwidth
> to justify using a memory-offload accelerators and the CPU cycles you
> save from offloading is too small to matter.
>
> So any discussion on accelerating promotion/demotion using these
> accelerators is useless to me, unless I am missing something.
>
> Like what kind of use cases do you have in mind? What kind of workloads
> and pages you're thinking? Especially, via migrate_pages() which is
> largely involved in scenarios involving user-mapped memory (anonymous and
> file pages) and thus heavy rmap involvment.

A paper[1] shows that using DSA can improve memory compaction speed and
memory compaction should migrate <2MB folios.

[1] https://ieeexplore.ieee.org/document/10841986
>
>> I think the use cases should be configurable by the user if at all
>> possible so we can control what has access to being offloaded.  These are
>> often shared system resources and can be contended like any other
>> resource, so configuring which migrations can use them vs not use them
>> seems important.
>
> -- 
> ~karim


Best Regards,
Yan, Zi


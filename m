Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A476CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 11:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787038E007D; Fri, 17 Oct 2025 07:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737708E0016; Fri, 17 Oct 2025 07:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8A58E007D; Fri, 17 Oct 2025 07:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42FB98E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:29:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0FC5B5796
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:29:00 +0000 (UTC)
X-FDA: 84007384440.13.A3EF257
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9FB5B1C000B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:28:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TrRoaZCp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760700538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3B/mwyFvSXy9/uNYy34CNtEMjSwA+nsrSEhjnxDt2E=;
	b=Y65cKLbWcpqnpkb+P0bon/t+SBwTcAzrMkSLRnNd23q0qiv3QdcuNX7qHlIHLDCXLJWSes
	EqxBqO2JNX+MqfONFepyoyFGVCHFPVQWMHy9DY5Yn6lzaFCfXr5VILv6QFL8wD6ODJMQPy
	w+xQBVTmn8W8+YYnhyNIJd8W9O8nS4U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760700538; a=rsa-sha256;
	cv=pass;
	b=7gvqd70QcwF23GXG3PePD/KwQgYNDhmBDTc/RbD2nHDCvaHU0+YQ8jDmfIBaYOTtvJyVFM
	7MbtxfPJ9zsmgtw1jf5554YS+5p5yzHOb81Q2NvauVP/w/oklFlQqnz+rw9HceesoWWGNV
	6hIObPO4YsMd2+fs1RsEXorCSjt0SJ8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TrRoaZCp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RJmet9hHg2aLbkzYinOU3FTB1SIZEm5/g9QlrON6lcfFNgMKoN4co+rnXj1uoz5tCkXp0AFhBAEX9YeW0XND8nxMoG2/J8Dam6eI23UIHalNP9kAXkmTcLkFSIQtfFuid4x1ruCM89O/WYhA9UcwaeZ5baLjpJ9PlNwgPv4Ss0DfEhI9YPmzYRuBVSLRlfomtuPa/oOWzaf/cCe23G/rJMENR9GWETp/0OLzb87PSgdizKusE/JbJ5nT8GrfiM4+bfbTqiMWDWLNwaXSuYx/QeP+Ni0agEHzc9SQ4vPoqMyZ8RKf3fu2TPP8bXl4PV3w9RhGnU2v1YVQYeJMJgIlmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3B/mwyFvSXy9/uNYy34CNtEMjSwA+nsrSEhjnxDt2E=;
 b=aGmtzb+hiMGZD1EXDRBVs5J+ZMROvW+i2pFrtBefJ4SGC2F5hfX9EUz6F76WyoZTz9SukmPxj8aGm19VHtRL+PZbVi2FTDtt+6lqJsGga932LtyIVwinDJXIGXiHoLGINOCirvVlAuIes4TdhSXQ8xsSUpKtyOs/i9EoXj2KS3uy7eBlNq8N5X1PevCVAM3sxu39Yn/Csgt8XzN/6UCipeUD0Y72gsFKqBJwZSObowSPFusAXrDsHJRevbQjsqjpojaOiEuogG7nFHv/5Y5ht8R587L6oL4HitKxMvAhd4Z3gAglHI8SRbF6cZfvTlmGsVFH0EkTjIUX9SldoRUIIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3B/mwyFvSXy9/uNYy34CNtEMjSwA+nsrSEhjnxDt2E=;
 b=TrRoaZCpnuc2T4IhSpwrs/W2IlF9hAkUbv7zN8zn5NYh1gYp9p8qn9P+uTFwjwIrxjlK9EwSs58UBYlE36s9QvZcINMkzf9FNNHnXq/xrCcqI2B0ToND7D5uWYIolwIl4BvTACqFaeKhJGcGL61GcDaXqQ4O1IuPRerKuBluuGJMz1jbIX1jyN5f1Z9y/4S4Gz4N8FJQjaPAngdqZPEoiYgSSyqWaNgGHWkXTnQOlhZLgCFD3BzoAXEpZPCp+9gKFAPyGddQPj/ISOvJoGELcu9I6g0+oXjDAFh+fF7J1Bz9+x5ioxnSTY/6r2SOtZwo/kzoR5RcXFdFvL3l1NI4iA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.11; Fri, 17 Oct 2025 11:28:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 17 Oct 2025
 11:28:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Date: Fri, 17 Oct 2025 07:28:49 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D17E5D2B-980C-462F-9B1D-FE26F01D3A9D@nvidia.com>
In-Reply-To: <24b02541-d880-4a48-a11a-23e3e0427f54@lucifer.local>
References: <20251017013630.139907-1-ziy@nvidia.com>
 <24b02541-d880-4a48-a11a-23e3e0427f54@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:36e::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: 427c858b-28e9-4365-ef6b-08de0d705999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z4Cj/Ti1QRZ+FICg5eZNYfNkTWCgdCabWeeF0dX3ytDUWL2xOoI8wSfEOXgR?=
 =?us-ascii?Q?idNBVBaRoFlMOplVanP4BX7/ygGXzG70SCFLMQ5hpvbJ/TjbOkRaXQCiJF+Z?=
 =?us-ascii?Q?jMnXND4NJK/mViolByUc2Zl58RNbCU/B+PoG/AKDlSBk88OhbM3qxSynmVro?=
 =?us-ascii?Q?rzZIE/gYwh2osjDDR1YCpGyO1OJ//tWZ/+7HFPAn4ab51nHvrhK6dcRZ8JxP?=
 =?us-ascii?Q?cTYWo3oEecshlx2a1IAUPicYX6NLWBT7NWeCSy54E3axOHvmV7q+yrebfJ8X?=
 =?us-ascii?Q?Pg4Lj1Dz4muUHEMFkelG54xCLnPh/oAZ00ISklKoWXiPnlSEhKWRsB0SVXJ8?=
 =?us-ascii?Q?378KB50u0xGAsHrmN9wgQwi5tZNuyytRH5vkHFtRbH/ReVdbpmbKNMVbXmZx?=
 =?us-ascii?Q?X9MNFmCF5j8/tWXP18xzA+KaMNj0UM54HpytNVikiRDCyW6ux1jmrX5p48kd?=
 =?us-ascii?Q?zuSGO3CbVfFghWhkvtwnMtPpI2f+Xk1E2D0ihuQJ1g9kcHKmCPSYYqnEcjlc?=
 =?us-ascii?Q?PYblN+wdQw3DEzIRwJSY2t1myYZXD075NiU6+enJJMZHGZeiiwezjtXXM4Pl?=
 =?us-ascii?Q?OW9w2An705q9MU0N6w2CLzaloCniZMzrN6z8v4bUKDQFCh5klq+Bqe+Z0D0R?=
 =?us-ascii?Q?d5b7qmiaryCNU4AFtbFc1O5VStj/gX49GUN83Vd4aBxlt/efalrZB6+1KR4d?=
 =?us-ascii?Q?iFsbUxbccOSmMMnwLhfEGNUVfuli2SU3RSTlyU8X7IKohnDGTTrQzqa9k2yb?=
 =?us-ascii?Q?J/081CRo4oHgb5N5N0xgL9BD3/lXYrI8sUDG7eXqIRgizlUz2I+Uvoia9xN+?=
 =?us-ascii?Q?kdlxnSN2eUrUfTpk52OOSGYeVixDSTlYcrNCoXi13Z6mUT2eeXJuzJ7C1sjZ?=
 =?us-ascii?Q?jIN6ynziAHkxPyWrhv2YX+JBeFn1jQQY6izIrvJXJBMjWyhhL9JaHThfrSFr?=
 =?us-ascii?Q?nGVeQXaY+OwNK8UbXjy/9evQj4f2vCUQrO+kJmX5Q8ovxnAMl68pCdsRIP1p?=
 =?us-ascii?Q?CVM7wv3TExZqB20DkCfqfGBLWJiGytZdofP7He675qlpSm4NMXz0XzdINl7q?=
 =?us-ascii?Q?7hBdqOpoZ20TCxKVtNfeMh65uO0hrwtbr9SP00T8gxxgrtOvIYwQ0TJRUCZ6?=
 =?us-ascii?Q?VtLtxed6HlFoIyEZqhAQs6qqkIfjdSGmpnQD0Ea1chvoHTHiXSIs444TnKJW?=
 =?us-ascii?Q?ASwl70WVh4kKdAO0iURbHi2epoVzUaQTBHmUPgJIw2aJsIOi4d7sKNDfRizG?=
 =?us-ascii?Q?+XBEyY7lsFiQIR2ONdCFwVQNIKzPQS7Hj8Iies/biep1+JKSpQLAtQ5NzVGl?=
 =?us-ascii?Q?LVC6QUuSDsEtV8D1ZRaDJ0PLMQ+UhgFEPzsTRFlrZ/WShuV7M6Bcj6HfK7hK?=
 =?us-ascii?Q?qOv3MyUBoW3LJFhVQTslbEiHInQjrq9lk7ryIZrPI6TANOqTV0nSR5y/YcuW?=
 =?us-ascii?Q?991ZwRXR1/BZ6JNn3QIaWx87VeJD/Y6rl5Bwi9IZ5RU5YhJZ3yt4EA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sSUV57zYeDtdVIPaTVxhVb/bhJkMPoKAeKf1BTrQm4hdTC//vJJuSakl/Opu?=
 =?us-ascii?Q?5m6SNf15pE1a6tQcAHzyi1TXw5GZRAco3ChiUlOtmFIdYwAB8XrJtqevF0hX?=
 =?us-ascii?Q?isZDJBkt1/xd8qNktlc1eXamXMOppIimfTqWSuHsAj4J+sMHIqgFBLExML0/?=
 =?us-ascii?Q?dNhlXB2DtH+esRNIgu52HmuPUClhzUOwxzn3jff1/pF/z1EKPIIQPwPTv7L6?=
 =?us-ascii?Q?f5win+VBJeqgTfGJ6tfH4V1N0RnU3EuHjll3df+bEvBTVTUx+2zixMvBsnhl?=
 =?us-ascii?Q?BIUMKmucy9x1kl2Lc+ka3pmV9ivLQIByUYd3GFZ5As+WLMk7MWf9bEOGX1wg?=
 =?us-ascii?Q?Vif67+XkSXfFoW/WRB/2Spa0AyF4Al+arO8NkZd4VXt6LNiwVqdJbebYTck3?=
 =?us-ascii?Q?F4FjPk0R8RZR41660lPhx27q2wPZIxfgo9+8p1UcHJIUQ3gLtIIt45X/xJ1L?=
 =?us-ascii?Q?/8RycAGHIPkb1OlmpA8zb+LblNGym2qVpBTyd+s797NMdL81cN4fLZCxb6qa?=
 =?us-ascii?Q?fp19l+ID7D448oqUBnxli5qROmnBwWXTbkF57DvVuncxcQsTFe8TSFWsW8lJ?=
 =?us-ascii?Q?ZRDT4mTZSKUnmFHbhS6NoG3Y6vmt1t0HVK8ht3pQpYmQAV4z/uUuZ5eb8pvQ?=
 =?us-ascii?Q?Ez/v9c39WQvzLcMLpGw4hwoHQ/jtx5lVAwhilOtUlT0PPwXy9V/S4DRZHrnX?=
 =?us-ascii?Q?jQ0IgmQ0BA1UHkqRaaWXEt2DZAy0Txg6RCIK9T+ds9cDRLF55wVAOIK0acBd?=
 =?us-ascii?Q?XI2V/D/Bafv2xWL3c5YhAnxGcT80gyUbS/BomkbwbB97XTpDMbd4rVmKKoYM?=
 =?us-ascii?Q?ihY3m6pZUkiYw/R3FG2O0GRE3rRiNaf+UL5bot8/O/wIuKXh+2ArLypNIYQh?=
 =?us-ascii?Q?20PqbiIPDo98EiabBtlNt54+jP0Edbg1qwvs3b4xJrZ4lJ/Ddn3mqjZ56x6G?=
 =?us-ascii?Q?FmNAKNrhnI/4SJozy0eh5NtZF/BMFf2sz7ZGA5iUUSKRyGjddOKzGig7hK3B?=
 =?us-ascii?Q?MX3cLAYDdhYnxiKnNBnCDdkrgZalkWueITm0/essox2CFJKuKfabsghzgvC4?=
 =?us-ascii?Q?FDeDKSzLILWIyvF6ZcmupAVitV+MOslsBiDPJguxYVE4pVbxIPnZ5jX1HJfn?=
 =?us-ascii?Q?KrdQPu2XoHUTo+fgDk6l5vbW+Ev6DvaqLKe8DKXOZchMvUfQuWc0wC7WYCvX?=
 =?us-ascii?Q?lYSAlg5eUM/Pj49kLgvY5wqKgLp3WwuzGq3ohaFiQht4IpqPJZGDtbdmk3LW?=
 =?us-ascii?Q?3vcZK+ZIGkua3joaY13FpmxXPrD3FYhKL2wcQqZm7XHgYcgZ+oiVWjfkjWIw?=
 =?us-ascii?Q?QoQpGp4O0gKnh7GiR7LcWGY3aRkV38CaYrv9lOBjLgSkU+tMjhng0oTAMyxf?=
 =?us-ascii?Q?ieiAtmud6G9jQtg2D59fmi3xcvy6sZKz5AjE0XCqhO+M50XMi6hj3ezdDy2S?=
 =?us-ascii?Q?ZFZx7KdojZV3M73ShKW+x/3CApD5ZIIuljLBiyjhRUhxmYZJavnQdJBUaDEn?=
 =?us-ascii?Q?y8wYDWbsqac4qwkp1YDFRxpS3QKOnLRGI+GaPUEGKIL0qgxJUcMHlcmdja5j?=
 =?us-ascii?Q?KQVGYyp7ifK23ybB4TrUXQLdx32SoJKgjjAfcao2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427c858b-28e9-4365-ef6b-08de0d705999
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 11:28:52.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMLcUv8kGh8Cg+IDk4Xiz5OQQkzDFFTE9QBvuvUftHwSwI2pg/LgG6g/cf1rl03r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FB5B1C000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 7ugqp5psifgtwieacpi6noc43mse8byq
X-HE-Tag: 1760700536-10828
X-HE-Meta: U2FsdGVkX1+bs1IDVuptKGp2E7x2K5SD/toEQ/n/oSV6mTcMtDBOit7jIZIydrI9S5vPIOBdQ6vyzpBa8R92zbDAtBvPIlrYFFfzkYpz/ow90S02yhfulaCkAivCVbXaMcISg3YVeDzJ3he+AClKwOQFxmr+gEFlsVUHywkJiJgV2854t/zqEOFkW4b4WTjchdAi0fap8Zo6Cbch+EuNP+1qpW2i/zO57JAt0YM1s2c+t+j1yucQDBoS5Wgjw2L4T+o1xrjv94C6yf5lI25DBAWEbFw4RTxpcA7XM+7E1ciEYry90yiwZ5oBxcqwqWvNN4L6VRG59zsysbp0xxQEs5UjVGaqdRK5moqLeDbPR661u/ik379dus6y53bEErL3qE+2X0+lP0ZKjsrRYGC3Ue6v84TzB4mYCXlWcDlv/DXsnuJutK2aQIgYEdtWm9FDKLmr2mZqKDkB8khgXT7yUpyK1VeleLuk34ORyJQQ/QtvTxhnCaLXu/y3bFyqWspiVT4BUbRylI5qerIJ4QrLPlE363Nwm9BnrNCDz/AQjfzayNrR1HwOEl6zCqU5Y5e65PBuNfpTpdWzmTYRSRhrvfasdPlqc+M9XyXDJ4SAMyJg5UdRy7eS19OwAeMhS5bV0p21X/v090sBdZDK0ryTZAT1jR5P+GQctu+M4ZCdNu1jFZDC6bUGa/K69sv03+kNelsk4EG2Jpy48B6kVT05Kn0j5w9tK2sexhy3vMtgBmdW2jWmqHHiZTZzfaTzz4pyQvkoKKdJnhLo6BwjGcSKUnPx+miwQeS7CcfIhnTBzKt5qvovo02QPmHDfmSoGjzHrjODURFBa7n8xYjWcxMm86Wa80A0iLfjsjKLqz+jcXDSlvSDmHOZN/5V849eEl0Y0Jov+aOQ0J3xcymbeeSsiX2+7yrIALrlN54yOxBhPWABJyNPCRljv6e774XDuwPNuVA2uUDjFsvhFjb9KtL
 jPwE0BmA
 bkHCkxAnoRdOY0b9G8fkB4LkZDIDbSbp6zI7zipnAQhyGGhGrV8HejIaqeR2YeWDnI9uY9SQRFX5PE1oiuxWr7MSiNXwhkDOuiWsqrMFrv98H/bydT6IEB8ulKTKp/ifwCLFfx/Anmb4BmYAScfLTCkatBCRcIElhb9ZzVjTIKIKmlNPJqwgU7j0ezHBaqEj2MISgrDGh6MtGQl3Nft3R0rHDIcLoEoE66t/HijqB3S7c8POh58MGVr0JNmRzkjR8ULCHG1arUAVm7IHKLNDbqqRq1OMqwC7ZkLOAD3AmBJrOZuymuDZziU4EA1wAXoD2Oqb0mUuCmoMTEDTOVUSiwnLuIHCm8nO2qt2tnShIeTYdjzag3lwFU/Y2oE1nqdEFgo0Y2sf4xt6Y3i8NqIqT+EO6PUo3mR30x+hPckHKvtaSSsCzc0TJb2xexKhsSvAbbrFAjd+1f4rYTXPSYagSATMeWXYIi8l0rmqZyPv7hHNTs6vewlaRDoWtE5NhRsIOIwtP8dJl91KbN0oPuehkpYMTgshD/riNPthD9BkQ1HNUFYiImbcYzUZur6LcF6lTa8KgG2qE6i5xioHOsFAB1rG9uct9ivYb++Cxgq5cDMZxwJqNlbf71AT7elaYaF2vRS7Cw8RXJW5yMJafa5DSp8231vAoFeXqx7mhQrEB7SdqIUWRE5IFy3wHFdTPROGfPY3oYjdp6si6X3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Oct 2025, at 5:19, Lorenzo Stoakes wrote:

> On Thu, Oct 16, 2025 at 09:36:30PM -0400, Zi Yan wrote:
>> Page cache folios from a file system that support large block size (LB=
S)
>> can have minimal folio order greater than 0, thus a high order folio m=
ight
>> not be able to be split down to order-0. Commit e220917fa507 ("mm: spl=
it a
>> folio in minimum folio order chunks") bumps the target order of
>> split_huge_page*() to the minimum allowed order when splitting a LBS f=
olio.
>> This causes confusion for some split_huge_page*() callers like memory
>> failure handling code, since they expect after-split folios all have
>> order-0 when split succeeds but in reality get min_order_for_split() o=
rder
>> folios and give warnings.
>>
>> Fix it by failing a split if the folio cannot be split to the target o=
rder.
>> Rename try_folio_split() to try_folio_split_to_order() to reflect the =
added
>> new_order parameter. Remove its unused list parameter.
>
> You're not mentioning that you removed the warning here, you should do =
that,
> especially as that seems to be the motive for the cc: stable...

The warning I removed below is not the warning triggered by the original =
code.
The one I removed never gets triggered due to the bump of target split or=
der
and it is removed to avoid another warning as the bump is removed by my c=
hange.
The triggered warning is in memory_failure(), since the code assumes afte=
r
a successful split, folios are never large.

>
>>
>> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks"=
)
>> [The test poisons LBS folios, which cannot be split to order-0 folios,=
 and
>> also tries to poison all memory. The non split LBS folios take more me=
mory
>> than the test anticipated, leading to OOM. The patch fixed the kernel
>> warning and the test needs some change to avoid OOM.]
>> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@g=
oogle.com/
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> With nits addressed above and below this functionally LGTM so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks.

>
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>> From V2[1]:
>> 1. Removed a typo in try_folio_split_to_order() comment.
>> 2. Sent the Fixes patch separately.
>
> You really should have mentioned you split this off and the other serie=
s now
> relies on it.
>
> Now it's just confusing unless you go read the other thread...

OK. Will add it.

>
>>
>> [1] https://lore.kernel.org/linux-mm/20251016033452.125479-1-ziy@nvidi=
a.com/
>>
>>  include/linux/huge_mm.h | 55 +++++++++++++++++-----------------------=
-
>>  mm/huge_memory.c        |  9 +------
>>  mm/truncate.c           |  6 +++--
>>  3 files changed, 28 insertions(+), 42 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index c4a811958cda..7698b3542c4f 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -383,45 +383,30 @@ static inline int split_huge_page_to_list_to_ord=
er(struct page *page, struct lis
>>  }
>>
>>  /*
>> - * try_folio_split - try to split a @folio at @page using non uniform=
 split.
>> + * try_folio_split_to_order - try to split a @folio at @page to @new_=
order using
>> + * non uniform split.
>>   * @folio: folio to be split
>> - * @page: split to order-0 at the given page
>> - * @list: store the after-split folios
>> + * @page: split to @new_order at the given page
>> + * @new_order: the target split order
>>   *
>> - * Try to split a @folio at @page using non uniform split to order-0,=
 if
>> - * non uniform split is not supported, fall back to uniform split.
>> + * Try to split a @folio at @page using non uniform split to @new_ord=
er, if
>> + * non uniform split is not supported, fall back to uniform split. Af=
ter-split
>> + * folios are put back to LRU list. Use min_order_for_split() to get =
the lower
>> + * bound of @new_order.
>>   *
>>   * Return: 0: split is successful, otherwise split failed.
>>   */
>> -static inline int try_folio_split(struct folio *folio, struct page *p=
age,
>> -		struct list_head *list)
>> +static inline int try_folio_split_to_order(struct folio *folio,
>> +		struct page *page, unsigned int new_order)
>
> OK I guess you realised that every list passed here is NULL anyway?

Yes.
>
>>  {
>> -	int ret =3D min_order_for_split(folio);
>> -
>> -	if (ret < 0)
>> -		return ret;
>> -
>> -	if (!non_uniform_split_supported(folio, 0, false))
>> -		return split_huge_page_to_list_to_order(&folio->page, list,
>> -				ret);
>> -	return folio_split(folio, ret, page, list);
>> +	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ fa=
lse))
>> +		return split_huge_page_to_list_to_order(&folio->page, NULL,
>> +				new_order);
>> +	return folio_split(folio, new_order, page, NULL);
>>  }
>>  static inline int split_huge_page(struct page *page)
>>  {
>> -	struct folio *folio =3D page_folio(page);
>> -	int ret =3D min_order_for_split(folio);
>> -
>> -	if (ret < 0)
>> -		return ret;
>> -
>> -	/*
>> -	 * split_huge_page() locks the page before splitting and
>> -	 * expects the same page that has been split to be locked when
>> -	 * returned. split_folio(page_folio(page)) cannot be used here
>> -	 * because it converts the page to folio and passes the head
>> -	 * page to be split.
>> -	 */
>
> Why are we deleting this comment?

This comment is added because folio was used to get min_order_for_split()=

and there was a version using split_folio() on folio causing unlock bugs.=

Now folio is removed, so the comment is no longer needed.

>
>> -	return split_huge_page_to_list_to_order(page, NULL, ret);
>> +	return split_huge_page_to_list_to_order(page, NULL, 0);
>>  }
>>  void deferred_split_folio(struct folio *folio, bool partially_mapped)=
;
>>  #ifdef CONFIG_MEMCG
>> @@ -611,14 +596,20 @@ static inline int split_huge_page(struct page *p=
age)
>>  	return -EINVAL;
>>  }
>>
>> +static inline int min_order_for_split(struct folio *folio)
>> +{
>> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
>> +	return -EINVAL;
>> +}
>> +
>>  static inline int split_folio_to_list(struct folio *folio, struct lis=
t_head *list)
>>  {
>>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>>  	return -EINVAL;
>>  }
>>
>> -static inline int try_folio_split(struct folio *folio, struct page *p=
age,
>> -		struct list_head *list)
>> +static inline int try_folio_split_to_order(struct folio *folio,
>> +		struct page *page, unsigned int new_order)
>>  {
>>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>>  	return -EINVAL;
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index f14fbef1eefd..fc65ec3393d2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3812,8 +3812,6 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>>
>>  		min_order =3D mapping_min_folio_order(folio->mapping);
>>  		if (new_order < min_order) {
>> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
>> -				     min_order);
>>  			ret =3D -EINVAL;
>>  			goto out;
>>  		}
>> @@ -4165,12 +4163,7 @@ int min_order_for_split(struct folio *folio)
>>
>>  int split_folio_to_list(struct folio *folio, struct list_head *list)
>>  {
>> -	int ret =3D min_order_for_split(folio);
>> -
>> -	if (ret < 0)
>> -		return ret;
>> -
>> -	return split_huge_page_to_list_to_order(&folio->page, list, ret);
>> +	return split_huge_page_to_list_to_order(&folio->page, list, 0);
>>  }
>>
>>  /*
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 91eb92a5ce4f..9210cf808f5c 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  	size_t size =3D folio_size(folio);
>>  	unsigned int offset, length;
>>  	struct page *split_at, *split_at2;
>> +	unsigned int min_order;
>>
>>  	if (pos < start)
>>  		offset =3D start - pos;
>> @@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  	if (!folio_test_large(folio))
>>  		return true;
>>
>> +	min_order =3D mapping_min_folio_order(folio->mapping);
>>  	split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);=

>> -	if (!try_folio_split(folio, split_at, NULL)) {
>> +	if (!try_folio_split_to_order(folio, split_at, min_order)) {
>>  		/*
>>  		 * try to split at offset + length to make sure folios within
>>  		 * the range can be dropped, especially to avoid memory waste
>> @@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  		 */
>>  		if (folio_test_large(folio2) &&
>>  		    folio2->mapping =3D=3D folio->mapping)
>> -			try_folio_split(folio2, split_at2, NULL);
>> +			try_folio_split_to_order(folio2, split_at2, min_order);
>>
>>  		folio_unlock(folio2);
>>  out:
>> --
>> 2.51.0
>>


--
Best Regards,
Yan, Zi


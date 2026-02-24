Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1A3F4BB7F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1EF6B0088; Tue, 24 Feb 2026 14:08:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9396B0089; Tue, 24 Feb 2026 14:08:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5C06B008A; Tue, 24 Feb 2026 14:08:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9ED6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:08:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87717577EF
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:08:40 +0000 (UTC)
X-FDA: 84480286800.12.A0A6890
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	by imf20.hostedemail.com (Postfix) with ESMTP id B84AB1C000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:08:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iPykqQNo;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771960117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIM5fTZMrcKiFmpV+4QqUBqm1Sh2aF/8uWQQDVIEr98=;
	b=vq2ZA1XHUA+RdnoCvpGrhIqQYgYWhBB1TbWPYdt4Fdv5nlXwfL/p5hQye+yZMDRN7jhZCr
	5tecWXAO91bU/gKYJSxC36TRfbDTSumopDdI9oYfcnbrhp6GDHZb/f4gxyMuEt4Gff0Wa7
	ILdaLfJ2mNa8hvHRPeABlUxm6NFJ8fA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iPykqQNo;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771960117; a=rsa-sha256;
	cv=pass;
	b=wdnK9wOXaQ1yzGcYnYXLK9fWH1+y4OZm5zdma+0Zn5XOeKsjBHr79G2Vb4sGT3Jv4NI6Jj
	OFfJnt6DbwRM0ApMt9A5frsnKEILAomWlfp/bV43uxTm67AgwophgmqK+OhivRhLBuOI7y
	OV0yhP//KkSxmojLUUFXsRarAm1KsFo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXJxaKp6GGzHA0CTN4p3I7IaZn9JzwAqExfrkydww5ZH9UbIzea1b4O6K673oTrhCIo0FDaJioZioDj8bvc66Vmfm6/6NRPVezUZ+xaTh9X/N1fm3SeLnjFHTYz+brT8IPBalmyyS+SdjNWCICrrYYA4Sy5X3tL+giM9eAe9AAxA+t2W+PI3Zc41JsBDSBu4WQaGLkppVPyxzSgBStgxPQMxlKCzuKSnQfWGLfII7AlXsjv2Ad9s1MqJLsIzqMZrBBDaSeCbqSvjSp9J4w78ucGcSwcD70W4rfN9NAZ09es3DnFGDSowDxDNV/brMr42xpdFYn3Ay3XFsp3QfPBYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIM5fTZMrcKiFmpV+4QqUBqm1Sh2aF/8uWQQDVIEr98=;
 b=sVY/3fW/BuPYfMVBg+dMY+7p9mEF6FZp48IbEzZNeLPopSSMz64U8d3iLr/0sYfssghUPxYr6xuq8HYOwvdWQmOBFRWu1s3RTdx0+9HsKsKhUkvYQDi6msavVxGJn6rIVZ0o0CQjMMA1TslVxdVJ5vWskMJULXUO6oDIG7aYK7HLFDMLmBghiPjtBDZbUInnM8/hrxPjYuNIf6qrwu208v8F5DvWK78/BqoW5oSyywWInkfbFL8CPYYpADpOW/zKtSUvzX50ymY02n3QgVJhfNGWkboEHBOQZen4lZ+g1bYqSMdRnOqzylqV36YtZLRKLD4mi+WUG9SSOhSNS2RTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIM5fTZMrcKiFmpV+4QqUBqm1Sh2aF/8uWQQDVIEr98=;
 b=iPykqQNovzxYl9yU92CfpsYzLHWlntM48atbnutmkC56dPp1iMuuDWfz8NFwgxSAIEcHhqeNfGKIluqVptNnbDQW+ZGLZbe0DpKBUqO5tNr32ranOj0claeSf7cg9p2/zti6BU37ea9ucChMzv3gotQaEzJPuxwCj7fHEYPFiXAD657qCfyZ66D4fw9aiECfZflzfKdFbfqBxmQZdEEVICShO+K3dekjNk4fThgGllqrUL60XrlHSUywb52DvnnqRNmcwFGdr393+E9LweuRWoCIJ5wzB+mOMppiOZv57uvv9K8cV9+jc8Pg/ISmVrarSP0YdhRjjSthmdjuujwKqA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7472.namprd12.prod.outlook.com (2603:10b6:510:1e9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Tue, 24 Feb 2026 19:08:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 19:08:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, David Hildenbrand <david@kernel.org>,
 willy@infradead.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, riel@surriel.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Date: Tue, 24 Feb 2026 14:08:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <42CCC4AB-EE32-4279-BB50-EE72756B5137@nvidia.com>
In-Reply-To: <aZ318PoxdAZjqnLX@cmpxchg.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <aZ318PoxdAZjqnLX@cmpxchg.org>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::36) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7472:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dcbb9bf-4818-4626-4ea5-08de73d819b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9xFxFc4bTLe2oCLDZm/uq/etKUoCr3CIse0Dc3e7/1DXVbH3JT9UfN4NQAHl?=
 =?us-ascii?Q?rCHjW5LfKKHlIewH0MFcJi6xA9McnlUqS0Xt2CxZr4/YEkxMqrivLQ7iSDvj?=
 =?us-ascii?Q?uhPg5vjNKGQaWz6wJsjI3FVgOl5Mpuy8Cbgt6cdEEK85uM/iYD/WqZOlqOJA?=
 =?us-ascii?Q?DTUUiT2mcxnq4702KfHFUBaW7cGLgidwtJQLYLcv3mvwSowBLk/FvSYWsnYC?=
 =?us-ascii?Q?xgkpkIXGTCh2LUdgmelLXkeARAqNcDYcwcZBGHGNrHIEi3h+WJ7oWLDyRabd?=
 =?us-ascii?Q?6m7zoq4rUXccBYJDOhJI71EQf4NIG8sPsucbT8abUzx7x1O6K6FfbzPXnFSO?=
 =?us-ascii?Q?qTFriN6Lx8HA3ZR/7jHcDQLzI7kkUdkFN7sx6nJNbgBxtdnfzEDQJjQ28+Hv?=
 =?us-ascii?Q?GIZSr1cALwO0bEuePB2vD+NvSYpUpLjR4ZYUe+LbG4JLAudM1DPSLVlNRE6G?=
 =?us-ascii?Q?XhC2I7kWWToR3xepuZ754c13nfx0EPOtiU9BiFVRRjjQI09HyhQJegotuv7/?=
 =?us-ascii?Q?6Xb1F++4F/JshAkBUrb0Beoa/lRbb3AEXW6rW8Yl7RQ+1dW2n0itFuEHEQVw?=
 =?us-ascii?Q?lbr4NWuszmdeE/yS6pY8NC+UlajYApDtBfnLC1cM0+Sdr8dc7nxvrdjAKnBQ?=
 =?us-ascii?Q?CZ7PWVxcwS0lJqq+tVwt2SjlklmOQy2WX9lYzd9qiF3ZkV5kBM96KQCupkBu?=
 =?us-ascii?Q?+Fuh+TcE0QUINyH5FUDFUEJTfbzYOqBvE9NEfETkA0SuK4T8h2I1adwX35T9?=
 =?us-ascii?Q?ZsBhKXEKUUX4D2OXqMHoyCcdkEP0zne4cVV1Q3g10atiIlTosfnQ7H989FFX?=
 =?us-ascii?Q?Gd+mpXbzfInZqCaMvOsOYtujVQKVfKpzgMocsFmjy8kvpvAXPrqZcErf9NtB?=
 =?us-ascii?Q?EjjFAanOsk75+XhcEIOJCcip2I+A0L0W/qtDaIt9+2my19jm5FqWfP83eHzM?=
 =?us-ascii?Q?cH3kAJUvTq3gYgybJMviuD3GLKKk0w/PXrRgLnPxkSKYtgl8fL5+I9tv89BV?=
 =?us-ascii?Q?DaBLtdYcvK1J4xrtPnvERbRtX6Y8KEHt0USzYuEUAPCnIf0e31dN6n++2UQ3?=
 =?us-ascii?Q?PYzY6ca83pyfTHsXOP5oYsjywN1BDqfpmAT6kpxxUngjWCr+/5gXbvejYFhb?=
 =?us-ascii?Q?qP6eJ8kZ9DvdVwYxn7Ae/bEqBDivKlitvcGaMi7Bb5rsb/FNVPDu/HW58QzH?=
 =?us-ascii?Q?9GW4saAXZckj+rxIBCZdG6oTw5zFLL/N84JNFp8CUeMZTS/WGzw5gza0HQf/?=
 =?us-ascii?Q?tVoAro9TJGxpiwVu+wuVf4d0IbDoprfUIUMJqZV8uDNrATBOo9u8gKUkdw0E?=
 =?us-ascii?Q?Jd4fBozw9Sg9XG9tQEC34i0B8MV4yNNMZxNjgP4+Dc0jrCmQEeFNuNA68Co9?=
 =?us-ascii?Q?3GSEKE+t3arxoJIqboKnGBD2jJdzF3UmFOS7nmGeVmPaD3R771Jj620sSzUu?=
 =?us-ascii?Q?zLt8D+GI3pVg1MXYd+sopiArN/Nktm8sDJ0GbxCv9z68gfCTatQAxaY3AXR5?=
 =?us-ascii?Q?m1r4ciB7QrkRkOk6J+01kM9468FWlaGQlY8RWpB8soF3r8/YVuL1pgxiJoBH?=
 =?us-ascii?Q?dPSpOXTm/Xht0lVIaso=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OAn3VcIlbawgOlIJ9O7FHbotpS8e9Wuk/qGzq4jqq5SssXkVIeISbVNuWlv/?=
 =?us-ascii?Q?EBgZ60zqoD7CWN7bSvQtdq8IOq5wzpmHetjEmwqc/Ne0rw279Nmb/CyaAy7C?=
 =?us-ascii?Q?kBLJc5OGtyvjielWCFEmF2MZqKdC350XT/ZamT10ASBXWloOoFX5AWT10ocp?=
 =?us-ascii?Q?somHmFdkbrIXazuw/c/YvEi8ttDR4Ip9Z6vuQDZA34aJpQSms3zJAawY5bVh?=
 =?us-ascii?Q?iSTQL7S2ise9UsetLvmhNkyDPeUNP+is2vhHBUX9kR7SEkaivmswFEaE7F1q?=
 =?us-ascii?Q?JBX0NZGXk2xEF0/CSEKIhwBD0DYOZsWNP0x2I00BBbIcbrB+IjHZDQfvNWpW?=
 =?us-ascii?Q?w2vGtrPd3zxrAI5LnSJN864MGSm+fUwpYKuAQT9ht9bzNUNqOO5nauTsjh3J?=
 =?us-ascii?Q?WeuywNZtZ2qElktqJVmf4/MqP+Bq6KuSlIxBDiWGEF9EfwWce4qy1+Wb/apg?=
 =?us-ascii?Q?KyAdbuGNMtgKhveS4yieCZHKGx0cL2QNdyOr5jPXTCjKkei2oZwQIPhB+PJ8?=
 =?us-ascii?Q?3Nkm2U6JS9odGpfkYMN2vdgFKSTWU8NuwFd88PPGFP/YRXB+82z4isweZAK0?=
 =?us-ascii?Q?7TgtO3BrCwpTEryM3X1iiB35ojnMwN6e10QxFIqz92Cwb9ryxd6bYRrjZMKS?=
 =?us-ascii?Q?5K8BWmGvFz42uKNdg2sh9F54toyh00GbskgMPJZubqbuKd3aL0xXIfNhaXRA?=
 =?us-ascii?Q?4Hb82qfZwl+AMkJql1aGxqqjz9KafJ2zDcBmXH4bnNQ2Lqvx7eyxVWvy4PaF?=
 =?us-ascii?Q?xMIYomgUj156HHB2m6YbDU5FWxzIiKhIcER2wrByAIMMn4z/Bc+uCmu7EEUH?=
 =?us-ascii?Q?v/IW/G49dFZCtB3nh0Z8FW4aiWV4Qcuy5wOcj8YHSz/UuYloxNtB2daSzc+m?=
 =?us-ascii?Q?8SBl0xgOvuppfqYIBmzTlk53e6r8GhzL+zFDpp49fusyHGENdk0yjJW3tVy4?=
 =?us-ascii?Q?URUWyl89PJ5pyloJl5HQuZpd6phRCOAtZBbQjXgfOinPZqOsv2kbO7i5tjkc?=
 =?us-ascii?Q?DzHA7NOyc/39aG11xmdmseY9uMqOrxC/Y6ui2jqr6EDetA08v11ELWHxyrWM?=
 =?us-ascii?Q?r0LcSB+yvw/GVAixPh3ypDE24Mokgak7RinKoEJA/jq8iWT6TrNmu7v+eg6N?=
 =?us-ascii?Q?ArMBbMSRPWu0ZBPo873TOi31BdND9Y9dybkhIR98nrAN4dYpYG4egfrfg4hq?=
 =?us-ascii?Q?h34pYxXbj85TEazaHQxNEYe/dNTAYWNmvRE47WHmKyRfHRD/gosLzPUFfQWm?=
 =?us-ascii?Q?B2ipwlnwD5gbAx+B8CxKtELfJRj0s2exFo9D/7eBf7bcAFxuRf6CEl9ySe85?=
 =?us-ascii?Q?FOVNuAkqzmjDNp3xITPJ5Bu4NYHGPvOTdoVytv58+ej0nj6jnePrEImQyceI?=
 =?us-ascii?Q?T1O57NNTdtdmqEaUvrH+GbDSrTl2+LBlUUsP1rSQLx4nr5IyLe8u3/zPfOH6?=
 =?us-ascii?Q?6FDlcHIESp4Yo96EaSsTdRaA4phHmdJyEVl+r/EFCMLv6mZYjnud5CUJn+TV?=
 =?us-ascii?Q?xfwMh9JasVLcYZisHZxCSnSM6NjUPIkGyaWBql+UFKa4vXK2IcVqLs5mlBuS?=
 =?us-ascii?Q?LTIvua5IhccmLbsGpn4uA/zR8MuEufyelBhBbeVeABsMhDJLG3tCm5xWNtUO?=
 =?us-ascii?Q?deM/T+CIqy6IWQbSGwRelcstOHODwVyczgg4F39IQ3CxCeEZUuEiAS0E2lSS?=
 =?us-ascii?Q?p8wP9ETFk+9N3Ffatv5BPWIEW5T/fDsJ9FH0ZxWoKl5P+/zTO5P5jOQs/leZ?=
 =?us-ascii?Q?sTjYBbKCYw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcbb9bf-4818-4626-4ea5-08de73d819b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 19:08:31.6604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp1QI2v8ybb4nzWcS3Hey59seWDDHMKVPB3ZfCIvY1/oZKs+hB+vd9iBUBtkFDXA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7472
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B84AB1C000A
X-Stat-Signature: 5wubk8gcar1sfh3ray35z4s84f1nf4rp
X-HE-Tag: 1771960117-111870
X-HE-Meta: U2FsdGVkX1+PDhG21QNd+SQ61jfCWG55SRw1Gm3rvcVbA1o31CXCv3EMAoGEfyIz0EL0ovgbskLeR/fKKZUt+uaD4yt1kdg1y6GTlemF+x8H8+Pn2LC1Tlzc/BYKexMRqTCHcRmoJrt8DfdoJRAbmJv3/NAlTQf8RQFvlcYfxYwsH7LmIuEdoSSVv+bd6ryoLWu4RO6Ze/MRmIdH06jibcJ/lB4XtTjZL+5oITaMHghxS/ulV4rnzIrdvK04E0ScIyiD37ihfTA89ll9a80bgrKm2rLriaK/P9ZHuc+LByOJVWficx8CGI1VDI8Hpd+J2IX5Y0KdyzHEhZaIpePdR8ZNoG8h2A/2A3Ep+nmtjP8ZFBlOALMJpJJDVAgOxrzXYrKJP4+MzRaGaKoifvgu58YzU0XGDl7Fh7q9xMSYUfrsTbPzsIiqkcHXEgu0a8/SK9hNAx0s00VefEjo0SN881T59xJZODMA1lUlT+X5dH8jgt5do7tPfvpJap6dcbmfaVrwx7Yi09yxSylHaiFjAHQ1gE/ip9xwZFyBszk08bfommFtN/QmZhTq7cB4fesc6/fnzfr1pJe2zZ4VrJS+gmCdJi7+/Eoy+yjS7o8Et4CHDOYDU+MXGMWWbo0h6ISgS+wH158Hrh48C66gUTHZ6BxAsH7XnwyxhR0lJw5f287kC5o6EuEFGd727/pFHO0EDTXlziU3uf2nsYCV7eBXne/UbY53diA7M4dk5wCkMMPom5Sf8wsLOYdzN5eafqyB42N9C36dg+zxWHh5klE4CtwPkViFLRBNQnIYh1kBwXMhm3jULND1KyKByI0u4i40sYqDnSZNbb3Az1pKL3aiT2u+sLfaKAwmPEEWMfpqI4KgMMbq0guhxWPQimWcyWi2qqdQG7i+zuGs6BAeVhZxQzN19417uy64Nv6CcP0MAO6hGCHANm+dvTxB50swOCXOAEqCfnk8jQVwmVtEfsT
 Y87LdDtB
 nUgwSVnJ0XpQRID6z8DDwQCZqEZlEmMxpd6acwz/RK1wDovhx4jqenjI0zItD5G4j4xjd79vrR1KHVvO/bPSn6vpws0yKKyKb8aLcQUp+NBHuqCk4JL9pXKGdjf2kGKv8goag+TEZiggN8auzr6+1h13QbxZJI+ImCvPthdi2P8LtuDBsCVEsNKPCB5VW3bYnQjiZ92KJyZi8WpTQ1YqNgWV6YksBKni64sZ9Pr4C9G0PT8tFy4iFn0iUgzlAOO6IC8cxS1hrdgXvo4DuQ7lb78iemP8+nT/8hU86nfpnjo3OdtUsXUZoWwCJcv2xWYIMfXbU5KTnNC32mT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 14:03, Johannes Weiner wrote:

> On Thu, Feb 19, 2026 at 03:53:35PM +0000, Usama Arif wrote:
>> Why 1G THP over hugetlbfs?
>> ==========================
>
> I know this isn't your intention, but one interesting aspect of
> supporting PUD mapped folios natively is that it could open the door
> to simplifying hugetlb as well.
>
> We currently have all kinds of huge_vma checks scattered over the page
> table code, and entirely parallel paths for unmapping etc. With native
> PUD mappings, this could allow pushing the special casing out of the
> virtual memory layer and into where we deal with the page objects.
>
> You might be able to take it as far as the only thing left of hugetlb
> is the reservation pool. Such that a naive application does mmap() as
> per usual, and it comes down to a separate allocation policy how the
> backing pages are served (buddy, CMA, boot-time reservations, ...)
>
> Approaching it this way could help separate out the discussion on code
> impact and tech debt of PUD mappings, from the allocation technique
> question, which in itself is a fairly large topic.

I agree with this 100%. Adding 1GB folio support first, we then can think
about what other THP features, e.g., split, migration, PMD/PTE mapping, are
really needed and add them one by one. It is also going to be a good way
of retiring hugetlb special code.

Best Regards,
Yan, Zi


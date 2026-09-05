Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8720AC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 01:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5BF6B0088; Fri,  4 Sep 2026 21:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255D06B008A; Fri,  4 Sep 2026 21:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144B76B008C; Fri,  4 Sep 2026 21:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5B2F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:20:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605AE1A0256
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:20:07 +0000 (UTC)
X-FDA: 85177952454.10.50E72AF
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8934640005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:20:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aiCMYruj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788571204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPPqK/uvjfP9HtCSG+rqEnPZj/SQwhg0aFE+SJ/tvC8=;
	b=vAyjBrNzYPybiF7FjrZzncWnhPazyllVXuWIBsdxC6oOhqg/K/sovaK+FDaULmhog9LyMt
	EaBWMqK9hR1fZarsNr8QoqnPduNwTsKM7rPke5m0L+FURzphs9ODBZ1bMmgwq4wEX6gNhs
	Yr9D1xkAK4dOD4+u2aJ2jYyHGyUFNWg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aiCMYruj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788571204;
	b=JkK1IBQdxoqRaIgNtgy7Ns2/TyOy5kc0vZqKcSIqrcNv7zX8gqkKkAaidIsTZtpdp2k5cx
	zcU4E7tBcsmR+kTDelz496n5DgFY+jPh9tNusRwqxplBuXl05Wk6/ZHeEN/bSM2YYXZOK9
	DCVOKfPEVY8H1NSUwfdaS6DBROdKxvg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3CXwrOfxkJ+sc8rDxm2CZzbfx5G1qP71oYFa47hiPaB1IR/E/rvnWBqk8pZgrYUHFM6us1yN/EqHFsvfbtAZl1XKZvHuzOoKA8YMfIvzvngtg2FXNUfKWn+i98IU3UnY84zte9qvWYN2bgvil8QOyn4B0yovr/U37uwUWiqBWmkneGf4G/OkPJGQBz1WLUhmsARE/CtI0aoRtJHb1b0g9udhkkeh1bX6uTe8S5VIpH837dHDp55nveqz7PgdX/A8ugrsCLSFB1wVb5s1F3M6BRKIgvwjZIfZmf+u52pk83eK5s0UM9hFwbTr35q6pCZ1BEZ718u45ezA5+OlYfGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPPqK/uvjfP9HtCSG+rqEnPZj/SQwhg0aFE+SJ/tvC8=;
 b=u+6R+7WlIyOqvfXMM4uSiS5TI2Og6YLd/orkSpuKAtTY8tvhZ4ptrKSItJZ1Q5mGaZVqxJlqLlw9C0zHKWMP77zm7FmTxxuuUt75bcENTQQnqhrwsgQaigCgFc+/laQBmivgF/3UzS1v1JQ1lvqZCZaAZcyoNcpkvEk86EbsrehnNlBUB1RZQhPW2A049AKj+AYCIFtlaNDYynPH7+qmTCRIWkcTUB55f3vgCgdjulhJFobveEZqgpFe7C/esNYe8MPxUtpDnh5pvxkcKkHNzEZhm962hIB+bYU5F4km5ten0DwaNJ/6mhf8VvwNVbKO6o77YvbWPfFwPPMYY0OIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPPqK/uvjfP9HtCSG+rqEnPZj/SQwhg0aFE+SJ/tvC8=;
 b=aiCMYrujHFm4YY3gDQoYpaNOes+M3kRC4CsZ4WIOFTd1QMf5YPkYLbGgINh68Vlza5hTxAyMRmhrU9yfsy7mIgu43XHMeSY2BskAT3E44MX6s8M5mMLWvGU5jhq9/GkYDZpPpWlUDjq0JBAJdkCJtmGivYUSDj4WDkX5zY3IUfHkMVZQzlHsghlBYIQHqjFPC+8zMDHRrYWGQv8v4I1Ry4LH1/bXOlx535HEKtdA3GQd8krEOlWxwUfc3m/sSUK4k+WoJ/gjxv58J2caN8gPUqrghcs0FINNZ2VAd47KJRD0v0I0OrOfRWaxccRZi9Ygvw9VtynRx1NB3BocnFohmg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 01:19:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Sat, 5 Sep 2026
 01:19:58 +0000
Date: Fri, 4 Sep 2026 22:19:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
	ackerleytng@google.com, fuad.tabba@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>, david@redhat.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com,
	michael.roth@amd.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org, vannapurve@google.com,
	maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	alexandru.elisei@arm.com, skhawaja@google.com,
	aneesh.kumar@kernel.org, linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com,
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
Message-ID: <20260905011956.GA856309@nvidia.com>
References: <20260728121138.1103610-6-tarunsahu@google.com>
 <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org>
 <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org>
 <anyObKiZIhfok5mk@google.com>
 <2vxzqzjz1x5f.fsf@kernel.org>
 <aoMcqp0gr06YXAPU@google.com>
 <2vxzy0e3zgqz.fsf@kernel.org>
 <aoSCCTTBn9D5hqzk@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoSCCTTBn9D5hqzk@google.com>
X-ClientProxiedBy: BLAPR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:208:32f::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: fa80e47d-db93-40df-3eed-08df0aebcca2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|4143699003|10067099003|5023799004|11063799006|6133799003|22082099003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	krjHVeiqggH9BowlYRBBf36cUNaZ5jLRr6rmP8j7va1L0HT8Ogd9IkzHihNIY238ZxdqR9ICEEmlLlH0376hrlaA8W8sweD9N2l0yf8asseMR3HAjPavrcSXsnouZ1QNJTNI9kUZh9OkFl+hdi8Z58BYZCvDLaWIaafNNd42/CKGxe5S8ftXSMe3k9/kgzLnRFlczNX9Mg5xYJTirEusuH9HXP1u+Zf0eHW63IQa1FQZN3jsNIwVCzLD4Wszdx1hfsfOvA9fzp4+RQk5WvHsdHh9EwV/xBbQPIxnlkdmquH+ow5GdjkmROB9Z3Ke/la7ooXvVFgFGCuPdIYddb+EPxrgaePP3gX698eVqQ62fOssEuoQUbH8CrJEv9BI4+uHHrmyJWxkMZeKZPKO6bE1fDrKpO9EaB1HhgWAb4HrMeWVkLajrJHCM4qg+dKpUi6HGy6V1zdeg0y9usmf6y0bvo12qBTPWbyizxukKR9+MK8ZdY4kzcanNHX4CQOCDBhQugkMHTbsEUD5celV5a5u5akHXSVWtPhAcfcxwzh9p66AbHrW24LKVpqAs+n0z19FKjjk8JSUT9xZ6YHyzCnOD02BpEE6ZAK/8f2h+fol9ynD21Ux5jNUndMmnXks23zpz5j68aP5F5QMkfWlXHgEDbBJ+a3/paqDrLiSaOUsGAQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(4143699003)(10067099003)(5023799004)(11063799006)(6133799003)(22082099003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+IpZEI2Sr37Sd5xHl5k2BlMHh1CODkXat0QJdJbD9D1ZxHnE8z0IgxpOHh8N?=
 =?us-ascii?Q?/5/NtHrXCgQEtAEpMvPNL9bksezr0sHxHqrh6Nb5ypAWFeggoR7tv1PYRaUt?=
 =?us-ascii?Q?C1ziT/NQszhDbWF5gaS97JPmePMfey3xAE/hNwHlkSrkNPKR0dayIcr1//mx?=
 =?us-ascii?Q?ab3l01EnfrcrIWQbwtm38d89S3LqZhlOeWx0oq1QHGrFqUwWf8xKY6M2UCIV?=
 =?us-ascii?Q?kcyvzTnnNdxj9vAQ3b9uOon3Cn412geTTGyC1v9E8SzcaErFUGsk+H73t7nt?=
 =?us-ascii?Q?2EN6aT5zs7jmhSeWKYrJeyDAPhT2VVqn9MyTt0lTfqhJorg7xCtXgoHO/+sF?=
 =?us-ascii?Q?8por4zw/3X5OZHPl9FRaH3zEkvUvZjICNMDsHTGH9nkyKDemYaOi3dPOj2dU?=
 =?us-ascii?Q?NPKR4Q/RBjZHwM4Vl9u6OCP4Cl2IAsSGnvl9NTqRZwtEeJL8J8T1DrtmjC7T?=
 =?us-ascii?Q?T5+Qy1R2FW+NTqlCy3JifMsYGYVaUbcs5qQDqizBJxz++OUO2Uw303SIsIxR?=
 =?us-ascii?Q?HZvNpTWYK+tvnipwcAW3p0kSq0EEf3BOYXr4XfZAac+JowKTaqsj7gnB+3Uh?=
 =?us-ascii?Q?rP7/BCfyRF34txqT8IW+9jPRVOQxPpPH7niEh7jE8GMqSQczVJSQ46wkRj8L?=
 =?us-ascii?Q?i2e2iLso1LbFf/KBKoM4elMAFiyBm5ZRCwNifxHsfJAvxqmSD7G2gPctBZWC?=
 =?us-ascii?Q?rrDHcYV6hgbcQPcgvkrJt2GxPwQPUJs9mmKEqHqn7XO5nutS+HGK4mWi0VlI?=
 =?us-ascii?Q?PggaNV+8oD+Vuhy0/qJZU3GccJGiCJvlxhr5LF3y5oTOcR8XsjEQMw54TVHu?=
 =?us-ascii?Q?8iHPz1nW4VI0spp90EgwNJgIrmozWoTwO6W29VYTgqB14P4rCwDGRsckXUQX?=
 =?us-ascii?Q?neqBwyl9ClsCCTufqLp3pXO1+JPhSbjSUc0ZQ7eBJt0zJCtsA61GZNL6HCyP?=
 =?us-ascii?Q?A2sjQshBioXslxhAy67+iEg1bG5Jcd4GjLHNC82up9uLUBgVzZ/znm+i3oUb?=
 =?us-ascii?Q?Fw/A2FhS1bsG0OCBZtZ7dXbugiBWKPConO8ohEDt6zzz6trSs0f3DPLCMe5E?=
 =?us-ascii?Q?kshmByM7k7H8xzvdMyCV5pzp3sHIQBT5a9A1iNRylWvFWMECQKj3O5ylMTxX?=
 =?us-ascii?Q?OEnxJ3z1uJ94ktCyGh9Z5d4BSfwITgsdjBQU655X5DdJw8/suBwLLJGauivh?=
 =?us-ascii?Q?77edg5JCxoEukgnrvLZMhwKw2GYu9OGjH6UqKnCEsGuw2GfCNjoJpflJmZ6I?=
 =?us-ascii?Q?dt11oC/i16w5mN1r7JA9lVtVYBywEcJ8y/n7FCnxW8fNQBOK7n5WBCoHCdqd?=
 =?us-ascii?Q?+3SsMBH9NIsMRz56v8KQo35ULdAdRWx9DtPq569dL4s/18YfHxah788c+mHH?=
 =?us-ascii?Q?IvS+BD90HKLW8fTNBvyyaHuTs925wROVW7a696aw41JIWSZLnPnSFeu2VTo4?=
 =?us-ascii?Q?n1+CG2Hmm95rCGGjf2ixyAv4Z6NagTf7f9J1TO5dAeWclXlW8d5UvNxUhp+K?=
 =?us-ascii?Q?rM6iMDsZ3PExsp9463OLlBddKeaGBMN1EkuBt26s+gqHNbhkKZ5mFwjBPTWA?=
 =?us-ascii?Q?jwEjq269YQWB3jCU2gGMzbx+vYbYQCeIei8s4G56izm1rqgwj11uguMyBwvo?=
 =?us-ascii?Q?+Xz3yLmWFIQAOg/By1+ywbfl5s/ARPxyIrZfKIrBT7oLeVYM9o/LyUFka2Xl?=
 =?us-ascii?Q?Eamlsdm6cWHD8ZWqjYUlYFN6QsubohPH6nVufhCSOLKp5bBx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa80e47d-db93-40df-3eed-08df0aebcca2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 01:19:57.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRRc4cXkdf/0ewHZR6XaYxD34qqt6orXQZdmTvAly1G7vgv2x35ZZstKvjk09yU2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001
X-Stat-Signature: cctmzwd5y7kcntqt9ztykyc5w5h3aj9n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8934640005
X-Rspam-User: 
X-HE-Tag: 1788571204-354040
X-HE-Meta: U2FsdGVkX18CRlibFveTIYt4BqnooxIg9YrfTwVtY32kvbOAxXQia4wVDIh4awv2aqBkFe8EBSl8LYq6lMbI6o30Do+SQgLHvtr6HKYAznbDnrGXFXBTocVSDH7B6gJc1Rfkh+P9FvwIUYW2wFEhG6e/eNHfKjP82M7b/0BeV0e15hMgUMXccUSAMWuFvavB6YEK2uoMUig8HXl1/x5DI/ME0ypA9MAyGEMYLR9WnsA2HroQ1unxzOORN2yqv45ecPjLbKOTQZTzMSH27ih+YiKUK+CD2JSi5aIFfgVIqLdn2bBbZ8vLTmZ5E28fM9p/TZ/e0Lt/Auar7E7/3Eq8H8MQ/BlhSIaniaBQ7P36JsErru/yFEsVpkZmCCL5fgfEuqFxyObzyz6eRPRF2IeZUkzKsIbbh6TqT9MozSRAoF5CMAEpDn6zlyVINiKt/J8kRWo4/t1W9avNTeBUdlwFG+nFfyFLNYbmMxI8UzL2OifwlwxBLsLSdOGp1BHw5GOTnIzzb55e4ApqQ5DkonDo8QPIcANjMBLBx0ODIpAFncpZYS+1suTDqntTJDtvoOTmotk78goajOy+mdVG/x9zHWk41IMJXtplAB4fLKjpyyk8f6zK9S+XZg0pRn8XuMFXVZjF2+G7M98jUWj57oS8Wdl/fGTZ3ipOryMfdv50VV7x/nsskkUR9pL9w6EWGHKHrifaAOXpSJrFcjJGOIB92EoEFOBrMl3HQXANqczYFb8zxB6RFALfyPSpA8L+aUTn0P2TWRsWCRNHSQPadBAQQzT0TkMdNtJG9bqYHQir/2DUR33sqPweseu10p0RM26HeNqZ8xF7m7u6O3bEeR3hVYCp4dtsK1oHjdtdnCcfms1amCM/JN/ICykLobPhlkV75yRrnF8LGUUr2rtRfAq2k3bZv1Iathl/1Dc+YriubCIW8gH0Wajx/zmhipdKAv36mYbH2jHLeeI6vfl/amP
 MngVBnfe
 8SOb+s15kHoFOikCn+JCsqs85h5pijtllDL94P+oIxK+Shz47OjJZx1pl2ERaRSkojzWJ+R6dbxYOXYNcf1v500yVKhc8qObkwM0owpYniqSgd/cBp0msrVi0rGDhA8mYNUwXjM3htNbuEpJR/v4Niv0EHiCzpevLeIiy76olo1J97vK5saXbkb7+A5NtVX154NSfDIbtwiddwqY+7xF9CmwQ5ZBtyy6I+I521bM+DQriRmfxW98d356Sorg2lv/P6aY9nnAQN4Slkl+5jamIvhjmXoG+mHZvCLJSD4nhwqJ9jFMI0xIkP+ceOzZqWQmphsle3X0Fe9ss0MgGMXQlq1Y2J6+yzG3Pd5ZwPE8XuHLfeflKGW8xMUbPp84HfkIOu6GFRC9EXdrVmCKAQRiv3Kne2shsrk9HlMhA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:02:17AM -0700, Sean Christopherson wrote:
> On Tue, Aug 18, 2026, Pratyush Yadav wrote:
> > Hi Sean,
> > 
> > On Mon, Aug 17 2026, Sean Christopherson wrote:
> > 
> > > On Sat, Aug 15, 2026, Pratyush Yadav wrote:
> > >> On Wed, Aug 12 2026, Sean Christopherson wrote:
> > >> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> > >> So with live update, we don't need to keep backwards compatibility in
> > >> the ABI forever. Of course, it is good to minimize changes, but we have
> > >> more freedom to change it.
> > >
> > > Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
> > > statement that live update doesn't need to support backwards compatibility.  I
> > > can totally believe that the folks working on live update are ok breaking backwards
> > > compatibility because their use cases are "fine" with such breakage.  And I can
> > > also believe live update as an upstream kernel feature being developed by those
> > > same folks is also ok with breaking backwards compatibility.
> > >
> > > But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
> > > to support a world where KVM is allowed to break backwards compatibility, so long
> > > as it's done "carefully" or whatever.  If y'all want to deal with the resulting
> > > complexity, that's fine by me, but you'll be doing it without KVM.
> > 
> > Let's step back a bit. I don't think backwards compatibility in the
> > _ABI_ is all that important in live update's context. What is important
> > is that our users are able to live update from kernel version X to Y.
> > The line format the kernel uses to describe its state is an
> > implementation detail. Our users never see it.
> 
> The rule is thou shalt not break userspace.  Whether or not the
> breakage is the result of an explicit ABI change is irrelevant.

I argued strongly for this simpler approach, I will write here the
reasoning I gave.

Firstly, "live update" is not uABI per-say. It is not "userspace
breaking", and it is not a "regression". It is an internal kernel
mechanism to allow the kernel to self-upgrade. In the industry it is
typical any of these hitless update/patch/etc schemes to only work
between a few tightly controlled version pairs.

Asking upstream to carry a full matrix of every single version pair
ever released is massive over-engineering and cost on upstream
maintainers. Refusing to do this is not a uABI breakage, it is not a
regression, it is simply a lack of a feature.

I think upstream should start by agreeing to only support forward
going upgrades within a single stable branch. If live update becomes a
success then maybe we could do from a stable branch to the immediate
next stable branch too. I don't know.

This alone is already much more powerful than live patching.

The balancing issue here is the impact on the kernel subsystems
adopting luo. Every time you change anything about the internal
function of the subystem you now have to go test a massive version
pair matrix to make sure everything works? No thanks.

Luo is very invasive and a huge PITA at the best of times. It doesn't
need to be even worse.

> It's probably fine for Google and other large companies that tightly
> control their kernels and use cases, and have the resources to
> juggle the resulting complexity, e.g. have kernel engineers on staff
> to track feature and dependencies, coordinate and plan kernel
> upgrades, etc.

Every downstream that wants to support luo is going to necessarily
severely restrict the version pairs that can work. Like a RH type
distro may only support it for 9.1.x -> 9.1.x+1 - they can carry the
cost of figuring out how to manage their patching and compatability
matrix on their own with the tools upstream provides.

> engineers on staff to help them thread the needle you describe
> above.  And if supporting live update as a general feature for all
> users of the kernel isn't being factored into design considerations,
> then that needs to change, otherwise this is all dead in the water.

General uses can use upstream and do CVE upgrades within a single
stable branch. That's good enough, lets start there. We don't need to
boil the ocean.

> I also don't see the point.  Maintaining a rigid save/restore ABI is
> annoying, but it's not _hard_ (or at least, not _that_ hard),
> especially if there's a set

I was told KVM had the smallest luo footprint of everything, so
perhaps your perspective is different.

In other places luo becomes coupled to the internal datastructures of
the kernel, we literally have to preserve lots of kernel memory
utterly unchanged without any kind of serialization at all. This
inevitably creates restrictions on the evolution of the kernel in
general if we can no longer change in-kernel architecture because it
would make some data structure incompatible with a kernel 10 years
old.

There is also a need for *downgrade*. Meaning the N+1 kernel has to
strictly emulate the limitations and capabilities of the N kernel so
it can be rolled back. Can you imagine the nightmare of trying to
codify the feature progression for every single kernel release forever
in some impossible scheme to enable this? Again, no thanks.

So, what upstream can reasonably do, that still provides real value
without severely burdening every subsystem, is upgrades within a
stable kernel branch only.

If some distro or CSP wants to do more, they can deal with it. They
have a far, far simpler problem because they can exactly lock down
their version pairs to a very small universe. They don't need a single
kernel that can emulate 10 different releases of behaviors
concurrently.

Jason


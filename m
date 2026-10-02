Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FD3CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 17:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DED6B008C; Fri,  2 Oct 2026 13:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D00B6B0092; Fri,  2 Oct 2026 13:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6972D6B0093; Fri,  2 Oct 2026 13:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9CF6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:18:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46620120711
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:18:28 +0000 (UTC)
X-FDA: 85278345096.01.7C35CC1
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72C3114000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:18:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dsNCoiQq;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790961505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fwfp8JOnrsItEDt8QqXm0reSHWZIwUB0O10inUaWeeE=;
	b=qtjPEr3Fmz6S7UKSwMMe9+VP00yBiqGo+kZIVPbE/fLDfkUHIKlo5pUhotKNlTndQEPGa+
	2l+F6Kjdz0ldnRF+SCTk3o9qJ8PDE4oE2ovJF3QgfEPAl63fyzw+uv7KL+1q+rge+D7Mtg
	BIrxenX6X2JUswSfHRjgaaLl/cjNRtU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790961505;
	b=h+ym+/k8qkznI8SAu+IH9bjW1PbAoN7sZVokpAAkmRhWobNbP23e7YioTWxeYzKmsqGxsx
	xyQtTP6T55Y2A5CYbVW+7AGxInWvWQfjepxFMUmWmc6xpTN7b3ex8Tj3txYupGFiuJK2ig
	aUF243Zww28DfcrtX6e5RSn37fjJCHA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dsNCoiQq;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzIzEawDtQSj8fhPzQ29+peib8HSpXQE3sExscTDL05G5eqDLXzlUttiqSqgOE3jtn5I6ncJTjEZJaJl9J65ATucKD5/2E6IOiZh5JiaD1cStMP9zlhL4eKJRe0NM12gucnVJ/o8bnP8RyhctN1c9SmCzgPC5ylFQ9nBcqvUN1H7ZHHhCMfNZSo8urzUJ41S2kzz6vuqP3LvpgBYyEkHhmADAGapJrD16AoeYUxtqlmyrNfU783REKC/GzHECMObJItIdn1uOCj5ZAbr6DdrpCDgtbuI0fzwKsZ/WefBPHRsVIdSwto4OFf0SMFI4tYn0nJMEgQIM8Qb6tKtadjqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fwfp8JOnrsItEDt8QqXm0reSHWZIwUB0O10inUaWeeE=;
 b=FktH9Y6CpnW7/1l15VczLs4jjSWID9HGSCWRatsj0R+hmJ/uu3ievUiLEl5ujXPJh4S4E5rFCH14jR8dzB3J3TAlwzAKumLyiP8GLaWufszzwPciuj5wsenSnOK5ErW6HT1Re4Gf0V230gZWR4Uz5RZZGMrmkd3KCBwCzLhpUPPVjrWmDw3PCvgzB6oVuBVAQvypAM7fhvdfEzTFuLF+rM5i/yYoJvaeSLxaOLWXplY1LEw7+r2KLYoAahI8sPkavZXwhbZSU+GQLqexzJLDyNCkrP6jV8uP8tol1KhBICScKXp6tzfy7N5cju8PXIh3IYRmUMisgLTlUnNNrCxDpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fwfp8JOnrsItEDt8QqXm0reSHWZIwUB0O10inUaWeeE=;
 b=dsNCoiQq1XZbFrcTuRpBoUFtSq++Vx/mvbhjVAxEDjFjo1L9dBM+3W4ktFT+Z9sNdi3No5iYoCSsfl2lZSvW1g0+qGwjIL6GoNqegfyoSLyScgW4Qc3NulJabjrvlVR259E724KBmPLZYU6AlcmdEX8O+ROSrQHFWL9zgnVvFJKVeFsupf25Tk0qWgNYwwDBRqz0CdrygKDQx2u24VcMCBUe8+5ccCoYJW6tR0zSaTQmfNfrZrjq4u927cZ4oB4q14buuwgjavapxJDHRX8X6Ht0EVNuwWZfQwvfjz366FObFxBGsi/shMTu9f601kfpML+medU0XPwSm2tDxJc05Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7977.namprd12.prod.outlook.com (2603:10b6:806:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 17:18:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 17:18:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/4] kselftest: mm: integrate huge page checks
Date: Fri, 02 Oct 2026 13:18:17 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <36DEC53C-FF4C-489C-AA05-8051C33416AF@nvidia.com>
In-Reply-To: <20261001-fix_split-v9-3-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
 <20261001-fix_split-v9-3-0f4ba8bbdbdf@arm.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0793.namprd03.prod.outlook.com
 (2603:10b6:408:13f::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a98c2eb-66a7-49a0-9b7a-08df20a926f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|4143699003|56012099006|11063799006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	InI55kX5rQ8K4S34VSxkpEsVXtDq5/P8bG1heefOeX9e1DNCu/iS1quJFNxtj35uTe/yTUiLV4HL/f7pKoskw6PLtXCPUCspBo4xy20h93Io6RbbYxwiBu3rshipJdUYCP9nL3pgNKjAUMlkxMtVOMojb1AclbV8Sze3/h06nUbAsv9xJzD7n/Iwk6Eapcqst1Ck653ZMWC7pn9gSLwU8qTozIHIyYd0u88fbw1Yq//Sb34fh8Omc8iY/tB9Cb0nkYHySTSwIdCkhyh4y3Y++r+AgQpkQfHZQ5PRhpAOG/5rDfNfLluYs9lwnkYWx44F3b/OSEhUlmxctBEbODiBYGiZKkHWqIk/uq1uVqmjUjj99x/fEoP7Wqf/zl1kgyQH1caHl+YonUo9P8MCoFWJUytduS/uvWCCSJYez6FuIHtXlqztWadS7oyC6Nx0KhSBaXiT7XoKL6BpqJcSrhT5MSxYv/N6rg8ejgcyT+tphMf2/teOY7SmtorXAPk0IAk4s1jouKq3XobLCzurEVG06yKM+qk/TTYZmuglazWVe6Q6Wt+Ror3SPC4M5jmWUZwLVa9G1NaE7MF7TZg7iyBBY8C5rZGJZcmG+OkY3hIZbsVd7UDjqca8I+x6H3XyOwNEE3GZr7RmHYqLJRN/cGWtpWMiRGytugLecGnQRsywYV0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(4143699003)(56012099006)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PYC6//crLt3/wONU4SFvuwG1CiHxmx9kJGMxMdbF3QpfxYDvbGViytMCt2mh?=
 =?us-ascii?Q?Xj3rJDJPhCaMRwYL4HagOQB21XB2ybVg8IcxBgKfYK/iBqIkLIttMQ+rkIgk?=
 =?us-ascii?Q?zlF+q3P4scFTkBFBHskZ7FCxzzlD2/0mdxItiJEe8kKDjzodKLQrBJmqidNt?=
 =?us-ascii?Q?OJZO8s5c+vIoPwZxtULsZCpcPyOpcW3moLInOGZbmdmzIktU+VjjErDsJ9d5?=
 =?us-ascii?Q?6gN5fXvE6nwSr9szBbylHcnaMqqLKzm+UmBm3TBTtmZfKEtI1lDYSKnBJnxZ?=
 =?us-ascii?Q?AHN2Nv1PCzYSk6X9Lt7HytNVBE6fna5VpBPa+3jscXroxO7gAYI0XZhUzt32?=
 =?us-ascii?Q?O002irAhdDalMeosCsB05DWe+SggEqbOOHK4NV8hz1Xcvn24qIkI+6GejLOJ?=
 =?us-ascii?Q?E1KIRlvw81hX33GeIo2xCFE66KM6ACiFYOnUOPSCQAnKoLJ/+L28oSxzQxvi?=
 =?us-ascii?Q?TMVhjz/hwoQdWsFq/aXgYUWsGZwruoLgBn4qik64B2umwBpu+RdlwY2L48Kr?=
 =?us-ascii?Q?gak3M5XZd9lmB+/Z7UnQNclKa9k2mLvgm8Tb5g8yeSemsUDZOCLn3Ktz8/oG?=
 =?us-ascii?Q?/VeA3QLljvoisgorN5CyaGR0FPR6dRyMDPmwylcoodci8ouSqBvkqChAnZag?=
 =?us-ascii?Q?cLps53eDhWgpd/+vCuaQdlNbfkaYwmUKvLqgyPVQ1UNBpxBMX+WMr90tL7gF?=
 =?us-ascii?Q?GxCwvt9zRC0JvCMuLX6FXkCo6MHFaP9lJo6MopCWahJZYinUUWKAEFxCFrzA?=
 =?us-ascii?Q?F8kO5xh+RQuX+ugPZGoTHmj3S3g8kjf+OTpCANwpryBhZL6rXoiGbKS7gwRV?=
 =?us-ascii?Q?VEWieDMwRIBrGh+CkWv8ppMSXXA9m/X6jTBAVfb3w6H6MRpZ/a9L7aP4K8ea?=
 =?us-ascii?Q?ohKHvDkW9Nr4fV2mcuktfvZlIfb14sFVw7GLE9bPBJZRCQInnjaQhKdwPdNT?=
 =?us-ascii?Q?0kQQ4EJGa334m+ezUUCn9093yInaeaEclrKZLS29SvrvvXuZqwuf/bvrVSd1?=
 =?us-ascii?Q?PFinfRvDyEKTgQ3UpPcfXWfIyj/dMBWZkoQRS033Chd0f6+oNIjooAK4ybZc?=
 =?us-ascii?Q?5/wLvAE1eSF5tRc++bHgyEuco9GZ0baKUjRWqEk59S2aog5zD4rfgj9W4agh?=
 =?us-ascii?Q?9kvBlWw1bM9FZ3dTt8iOzn0SC/McBEplN3jAVpMT/saQSaYHK6HTOxfq5fN6?=
 =?us-ascii?Q?acJVlUZvcCqizX2UB0oi4FgRtN1Mh8cnFeCo3XIKAVCf3y8ORoYYWLkcszV7?=
 =?us-ascii?Q?8RSR7Om3mmZb7BEytIlgox51/+UYBYr/jZjJ9NTWS8SKHeItfKoxWosdW8Ef?=
 =?us-ascii?Q?VTFv6PIj6hhBePPRxYeHeroWUCmKwR71MyEkpJatxIQCL8wJYKF+6MqlMn6P?=
 =?us-ascii?Q?MKx9LX+A5sOmOcewW463WizpAI6JIIAa1EKidHRjLpIwbWZbDpmptlgbqnta?=
 =?us-ascii?Q?1efyRIqxNmh4jFDDdXz1YiyFFEmgT24vFSyLRXPW07Id2gwrVnTYvJh3t6Dj?=
 =?us-ascii?Q?bexOIDhHQcNa3HVSYBb2OKJuAJxJ31sl5TmfEA657qtOSkf7Y9IO94C/V9xN?=
 =?us-ascii?Q?vVIFKR8MdV6LeMm1kkjGJwrSflO9lHdAyg0CJah/wYeT90DeTzDsrbPvo22k?=
 =?us-ascii?Q?vz/pMRimMqk+1RyF/thNJW62sYKw0LGltvk7bQ1AHGZy6AgqzZ23OyNqsbMo?=
 =?us-ascii?Q?xcrE1ClZ9gi3fE7G+Y6JxcvDyaz2opD1c5ScANXkAUOve6vEY1EjR9En/8HO?=
 =?us-ascii?Q?XtcQjaCt3A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a98c2eb-66a7-49a0-9b7a-08df20a926f9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 17:18:18.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmU4uUrHnteMPyYNA3roVZmxvwK5LyMDbBW5g+z66+oUQFAxWTHkq7R0vhGHx4T6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7977
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 72C3114000D
X-Stat-Signature: ymm5ziy66q7o65kai43kdq1s6jrd5m5g
X-Rspam-User: 
X-HE-Tag: 1790961503-163104
X-HE-Meta: U2FsdGVkX1805V73KbKRytLitIwCZaSZvyQE2KJWXuBFNyBKJflmVaCkm27x9FwDNUUayT9b6NH8h9ABugVv3TYDEG3Obs9fvayToLM42VjQScWeVTH+qlN0evtYyql9xnFMxUJVMJR9xzZqLCVRHELTNuRUlA0ZseihY9/aaRcQ+UTO9n8Dnv/cCnmc8cI3PTHDsGh05D07ZCacNX66IONdx4QgWvttNnJCwFmNfTtfUx3n2mgyq4iN7wxSzuChg1YwVo8E8t/eFt5UbIq7P1Cd9LH4Nr1oaBxPmaXf3LvvKTCE68YQpBbEVDrewMkz/9ptCjpGhikvV9Ko6KPFXyPu9s5+oDiM8h1I5Ysj0SMEoevbO9G2jP6a8j4WSs5HAVrbHE/6SDD8KuVFpgV4UJuNqXUNOM5R9taH1/SM4sJYSeB3KVIVtEJ3mEqryhaDjQtlAAJffc3P6nyc9/ZIpxdfO2z5RrBIQPXSMxO+e1kNDDcRqSs9jabMKRpzruVLUnaNWDNedhuK9ynWLVbfLH2kHnSC7gTqnddYm+YEXevEi0kIXa0MIayMOZC/4QoJruOByiGP2e7/HEZlkniPajYZ4wj5y5fcI4OCVCCXAcFlVO8S8jrZujJSf/XtYr9NiDEhgXDvwj3aJs6Hd3SidB6HawjIYH48ENBd4xSirSYOG5HjSaU3bHxdpzid+iLcKXGL/bFa/YQPCT+d63Je5iqSJU/pr59uFRjrI64XtS8DgFw3GXDSt6rh28eko6cz8953UMK0MiVeYlPJrk/mC3iB0Mzv0hT8w6L6/ChpfEy1Lu1AlVqryDBjuwxLQbTT/7BRmFQW8Qz6gGffORyae1NVUw35M5X/h1JJVfWoeQR2B/Kl0HOANhyXoodKzo0ROY9eLyhnvW916X/4BoCk7miDWWz9gOVr6/w7m9paH6ycuSCzqzqQOgxwhCr+m1QU++qxNz3ZnvBDbIDlHmP
 l+jS4kQO
 sdvi7NM5yYWESMQxZE74ybUhTv1PkRgYC+OO8O21Qenf9Kkg4svIus6OIaqtuUjH/0Dpr2hP6REqx4bLb4l0cTUAsdivoTMZTE6ol9O/dx89jK3TYU4WFAnN2qLV/Pr+wtsHgqhmjWPYv5TEdN+MmfXRju4aRZZ42N8HsGZXEmUvEnK22JPGHsRZrDt7/jJKQi+Gwy3gSe3shBq/uno3hSKUEfXQhMrwYIWUS7M0fLVucmBO+lyACHRSfceaAm9zcJGCNUSYYBzfw8HCklCASQ53uvzbiQC3GsbYuu+YL3MR0+C6Kt3AzFfp3CNDcKcw0g1ltLtQ6v3CDiJjmFJxx1x59P3kb93eys2SBa9MYHhAX+jxb1peeaHDh6wWE8amNRGARYn7TR0Jklhq6xE9J9nyRjDSDv1oR4Jkyu3txtlC+tLTNRFKaHSRVMDXKxGEPjafKLMZqRZ3YSbPoMhj/+lTSGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2026, at 17:17, Yeoreum Yun wrote:

> check_large_folios() only checks for large folios without distinguishing
> between anonymous and file-backed huge pages.
>
> To add huge page type checking, integrate the huge page checks into
> __check_huge() and __check_type():
>
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
>      check_large_folios(), since only the mapping type matters. This
>      identifies PMD-mapped huge pages.
>
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
>
>   3. Check the folio flags according to the huge page type via
>      __check_type()
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 90 ++++++++++++++++++++++--------------
>  1 file changed, 56 insertions(+), 34 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


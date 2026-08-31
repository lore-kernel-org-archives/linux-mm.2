Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A593C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4C06B0095; Mon, 31 Aug 2026 02:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C816B0096; Mon, 31 Aug 2026 02:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6A26B0098; Mon, 31 Aug 2026 02:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAE166B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:56:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 374CAA2EC0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:56:33 +0000 (UTC)
X-FDA: 85160656266.03.E93AD72
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by imf07.hostedemail.com (Postfix) with ESMTP id D30A040003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:56:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=RJZeW832;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=temperror (imf07.hostedemail.com: error in processing during lookup of "prvs=3703582c33=ionut.nechita@windriver.com": DNS error) smtp.mailfrom="prvs=3703582c33=ionut.nechita@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788159390;
	b=iGasAoGlxsNdzMd7gXa6z5LSEcLN9GhVmSB7PSB/sWrKFMgYJ5BC4oA6k1W18DqXiuingz
	M94OAEhjrphYgZo5cZ2PPXArfEHexHHeB/C7UoN69+SfnUO1i7Tmaqv4enxBig7CVIg/O2
	M49GDvagLKE4HBqk+j1EPJM12LS1Q8I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=RJZeW832;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=temperror (imf07.hostedemail.com: error in processing during lookup of "prvs=3703582c33=ionut.nechita@windriver.com": DNS error) smtp.mailfrom="prvs=3703582c33=ionut.nechita@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788159390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0H+JtNvl2ce2qCmbmnHzgRZGauiD9lqsKifLXbuDtts=;
	b=jWB5TDnv3304MOmj5OwJ0TgHII8adeUY7uKAa5z5uzI6eQZpEdC9AgIHXXpzccQNRpoNNP
	CyjWYbHD4msanBMI2Af8vLoydwSRbeF7cmzPJd+/3a/Hg+iEumDxKawXmIFb+XCe9zbUmu
	hrXZV3Cu4v5umhnzURR4jCGzRYuQNYo=
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V54DNE2730138;
	Sun, 30 Aug 2026 23:55:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=0H+JtNvl2ce2qCmbmnHzgRZGauiD9lqsKifLXbuDtts=; b=
	RJZeW832gbfjEK14kE/CQ3C/eydOKbNd7U2amDqGbYyu0LRnyvOY20VBIOBRhlpa
	ppColJynyM+icjnBR213K1GIac4SVcKOrLXXyZEs8f2HuHu3WkYmvs73byHdnm7w
	SCXRFm5CKfb9pac267CNQUVCwpdM3xLmK8CCEUux3RcCn4hdhufjGPZcmx/iAiVy
	BANC/+o+pdpeUQrnQNmoUO/X26uUJ8Nr6I+hbggdEnpc7pHJBGWrx4LNWWzGkCiF
	4Ctd/Wi+sFcEjelxhAbF82PU8Ag9IE5SU064RIh1ZkWhb8A8v8L9SzvLy//xlBBj
	qLlldgElmggxSUVj0FAtqw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023115.outbound.protection.outlook.com [40.93.196.115])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gbtpy1vxc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 30 Aug 2026 23:55:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBG+xq2xjQbeZBHoxZ6w/KF9dAWK7gcBQ8fbBIBP0YmQ9BI43sihPh1CWf6R3wzNO08BFw+dHqo+F+hiSBEnOJB80WUof+Al4EEZ7FCbmHwqy9eZK9jNTYQLIT1yTN1wD4GFGOlpuXrsn44FpeWZ+t3hLSbTh7b7YFxG47804h0wrorQxOwBBzPadj/2e8NULtogT2fc0+ZwNUPrbk2UHbv9nxkA2+PBF4gwu5LDJ70BhCnrQmpH6179lKWcN2Lu2OFl7RuWvaEVc3vyhESCRRMhiLqBKxFzew5Pk+8P6kuI8HyDUbPR7E43lmipl8M9vv2WxxyZbueskMq9iFoREw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0H+JtNvl2ce2qCmbmnHzgRZGauiD9lqsKifLXbuDtts=;
 b=j4UWyrQkgyZdoxiVoBw7v4P/CYXou+FRLdbTEI0QT4S6OCyTwCtqOWzCbdYjygVLz0SKJMbi+EGr64PtfLOJ3XxEnfNfeHrCVYLFtKgIVzavYbOM6zB6kd/gLuC1ULVBcT8uOtheOvqGDk6c0F1gZFYy4fP4ewGuwpklRfeIehL3QiU/bVpmvysMv480OObzIoMieoko7ZN1e0iRxfDcVnhWjKO8/iGj/aFfcVvn3mcdGmHyl2BTuNpf20/iGAtfgmbBYVKcBPSQajHOvVQvBrywxWh8QPxV0fJON3xInIcO32ylhdZXFU+s6h3vcc29CQ0DSBH/yZ7wLkrVTrbHjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SJ1PR11MB6081.namprd11.prod.outlook.com (2603:10b6:a03:48c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 06:55:28 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%3]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 06:55:28 +0000
From: Ionut Nechita <ionut.nechita@windriver.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <frederic@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/isolation: Defer freeing of the bootmem housekeeping cpumasks
Date: Mon, 31 Aug 2026 09:55:10 +0300
Message-ID: <20260831065510.10645-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anA7GhzjZoi293Yy@kernel.org>
References: <anA7GhzjZoi293Yy@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0004.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::10) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SJ1PR11MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f291297-8a24-406f-53b1-08df072cd70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|10070799003|7416014|376014|52116014|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6BzG1/VFAxQX0M1g64J6xFDhyJam5GyO3xQIgLuUk9yRa3Q+DJRoQ3h3rZETaH2UbPneaNpgWOeyJBWkuaEiaJxXEJx4UmYVLrWTMAgBLWhz04NQAhq+jLUgrLWl+CH993zRJxmeo6lBFtofWWpuWxtTwKvL6fNFZD3E5E5LsziOtedxyG5Yn8unxRYISQ665D7OuNw+fg1WQ9sGQvlWaZId5Jr6gf3pDYbp+HiSibWvdka5oglq8xq9Kc7VBwvQsQs8zaCanoPu4wUzYHkRJrVCZIuZvrIJS3dOVofnDVNBtys+dpCArYNgEbZ9ktYp09P9rEOaZ4aCQwdAvFEBln8lvVqkj3XllCc05o9y31RoAMLqlZI0agQ2ljexltTOvRz8sj5x1IRnD6pqZ83WOd8B0i5kVqN73hPBMt0UhI9jj6OIbiiNvB2T2r3vVe2B1HrdJ9Yui/b4SUDKv/0KVhydT2GBYgeg/EW4qKnbdbFIG66Y2LjmGSQV0wvKtRc79h/cvcgQ7ARgs186ThpIvFo9ddrJdUxXeVEdCZzJYusqNcm8tolRxQ4XQ+slf17h2ziX7FGqsWkGV91CnpquYj4GSYKzusr2HtYB0LXxxZWNRK0yH8Eg5g5UvxHSmeTbwmQrmd04aFvHhO87yFhl0XGFrOT5K53cUYW+RIM/akI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(10070799003)(7416014)(376014)(52116014)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wc5tPXh4sTaZE7APHxHYZ0eok9TLmaIRaLN+PYvrkyyYIK2Szwdw5QSGpaP6?=
 =?us-ascii?Q?dXh2F81sFPrSS/33UI9U4clagsLUuiV3IHk5i3rJ8fHbw00rUiFNsM3zv8Yr?=
 =?us-ascii?Q?0gJx3ltlY+9e8Jy0z9PEUGT8Ravfo8WqQd5J00anRjlxxZkEfx5iJI05l9Nn?=
 =?us-ascii?Q?6wdZPkXPRCA/GXo7ufR31jxqMbNzOsuaYxSyQb5NF5EZ4DzJayWvTfpLhh//?=
 =?us-ascii?Q?k68folWyDLslvRTburyHCxUAT9igAHcklQU1PKUF+m0/C57YdPqUANkFPQWa?=
 =?us-ascii?Q?PD8voykAetBMa8I495WVkh3D86BdawN4A2sDf0VzQGVqUsXSYz9OOkXQ8Zfq?=
 =?us-ascii?Q?lH/Btn7sk4UoKN/gM//Es2rGw+b4urWwSOqbvRlJHgDekOBL2CaO08SPTqYD?=
 =?us-ascii?Q?k/4xV4Q2fBr8zx6IveEnA/7YDhLq8pm4FFSxb6v3D5BvTn2vcMvCqOiPR2vo?=
 =?us-ascii?Q?JWhyXKEHfzQiJdySsFYYrYeY5IsDF/gig1Ug9jXDV9iz4fHAp5udZKPmhFg4?=
 =?us-ascii?Q?DBSDl9Rof9NIA2Dmhhj9DME+7Xn5mhKRlPzbwjN7tLZiOPDtRH+ajeHQGhqN?=
 =?us-ascii?Q?EBUqPihi+b00+eaBF/8FzT/lE+exaiwKbl0chUMd7LfxrxYkxOusuIeUgvIS?=
 =?us-ascii?Q?agonWYDn5yhNlJbPrwS+gz5Tisy3X2ihfkJsYK/De6nWV8shvput+JljKb3S?=
 =?us-ascii?Q?QgJiSEDCZ9jHrBzCBYcR1H79b1+OrSRe99pnzhsCU2qy7ozMnOHBuaSDWKPd?=
 =?us-ascii?Q?T0KkYS6iiQrBILuCRZSNs1XS3jzubaMa14wOlkmQse/S+8wjRMsz+bU31kBj?=
 =?us-ascii?Q?nDkTK6+vjgGhjs+Aqv6tAaa3Gkhlk78QdlXfINElsR154IVDhA4gmhjbCu//?=
 =?us-ascii?Q?dnx1XR4eQF1BaP16mqPIk67hOQHqgcz3oVKxHaocQ0RJIX8mbpi+cumkfaVg?=
 =?us-ascii?Q?R3T/HliHD58FjqNxIF/xA4Ic8FKzXkke9kqoiE//R4igMxawXwyfADN/KWSg?=
 =?us-ascii?Q?gs0OE+2sHNz9gjjACQCA78cIIr6HcQfade9WZ9U+mWYKdzpZ76Jzj7p8ZyWm?=
 =?us-ascii?Q?StZKhb/WK4H6sCbS2GWjEO+fQeY3PwRwX6tYF4AhnTufs8WO7gtljLSObo+T?=
 =?us-ascii?Q?vUOmeyio0eHmj4RGhvAUzxLWm+JpJK/ObSUNoFKOSZ9WaNXJHaglQOYaj51H?=
 =?us-ascii?Q?1a7WhQoshxko8T7xuvn2Er2FFXE+HVTpGK7K5sq15W2V2u+qxPWZYnC315lj?=
 =?us-ascii?Q?r9jbuYqxrTh1KlziFr5if23lvjhAbOQM+Ip210kBFD9L9L21ojgWWdFEX8Pk?=
 =?us-ascii?Q?yrW8fC7T6q28VvOuLYYAmB0tlzY/H2D8kIwWQNY2VTAPsiFK851CqyxWgLn2?=
 =?us-ascii?Q?ZWhTYyUWEj6g7eZAtU5jGiEatZ+H273GekO0+RXhBgj5VmAwf6AABWslK6wB?=
 =?us-ascii?Q?2SxeR4wK1KWnFRWGSa3zKl+lL5OXxMu2kKj6pT3VKKlIdd1+3iv1oeyH2ILF?=
 =?us-ascii?Q?6AJ357tpnetyjXr5k6sb6SRp0AzPQbTJEdk7JeYruCMG+plHLhWepA8/cOG2?=
 =?us-ascii?Q?MtTZhNwb1+b8crp+7zWda1xgkO8thK3VjMRrH3XOeTmOTFRFUmZEnGXVWRNq?=
 =?us-ascii?Q?oLCLSMRf1+DnR3ziHNVnXOvNq/2XH0I0T0HJzasVr690/zaCpcroDphxQeBR?=
 =?us-ascii?Q?+4IxUPbOyCEBJ1IqUSJMQ3qlabzR8MC3+TPHuB9i9ZRLJxRh8/gcLtnjS3cB?=
 =?us-ascii?Q?oPKGDFa9AmKFGg1A+atg9BHeHWNi8kpEmYuznyW9tI5kmeOuS0lO2k7bjc9M?=
X-MS-Exchange-AntiSpam-MessageData-1: GgUB2A/Q3mLNZktJu4hx0EUQMieZhIbg62A=
X-Exchange-RoutingPolicyChecked:
	4o4Avy/85YVlhDqHC9hHLo9/cEG/EzO99dWDa/stmiVLFESpGu/jc6tyD6xCMFW7uilWuz3RgqPp/Q/tJDSp76+DW4zGlipXquMJZeQHSwov1MA8Airj5mqkkt5yWzzaniiwuqfp8XNHsNRPu9HWRAPQjCnop9OpCB94lk0XEMQrn7P2jiQTxTrsWmnxulDihhSIuiQmbtBhE3BnJnlMD12Ki+NWvuVi7OI3UyRkljLTPzeafl2guUOZPQW8lbGSoh7bwbqRrNTtKaZjp8hHpJZgku17o831qpAJLSCauUDxitPjYt6aPvNtKf7RHA951bZMWeY/gSQoI6dQEw1Zrg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f291297-8a24-406f-53b1-08df072cd70e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 06:55:28.2443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9biPa4LG1c+NPdahsJ4w4liKM1fk2V/bNz35cNZGsxelrE/MljWWcTTjna6pL08NPTsJhjpKIfdISSr4GbmPNsreI9bGbBD49i/m51UKWOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA1NyBTYWx0ZWRfXwgs/udeCH5oo
 iwRxOlhMgHPfNovkTj3hTxmSyqI738z55W88RwafRB7wZYRSGF5rCGyZy2NX4A8R4wAHAomZGOz
 e5KbnhPqui+4amnYhzhHAsvxanl7LHUiqtYfV30zbi3NCKNm7p5DWwPWwZiVWl9JBdyyfBfOU34
 W7R/AP7B0WibkuZpHtwu3nkW2L1rYZRSS968rfPyOVff1dKzC/7enT0SF+H9YsN8LZib95C+Sw5
 kZDg7i5tZuhkbGnG2DLCR6wBusxyj7oOgIf5UlY4kioy6dJlUIlpK/dhcYQsEPqfE8063I3qUcX
 rHAjgtt+l/GguiD6FNYFXwOunEQHfuim7zXIHqy/RuGv2ExVloiAVbI4nVVbliaPrBO6ORKkR80
 hf3S0i6QYSVhANbIJ8QSFiYAPoZ7thWPc9pnac6l2gGBdo/96hdCM3fVlCa7ZMurOPTO42ZsUte
 SxSNRHhKvXhVSvdq0NQ==
X-Proofpoint-GUID: -jM0W55izkvOGPHe7OnGcp9wRc-x847z
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA1NyBTYWx0ZWRfX4C3bR7i37DDM
 SX7Ic2p3BvoSGPrNOKfLZDYFrAio0TAVQ1ZUubUzGT5xkfHUxllkOvmT45d6ZciVMsxDhNCQrBT
 JiXf060ncCSKd8bqNDtZDXWAwI8i6+0QFxVSuXJFOOCRIugjElbQ
X-Authority-Analysis: v=2.4 cv=ANEnCIlm c=1 sm=1 tr=0 ts=6a952562 cx=c_pps
 a=Xf/sOfNuiYS70hS914xU5g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22 a=VwQbUJbxAAAA:8
 a=zJSYoWzX9zstxPlw9msA:9
X-Proofpoint-ORIG-GUID: -jM0W55izkvOGPHe7OnGcp9wRc-x847z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310057
X-Rspam-User: 
X-Stat-Signature: ff5hyrkh1bazcjri15rkribrcniurbmd
X-Rspamd-Queue-Id: D30A040003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788159384-620831
X-HE-Meta: U2FsdGVkX19j1YHpI2iR+WqQ/drcdR4tLOsdM7uuSeuhwbpGYf+VVH4fTHMfPWgegBRGv6F8/fVOhpUR5cYAOiBt8VJN8kkt7wktyTI44gH9owiBGZA8auXXX6RAdH7i09KjM/Mk3+BF3J6C4cTrgD6fKE4oVBtuC9Pmu27Hk0ixxGgVYhPgWvfeRZ392WnlCTaw3WucKyO3tv16GVEeLQNMHuUQolfzfzbsvAbMg18v9YepEzdUBqI8ank3wVNAn6UIjdlZcx6mc5m2aqPGnksADdSpwk9HalfWP4HcewgcWlH12lPK/IwBlmHR1XOr6o+HH7z7i51zkqMWFWbEZ2s73mkA/6YNlJeczDNWRsGvj9HbnsRYLYN6gkjiE9IqfCJcPFcMi1hoFBzvviZXOjEAcXm/84VOLe8UwH1GEOENiTUY7IwtzTQ4A52xazvDm7fOzwjhDxmafqfBj2ES5F0XM9xrZcAmuzqTgmki2NRwbF38GWxzO23Frb1NPFF9/SI8msFVaE0xMlPTrar1Z6QtIWURIC3lEsS3GVSmOrKcpifO3aO+XrbSv/m9l9fXYEhCugBOIUibR1mZ1bPkxlnLeVULiIqb05GiHyv5DqBLxF/Xj8Zwn6QUQXYv3rLXfLjkcJTfQsqkcXQI7e+cSPsXd7mWKY/8MzOWX+hTgHh0HtlKpfi9Qp/FueNJvPyItLGC+TagNc6bKU/lG9Ac6iwU7bGWfptrh2IXU59TVIVZ7dnUhHw7aqmUXpogSV8nghyO8p2o0rYbAafwqlGHqZ2C1Z8emp1Oge1rPMKHj4+RbCNuvpHxbTtKyhsVUxLKAR8a/iL3mM1T5+cjrSzutI78HnIP0w7UWuR+XsJkD1NPf/0niydU2jYmdhNml4pIvU1KdG0cQAR681uPATryVEBm1tQM3XLgHT+blIK5kuVNB3AAvzzqbVe3IA0jHzSItzXg2yXATtTRiAZgfsF
 Ep4vKX+L
 QXgvYrUXWRiBpbj5Ry9+N5+4cn4ZJVmle7a9O9nCSrSb1mfl0jjYFzEENJiB/czElPfkIKHPVGmc/Rz8wE/u/NMtQZCTSvel5tYZCmkGu/s9ryS/iaP9uLyIqHw47X9IHUglnaM0bnSAhhymz/7QCtQOGSNke4LfXezyZnH9MqGZaIn1vbUa274FZ4jt7O+r9Bd7rTmdRrdK2WpAoDfunxbcduHb/9eH/1zuAenAI4DeMEQWC7HHvuH5gcI4J94El4hEaaiI/v4OWXP/5LqcSex43aIKxPemP5JB3y+Eo+m/PJmIXkwSMl7NLhp86fMoCObpIZImKXCupMEiOJATLNYkBZdlapJvOMQ6hW+0XVAsLDZjhQVKqDUzMF4VsLU8sfq0rbE2fvYV5Gcn6Xyh6J/3NBLK3geJ0xHD14sfM0lxhhEVptTh4Z+QKKxRy37fPwncM+Rfd5aFER9ClOj4IW78i80016hJPIJeNKGNRC8tclDBkUVtbxgaVoWmure/WAKcW774DRaJsd0UleHSqnpbn6N5mp8wHaFR70iRY6LoW9MLvrXDtCxO/2lkDTKRVzR4z4PLVQTBDx3+7hooFynPGwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 09:54:18AM +0300, Mike Rapoport wrote:
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Some nits below.

Thanks for the Ack and for the comment nits, and sorry for the noise --
this patch is not needed.

The same problem was already fixed by:

  2b58c749b8c5 ("sched/isolation: Defer freeing of cpumask memblock memory
                 to initcall")

from Waiman Long, written on 2026-07-01, applied by Peter to sched/urgent
and merged in v7.3-rc1. It records the stale bootmem masks on an __initdata
llist and releases them from a pure_initcall, which is initcall level 0 and
therefore runs from do_initcalls() inside do_basic_setup(), after
page_alloc_init_late(). I only noticed it now, while preparing the v2 --
I should have re-checked mainline before posting.

So please drop this one, there will be no v2.

I will close bug 221804 as RESOLVED/CODE_FIX pointing at 2b58c749b8c5.

Ionut


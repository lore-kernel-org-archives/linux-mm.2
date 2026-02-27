Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8DCFEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81FF6B0005; Fri, 27 Feb 2026 09:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E5C6B0088; Fri, 27 Feb 2026 09:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CE26B0089; Fri, 27 Feb 2026 09:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC8B6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:41:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F0291C935
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:41:40 +0000 (UTC)
X-FDA: 84490500360.16.3A82850
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C35C4000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:41:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vEh6fOXD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.46.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772203297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCEX0fENrVYIY7TO3obmYiStpmBPGq9v1/lvVl6zP7U=;
	b=pzQaTUj4yFji+zLXeahencC8Fe0Yk3x84fzIoqLSgRW5fRLKTPEzBzEDHwytjbUOQokTs5
	8GVe5E3meMdP7wq6iqxD6+7ilaTibKTWLt2BbzlA1dReA8LEVWN3nf0cgsjfeAWEf64bhE
	+UWPN6NiYjx42irq8yXMshvAVjaSOwg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vEh6fOXD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.46.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772203297; a=rsa-sha256;
	cv=pass;
	b=MVtlIM7BMlpZGXm8eeWT6SPOU9AH3/dqzD8uB8LCZhkvtbXs4aFgo4lJBbjigeTjr8QC9J
	acgckobF4wLCPFJSEoFAYKcgTCUlVtgzEvqFe2KyPWzqTuJos3gIXS4C8c6lTvbvot2rUH
	TXFt1WsG4S+9aPxNIIF0QJhg+X48xYo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWleV+uG3uM1Bp9hc21i4yZZfI5XYX0xi6wvpWDcaNwAtS3pKbP6N6ykEbyJLbbaapxwkby+yIRA6+JcKXOUrPAzHmHbnbnXuG8KTxNwnuhOABpaWTWJ5e2SVl5C/MB4V4abNceTNCzzNqdM1LhULXxKlB3bAdxisD0oKOBSUQYTVk6myxwdwKUbx+svAUUgqMBifwKvzm7YY0Wdqjh4iPZHpRyqMvTdiVuPRiJ/+KY5wjHIWLeD6Gxo8SCXXt3KkMOIKrsvo7BnPfgR07CgeqBlNsjsVGyz499Jt2q4NJnCgscPiOVFlTkmG1f1q4MOQdBWqpNQtFJkR5tmFthQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCEX0fENrVYIY7TO3obmYiStpmBPGq9v1/lvVl6zP7U=;
 b=qfilxX0kHAc/3qxN4mQqqA/h9v4gxskPQ+iSz5UTunWzQwxxtdFXX+M6z/wZDKATZ5hDbIGxoAWG6DS0lN+Y2vdiBDvn/RJP6xlbav1xhyYZMeyhijsGTbuGhReRIWgbgK3+Q9mj5uSzyThkDOZY+hXrFOeqbyNjwwOOtl2bAAnKiJ0hs10aovMLu6Qpy2QFb01948/7+eHb6x42XAScNupkBmFnJuanSxD/hg+Xtdvo+enmRn54WUM89qSZSwbvuuja1lJKETDWoBUeOZsYhSui1bzwrCn8WSYh4RI0OMMgSPpzo2GrO4Ir50YB97gt98MXPi/tbFpyFlWVqCvWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCEX0fENrVYIY7TO3obmYiStpmBPGq9v1/lvVl6zP7U=;
 b=vEh6fOXDs5TuynMUaly3Xfgmdqyplk2n9kPcCO7t3is99lrFNu6P2ZclZWeqzeIRyyhWdlAivFTQZY+XzbeHncNBb9N85h+Es52040Y2z6nyaxt1NmrC7X98Bl+2vUQoMIIgrLuIVrUeOm5aRM/hhBfGHKVfFGEw7yDqOzD6KF8=
Received: from BL1PR13CA0261.namprd13.prod.outlook.com (2603:10b6:208:2ba::26)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Fri, 27 Feb
 2026 14:41:32 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::87) by BL1PR13CA0261.outlook.office365.com
 (2603:10b6:208:2ba::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.14 via Frontend Transport; Fri,
 27 Feb 2026 14:41:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Fri, 27 Feb 2026 14:41:32 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 27 Feb
 2026 08:41:29 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 27 Feb 2026 08:41:23 -0600
Message-ID: <b2a255d1-9c84-4519-bfed-8b3a5d756293@amd.com>
Date: Fri, 27 Feb 2026 20:11:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 02/10] migrate: Add
 migrate_misplaced_folios_batch()
To: Joshua Hahn <joshua.hahnjy@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260226204059.481964-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260226204059.481964-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: e41301ea-d675-40be-4b95-08de760e4cb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	s/+okY5hDSLTMFJzmhIo/2KGkU8Hkjp7970SuNSPdRmYQUMj51+ymoBd6ph56tPJghjhXGfs/Tpa/fQQ0IRkKgmtTgR2HvwC4DfFCUYCgKptxhjElqT/D9OWZcxwKzaIhHOUzEqyUYg2T4PtCIhfg7Wd692dgWH0Jbs6nFSR/wO+C+cy9M+fj89zI4Zq5DicrsJsZWF3UpCBYA4/ociHqRMsXwJv3CIY0cUcI1JOdL7sie7hBuyAYsVPcI7Q6mvsRhC0bM1yweq7GSwf9iJAHvCD/qBzQTJva41y3x9Xiu8zoTxDRqls6cd5q0a8xXf0jevDHrAyEOfCYbuqmLiXGdacjRQ8l7iGsNsy2K07xStgcSHwlxPSpGMFaXbip4C7CIOk/3TIUYQWxesmG9gMLQMlW6MymV1j6tMTYWYNSHyXB/UVu1KVqYIvfT93p3kHGBzf8dVlqzgTsXszMx9nsKRtHX1sxpB6sKJwaU8Fada0C4Ke69ckL9CWWkCE0Z8ApfoPu14vM5S/hC8YZskcIYS9AszaAukce/uhJ0njuWAPkjQeBQzG0yO4pkt828mvL+Sls9m4hRZ6efv5zY5HgSvay5GuguNgom4gjE8m+zVpfYEq/mjmwk89QsWyrq24lm44qOx1S0HvSxZY3ifQwHRupBZthz3LIakl6a1lx9n6KU5tBYF9QtdWoEbpp1C+0YE67ocNiMjFN9feRdOZBxmxKjRgyujMGnR1Lc7tZ9oRlInJu+RwTjsRM9BKmd83p/ZLdJe983hdOequf0G1UStGTxNwyihOAtJFI+9qnQlls47koHQ61N7GHTmMdlHrqGegoc+4shFUkJgXb1pZiQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8kfwBaXUh2w+eJVNjn61A+RCHyrp7ANEeQOCMig58ENKiBSVSFDgp9Nctrpq4gQ8f8lxEA7Qz5TVlsHHp1Arpdw461lsdVGxHF8RdVIAWOa75FL7x2ErjQGZq+8OWToPOrLDcBGeZRXsYGkN6aSlcjaNuOni9HYBOgqMDNpSupuZqywHT+O4NGZk3x+OdEdZhPOA8CCWsQHnBaBpUIQSOXlL0YgdejaiPIEjiVoxUla3D4t/fvrQH6u4ZzQnI2+oz7Xf4W0vtafVmqoQBdQRxYJHyQrCPsGHqbJn2a/A9SSD4YSIF9SYm98JZ2ewMYk89JkZNkZTU+mqSKbvinl0ipl9R2NaLivNCKRPb5hfHVm/Guyxq5FSYeAmhq4JUy7Cm9VxDjp7/XCFIs0vJWAdbUjk3JmOFhV598y55M1ae9r7GPnCR+InKUHXPcGECEpQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 14:41:32.1247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e41301ea-d675-40be-4b95-08de760e4cb4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C35C4000F
X-Stat-Signature: 41d581m4nczp81izuzsg9j9bpuj886zq
X-HE-Tag: 1772203297-471809
X-HE-Meta: U2FsdGVkX19ITgtJAOWWIQXVufKNY+eXIJg19vSkBbo80SKLw+1Msi8BK0j7vpGPFR/fPrIBOtab+BOE1ztphXijkBwSjTQEunTNbdgbplzRlNfplYcUzbguJ9Y2MHVguYj5NZ/T8sIn4WMPZfzmop0+jMAKcRCHu/qVOy0spv0GgqZCQIMXCWlMUUEDSmqUMvl9useXbuvmr5Z/Vnnn3jvhd5ZoyGK0ArH0LI/pOjDHxgTctefCIcTwHJPcgcWIiSfZhQKygUaaM6/2ttAlqMEPhvxQ7UGEokbL4XYbgS0J+7ga/At/kkaZ62dQkakijFbMnidYrGILJQL97+ditquKgMLr/Fz1qtn0ccOHSPgC7H4cg6SbJjZXxR3cF2ieO2aOGxWt9kMm5sMLt6k8LPnBJb6tAEFj6AEBatM+ndrzpANnn+vwr2C5+7n1Lwl+HHfXZbPv0DvJrU1b93HoRVrsiTMHXrh54vBdfgqvpuWqFSO77H0r+wDfrlXoaBKBSo6g6XKBqVOK02Id8NHy2hXdfS2BQKRxLuK9Yaq8+eAvXRz6ovub8MrpRD4EBVk7Z2EZcIrSyvww7TbpuIDHzotAJuX3dkmnF5kcV6zUrmjoSe1i/3J5jIF0Afsq/Mufc/jSc/RipHEObnkbwYxe10A31jsvqM9+HV+1BuGZh3K0xL4G04lSnO0Vys3UaDDS71c8M6VuB0/W3ETWxgBbFIKTxmTsLW2qd7qIZcEnJxF8BO6m8jGL6emLWtf8YPFk2efx3/Vr9NvXBo/2/Kfmnc3yhwhIyWr8A6m1gnsWRGQdl4fcrLWOjm+b1/l/kBmvznAMEqU/iexEgUiN3wjGAAQyC2bZG+56QORXVQdV9dnOxKUoDqRsXYYRjWfriB/99Nfs5YHr4tNMWDAkfEmI7PSGXdOw7GrFmE/LXIaGim9/DqR8Wr8DJfIyhmU68NPP0sY99Wu4my3LEkYlTaG
 WeiySopS
 pQPR1FiR1/Dbje2BxMjOm9EjOuSuGpd6PYxICut2VRvJmYIdbKbGWRNska3HuQfl8GjbBvGrcWejv0D8brKU9gvRZxVgjuoqW4InzzrTKUlUthrH1DAvZNHAlk4TeqqcBa8ASFl20utQKNj23OM9w7XcDeYw2tK6QqwNxG6tCnmulDIBGZDZyPPE4anr/oQ/Ha7D2+zNqFwdgNHR6MjJdemBkPn4qfaF9Jc7hRvVhrMI6mjBWA9lgDINGDFclkaKq6FLhcdlxXK1KLxi/6YEzY5XA2DneP34C5bDkVp8bmRItbJbxNIz5UxDVvuJAAISnu+Y4NQ/J7bbn/3C/ISczPub4fbH4zOM7SR2Ik/Nj8N4WxhIObtdmFPN0wVkd8awnaHmT/CGbcOu1azYaYFFWKKA8rvHngfXchJGPHg44OyNhbIm8CpVBgQCMh3th8OsnBlPONneHNNpxZy8ZoxPBL0cgkDH+eOyQ4sqV+fLYQQbjCYz3pqoBtc+aeKczl1WrpH0F+iMuoUyWUJJ7DUwdP1e41w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27-Feb-26 2:10 AM, Joshua Hahn wrote:
> 
> Hello Bharata, I hope you are doing well! Thank you for the series.
> I saw the numbers and they look great. I'm hoping to do some more testing
> myself as well : -) I'm also going through the series as well!!

Thanks Joshua for looking at the patchset and for your testing offer!

> 
>> +	if (nr_succeeded) {
> 
> The single-folio case, migrate_misplaced_folio, has a guard here to
> check that the function performs more than just a migration, but a promotion.
> Specifically, it checks that the folio's node is not toptier, and the
> destination node is toptier. Should that also be included here?

Ideally yes, but right now the batch variant gets called only for promotion case.

> 
> When this is called in kmigrated_walk_zone in the next patch, there is no
> check to make sure that the folios are actually on a lower tier, and the
> destination is on a higher tier. Maybe I'm missing something? But it
> wasn't entirely obvious to me that the migration is always a promotion.

Firstly the hotness is tracked only for lower tier pages. pghot_record_access()
ensures this.

Next, there is one kmigrated thread for each lower tier node and it looks at its
own PFNs. This ensures that only lower tier PFNs are considered for promotion.

> 
> I want to note that we're also skipping the count_memcg_events, which
> I understand is much harder to do here becuase each folio might belong
> to a different memcg. Ying also noted this in his reply from v1 [1]
> but I don't think it ever got addressed.

Ying's suggestion about unifying single and batch versions of misplaced
migration routines is in my TODO list. memcg accounting looks harder, I will
give it a try.

Regards,
Bharata.


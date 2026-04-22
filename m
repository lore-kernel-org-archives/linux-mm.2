Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23AEF94CC7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 04:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C936B0088; Wed, 22 Apr 2026 00:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDD46B008A; Wed, 22 Apr 2026 00:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC396B008C; Wed, 22 Apr 2026 00:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA7F36B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:16:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0F9913C5F9
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:16:26 +0000 (UTC)
X-FDA: 84684879972.01.E46FDE3
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	by imf30.hostedemail.com (Postfix) with ESMTP id B074D80008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:16:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1m7xd6+5;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.198.4 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776831383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llMyywFH5yFDBxwR1EoNL+lmV0vnAKlWBctyieKZ578=;
	b=nmJP7oLAHTT849axMDi4ttzsjTV8o76Pn5OXqSw/azqvv0+qodksqdSm8DXc106nLIXm0/
	BpDe1ElfX5J/ijsGajTURTtdiFTgnQViRPqHjdj/bCWIn+G/s815FLZcQwgjNaA1iEtdBh
	3kOBK3pnueLpu3NaL+Eba6MoARDu0fw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1m7xd6+5;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.198.4 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776831383; a=rsa-sha256;
	cv=pass;
	b=xU/zwbLbJPtmCpt8+4vRS1K8d2AcOYBM0jXcfPa3QxJm856IH6a8KxBazX6TSI92J+mmrb
	IGs7zzc00ITaz2uanEYGEMxAThGBR05GJ9EZBCNwh04rwi6Kjprv81yzDscuiOu9Js9iCz
	JNx4QEQBrqEePCloO5Yx2hzbNotZiMg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sLV73XDmLZntfC9teWKfEI+wl8WWwXTZpK8iPmjDqVs7sFDHA4qKwE47F43eeyy9ZQ+54WZwa2sl0fAzdhKOOyD1yZ0KfsYegvTfWPGUfjxaX60Osmjv/hEeCXaLRufGr3fZvihuRCPV7AOu7SHf2iwsqWm88VkjN6+avI9FjuT13zk0s/ShHjrkkLOpRvbcUdoNO6hbx2VifURztFldTDm5NYuICx3Re4xN5NpfNu7tdmPS3I7uy5UKo8m91EO0QGF3pY2zZ8CyT1X0bdGw7Zv+9YDLBO9m4iiXA3sU3m8to5ST6Kvc4drFnKD8Vz08x0TjRCtPDAOi9bocg1mlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llMyywFH5yFDBxwR1EoNL+lmV0vnAKlWBctyieKZ578=;
 b=j9yAs1I834wdt61rOLwJjgG3awPPIJuKim2a4WFvnfN/TbisXez+/xQcqpTnlXpKUPVWu3QyOjZ1Z+xU0cY8/YjxmIhrtKGP3vlkTJnKesMnULuB9SiRf2PszjJK2NriUwq2VbQdhw5laU0O71qgHYTcVpePFvFmvbxtDDRQ3yIuE+xzLiIp+ne20EFnOlNlU8sngVoBQ8InJmBjPn3oLQFbwFjUWCMFYF/WXXQN0lkUnTucOGU7rSGStWVfUX4m3a4LaQRKMU2mgkQPw9RX/qdIciCvTLZCRtc/hlmQIsWfXrKYQ1y6uhzIzg53Z4JTAeImCetSEnz0EWhWEX1osA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llMyywFH5yFDBxwR1EoNL+lmV0vnAKlWBctyieKZ578=;
 b=1m7xd6+5VIQEKIm0nnccIQt3h3hZDeXR+5/DsJOSLKhZMjvuNiV/vffEBC+FXnO2wLLGTwQZGjbMP3ByeyXOn39Zc+8pbH1IxnYKG7nm5RmcXOjhvAFFGmou+dvFyIg2PyfORjLVjNVnSNRW7N2bbHZbhoc6ko3bQ5N5HYcDYPw=
Received: from SJ0PR03CA0099.namprd03.prod.outlook.com (2603:10b6:a03:333::14)
 by IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 04:16:16 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:a03:333:cafe::97) by SJ0PR03CA0099.outlook.office365.com
 (2603:10b6:a03:333::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 04:16:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Wed, 22 Apr 2026 04:16:15 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Apr
 2026 23:16:11 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Apr
 2026 23:16:11 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Apr 2026 23:16:04 -0500
Message-ID: <30f47bd5-68a2-4be5-a4be-d4b8801de810@amd.com>
Date: Wed, 22 Apr 2026 09:45:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
To: Donet Tom <donettom@linux.ibm.com>, Gregory Price <gourry@gourry.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
 <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
 <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
 <bed91b49-4053-4d9a-a6cf-6d3a4654fbc3@amd.com>
 <aehCjOtPtt_wrQlv@gourry-fedora-PF4VCD3F>
 <45b93560-acdb-4552-bac5-bd085d778085@linux.ibm.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <45b93560-acdb-4552-bac5-bd085d778085@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: f0358eaf-db13-431a-12a4-08dea025e591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AMX4mW4EVIzzM1p+UHV87uHYwY9iFVGfOC3+DHLT36qjdHEE7THTlAu2s9z4pZasceBmgO7G1tI+Mn9TcuXItPS4SC3Ka4pLm+VTj1sEb8ICeUWUBGEDoHValdx3atCsEomaV5JcqoNuYbU42M3e57S7FWqtWIIRcT6HM3DER+Bi4O0a+4hg9UhQq+/lmRSNBfemCiVONGOJoYw2Uu7ztxkFvlZ8B+HmKQ7uRJKCxSzphikqur4rBVCIs0to74vpNMNTKKT01oL9Dx8RKwsZnFA1M7WLFA032gVRf2RnpS85u2OYLbmRaBGw3u1CSmXCRIomYs+fAdloj6vBYJlPqZ5vbgVCAe6NfJpP7M+EMHiw1sHiFKzm29Mu3oPYeqbJV+q27fMAn1nG0hb8O4B8IVlxXdUExtC1WJwt45VVhyyyac7H93aTa2F9DHQSBFvJMQFRpNonPzPE4Yfbo382lVdHFCTZ/IgPFz9cSXW5RMtG6ZIrTzeLtKWsXnbNsTgWICITUCeoUBql7is87XJE4HUikauXKkQNEiLhpl02iTri0/gts52Ts+dKPQQYrAcD4FIw7XwjJJ5U12wrxcNeLYK64vBRu+yIDBNdf9ft4HBNp5gVT5GfibZ+ZA6IT8WCBBWrbhAF/tTgl/fOTOIocp9BN4yu5l6ibO6txz1LWch0l+9jTFaepARK9Ec8VWH8i5Ee4ZRfg7cairfJXRGe2xqqgDOPmOEXawtIF0q8+2ThjCSzeRLV6ILEV1qRcT7z62S7wT5zm/kMtys60qaWFw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aCKiY7inbJKtki2ssMMOFZukvQ5K5VOptDDwwwrKiN8ArGqn4cnCP6AoOjdTc8HRKDM3cBJd+DVlR3S4K6PyLJYwN+IMMtg4lhYYDzxhi6XmYgZGkSXssU851M7WsoMAvJjuWtNPzDvEG7iNyP4dFu6LuU+mcf14ac1X+uW43ep6KPWkjv5yJB9L6dcV0iPYniPmHpAzgSwNNGTFLmqnYNvmRJSZZam1tyu2KNAQoNEcBQfHcyByVzVcjexr8OADaAq9mkamqf9JS1RKWt79OJwMDEHoQq/g5xIgkJK5ulW6kPMQSb+yykipf+nvBdW5cCmqX7D3TinQK8gNeRRYdd2Pm6QNn4BJaAqB0eJXe2ksREboHgMbIv20apre+liI6KCnG2XkyeK61sT0mGLqwUirv5NgjligUI4SPfHhDyOu0oZa8hJJ3y5UERhPiizp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 04:16:15.8120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0358eaf-db13-431a-12a4-08dea025e591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B074D80008
X-Stat-Signature: dfpyu5q9h7iwame74q7iwarhkncikw6u
X-Rspam-User: 
X-HE-Tag: 1776831383-813857
X-HE-Meta: U2FsdGVkX1+e7Y/9Sx+ptWq0bgRqWccqa+kNAe3rCRjyo8iCsWDJw0rgdhBhiZgD9HMVxkV0ooKJZsE3j5BRwUuIJtMKTf+1Y2PiS/bnVG1OT6WeFA1V3Cz4qfAvPwuVPcKTjV9gKzX+n/1gM34rkOU9lzFU/6ZEpJ4AZKSRIyCSlfchsJBaxynSnzyQSVbwPA8Ee1CcS4mzG0y6GOBt4V9QnGxWjDf3ubSC7umVxO/M/tEBdHb1dc42+yPHj8nSKzD07OUxcl6mec7PuiEMm4U3nuLTib14++oR5qI66xy/q5oMyLeqMlAI7BXVGfEF2m1Dpa2UeKaDVrnljAyznD0kQQCgUzJguyzd6HkNB4HJSXHy2W6KokiwThLoDxGWBYtfcY6ca8A+FUP1PvwuSnQP0b6Y2A964dR1yK0iExdDhN5cnsbrdKMkhoW8Ic0TgOV/6S9ZDuGLTbOohtqOInuP2Dnk3/yMZMrdxv+1uwz8jQi3Bc3iJPTV3k3N4ta5rLTEttOyWHYFAV+qKQ672WQERQ1SiBX6m6Feh7hi6B+ISVCIQg07b0BbAA2UouYbxRJwzYKkcA10zBzfmscuwy3Fu9LvEKeS8c/4bwwDcPlLTQ/4V7SYXBHAT0n5qeSZCUozaj97PJ7LS7feIzqwM0DIXqDfG7qhdPsTNvMvaRfpsWy/xdBGSEfwWN/m+OacroNZpyI1i2BRc+Zgj0iaKlx8g3QybV7joMlUNw16py473IzxVSIGTAyrEHSyuT3pokk2H8uU5e1NL6arFLbphU8mTgjulC2/cCOfazcZBEpKdXTHWAWjQ/akzcbi6wWIUO2PRTNZ/3zYCAoxiDDEW3Wd0FMHLcU77WKTyWeZo8vITirbQfBJ0cvJ2/kXR+rrv9LkN3o+YoSctDtRuJJXX/jG6FStfwhmQDvn29rsqdfS2ObmZhIyPtc0y2bhGfnFRl2T4N2G7fG0iqsh/dg
 HfC+q2uv
 jSQfl2cDVoH/gnBAj6OW5OtoXKZ7erBRJvpEjllKjusZg9oMbf8bHNSZmDtsV9Lcomp1lTd9ep1PDxCHNYZthFlVLaoFLwNBD7kEg223rbYQsDRAKGZkGSwOmEMj8wutn1STQIbUnamAWyVE4Jy1H377uUMpzcUn6Uvx4WTgkWxdIWLtLDtSfSllPCA5Y1s+r0Mwti+EXtKXlYiHt4/1HffdBZXoR1zAvbuKd817TVC+N1i5miRQfP8RsrVsq5efg010/y/7p9GitHSxgtEOTsI8rndHEqHU/m28nJT9rjMyeJ+TGQzZlwaKbi0LY/M2cf0LpdCLuANWWS95JvCdS8H4dkNm8pXK8nOgUlpPloz5rL4BdmQF2GOdewcu7xiwSErK5D7a/1hhUls9X52wWXAOK8QAA+2d1lzycwQOU2VhjtmHB1T7o8l6jWFDIRMqoZqE9k9TtS4XDxo3YX0YxbVTtr/ztz5/sM5Rz4VZuIfuxZS3gg+CKwzgMybKXatKZiZGAjZqr2N1H+ahyetmuneOOPcUDp2WrVzmapqTvdo0AEMPwetcz4WNQUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22-Apr-26 9:34 AM, Donet Tom wrote:
> Hi Gregory
> 
> On 4/22/26 9:07 AM, Gregory Price wrote:
>> On Wed, Apr 22, 2026 at 08:56:59AM +0530, Bharata B Rao wrote:
>>> On 21-Apr-26 9:35 PM, Gregory Price wrote:
>>>> On Tue, Apr 21, 2026 at 08:55:02PM +0530, Donet Tom wrote:
>>>>>> +/**
>>>>>> + * migrate_misplaced_folios_batch() - Batch variant of
>>>>>> migrate_misplaced_folio
>>>>>> + * Attempts to migrate a folio list to the specified destination.
>>>>>> + * @folio_list: Isolated list of folios to be batch-migrated.
>>>>>> + * @node: The NUMA node ID to where the folios should be migrated.
>>>>>> + *
>>>>>> + * Caller is expected to have isolated the folios by calling
>>>>>> + * migrate_misplaced_folio_prepare(), which will result in an
>>>>>> + * elevated reference count on the folio. All the isolated folios
>>>>>> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
>>>>>> + * stat can be attributed correctly to the memcg.
>>> ^ This is the expectation from the caller. pghot caller ensures this.
>>> I could add a debug check in this routine to verify if that is indeed so.
>>>
>> Wondering if the interface name should somehow reflect this as well, to
>> make it a bit clearer.
> 
> I agree—this would make the interface clearer.

Sure, will change.

Regards,
Bharata.


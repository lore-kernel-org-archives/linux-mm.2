Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDE6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979746B0088; Thu,  9 Jul 2026 03:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902F56B008A; Thu,  9 Jul 2026 03:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3296B008C; Thu,  9 Jul 2026 03:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 493A66B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:17:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC00FA0409
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:09 +0000 (UTC)
X-FDA: 84968381778.29.18BA015
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8446DA0008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GfTuUw/m";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783581426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6hm6HhF4Yc8zEixV39mMQyrwyGc3XgnCz2mI/SLk9A=;
	b=Qw4MtZJqsVWjkUpAbmfzq77TRwKST2D70SCVTTZNioIIgZinzV2QeiG/qCIiQ26luCbWIL
	p5efKMuX/0ereMtkmeLh0EkvimD6QdQHmrMwHe1YyFPzwnOeKfn3z1sTpTNbnfJBRE3YHu
	Lyv0VxalXFM7+nomxtx7Jg9+DrlLPyA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GfTuUw/m";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783581426;
	b=QdQZGXjY26V5NKsll+JvcOGbGQO+tum6Q13bEKlwpYiuiSRqjCU4apEEVFDGNVWR0Z/bue
	lLQC0Op161rO3q59EfaACkQdOSSb5bQ+9QYyo2WkuHhZMrWBRHoJEFjiB5BRLhtPU+M4dk
	p5NUswA7gyo5b9cTRw77TcY7X/r1wWU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bj7fx9oWUx2Hmg7zB3UeW3lJV3nBUbCW8Les8EtTQD4190lLinb6pl5Df5qq29kaZOuE/f/+bkwvrV2X0O7AZDpcUA8LXIf84e8moUdN80MLJxIWNNwkoyyLL2/ujf6pmJdYbIqm4ZOB3ZEb+FxAHCP/UixLmLCn6CKjUtAA+6htNgfd0UxxIPw4WQ9r14RWBdWDA2M0qhTI5MmFyvb6xXL9wm4UibaE6gWsugkhiOvl1cp6t2yAlCLm5PilAD1sAivHmPTxtyKuAlRyEcri4p/taTA8jbI7NbqZd3yVWXVg1c4FcUbK+0hBRqOMm8rTfoy7Z1vrCbEJbIGvvR0Zxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6hm6HhF4Yc8zEixV39mMQyrwyGc3XgnCz2mI/SLk9A=;
 b=jjPqtVPM1N9cB0MMIEpbuYY4H2PhAmwAq0nE0+OxjS6U2cMhPSUgnLZs6KHmF8ETettlZVkfk2c5NxHzsFkz6LsoTB3Dmf16EgnsHr4kKMd4ajifjqV3vNy9emG+pyT2aMGeFcWd1CA+lCV3ELGx3B8tgKFhUk8yConb8PGsaX9RLa0sPu0GJ+YvA9cIQT0y+3G29hhokWU12845lGknH0jmx727galcctlGpCs1+179GSE3kPoEbuqnQKRzzHe9IHRjgJ/fTLki7QKDrUUNg41QCOHzENJ9gm0Eg/InyaMrA6oPnL4DUmy/kBCoEhJW4QcxTsTG6GwF1aWDGV5t7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6hm6HhF4Yc8zEixV39mMQyrwyGc3XgnCz2mI/SLk9A=;
 b=GfTuUw/mWB+G823Y9xFuuua9Ybyh4i5tuB3gib4RSC5LuHhbepRb+2w3XbW+cS37nITV+mqq61EGlxYeScVNUW/S1A87FnTDOlUQrDFw4/KEeqbYHYnUqLLzJpbz9c262fu7CZJUbbFW8zthq3IkQATKItTw9w0csQM5kuBg3+c=
Received: from SJ0PR03CA0041.namprd03.prod.outlook.com (2603:10b6:a03:33e::16)
 by CYYPR12MB9014.namprd12.prod.outlook.com (2603:10b6:930:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Thu, 9 Jul 2026
 07:16:56 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::3c) by SJ0PR03CA0041.outlook.office365.com
 (2603:10b6:a03:33e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Thu, 9
 Jul 2026 07:16:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 9 Jul 2026 07:16:55 +0000
Received: from [10.128.115.58] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 9 Jul
 2026 02:16:48 -0500
Message-ID: <d7cac057-c270-4b3d-bc9b-c3503c5b6f50@amd.com>
Date: Thu, 9 Jul 2026 12:46:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <chrisl@kernel.org>,
	<kasong@tencent.com>, <hughd@google.com>, <liam@infradead.org>
CC: <riel@surriel.com>, <vbabka@kernel.org>, <harry@kernel.org>,
	<jannh@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<qi.zheng@linux.dev>, <shakeel.butt@linux.dev>, <baohua@kernel.org>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
	<youngjun.park@lge.com>, <baolin.wang@linux.alibaba.com>, <pfalcato@suse.de>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260526063635.61721-3-dev.jain@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|CYYPR12MB9014:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a26bca-9e56-44ac-f9c4-08dedd8a0ef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|23010399003|4143699003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	7LF8OacmVtfd7SOEPR8QsPg6kCdkuM7wsPHmeD0VekR8qlh0XwURiA/iXTyb4tI/iHrM5KiEfrJmSz/fkBKmxVfxnvys8UY6iaTUDurI5ylMNNS1RHir2UjfyMhVuVUEpOK+iiTIKWQ9uMUTiKqe1J+wm/PPUv+OP1g9l8cmBuL0RxyGr7D+Yb7Zn6E4Cy4XdYOCYaLeNclh6qDh9WBqoiNTOQyGdMhB12C86FolNrBE8kU8tHwso3sePNaLSaX41SScPDFJyVuCpmOXHCFVRdVowjdIz7ZbS3DbMVX2hk6DqZPB3oKUt1k9NgyhTsU3vUl0QlVO+3+s4N9+BJgOQ+H6eyscT9odGtPBS7Vi6CJqqGMebSVXemUZ4+RCSZO1APSfupsI6wgnOrTYbMtLSc9LXYFIBECi6k69Mxird7iLtgzuuXfVAJAqHNMrie83Mvv0Mp+Ti9e6/kJVx7Y96Rq0IPZBF4MFboWzRWqDjq1sBEwi2B8EMt8jAxzJdjy9R3SsN+fTR/DWhBVSJzmT3e6onYrLu2jZWm6O3aOofroSc+O9+t1bUfNPVkIegFnXO9pBMCR2X8HBeT9oI5xuLdPmZSrIed+1c4rorI9ZWXUYWMWwvindW9YvSuwHetCAnwypVJzEuxRkNJcESwWxAPfxr42IiuTHt5fiuNLDwBpNNEqFNvFIq6NZ/I3MP8EkepPWg/dkgAt2JPMileOPCw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(23010399003)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	N0RDy+z9eY2d5J3BnFRvoD61yUc0zYO/XC/CFoEZRHpS/j+/pT/I6MbAZPInxhWa0iU5gTxnZg4WBs53S5XG4WGYkqY01TI+Afj77lLY+iJ0UcmMGv2HjcQQLBZbMZBqMKW9OqZ+3/bomePYwu91Kg1Wz5L682VRthqhdGICqT2B4wX3/ZvST1p0TYCxuqZh5mDog6hcIqIFWQLDmsEohssHVh85ICTzz1iGLcUtkldVLOzrIRjdRMic7JP2egRaVqKO6JCI6rAPdYH80071DRKE5+kNBpkTD7r/xK1U2rX2CRYVPYsd6rEj4aTmfP6+lyGXLUBmZ94K02Ea8JFlKJpx5fAtgLXjRSbFJmVAInmRleREo7D5UrRr4ScoSuN8oByVgsa338YPI8GgoysU0OrT/faMtEePOITVceSX4A0sZcHl2w4SU0Fe/i5cqse3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 07:16:55.8185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a26bca-9e56-44ac-f9c4-08dedd8a0ef6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9014
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8446DA0008
X-Stat-Signature: jrgt1dprfhcja4qdgwneoim8suaz4c8m
X-HE-Tag: 1783581426-165904
X-HE-Meta: U2FsdGVkX1++3goCymhV4lXgmdYZbno+PaS4wetbf8Q27SNC+VKhVFSbTuTlM8TOMH9J1LrAnnimsQC2zvvstVRv42YN1wZmpRybbpTAYABa+YcJmvT4MQwJ0wajV+gCL2xVbAWg0ACProivyWEKRilcRuoeGukk/rTy9p56T1wx2m1NydQjlkZs0jTahsIFUK4asGM5mkgUAUcHNBQ7tJPIcMSPsLMaCxm1mNJbYbsv/56MgVmHOWIMufQgJjX4KwUKRJ0d8K8XWo2yY/a06OLTXiiMHIbNkkjYPvuQeFLalo1ef5IJKhYuA2DaGNcOtfP4twRcwM9aV4jxyusmuh4OpMB3LfOCtXhs+roUfWlX0ql9xaYIe3aT1nh3Gm4PKP/0rwbEZlSxzA/jzPX6EOvTwm9E42DxBn7rGrqn6x3DzdJDLsBPk+PFBmU9D69lftvbRvu55wx4GQ9iwDZP8C2G49m1HpUsR0qmmm4XVUQCK4TIZAxpQ/Elf4xQf0HINTNW/Zw9iILCzGVWicNR4in1fZAujHaN2CX4r2BQ0DNab7EWVcNNGoFqViaD3vAQyGKta/qJcWzSEktkFeUJb13/4Mky2OHNyCfXRNA9oEOKlVmYC5WNYLsgMhabuJj6Hzh3hRC/0p7FZaJxZ2KKf15W+AkBJmFLuIwhI5IiXeDlawYa5xlQVaFAFkaesaRHf/fWFBFtNaYSxtw16VY92yykS2OM29NHse9/aBXPQWTJB/48wiS2FKPYRgSUTR79rOkZn6J0aroHqe4nZ7DsSaidcylOLOPZrGqGrpQrys/Jyb6Pp8uapwl9PAzEoWJDb63h9SXVsiDx7+knAUwrsT499vuOTJXn/5U7ByzaMCO6LZwzdGBviYTlO2tTjc3Zj7xgGIe2paLjkxD+vpLs3JqTa5sDAAbF+oWA2gFrOhpFmazMyyMTQ8LvadNCWW4dCOQuhorRkgy6zhtbDOh
 NhU4am6t
 tnyKmrjdahUIq45MXs2/XkZbs3dFT2XjHaqGbK4lEi+5gwXXMzk+1ci1F7/PEeMlLPhli2/8AeMO3gMQiHeE6wMybaVCHsd8Kp/Pd+n911sNDVBFFxUBQpPCXLNjJFmX++yfFCFLzK3Q1cX5vgjUB0Bnhhudt39o8I7s7EGOLXeAnd77do2pIEiMX6UbvupjJtSXeuKDtQhBg4auOaL2auqNQc0KQfT+oZkdGpNB9b1W/Kx+ZANsd4eXrR9Vc69cJyvwS2p7ijUhU3zNO7+uo2rgUgbq8qaDdI7VOctmdWG4T57Cl/CqIQU3xeIu7oPlwuukgHTL7yiV9kkIC/NrJ2BpKeeMY1+1XYQAqQV6VDizR2Jb7MvaqC1TqL2UR5f2Lq0/Arn4vzlvR/r82Z5NVNkiBfCSE/YHnlD/8zF6Ujeva3/t10zmgjLEpO1BsfhkCM199jFRDdN8xyAeLKqYxA09jBn8NrIXKuogYYVjp80xQV8HIIemnSN1WV6IiCEEO7Smet2OFEJ4e8hcXwVUjktxtDhlsBKZOjUkwXkLFwmB4Bhp1NCoKlLv2EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/26/2026 12:06 PM, Dev Jain wrote:
> Simplify try_to_unmap_one by separating out the hugetlb parts into
> try_to_unmap_hugetlb_one.

[snip]

> @@ -2393,7 +2431,8 @@ static int folio_not_mapped(struct folio *folio)
>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>  {
>  	struct rmap_walk_control rwc = {
> -		.rmap_one = try_to_unmap_one,
> +		.rmap_one = folio_test_hugetlb(folio) ?
> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>  		.arg = (void *)flags,
>  		.done = folio_not_mapped,
>  		.anon_lock = folio_lock_anon_vma_read,

Now that try_to_unmap_hugetlb_one() is split out, should we wrap it in
#ifdef CONFIG_HUGETLB_PAGE and a stub function for !HUGETLB case?

I'm working on similar change for try_to_migrate() and had this thought.
I think either is fine, but wanted to check the preference.

Thanks,
Shivank

